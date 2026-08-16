extends Node

var autosave_timer: Timer
#=================================================
# INVENTORY
#=================================================

var current_axe := "Hands"
var current_pickaxe := "Hands"
var current_fishing_rod := "Hands"
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

signal portal_unlocked(portal_id)

var unlocked_portals: Dictionary = {}


func is_portal_unlocked(portal_id: String) -> bool:

	return unlocked_portals.get(portal_id, false)


func unlock_portal(portal_id: String) -> void:

	unlocked_portals[portal_id] = true

	portal_unlocked.emit(portal_id)
	

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

func get_axe_tier() -> int:

	match current_axe:

		"Hands":
			return 0

		"Wood Wrecker":
			return 1

		"Timber Titan":
			return 2

		"Lumber Lord":
			return 3

		"Barkbreaker":
			return 4

		# Old names - keep these temporarily so
		# existing saves / scripts don't break.
		"Wood Axe":
			return 1

		"Tree2 Axe":
			return 2

		"Tree3 Axe":
			return 3

		"Super Saiyan Axe":
			return 4

	return 0


func get_axe_name(tier: int) -> String:

	match tier:

		0:
			return "Hands"

		1:
			return "Wood Wrecker"

		2:
			return "Timber Titan"

		3:
			return "Lumber Lord"

		4:
			return "Barkbreaker"

	return "Unknown Axe"


func get_next_axe():

	match get_axe_tier():

		0:
			return "Wood Wrecker"

		1:
			return "Timber Titan"

		2:
			return "Lumber Lord"

		3:
			return "Barkbreaker"

		4:
			return "MAX"

	return "MAX"


#=================================================
# AXE TRADING
#=================================================

func get_axe_requirements(axe_name: String) -> Dictionary:

	match axe_name:

		"Wood Wrecker":
			return {
				"Greenwood": 20
			}

		"Timber Titan":
			return {
				"Ironbark": 30,
				"Greenwood": 10
			}

		"Lumber Lord":
			return {
				"Heartwood": 40,
				"Ironbark": 10,
				"Greenwood": 10
			}

		"Barkbreaker":
			return {
				"Ancientwood": 50,
				"Heartwood": 10,
				"Ironbark": 10,
				"Greenwood": 10
			}

	return {}


func can_trade_for_axe(axe_name: String) -> bool:

	var requirements = get_axe_requirements(axe_name)

	if requirements.is_empty():
		return false

	for item_name in requirements:

		if get_item_count(item_name) < requirements[item_name]:
			return false

	return true


func trade_for_axe(axe_name: String) -> bool:

	if not can_trade_for_axe(axe_name):
		return false

	var requirements = get_axe_requirements(axe_name)

	for item_name in requirements:

		inventory[item_name] -= requirements[item_name]

	current_axe = axe_name

	# First axe achievement
	if axe_name == "Wood Wrecker":
		AchievementManager.unlock_if_locked("FIRST_AXE")

	# Best axe achievement
	if axe_name == "Barkbreaker":
		AchievementManager.unlock_if_locked("ALL_AXES")

	inventory_changed.emit()

	MessageManager.send_message(
		"You traded for the " + axe_name + "!"
	)

	return true

#=================================================
# PICKAXES
#=================================================


func get_pickaxe_tier() -> int:

	match current_pickaxe:

		"Hands":
			return 0

		"Rock Wrecker":
			return 1

		"Stone Titan":
			return 2

		"Mining Lord":
			return 3

		"Rock Puncher":
			return 4

	return 0


func get_pickaxe_name(tier: int) -> String:

	match tier:

		0:
			return "Hands"

		1:
			return "Rock Wrecker"

		2:
			return "Stone Titan"

		3:
			return "Mining Lord"

		4:
			return "Rock Puncher"

	return "Unknown Pickaxe"


func get_pickaxe_requirements(pickaxe_name: String) -> Dictionary:

	match pickaxe_name:

		"Rock Wrecker":
			return {
				"Granite": 20
			}

		"Stone Titan":
			return {
				"Bloodstone": 30,
				"Granite": 10
			}

		"Mining Lord":
			return {
				"Verdantstone": 40,
				"Bloodstone": 10,
				"Granite": 10
			}

		"RockPuncher":
			return {
				"Shale": 50,
				"Verdantstone": 10,
				"Bloodstone": 10,
				"Granite": 10
			}

	return {}


