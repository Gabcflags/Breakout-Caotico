# BolaExtra.gd
extends RigidBody2D

@export var velocidad: float = 400.0

var velocidad_actual: float
var efecto_velocidad_activo: bool = false

func _ready() -> void:
	# Únicamente en el grupo de bolas extra
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
		linear_velocity = linear_velocity.normalized() * velocidad_actual
