extends Panel


#=================================================
# AXE DATA
#=================================================

var axes = [
	{
		"name": "Hands",
		"power": 0
	},
	{
		"name": "Wood Wrecker",
		"power": 5
	},
	{
		"name": "Timber Titan",
		"power": 10
	},
	{
		"name": "Lumber Lord",
		"power": 20
	},
	{
		"name": "Barkbreaker",
		"power": 40
	}
]


var current_axe_index := 0


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

	$AxeDisplay/ActionButton.pressed.connect(
		_on_action_pressed
	)

	GameManager.inventory_changed.connect(
		_on_inventory_changed
	)

	show_axe()


#=================================================
# DISPLAY AXE
#=================================================

func show_axe():

	var axe = axes[current_axe_index]

	var axe_name: String = axe["name"]


	#-------------------------------
	# Name
	#-------------------------------

	$AxeDisplay/AxeName.text = axe_name


	#-------------------------------
	# Stats
	#-------------------------------

	$AxeDisplay/AxeStats.text = (
		"Woodcutting Power: "
		+ str(axe["power"])
	)


	#-------------------------------
	# Requirements
	#-------------------------------

	var requirements = GameManager.get_axe_requirements(
		axe_name
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
				+ "    "
				+ str(player_amount)
				+ " / "
				+ str(required_amount)
				+ "\n"
			)


	$AxeDisplay/Requirements.text = requirement_text


	#-------------------------------
	# Status / Button
	#-------------------------------

	if axe_name == "Hands":

		$AxeDisplay/StatusLabel.text = "STARTING TOOL"

		$AxeDisplay/ActionButton.text = "EQUIPPED"

		$AxeDisplay/ActionButton.disabled = true


	elif GameManager.current_axe == axe_name:

		$AxeDisplay/StatusLabel.text = "CURRENTLY EQUIPPED"

		$AxeDisplay/ActionButton.text = "EQUIPPED"

		$AxeDisplay/ActionButton.disabled = true


	elif GameManager.can_trade_for_axe(axe_name):

		$AxeDisplay/StatusLabel.text = "READY TO TRADE"

		$AxeDisplay/ActionButton.text = "TRADE FOR AXE"

		$AxeDisplay/ActionButton.disabled = false


	else:

		$AxeDisplay/StatusLabel.text = "NOT ENOUGH MATERIALS"

		$AxeDisplay/ActionButton.text = "TRADE FOR AXE"

		$AxeDisplay/ActionButton.disabled = true


	#-------------------------------
	# Page Number
	#-------------------------------

	$AxeDisplay/PageLabel.text = (
		str(current_axe_index + 1)
		+ " / "
		+ str(axes.size())
	)


#=================================================
# PREVIOUS AXE
#=================================================

func _on_previous_pressed():

	current_axe_index -= 1

	if current_axe_index < 0:

		current_axe_index = axes.size() - 1

	show_axe()


#=================================================
# NEXT AXE
#=================================================

func _on_next_pressed():

	current_axe_index += 1

	if current_axe_index >= axes.size():

		current_axe_index = 0

	show_axe()


#=================================================
# TRADE
#=================================================

func _on_action_pressed():

	var axe_name: String = axes[current_axe_index]["name"]

	var success = GameManager.trade_for_axe(
		axe_name
	)

	if success:

		show_axe()

	else:

		$AxeDisplay/StatusLabel.text = (
			"NOT ENOUGH MATERIALS"
		)


#=================================================
# INVENTORY UPDATED
#=================================================

func _on_inventory_changed():

	show_axe()


#=================================================
# CLOSE
#=================================================

func _on_close_pressed():

	get_parent().queue_free()
