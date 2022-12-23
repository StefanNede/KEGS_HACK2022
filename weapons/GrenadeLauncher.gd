extends Node2D

signal weapon_out_of_ammo
signal gun_ammo_changed
signal ammo_left_changed(new_ammo_left)

onready var grenade_audio = $GrenadeAudio

var explosion_point: Vector2
var explosion_radius: int = 100

var max_ammo: int = 3
var current_ammo: int = max_ammo setget set_current_ammo
var ammo_left: int = 0 setget set_ammo_left

func is_close_enough(enemy) -> bool:
	if abs(enemy.position.x - explosion_point.x) < explosion_radius and abs(enemy.position.y - explosion_point.y) < explosion_radius:
		return true
	return false

func set_current_ammo(new_ammo: int) -> void:
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo <= 0:
			print("no more ammo")
			emit_signal("weapon_out_of_ammo")
		emit_signal("gun_ammo_changed", current_ammo)

func set_ammo_left(new_ammo_left: int) -> void:
	ammo_left = new_ammo_left
	emit_signal("ammo_left_changed", new_ammo_left)

func shoot():
	if current_ammo > 0:
		grenade_audio.play()
		explosion_point = get_global_mouse_position()
		# get all the enemies in a radius of __ of that point
		# and damage them
		var enemies_in_scene = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies_in_scene:
			if is_close_enough(enemy):	
				if enemy.has_method("handle_hit"):
					enemy.handle_hit("grenade")
					GlobalSignals.emit_signal("bullet_impacted", enemy.global_position, Vector2.ZERO)
				if enemy.has_method("handle_knockback"):
					enemy.handle_knockback(Vector2.ZERO)
		
		set_current_ammo(current_ammo-1)
