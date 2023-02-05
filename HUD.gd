extends CanvasLayer


var growth = 0
var roots = 0
var powerups = 0
var goals = 0
var time = 45

onready var timer = get_node("TimeToAchieveGoals")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(time)
	timer.start()
	$BGMusic.play()
	$TextureRect/ActiveRoots.text = String(roots)
	$TextureRect/GrowingCm.text = String(growth)
	$TextureRect/PowerUpsCollected.text = String(powerups)
	$TextureRect2/Label.text = String(goals)

func _process(delta):
	$TextureRect/RemainingTime.text = "%d:%02d" % [floor($TimeToAchieveGoals.time_left / 60), int($TimeToAchieveGoals.time_left) % 60]




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TimeToAchieveGoals_timeout():
	get_tree().change_scene("res://ResultsMenu.tscn")
