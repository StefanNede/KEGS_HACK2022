extends Node2D

onready var animation_player = $AnimationPlayer

func _ready() -> void:
	pass

func punch() -> void:
	animation_player.play("Punching")
