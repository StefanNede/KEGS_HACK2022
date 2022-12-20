extends Node2D

onready var animation_player = $AnimationPlayer

func _ready() -> void:
	pass

func slash() -> void:
	animation_player.play("Candy Cane Sword")
