extends RigidBody2D

@export var velocidad: float = 550.0
@export var barra_path: NodePath
@export var offset: Vector2 = Vector2(0, -20)

var barra: Node2D
var lanzada: bool = false

func _ready():
	barra = get_node(barra_path)
	freeze = true
	gravity_scale = 0
	linear_damp = 0
	angular_damp = 0

func _physics_process(_delta):
	if not lanzada:
		global_position = barra.global_position + offset
		return
	
	# Fuerza la magnitud de la velocidad a ser siempre constante
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * velocidad

func _unhandled_input(event: InputEvent) -> void:
	if lanzada:
		return
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		lanzar()

func lanzar() -> void:
	lanzada = true
	freeze = false
	var angulo_grados = randf_range(-60.0, 60.0)
	var direccion = Vector2(sin(deg_to_rad(angulo_grados)), -cos(deg_to_rad(angulo_grados)))
	linear_velocity = direccion.normalized() * velocidad
