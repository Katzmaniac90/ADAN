extends Panel

@onready var list: RichTextLabel = $VBoxContainer/ItemList
@onready var hide_button: Button = $VBoxContainer/HBoxContainer/HideButton

func _ready():

	visible = false

	QuestManager.quest_started.connect(show_tracker)
	QuestManager.inventory_changed.connect(update_tracker)
	QuestManager.quest_completed.connect(hide_tracker)


func show_tracker():

	visible = true

	update_tracker()


func hide_tracker():

	visible = false


func update_tracker():

	var text := ""

	for item in QuestManager.required_items.keys():

		var have = QuestManager.collected_items[item]
		var need = QuestManager.required_items[item]

		text += "%s : %d / %d\n" % [item, have, need]

	list.text = text
		
func _on_hide_button_pressed():
	list.visible = !list.visible
	
	if list.visible:
		hide_button.text = "Hide"
	else:
		hide_button.text = "Show"
