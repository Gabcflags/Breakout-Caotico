extends Node2D

@onready var label_puntos: Label = $LabelPuntos
@onready var label_record: Label = $LabelRecord

func _ready() -> void:
	label_puntos.text = "Puntos: %d" % PuntajeGlobal.puntos
	if PuntajeGlobal.es_nuevo_record:
		label_record.text = "¡Nuevo récord! %d" % PuntajeGlobal.record
	else:
		label_record.text = "Récord: %d" % PuntajeGlobal.record

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/caja.tscn")
