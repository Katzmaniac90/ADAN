extends CanvasLayer


@onready var label = $Panel/Label


func show_message(message):
	label.text = message
	$Panel.visible = true


func hide_message():
	$Panel.visible = false
