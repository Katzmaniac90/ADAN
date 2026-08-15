extends StaticBody2D

var player_near = false
var chopping = false
var shake_amount = 1.0
var original_position: Vector2

@export var min_respawn_time: float = 4.0
@export var max_respawn_time: float = 8.0
@export var interaction_height: float = -50
@export var resource_type: String = "Greenwood"

# Barkbreaking requirements

@export var required_barkbreaking_level: int = 1

# Tree settings

@export var barkbreaking_xp: int = 25
@export var tree_difficulty: int = 1

# Different tree drops

@export var log_name: String = "Greenwood"
@export var interaction_text: String = "Chop Tree"


func _ready():

	original_position = $TreeModified.position

	$InteractionLabel.position = Vector2(
		0,
		interaction_height
	)

	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

	$ChopTimer.timeout.connect(_on_chop_timer_timeout)
	$RespawnTimer.timeout.connect(_on_respawn_timer_timeout)

	$ChopProgress.visible = false


func _on_body_entered(body):

	if body.name == "Player":

		player_near = true

		$InteractionLabel.position = Vector2(
			-$InteractionLabel.size.x / 2,
			interaction_height
		)

		$InteractionLabel.visible = true


func _on_body_exited(body):

	if body.name == "Player":

		player_near = false

		$InteractionLabel.visible = false

		if chopping:

			cancel_chopping()


func _process(delta):

	if chopping:

		$ChopProgress.value += (
			100.0 / get_chop_time()
		) * delta

		shake_tree()

	else:

		$TreeModified.position = original_position


	if player_near and Input.is_action_just_pressed("interact"):

		if chopping:

			cancel_chopping()

		else:

			start_chopping()


func start_chopping():

	if GameManager.barkbreaking_level < required_barkbreaking_level:

		MessageManager.send_message(
			"You can't do that yet"
		)

		return


	chopping = true

	$InteractionLabel.visible = false
	$ChopProgress.visible = true
	$ChopProgress.value = 0
	$GPUParticles2D.emitting = true

	$ChopTimer.start(
		get_chop_time()
	)


func _on_chop_timer_timeout():

	chop_tree()


func chop_tree():

	# Give skill XP
	GameManager.add_barkbreaking_xp(
		barkbreaking_xp
	)

	# Add log directly to inventory
	GameManager.add_item(
		log_name,
		1
	)

	AchievementManager.unlock_if_locked(
		"FIRST_TREE"
	)

	chopping = false

	$ChopProgress.visible = false
	$GPUParticles2D.emitting = false


	# Tell ResourceSpawnManager this resource is no longer occupying its point
	ResourceSpawnManager.release_resource_spawn(
	resource_type,
	self
)


	hide()

	$CollisionShape2D.disabled = true


	# Random respawn time
	var r = randf()

	var random_respawn = lerp(
		min_respawn_time,
		max_respawn_time,
		sqrt(r)
	)

	$RespawnTimer.start(
		random_respawn
	)


func shake_tree():

	if chopping:

		$TreeModified.position.x = (
			original_position.x
			+ randf_range(
				-shake_amount,
				shake_amount
			)
		)

	else:

		$TreeModified.position = original_position


func _on_respawn_timer_timeout():

	print(
		"🌳 ",
		resource_type,
		" RESPAWN TIMER FIRED: ",
		name
	)


	var spawn_point = ResourceSpawnManager.get_available_resource_spawn(
	resource_type,
	self
)


	if spawn_point == null:

		print(
			"❌ No available ",
			resource_type,
			" spawn point!"
		)

		$RespawnTimer.start(1.0)

		return


	print(
		"🌳 Moving ",
		name,
		" to ",
		spawn_point.name
	)


	global_position = spawn_point.global_position

	show()

	$CollisionShape2D.disabled = false


func get_chop_time():

	var axe_speed = 1.0


	match GameManager.current_axe:

		"Hands":
			axe_speed = 1.0

		"Wood Wrecker":
			axe_speed = 0.5

		"Timber Titan":
			axe_speed = 0.35

		"Lumber Lord":
			axe_speed = 0.25

		"Barkbreaker":
			axe_speed = 0.1


	var base_time = tree_difficulty * 10.0

	return base_time * axe_speed


func cancel_chopping():

	print(
		"Stopped chopping"
	)

	chopping = false

	$ChopTimer.stop()

	$ChopProgress.value = 0
	$ChopProgress.visible = false
	$GPUParticles2D.emitting = false

	$InteractionLabel.visible = player_near
