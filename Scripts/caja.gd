extends Node2D

@onready var label_puntos: Label = $CanvasLayer/LabelPuntos

func _ready() -> void:
	PuntajeGlobal.reiniciar()

func _process(_delta: float) -> void:
	label_puntos.text = "Puntos: %d   Récord: %d" % [PuntajeGlobal.puntos, PuntajeGlobal.record]
