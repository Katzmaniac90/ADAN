extends Button

func _ready():
	GameManager.inventory_changed.connect(update_craft_button)
	update_craft_button()

func _pressed():
	GameManager.craft_wooden_axe()
	update_craft_button()

func update_craft_button():
	var logs = GameManager.inventory.get("Wood Log", 0)
	var needed = max(0, 10 - logs)

	if GameManager.current_axe == "Wood Axe":
		hide()
		return

	if logs >= 10:
		text = "Craft Wooden Axe"
		disabled = false
	else:
		text = "Need %d more logs" % needed
		disabled = true
