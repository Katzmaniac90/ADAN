extends StaticBody2D

var player_near = false
var punching = false
var shake_amount := 1.0
var original_position: Vector2

@export var min_respawn_time: float = 4.0
@export var max_respawn_time: float = 8.0

#=================================================
# ROCK SETTINGS
#=================================================

@export var rockpunching_xp: int = 25
@export var required_rockpunching_level: int = 1
@export var rock_difficulty: int = 1

#=================================================
# ROCK DROPS
#=================================================

@export var rock_drop: String = "Granite"
@export var interaction_text: String = "Punch Rock"


func _ready():

	original_position = $RockModified.position

	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

	$PunchTimer.timeout.connect(_on_punch_timer_timeout)
	$RespawnTimer.timeout.connect(_on_respawn_timer_timeout)

	$PunchProgress.visible = false


func _on_body_entered(body):

	if body.name == "Player":

		player_near = true

		$InteractionLabel.text = interaction_text
		$InteractionLabel.visible = true


func _on_body_exited(body):

	if body.name == "Player":

		player_near = false

		$InteractionLabel.visible = false

		if punching:

			cancel_punching()


func _process(delta):

	if punching:

		var player = get_tree().get_first_node_in_group("player")

		if player and player.global_position.distance_to(global_position) > 60:

			cancel_punching()
			return

		# Update progress based on current pickaxe speed
		$PunchProgress.value += (
			100.0 / get_punch_time()
		) * delta

		shake_rock()

		# Press interact again to cancel
		if Input.is_action_just_pressed("interact"):

			cancel_punching()
			return


	if player_near and Input.is_action_just_pressed("interact"):

		if not punching:

			start_punching()


func start_punching():

	# Skill level controls whether the resource
	# can be gathered.
	if GameManager.rockpunching_level < required_rockpunching_level:

		MessageManager.send_message(
			"You can't do that yet"
		)

		return


	punching = true

	$InteractionLabel.visible = false
	$PunchProgress.visible = true
	$PunchProgress.value = 0
	$GPUParticles2D.emitting = true

	$PunchTimer.start(
		get_punch_time()
	)


func _on_punch_timer_timeout():

	punch_rock()


func punch_rock():

	# Give skill XP
	GameManager.add_rockpunching_xp(
		rockpunching_xp
	)

	# Give rock resource
	GameManager.add_item(
		rock_drop,
		1
	)

	AchievementManager.unlock_if_locked(
		"FIRST_ROCK"
	)

	print("ROCK PUNCHED!")
	print(
		"Rockpunching XP +",
		rockpunching_xp
	)

	print(
		"Received ",
		rock_drop
	)

	punching = false

	$PunchProgress.visible = false
	$GPUParticles2D.emitting = false

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


func _on_respawn_timer_timeout():

	print(
		"🔄 ",
		rock_drop,
		" respawn timer fired: ",
		name
	)


	var spawn_point = ResourceSpawnManager.get_available_resource_spawn(
		rock_drop,
		self
	)


	if spawn_point == null:

		print(
			"❌ No available spawn point for ",
			rock_drop,
			": ",
			name
		)

		$RespawnTimer.start(2.0)

		return


	print(
		"📍 Moving ",
		name,
		" from ",
		global_position,
		" → ",
		spawn_point.name,
		" ",
		spawn_point.global_position
	)

	global_position = spawn_point.global_position

	show()

	$CollisionShape2D.disabled = false

	print(
		"✅ ",
		name,
		" respawned at ",
		spawn_point.name
	)


func cancel_punching():

	print("Stopped punching")

	punching = false

	$PunchTimer.stop()

	$PunchProgress.value = 0
	$PunchProgress.visible = false
	$GPUParticles2D.emitting = false

	$InteractionLabel.visible = player_near


#=================================================
# PUNCH SPEED
#=================================================

func get_punch_time():

	var pickaxe_speed = 1.0

	match GameManager.current_pickaxe:

		"Hands":
			pickaxe_speed = 1.0

		"Rock Wrecker":
			pickaxe_speed = 0.5

		"Stone Titan":
			pickaxe_speed = 0.35

		"Mining Lord":
			pickaxe_speed = 0.25

		"Rock Puncher":
			pickaxe_speed = 0.1


	var base_time = rock_difficulty * 10.0

	return base_time * pickaxe_speed


#=================================================
# ROCK SHAKE
#=================================================

func shake_rock():

	if punching:

		$RockModified.position.x = (
			original_position.x
			+ randf_range(
				-shake_amount,
				shake_amount
			)
		)

	else:

		$RockModified.position = original_position
