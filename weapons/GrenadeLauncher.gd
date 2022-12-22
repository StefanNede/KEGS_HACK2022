extends Node2D

onready var grenade_audio = $GrenadeAudio

var explosion_point: Vector2
var explosion_radius: int = 100

func is_close_enough(enemy) -> bool:
	if abs(enemy.position.x - explosion_point.x) < explosion_radius and abs(enemy.position.y - explosion_point.y) < explosion_radius:
		return true
	return false

func shoot():
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
