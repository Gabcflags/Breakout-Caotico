extends Node2D

var puntaje = 0



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass


func _on_area_arriba_body_entered(body: Node2D) -> void:
	
	body.direction.y *= -1


func _on_area_izquierda_body_entered(body: Node2D) -> void:
		body.direction.x *= -1


func _on_area_derecha_body_entered(body: Node2D) -> void:
	body.direction.x *= -1
	
	
	

func _on_area_abajo_body_entered(body: Node2D) -> void:
	body.queue.free()
	
