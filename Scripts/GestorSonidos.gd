extends Node

var sonido_rebote: AudioStream = preload("res://Assets/Audio/laserSmall_000.ogg")
var sonido_romper: AudioStream = preload("res://Assets/Audio/explosionCrunch_001.ogg")
var sonido_powerup: AudioStream = preload("res://Assets/Audio/powerup.mp3")

var volumen_rebote_db: float = -4.0
var volumen_romper_db: float = -7.0
var volumen_powerup_db: float = 2.0

var pitch_min: float = 0.9
var pitch_max: float = 1.1

const NUM_REPRODUCTORES: int = 8

var _pool: Array[AudioStreamPlayer] = []
var _indice: int = 0

func _ready() -> void:
	for i in range(NUM_REPRODUCTORES):
		var reproductor := AudioStreamPlayer.new()
		add_child(reproductor)
		_pool.append(reproductor)

func _reproducir(stream: AudioStream, volumen_db: float) -> void:
	if not stream:
		return
	var reproductor: AudioStreamPlayer = _pool[_indice]
	_indice = (_indice + 1) % _pool.size()
	reproductor.stream = stream
	reproductor.volume_db = volumen_db
	reproductor.pitch_scale = randf_range(pitch_min, pitch_max)
	reproductor.play()

func reproducir_rebote() -> void:
	_reproducir(sonido_rebote, volumen_rebote_db)

func reproducir_romper() -> void:
	_reproducir(sonido_romper, volumen_romper_db)

func reproducir_powerup() -> void:
	_reproducir(sonido_powerup, volumen_powerup_db)
