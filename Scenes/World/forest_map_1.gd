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

		player.set_camera_limits(
			left,
			top,
			right,
			bottom
		)


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


	ResourceSpawnManager.setup_resource(
		"Greenwood",
		spawn_points,
		trees
	)


	#=================================================
	# IRONBARK RESOURCE SPAWNING
	#=================================================

	var ironbark_trees = get_tree().get_nodes_in_group(
		"Ironbark"
	)

	var ironbark_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"IronbarkSpawn"
	):

		if point is Marker2D:
			ironbark_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 IRONBARK SETUP")
	print("Ironbark trees: ", ironbark_trees.size())
	print("Ironbark spawn points: ", ironbark_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Ironbark",
		ironbark_spawn_points,
		ironbark_trees
	)


	#=================================================
	# HEARTWOOD RESOURCE SPAWNING
	#=================================================

	var heartwood_trees = get_tree().get_nodes_in_group(
		"Heartwood"
	)

	var heartwood_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"HeartwoodSpawn"
	):

		if point is Marker2D:
			heartwood_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 HEARTWOOD SETUP")
	print("Heartwood trees: ", heartwood_trees.size())
	print("Heartwood spawn points: ", heartwood_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Heartwood",
		heartwood_spawn_points,
		heartwood_trees
	)


	#=================================================
	# ANCIENTWOOD RESOURCE SPAWNING
	#=================================================

	var ancientwood_trees = get_tree().get_nodes_in_group(
		"Ancientwood"
	)

	var ancientwood_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"AncientwoodSpawn"
	):

		if point is Marker2D:
			ancientwood_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 ANCIENTWOOD SETUP")
	print("Ancientwood trees: ", ancientwood_trees.size())
	print("Ancientwood spawn points: ", ancientwood_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Ancientwood",
		ancientwood_spawn_points,
		ancientwood_trees
	)


	#=================================================
	# ELDERWOOD RESOURCE SPAWNING
	#=================================================

	var elderwood_trees = get_tree().get_nodes_in_group(
		"Elderwood"
	)

	var elderwood_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"ElderwoodSpawn"
	):

		if point is Marker2D:
			elderwood_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 ELDERWOOD SETUP")
	print("Elderwood trees: ", elderwood_trees.size())
	print("Elderwood spawn points: ", elderwood_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Elderwood",
		elderwood_spawn_points,
		elderwood_trees
	)
