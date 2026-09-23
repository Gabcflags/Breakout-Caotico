extends Node2D

@export var escena_bloque: PackedScene
@export var filas: int = 5
@export var columnas: int = 8
@export var espaciado: Vector2 = Vector2(80, 30)
@export var margen_superior: float = 60.0
@export var margen_izquierdo: float = 60.0

func _ready() -> void:
	generar_bloques()

func generar_bloques() -> void:
	for fila in range(filas):
		for columna in range(columnas):
			var bloque = escena_bloque.instantiate()
			bloque.global_position = Vector2(
				margen_izquierdo + columna * espaciado.x,
				margen_superior + fila * espaciado.y
			)
			add_child(bloque)
