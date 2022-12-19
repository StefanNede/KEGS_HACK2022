extends Node2D

class_name WeaponManager

onready var current_weapon = $Pistol

var ammo_left: int = 30
var mag_size: int = 10

var weapons: Array = []

func _ready() -> void:
	weapons = get_children()
	current_weapon.connect("weapon_out_of_ammo", self, "handle_reload")

