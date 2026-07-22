extends Node

enum QuestState {
	NOT_STARTED,
	ACTIVE,
	READY_TO_COMPLETE,
	COMPLETED
}

var state = QuestState.NOT_STARTED

# Item requirements
var required_items = {
	"Parsnip": 7,
	"Mushroom": 7,
	"Fish": 5,
	"Plates": 1,
	"Forks": 1,
	"Knives": 1,
	"Tomato": 5,
	"Carrot": 5,
	"Corn": 5,
	"Milk": 1
}

# Player inventory for this quest
var collected_items = {}

signal quest_started
signal inventory_changed
signal quest_ready
signal quest_completed


func start_quest():
	state = QuestState.ACTIVE

	collected_items.clear()

	for item in required_items.keys():
		collected_items[item] = 0

	quest_started.emit()
	inventory_changed.emit()


func add_item(item_name):

	if state != QuestState.ACTIVE:
		return

	if !required_items.has(item_name):
		return

	collected_items[item_name] += 1

	inventory_changed.emit()

	check_completion()


func check_completion():

	for item in required_items.keys():

		if collected_items[item] < required_items[item]:
			return

	state = QuestState.READY_TO_COMPLETE
	quest_ready.emit()


func complete_quest():

	state = QuestState.COMPLETED

	quest_completed.emit()
