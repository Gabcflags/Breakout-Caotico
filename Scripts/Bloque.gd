extends StaticBody2D

@export var puntos: int = 10
@export var resistencia: int = 1

var golpes_recibidos: int = 0

func _ready() -> void:
	add_to_group("bloques")

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola"):
		golpes_recibidos += 1
		if golpes_recibidos >= resistencia:
			destruir()

func destruir() -> void:
	queue_free()
