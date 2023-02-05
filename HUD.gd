extends CanvasLayer


var growth = 0
var roots = 0
var powerups = 0
var time = 0
var goals = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect/RemainingTime.text = String(time)
	$TextureRect/ActiveRoots.text = String(roots)
	$TextureRect/GrowingCm.text = String(growth)
	$TextureRect/PowerUpsCollected.text = String(powerups)
	$TextureRect2/Label.text = String(goals)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
