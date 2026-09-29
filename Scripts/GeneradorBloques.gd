extends Node2D

@export var escena_bloque: PackedScene
@export var bloque_especial_scene: PackedScene
@export var bloque_alargador_scene: PackedScene
@export var escena_bloque_multibola: PackedScene
@export var filas: int = 5
@export var columnas: int = 8
@export var espaciado: Vector2 = Vector2(80, 30)
@export var margen_superior: float = 60.0
@export var margen_izquierdo: float = 60.0
@export_range(0.0, 1.0) var probabilidad_especial: float = 0.2
@export_range(0.0, 1.0) var probabilidad_alargador: float = 0.1
@export_range(0, 100) var probabilidad_multibola: float = 0.3

func _ready() -> void:
	add_to_group("generador_bloques")
	generar_bloques()

func generar_bloques() -> void:
	for fila in range(filas):
		for columna in range(columnas):
			var escena_a_usar: PackedScene = escena_bloque
			var tirada: float = randf()

			if tirada < probabilidad_alargador:
				escena_a_usar = bloque_alargador_scene
			elif tirada < probabilidad_alargador + probabilidad_especial:
				escena_a_usar = bloque_especial_scene
			elif tirada < probabilidad_alargador + probabilidad_especial + probabilidad_multibola:
				if escena_bloque_multibola:
					escena_a_usar = escena_bloque_multibola

			var nuevo_bloque = escena_a_usar.instantiate()
			nuevo_bloque.global_position = Vector2(
				margen_izquierdo + columna * espaciado.x,
				margen_superior + fila * espaciado.y
			)
			add_child(nuevo_bloque)
			
			
func verificar_fin_de_nivel() -> void:
	# Esperamos un fotograma para que Godot termine de remover el bloque de la memoria
	await get_tree().process_frame
	
	var bloques_restantes: int = get_tree().get_nodes_in_group("bloques").size()
	var bloque_restante_especial : int = get_tree().get_nodes_in_group("bloque_especial").size()
	var bloque_restante_alargador : int = get_tree().get_nodes_in_group("bloque_especial_alargador").size()
	var bloque_restante_multibola : int =  get_tree().get_nodes_in_group("bloque_multibola").size()
	
	
	if bloques_restantes <= 0 and bloque_restante_especial <= 0 and bloque_restante_multibola <= 0 and bloque_restante_alargador <=0:
			activar_screenshake()

func activar_screenshake() -> void:
	var camara = get_tree().get_first_node_in_group("camara") as Camera2D
	if camara and camara.has_method("sacudir"):
		camara.sacudir(3.0)
