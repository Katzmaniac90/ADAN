extends Panel

@onready var level_label = $LevelLabel
@onready var xp_label = $XPLabel


func _ready():

	show()

	GameManager.barkbreaking_changed.connect(update_barkbreaking)

	update_barkbreaking()



func _unhandled_input(event):

	if event.is_action_pressed("skills"):
		visible = !visible



func update_barkbreaking():

	level_label.text = "Lv. " + str(GameManager.barkbreaking_level)

	var required_xp = GameManager.barkbreaking_level * 100

	xp_label.text = str(GameManager.barkbreaking_xp) + " / " + str(required_xp) + " XP"
