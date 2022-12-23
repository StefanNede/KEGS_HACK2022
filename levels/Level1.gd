extends Node2D

signal won
signal wave_changed(new_wave)

const GameOverScreen = preload("res://UI/GameOverScreen.tscn") 
const PauseScreen = preload("res://UI/PauseScreen.tscn")
const LevelSelectScreen = preload("res://UI/LevelSelectScreen.tscn")

const PunchEnemyTemplate = preload("res://actors/PunchEnemy.tscn")

const DialogueBox = preload("res://UI/Dialogue.tscn")

onready var player: Player = $Player
onready var gui: Gui = $GUI

var waves = [
	["punch","punch","punch","punch","punch"], 
	["punch","punch","punch","punch","punch", "punch", "punch"]
]

var waves_enemy = [5,7]

var time_between_waves: float = 5.0

var current_wave = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # change random number seed every time we play so that random movements don't always go in the same sequence
	GlobalSignals.connect("enemy_died", self, "handle_enemy_died")
	show_dialogue()
	gui.visible = false
	var t = Timer.new()
	t.set_wait_time(7)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	gui.visible = true
	spawn_player()
	spawn_enemies()


func show_dialogue():
	var dialogue_box = DialogueBox.instance()
	dialogue_box.z_index = 1
	var dialogue = dialogue_box.get_node("Label")
	dialogue.text = "Watch out for these enemies. The elves can't hurt you they're just there to annoy you, so quick kill them, we need to find Santa!"
	add_child(dialogue_box)

func spawn_player() -> void:
	player.connect("died", self, "handle_player_died")
	gui.set_player(player)
	# print(player.position.x, " ", player.position.y)

func spawn_enemies() -> void:
	for i in waves[current_wave]:
		var enemy_instance
		if i == "punch":
			enemy_instance = PunchEnemyTemplate.instance()
		enemy_instance.position.x = rand_range(-250, 1250)
		enemy_instance.position.y = rand_range(-150,750)
		while enemy_instance.position.y > 0 and enemy_instance.position.y < 600: 
			enemy_instance.position.y = rand_range(-150,750)
		call_deferred("add_child", enemy_instance)

func handle_enemy_died():
	waves_enemy[current_wave] -= 1
	if waves_enemy[current_wave] <= 0:
		if current_wave == waves.size()-1:
			emit_signal("won")
			handle_player_won_level()
		else:
			current_wave += 1
			emit_signal("wave_changed", current_wave)
			# wait 5 seconds
			var t = Timer.new()
			t.set_wait_time(time_between_waves)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			
			# spawn enemies from that wave
			spawn_enemies()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instance()
		add_child(pause_menu)

func handle_player_died() -> void:
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true

func handle_player_won_level() -> void:
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true

func handle_player_paused() -> void:
	get_tree().paused = true
