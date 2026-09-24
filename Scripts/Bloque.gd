extends StaticBody2D

@export var valor_puntos: int = 10
@export var resistencia: int = 1
@export var alpha_minimo: float = 0.25 # que tan transparente puede llegar a estar antes de destruirse

var golpes_recibidos: int = 0

func _ready() -> void:
	add_to_group("bloques")

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola"):
		golpes_recibidos += 1
		PuntajeGlobal.agregar_puntos(valor_puntos)

		if golpes_recibidos >= resistencia:
			destruir()
		else:
			actualizar_visual()

func actualizar_visual() -> void:
	var vida_restante: float = 1.0 - (float(golpes_recibidos) / float(resistencia))
	modulate.a = clamp(vida_restante, alpha_minimo, 1.0)

func destruir() -> void:
	queue_free()
