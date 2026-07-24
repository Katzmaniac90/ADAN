extends Panel

@onready var axe_icon = $AxeSlot/AxeIcon
@onready var axe_name = $AxeSlot/AxeName
@onready var title = $Title

var dragging = false
var drag_offset = Vector2()


var hands_icon = preload("res://Items/Axes/Hands.png")
var wood_axe_icon = preload("res://Items/Axes/WoodAxe.png")
var tree2_axe_icon = preload("res://Items/Axes/Tree2Axe.png")
var tree3_axe_icon = preload("res://Items/Axes/Tree3Axe.png")
var super_axe_icon = preload("res://Items/Axes/SuperSaiyanAxe.png")


func _ready():

	show()

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



func update_equipment():

	axe_name.text = GameManager.current_axe

	match GameManager.current_axe:

		"Hands":
			axe_icon.texture = hands_icon
			axe_icon.tooltip_text = "Hands"

		"Wood Axe":
			axe_icon.texture = wood_axe_icon
			axe_icon.tooltip_text = "Wood Axe"

		"Tree2 Axe":
			axe_icon.texture = tree2_axe_icon
			axe_icon.tooltip_text = "Tree2 Axe"

		"Tree3 Axe":
			axe_icon.texture = tree3_axe_icon
			axe_icon.tooltip_text = "Tree3 Axe"

		"Super Saiyan Axe":
			axe_icon.texture = super_axe_icon
			axe_icon.tooltip_text = "Super Saiyan Axe"
