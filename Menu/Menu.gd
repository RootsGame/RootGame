extends Control

func _ready():
	if not MenuMusic.playing:
		MenuMusic.play()

func _on_SelectLevelButton_pressed():
	MenuMusic.stop()
	get_tree().change_scene("res://level.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()

func _on_Options_pressed():
	get_tree().change_scene("res://OptionsMenu.tscn")
