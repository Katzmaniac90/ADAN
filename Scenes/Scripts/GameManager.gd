extends Node

#=================================================
# INVENTORY
#=================================================

var current_axe := "Hands"
var inventory := {}

signal inventory_changed


#=================================================
# SKILL SIGNALS
#=================================================

signal barkbreaking_changed
signal rockpunching_changed
signal footwork_changed
signal fishsnatching_changed
signal xp_gained(amount, skill_name)

#=================================================
# SKILL DATA
#=================================================

const MAX_SKILL_LEVEL := 25

var barkbreaking_level := 1
var barkbreaking_xp := 0

var rockpunching_level := 1
var rockpunching_xp := 0

var footwork_level := 1
var footwork_xp := 0
var footwork_steps := 0

var fishsnatching_level := 1
var fishsnatching_xp := 0

#=================================================
# PLAYER DATA
#=================================================

var player_position := Vector2.ZERO


#=================================================
# PORTAL UNLOCKS
#=================================================

signal portal_unlocked

var unlocked_portals: Dictionary = {}


func is_portal_unlocked(portal_id: String) -> bool:

	return unlocked_portals.get(portal_id, false)

func unlock_portal(portal_id: String) -> void:

	unlocked_portals[portal_id] = true

	portal_unlocked.emit()
	

#=================================================
# STAMINA
#=================================================

signal stamina_changed


var max_stamina := 5.0
var current_stamina := 5.0

var stamina_regen := 0.5
var stamina_drain := 1.0

var stamina_recovery_delay := 3.0
var stamina_recovery_timer := 0.0

var can_sprint := true
var stamina_bar_visible := false

#=================================================
# STAMINA FUNCTIONS
#=================================================

func update_stamina(delta):

	if stamina_recovery_timer > 0:

		stamina_recovery_timer -= delta

	else:

		current_stamina += stamina_regen * delta

		current_stamina = min(
			current_stamina,
			max_stamina
		)


	# Allow sprint again once fully recovered
	if current_stamina >= max_stamina * 0.25:

		can_sprint = true


	stamina_changed.emit()



func drain_stamina(delta):

	current_stamina -= stamina_drain * delta

	current_stamina = max(
		current_stamina,
		0
	)


	# Start recovery delay
	stamina_recovery_timer = stamina_recovery_delay


	# Disable sprint when empty
	if current_stamina <= 0:

		can_sprint = false


	stamina_changed.emit()



func increase_max_stamina(amount):

	max_stamina += amount

	current_stamina = max_stamina

	stamina_changed.emit()

func should_show_stamina_bar(sprinting: bool) -> bool:

	if sprinting:
		return false

	if current_stamina >= max_stamina:
		return false

	if current_stamina < max_stamina * 0.25:
		return false

	return true
#=================================================
# XP SYSTEM
#=================================================
func is_skill_maxed(level:int) -> bool:

	return level >= MAX_SKILL_LEVEL
func get_required_xp(level:int) -> int:
	return level * 100
func reached_max_level(skill_name:String):

	MessageManager.send_message(
		skill_name + " has reached MAX LEVEL!"
	)

