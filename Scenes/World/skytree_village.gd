extends Node2D

@onready var ground: TileMapLayer = $GroundLayer

func _ready():

	#=================================================
	# CAMERA LIMITS
	#=================================================

	var used = ground.get_used_rect()
	var tile_size = ground.tile_set.tile_size

	var left = int(used.position.x * tile_size.x)
	var top = int(used.position.y * tile_size.y)
	var right = int((used.position.x + used.size.x) * tile_size.x)
	var bottom = int((used.position.y + used.size.y) * tile_size.y)

	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.set_camera_limits(
			left,
			top,
			right,
			bottom
		)


	#=================================================
	# GREENWOOD
	#=================================================

	var greenwood_trees = get_tree().get_nodes_in_group("Greenwood")
	var greenwood_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group("GreenwoodSpawn"):
		if point is Marker2D:
			greenwood_spawn_points.append(point)

	print("================================")
	print("SECOND MAP GREENWOOD SETUP")
	print("Greenwood trees: ", greenwood_trees.size())
	print("Greenwood spawn points: ", greenwood_spawn_points.size())
	print("================================")

	ResourceSpawnManager.setup_resource(
		"Greenwood",
		greenwood_spawn_points,
		greenwood_trees
	)


	#=================================================
	# IRONBARK
	#=================================================

	var ironbark_trees = get_tree().get_nodes_in_group("Ironbark")
	var ironbark_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group("IronbarkSpawn"):
		if point is Marker2D:
			ironbark_spawn_points.append(point)

	print("================================")
	print("SECOND MAP IRONBARK SETUP")
	print("Ironbark trees: ", ironbark_trees.size())
	print("Ironbark spawn points: ", ironbark_spawn_points.size())
	print("================================")

	ResourceSpawnManager.setup_resource(
		"Ironbark",
		ironbark_spawn_points,
		ironbark_trees
	)


	#=================================================
	# HEARTWOOD
	#=================================================

	var heartwood_trees = get_tree().get_nodes_in_group("Heartwood")
	var heartwood_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group("HeartwoodSpawn"):
		if point is Marker2D:
			heartwood_spawn_points.append(point)

	print("================================")
	print("SECOND MAP HEARTWOOD SETUP")
	print("Heartwood trees: ", heartwood_trees.size())
	print("Heartwood spawn points: ", heartwood_spawn_points.size())
	print("================================")

	ResourceSpawnManager.setup_resource(
		"Heartwood",
		heartwood_spawn_points,
		heartwood_trees
	)


	#=================================================
	# ANCIENTWOOD
	#=================================================

	var ancientwood_trees = get_tree().get_nodes_in_group("Ancientwood")
	var ancientwood_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group("AncientwoodSpawn"):
		if point is Marker2D:
			ancientwood_spawn_points.append(point)

	print("================================")
	print("SECOND MAP ANCIENTWOOD SETUP")
	print("Ancientwood trees: ", ancientwood_trees.size())
	print("Ancientwood spawn points: ", ancientwood_spawn_points.size())
	print("================================")

	ResourceSpawnManager.setup_resource(
		"Ancientwood",
		ancientwood_spawn_points,
		ancientwood_trees
	)


	#=================================================
	# ELDERWOOD
	#=================================================

	var elderwood_trees = get_tree().get_nodes_in_group("Elderwood")
	var elderwood_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group("ElderwoodSpawn"):
		if point is Marker2D:
			elderwood_spawn_points.append(point)

	print("================================")
	print("SECOND MAP ELDERWOOD SETUP")
	print("Elderwood trees: ", elderwood_trees.size())
	print("Elderwood spawn points: ", elderwood_spawn_points.size())
	print("================================")

	ResourceSpawnManager.setup_resource(
		"Elderwood",
		elderwood_spawn_points,
		elderwood_trees
	)
