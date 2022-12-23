extends Node2D

class_name Punch_AI

onready var player: Player = get_node("../../Player")

var motion = Vector2.ZERO
var actor: KinematicBody2D = null

func initialise(actor: KinematicBody2D):
	self.actor = actor

func _physics_process(delta: float) -> void:
	var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
	actor.rotate_towards(player.global_position)
	
	motion = actor.velocity_towards(player.position)
	actor.move_and_slide(motion)
