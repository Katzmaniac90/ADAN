extends Panel


@onready var level_label = $Barkbreaking/LevelLabel
@onready var xp_label = $Barkbreaking/XPLabel

@onready var rockpunching_level_label = $Rockpunching/LevelLabel
@onready var rockpunching_xp_label = $Rockpunching/XPLabel

@onready var attack_level_label = $Attack/LevelLabel
@onready var attack_xp_label = $Attack/XPLabel

@onready var agility_level_label = $Agility/LevelLabel
@onready var agility_xp_label = $Agility/XPLabel

var dragging := false
var drag_offset := Vector2.ZERO


func _ready():

	show()

	GameManager.barkbreaking_changed.connect(update_barkbreaking)
	GameManager.rockpunching_changed.connect(update_rockpunching)
	GameManager.attack_changed.connect(update_attack)
	GameManager.agility_changed.connect(update_agility)

	update_barkbreaking()
	update_rockpunching()
	update_attack()
	update_agility()



func _unhandled_input(event):

	if event.is_action_pressed("skills"):

		visible = !visible



func update_barkbreaking():

	level_label.text = "Lv. " + str(GameManager.barkbreaking_level)

	var required_xp = GameManager.barkbreaking_level * 100

	xp_label.text = str(GameManager.barkbreaking_xp) + " / " + str(required_xp) + " XP"



func update_rockpunching():

	rockpunching_level_label.text = "Lv. " + str(GameManager.rockpunching_level)

	var required_xp = GameManager.rockpunching_level * 100

	rockpunching_xp_label.text = str(GameManager.rockpunching_xp) + " / " + str(required_xp) + " XP"



func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				dragging = true
				drag_offset = get_global_mouse_position() - global_position

			else:

				dragging = false


	if event is InputEventMouseMotion and dragging:

		global_position = get_global_mouse_position() - drag_offset
func update_attack():

	attack_level_label.text = "Lv. " + str(GameManager.attack_level)

	var required_xp = GameManager.attack_level * 100

	attack_xp_label.text = str(GameManager.attack_xp) + " / " + str(required_xp) + " XP"

func update_agility():

	agility_level_label.text = "Lv. " + str(GameManager.agility_level)

	var required_xp = GameManager.agility_level * 100

	agility_xp_label.text = str(GameManager.agility_xp) + " / " + str(required_xp) + " XP"
