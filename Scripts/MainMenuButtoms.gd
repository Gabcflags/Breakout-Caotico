extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/caja.tscn")


func _on_start_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu_options.tscn")

func _on_start_3_pressed() -> void:
	get_tree().quit()
