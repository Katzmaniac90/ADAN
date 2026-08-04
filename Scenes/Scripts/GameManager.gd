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
signal smacking_changed
signal footwork_changed
signal creation_changed
signal growcraft_changed
signal angling_changed
signal heatworking_changed
signal xp_gained(amount, skill_name)

#=================================================
# SKILL DATA
#=================================================

const MAX_SKILL_LEVEL := 25

var barkbreaking_level := 1
var barkbreaking_xp := 0

var rockpunching_level := 1
var rockpunching_xp := 0

var smacking_level := 1
var smacking_xp := 0

var footwork_level := 1
var footwork_xp := 0
var footwork_steps := 0

var creation_level := 1
var creation_xp := 0

var growcraft_level := 1
var growcraft_xp := 0

var angling_level := 1
var angling_xp := 0

var heatworking_level := 1
var heatworking_xp := 0


#=================================================
# PLAYER DATA
#=================================================

var player_position := Vector2.ZERO

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


func add_skill_xp(skill:String, amount:int):

	match skill:

		"barkbreaking":
			barkbreaking_xp += amount
			check_level_up("barkbreaking")

		"rockpunching":
			rockpunching_xp += amount
			check_level_up("rockpunching")

		"smacking":
			smacking_xp += amount
			check_level_up("smacking")

		"footwork":
			footwork_xp += amount
			check_level_up("footwork")

		"creation":
			creation_xp += amount
			check_level_up("creation")

		"growcraft":
			growcraft_xp += amount
			check_level_up("growcraft")

		"angling":
			angling_xp += amount
			check_level_up("angling")

		"heatworking":
			heatworking_xp += amount
			check_level_up("heatworking")



func check_level_up(skill:String):

	var level
	var xp

	match skill:

		"barkbreaking":
			level = barkbreaking_level
			xp = barkbreaking_xp

		"rockpunching":
			level = rockpunching_level
			xp = rockpunching_xp

		"smacking":
			level = smacking_level
			xp = smacking_xp

		"footwork":
			level = footwork_level
			xp = footwork_xp

		"creation":
			level = creation_level
			xp = creation_xp

		"growcraft":
			level = growcraft_level
			xp = growcraft_xp

		"angling":
			level = angling_level
			xp = angling_xp

		"heatworking":
			level = heatworking_level
			xp = heatworking_xp


	while xp >= get_required_xp(level) and level < MAX_SKILL_LEVEL:

		xp -= get_required_xp(level)
		level += 1

	print(skill, "Level:", level)


	match skill:

		"barkbreaking":
			barkbreaking_level = level
			barkbreaking_xp = xp
			barkbreaking_changed.emit()

		"rockpunching":
			rockpunching_level = level
			rockpunching_xp = xp
			rockpunching_changed.emit()

		"smacking":
			smacking_level = level
			smacking_xp = xp
			smacking_changed.emit()

		"footwork":
			footwork_level = level
			footwork_xp = xp
			footwork_changed.emit()

		"creation":
			creation_level = level
			creation_xp = xp
			creation_changed.emit()

		"growcraft":
			growcraft_level = level
			growcraft_xp = xp
			growcraft_changed.emit()

		"angling":
			angling_level = level
			angling_xp = xp
			angling_changed.emit()

		"heatworking":
			heatworking_level = level
			heatworking_xp = xp
			heatworking_changed.emit()


#=================================================
# INVENTORY FUNCTIONS
#=================================================

func add_item(item_name:String, amount:int):

	if inventory.has(item_name):
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount

	MessageManager.loot_message(
		item_name,
		amount
	)

	inventory_changed.emit()



func get_item_count(item_name:String) -> int:

	return inventory.get(item_name,0)


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
	
	if barkbreaking_level >= MAX_SKILL_LEVEL:
		return
	barkbreaking_xp += amount

	xp_gained.emit(amount, "Barkbreaking")

	while barkbreaking_xp >= get_required_xp(barkbreaking_level) and barkbreaking_level < MAX_SKILL_LEVEL:

		barkbreaking_xp -= get_required_xp(barkbreaking_level)
		barkbreaking_level += 1

	MessageManager.level_up_message(
		"Barkbreaking",
		barkbreaking_level
	)
	if barkbreaking_level >= 5:
		AchievementManager.unlock_if_locked("BARKBREAKING_5")

	if barkbreaking_level >= 10:
		AchievementManager.unlock_if_locked("BARKBREAKING_10")

	if barkbreaking_level >= 15:
		AchievementManager.unlock_if_locked("BARKBREAKING_15")

	if barkbreaking_level >= 20:
		AchievementManager.unlock_if_locked("BARKBREAKING_20")

		print("Barkbreaking Level:", barkbreaking_level)

	barkbreaking_changed.emit()



