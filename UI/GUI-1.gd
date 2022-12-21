extends CanvasLayer

class_name GUI1

onready var health_bar = $MarginContainer/Rows/TopRow/HealthSection/HealthBar
onready var health_tween = $MarginContainer/Rows/TopRow/HealthSection/HealthTween

onready var inventory_bar: Inventory_Bar = $MarginContainer/Rows/BottomRow/InventoryBar

var player: Player

func set_player(player: Player):
	self.player = player
	
	set_new_health(player.health_stat.health)
	
	player.connect("player_health_changed", self, "set_new_health")

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
