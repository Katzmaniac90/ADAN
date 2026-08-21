extends Node

#=================================================
# RESOURCE SETTINGS
#=================================================

@export var greenwood_active_count: int = 7
@export var ironbark_active_count: int = 5
@export var heartwood_active_count: int = 3
@export var ancientwood_active_count: int = 2
@export var elderwood_active_count: int = 1

@export var granite_active_count: int = 5
@export var bloodstone_active_count: int = 4
@export var verdantstone_active_count: int = 3
@export var shale_active_count: int = 2
@export var tidestone_active_count: int = 1

@export var bubblefin_active_count: int = 5
@export var glimmergill_active_count: int = 4
@export var moonscale_active_count: int = 3
@export var tidefang_active_count: int = 2
@export var leviathan_active_count: int = 1


#=================================================
# RESOURCE DATA
#=================================================

var resource_spawn_points: Dictionary = {}
var active_resources: Dictionary = {}


#=================================================
# SETUP RESOURCE
#=================================================

func setup_resource(
	resource_type: String,
	points: Array[Marker2D],
	resources: Array[Node]
):

	resource_spawn_points[resource_type] = points
	active_resources[resource_type] = resources

	spawn_resource(resource_type)


#=================================================
# GET ACTIVE COUNT
#=================================================

func get_active_count(resource_type: String) -> int:

	match resource_type:

		"Greenwood":
			return greenwood_active_count

		"Ironbark":
			return ironbark_active_count

		"Heartwood":
			return heartwood_active_count

		"Ancientwood":
			return ancientwood_active_count

		"Elderwood":
			return elderwood_active_count

		"Granite":
			return granite_active_count

		"Bloodstone":
			return bloodstone_active_count

		"Verdantstone":
			return verdantstone_active_count

		"Shale":
			return shale_active_count

		"Tidestone":
			return tidestone_active_count

		"Bubblefin":
			return bubblefin_active_count

		"Glimmergill":
			return glimmergill_active_count

		"Moonscale":
			return moonscale_active_count

		"Tidefang":
			return tidefang_active_count

		"Leviathan":
			return leviathan_active_count

	return 0


#=================================================
# INITIAL SPAWN
#=================================================

func spawn_resource(resource_type: String):

	if not resource_spawn_points.has(resource_type):

		print(
			"❌ No spawn points registered for ",
			resource_type
		)

		return


	if not active_resources.has(resource_type):

		print(
			"❌ No resources registered for ",
			resource_type
		)

		return


	var spawn_points = resource_spawn_points[resource_type]
	var resources = active_resources[resource_type]

	var available_points = spawn_points.duplicate()
	var resources_to_spawn = resources.duplicate()


	var amount_to_spawn = min(
		get_active_count(resource_type),
		min(
			resources.size(),
			available_points.size()
		)
	)


	#=================================================
	# GUARANTEED NPC RESOURCES
	#=================================================

	#-------------------------------------------------
	# BARRY'S TREE
	#-------------------------------------------------

	if resource_type == "Greenwood":

		var barry_spawn = null

		for point in available_points:

			if point.name == "BarryTreeSpawn":

				barry_spawn = point
				break


		if barry_spawn != null and amount_to_spawn > 0:

			var barry_tree = resources_to_spawn[0]

			barry_tree.global_position = barry_spawn.global_position
			barry_tree.show()

			available_points.erase(barry_spawn)
			resources_to_spawn.erase(barry_tree)

			amount_to_spawn -= 1

			print(
				"🌳 Barry's tree guaranteed at ",
				barry_spawn.name
			)


	#-------------------------------------------------
	# RHONDA'S GRANITE
	#-------------------------------------------------

	if resource_type == "Granite":

		var rhonda_spawn = null

		for point in available_points:

			if point.name == "RhondaRockSpawn":

				rhonda_spawn = point
				break


		if rhonda_spawn != null and amount_to_spawn > 0:

			var rhonda_rock = resources_to_spawn[0]

			rhonda_rock.global_position = rhonda_spawn.global_position
			rhonda_rock.show()

			available_points.erase(rhonda_spawn)
			resources_to_spawn.erase(rhonda_rock)

			amount_to_spawn -= 1

			print(
				"🪨 Rhonda's rock guaranteed at ",
				rhonda_spawn.name
			)


	#=================================================
	# RANDOM SPAWNING
	#=================================================

	for i in range(amount_to_spawn):

		if available_points.is_empty():
			break

		if resources_to_spawn.is_empty():
			break


		var random_point_index = randi_range(
			0,
			available_points.size() - 1
		)

		var spawn_point = available_points[random_point_index]

		available_points.remove_at(random_point_index)


		var resource = resources_to_spawn[0]

		resources_to_spawn.remove_at(0)


		resource.global_position = spawn_point.global_position
		resource.show()


		print(
			"🌱 ",
			resource_type,
			": ",
			resource.name,
			" spawned at ",
			spawn_point.name
		)


#=================================================
# GET AVAILABLE RESOURCE SPAWN
#=================================================

func get_available_resource_spawn(
	resource_type: String,
	resource: Node
):

	if not resource_spawn_points.has(resource_type):

		print(
			"❌ No spawn points registered for ",
			resource_type
		)

		return null


	if not active_resources.has(resource_type):

		print(
			"❌ No resources registered for ",
			resource_type
		)

		return null


	var spawn_points = resource_spawn_points[resource_type]
	var resources = active_resources[resource_type]

	var available_points = []


	# Remember where the resource currently is
	var old_position = resource.global_position


	for point in spawn_points:

		#-----------------------------------------
		# NEVER RETURN TO THE SAME SPAWN POINT
		#-----------------------------------------

		if point.global_position.distance_to(old_position) < 1.0:

			continue


		#-----------------------------------------
		# CHECK IF ANOTHER RESOURCE IS THERE
		#-----------------------------------------

		var point_occupied = false

		for other_resource in resources:

			if other_resource == resource:
				continue

			if not other_resource.visible:
				continue

			if other_resource.global_position.distance_to(
				point.global_position
			) < 1.0:

				point_occupied = true
				break


		if not point_occupied:

			available_points.append(point)


	#-----------------------------------------
	# NO AVAILABLE SPAWN
	#-----------------------------------------

	if available_points.is_empty():

		print(
			"❌ No available ",
			resource_type,
			" spawn point for ",
			resource.name
		)

		return null


	#-----------------------------------------
	# PICK RANDOM AVAILABLE SPAWN
	#-----------------------------------------

	var random_index = randi_range(
		0,
		available_points.size() - 1
	)

	var selected_point = available_points[random_index]


	#-----------------------------------------
	# DEBUG OUTPUT
	#-----------------------------------------

	print(
		"🔄 ",
		resource.name,
		" (",
		resource_type,
		") ",
		"depleted at ",
		old_position,
		" → respawning at ",
		selected_point.name,
		" ",
		selected_point.global_position
	)


	return selected_point


#=================================================
# RELEASE RESOURCE
#=================================================

func release_resource_spawn(
	resource_type: String,
	resource: Node
):

	print(
		"🔓 Released ",
		resource_type,
		" spawn point for ",
		resource.name
	)
