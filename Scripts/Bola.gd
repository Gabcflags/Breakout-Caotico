extends RigidBody2D

@export var velocidad: float = 350.0
@export var offset: Vector2 = Vector2(0, -20)
@export var etiqueta_vidas: Label
@export_range(5.0, 45.0) var angulo_minimo_grados: float = 20.0

var barra: Node2D
var lanzada: bool = false
var vidas: int = 3

var velocidad_actual: float
var multiplicador_nivel: float = 1.0
var efecto_velocidad_activo: bool = false

func _ready():
	add_to_group("bola")
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC

	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE

	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)

	velocidad_actual = velocidad

	barra = get_tree().get_first_node_in_group("barra")

	if not barra:
		print("¡ERROR: No se encontró ningún nodo en el grupo 'barra'!")

	_reiniciar_seguro()
	actualizar_texto_vidas()

func _on_body_entered(_body: Node) -> void:
	if lanzada:
		GestorSonidos.reproducir_rebote()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not lanzada and barra:
		state.transform = Transform2D(0.0, barra.global_position + offset)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0

func _physics_process(_delta):
	if not lanzada:
		return
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
		PuntajeGlobal.terminar_partida()
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
		
func reiniciar_vidas(cantidad: int = 3) -> void:
	vidas = cantidad
	actualizar_texto_vidas()
	
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

func aplicar_multiplicador_velocidad(multiplicador: float, duracion: float) -> void:
	velocidad_actual = velocidad * multiplicador_nivel * multiplicador
	efecto_velocidad_activo = true

	await get_tree().create_timer(duracion).timeout

	if efecto_velocidad_activo:
		velocidad_actual = velocidad * multiplicador_nivel
		efecto_velocidad_activo = false

func preparar_siguiente_nivel(multiplicador: float) -> void:
	efecto_velocidad_activo = false
	multiplicador_nivel = multiplicador
	velocidad_actual = velocidad * multiplicador_nivel
	call_deferred("_reiniciar_seguro")