func add_rockpunching_xp(amount):
	
	if rockpunching_level >= MAX_SKILL_LEVEL:
		return
	rockpunching_xp += amount

	xp_gained.emit(
	amount,
	"Rockpunching"
)

	while rockpunching_xp >= get_required_xp(rockpunching_level) and rockpunching_level < MAX_SKILL_LEVEL:

		rockpunching_xp -= get_required_xp(rockpunching_level)
		rockpunching_level += 1

	MessageManager.level_up_message(
	"Rockpunching",
	rockpunching_level
)

	print("Rockpunching Level:", rockpunching_level)
	if rockpunching_level >= 5:
		AchievementManager.unlock_if_locked("ROCKPUNCHING_5")
	rockpunching_changed.emit()



func add_smacking_xp(amount):

	AchievementManager.unlock_if_locked("FIRST_ENEMY")
	
	if smacking_level >= MAX_SKILL_LEVEL:
		return
	smacking_xp += amount

	xp_gained.emit(
		amount,
		"Smacking"
	)

	while smacking_xp >= get_required_xp(smacking_level)and smacking_level < MAX_SKILL_LEVEL:

		smacking_xp -= get_required_xp(smacking_level)
		smacking_level += 1

		MessageManager.level_up_message(
			"Smacking",
			smacking_level
		)

		print("Smacking Level:", smacking_level)

	if smacking_level >= 5:
		AchievementManager.unlock_if_locked("SMACKING_5")

	if smacking_level >= 10:
		AchievementManager.unlock_if_locked("SMACKING_10")

	smacking_changed.emit()



func add_footwork_steps(amount):
	
	if footwork_level >= MAX_SKILL_LEVEL:
		return
	footwork_steps += amount

	if footwork_steps >= 1000:

		footwork_steps -= 1000

		add_footwork_xp(25)



func add_footwork_xp(amount):

	footwork_xp += amount

	xp_gained.emit(
		amount,
		"Footwork"
	)

	AchievementManager.unlock_if_locked("FOOTWORK_1")

	while footwork_xp >= get_required_xp(footwork_level)and footwork_level < MAX_SKILL_LEVEL:

		footwork_xp -= get_required_xp(footwork_level)
		footwork_level += 1
		increase_max_stamina(1)
		
		MessageManager.level_up_message(
			"Footwork",
			footwork_level
		)

		print("Footwork Level:", footwork_level)

	if footwork_level >= 5:
		AchievementManager.unlock_if_locked("FOOTWORK_5")

	if footwork_level >= 10:
		AchievementManager.unlock_if_locked("FOOTWORK_10")

	footwork_changed.emit()



func add_creation_xp(amount):

	creation_xp += amount

	while creation_xp >= get_required_xp(creation_level):

		creation_xp -= get_required_xp(creation_level)
		creation_level += 1

	creation_changed.emit()



func add_growcraft_xp(amount):

	growcraft_xp += amount

	while growcraft_xp >= get_required_xp(growcraft_level):

		growcraft_xp -= get_required_xp(growcraft_level)
		growcraft_level += 1

	growcraft_changed.emit()



func add_angling_xp(amount):

	angling_xp += amount

	while angling_xp >= get_required_xp(angling_level):

		angling_xp -= get_required_xp(angling_level)
		angling_level += 1

	angling_changed.emit()



func add_heatworking_xp(amount):

	heatworking_xp += amount

	while heatworking_xp >= get_required_xp(heatworking_level):

		heatworking_xp -= get_required_xp(heatworking_level)
		heatworking_level += 1

	heatworking_changed.emit()

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

			"smacking_level": smacking_level,
			"smacking_xp": smacking_xp,

			"footwork_level": footwork_level,
			"footwork_xp": footwork_xp,
			"footwork_steps": footwork_steps,

			"creation_level": creation_level,
			"creation_xp": creation_xp,

			"growcraft_level": growcraft_level,
			"growcraft_xp": growcraft_xp,

			"angling_level": angling_level,
			"angling_xp": angling_xp,

			"heatworking_level": heatworking_level,
			"heatworking_xp": heatworking_xp
		},


		# Stamina
		"max_stamina": max_stamina,


		# Player
		"player_position": {
			"x": player_position.x,
			"y": player_position.y
		}
	}


	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	file.store_string(
		JSON.stringify(save_data)
	)

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

	smacking_level = skills["smacking_level"]
	smacking_xp = skills["smacking_xp"]

	footwork_level = skills["footwork_level"]
	footwork_xp = skills["footwork_xp"]
	footwork_steps = skills["footwork_steps"]


	creation_level = skills["creation_level"]
	creation_xp = skills["creation_xp"]

	growcraft_level = skills["growcraft_level"]
	growcraft_xp = skills["growcraft_xp"]

	angling_level = skills["angling_level"]
	angling_xp = skills["angling_xp"]

	heatworking_level = skills["heatworking_level"]
	heatworking_xp = skills["heatworking_xp"]



	# Stamina

	max_stamina = data["max_stamina"]


	print("Game Loaded!")

func _notification(what):

	if what == NOTIFICATION_WM_CLOSE_REQUEST:

		save_game()

		get_tree().quit()

func _ready():

	GameManager.load_game()
