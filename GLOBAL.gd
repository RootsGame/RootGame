extends Node

onready var powerups : int
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func random(min_number, max_number):
	rng.randomize()
	var random = rng.randf_range(min_number,max_number)
	return random

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
