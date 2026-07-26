extends Control


func _ready():

	hide()


func show_tutorial():

	show()


func _on_continue_button_pressed():

	hide()

	get_tree().paused = false
