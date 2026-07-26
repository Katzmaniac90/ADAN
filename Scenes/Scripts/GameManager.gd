extends Node

#========================
# INVENTORY
#========================

var current_axe = "Hands"


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

		_:
			return 0
var inventory = {}

signal inventory_changed

#========================
# SKILLS
#========================

# Barkbreaking
signal barkbreaking_changed
var barkbreaking_level = 1
var barkbreaking_xp = 0


# Rockpunching
signal rockpunching_changed
var rockpunching_level = 1
var rockpunching_xp = 0


# Smacking
signal smacking_changed
var smacking_level = 1
var smacking_xp = 0


# Footwork
signal footwork_changed
var footwork_level = 1
var footwork_xp = 0
var footwork_steps = 0

#========================
# PLAYER DATA
#========================

var player_position = Vector2.ZERO


#========================
# INVENTORY FUNCTIONS
#========================

func add_item(item_name, amount):
	if inventory.has(item_name):
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount

	inventory_changed.emit()


func get_item_count(item_name):
	return inventory.get(item_name, 0)
	
func craft_wooden_axe():
	if inventory.get("Tree1 Log", 0) < 10:
		return false

	inventory["Tree1 Log"] -= 10
	current_axe = "Wood Axe"

	inventory_changed.emit()
	return true
func craft_tree2_axe():

	if current_axe != "Wood Axe":
		print("Need Wood Axe first!")
		return false

	if inventory.get("Tree1 Log", 0) < 20:
		print("Need 20 Tree1 Logs")
		return false

	if inventory.get("Tree2 Log", 0) < 20:
		print("Need 20 Tree2 Logs")
		return false


	inventory["Tree1 Log"] -= 20
	inventory["Tree2 Log"] -= 20

	current_axe = "Tree2 Axe"

	inventory_changed.emit()

	print("Crafted Tree2 Axe!")
	return true
func craft_tree3_axe():

	if current_axe != "Tree2 Axe":
		print("Need Tree2 Axe first!")
		return false

	if inventory.get("Tree1 Log", 0) < 30:
		print("Need 30 Tree1 Logs")
		return false

	if inventory.get("Tree2 Log", 0) < 30:
		print("Need 30 Tree2 Logs")
		return false

	if inventory.get("Tree3 Log", 0) < 30:
		print("Need 30 Tree3 Logs")
		return false


	inventory["Tree1 Log"] -= 30
	inventory["Tree2 Log"] -= 30
	inventory["Tree3 Log"] -= 30

	current_axe = "Tree3 Axe"

	inventory_changed.emit()

	print("Crafted Tree3 Axe!")
	return true
func craft_super_saiyan_axe():

	if current_axe != "Tree3 Axe":
		print("Need Tree3 Axe first!")
		return false

	if inventory.get("Tree4 Log", 0) < 1:
		print("Need 1 Tree4 Logs")
		return false


	inventory["Tree4 Log"] -= 1

	current_axe = "Super Saiyan Axe"

	inventory_changed.emit()

	print("SUPER SAIYAN AXE CREATED!")
	return true
#========================
# BARKBREAKING
#========================

func add_barkbreaking_xp(amount):

	barkbreaking_xp += amount

	while barkbreaking_xp >= get_required_xp(barkbreaking_level):

		barkbreaking_xp -= get_required_xp(barkbreaking_level)

		barkbreaking_level += 1

		print("Barkbreaking Level:", barkbreaking_level)

	barkbreaking_changed.emit()
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
#========================
# ROCKPUNCHING
#========================
func add_rockpunching_xp(amount):

	rockpunching_xp += amount

	while rockpunching_xp >= get_required_xp(rockpunching_level):

		rockpunching_xp -= get_required_xp(rockpunching_level)

		rockpunching_level += 1

		print("Rockpunching Level:", rockpunching_level)

	rockpunching_changed.emit()
#========================
# SMACKING
#========================
func add_smacking_xp(amount):

	smacking_xp += amount

	while smacking_xp >= get_required_xp(smacking_level):

		smacking_xp -= get_required_xp(smacking_level)

		smacking_level += 1

		print("Smacking Level:", smacking_level)

	smacking_changed.emit()
#========================
# FOOTWORK
#========================

func add_footwork_steps(amount):

	footwork_steps += amount

	# Every 1000 pixels walked = 10 XP
	if footwork_steps >= 1000:

		footwork_xp += 10

		footwork_steps -= 1000

		print("Gained Footwork XP: 10")

		while footwork_xp >= get_required_xp(footwork_level):

			footwork_xp -= get_required_xp(footwork_level)

			footwork_level += 1

			print("Footwork Level:", footwork_level)

		footwork_changed.emit()
func get_required_xp(level):

	return level * 100
