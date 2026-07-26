extends Node


var tutorial_active = false


func start_tutorial():

	tutorial_active = true

	print("Tutorial Started")

	show_message("Welcome to Growcraft!\n\nMove around and explore.")


func show_message(message):

	print(message)
