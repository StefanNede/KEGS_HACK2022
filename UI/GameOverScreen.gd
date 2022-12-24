extends CanvasLayer

onready var title = $PanelContainer/MarginContainer/Rows/Title

func set_title(win: bool, custom = ""):
	if custom != "":
		title.text = custom
		title.modulate = Color.aquamarine
	elif win:
		title.text = "YOU WIN!"
		title.modulate = Color.green
	else:
		title.text = "YOU LOST"
		title.modulate = Color.red

func _on_Quit_pressed():
	get_tree().quit()

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/MainMenuScreen.tscn")
 

func _on_LevelSelect_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/LevelSelectScreen.tscn")
