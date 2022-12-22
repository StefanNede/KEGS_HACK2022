extends CanvasLayer


func _on_Level1_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://levels/Level1.tscn")


func _on_Level2_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://levels/Level2.tscn")


func _on_Level3_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://levels/Level3.tscn")


func _on_Level4_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://levels/Level4.tscn")


func _on_Level5_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://levels/Level5.tscn")


func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/MainMenuScreen.tscn")
