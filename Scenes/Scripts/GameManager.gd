extends Node

#========================
# INVENTORY
#========================

var current_axe = "Hands"
var inventory = {}
signal inventory_changed


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
	if inventory.get("Wood Log", 0) < 10:
		return false

	inventory["Wood Log"] -= 10
	current_axe = "Wood Axe"

	inventory_changed.emit()
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
