extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Verificamos si el objeto que entró tiene la función "perder_vida" (es nuestra bola)
	if body.has_method("perder_vida"):
		body.perder_vida()
