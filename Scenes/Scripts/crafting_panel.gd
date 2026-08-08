extends Panel


@onready var axe_name = $RecipeContainer/RecipeCard/Info/Name
@onready var requirements = $RecipeContainer/RecipeCard/Info/Requirements
@onready var axe_icon = $RecipeContainer/RecipeCard/AxeIcon


func _ready():

	UIManager.register_window(self)
	hide()

	GameManager.inventory_changed.connect(update_recipe)

	update_recipe()



func _input(event):

	if event.is_action_pressed("crafting"):

		visible = !visible



func update_recipe():

	var next_axe = GameManager.get_next_axe()


	match next_axe:

		"Wood Axe":

			axe_name.text = "Wood Axe"

			requirements.text = "Requires:\n10 Greenwoods"


		"Tree2 Axe":

			axe_name.text = "Tree2 Axe"

			requirements.text = "Requires:\n20 Greenwoods\n20 Ironbarks"


		"Tree3 Axe":

			axe_name.text = "Tree3 Axe"

			requirements.text = "Requires:\n30 Greenwoods\n30 Ironbarks\n30 Heartwoods"


		"Super Saiyan Axe":

			axe_name.text = "Super Saiyan Axe"

			requirements.text = "Requires:\n1 Ancientwood"


		"MAX":

			axe_name.text = "All Axes Crafted!"

			requirements.text = "You have the best axe!"


func _on_craft_button_pressed():

	var next_axe = GameManager.get_next_axe()


	match next_axe:

		"Wood Axe":
			GameManager.craft_wooden_axe()

		"Tree2 Axe":
			GameManager.craft_tree2_axe()

		"Tree3 Axe":
			GameManager.craft_tree3_axe()

		"Super Saiyan Axe":
			GameManager.craft_super_saiyan_axe()


	update_recipe()
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
