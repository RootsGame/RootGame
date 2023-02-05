extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$BGMusic.play()


func _on_Button_pressed():
	get_tree().change_scene("res://Menu.tscn")

func _on_SelectLevelButton_pressed():
	get_tree().change_scene("res://level.tscn")
