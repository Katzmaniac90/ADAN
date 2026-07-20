extends Panel

@onready var label = $InventoryLabel

var player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	GameManager.inventory_changed.connect(update_inventory)

	update_inventory()


func update_inventory():
	label.text = "Inventory\n\n"

	for item in GameManager.inventory:
		label.text += item + ": " + str(GameManager.inventory[item]) + "\n"
