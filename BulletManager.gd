extends Node2D

func handle_bullet_spawned(bullet: Bullet, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = position
	
	# to give speed to movement need to do that in bullet script
	bullet.set_direction(direction)
