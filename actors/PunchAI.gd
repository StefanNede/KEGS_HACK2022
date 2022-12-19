extends Node2D

class_name Punch_AI


onready var player_detection_zone = $PlayerDetectionZonePuncher

var motion = Vector2.ZERO
var go: bool = false
var player: Player = null

var actor: KinematicBody2D = null

func initialise(actor: KinematicBody2D):
	self.actor = actor

func _physics_process(delta: float) -> void:
	if go:
		# make enemy face player
		var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
		actor.rotate_towards(player.global_position)
		
		motion = actor.velocity_towards(player.position)
		actor.move_and_slide(motion)

func _on_PlayerDetectionZonePuncher_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		go = true
		player = body
