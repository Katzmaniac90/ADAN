extends Node


var open_windows = []


func register_window(window):

	if not open_windows.has(window):
		open_windows.append(window)



func unregister_window(window):

	if open_windows.has(window):
		open_windows.erase(window)



func close_all_windows():

	for window in open_windows:

		if is_instance_valid(window):

			window.hide()

func _unhandled_input(event):

	if event.is_action_pressed("ui_cancel"):

		close_all_windows()

		get_viewport().set_input_as_handled()
