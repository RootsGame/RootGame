extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Level1_pressed():
	get_tree().change_scene("res://Level.tscn")


func _on_Level2_pressed():
	get_tree().change_scene("res://Level.tscn")


func _on_Level3_pressed():
	get_tree().change_scene("res://Level.tscn")


func _on_Level4_pressed():
	get_tree().change_scene("res://Level.tscn")


func _on_Level5_pressed():
	get_tree().change_scene("res://Level.tscn")


func _on_Level6_pressed():
	get_tree().change_scene("res://Level.tscn")


func _on_Level7_pressed():
	get_tree().change_scene("res://Level.tscn")


func _on_BackToMenu_pressed():
	get_tree().change_scene("res://Menu.tscn")
