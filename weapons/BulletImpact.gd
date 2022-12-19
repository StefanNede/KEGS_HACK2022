extends Particles2D

onready var timer = $Timer


func start_emitting() -> void:
	timer.wait_time = lifetime + 0.1 # make timer match duration of particle life time
	timer.start()
	emitting = true

func _on_Timer_timeout() -> void:
	queue_free()
