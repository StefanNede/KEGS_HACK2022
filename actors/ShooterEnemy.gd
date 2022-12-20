extends KinematicBody2D

class_name Shooter_Enemy

export (int) var speed = 100

onready var health_stat: Health = $Health
onready var ai: Shooter_AI = $AI
onready var weapon: ShootWeapon = $Weapon

var mag_size:int = 10
var starting_health := 100

func _ready():
	ai.initialise(self, weapon)
	health_stat.health = starting_health
	weapon.connect("weapon_out_of_ammo", self, "handle_reload")
	
func handle_reload():
	weapon.start_reload(mag_size)

func rotate_towards(location: Vector2) -> void:
	# rotation is in radians
	# lerp makes it look more natural when the AI turns around - it doesn't just snap -> takes in (current rotation, final rotation, weight)
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed

func handle_hit() -> void:
	print("shooter health: " + str(health_stat.health))
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
	# print("enemy health now at: " + str(health_stat.health))
