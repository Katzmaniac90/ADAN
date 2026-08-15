extends Panel


#=================================================
# FISHING ROD DATA
#=================================================

var fishing_rods = [
	{
		"name": "Hands",
		"power": 0,
		"image": preload("res://Items/Axes/Hands.png")
	},
	{
		"name": "Fishwrecker",
		"power": 5,
		"image": preload("res://Items/Fishingrods/Fishwrecker.png")
	},
	{
		"name": "Reel Titan",
		"power": 10,
		"image": preload("res://Items/Fishingrods/Reeltitan.png")
	},
	{
		"name": "Angler Lord",
		"power": 20,
		"image": preload("res://Items/Fishingrods/Anglerlord.png")
	},
	{
		"name": "Fishmaster",
		"power": 40,
		"image": preload("res://Items/Fishingrods/Fishmaster.png")
	}
]


var current_fishing_rod_index := 0


#=================================================
# READY
#=================================================

func _ready():

	$CloseButton.pressed.connect(_on_close_pressed)

	$PreviousButton.pressed.connect(
		_on_previous_pressed
	)

	$NextButton.pressed.connect(
		_on_next_pressed
	)

	$FishingrodDisplay/ActionButton.pressed.connect(
		_on_action_pressed
	)

	GameManager.inventory_changed.connect(
		_on_inventory_changed
	)

	show_fishing_rod()


#=================================================
# DISPLAY FISHING ROD
#=================================================

func show_fishing_rod():

	var fishing_rod = fishing_rods[current_fishing_rod_index]

	$FishingrodDisplay/FishingrodImage.texture = fishing_rod["image"]

	var fishing_rod_name: String = fishing_rod["name"]


	#-------------------------------
	# Name
	#-------------------------------

	$FishingrodDisplay/FishingrodName.text = fishing_rod_name


	#-------------------------------
	# Stats
	#-------------------------------

	$FishingrodDisplay/FishingrodStats.text = (
		"Fishsnatching Power: "
		+ str(fishing_rod["power"])
	)


	#-------------------------------
	# Requirements
	#-------------------------------

	var requirements = GameManager.get_fishing_rod_requirements(
		fishing_rod_name
	)

	var requirement_text := "REQUIRED MATERIALS\n\n"


	if requirements.is_empty():

		requirement_text = "NO MATERIALS REQUIRED"

	else:

		for item_name in requirements:

			var required_amount = requirements[item_name]

			var player_amount = GameManager.get_item_count(
				item_name
			)

			requirement_text += (
				item_name
				+ ": "
				+ str(player_amount)
				+ " / "
				+ str(required_amount)
				+ "\n"
			)


	$FishingrodDisplay/Requirements.text = requirement_text


	#-------------------------------
	# Status / Button
	#-------------------------------

	if fishing_rod_name == "Hands":

		$FishingrodDisplay/StatusLabel.text = "STARTING TOOL"

		$FishingrodDisplay/ActionButton.text = "EQUIPPED"

		$FishingrodDisplay/ActionButton.disabled = true


	elif GameManager.current_fishing_rod == fishing_rod_name:

		$FishingrodDisplay/StatusLabel.text = "CURRENTLY EQUIPPED"

		$FishingrodDisplay/ActionButton.text = "EQUIPPED"

		$FishingrodDisplay/ActionButton.disabled = true


	elif GameManager.can_trade_for_fishing_rod(fishing_rod_name):

		$FishingrodDisplay/StatusLabel.text = "READY TO TRADE"

		$FishingrodDisplay/ActionButton.text = "TRADE FOR FISHING ROD"

		$FishingrodDisplay/ActionButton.disabled = false


	else:

		$FishingrodDisplay/StatusLabel.text = "NOT ENOUGH MATERIALS"

		$FishingrodDisplay/ActionButton.text = "TRADE FOR FISHING ROD"

		$FishingrodDisplay/ActionButton.disabled = true


	#-------------------------------
	# Page Number
	#-------------------------------

	$FishingrodDisplay/PageLabel.text = (
		str(current_fishing_rod_index + 1)
		+ " / "
		+ str(fishing_rods.size())
	)


#=================================================
# PREVIOUS FISHING ROD
#=================================================

func _on_previous_pressed():

	current_fishing_rod_index -= 1

	if current_fishing_rod_index < 0:

		current_fishing_rod_index = fishing_rods.size() - 1

	show_fishing_rod()


#=================================================
# NEXT FISHING ROD
#=================================================

func _on_next_pressed():

	current_fishing_rod_index += 1

	if current_fishing_rod_index >= fishing_rods.size():

		current_fishing_rod_index = 0

	show_fishing_rod()


#=================================================
# TRADE
#=================================================

func _on_action_pressed():

	var fishing_rod_name: String = fishing_rods[current_fishing_rod_index]["name"]

	var success = GameManager.trade_for_fishing_rod(
		fishing_rod_name
	)

	if success:

		show_fishing_rod()

	else:

		$FishingrodDisplay/StatusLabel.text = (
			"NOT ENOUGH MATERIALS"
		)


#=================================================
# INVENTORY UPDATED
#=================================================

func _on_inventory_changed():

	show_fishing_rod()


#=================================================
# CLOSE
#=================================================

func _on_close_pressed():

	get_parent().queue_free()
