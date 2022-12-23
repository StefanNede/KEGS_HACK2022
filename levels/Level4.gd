extends Node2D

signal won
signal wave_changed(new_wave)

const GameOverScreen = preload("res://UI/GameOverScreen.tscn") 
const PauseScreen = preload("res://UI/PauseScreen.tscn")
const LevelSelectScreen = preload("res://UI/LevelSelectScreen.tscn")

const PunchEnemyTemplate = preload("res://actors/PunchEnemy.tscn")
const ShootEnemyTemplate = preload("res://actors/ShooterEnemy.tscn")
const ReindeerEnemyTemplate = preload("res://actors/Reindeer.tscn")
const WitchEnemyTemplate = preload("res://actors/WitchEnemy.tscn")

onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var gui: Gui = $GUI

var waves = [
	["punch","punch","shoot","shoot","reindeer","witch"], 
	["punch","punch","shoot","shoot","shoot","reindeer","reindeer", "witch", "witch"],
	["punch","punch","shoot", "shoot", "shoot", "reindeer", "reindeer", "reindeer", "witch", "witch"],
	["punch","punch","shoot", "shoot", "shoot", "reindeer", "reindeer", "reindeer", "witch", "witch", "witch", "witch"]
]
var waves_enemy = [6,9,10,12]
var time_between_waves: float = 5.0
var current_wave = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # change random number seed every time we play so that random movements don't always go in the same sequence
	GlobalSignals.connect("enemy_died", self, "handle_enemy_died")
	connectBullets()
	spawn_player()
	spawn_enemies()

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
		elif i == "shoot":
			enemy_instance = ShootEnemyTemplate.instance()
			enemy_instance.position.x = rand_range(100, 900)
			enemy_instance.position.y = rand_range(100, 500)
			call_deferred("add_child", enemy_instance)
		elif i == "reindeer":
			enemy_instance = ReindeerEnemyTemplate.instance()
			enemy_instance.position.x = rand_range(-250, 1250)
			enemy_instance.position.y = rand_range(-150,750)
			while enemy_instance.position.y > 0 and enemy_instance.position.y < 600: 
				enemy_instance.position.y = rand_range(-150,750)
			call_deferred("add_child", enemy_instance)
		elif i == "witch":
			enemy_instance = WitchEnemyTemplate.instance()
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
			# set health back to full
			player.health_stat.health = player.max_health
			player.emit_signal("player_health_changed", player.max_health)
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

func connectBullets() -> void:
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

func handle_player_won_level() -> void:
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true

func handle_player_paused() -> void:
	get_tree().paused = true
