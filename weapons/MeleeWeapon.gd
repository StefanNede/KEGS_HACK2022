extends Node2D

class_name MeleeWeapon

export (PackedScene) var Punch

# $ selects child nodes of current parent node
# onready - not still initialising
onready var end_of_punch = $EndOfPunch
onready var attack_cooldown = $AttackCooldown # no attack cooldown for punching
onready var animation_player = $AnimationPlayer


func punch():
	if attack_cooldown.is_stopped() and Punch != null:
		var punch_instance = Punch.instance()
		# make punch point in the correct direction
		var target = get_global_mouse_position()
		var direction = (end_of_punch.global_position - global_position).normalized()

		GlobalSignals.emit_signal("punch_fired", punch_instance, end_of_punch.global_position, direction)

		# start attack cooldown again
		attack_cooldown.start()
		animation_player.play("punch")
