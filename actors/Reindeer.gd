extends KinematicBody2D

class_name Reindeer

onready var health_stat: Health = $Health
onready var ai: Reindeer_AI = $AI

var starting_health := 150
var speed := 400

func _ready() -> void:
	ai.initialise(self)
	health_stat.health = starting_health

func handle_hit() -> void:
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
	# print("enemy health now at: " + str(health_stat.health))

func rotate_towards(location: Vector2) -> void:
	# rotation is in radians
	# lerp makes it look more natural when the AI turns around - it doesn't just snap -> takes in (current rotation, final rotation, weight)
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