func process_skill_xp(skill_name:String, xp_amount:int):

	match skill_name:


		"Barkbreaking":

			barkbreaking_xp += xp_amount

			while barkbreaking_xp >= get_required_xp(barkbreaking_level) and barkbreaking_level < MAX_SKILL_LEVEL:

				barkbreaking_xp -= get_required_xp(barkbreaking_level)
				barkbreaking_level += 1

				MessageManager.level_up_message(
					"Barkbreaking",
					barkbreaking_level
				)

			match barkbreaking_level:
				5:
					AchievementManager.unlock_if_locked("BARKBREAKING_5")
				10:
					AchievementManager.unlock_if_locked("BARKBREAKING_10")
				15:
					AchievementManager.unlock_if_locked("BARKBREAKING_15")
				20:
					AchievementManager.unlock_if_locked("BARKBREAKING_20")
				25:
					AchievementManager.unlock_if_locked("BARKBREAKING_25")

			if barkbreaking_level == MAX_SKILL_LEVEL:

				reached_max_level("Barkbreaking")


			barkbreaking_changed.emit()



		"Rockpunching":

			rockpunching_xp += xp_amount

			while rockpunching_xp >= get_required_xp(rockpunching_level) and rockpunching_level < MAX_SKILL_LEVEL:

				rockpunching_xp -= get_required_xp(rockpunching_level)
				rockpunching_level += 1

				MessageManager.level_up_message(
					"Rockpunching",
					rockpunching_level
				)

			match rockpunching_level:
				5:
					AchievementManager.unlock_if_locked("ROCKPUNCHING_5")
				10:
					AchievementManager.unlock_if_locked("ROCKPUNCHING_10")
				15:
					AchievementManager.unlock_if_locked("ROCKPUNCHING_15")
				20:
					AchievementManager.unlock_if_locked("ROCKPUNCHING_20")
				25:
					AchievementManager.unlock_if_locked("ROCKPUNCHING_25")
			if rockpunching_level == MAX_SKILL_LEVEL:

				reached_max_level("Rockpunching")


			rockpunching_changed.emit()



		"Footwork":

			footwork_xp += xp_amount

			while footwork_xp >= get_required_xp(footwork_level) and footwork_level < MAX_SKILL_LEVEL:

				footwork_xp -= get_required_xp(footwork_level)
				footwork_level += 1

				increase_max_stamina(1)

				MessageManager.level_up_message(
					"Footwork",
					footwork_level
				)

			match footwork_level:
				5:
					AchievementManager.unlock_if_locked("FOOTWORK_5")
				10:
					AchievementManager.unlock_if_locked("FOOTWORK_10")
				15:
					AchievementManager.unlock_if_locked("FOOTWORK_15")
				20:
					AchievementManager.unlock_if_locked("FOOTWORK_20")
				25:
					AchievementManager.unlock_if_locked("FOOTWORK_25")
			if footwork_level == MAX_SKILL_LEVEL:

				reached_max_level("Footwork")


			footwork_changed.emit()
			
		"Fishsnatching":

			fishsnatching_xp += xp_amount

			while fishsnatching_xp >= get_required_xp(fishsnatching_level) and fishsnatching_level < MAX_SKILL_LEVEL:

				fishsnatching_xp -= get_required_xp(fishsnatching_level)
				fishsnatching_level += 1

				MessageManager.level_up_message(
					"Fishsnatching",
					fishsnatching_level
				)
				match fishsnatching_level:
					5:
						AchievementManager.unlock_if_locked("FISHSNATCHING_5")
					10:
						AchievementManager.unlock_if_locked("FISHSNATCHING_10")
					15:
						AchievementManager.unlock_if_locked("FISHSNATCHING_15")
					20:
						AchievementManager.unlock_if_locked("FISHSNATCHING_20")
					25:
						AchievementManager.unlock_if_locked("FISHSNATCHING_25")
			if fishsnatching_level == MAX_SKILL_LEVEL:

				reached_max_level("Fishsnatching")

			fishsnatching_changed.emit()

func add_item(item_name:String, amount:int):

	if inventory.has(item_name):
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount

	MessageManager.loot_message(item_name, amount)

	inventory_changed.emit()

func get_item_count(item_name:String) -> int:

	return inventory.get(item_name,0)
	
