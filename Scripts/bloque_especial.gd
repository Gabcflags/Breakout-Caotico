extends StaticBody2D

@export var valor_puntos: int = 15
@export var resistencia: int = 2
@export var multiplicador_velocidad: float = 3.25
@export var duracion_efecto: float = 10.0

var golpes_recibidos: int = 0

func _ready() -> void:
	add_to_group("bloque_especial")

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola"):
		# 1. Registrar golpe
		golpes_recibidos += 1
		
		
		aplicar_efecto_velocidad(body)
		
		
		if golpes_recibidos >= resistencia:
			PuntajeGlobal.agregar_puntos(valor_puntos)
			destruir()

func aplicar_efecto_velocidad(bola: Node2D) -> void:
	
	var velocidad_original: float = bola.linear_velocity.length()
	
	
	bola.linear_velocity *= multiplicador_velocidad
	
	print("Cambio de velocidad!")
	await get_tree().create_timer(duracion_efecto).timeout
	
	if is_instance_valid(bola):
		bola.linear_velocity = bola.linear_velocity.normalized() * velocidad_original

func destruir() -> void:
	queue_free()
