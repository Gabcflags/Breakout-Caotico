# BloqueMultibola.gd
extends StaticBody2D

@export var valor_puntos: int = 20
@export var resistencia: int = 1
@export var cantidad_bolas_extra: int = 2
@export var escena_bola_extra: PackedScene # <--- Asigna BolaExtra.tscn en el Inspector

var golpes_recibidos: int = 0

func _ready() -> void:
	add_to_group("bloque_multibola")

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola") or body.is_in_group("bola_extra"):
		golpes_recibidos += 1
		
		# Si este bloque es un BloqueMultibola, multiplicamos a partir de la bola que chocó
		if has_method("multiplicar_bola"):
			multiplicar_bola(body)

		if golpes_recibidos >= resistencia:
			PuntajeGlobal.agregar_puntos(valor_puntos)
			destruir()

func multiplicar_bola(bola_origen: Node2D) -> void:
	if not escena_bola_extra:
		print("¡ERROR: Falta asignar escena_bola_extra en el Inspector!")
		return

	for i in range(cantidad_bolas_extra):
		var nueva_bola = escena_bola_extra.instantiate()
		
		# Copiamos la posición actual
		nueva_bola.global_position = bola_origen.global_position
		
		# Calculamos el desvío de trayectoria basado en la dirección de la bola que chocó
		var velocidad_base = 400.0
		if "velocidad_actual" in bola_origen:
			velocidad_base = bola_origen.velocidad_actual
		
		var direccion_base = Vector2.UP
		if "linear_velocity" in bola_origen and bola_origen.linear_velocity.length() > 0:
			direccion_base = bola_origen.linear_velocity.normalized()

		var angulo_desvio = randf_range(-0.6, 0.6)
		nueva_bola.linear_velocity = direccion_base.rotated(angulo_desvio) * velocidad_base

		# La agregamos de forma diferida para evitar errores de física
		bola_origen.get_parent().call_deferred("add_child", nueva_bola)

func destruir() -> void:
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	if has_node("AreaDeteccion/CollisionShape2D"):
		$AreaDeteccion/CollisionShape2D.set_deferred("disabled", true)
	if has_node("Sprite2D"):
		$Sprite2D.visible = false
	
	if has_node("Particulas"):
		$Particulas.global_position = global_position
		$Particulas.emitting = true
		await get_tree().create_timer($Particulas.lifetime).timeout
		
	queue_free()
	
	var generador = get_tree().get_first_node_in_group("generador_bloques")
	if generador and generador.has_method("verificar_fin_de_nivel"):
		generador.verificar_fin_de_nivel()
