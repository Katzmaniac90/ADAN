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
signal barkbreaking_changed


#========================
# SKILLS
#========================

var barkbreaking_level = 1
var barkbreaking_xp = 0


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

	while barkbreaking_xp >= barkbreaking_level * 100:

		barkbreaking_xp -= barkbreaking_level * 100

		barkbreaking_level += 1

		print("LEVEL UP!")
		print("Barkbreaking Level:", barkbreaking_level)

	barkbreaking_changed.emit()
