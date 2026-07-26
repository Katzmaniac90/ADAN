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



func _on_area_2d_body_entered(body):

	print("Something entered:", body.name)

	if body.is_in_group("player"):

		print("Player detected!")

		player_near = true



func _on_area_2d_body_exited(body):

	print("Something exited:", body.name)

	if body.is_in_group("player"):

		print("Player left!")

		player_near = false



func _process(delta):

	if dead:
		return


	if player_near and Input.is_action_just_pressed("Attack"):

		take_damage(damage_taken_per_hit)



func take_damage(amount):

	if dead:
		return


	health -= amount

	print("Dummy HP:", health)


	if health <= 0:

		die()



func die():

	dead = true

	GameManager.add_smacking_xp(smacking_xp_reward)

	print("Dummy defeated!")

	hide()

	$CollisionShape2D.disabled = true
