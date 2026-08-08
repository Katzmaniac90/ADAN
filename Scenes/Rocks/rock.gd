extends StaticBody2D

var player_near = false
var punching = false
var shake_amount := 1.0
var original_position: Vector2

@export var min_respawn_time: float = 4.0
@export var max_respawn_time: float = 8.0

# Rock settings

@export var rockpunching_xp: int = 25
@export var required_rockpunching_level: int = 1
@export var rock_difficulty: int = 1

# Rock drops

@export var rock_drop: String = "Granite"

@export var punch_time: float = 10.0
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

		$PunchProgress.value += (100.0 / punch_time) * delta

		shake_rock()

		if Input.is_action_just_pressed("interact"):

			cancel_punching()
			return


	if player_near and Input.is_action_just_pressed("interact"):

		start_punching()


func start_punching():

	if GameManager.rockpunching_level < required_rockpunching_level:

		print("Your Rockpunching level is too low!")
		return


	punching = true

	$InteractionLabel.visible = false

	$PunchProgress.visible = true

	$PunchProgress.value = 0

	$PunchTimer.start(punch_time)


func _on_punch_timer_timeout():

	punch_rock()


func punch_rock():

	var player = get_tree().get_first_node_in_group("player")

	# Give skill XP
	GameManager.add_rockpunching_xp(rockpunching_xp)

	# Give rock resource
	GameManager.add_item(rock_drop, 1)

	AchievementManager.unlock_if_locked("FIRST_ROCK")

	print("ROCK PUNCHED!")
	print("Rockpunching XP +", rockpunching_xp)
	print("Received ", rock_drop)

	punching = false

	$PunchProgress.visible = false

	hide()

	$CollisionShape2D.disabled = true

	var r = randf()

	var random_respawn = lerp(
		min_respawn_time,
		max_respawn_time,
		sqrt(r)
	)

	$RespawnTimer.start(random_respawn)


func _on_respawn_timer_timeout():

	show()

	$CollisionShape2D.disabled = false


func cancel_punching():

	print("Stopped punching")

	punching = false

	$PunchTimer.stop()

	$PunchProgress.value = 0
	$PunchProgress.visible = false

	$InteractionLabel.visible = player_near


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
