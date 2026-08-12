extends Control

var dragging := false
var drag_offset := Vector2.ZERO


func _ready():

	mouse_filter = Control.MOUSE_FILTER_STOP


func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				dragging = true

				drag_offset = (
					get_global_mouse_position()
					- get_parent().global_position
				)

				accept_event()

			else:

				dragging = false

				accept_event()


	if event is InputEventMouseMotion and dragging:

		var panel = get_parent()

		var new_position = (
			get_global_mouse_position()
			- drag_offset
		)

		var viewport_size = get_viewport_rect().size

		new_position.x = clamp(
			new_position.x,
			0,
			viewport_size.x - panel.size.x
		)

		new_position.y = clamp(
			new_position.y,
			0,
			viewport_size.y - panel.size.y
		)

		panel.global_position = new_position

		accept_event()
