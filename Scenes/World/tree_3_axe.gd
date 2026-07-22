extends Button


func _ready():
	GameManager.inventory_changed.connect(update_craft_button)
	update_craft_button()


func _pressed():
	GameManager.craft_tree3_axe()
	update_craft_button()


func update_craft_button():

	# Hide until Tree2 Axe exists
	if GameManager.current_axe != "Tree2 Axe":
		hide()
		return

	show()

	var tree1 = GameManager.get_item_count("Tree1 Log")
	var tree2 = GameManager.get_item_count("Tree2 Log")
	var tree3 = GameManager.get_item_count("Tree3 Log")


	if tree1 >= 30 and tree2 >= 30 and tree3 >= 30:
		text = "Craft Tree3 Axe"
		disabled = false
	else:
		text = "Need Tree1 Logs: %d/30\nNeed Tree2 Logs: %d/30\nNeed Tree3 Logs: %d/30" % [
			tree1,
			tree2,
			tree3
		]
		disabled = true
