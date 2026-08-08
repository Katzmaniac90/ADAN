extends Panel


@onready var inventory_grid = $InventoryScroll/InventoryGrid


var item_slot_scene = preload("res://Scenes/World/Item_Slot.tscn")


var item_textures = {

	# Logs
	"Greenwood": preload("res://Items/Logs/Tree1Log.png"),
	"Ironbark": preload("res://Items/Logs/Tree2Log.png"),
	"Heartwood": preload("res://Items/Logs/Tree3Log.png"),
	"Ancientwood": preload("res://Items/Logs/Tree4Log.png"),
	"Elderwood": preload("res://Items/Logs/Tree5Log.png"),

	# Rocks
	"Granite": preload("res://Items/Rocks/Rock1rock.png"),
	"Bloodstone": preload("res://Items/Rocks/Rock2rock.png"),
	"Verdantstone": preload("res://Items/Rocks/Rock3rock.png"),
	"Shale": preload("res://Items/Rocks/Rock4rock.png"),
	"Tidestone": preload("res://Items/Rocks/Rock5rock.png"),

	# Fish
	"Bubblefin": preload("res://Items/Fish/Bubble1fish.png"),
	"Glimmergill": preload("res://Items/Fish/Bubble2fish.png"),
	"Moonscale": preload("res://Items/Fish/Bubble3fish.png"),
	"Tidefang": preload("res://Items/Fish/Bubble4fish.png"),
	"Leviathan": preload("res://Items/Fish/Bubble5fish.png")
}



func _ready():

	UIManager.register_window(self)
	# Bag is open when game starts
	hide()

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
var dragging := false
var drag_offset := Vector2.ZERO


func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				dragging = true
				drag_offset = get_global_mouse_position() - global_position

			else:

				dragging = false

	if event is InputEventMouseMotion and dragging:

		global_position = get_global_mouse_position() - drag_offset

		var viewport_size = get_viewport_rect().size

		global_position.x = clamp(
			global_position.x,
			0,
			viewport_size.x - size.x
		)

		global_position.y = clamp(
			global_position.y,
			0,
			viewport_size.y - size.y
		)
