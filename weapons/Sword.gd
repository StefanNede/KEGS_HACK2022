extends Node2D

onready var animation_player = $AnimationPlayer

func _ready() -> void:
	pass

func shoot() -> void:
	animation_player.play("Candy Cane Sword")

func _on_SwordHit_body_entered(body):
	if body.is_in_group("enemy"):
		body.handle_hit("sword")
		GlobalSignals.emit_signal("bullet_impacted", body.global_position, Vector2.ZERO)
		# body.handle_knockback(position)
