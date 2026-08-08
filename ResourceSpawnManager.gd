extends Node

#=================================================
# GREENWOOD SPAWNING
#=================================================

var greenwood_spawn_points: Array[Marker2D] = []
var active_greenwood: Array[Node] = []

@export var greenwood_active_count: int = 7

# Keeps track of which spawn point each tree currently occupies
var occupied_greenwood_points: Dictionary = {}


#=================================================
# SETUP GREENWOOD
#=================================================

func setup_greenwood(points: Array[Marker2D], trees: Array[Node]):

	greenwood_spawn_points = points
	active_greenwood = trees

	# Clear any old spawn assignments
	occupied_greenwood_points.clear()

	spawn_greenwood()


#=================================================
# INITIAL GREENWOOD SPAWN
#=================================================

func spawn_greenwood():

	occupied_greenwood_points.clear()

	var available_points = greenwood_spawn_points.duplicate()

	var amount_to_spawn = min(
		greenwood_active_count,
		min(active_greenwood.size(), available_points.size())
	)

	for i in range(amount_to_spawn):

		var random_index = randi_range(
			0,
			available_points.size() - 1
		)

		var spawn_point = available_points[random_index]

		available_points.remove_at(random_index)

		var tree = active_greenwood[i]

		tree.global_position = spawn_point.global_position
		tree.show()

		occupied_greenwood_points[tree] = spawn_point

		print(
			tree.name,
			" spawned at ",
			spawn_point.name
		)


#=================================================
# GET AVAILABLE GREENWOOD SPAWN
#=================================================

func get_available_greenwood_spawn(tree):

	var available_points = []

	for point in greenwood_spawn_points:

		var occupied = false

		for other_tree in occupied_greenwood_points:

			# Don't count the tree that is currently respawning
			if other_tree == tree:
				continue

			if occupied_greenwood_points[other_tree] == point:
				occupied = true
				break

		if not occupied:
			available_points.append(point)


	if available_points.is_empty():

		print("❌ No available Greenwood spawn points!")

		return null


	var random_index = randi_range(
		0,
		available_points.size() - 1
	)

	var spawn_point = available_points[random_index]

	occupied_greenwood_points[tree] = spawn_point

	print(
		"🌳 ",
		tree.name,
		" assigned to ",
		spawn_point.name
	)

	return spawn_point


#=================================================
# RELEASE GREENWOOD SPAWN
#=================================================

func release_greenwood_spawn(tree):

	if occupied_greenwood_points.has(tree):

		var old_point = occupied_greenwood_points[tree]

		occupied_greenwood_points.erase(tree)

		print(
			"🌳 ",
			tree.name,
			" released ",
			old_point.name
		)

	else:

		print(
			"⚠️ ",
			tree.name,
			" had no recorded Greenwood spawn point."
		)
