extends Node2D

export(PackedScene) var root_scene = preload("res://Level/root.tscn")


export(float) var character_speed = 10.0
var path = []
var moving = false

var map
var update_time : float = 1.0/10.0
var running_time : float = 0.0


onready var character = $Character


func _ready():
	# use call deferred to make sure the entire SceneTree Nodes are setup
	# else yield on 'physics_frame' in a _ready() might get stuck
	call_deferred("setup_navserver")
	randomize()


func _process(delta):
	var walk_distance = character_speed * delta
	
	running_time += delta;
	
	if running_time >= update_time :
		spawn_root(character.position)
		running_time = 0.0
	
	move_along_path(walk_distance)
	update()
	
	get_node("EndRoute/PathFollow2D").set_offset(randi())
	if !moving :
		_update_navigation_path(character.position, get_node("EndRoute/PathFollow2D").position)


# The "click" event is a custom input action defined in
# Project > Project Settings > Input Map tab.
func _unhandled_input(event):
	if not event.is_action_pressed("click"):
		return
	_update_navigation_path(character.position, get_local_mouse_position())
		

func setup_navserver():

	# create a new navigation map
	map = Navigation2DServer.map_create()
	Navigation2DServer.map_set_active(map, true)

	# create a new navigation region and add it to the map
	var region = Navigation2DServer.region_create()
	Navigation2DServer.region_set_transform(region, Transform())
	Navigation2DServer.region_set_map(region, map)

	# sets navigation mesh for the region
	var navigation_poly = NavigationMesh.new()
	navigation_poly = $Navmesh.navpoly
	Navigation2DServer.region_set_navpoly(region, navigation_poly)

	# wait for Navigation2DServer sync to adapt to made changes
	yield(get_tree(), "physics_frame")


func move_along_path(distance):
	var last_point = character.position
		
	while path.size():
		moving = true
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			character.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	character.position = last_point
	moving = false
	
	set_process(false)


func _update_navigation_path(start_position, end_position):
	# map_get_path is part of the avigation2DServer class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = Navigation2DServer.map_get_path(map,start_position, end_position, true)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	set_process(true)


func _draw():
	# This draw a white circle with radius of 10px for each point in the path
	#print(character.position)
	draw_circle(character.position, 10, Color(1, 1, 1))
	for p in path:
		draw_circle(p, 10, Color(1, 1, 1))

func spawn_root(position):
	var instance = root_scene.instance()
	instance.global_position = position
	add_child(instance)
