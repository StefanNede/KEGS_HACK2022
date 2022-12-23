extends Node2D

class_name ShootWeapon

signal weapon_out_of_ammo
signal gun_ammo_changed


const Bullet  = preload("res://weapons/Bullet.tscn")

# $ selects child nodes of current parent node
# onready - not still initialising
onready var end_of_gun = $EndOfGun
onready var attack_cooldown = $AttackCooldown
onready var animation_player = $AnimationPlayer
onready var audio = $ShotAudio
onready var reload_audio = $ReloadAudio

var max_ammo: int = 10
var current_ammo: int = max_ammo setget set_current_ammo

func start_reload(available_ammo):
	self.max_ammo = available_ammo
	animation_player.play("reload")
	reload_audio.play()

func _stop_reload():
	current_ammo = max_ammo
	emit_signal("gun_ammo_changed", current_ammo)
	
func set_current_ammo(new_ammo: int) -> void:
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo <= 0:
			emit_signal("weapon_out_of_ammo")
		emit_signal("gun_ammo_changed", current_ammo)

func shoot():
	if current_ammo > 0 and attack_cooldown.is_stopped() and Bullet != null:
		# true whenever the timer is not running
		var bullet_instance = Bullet.instance()
		# bullet_instance.global_position = end_of_gun.global_position
		# make bullet point in the correct direction
		var target = get_global_mouse_position()
		var direction = (end_of_gun.global_position - global_position).normalized() # gets vector between these two
		
		GlobalSignals.emit_signal("bullet_fired", bullet_instance, end_of_gun.global_position, direction)
		
		# start attack cooldown again
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
		audio.play()
		
		# handle ammo
		set_current_ammo(current_ammo - 1)
