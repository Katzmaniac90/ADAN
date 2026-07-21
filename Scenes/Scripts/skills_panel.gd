extends Panel

@onready var level_label = $Label
@onready var xp_bar = $ProgressBar


func _ready():
	update_skill()


func _process(delta):
	update_skill()


func update_skill():
	level_label.text = "Barkbreaking Lv. " + str(GameManager.barkbreaking_level)

	xp_bar.max_value = GameManager.barkbreaking_level * 100
	xp_bar.value = GameManager.barkbreaking_xp
