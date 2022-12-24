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

const DialogueBox = preload("res://UI/Dialogue.tscn")

onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var gui: Gui = $GUI
onready var pistol = get_node("./Player/WeaponManager/Pistol")
onready var grenade_launcher = get_node("./Player/WeaponManager/GrenadeLauncher")

var enemy_options = ["punch", "shoot", "reindeer", "witch"]
var waves = [
	["punch","punch", "punch"]
]
var waves_enemy = [3]
var time_between_waves: float = 5.0
var current_wave = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # change random number seed every time we play so that random movements don't always go in the same sequence
	GlobalSignals.connect("enemy_died", self, "handle_enemy_died")
	connectBullets()
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
	dialogue.text = "How many waves can you survive??? Santa has pity on you so your health and ammo will replenish after every round for now."
	add_child(dialogue_box)

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

func create_new_wave():
	# there will be 3 * wave number enemies per wave
	var enemies_to_add = 3 * (current_wave+1)
	var new_wave = []
	while enemies_to_add > 0:
		new_wave.append(enemy_options[int(rand_range(0,len(enemy_options)))])
		enemies_to_add -= 1
	waves.append(new_wave)
	waves_enemy.append(new_wave.size())

func handle_enemy_died():
	waves_enemy[current_wave] -= 1
	if waves_enemy[current_wave] <= 0:
		current_wave += 1
		if current_wave == waves.size():
			create_new_wave()
		# set health back to full
		player.health_stat.health = player.max_health
		player.emit_signal("player_health_changed", player.max_health)
		
		# set ammo back to full
		player.ammo_left = 15
		#pistol.current_ammo = pistol.max_ammo
		pistol.set_current_ammo(pistol.max_ammo)
		#grenade_launcher.current_ammo = grenade_launcher.max_ammo
		grenade_launcher.set_current_ammo(grenade_launcher.max_ammo)
		
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
	game_over.set_title(false, "you survived " + str(current_wave) + " rounds")
	get_tree().paused = true

func handle_player_won_level() -> void:
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true

func handle_player_paused() -> void:
	get_tree().paused = true
