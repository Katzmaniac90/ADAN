extends Node

#=================================================
# GREENWOOD SETTINGS
#=================================================

@export var greenwood_active_count: int = 7


#=================================================
# GREENWOOD DATA
#=================================================

var greenwood_spawn_points: Array[Node] = []
var occupied_greenwood_points: Dictionary = {}


#=================================================
# READY
#=================================================

func _ready():

	print("================================")
	print("RESOURCE SPAWN MANAGER IS RUNNING")
	print("================================")

	spawn_greenwood()


#=================================================
# INITIAL GREENWOOD SPAWN
#=================================================

func spawn_greenwood():

	var trees = get_tree().get_nodes_in_group("Greenwood")
	var spawn_points = get_tree().get_nodes_in_group("GreenwoodSpawn")

	print("Greenwood trees found: ", trees.size())
	print("Greenwood spawn points found: ", spawn_points.size())


	if trees.is_empty():

		print("ERROR: No Greenwood trees found.")

		return


	if spawn_points.is_empty():

		print("ERROR: No Greenwood spawn points found.")

		return


	greenwood_spawn_points = spawn_points


	var available_points = greenwood_spawn_points.duplicate()

	var amount_to_spawn = min(
		greenwood_active_count,
		min(trees.size(), available_points.size())
	)


	for i in range(amount_to_spawn):

		var random_index = randi_range(
			0,
			available_points.size() - 1
		)

		var spawn_point = available_points[random_index]

		available_points.remove_at(random_index)

		var tree = trees[i]

		tree.global_position = spawn_point.global_position
		tree.show()

		occupied_greenwood_points[tree] = spawn_point


#=================================================
# GET AVAILABLE GREENWOOD SPAWN
#=================================================

func get_available_greenwood_spawn(tree):

	var available_points = []

	for point in greenwood_spawn_points:

		if not occupied_greenwood_points.values().has(point):

			available_points.append(point)


	if available_points.is_empty():

		print("No available Greenwood spawn points!")

		return null


	var random_index = randi_range(
		0,
		available_points.size() - 1
	)

	var spawn_point = available_points[random_index]

	occupied_greenwood_points[tree] = spawn_point

	return spawn_point


#=================================================
# RELEASE GREENWOOD SPAWN
#=================================================

func release_greenwood_spawn(tree):

	if occupied_greenwood_points.has(tree):

		occupied_greenwood_points.erase(tree)
