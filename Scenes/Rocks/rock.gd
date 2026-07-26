extends StaticBody2D


var player_near = false
var punching = false


@export var min_respawn_time: float = 4.0
@export var max_respawn_time: float = 8.0

# Rock settings
@export var rockpunching_xp: int = 25
@export var required_rockpunching_level: int = 1
@export var rock_difficulty: int = 1

@export var punch_time: float = 10.0
@export var interaction_text: String = "Chop Tree"


func _ready():

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



func _process(delta):

	if punching:

		$PunchProgress.value += (100.0 / punch_time) * delta


	if player_near and Input.is_action_just_pressed("interact") and not punching:

		start_punching()



func start_punching():

	if GameManager.rockpunching_level < required_rockpunching_level:

		print("Your Rockpunching level is too low!")
		return


	punching = true


	var player = get_tree().get_first_node_in_group("player")

	player.is_busy = true


	$InteractionLabel.visible = false

	$PunchProgress.visible = true

	$PunchProgress.value = 0


	$PunchTimer.start(punch_time)



func _on_punch_timer_timeout():

	punch_rock()



func punch_rock():

	var player = get_tree().get_first_node_in_group("player")

	player.is_busy = false


	GameManager.add_rockpunching_xp(rockpunching_xp)


	print("ROCK PUNCHED!")
	print("Rockpunching XP +", rockpunching_xp)


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
