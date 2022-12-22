extends Node2D

const GameOverScreen = preload("res://UI/GameOverScreen.tscn") 
const PauseScreen = preload("res://UI/PauseScreen.tscn")


onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var gui: Gui = $GUI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # change random number seed every time we play so that random movements don't always go in the same sequence
	connectBullets()
	spawn_player()

func connectBullets() -> void:
	for weapon in player.weapons_available:
		if weapon.get("max_ammo"):
			GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instance()
		add_child(pause_menu)

func spawn_player() -> void:
	player.connect("won", self, "handle_player_won_level")
	player.connect("died", self, "handle_player_died")
	gui.set_player(player)

func handle_player_died() -> void:
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true

func handle_player_won_level() -> void:
	var game_over = GameOverScreen.instance()
	game_over.set_title(true)
	get_tree().paused = true

func handle_player_paused() -> void:
	get_tree().paused = true
