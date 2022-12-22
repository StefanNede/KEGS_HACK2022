extends KinematicBody2D

class_name PunchEnemy

export (int) var speed = 150

onready var health_stat = $Health
onready var ai: Punch_AI = $PunchAI
onready var sprite = $Sprite

var starting_health := 60

func _ready():
	ai.initialise(self)
	health_stat.health = starting_health

func _physics_process(delta: float) -> void:
	pass

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
	health_stat.health -= damage_dealt # automatically calls the setters
	if health_stat.health <= 0:
		queue_free()

func handle_knockback(direction: Vector2):
	pass

func rotate_towards(location: Vector2) -> void:
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
