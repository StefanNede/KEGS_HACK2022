extends CanvasLayer

class_name GUI3

onready var health_bar = $MarginContainer/Rows/TopRow/HealthSection/HealthBar
onready var current_ammo = $MarginContainer/Rows/TopRow/AmmoSection/CurrentAmmo
onready var ammo_left = $MarginContainer/Rows/TopRow/AmmoSection/AmmoLeft
onready var health_tween = $MarginContainer/Rows/TopRow/HealthSection/HealthTween

onready var inventory_bar: Inventory_Bar = $MarginContainer/Rows/BottomRow/InventoryBar

var player: Player

func set_player(player: Player):
	self.player = player
	player.connect("weapon_changed", self, "handle_weapon_changed")
	
	set_new_health(player.health_stat.health)
	set_current_ammo(0)
	set_ammo_left(0)
	
	player.connect("player_health_changed", self, "set_new_health")
	
	# set max value to the value the player starts with
	health_bar.max_value = player.health_stat.health
	
func getIndex(weapon):
	for w in range(len(player.weapons_available)):
		if weapon == player.weapons_available[w]:
			return w
	return -1

func handle_weapon_changed(new_weapon: Node2D) -> void:
	var weaponIndex = getIndex(new_weapon)+1
	inventory_bar.weapon_changed(weaponIndex)
	# changes the bit at the bottom that highlights the weapon currently in use and the ammo section
	if new_weapon.get("current_ammo"):
		set_current_ammo(new_weapon.current_ammo)
		set_ammo_left(player.ammo_left)
		new_weapon.connect("gun_ammo_changed", self, "set_current_ammo")
		player.connect("pistol_ammo_left_changed", self, "set_ammo_left")
	else:
		set_current_ammo(0)
		set_ammo_left(0)

func set_new_health(new_health: int) -> void:
	var bar_style = health_bar.get("custom_styles/fg")
	var original_colour = Color("5c1818")
	var highlight_colour = Color("fb8080") # to highlight to the player their health changed
	# change the value of the health bar
	health_tween.interpolate_property(health_bar, "value", health_bar.value, new_health, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	# change the colour of the health bar
	health_tween.interpolate_property(bar_style, "bg_color", original_colour, highlight_colour, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", highlight_colour, original_colour, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.1)
	health_tween.start()
	# health_bar.value = new_health

func set_current_ammo(new_ammo: int) -> void:
	current_ammo.text = str(new_ammo)

func set_ammo_left(new_ammo_left: int) -> void:
	ammo_left.text = str(new_ammo_left)
