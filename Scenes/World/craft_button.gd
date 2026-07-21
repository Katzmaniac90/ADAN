extends Button

func _ready():
	GameManager.inventory_changed.connect(update_craft_button)
	update_craft_button()

func _pressed():
	GameManager.craft_wooden_axe()
	update_craft_button()

func update_craft_button():
	var logs = GameManager.get_item_count("Wood Log")

	if GameManager.current_axe == "Wood Axe":
		hide()
		return

	if logs >= 10:
		text = "Craft Wooden Axe"
		disabled = false
	else:
		var needed = 10 - logs
		text = "Need %d more logs\n(Wooden Axe)" % needed
		disabled = true
