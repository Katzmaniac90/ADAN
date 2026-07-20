extends StaticBody2D

var player_near = false
var chopping = false
var shake_amount = 3.0
var original_position: Vector2
var spawn_position: Vector2

@export var stump_scene: PackedScene
@export var log_scene: PackedScene
@export var chop_time: float = 3.0
@export var respawn_time: float = 5.0
@export var respawn_radius := 50.0


func _ready():
	original_position = $TreeModified.position

	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$ChopTimer.timeout.connect(_on_chop_timer_timeout)
	$RespawnTimer.timeout.connect(_on_respawn_timer_timeout)

	$ChopProgress.visible = false
	spawn_position = global_position
	var angle = randf_range(0.0, TAU)
	var distance = randf_range(0.0, respawn_radius)

	global_position = spawn_position + Vector2.RIGHT.rotated(angle) * distance

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
		$ChopProgress.value += (100 / chop_time) * delta
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
	
	$ChopTimer.start(chop_time)


func _on_chop_timer_timeout():
	chop_tree()


func chop_tree():
	var player = get_tree().get_first_node_in_group("player")
	player.is_busy = false
	player.add_barkbreaking_xp(25)
	print("CHOPPING TREE!")


	var log = log_scene.instantiate()

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
	var angle = randf_range(0.0, TAU)
	var distance = randf_range(0.0, respawn_radius)

	global_position += Vector2.RIGHT.rotated(angle) * distance

	$TreeModified.position = Vector2.ZERO
	original_position = $TreeModified.position

	show()
	$CollisionShape2D.disabled = false
