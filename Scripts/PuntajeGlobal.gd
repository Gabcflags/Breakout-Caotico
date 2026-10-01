extends Node

const RUTA_GUARDADO := "user://record.cfg"

var puntos: int = 0
var nivel: int = 1
var record: int = 0
var es_nuevo_record: bool = false

func _ready() -> void:
	cargar_record()

func agregar_puntos(cantidad: int) -> void:
	puntos += cantidad
	print("Puntos actuales: ", puntos)

func reiniciar() -> void:
	puntos = 0
	nivel = 1
	es_nuevo_record = false

func terminar_partida() -> void:
	if puntos > record:
		record = puntos
		es_nuevo_record = true
		guardar_record()

func guardar_record() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("juego", "record", record)
	cfg.save(RUTA_GUARDADO)

func cargar_record() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(RUTA_GUARDADO) == OK:
		record = cfg.get_value("juego", "record", 0)
