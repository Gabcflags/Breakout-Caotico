extends Node2D # O CanvasLayer / Control, según el nodo al que le añadas el script

@onready var label_puntos: Label = $CanvasLayer/LabelPuntos

func _process(_delta: float) -> void:
	# Lee los puntos guardados en la variable global y actualiza el texto
	label_puntos.text = "Puntos: " + str(PuntajeGlobal.puntos)
