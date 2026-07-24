extends Panel


func _ready():

	hide()

	GameManager.inventory_changed.connect(update_recipes)

	update_recipes()


func _input(event):

	if event.is_action_pressed("crafting"):

		visible = !visible


func update_recipes():

	pass
