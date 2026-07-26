extends Button


func _ready():
	GameManager.inventory_changed.connect(update_craft_button)
	update_craft_button()


func _pressed():
	GameManager.craft_super_saiyan_axe()
	update_craft_button()


func update_craft_button():

	# Hide until Tree3 Axe exists
	if GameManager.current_axe != "Tree3 Axe":
		hide()
		return

	show()

	var tree4 = GameManager.get_item_count("Tree4 Log")


	if tree4 >= 1:
		text = "Craft Super Saiyan Axe"
		disabled = false
	else:
		text = "Need Tree4 Logs: %d/1" % tree4
		disabled = true
