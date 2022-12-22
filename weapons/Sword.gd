extends Node2D

onready var animation_player = $AnimationPlayer
onready var audio = $SlashAudio

var direction: Vector2 = Vector2.ZERO

func shoot() -> void:
	animation_player.play("Candy Cane Sword")
	audio.play()

func _on_SwordHit_body_entered(body):
	if body.is_in_group("enemy"):
		body.handle_hit("sword")

		GlobalSignals.emit_signal("bullet_impacted", body.global_position, direction)
