extends Panel

@onready var text = $VBoxContainer/RichTextLabel
@onready var accept = $VBoxContainer/HBoxContainer/AcceptButton
@onready var reject = $VBoxContainer/HBoxContainer/RejectButton
@onready var complete = $VBoxContainer/HBoxContainer/CompleteButton


func open_dialog():

	visible = true

	match QuestManager.state:

		QuestManager.QuestState.NOT_STARTED:

			text.text = "Can you gather some supplies for me?"

			accept.visible = true
			reject.visible = true
			complete.visible = false

		QuestManager.QuestState.ACTIVE:

			text.text = "Please come back when you've collected everything."

			accept.visible = false
			reject.visible = true
			complete.visible = false

		QuestManager.QuestState.READY_TO_COMPLETE:

			text.text = "Wonderful! You found everything."

			accept.visible = false
			reject.visible = false
			complete.visible = true

		QuestManager.QuestState.COMPLETED:

			text.text = "Thank you again!"

			accept.visible = false
			reject.visible = true
			complete.visible = false


func _on_accept_button_pressed():
	QuestManager.start_quest()
	visible = false


func _on_reject_button_pressed():
	visible = false


func _on_complete_button_pressed():
	QuestManager.complete_quest()
	visible = false
