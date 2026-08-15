extends Panel

@onready var axe_icon = $AxeSlot/AxeIcon
@onready var axe_name = $AxeSlot/AxeName

@onready var pickaxe_icon = $PickaxeSlot/PickaxeIcon
@onready var pickaxe_name = $PickaxeSlot/PickaxeName

@onready var fishing_rod_icon = $FishingrodSlot/FishingrodIcon
@onready var fishing_rod_name = $FishingrodSlot/FishingrodName

@onready var title = $Title


var dragging := false
var drag_offset := Vector2.ZERO


#=================================================
# AXE ICONS
#=================================================

var hands_icon = preload("res://Items/Axes/Hands.png")
var wood_axe_icon = preload("res://Items/Axes/Woodwrecker.png")
var tree2_axe_icon = preload("res://Items/Axes/Timbertitan.png")
var tree3_axe_icon = preload("res://Items/Axes/Lumberlord.png")
var super_axe_icon = preload("res://Items/Axes/Barkbreaker.png")


#=================================================
# PICKAXE ICONS
#=================================================

var hands_pickaxe_icon = preload("res://Items/Axes/Hands.png")
var rock_wrecker_icon = preload("res://Items/Pickaxes/RockWrecker.png")
var stone_titan_icon = preload("res://Items/Pickaxes/StoneTitan.png")
var mining_lord_icon = preload("res://Items/Pickaxes/MiningLord.png")
var rockpuncher_icon = preload("res://Items/Pickaxes/Rockpuncher.png")


#=================================================
# FISHING ROD ICONS
#=================================================

var hands_fishing_icon = preload("res://Items/Axes/Hands.png")
var fishwrecker_icon = preload("res://Items/Fishingrods/Fishwrecker.png")
var reel_titan_icon = preload("res://Items/Fishingrods/Reeltitan.png")
var angler_lord_icon = preload("res://Items/Fishingrods/Anglerlord.png")
var fishmaster_icon = preload("res://Items/Fishingrods/Fishmaster.png")


#=================================================
# READY
#=================================================

func _ready():

	UIManager.register_window(self)
	hide()

	GameManager.inventory_changed.connect(update_equipment)

	update_equipment()


#=================================================
# OPEN / CLOSE
#=================================================

func _unhandled_input(event):

	if event.is_action_pressed("equipment"):

		visible = !visible


#=================================================
# DRAGGING
#=================================================

func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				dragging = true

				drag_offset = (
					get_global_mouse_position()
					- global_position
				)

			else:

				dragging = false


	if event is InputEventMouseMotion and dragging:

		global_position = (
			get_global_mouse_position()
			- drag_offset
		)

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


#=================================================
# UPDATE ALL EQUIPMENT
#=================================================

func update_equipment():

	update_axe()

	update_pickaxe()

	update_fishing_rod()


#=================================================
# AXE
#=================================================

func update_axe():

	axe_name.text = GameManager.current_axe

	match GameManager.current_axe:

		"Hands":

			axe_icon.texture = hands_icon
			axe_icon.tooltip_text = "Hands"

		"Wood Wrecker":

			axe_icon.texture = wood_axe_icon
			axe_icon.tooltip_text = "Wood Wrecker"

		"Timber Titan":

			axe_icon.texture = tree2_axe_icon
			axe_icon.tooltip_text = "Timber Titan"

		"Lumber Lord":

			axe_icon.texture = tree3_axe_icon
			axe_icon.tooltip_text = "Lumber Lord"

		"Barkbreaker":

			axe_icon.texture = super_axe_icon
			axe_icon.tooltip_text = "Barkbreaker"


#=================================================
# PICKAXE
#=================================================

func update_pickaxe():

	pickaxe_name.text = GameManager.current_pickaxe

	match GameManager.current_pickaxe:

		"Hands":

			pickaxe_icon.texture = hands_pickaxe_icon
			pickaxe_icon.tooltip_text = "Hands"

		"Rock Wrecker":

			pickaxe_icon.texture = rock_wrecker_icon
			pickaxe_icon.tooltip_text = "Rock Wrecker"

		"Stone Titan":

			pickaxe_icon.texture = stone_titan_icon
			pickaxe_icon.tooltip_text = "Stone Titan"

		"Mining Lord":

			pickaxe_icon.texture = mining_lord_icon
			pickaxe_icon.tooltip_text = "Mining Lord"

		"Rockpuncher":

			pickaxe_icon.texture = rockpuncher_icon
			pickaxe_icon.tooltip_text = "Rockpuncher"


#=================================================
# FISHING ROD
#=================================================

func update_fishing_rod():

	fishing_rod_name.text = GameManager.current_fishing_rod

	match GameManager.current_fishing_rod:

		"Hands":

			fishing_rod_icon.texture = hands_fishing_icon
			fishing_rod_icon.tooltip_text = "Hands"

		"Fishwrecker":

			fishing_rod_icon.texture = fishwrecker_icon
			fishing_rod_icon.tooltip_text = "Fishwrecker"

		"Reel Titan":

			fishing_rod_icon.texture = reel_titan_icon
			fishing_rod_icon.tooltip_text = "Reel Titan"

		"Angler Lord":

			fishing_rod_icon.texture = angler_lord_icon
			fishing_rod_icon.tooltip_text = "Angler Lord"

		"Fishmaster":

			fishing_rod_icon.texture = fishmaster_icon
			fishing_rod_icon.tooltip_text = "Fishmaster"
