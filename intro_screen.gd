extends Control


func _ready():

	# Pause the game until choice is made
	get_tree().paused = true


func _on_play_button_pressed():

	get_tree().paused = false
	hide()


func _on_tutorial_button_pressed():

	hide()

	$"../TutorialScreen".show_tutorial()
