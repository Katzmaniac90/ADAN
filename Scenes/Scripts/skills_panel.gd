extends Panel

@onready var level_label = $LevelLabel
@onready var xp_label = $XPLabel


func _ready():

	show()

	GameManager.barkbreaking_changed.connect(update_barkbreaking)

	update_barkbreaking()



func _unhandled_input(event):

	if event.is_action_pressed("skills"):
		visible = !visible



func update_barkbreaking():

	level_label.text = "Lv. " + str(GameManager.barkbreaking_level)

	var required_xp = GameManager.barkbreaking_level * 100

	xp_label.text = str(GameManager.barkbreaking_xp) + " / " + str(required_xp) + " XP"
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
