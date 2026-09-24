extends CharacterBody2D

const VELOCIDAD = 400.0
var altura: float
var posicion_inicial: Vector2

var escala_original: Vector2
var agrandado: bool = false

func _ready():
	add_to_group("barra")
	altura = global_position.y
	posicion_inicial = global_position
	escala_original = scale

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

# --- Efecto de agrandar la barra ---
func agrandar(multiplicador: float, duracion: float) -> void:
	# Si ya está agrandada, solo reinicia el temporizador de duración
	scale.x = escala_original.x * multiplicador
	agrandado = true

	await get_tree().create_timer(duracion).timeout

	# Solo vuelve al tamaño normal si nadie más volvió a agrandar mientras tanto
	if agrandado:
		scale = escala_original
		agrandado = false