func check_skill_achievements():

	if barkbreaking_level >= 5:
		AchievementManager.unlock_if_locked("BARKBREAKING_5")

	if barkbreaking_level >= 10:
		AchievementManager.unlock_if_locked("BARKBREAKING_10")

	if barkbreaking_level >= 15:
		AchievementManager.unlock_if_locked("BARKBREAKING_15")

	if barkbreaking_level >= 20:
		AchievementManager.unlock_if_locked("BARKBREAKING_20")

	if barkbreaking_level >= 25:
		AchievementManager.unlock_if_locked("BARKBREAKING_25")


	if rockpunching_level >= 5:
		AchievementManager.unlock_if_locked("ROCKPUNCHING_5")

	if rockpunching_level >= 10:
		AchievementManager.unlock_if_locked("ROCKPUNCHING_10")

	if rockpunching_level >= 15:
		AchievementManager.unlock_if_locked("ROCKPUNCHING_15")

	if rockpunching_level >= 20:
		AchievementManager.unlock_if_locked("ROCKPUNCHING_20")

	if rockpunching_level >= 25:
		AchievementManager.unlock_if_locked("ROCKPUNCHING_25")


	if footwork_level >= 5:
		AchievementManager.unlock_if_locked("FOOTWORK_5")

	if footwork_level >= 10:
		AchievementManager.unlock_if_locked("FOOTWORK_10")

	if footwork_level >= 15:
		AchievementManager.unlock_if_locked("FOOTWORK_15")

	if footwork_level >= 20:
		AchievementManager.unlock_if_locked("FOOTWORK_20")

	if footwork_level >= 25:
		AchievementManager.unlock_if_locked("FOOTWORK_25")


	if fishsnatching_level >= 5:
		AchievementManager.unlock_if_locked("FISHSNATCHING_5")

	if fishsnatching_level >= 10:
		AchievementManager.unlock_if_locked("FISHSNATCHING_10")

	if fishsnatching_level >= 15:
		AchievementManager.unlock_if_locked("FISHSNATCHING_15")

	if fishsnatching_level >= 20:
		AchievementManager.unlock_if_locked("FISHSNATCHING_20")

	if fishsnatching_level >= 25:
		AchievementManager.unlock_if_locked("FISHSNATCHING_25")


#=================================================
# AXES
#=================================================

func get_axe_tier():

	match current_axe:

		"Hands":
			return 0

		"Wood Axe":
			return 1

		"Tree2 Axe":
			return 2

		"Tree3 Axe":
			return 3

		"Super Saiyan Axe":
			return 4

	return 0

func get_axe_name(tier:int) -> String:

	match tier:
		0:
			return "Hands"
		1:
			return "Wood Axe"
		2:
			return "Tree2 Axe"
		3:
			return "Tree3 Axe"
		4:
			return "Super Saiyan Axe"

	return "Unknown Axe"





func craft_wooden_axe():

	if inventory.get("Tree1 Log",0) < 10:
		return false

	inventory["Tree1 Log"] -= 10
	current_axe = "Wood Axe"
	AchievementManager.unlock_if_locked("FIRST_AXE")
	inventory_changed.emit()

	return true



func craft_tree2_axe():

	if inventory.get("Tree1 Log",0) < 20:
		return false

	if inventory.get("Tree2 Log",0) < 20:
		return false

	inventory["Tree1 Log"] -= 20
	inventory["Tree2 Log"] -= 20

	current_axe = "Tree2 Axe"

	inventory_changed.emit()

	return true



func craft_tree3_axe():

	if inventory.get("Tree1 Log",0) < 30:
		return false

	if inventory.get("Tree2 Log",0) < 30:
		return false

	if inventory.get("Tree3 Log",0) < 30:
		return false

	inventory["Tree1 Log"] -= 30
	inventory["Tree2 Log"] -= 30
	inventory["Tree3 Log"] -= 30

	current_axe = "Tree3 Axe"

	inventory_changed.emit()

	return true



func craft_super_saiyan_axe():

	if inventory.get("Tree4 Log",0) < 1:
		return false

	inventory["Tree4 Log"] -= 1

	current_axe = "Super Saiyan Axe"
	AchievementManager.unlock_if_locked("ALL_AXES")
	inventory_changed.emit()

	return true


#=================================================
# FOOTWORK
#=================================================

#=================================================
# SKILL XP FUNCTIONS
#=================================================

func add_barkbreaking_xp(amount):

	xp_gained.emit(
		amount,
		"Barkbreaking"
	)

	process_skill_xp(
		"Barkbreaking",
		amount
	)



