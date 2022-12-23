extends Area2D

class_name SnowBullet

export (int) var speed = 10

onready var kill_timer = $KillTimer

var direction := Vector2.ZERO

func _ready() -> void:
	kill_timer.start()

# physics process is called at a constant rate so it doesn't depend on fps
func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		
		global_position += velocity

# set the direction
func set_direction(direction:Vector2) -> void:
	# self references the global variable
	self.direction = direction
	rotation += direction.angle()

# destroy the object after certain time
func _on_KillTimer_timeout():
	queue_free() # unity equivalent of destroy

func _on_SnowBullet_body_entered(body):
	if body.is_in_group("player"):
		# GlobalSignals.emit_signal("bullet_impacted", body.global_position, direction)
		body.handle_hit("snow_bullet")
	queue_free() 