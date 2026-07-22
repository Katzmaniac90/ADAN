extends Button


func _ready():
	GameManager.inventory_changed.connect(update_craft_button)
	update_craft_button()


func _pressed():
	GameManager.craft_tree2_axe()
	update_craft_button()


func update_craft_button():

	# Hide until Wood Axe exists
	if GameManager.current_axe != "Wood Axe":
		hide()
		return

	show()

	var tree1 = GameManager.get_item_count("Tree1 Log")
	var tree2 = GameManager.get_item_count("Tree2 Log")


	if tree1 >= 20 and tree2 >= 20:
		text = "Craft Tree2 Axe"
		disabled = false
	else:
		text = "Need Tree1 Logs: %d/20\nNeed Tree2 Logs: %d/20" % [tree1, tree2]
		disabled = true
