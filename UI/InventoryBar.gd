extends Node2D

class_name Inventory_Bar

onready var selected1 = $Selected1
onready var selected2 = $Selected2
onready var selected3 = $Selected3
onready var selected4 = $Selected4
onready var selected5 = $Selected5

onready var BoxingGloves = $BoxingGloves
onready var CandyCane = $CandyCane
onready var SnowGun = $SnowGun
onready var GrenadeLauncher = $GrenadeLauncher
onready var RudolphNose = $RudolphNose

var level: int

func _ready() -> void:
	level = getLevel()
	setWeapons()

func getLevel() -> int:
	var current_scene: String = get_tree().get_current_scene().get_name()
	if current_scene == "Survival":
		return 100
	var current_level: int = int(current_scene[current_scene.length()-1])
	return current_level

func setWeapons() -> void:
	BoxingGloves.visible = false
	CandyCane.visible = false
	SnowGun.visible = false
	GrenadeLauncher.visible = false
	RudolphNose.visible = false
	
	if level >= 1:
		BoxingGloves.visible = true
	if level >= 2:
		CandyCane.visible = true
	if level >= 3:
		SnowGun.visible = true
	if level >= 4:
		GrenadeLauncher.visible = true
	if level == 5:
		RudolphNose.visible = true

func weapon_changed(new_weapon_index: int):
	selected1.visible = false
	selected2.visible = false
	selected3.visible = false
	selected4.visible = false
	selected5.visible = false
	
	match new_weapon_index:
		1:
			selected1.visible = true
		2:
			selected2.visible = true
		3:
			selected3.visible = true
		4:
			selected4.visible = true
		5:
			selected5.visible = true
		_:
			pass
