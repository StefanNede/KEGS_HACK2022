extends KinematicBody2D

class_name Reindeer

onready var health_stat: Health = $Health

var starting_health := 150

func _ready() -> void:
	health_stat.health = starting_health

func handle_hit() -> void:
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
	# print("enemy health now at: " + str(health_stat.health))
