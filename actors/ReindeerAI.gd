extends Node2D

class_name Reindeer_AI

onready var timer = $Timer
onready var player = get_node("../../Player")
onready var ReindeerHit = get_node("../Sprite/ReindeerHit/CollisionShape2D")

var actor: KinematicBody2D = null
var actor_velocity: Vector2 = Vector2.ZERO
var target_position: Vector2
var angle_to_target: float
var target_position_reached: bool

var hitbox_disabled = false

func _ready() -> void:
	timer.start()
	target_position_reached = true

func initialise(actor) -> void:
	self.actor = actor

func _process(delta: float) -> void:
	if not target_position_reached and abs(actor.global_position.x - target_position.x) < 1 and abs(actor.global_position.y - target_position.y) < 1:
		# also need to check if reindeer has collided with anything in which case we set target_position_reached to be true
		target_position_reached = true
		hitbox_disabled = true
		timer.start()
	if player != null and not target_position_reached:
		# print("moving to target position")
		actor.rotate_towards(target_position)
		if abs(actor.rotation - angle_to_target) < 0.1:
			# charge at the player
			actor.move_and_slide(actor_velocity)

func _on_Timer_timeout():
	if player != null:
		#print("new target position set")
		target_position = player.global_position
		#print(actor.global_position, target_position)
		angle_to_target = actor.global_position.direction_to(target_position).angle()
		actor_velocity = actor.velocity_towards(target_position)
		target_position_reached = false
		hitbox_disabled = false

func _on_ReindeerHit_body_entered(body):
	if not hitbox_disabled:
		if body.is_in_group("player"):
			body.handle_hit("reindeer")
		target_position_reached = true
		hitbox_disabled = true
		timer.start()
