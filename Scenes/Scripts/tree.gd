extends StaticBody2D

var player_near = false
var chopping = false
var shake_amount = 3.0
var original_position: Vector2


@export var stump_scene: PackedScene
@export var log_scene: PackedScene
@export var respawn_time: float = 5.0

@export var resource_boundary: Area2D


func _ready():
	original_position = $TreeModified.position

	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$ChopTimer.timeout.connect(_on_chop_timer_timeout)
	$RespawnTimer.timeout.connect(_on_respawn_timer_timeout)

	$ChopProgress.visible = false

	if not is_inside_barkbreaking_area():
		print("Tree outside area!")

func _on_body_entered(body):
	if body.name == "Player":
		player_near = true
		$InteractionLabel.visible = true


func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		$InteractionLabel.visible = false


func _process(delta):
	if chopping:
		$ChopProgress.value += (100.0 / get_chop_time()) * delta
		shake_tree()
	else:
		$TreeModified.position = original_position

	if player_near and Input.is_action_just_pressed("interact") and not chopping:
		start_chopping()


func start_chopping():
	chopping = true
	
	var player = get_tree().get_first_node_in_group("player")
	player.is_busy = true
	
	$InteractionLabel.visible = false
	$ChopProgress.visible = true
	$ChopProgress.value = 0
	
	$ChopTimer.start(get_chop_time())


func _on_chop_timer_timeout():
	chop_tree()


func chop_tree():
	var player = get_tree().get_first_node_in_group("player")
	player.is_busy = false
	player.add_barkbreaking_xp(25)
	print("CHOPPING TREE!")
	print("LOG SCENE:", log_scene)


	var log = log_scene.instantiate()

	print("LOG CREATED:", log)

	var offset = Vector2(
		randf_range(-20, 20),
		randf_range(25, 45)
	)

	log.global_position = global_position + offset

	get_parent().add_child(log)

	chopping = false
	$ChopProgress.visible = false

	hide()
	$CollisionShape2D.disabled = true

	$RespawnTimer.start(respawn_time)

func shake_tree():
	if chopping:
		$TreeModified.position.x = original_position.x + randf_range(-shake_amount, shake_amount)
	else:
		$TreeModified.position = original_position


func _on_respawn_timer_timeout():

	show()
	$CollisionShape2D.disabled = false

func get_chop_time():
	match GameManager.current_axe:
		"Hands":
			return 5.0
		"Wood Axe":
			return 3.0
		"Stone Axe":
			return 2.5
		"Iron Axe":
			return 2.0
		"Steel Axe":
			return 1.6
		"Mithril Axe":
			return 1.3
		"Adamant Axe":
			return 1.1
		"Rune Axe":
			return 0.9
		_:
			return 5.0

func is_inside_barkbreaking_area():
	if resource_boundary == null:
		return true

	var shape = resource_boundary.get_node("CollisionShape2D").shape as RectangleShape2D

	var area_position = resource_boundary.global_position
	var half_size = shape.size / 2

	return (
		global_position.x > area_position.x - half_size.x and
		global_position.x < area_position.x + half_size.x and
		global_position.y > area_position.y - half_size.y and
		global_position.y < area_position.y + half_size.y
	)
