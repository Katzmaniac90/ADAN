extends Node

#=================================================
# GREENWOOD SETTINGS
#=================================================

@export var greenwood_active_count: int = 7

#=================================================
# GREENWOOD DATA
#=================================================

var greenwood_spawn_points: Array[Marker2D] = []
var active_greenwood: Array[Node] = []


#=================================================
# SETUP
#=================================================

func setup_greenwood(points: Array[Marker2D], trees: Array[Node]):

	greenwood_spawn_points = points
	active_greenwood = trees

	spawn_greenwood()


#=================================================
# INITIAL SPAWN
#=================================================

func spawn_greenwood():

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

		print(
			"🌳 ",
			tree.name,
			" spawned at ",
			spawn_point.name
		)


#=================================================
# GET AVAILABLE SPAWN
#=================================================

func get_available_greenwood_spawn(tree):

	var available_points = []

	for point in greenwood_spawn_points:

		var point_occupied = false

		for other_tree in active_greenwood:

			if other_tree == tree:
				continue

			if not other_tree.visible:
				continue

			if other_tree.global_position.distance_to(
				point.global_position
			) < 1.0:

				point_occupied = true
				break

		if not point_occupied:
			available_points.append(point)


	if available_points.is_empty():

		print("❌ No available Greenwood spawn point!")

		return null


	var random_index = randi_range(
		0,
		available_points.size() - 1
	)

	return available_points[random_index]


#=================================================
# RELEASE
#=================================================

func release_greenwood_spawn(tree):

	print(
		"🌳 Released spawn point for ",
		tree.name
	)
