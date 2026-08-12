extends Panel

@onready var axe_icon = $AxeSlot/AxeIcon
@onready var axe_name = $AxeSlot/AxeName
@onready var title = $Title

var dragging := false
var drag_offset := Vector2.ZERO


var hands_icon = preload("res://Items/Axes/Hands.png")
var wood_axe_icon = preload("res://Items/Axes/Woodwrecker.png")
var tree2_axe_icon = preload("res://Items/Axes/Timbertitan.png")
var tree3_axe_icon = preload("res://Items/Axes/Lumberlord.png")
var super_axe_icon = preload("res://Items/Axes/Barkbreaker.png")


func _ready():

	UIManager.register_window(self)
	hide()

	GameManager.inventory_changed.connect(update_equipment)

	update_equipment()


func _unhandled_input(event):

	if event.is_action_pressed("equipment"):
		visible = !visible


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



func update_equipment():

	axe_name.text = GameManager.current_axe

	match GameManager.current_axe:

		"Hands":
			axe_icon.texture = hands_icon
			axe_icon.tooltip_text = "Hands"

		"Wood Wrecker":
			axe_icon.texture = wood_axe_icon
			axe_icon.tooltip_text = "Wood Wrecker"

		"Timber Titan":
			axe_icon.texture = tree2_axe_icon
			axe_icon.tooltip_text = "Timber Titan"

		"Lumber Lord":
			axe_icon.texture = tree3_axe_icon
			axe_icon.tooltip_text = "Lumber Lord"

		"Barkbreaker":
			axe_icon.texture = super_axe_icon
			axe_icon.tooltip_text = "Barkbreaker"
