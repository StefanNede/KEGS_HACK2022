extends CanvasLayer


func _on_PlayCampaign_pressed():
	get_tree().change_scene("res://UI/LevelSelectScreen.tscn")


func _on_PlaySurvival_pressed():
	get_tree().change_scene("res://levels/Survival.tscn")

func _on_Quit_pressed():
	get_tree().quit()
