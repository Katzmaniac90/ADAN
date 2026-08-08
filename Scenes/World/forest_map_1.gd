extends Node2D

@onready var ground: TileMapLayer = $GroundLayer

func _ready():

	#=================================================
	# CAMERA LIMITS
	#=================================================

	# Get the rectangle of tiles that are actually used
	var used = ground.get_used_rect()

	# Size of one tile
	var tile_size = ground.tile_set.tile_size

	# Convert tile coordinates to pixel coordinates
	var left = int(used.position.x * tile_size.x)
	var top = int(used.position.y * tile_size.y)
	var right = int((used.position.x + used.size.x) * tile_size.x)
	var bottom = int((used.position.y + used.size.y) * tile_size.y)

	# Find the player
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.set_camera_limits(left, top, right, bottom)


	#=================================================
	# GREENWOOD RESOURCE SPAWNING
	#=================================================

	var trees = get_tree().get_nodes_in_group("Greenwood")
	var spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group("GreenwoodSpawn"):
		if point is Marker2D:
			spawn_points.append(point)

	print("================================")
	print("FOREST MAP 1 GREENWOOD SETUP")
	print("Greenwood trees: ", trees.size())
	print("Greenwood spawn points: ", spawn_points.size())
	print("================================")

	ResourceSpawnManager.setup_greenwood(
		spawn_points,
		trees
	)
