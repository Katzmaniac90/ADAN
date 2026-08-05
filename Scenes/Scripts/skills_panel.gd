extends Panel


@onready var level_label = $Barkbreaking/LevelLabel
@onready var xp_label = $Barkbreaking/XPLabel

@onready var rockpunching_level_label = $Rockpunching/LevelLabel
@onready var rockpunching_xp_label = $Rockpunching/XPLabel

@onready var smacking_level_label = $Smacking/LevelLabel
@onready var smacking_xp_label = $Smacking/XPLabel

@onready var footwork_level_label = $Footwork/LevelLabel
@onready var footwork_xp_label = $Footwork/XPLabel

@onready var creation_level_label = $Creation/LevelLabel
@onready var creation_xp_label = $Creation/XPLabel

@onready var growcraft_level_label = $Growcraft/LevelLabel
@onready var growcraft_xp_label = $Growcraft/XPLabel

@onready var angling_level_label = $Angling/LevelLabel
@onready var angling_xp_label = $Angling/XPLabel

@onready var heatworking_level_label = $Heatworking/LevelLabel
@onready var heatworking_xp_label = $Heatworking/XPLabel

var dragging := false
var drag_offset := Vector2.ZERO


func _ready():

	UIManager.register_window(self)
	visible = false

	GameManager.barkbreaking_changed.connect(update_barkbreaking)
	GameManager.rockpunching_changed.connect(update_rockpunching)
	GameManager.footwork_changed.connect(update_footwork)
	update_barkbreaking()
	update_rockpunching()
	update_footwork()

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



func _input(event):

	if not visible:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:

		if event.pressed:

			var rect = Rect2(global_position, size)

			if rect.has_point(get_global_mouse_position()):

				dragging = true
				drag_offset = get_global_mouse_position() - global_position

		else:

			dragging = false


	elif event is InputEventMouseMotion and dragging:

		global_position = get_global_mouse_position() - drag_offset

	var viewport_size = get_viewport_rect().size

	global_position.x = clamp(
	global_position.x,
	0,
	viewport_size.x - size.x
	)

	global_position.y = clamp(
	global_position.y,
	0,
	viewport_size.y - size.y
)
func update_smacking():

	smacking_level_label.text = "Lv. " + str(GameManager.smacking_level)

	var required_xp = GameManager.smacking_level * 100

	smacking_xp_label.text = str(GameManager.smacking_xp) + " / " + str(required_xp) + " XP"

func update_footwork():

	footwork_level_label.text = "Lv. " + str(GameManager.footwork_level)

	var required_xp = GameManager.footwork_level * 100

	footwork_xp_label.text = str(GameManager.footwork_xp) + " / " + str(required_xp) + " XP"

func update_coming_soon_skills():

	creation_level_label.text = "Coming Soon"
	creation_xp_label.text = ""

	growcraft_level_label.text = "Coming Soon"
	growcraft_xp_label.text = ""

	angling_level_label.text = "Coming Soon"
	angling_xp_label.text = ""

	heatworking_level_label.text = "Coming Soon"
	heatworking_xp_label.text = ""
func hide_skill(skill_node):

	for child in skill_node.get_children():

		if child is CanvasItem:

			child.hide()
