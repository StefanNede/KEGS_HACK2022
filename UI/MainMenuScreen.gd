extends CanvasLayer


func _on_PlayCampaign_pressed():
	get_tree().change_scene("res://levels/Level2.tscn")


func _on_PlaySurvival_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
