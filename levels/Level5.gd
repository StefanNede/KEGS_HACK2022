extends Node2D

const GameOverScreen = preload("res://UI/GameOverScreen.tscn") 
const PauseScreen = preload("res://UI/PauseScreen.tscn")
const ComingSoonScreen = preload("res://UI/ComingSoonScreen.tscn")

const DialogueBox = preload("res://UI/Dialogue.tscn")

onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var gui: Gui = $GUI

var enemies: int = 50
var waves = [[]]
var waves_enemy = [0]
var time_between_waves: float = 5.0
var current_wave = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # change random number seed every time we play so that random movements don't always go in the same sequence
	connectBullets()
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
	handle_player_won_game()

func show_dialogue():
	var dialogue_box = DialogueBox.instance()
	dialogue_box.z_index = 1
	var dialogue = dialogue_box.get_node("Label")
	dialogue.text = "Santa's room is empty?! He must've escaped, we'll catch him next time..."
	add_child(dialogue_box)

func handle_enemy_died():
	enemies -= 1
	if enemies <= 0:
		emit_signal("won")
		handle_player_won_game()

func connectBullets() -> void:
	for weapon in player.weapons_available:
		if weapon.get("max_ammo"):
			GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instance()
		add_child(pause_menu)

func spawn_player() -> void:
	player.connect("died", self, "handle_player_died")
	gui.set_player(player)

func handle_player_died() -> void:
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true

func handle_player_won_game() -> void:
	var game_over = ComingSoonScreen.instance()
	add_child(game_over)
	# game_over.set_title(true)
	# get_tree().paused = true

func handle_player_paused() -> void:
	get_tree().paused = true
