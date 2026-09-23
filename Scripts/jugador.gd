extends CharacterBody2D

const VELOCIDAD = 400.0
var altura: float
var posicion_inicial: Vector2

func _ready():
	add_to_group("barra")
	altura = global_position.y
	posicion_inicial = global_position

func _physics_process(_delta):
	var direccion: float = Input.get_axis("ui_left", "ui_right")
	velocity.y = 0

	if direccion != 0:
		velocity.x = direccion * VELOCIDAD
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)

	move_and_slide()
	global_position.y = altura

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.direction.y *= -1

func reiniciar_posicion() -> void:
	global_position = posicion_inicial
	velocity = Vector2.ZERO

###hola
