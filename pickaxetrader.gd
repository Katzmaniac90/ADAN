extends CharacterBody2D

var player_near := false
var shop_open := false

const PICKAXE_TRADER_UI = preload("res://Scenes/pickaxe_trader_ui.tscn")


func _ready():

	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

	print("⛏️ Pickaxe Trader is ready!")


func _on_body_entered(body):

	if body.name == "Player":

		player_near = true

		print("⛏️ Player is near Pickaxe Trader")


func _on_body_exited(body):

	if body.name == "Player":

		player_near = false

		print("⛏️ Player left Pickaxe Trader")


func _process(_delta):

	if player_near and Input.is_action_just_pressed("interact"):

		open_shop()


func open_shop():

	if shop_open:
		return

	print("⛏️ Pickaxe Trader opened!")

	var shop = PICKAXE_TRADER_UI.instantiate()

	# Add the CanvasLayer to the main game scene.
	get_tree().current_scene.add_child(shop)

	# Get the Panel inside the CanvasLayer.
	var panel = shop.get_node("PickaxeTraderPanel")

	# Center the window on screen.
	var viewport_size = get_viewport().get_visible_rect().size

	panel.position = (
		viewport_size / 2.0
		- panel.size / 2.0
	)

	shop_open = true

	shop.tree_exited.connect(_on_shop_closed)


func _on_shop_closed():

	shop_open = false
