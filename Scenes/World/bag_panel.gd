extends Panel


@onready var inventory_grid = $InventoryGrid


var item_slot_scene = preload("res://Scenes/World/Item_Slot.tscn")


var item_textures = {

	"Tree1 Log": preload("res://Items/Logs/Tree1Log.png"),
	"Tree2 Log": preload("res://Items/Logs/Tree2Log.png"),
	"Tree3 Log": preload("res://Items/Logs/Tree3Log.png"),
	"Tree4 Log": preload("res://Items/Logs/Tree4Log.png")

}



func _ready():

	# Bag is open when game starts
	show()

	GameManager.inventory_changed.connect(update_inventory)

	update_inventory()



func _input(event):

	if event.is_action_pressed("bag"):

		visible = !visible



func update_inventory():

	# Remove old item slots
	for child in inventory_grid.get_children():

		child.queue_free()


	# Create new item slots
	for item in GameManager.inventory:

		var amount = GameManager.inventory[item]


		# Only show items that have icons
		if item_textures.has(item):

			var slot = item_slot_scene.instantiate()


			slot.setup_item(
				item,
				amount,
				item_textures[item]
			)


			inventory_grid.add_child(slot)
