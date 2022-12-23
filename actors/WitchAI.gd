extends Node2D

class_name Witch_AI

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

onready var player_detection_zone = $PlayerDetectionZone
onready var player: Player = get_node("../../Player")

var current_state: int = -1 setget set_state
var actor: KinematicBody2D = null
var weapon = null

# PATROL STATE
var origin: Vector2 = Vector2.ZERO # the origin for the AI patrolling
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_state(State.PATROL)


func initialise(actor, weapon) -> void:
	self.actor = actor
	self.weapon = weapon

func _process(delta: float) -> void:
	match current_state:
		State.PATROL: 
			actor.rotate_towards(player.global_position)
			actor_velocity = actor.velocity_towards(player.position)
			actor.move_and_slide(actor_velocity)

		State.ENGAGE:
			if player != null and weapon != null:
				var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
				# make actor follow player
				actor.rotate_towards(player.global_position)
				if abs(actor.rotation - angle_to_player) < 0.1:
					# only shoot when the AI is actually facing the player to make it easier for the player to survive
					weapon.shoot()
			else: 
				print("Error: no weapon or player in ENGAGE state")
				
		_: 
			print("Error: found state for enemy that shouldn't exist")

func set_state(newState: int) -> void:
	if newState != current_state:
		if newState == State.PATROL:
			origin = global_position
			# start timer
			patrol_location_reached = true
		current_state = newState
		emit_signal("state_changed", current_state)

func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		set_state(State.ENGAGE)

func _on_PlayerDetectionZone_body_exited(body):
	if player and body.is_in_group("player"):
		set_state(State.PATROL)
