extends Node2D

onready var animation_player = $AnimationPlayer

var direction: Vector2 = Vector2.ZERO

func shoot() -> void:
	animation_player.play("Punching")

func get_direction() -> void:
	direction = ($BoxingGloves/FistHit/CollisionShape2D.global_position - global_position).normalized() # gets vector between these two

func _on_FistHit_body_entered(body):
	if body.is_in_group("enemy"):
		body.handle_hit("fists")
		get_direction()
		GlobalSignals.emit_signal("bullet_impacted", body.global_position, direction)
		if body.has_method("handle_knockback"):
			body.handle_knockback(direction)
