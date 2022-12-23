extends KinematicBody2D

class_name Player

signal player_health_changed(new_health)
signal pistol_ammo_left_changed(new_ammo_left)
signal weapon_changed(new_weapon)
signal died

# PackedScene is a reference to the scene data 
#	- can create instances of PackedScene in game so like a class
export (int) var speed = 300

# could have a stat node for when we have more
onready var health_stat = $Health
onready var collision_shape = $CollisionShape2D
onready var hurt_audio = $HurtAudio

var ammo_left: int = 30
var mag_size: int = 10

var weapons_available = []

var current_level: int
var current_weapon

var enemies_left: int

var max_health: int = 200

func _ready() -> void:
	health_stat.health = max_health
	current_level = getLevel()
	weapons_available = getWeaponAvailable(current_level)
	enemies_left = getEnemiesLeft()
	connectWeapons()

func getEnemiesLeft() -> int:
	return 0

func getLevel() -> int:
	var current_scene: String = get_tree().get_current_scene().get_name()
	var current_level: int = int(current_scene[current_scene.length()-1])
	return current_level

func getWeaponAvailable(level: int) -> Array:
	var weapons = []
	match level:
		1:
			# just fists
			weapons.append($WeaponManager/Fists)
		2:
			# fists and sword
			weapons.append($WeaponManager/Fists)
			weapons.append($WeaponManager/Sword)
		3:
			# fists, swords, pistol
			weapons.append($WeaponManager/Fists)
			weapons.append($WeaponManager/Sword)
			weapons.append($WeaponManager/Pistol)
		4:
			# fists, swords, pistol, grenade launcher
			weapons.append($WeaponManager/Fists)
			weapons.append($WeaponManager/Sword)
			weapons.append($WeaponManager/Pistol)
			weapons.append($WeaponManager/GrenadeLauncher)
		5:
			# fists, swords, pistol, grenade launcher
			weapons.append($WeaponManager/Fists)
			weapons.append($WeaponManager/Sword)
			weapons.append($WeaponManager/Pistol)
			weapons.append($WeaponManager/GrenadeLauncher)
			weapons.append($WeaponManager/RudolphNose)
		_: 
			pass
	
	# make only the first weapon visible
	for weapon in weapons:
		weapon.visible = false
	setCurrentWeapon(weapons[0])
	
	return weapons 

func setCurrentWeapon(weapon) -> void:
	emit_signal("weapon_changed", weapon)
	if current_weapon:
		# set old weapon to not be visible
		current_weapon.visible = false
	
	current_weapon = weapon
	
	# set new weapon to be visible
	current_weapon.visible = true
	

func connectWeapons() -> void:
	# print(weapons_available)
	for weapon in weapons_available:
		if weapon.get("current_ammo"):
			weapon.connect("weapon_out_of_ammo", self, "handle_reload")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# print("ammo left: " + str(ammo_left))
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
	#print(current_weapon)
	if not current_weapon.get("max_ammo"):
		return
	
	# reloads automatically if no ammo left or can be triggered by pressing r
	if ammo_left > 0:
		var ammo_used = min(mag_size- current_weapon.current_ammo, ammo_left - current_weapon.current_ammo)
		#print(ammo_used)
		current_weapon.start_reload(current_weapon.current_ammo + ammo_used)
		ammo_left -= ammo_used
	else:
		#print("no ammo left")
		pass
	
	emit_signal("pistol_ammo_left_changed", ammo_left)

func _unhandled_input(event: InputEvent) -> void:
	# change weapon:
	if event.is_action_released("weapon1") and weapons_available.size() >= 1:
		setCurrentWeapon(weapons_available[0])
	if event.is_action_released("weapon2") and weapons_available.size() >= 2:
		setCurrentWeapon(weapons_available[1])
	if event.is_action_released("weapon3") and weapons_available.size() >= 3:
		setCurrentWeapon(weapons_available[2])
	if event.is_action_released("weapon4") and weapons_available.size() >= 4:
		setCurrentWeapon(weapons_available[3])
	if event.is_action_released("weapon5") and weapons_available.size() >= 5:
		setCurrentWeapon(weapons_available[4])
	
	elif event.is_action_released("shoot"):
		current_weapon.shoot()
	
	elif event.is_action_released("reload"):
		handle_reload()


func get_damage_dealt(weapon: String) -> int:
	match weapon:
		"pistol":
			return 20
		_:
			return 0

func handle_hit(weapon: String) -> void:
	# print("player health: " + str(health_stat.health))
	health_stat.health -= 20 # automatically calls the setter
	hurt_audio.play()
	emit_signal("player_health_changed", health_stat.health)
	if health_stat.health <= 0:
		die()
	
	# check the number of enemies left on the screen
	
	# print("player health now at: " + str(health_stat.health))

func die():
	emit_signal("died")
