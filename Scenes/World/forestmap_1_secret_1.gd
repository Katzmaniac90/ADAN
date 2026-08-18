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


	#=================================================
	# GRANITE RESOURCE SPAWNING
	#=================================================

	var granite_rocks = get_tree().get_nodes_in_group(
		"Granite"
	)

	var granite_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"GraniteSpawn"
	):

		if point is Marker2D:
			granite_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 GRANITE SETUP")
	print("Granite rocks: ", granite_rocks.size())
	print("Granite spawn points: ", granite_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Granite",
		granite_spawn_points,
		granite_rocks
	)


	#=================================================
	# BLOODSTONE RESOURCE SPAWNING
	#=================================================

	var bloodstone_rocks = get_tree().get_nodes_in_group(
		"Bloodstone"
	)

	var bloodstone_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"BloodstoneSpawn"
	):

		if point is Marker2D:
			bloodstone_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 BLOODSTONE SETUP")
	print("Bloodstone rocks: ", bloodstone_rocks.size())
	print("Bloodstone spawn points: ", bloodstone_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Bloodstone",
		bloodstone_spawn_points,
		bloodstone_rocks
	)


	#=================================================
	# VERDANTSTONE RESOURCE SPAWNING
	#=================================================

	var verdantstone_rocks = get_tree().get_nodes_in_group(
		"Verdantstone"
	)

	var verdantstone_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"VerdantstoneSpawn"
	):

		if point is Marker2D:
			verdantstone_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 VERDANTSTONE SETUP")
	print("Verdantstone rocks: ", verdantstone_rocks.size())
	print("Verdantstone spawn points: ", verdantstone_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Verdantstone",
		verdantstone_spawn_points,
		verdantstone_rocks
	)


	#=================================================
	# SHALE RESOURCE SPAWNING
	#=================================================

	var shale_rocks = get_tree().get_nodes_in_group(
		"Shale"
	)

	var shale_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"ShaleSpawn"
	):

		if point is Marker2D:
			shale_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 SHALE SETUP")
	print("Shale rocks: ", shale_rocks.size())
	print("Shale spawn points: ", shale_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Shale",
		shale_spawn_points,
		shale_rocks
	)


	#=================================================
	# TIDESTONE RESOURCE SPAWNING
	#=================================================

	var tidestone_rocks = get_tree().get_nodes_in_group(
		"Tidestone"
	)

	var tidestone_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"TidestoneSpawn"
	):

		if point is Marker2D:
			tidestone_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 TIDESTONE SETUP")
	print("Tidestone rocks: ", tidestone_rocks.size())
	print("Tidestone spawn points: ", tidestone_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Tidestone",
		tidestone_spawn_points,
		tidestone_rocks
	)


	#=================================================
	# BUBBLEFIN RESOURCE SPAWNING
	#=================================================

	var bubblefin_fish = get_tree().get_nodes_in_group(
		"Bubblefin"
	)

	var bubblefin_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"BubblefinSpawn"
	):

		if point is Marker2D:
			bubblefin_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 BUBBLEFIN SETUP")
	print("Bubblefin fish: ", bubblefin_fish.size())
	print("Bubblefin spawn points: ", bubblefin_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Bubblefin",
		bubblefin_spawn_points,
		bubblefin_fish
	)


	#=================================================
	# GLIMMERGILL RESOURCE SPAWNING
	#=================================================

	var glimmergill_fish = get_tree().get_nodes_in_group(
		"Glimmergill"
	)

	var glimmergill_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"GlimmergillSpawn"
	):

		if point is Marker2D:
			glimmergill_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 GLIMMERGILL SETUP")
	print("Glimmergill fish: ", glimmergill_fish.size())
	print("Glimmergill spawn points: ", glimmergill_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Glimmergill",
		glimmergill_spawn_points,
		glimmergill_fish
	)


	#=================================================
	# MOONSCALE RESOURCE SPAWNING
	#=================================================

	var moonscale_fish = get_tree().get_nodes_in_group(
		"Moonscale"
	)

	var moonscale_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"MoonscaleSpawn"
	):

		if point is Marker2D:
			moonscale_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 MOONSCALE SETUP")
	print("Moonscale fish: ", moonscale_fish.size())
	print("Moonscale spawn points: ", moonscale_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Moonscale",
		moonscale_spawn_points,
		moonscale_fish
	)


	#=================================================
	# TIDEFANG RESOURCE SPAWNING
	#=================================================

	var tidefang_fish = get_tree().get_nodes_in_group(
		"Tidefang"
	)

	var tidefang_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"TidefangSpawn"
	):

		if point is Marker2D:
			tidefang_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 TIDEFANG SETUP")
	print("Tidefang fish: ", tidefang_fish.size())
	print("Tidefang spawn points: ", tidefang_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Tidefang",
		tidefang_spawn_points,
		tidefang_fish
	)


	#=================================================
	# LEVIATHAN RESOURCE SPAWNING
	#=================================================

	var leviathan_fish = get_tree().get_nodes_in_group(
		"Leviathan"
	)

	var leviathan_spawn_points: Array[Marker2D] = []

	for point in get_tree().get_nodes_in_group(
		"LeviathanSpawn"
	):

		if point is Marker2D:
			leviathan_spawn_points.append(point)


	print("================================")
	print("FOREST MAP 1 LEVIATHAN SETUP")
	print("Leviathan fish: ", leviathan_fish.size())
	print("Leviathan spawn points: ", leviathan_spawn_points.size())
	print("================================")


	ResourceSpawnManager.setup_resource(
		"Leviathan",
		leviathan_spawn_points,
		leviathan_fish
	)
