extends Control

@onready var fondo: Sprite2D = $Background
@onready var luna: Sprite2D = $Moon

@export var fuerza_fondo := 15.0
@export var fuerza_luna := 35.0
@export var suavidad := 5.0
@export var flote_luna := 4.0
@export var rotacion_luna := 0.02

var fondo_base: Vector2
var luna_base: Vector2
var tiempo := 0.0

func _ready():
	var pantalla := get_viewport_rect().size
	var tam_fondo := fondo.texture.get_size() * fondo.scale
	var necesario := (pantalla + Vector2.ONE * fuerza_fondo * 2.0) / tam_fondo
	var factor: float = max(1.0, max(necesario.x, necesario.y))
	fondo.scale *= factor

	fondo_base = fondo.position
	luna_base = luna.position

func _process(delta):
	tiempo += delta

	var centro := get_viewport_rect().size / 2.0
	var dir := (get_viewport().get_mouse_position() - centro) / centro
	dir = dir.clamp(Vector2(-1, -1), Vector2(1, 1))

	var flotar := Vector2(0, sin(tiempo * 1.2) * flote_luna)

	var destino_fondo := fondo_base - dir * fuerza_fondo
	var destino_luna := luna_base - dir * fuerza_luna + flotar

	var t := 1.0 - exp(-suavidad * delta)
	fondo.position = fondo.position.lerp(destino_fondo, t)
	luna.position = luna.position.lerp(destino_luna, t)

	luna.rotation += delta * rotacion_luna


###hola
