extends Panel


#=================================================
# PICKAXE DATA
#=================================================

var pickaxes = [
	{
		"name": "Hands",
		"power": 0,
		"image": preload("res://Items/Axes/Hands.png")
	},
	{
		"name": "Rock Wrecker",
		"power": 5,
		"image": preload("res://Items/Pickaxes/RockWrecker.png")
	},
	{
		"name": "Stone Titan",
		"power": 10,
		"image": preload("res://Items/Pickaxes/StoneTitan.png")
	},
	{
		"name": "Mining Lord",
		"power": 20,
		"image": preload("res://Items/Pickaxes/MiningLord.png")
	},
	{
		"name": "Rockpuncher",
		"power": 40,
		"image": preload("res://Items/Pickaxes/Rockpuncher.png")
	}
]


var current_pickaxe_index := 0


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

	$PickaxeDisplay/ActionButton.pressed.connect(
		_on_action_pressed
	)

	GameManager.inventory_changed.connect(
		_on_inventory_changed
	)

	show_pickaxe()


#=================================================
# DISPLAY PICKAXE
#=================================================

func show_pickaxe():

	var pickaxe = pickaxes[current_pickaxe_index]

	$PickaxeDisplay/PickaxeImage.texture = pickaxe["image"]

	var pickaxe_name: String = pickaxe["name"]


	#-------------------------------
	# Name
	#-------------------------------

	$PickaxeDisplay/PickaxeName.text = pickaxe_name


	#-------------------------------
	# Stats
	#-------------------------------

	$PickaxeDisplay/PickaxeStats.text = (
		"Rockpunching Power: "
		+ str(pickaxe["power"])
	)


	#-------------------------------
	# Requirements
	#-------------------------------

	var requirements = GameManager.get_pickaxe_requirements(
		pickaxe_name
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


	$PickaxeDisplay/Requirements.text = requirement_text


	#-------------------------------
	# Status / Button
	#-------------------------------

	if pickaxe_name == "Hands":

		$PickaxeDisplay/StatusLabel.text = "STARTING TOOL"
		$PickaxeDisplay/ActionButton.text = "EQUIPPED"
		$PickaxeDisplay/ActionButton.disabled = true

	elif GameManager.current_pickaxe == pickaxe_name:

		$PickaxeDisplay/StatusLabel.text = "CURRENTLY EQUIPPED"
		$PickaxeDisplay/ActionButton.text = "EQUIPPED"
		$PickaxeDisplay/ActionButton.disabled = true

	elif GameManager.can_trade_for_pickaxe(pickaxe_name):

		$PickaxeDisplay/StatusLabel.text = "READY TO TRADE"
		$PickaxeDisplay/ActionButton.text = "TRADE FOR PICKAXE"
		$PickaxeDisplay/ActionButton.disabled = false

	else:

		$PickaxeDisplay/StatusLabel.text = "NOT ENOUGH MATERIALS"
		$PickaxeDisplay/ActionButton.text = "TRADE FOR PICKAXE"
		$PickaxeDisplay/ActionButton.disabled = true


	#-------------------------------
	# Page Number
	#-------------------------------

	$PickaxeDisplay/PageLabel.text = (
		str(current_pickaxe_index + 1)
		+ " / "
		+ str(pickaxes.size())
	)


#=================================================
# PREVIOUS PICKAXE
#=================================================

func _on_previous_pressed():

	current_pickaxe_index -= 1

	if current_pickaxe_index < 0:
		current_pickaxe_index = pickaxes.size() - 1

	show_pickaxe()


#=================================================
# NEXT PICKAXE
#=================================================

func _on_next_pressed():

	current_pickaxe_index += 1

	if current_pickaxe_index >= pickaxes.size():
		current_pickaxe_index = 0

	show_pickaxe()


#=================================================
# TRADE
#=================================================

func _on_action_pressed():

	var pickaxe_name: String = pickaxes[current_pickaxe_index]["name"]

	var success = GameManager.trade_for_pickaxe(
		pickaxe_name
	)

	if success:

		show_pickaxe()

	else:

		$PickaxeDisplay/StatusLabel.text = (
			"NOT ENOUGH MATERIALS"
		)


#=================================================
# INVENTORY UPDATED
#=================================================

func _on_inventory_changed():

	show_pickaxe()


#=================================================
# CLOSE
#=================================================

func _on_close_pressed():

	get_parent().queue_free()
