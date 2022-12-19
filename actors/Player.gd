extends KinematicBody2D

class_name Player

signal player_health_changed(new_health)
signal pistol_ammo_left_changed(new_ammo_left)
signal died

# PackedScene is a reference to the scene data 
#	- can create instances of PackedScene in game so like a class
export (int) var speed = 300

# could have a stat node for when we have more
onready var health_stat = $Health
onready var collision_shape = $CollisionShape2D
onready var current_weapon: ShootWeapon = $Pistol

var ammo_left: int = 30
var mag_size: int = 10

func _ready() -> void:
	current_weapon.connect("weapon_out_of_ammo", self, "handle_reload")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var movement_direction := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		# in godot moving up is negative
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
	if Input.is_action_pressed("right"):
		movement_direction.x = 1
	
	# otherwise moving diagonally is faster
	movement_direction = movement_direction.normalized()
	
	move_and_slide(movement_direction*speed) # returns the actual velocity - so we can store how we're moving
	
	# rotate and face the mouse
	look_at(get_global_mouse_position())

func handle_reload():
	# reloads automatically if no ammo left or can be triggered by pressing r
	if ammo_left > 0:
		var ammo_used = min(mag_size- current_weapon.current_ammo, ammo_left - current_weapon.current_ammo)
		print(ammo_used)
		current_weapon.start_reload(current_weapon.current_ammo + ammo_used)
		ammo_left -= ammo_used
	else:
		print("no ammo left")
	emit_signal("pistol_ammo_left_changed", ammo_left)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		current_weapon.shoot()
		# print(current_weapon.current_ammo)
	elif event.is_action_released("reload"):
		handle_reload()


func handle_hit() -> void:
	health_stat.health -= 20 # automatically calls the setter
	emit_signal("player_health_changed", health_stat.health)
	if health_stat.health <= 0:
		die()
	# print("player health now at: " + str(health_stat.health))

func die():
	emit_signal("died")
