extends Node2D

export(PackedScene) var root_scene = preload("res://Level/root.tscn")


export(float) var character_speed = 40.0
var path = []
var characterArray = []
var moving = false

var map
var update_time : float = 1.0/10.0
var running_time : float = 0.0

var grownDistance = 0
var newRoot = 600

var blue = preload("res://BluePowerUp.tscn")
var yellow = preload("res://YellowPowerUp.tscn")
var pink = preload("res://PinkPowerUp.tscn")

onready var powerupsamount = 7

onready var character = $Character
onready var area = $PowerUpSpawn

func _ready():
	spawn_powerups(powerupsamount)
	# use call deferred to make sure the entire SceneTree Nodes are setup
	# else yield on 'physics_frame' in a _ready() might get stuck
	call_deferred("setup_navserver")
	randomize()

func spawn_powerups(num):
	for i in range(num):
		randomize()
		var powerups = [blue, yellow, pink]
		var powerup = powerups[randi()% powerups.size()]
		var object = powerup.instance()
		var position = area.rect_position + Vector2(randf() * area.rect_size.x, randf() * area.rect_size.y)
		object.position = position
		add_child(object)


func _process(delta):
	var walk_distance = character_speed * delta
	
	running_time += delta;
	
	if running_time >= update_time :
		spawn_root(character.position)
		if characterArray.size() > 0 :
			for item in characterArray :
				spawn_root(item.position)
		running_time = 0.0
	
	move_along_path(walk_distance, character)
	
	if characterArray.size() > 0 :
		for item in characterArray :
			get_node("EndRoute/PathFollow2D").set_offset(randi())
			move_along_path(walk_distance, item, _update_navigation_path(item.position, get_node("EndRoute/PathFollow2D").position, true))
	
	grownDistance += 1
	
	if 	grownDistance >= newRoot * (characterArray.size() + 1) :
		spawn_new_root(character.position)
		grownDistance = 0
		
	if !character.isMoving :
		get_node("EndRoute/PathFollow2D").set_offset(randi())
		_update_navigation_path(character.position, get_node("EndRoute/PathFollow2D").position)
	
	if characterArray.size() > 0 :
		for item in characterArray :
			if !item.isMoving :
				get_node("EndRoute/PathFollow2D").set_offset(randi())
				_update_navigation_path(item.position, get_node("EndRoute/PathFollow2D").position, true)
	
	update()
	

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


func move_along_path(distance, character, pathParameter = null):
	var last_point = character.position
	var actualPath = []
	
	if pathParameter != null:
		actualPath = pathParameter
	else :
		actualPath = path
		
	while actualPath.size():
		character.isMoving = true
		var distance_between_points = last_point.distance_to(actualPath[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			character.position = last_point.linear_interpolate(actualPath[0], distance / distance_between_points)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = actualPath[0]
		actualPath.remove(0)
	# The character reached the end of the path.
	character.position = last_point
	character.isMoving = false
	
	set_process(false)


func _update_navigation_path(start_position, end_position, child = false):
	# map_get_path is part of the avigation2DServer class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	
	var subPath
		
	if !child :
		path = Navigation2DServer.map_get_path(map,start_position, end_position, true)
		# The first point is always the start_position.
		# We don't need it in this example as it corresponds to the character's position.
		path.remove(0)
	else :
		subPath = Navigation2DServer.map_get_path(map,start_position, end_position, true)
		# The first point is always the start_position.
		# We don't need it in this example as it corresponds to the character's position.
		subPath.remove(0)

	set_process(true)
	
	return subPath
	
#func getNavigationsMaps(start_position, end_position) :
#
#	subPath = Navigation2DServer.map_get_path(map,start_position, end_position, true)
#	# The first point is always the start_position.
#	# We don't need it in this example as it corresponds to the character's position.
#	path.remove(0)
#
#	return Navigation2DServer.map_get_path(map,start_position, end_position, true).remove(0)


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
	
		
func spawn_new_root(position):		
	var existing_sprite = get_node("Character")
	var new_sprite = existing_sprite.duplicate()
	new_sprite.global_position = position
	new_sprite.isMoving = false
	characterArray.append(new_sprite)
	add_child(new_sprite)
