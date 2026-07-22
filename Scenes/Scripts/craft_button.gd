extends Button


func _ready():
	GameManager.inventory_changed.connect(update_craft_button)
	update_craft_button()


func _pressed():
	GameManager.craft_wooden_axe()
	update_craft_button()


func update_craft_button():

	# Only show while using Hands
	if GameManager.current_axe != "Hands":
		hide()
		return

	show()

	var logs = GameManager.get_item_count("Tree1 Log")


	if logs >= 10:
		text = "Craft Wooden Axe"
		disabled = false
	else:
		var needed = 10 - logs
		text = "Need %d more Tree1 Logs\n(Wooden Axe)" % needed
		disabled = true
