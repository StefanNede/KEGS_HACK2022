extends KinematicBody2D

class_name Reindeer

onready var health_stat: Health = $Health
onready var ai: Reindeer_AI = $AI

var starting_health := 150
var speed := 400

func _ready() -> void:
	ai.initialise(self)
	health_stat.health = starting_health

func get_damage_dealt(weapon: String) -> int:
	match weapon:
		"fists":
			return 20
		"sword":
			return 40
		"pistol":
			return 50
		"grenade":
			return 100
		"rudolph":
			return 0
		_:
			return 0

func handle_hit(weapon: String) -> void:
	var damage_dealt := get_damage_dealt(weapon)
	health_stat.health -= damage_dealt
	if health_stat.health <= 0:
		queue_free()

func rotate_towards(location: Vector2) -> void:
	# rotation is in radians
	# lerp makes it look more natural when the AI turns around - it doesn't just snap -> takes in (current rotation, final rotation, weight)
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
