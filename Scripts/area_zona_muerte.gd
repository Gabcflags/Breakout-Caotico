extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not is_instance_valid(body):
		return

	if body.is_in_group("bola"):
		body.perder_vida()

	elif body.is_in_group("bola_extra"):
		body.queue_free()
		
