extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#$VBoxContainer/SelectLevelButton.grab_focus()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SelectLevelButton_pressed():
	get_tree().change_scene("res://level.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()

func _on_Options_pressed():
	get_tree().change_scene("res://OptionsMenu.tscn")
