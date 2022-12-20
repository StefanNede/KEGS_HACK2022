extends Node2D

class_name Health

export (int) var health = 100 setget set_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_health(new_health: int) -> void:
	health = new_health # makes sure health is between 0 and 100, so always a valid value
