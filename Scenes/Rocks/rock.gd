extends StaticBody2D


var player_near = false
var mining = false


@export var rockpunching_xp: int = 25
@export var required_rockpunching_level: int = 1

@export var min_respawn_time: float = 4.0
@export var max_respawn_time: float = 8.0



func _ready():

	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

	$RespawnTimer.timeout.connect(_on_respawn_timer_timeout)



func _on_body_entered(body):

	if body.name == "Player":

		player_near = true
		$InteractionLabel.visible = true



func _on_body_exited(body):

	if body.name == "Player":

		player_near = false
		$InteractionLabel.visible = false



func _process(delta):

	if player_near and Input.is_action_just_pressed("interact") and not mining:

		punch_rock()



func punch_rock():

	if GameManager.rockpunching_level < required_rockpunching_level:

		print("Your Rockpunching level is too low!")

		return


	var player = get_tree().get_first_node_in_group("player")

	player.is_busy = true


	GameManager.add_rockpunching_xp(rockpunching_xp)


	print("Rock punched!")
	print("Rockpunching XP +", rockpunching_xp)


	player.is_busy = false


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
