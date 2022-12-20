extends KinematicBody2D

class_name PunchEnemy

export (int) var speed = 150

onready var health_stat = $Health
onready var ai: Punch_AI = $PunchAI

var starting_health := 60

func _ready():
	ai.initialise(self)
	health_stat.health = starting_health

func handle_hit() -> void:
	health_stat.health -= 20 # automatically calls the settersd
	if health_stat.health <= 0:
		queue_free()


func rotate_towards(location: Vector2) -> void:
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
