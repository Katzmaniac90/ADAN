extends Node

#=================================================
# GREENWOOD SPAWNING
#=================================================

var greenwood_spawn_points: Array[Marker2D] = []
var active_greenwood: Array[Node] = []

@export var greenwood_active_count: int = 7


func setup_greenwood(points: Array[Marker2D], trees: Array[Node]):

	greenwood_spawn_points = points
	active_greenwood = trees

	spawn_greenwood()


func spawn_greenwood():

	var available_points = greenwood_spawn_points.duplicate()

	# Make sure we don't try to spawn more trees than points
	var amount_to_spawn = min(
		greenwood_active_count,
		available_points.size()
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
