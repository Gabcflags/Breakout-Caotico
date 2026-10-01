extends RigidBody2D

@export var velocidad: float = 400.0
@export_range(5.0, 45.0) var angulo_minimo_grados: float = 20.0

var velocidad_actual: float
var efecto_velocidad_activo: bool = false

func _ready() -> void:
	add_to_group("bola_extra")

	gravity_scale = 0.0
	linear_damp = 0.0
	angular_damp = 0.0
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	contact_monitor = true
	max_contacts_reported = 4

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	velocidad_actual = velocidad

func _on_body_entered(_body: Node) -> void:
	GestorSonidos.reproducir_rebote()

func _physics_process(_delta: float) -> void:
	if linear_velocity.length() > 0:
		var dir: Vector2 = _corregir_angulo(linear_velocity.normalized())
		linear_velocity = dir * velocidad_actual

func _corregir_angulo(dir: Vector2) -> Vector2:
	var min_y: float = sin(deg_to_rad(angulo_minimo_grados))
	if absf(dir.y) >= min_y:
		return dir
	var signo_y: float = signf(dir.y)
	if signo_y == 0.0:
		signo_y = 1.0 if randf() < 0.5 else -1.0
	var signo_x: float = signf(dir.x)
	if signo_x == 0.0:
		signo_x = 1.0
	return Vector2(signo_x * sqrt(1.0 - min_y * min_y), signo_y * min_y)
