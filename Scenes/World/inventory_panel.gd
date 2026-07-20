extends Panel

@onready var label = $InventoryLabel

var player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.inventory_changed.connect(update_inventory)

	update_inventory()


func update_inventory():
	label.text = "Inventory\n\n"

	for item in player.inventory:
		label.text += item + ": " + str(player.inventory[item]) + "\n"
