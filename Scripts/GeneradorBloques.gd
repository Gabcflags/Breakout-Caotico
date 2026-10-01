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

@export_group("Niveles procedurales")
@export var max_filas: int = 8
@export var incremento_velocidad_por_nivel: float = 0.05
@export var multiplicador_velocidad_maximo: float = 1.6
@export var tiempo_entre_niveles: float = 1.0
@export var debug_tecla_k: bool = true

enum Patron { LLENO, AJEDREZ, PIRAMIDE, PIRAMIDE_INVERTIDA, FILAS_ALTERNAS, MARCO, COLUMNAS_ALTERNAS, ROMBO, ALEATORIO_SIMETRICO }

const GRUPOS_BLOQUES: Array[String] = ["bloques", "bloque_especial", "bloque_especial_alargador", "bloque_multibola"]

var cambiando_nivel: bool = false
var ultimo_patron: int = -1

func _ready() -> void:
	add_to_group("generador_bloques")
	randomize()
	generar_bloques()

func generar_bloques() -> void:
	var nivel: int = PuntajeGlobal.nivel

	var filas_nivel: int = mini(filas + int((nivel - 1) * 0.5), max_filas)
	var resistencia_nivel: int = mini(1 + int((nivel - 1) / 3.0), 4)

	var patron: int = _elegir_patron(nivel)
	var mascara: Array = _crear_mascara(patron, filas_nivel, columnas)

	for fila in range(filas_nivel):
		for columna in range(columnas):
			if not mascara[fila][columna]:
				continue

			var escena_a_usar: PackedScene = escena_bloque
			var tirada: float = randf()

			if tirada < probabilidad_alargador and bloque_alargador_scene:
				escena_a_usar = bloque_alargador_scene
			elif tirada < probabilidad_alargador + probabilidad_especial and bloque_especial_scene:
				escena_a_usar = bloque_especial_scene
			elif tirada < probabilidad_alargador + probabilidad_especial + probabilidad_multibola:
				if escena_bloque_multibola:
					escena_a_usar = escena_bloque_multibola

			var nuevo_bloque = escena_a_usar.instantiate()
			if escena_a_usar == escena_bloque and "resistencia" in nuevo_bloque:
				nuevo_bloque.resistencia = resistencia_nivel
			nuevo_bloque.global_position = Vector2(
				margen_izquierdo + columna * espaciado.x,
				margen_superior + fila * espaciado.y
			)
			add_child(nuevo_bloque)

func _elegir_patron(nivel: int) -> int:
	if nivel <= 1:
		ultimo_patron = Patron.LLENO
		return Patron.LLENO

	var patron: int = randi() % Patron.size()
	while patron == ultimo_patron:
		patron = randi() % Patron.size()
	ultimo_patron = patron
	return patron

func _crear_mascara(patron: int, filas_n: int, cols: int) -> Array:
	var mascara: Array = []
	var hc: float = (cols - 1) / 2.0
	var hr: float = (filas_n - 1) / 2.0
	var cuantos: int = 0

	var mitad: Array = []
	if patron == Patron.ALEATORIO_SIMETRICO:
		for f in range(filas_n):
			var fila_mitad: Array = []
			for c in range(int(ceil(cols / 2.0))):
				fila_mitad.append(randf() < 0.7)
			mitad.append(fila_mitad)

	for f in range(filas_n):
		var fila: Array = []
		for c in range(cols):
			var hay: bool = true
			match patron:
				Patron.AJEDREZ:
					hay = (f + c) % 2 == 0
				Patron.PIRAMIDE:
					hay = absf(c - hc) <= hc * (f + 1.0) / filas_n
				Patron.PIRAMIDE_INVERTIDA:
					hay = absf(c - hc) <= hc * (filas_n - f) / float(filas_n)
				Patron.FILAS_ALTERNAS:
					hay = f % 2 == 0
				Patron.MARCO:
					hay = f == 0 or f == filas_n - 1 or c == 0 or c == cols - 1
				Patron.COLUMNAS_ALTERNAS:
					hay = c % 2 == 0
				Patron.ROMBO:
					if hr > 0.0 and hc > 0.0:
						hay = absf(c - hc) / hc + absf(f - hr) / hr <= 1.0001
				Patron.ALEATORIO_SIMETRICO:
					var cm: int = c if c < int(ceil(cols / 2.0)) else cols - 1 - c
					hay = mitad[f][cm]
			if hay:
				cuantos += 1
			fila.append(hay)
		mascara.append(fila)

	if cuantos == 0:
		return _crear_mascara(Patron.LLENO, filas_n, cols)
	return mascara

func verificar_fin_de_nivel() -> void:
	await get_tree().process_frame

	if cambiando_nivel:
		return

	var restantes: int = 0
	for grupo in GRUPOS_BLOQUES:
		for b in get_tree().get_nodes_in_group(grupo):
			if not b.is_queued_for_deletion():
				restantes += 1

	if restantes > 0:
		return

	cambiando_nivel = true
	await _pasar_al_siguiente_nivel()

func _input(event: InputEvent) -> void:
	if not debug_tecla_k or cambiando_nivel:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_K:
		get_viewport().set_input_as_handled()
		_destruir_todos_los_bloques()

func _destruir_todos_los_bloques() -> void:
	for grupo in GRUPOS_BLOQUES:
		for b in get_tree().get_nodes_in_group(grupo):
			if b.is_queued_for_deletion() or b.has_meta("destruyendo"):
				continue
			b.set_meta("destruyendo", true)
			if b.has_method("destruir"):
				b.destruir()

func _pasar_al_siguiente_nivel() -> void:
	PuntajeGlobal.nivel += 1

	for b in get_tree().get_nodes_in_group("bola_extra"):
		b.queue_free()

	var mult: float = minf(1.0 + (PuntajeGlobal.nivel - 1) * incremento_velocidad_por_nivel, multiplicador_velocidad_maximo)
	var bola = get_tree().get_first_node_in_group("bola")
	if bola and bola.has_method("preparar_siguiente_nivel"):
		bola.preparar_siguiente_nivel(mult)

	activar_screenshake()
	await get_tree().create_timer(tiempo_entre_niveles).timeout

	generar_bloques()
	cambiando_nivel = false

func activar_screenshake() -> void:
	var camara = get_tree().get_first_node_in_group("camara") as Camera2D
	if camara and camara.has_method("sacudir"):
		camara.sacudir(3.0)
