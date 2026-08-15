extends StaticBody2D

var player_near := false
var snatching := false

var shake_amount := 1.0
var original_position: Vector2


#=================================================
# RESPAWN
#=================================================

@export var min_respawn_time: float = 4.0
@export var max_respawn_time: float = 8.0


#=================================================
# INTERACTION
#=================================================

@export var interaction_height: float = -50.0
@export var interaction_text: String = "Snatch Fish"


#=================================================
# FISHSNATCHING
#=================================================

@export var fishsnatching_xp: int = 25
@export var bubble_difficulty: int = 1
@export var required_fishsnatching_level: int = 1


#=================================================
# FISH DROP / RESOURCE TYPE
#=================================================

@export var fish_name: String = "Bubblefin"


#=================================================
# READY
#=================================================

func _ready():

	original_position = $Bubble.position

	$InteractionLabel.position = Vector2(
		0,
		interaction_height
	)

	$InteractionLabel.text = interaction_text

	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

	$SnatchTimer.timeout.connect(_on_snatch_timer_timeout)
	$RespawnTimer.timeout.connect(_on_respawn_timer_timeout)

	$SnatchProgress.visible = false


#=================================================
# PLAYER ENTER
#=================================================

func _on_body_entered(body):

	if body.name == "Player":

		player_near = true

		$InteractionLabel.position = Vector2(
			-$InteractionLabel.size.x / 2,
			interaction_height
		)

		$InteractionLabel.visible = true


#=================================================
# PLAYER EXIT
#=================================================

func _on_body_exited(body):

	if body.name == "Player":

		player_near = false

		$InteractionLabel.visible = false

		if snatching:

			cancel_snatching()


#=================================================
# PROCESS
#=================================================

func _process(delta):

	if snatching:

		$SnatchProgress.value += (
			100.0 / get_snatch_time()
		) * delta

		shake_bubble()

	else:

		$Bubble.position = original_position


	if player_near and Input.is_action_just_pressed("interact"):

		if snatching:

			cancel_snatching()

		else:

			start_snatching()


#=================================================
# START SNATCHING
#=================================================

func start_snatching():

	if GameManager.fishsnatching_level < required_fishsnatching_level:

		MessageManager.send_message(
			"You can't do that yet"
		)

		return


	snatching = true

	$InteractionLabel.visible = false

	$SnatchProgress.visible = true
	$SnatchProgress.value = 0

	$SnatchTimer.start(
		get_snatch_time()
	)


#=================================================
# SNATCH TIMER
#=================================================

func _on_snatch_timer_timeout():

	snatch_fish()


#=================================================
# SNATCH FISH
#=================================================

func snatch_fish():

	# Give Fishsnatching XP
	GameManager.add_fishsnatching_xp(
		fishsnatching_xp
	)

	# Give fish
	GameManager.add_item(
		fish_name,
		1
	)

	# First fish achievement
	AchievementManager.unlock_if_locked(
		"FIRST_FISH"
	)

	print(
		"🐟 ",
		name,
		" (",
		fish_name,
		") collected at ",
		global_position
	)

	snatching = false

	$SnatchProgress.visible = false

	# Hide fish
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


#=================================================
# BUBBLE SHAKE
#=================================================

func shake_bubble():

	if snatching:

		$Bubble.position.x = (
			original_position.x
			+ randf_range(
				-shake_amount,
				shake_amount
			)
		)

	else:

		$Bubble.position = original_position


#=================================================
# RESPAWN
#=================================================

func _on_respawn_timer_timeout():

	print(
		"🔄 ",
		fish_name,
		" respawn timer fired: ",
		name
	)

	var spawn_point = ResourceSpawnManager.get_available_resource_spawn(
		fish_name,
		self
	)

	if spawn_point == null:

		print(
			"❌ No available ",
			fish_name,
			" spawn point for ",
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


#=================================================
# SNATCH TIME
#=================================================

func get_snatch_time():

	var rod_speed = 1.0

	match GameManager.current_fishing_rod:

		"Hands":
			rod_speed = 1.0

		"Fishwrecker":
			rod_speed = 0.5

		"Reel Titan":
			rod_speed = 0.35

		"Angler Lord":
			rod_speed = 0.25

		"Fishmaster":
			rod_speed = 0.1

	var base_time = bubble_difficulty * 10.0

	return base_time * rod_speed


#=================================================
# CANCEL SNATCHING
#=================================================

func cancel_snatching():

	print("Stopped snatching")

	snatching = false

	$SnatchTimer.stop()

	$SnatchProgress.value = 0
	$SnatchProgress.visible = false

	$InteractionLabel.visible = player_near
