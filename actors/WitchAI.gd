extends Node2D

class_name Witch_AI

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

const SnowBullet = preload("res://weapons/SnowBullet.tscn")

onready var player: Player = get_node("../../Player")
onready var player_detection_zone = $PlayerDetectionZone

var current_state: int = -1 setget set_state
var actor: KinematicBody2D = null
var weapon = null

var motion = Vector2.ZERO

func _ready() -> void:
	set_state(State.PATROL)

func initialise(actor) -> void:
	self.actor = actor

func _process(delta: float) -> void:
	match current_state:
		State.PATROL: 
			var angle_to_player = actor.global_position.direction_to(player.global_position).angle() - 90
			actor.rotate_towards(player.global_position)
			
			motion = actor.velocity_towards(player.position)
			actor.move_and_slide(motion)
			
		State.ENGAGE:
			var angle_to_player = actor.global_position.direction_to(player.global_position).angle() - 90
			attack()
				
		_: 
			print("Error: found state for enemy that shouldn't exist")

func attack():
	var bullet_instance = SnowBullet.instance()
	bullet_instance.global_position = global_position
	# make bullet point in the correct direction
	var target = get_global_mouse_position()
	var direction = (target - global_position).normalized() # gets vector between these two
	print(direction)
	GlobalSignals.emit_signal("bullet_fired", bullet_instance, global_position, direction)

func set_state(newState: int) -> void:
	if newState != current_state:
		current_state = newState
		emit_signal("state_changed", current_state)

func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		set_state(State.ENGAGE)

func _on_PlayerDetectionZone_body_exited(body):
	if player and body.is_in_group("player"):
		set_state(State.PATROL)
