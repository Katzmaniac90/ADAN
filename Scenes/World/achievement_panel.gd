extends Panel


@export var achievement_card_scene: PackedScene
@onready var achievement_container = $ScrollContainer/AchievementContainer

var dragging := false
var drag_offset := Vector2.ZERO

var achievements = [
	{
		"name": "First Harvest",
		"description": "Collect your first log.",
		"progress": "0 / 1"
	},
	{
		"name": "Tool Upgrade",
		"description": "Craft your first axe.",
		"progress": "0 / 1"
	},
	{
		"name": "Rocky Start",
		"description": "Punch your first rock.",
		"progress": "0 / 1"
	},
	{
		"name": "First Contact",
		"description": "Smack your first NPC.",
		"progress": "0 / 1"
	}
]


func _ready():

	create_achievements()
	hide()


func create_achievements():

	var y_position = 0


	for achievement in achievements:

		var card = achievement_card_scene.instantiate()

		achievement_container.add_child(card)

		card.position.y = y_position

		card.setup_achievement(
			achievement.name,
			achievement.description,
			achievement.progress
		)

		y_position += 120

func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			get_viewport().set_input_as_handled()

	if event is InputEventMouseButton:

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
