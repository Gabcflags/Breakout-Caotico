extends StaticBody2D

@export var valor_puntos: int = 15
@export var resistencia: int = 2
@export var multiplicador_velocidad: float = 3.25
@export var duracion_efecto: float = 10.0
@export var alpha_minimo: float = 0.25 # que tan transparente puede llegar a estar antes de destruirse
@onready var particulas: CPUParticles2D = $Particulas

var golpes_recibidos: int = 0

func _ready() -> void:
	add_to_group("bloque_especial")

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola"):
		golpes_recibidos += 1

		if golpes_recibidos >= resistencia:
			PuntajeGlobal.agregar_puntos(valor_puntos)
			aplicar_efecto_velocidad(body)
			destruir()
		else:
			actualizar_visual()

func actualizar_visual() -> void:
	var vida_restante: float = 1.0 - (float(golpes_recibidos) / float(resistencia))
	modulate.a = clamp(vida_restante, alpha_minimo, 1.0)

func aplicar_efecto_velocidad(bola: Node2D) -> void:
	if bola.has_method("aplicar_multiplicador_velocidad"):
		bola.aplicar_multiplicador_velocidad(multiplicador_velocidad, duracion_efecto)
		
func destruir() -> void:

	if has_node("Sprite2D"):
		$Sprite2D.visible = false
	particulas.emitting = true
	await get_tree().create_timer(particulas.lifetime).timeout
	queue_free()
