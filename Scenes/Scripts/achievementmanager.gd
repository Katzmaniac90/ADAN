extends Node


signal achievement_unlocked(achievement_id)


var achievements = {

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


	"FIRST_AXE": {
		"name": "First Tool",
		"description": "Craft your first axe",
		"unlocked": false
	},

	"ALL_AXES": {
		"name": "Axe Collector",
		"description": "Craft all four axes",
		"unlocked": false
	},


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


	"FIRST_ENEMY": {
		"name": "First Strike",
		"description": "Smack your first enemy",
		"unlocked": false
	},

	"SMACKING_5": {
		"name": "Street Fighter",
		"description": "Reach Smacking Level 5",
		"unlocked": false
	},

	"SMACKING_10": {
		"name": "Brawler",
		"description": "Reach Smacking Level 10",
		"unlocked": false
	},


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
