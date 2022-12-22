extends Node2D

onready var animation_player = $AnimationPlayer

func _ready() -> void:
	pass

func shoot() -> void:
	animation_player.play("Punching")
	
	# check if there are any enmies in front of the fists and move them back
	
