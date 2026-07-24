extends Panel


@onready var axe_name = $RecipeContainer/RecipeCard/Info/Name
@onready var requirements = $RecipeContainer/RecipeCard/Info/Requirements
@onready var axe_icon = $RecipeContainer/RecipeCard/AxeIcon


func _ready():

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

			requirements.text = "Requires:\n10 Tree1 Logs"


		"Tree2 Axe":

			axe_name.text = "Tree2 Axe"

			requirements.text = "Requires:\n20 Tree1 Logs\n20 Tree2 Logs"


		"Tree3 Axe":

			axe_name.text = "Tree3 Axe"

			requirements.text = "Requires:\n30 Tree1 Logs\n30 Tree2 Logs\n30 Tree3 Logs"


		"Super Saiyan Axe":

			axe_name.text = "Super Saiyan Axe"

			requirements.text = "Requires:\n1 Tree4 Log"


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
