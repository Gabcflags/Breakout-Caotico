extends RigidBody2D

@export var velocidad: float = 400.0
@export var offset: Vector2 = Vector2(0, -20)
@export var etiqueta_vidas: Label


var barra: Node2D
var lanzada: bool = false
var vidas: int = 3

var velocidad_actual: float
var efecto_velocidad_activo: bool = false

func _ready():
	add_to_group("bola")
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC

	# Evita que a velocidades altas (power-up de velocidad) la bola
	# atraviese paredes/bloques sin que se detecte la colisión.
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE

	velocidad_actual = velocidad

	barra = get_tree().get_first_node_in_group("barra")

	if not barra:
		print("¡ERROR: No se encontró ningún nodo en el grupo 'barra'!")

	_reiniciar_seguro()
	actualizar_texto_vidas()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not lanzada and barra:
		state.transform = Transform2D(0.0, barra.global_position + offset)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0

func _physics_process(_delta):
	if not lanzada:
		return
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * velocidad_actual

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
	linear_velocity = direccion.normalized() * velocidad_actual

func perder_vida() -> void:
	vidas -= 1
	actualizar_texto_vidas()

	if vidas > 0:
		call_deferred("_reiniciar_seguro")
	else:
		print("¡Juego terminado!")
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")


func _reiniciar_seguro() -> void:
	lanzada = false
	freeze = true

	if barra:
		barra.reiniciar_posicion()
		global_position = barra.global_position + offset

	rotation = 0.0
	gravity_scale = 0
	linear_damp = 0
	angular_damp = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

func actualizar_texto_vidas() -> void:
	if etiqueta_vidas:
		etiqueta_vidas.text = "Vidas: " + str(vidas)

# --- Efecto de power-up de velocidad ---
func aplicar_multiplicador_velocidad(multiplicador: float, duracion: float) -> void:
	velocidad_actual = velocidad * multiplicador
	efecto_velocidad_activo = true

	await get_tree().create_timer(duracion).timeout

	# Solo vuelve a la velocidad base si nadie volvió a aplicar el efecto mientras tanto
	if efecto_velocidad_activo:
		velocidad_actual = velocidad
		efecto_velocidad_activo = false
