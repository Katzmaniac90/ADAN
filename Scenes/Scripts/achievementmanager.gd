extends Node


signal achievement_unlocked(achievement_id)




var achievements = {

	#=================================================
	# BARKBREAKING
	#=================================================

	"FIRST_TREE": {
		"name": "First Cut",
		"description": "Break your first tree",
		"unlocked": false
	},

	"BARKBREAKING_5": {
		"name": "Apprentice Lumberjack",
		"description": "Reach Barkbreaking Level 5",
		"unlocked": false
	},

	"BARKBREAKING_10": {
		"name": "Skilled Lumberjack",
		"description": "Reach Barkbreaking Level 10",
		"unlocked": false
	},

	"BARKBREAKING_15": {
		"name": "Master Lumberjack",
		"description": "Reach Barkbreaking Level 15",
		"unlocked": false
	},

	"BARKBREAKING_20": {
		"name": "Forest Legend",
		"description": "Reach Barkbreaking Level 20",
		"unlocked": false
	},

	"BARKBREAKING_25": {
		"name": "Tree Whisperer",
		"description": "Reach Barkbreaking Level 25",
		"unlocked": false
	},


	#=================================================
	# ROCKPUNCHING
	#=================================================

	"FIRST_ROCK": {
		"name": "Rock Breaker",
		"description": "Punch your first rock",
		"unlocked": false
	},

	"ROCKPUNCHING_5": {
		"name": "Stone Apprentice",
		"description": "Reach Rockpunching Level 5",
		"unlocked": false
	},

	"ROCKPUNCHING_10": {
		"name": "Stone Worker",
		"description": "Reach Rockpunching Level 10",
		"unlocked": false
	},

	"ROCKPUNCHING_15": {
		"name": "Stone Master",
		"description": "Reach Rockpunching Level 15",
		"unlocked": false
	},

	"ROCKPUNCHING_20": {
		"name": "Mountain Breaker",
		"description": "Reach Rockpunching Level 20",
		"unlocked": false
	},

	"ROCKPUNCHING_25": {
		"name": "Earth Shatterer",
		"description": "Reach Rockpunching Level 25",
		"unlocked": false
	},


	#=================================================
	# FOOTWORK
	#=================================================

	"FOOTWORK_1": {
		"name": "First Steps",
		"description": "Gain your first Footwork XP",
		"unlocked": false
	},

	"FOOTWORK_5": {
		"name": "Trail Walker",
		"description": "Reach Footwork Level 5",
		"unlocked": false
	},

	"FOOTWORK_10": {
		"name": "Road Runner",
		"description": "Reach Footwork Level 10",
		"unlocked": false
	},

	"FOOTWORK_15": {
		"name": "Path Finder",
		"description": "Reach Footwork Level 15",
		"unlocked": false
	},

	"FOOTWORK_20": {
		"name": "Wind Walker",
		"description": "Reach Footwork Level 20",
		"unlocked": false
	},

	"FOOTWORK_25": {
		"name": "Lightning Feet",
		"description": "Reach Footwork Level 25",
		"unlocked": false
	},
	
	#=================================================
	# FOOTWORK
	#=================================================
	"FIRST_FISH": {
		"name": "First Catch",
		"description": "Snatch your first fish",
		"unlocked": false
	},

	"FISHSNATCHING_5": {
		"name": "River Rookie",
		"description": "Reach Fishsnatching Level 5",
		"unlocked": false
	},

	"FISHSNATCHING_10": {
		"name": "Lake Hunter",
		"description": "Reach Fishsnatching Level 10",
		"unlocked": false
	},

	"FISHSNATCHING_15": {
		"name": "Master Angler",
		"description": "Reach Fishsnatching Level 15",
		"unlocked": false
	},

	"FISHSNATCHING_20": {
		"name": "Sea Stalker",
		"description": "Reach Fishsnatching Level 20",
		"unlocked": false
	},

	"FISHSNATCHING_25": {
		"name": "Legend of the Deep",
		"description": "Reach Fishsnatching Level 25",
		"unlocked": false
	},

	#=================================================
	# COMPLETION
	#=================================================

	"ALL_ACHIEVEMENTS": {
		"name": "ADAN Legend",
		"description": "Obtain all achievements",
		"unlocked": false
	}
}


func unlock(id:String):

	if not achievements.has(id):
		print("Achievement does not exist:", id)
		return

	if achievements[id]["unlocked"]:
		return

	achievements[id]["unlocked"] = true

	print("Achievement unlocked:", achievements[id]["name"])

	achievement_unlocked.emit(id)

	if id == "ALL_ACHIEVEMENTS":

		GameTimer.stop_timer()

	get_tree().call_group(
		"end_screen",
		"show_end_screen"
	)

func is_unlocked(id:String):

	return achievements[id]["unlocked"]

func get_all():

	return achievements

func unlock_if_locked(id: String):
	if achievements.has(id) and !achievements[id]["unlocked"]:
		unlock(id)

func check_all_achievements():

	for id in achievements:

		if id == "ALL_ACHIEVEMENTS":
			continue

		if not achievements[id]["unlocked"]:
			return

	unlock_if_locked("ALL_ACHIEVEMENTS")

func save_data() -> Dictionary:
	return achievements


func load_data(data: Dictionary):

	for id in data:

		if achievements.has(id):
			achievements[id]["unlocked"] = data[id]["unlocked"]
