extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	if not MenuMusic.playing:
		MenuMusic.play()
	

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SelectLevelButton_pressed():
	MenuMusic.stop()
	get_tree().change_scene("res://level.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()

func _on_Options_pressed():
	get_tree().change_scene("res://OptionsMenu.tscn")