func can_trade_for_pickaxe(pickaxe_name: String) -> bool:

	var requirements = get_pickaxe_requirements(
		pickaxe_name
	)

	if requirements.is_empty():
		return false

	for item_name in requirements:

		if get_item_count(item_name) < requirements[item_name]:
			return false

	return true


func trade_for_pickaxe(pickaxe_name: String) -> bool:

	if not can_trade_for_pickaxe(pickaxe_name):
		return false

	var requirements = get_pickaxe_requirements(
		pickaxe_name
	)

	for item_name in requirements:

		inventory[item_name] -= requirements[item_name]

	current_pickaxe = pickaxe_name

	inventory_changed.emit()

	MessageManager.send_message(
		"You traded for the " + pickaxe_name + "!"
	)

	return true

#=================================================
# FISHING RODS
#=================================================

func get_fishing_rod_tier() -> int:

	match current_fishing_rod:

		"Hands":
			return 0

		"Fishwrecker":
			return 1

		"Reel Titan":
			return 2

		"Angler Lord":
			return 3

		"Fishmaster":
			return 4

	return 0


func get_fishing_rod_name(tier: int) -> String:

	match tier:

		0:
			return "Hands"

		1:
			return "Fishwrecker"

		2:
			return "Reel Titan"

		3:
			return "Angler Lord"

		4:
			return "Fishmaster"

	return "Unknown Fishing Rod"


func get_fishing_rod_requirements(
	fishing_rod_name: String
) -> Dictionary:

	match fishing_rod_name:

		"Fishwrecker":
			return {
				"Bubblefin": 20
			}

		"Reel Titan":
			return {
				"Glimmergill": 30,
				"Bubblefin": 10
			}

		"Angler Lord":
			return {
				"Moonscale": 40,
				"Glimmergill": 10,
				"Bubblefin": 10
			}

		"Fishmaster":
			return {
				"Tidefang": 50,
				"Moonscale": 10,
				"Glimmergill": 10,
				"Bubblefin": 10
			}

	return {}


func can_trade_for_fishing_rod(
	fishing_rod_name: String
) -> bool:

	var requirements = get_fishing_rod_requirements(
		fishing_rod_name
	)

	if requirements.is_empty():
		return false

	for item_name in requirements:

		if get_item_count(item_name) < requirements[item_name]:
			return false

	return true


func trade_for_fishing_rod(
	fishing_rod_name: String
) -> bool:

	if not can_trade_for_fishing_rod(fishing_rod_name):
		return false

	var requirements = get_fishing_rod_requirements(
		fishing_rod_name
	)

	for item_name in requirements:

		inventory[item_name] -= requirements[item_name]

	current_fishing_rod = fishing_rod_name

	inventory_changed.emit()

	MessageManager.send_message(
		"You traded for the " + fishing_rod_name + "!"
	)

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

func xp_message(amount:int, skill_name:String):

	MessageManager.send_message(
		"+" + str(amount) + " " + skill_name + " XP"
	)


#=================================================
# SAVE SYSTEM
#=================================================

const SAVE_PATH = "user://savegame.json"


func save_game():

	print("💾 Saving game...")

	var save_data = {

		# Inventory
		"inventory": inventory,
		"current_axe": current_axe,
		"current_pickaxe": current_pickaxe,
		"current_fishing_rod": current_fishing_rod,

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

	if file == null:

		print("❌ Failed to open save file.")

		return

	file.store_string(
		JSON.stringify(save_data)
	)

	file.close()

	print("💾 Game Saved!")

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

	current_pickaxe = data.get(
		"current_pickaxe",
		"Hands"
)

	current_fishing_rod = data.get(
		"current_fishing_rod",
		"Hands"
)



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

	autosave_timer = Timer.new()
	autosave_timer.wait_time = 30.0
	autosave_timer.one_shot = false

	add_child(autosave_timer)

	autosave_timer.timeout.connect(save_game)

	autosave_timer.start()

	load_game()
	
