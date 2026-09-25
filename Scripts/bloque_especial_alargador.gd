extends StaticBody2D

@export var valor_puntos: int = 15
@export var resistencia: int = 1
@export var multiplicador_tamano: float = 1.6
@export var duracion_efecto: float = 10.0
@onready var particulas: CPUParticles2D = $Particulas

var golpes_recibidos: int = 0

func _ready() -> void:
	add_to_group("bloque_especial_alargador")

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola"):
		golpes_recibidos += 1

		aplicar_efecto_alargar()

		if golpes_recibidos >= resistencia:
			PuntajeGlobal.agregar_puntos(valor_puntos)
			destruir()

func aplicar_efecto_alargar() -> void:
	var barra = get_tree().get_first_node_in_group("barra")
	if barra and barra.has_method("agrandar"):
		barra.agrandar(multiplicador_tamano, duracion_efecto)

func destruir() -> void:
	
	if has_node("Sprite2D"):
		$Sprite2D.visible = false
	particulas.emitting = true
	await get_tree().create_timer(particulas.lifetime).timeout
	queue_free()
