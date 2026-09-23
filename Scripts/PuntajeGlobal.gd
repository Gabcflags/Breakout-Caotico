extends Node

var puntos: int = 0

func agregar_puntos(cantidad: int) -> void:
	puntos += cantidad
	print("Puntos actuales: ", puntos)
