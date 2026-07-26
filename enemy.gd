extends CharacterBody2D

@export var max_health := 100
@export var smacking_xp_reward := 25
@export var damage_taken_per_hit := 25

var health := 100
var player_near := false
var dead := false


func _ready():

	health = max_health

	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

	$RespawnTimer.timeout.connect(respawn)



func _on_area_2d_body_entered(body):

	print("Entered:", body.name)
	if body.is_in_group("player"):

		player_near = true



func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):

		player_near = false



func _process(delta):

	if dead:
		return

	if player_near:
		print("Player is near enemy")

	if player_near and Input.is_action_just_pressed("attack"):

		print("Attack detected")
		take_damage(damage_taken_per_hit)



func take_damage(amount):

	if dead:
		return

	health -= amount

	print("Enemy HP:", health)


	if health <= 0:

		die()



func die():

	dead = true

	GameManager.add_smacking_xp(smacking_xp_reward)

	print("Enemy defeated!")

	hide()

	$CollisionShape2D.disabled = true

	$RespawnTimer.start()



func respawn():

	health = max_health

	dead = false

	show()

	$CollisionShape2D.disabled = false

	print("Enemy respawned!")
