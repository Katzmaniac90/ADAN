extends Node

signal message_added(text: String)

func send_message(text: String):
	message_added.emit(text)

func xp_message(amount: int, skill_name: String):
	send_message("+" + str(amount) + " " + skill_name + " XP")

func loot_message(item_name: String, amount: int):
	send_message("Received: " + str(amount) + "x " + item_name)


func level_up_message(skill_name: String, level: int):
	send_message(skill_name + " Level " + str(level) + "!")

func chat_message(text: String):
	send_message(text)
