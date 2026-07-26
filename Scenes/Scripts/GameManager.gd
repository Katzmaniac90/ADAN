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


#=================================================
# SKILL DATA
#=================================================

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
# XP SYSTEM
#=================================================

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


	while xp >= get_required_xp(level):

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







func craft_wooden_axe():

	if inventory.get("Tree1 Log",0) < 10:
		return false

	inventory["Tree1 Log"] -= 10
	current_axe = "Wood Axe"

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

	inventory_changed.emit()

	return true


#=================================================
# FOOTWORK
#=================================================



#=================================================
# SKILL XP FUNCTIONS
#=================================================

func add_barkbreaking_xp(amount):

	barkbreaking_xp += amount

	while barkbreaking_xp >= get_required_xp(barkbreaking_level):

		barkbreaking_xp -= get_required_xp(barkbreaking_level)
		barkbreaking_level += 1

		print("Barkbreaking Level:", barkbreaking_level)

	barkbreaking_changed.emit()



func add_rockpunching_xp(amount):

	rockpunching_xp += amount

	while rockpunching_xp >= get_required_xp(rockpunching_level):

		rockpunching_xp -= get_required_xp(rockpunching_level)
		rockpunching_level += 1

		print("Rockpunching Level:", rockpunching_level)

	rockpunching_changed.emit()



func add_smacking_xp(amount):

	smacking_xp += amount

	while smacking_xp >= get_required_xp(smacking_level):

		smacking_xp -= get_required_xp(smacking_level)
		smacking_level += 1

		print("Smacking Level:", smacking_level)

	smacking_changed.emit()



func add_footwork_steps(amount):

	footwork_steps += amount

	if footwork_steps >= 1000:

		footwork_steps -= 1000

		add_footwork_xp(10)



func add_footwork_xp(amount):

	footwork_xp += amount

	while footwork_xp >= get_required_xp(footwork_level):

		footwork_xp -= get_required_xp(footwork_level)
		footwork_level += 1

		print("Footwork Level:", footwork_level)

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
