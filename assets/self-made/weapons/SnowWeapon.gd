extends Node2D

const Bullet  = preload("res://weapons/SnowBullet.tscn")

# $ selects child nodes of current parent node
# onready - not still initialising
onready var end_of_gun = $EndOfGun
onready var attack_cooldown = $AttackCooldown
onready var audio = $ShotAudio

func shoot():
	if attack_cooldown.is_stopped() and Bullet != null:
		# true whenever the timer is not running
		var bullet_instance = Bullet.instance()
		# bullet_instance.global_position = end_of_gun.global_position
		# make bullet point in the correct direction
		var target = get_global_mouse_position()
		var direction = (end_of_gun.global_position - global_position).normalized() # gets vector between these two
		
		GlobalSignals.emit_signal("bullet_fired", bullet_instance, end_of_gun.global_position, direction)
		
		# start attack cooldown again
		attack_cooldown.start()
		audio.play()
		
