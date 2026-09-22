extends RigidBody2D

var velocidad = 550

func _ready():
	linear_velocity = Vector2(-200, -200).normalized() * velocidad
