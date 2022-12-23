extends KinematicBody2D

class_name WitchEnemy

export (int) var speed = 75

onready var health_stat = $Health
onready var ai: Witch_AI = $AI
onready var sprite = $Sprite

onready var health_bar = $HealthBar

var starting_health := 100

func _ready():
	ai.initialise(self)
	health_stat.health = starting_health
	health_bar.max_value = starting_health
	health_bar.value = starting_health

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
	health_bar.value = health_stat.health
	if health_stat.health <= 0:
		GlobalSignals.emit_signal("enemy_died")
		queue_free()

func rotate_towards(location: Vector2) -> void:
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
