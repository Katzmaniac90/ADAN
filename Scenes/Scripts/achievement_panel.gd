extends Panel


@export var achievement_card_scene: PackedScene
@onready var achievement_container = $ScrollContainer/AchievementContainer


var dragging := false
var drag_offset := Vector2.ZERO



func _ready():

	create_achievements()
	hide()
	AchievementManager.achievement_unlocked.connect(_on_achievement_unlocked)


func create_achievements():

	var y_position = 0

	for id in AchievementManager.get_all():

		var achievement = AchievementManager.get_all()[id]

		var card = achievement_card_scene.instantiate()

		achievement_container.add_child(card)

		card.position.y = y_position

		card.setup_achievement(
			achievement["name"],
			achievement["description"],
			achievement["unlocked"]
		)

		y_position += 120

	achievement_container.custom_minimum_size.y = y_position

func get_progress_text(achievement):

	if achievement["unlocked"]:

		return "Completed ✓"

	else:

		return "Locked"



func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			get_viewport().set_input_as_handled()


		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				dragging = true
				drag_offset = get_global_mouse_position() - global_position

			else:

				dragging = false



	if event is InputEventMouseMotion and dragging:

		global_position = get_global_mouse_position() - drag_offset



func _unhandled_input(event):

	if event.is_action_pressed("achievements"):

		visible = !visible



func _on_close_button_pressed():

	hide()
func _on_achievement_unlocked(id):

	# Remove the old cards
	for child in achievement_container.get_children():
		child.queue_free()

	# Rebuild the list
	create_achievements()
