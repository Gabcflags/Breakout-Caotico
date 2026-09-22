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
@export var velocidad_max: float = 400.0
@export var aceleracion: float = 2500.0   # qué tan rápido llega a velocidad máxima
@export var friccion: float = 3000.0      # qué tan rápido frena al soltar (mayor = más responsive)

var altura: float

func _ready():
    altura = global_position.y

func _physics_process(delta: float) -> void:
    var direccion: float = Input.get_axis("ui_left", "ui_right")

    if direccion != 0:
        velocity.x = move_toward(velocity.x, direccion * velocidad_max, aceleracion * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, friccion * delta)

    move_and_slide()
    global_position.y = altura

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.direction.y *= -1

func reiniciar_posicion() -> void:
	global_position = posicion_inicial
	velocity = Vector2.ZERO
    body.direction.y *= -1
