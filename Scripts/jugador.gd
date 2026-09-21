extends CharacterBody2D

const VELOCIDAD = 400.0
var altura : float
func _ready():
	altura = global_position.y
	

func _physics_process(_delta):
	
	var direccion: float = Input.get_axis("ui_left","ui_right")
	velocity.y = 0
		
	if direccion != 0:
		velocity.x = direccion * VELOCIDAD
	
	else:
		velocity.x = move_toward(velocity.x,0,VELOCIDAD)		
	

	move_and_slide()
	
	global_position.y = altura


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.direction.y *= -1