func add_rockpunching_xp(amount):

	xp_gained.emit(
		amount,
		"Rockpunching"
	)

	process_skill_xp(
		"Rockpunching",
		amount
	)


func add_footwork_steps(amount):
	
	if footwork_level >= MAX_SKILL_LEVEL:
		return
	footwork_steps += amount

	if footwork_steps >= 1000:

		footwork_steps -= 1000

		add_footwork_xp(25)



func add_footwork_xp(amount):

	xp_gained.emit(
		amount,
		"Footwork"
	)

	process_skill_xp(
		"Footwork",
		amount
	)

func add_fishsnatching_xp(amount):

	xp_gained.emit(
		amount,
		"Fishsnatching"
	)

	process_skill_xp(
		"Fishsnatching",
		amount
	)
#=================================================
# AXE PROGRESSION
#=================================================

func get_next_axe():

	match current_axe:

		"Hands":
			return "Wood Axe"

		"Wood Axe":
			return "Tree2 Axe"

		"Tree2 Axe":
			return "Tree3 Axe"

		"Tree3 Axe":
			return "Super Saiyan Axe"

		"Super Saiyan Axe":
			return "MAX"

		_:
			return "MAX"

func xp_message(amount:int, skill_name:String):

	MessageManager.send_message(
		"+" + str(amount) + " " + skill_name + " XP"
	)


#=================================================
# SAVE SYSTEM
#=================================================

const SAVE_PATH = "user://savegame.json"


func save_game():

	var save_data = {

		# Inventory
		"inventory": inventory,
		"current_axe": current_axe,

		# Skills
		"skills": {
			"barkbreaking_level": barkbreaking_level,
			"barkbreaking_xp": barkbreaking_xp,

			"rockpunching_level": rockpunching_level,
			"rockpunching_xp": rockpunching_xp,

			"footwork_level": footwork_level,
			"footwork_xp": footwork_xp,
			"footwork_steps": footwork_steps,

			"fishsnatching_level": fishsnatching_level,
			"fishsnatching_xp": fishsnatching_xp,
		},

		# Stamina
		"max_stamina": max_stamina,

		# Player
		"player_position": {
			"x": player_position.x,
			"y": player_position.y
		},

		# Achievements
		"achievements": AchievementManager.save_data(),
		
		# Portals
		"unlocked_portals": unlocked_portals
	}

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	file.store_string(JSON.stringify(save_data))
	file.close()

	print("Game Saved!")

func load_game():

	if not FileAccess.file_exists(SAVE_PATH):

		print("No save found")

		return


	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)


	var data = JSON.parse_string(
		file.get_as_text()
	)

	file.close()


	if data == null:
		return



	# Inventory

	inventory = data["inventory"]

	current_axe = data["current_axe"]



	# Skills

	var skills = data["skills"]


	barkbreaking_level = skills["barkbreaking_level"]
	barkbreaking_xp = skills["barkbreaking_xp"]

	rockpunching_level = skills["rockpunching_level"]
	rockpunching_xp = skills["rockpunching_xp"]


	footwork_level = skills["footwork_level"]
	footwork_xp = skills["footwork_xp"]
	footwork_steps = skills["footwork_steps"]

	fishsnatching_level = skills.get("fishsnatching_level", 1)
	fishsnatching_xp = skills.get("fishsnatching_xp", 0)

	# Stamina

	max_stamina = data["max_stamina"]
	
	# Achievements
	if data.has("achievements"):
		AchievementManager.load_data(data["achievements"])
	
	# Portals
	if data.has("unlocked_portals"):
		unlocked_portals = data["unlocked_portals"]
	
	
	# Make sure achievements match current skill levels
	check_skill_achievements()
	print("Game Loaded!")






func _notification(what):

	if what == NOTIFICATION_WM_CLOSE_REQUEST:

		save_game()

		get_tree().quit()

func _ready():

	GameManager.load_game()
	
