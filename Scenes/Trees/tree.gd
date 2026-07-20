extends StaticBody2D

var player_near = false

@export var stump_scene: PackedScene
@export var log_scene: PackedScene


func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body.name == "Player":
		player_near = true
		$InteractionLabel.visible = true


func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		$InteractionLabel.visible = false


func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):
		chop_tree()


func chop_tree():
	print("CHOPPING TREE!")

	# Create stump
	var stump = stump_scene.instantiate()
	stump.global_position = global_position
	get_parent().add_child(stump)

	# Create log
	var log = log_scene.instantiate()

	# Random drop location near tree
	var offset = Vector2(
		randf_range(-16, 16),
		randf_range(8, 20)
	)

	log.global_position = global_position + offset
	get_parent().add_child(log)

	# Remove tree
	queue_free()
