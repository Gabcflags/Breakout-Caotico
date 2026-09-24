extends Node2D

@export var escena_bloque: PackedScene
@export var bloque_especial_scene: PackedScene
@export var filas: int = 5
@export var columnas: int = 8
@export var espaciado: Vector2 = Vector2(80, 30)
@export var margen_superior: float = 60.0
@export var margen_izquierdo: float = 60.0
@export_range(0.0, 1.0) var probabilidad_especial: float = 0.2

func _ready() -> void:
	generar_bloques()

func generar_bloques() -> void:
	for fila in range(filas):
		for columna in range(columnas):
			var escena_a_usar: PackedScene
			if randf() < probabilidad_especial:
				escena_a_usar = bloque_especial_scene
			else:
				escena_a_usar = escena_bloque
				
				
			var nuevo_bloque = escena_a_usar.instantiate()
			nuevo_bloque.global_position = Vector2(
				margen_izquierdo + columna * espaciado.x,
				margen_superior + fila * espaciado.y
			)
			add_child(nuevo_bloque)
