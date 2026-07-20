extends StaticBody2D

var player_near = false
var chopping = false

@export var stump_scene: PackedScene
@export var log_scene: PackedScene
@export var chop_time: float = 3.0


func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$ChopTimer.timeout.connect(_on_chop_timer_timeout)
	$ChopProgress.visible = false


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

	if player_near and Input.is_action_just_pressed("interact") and not chopping:
		start_chopping()


func start_chopping():
	print("Starting chop...")
	chopping = true
	
	$InteractionLabel.visible = false
	$ChopProgress.visible = true
	$ChopProgress.value = 0
	
	$ChopTimer.start(chop_time)


func _on_chop_timer_timeout():
	chop_tree()


func chop_tree():
	print("CHOPPING TREE!")

	var stump = stump_scene.instantiate()
	stump.global_position = global_position
	get_parent().add_child(stump)

	var log = log_scene.instantiate()

	var offset = Vector2(
		randf_range(-20, 20),
		randf_range(25, 45)
	)

	log.global_position = global_position + offset
	get_parent().add_child(log)

	chopping = false
	queue_free()
