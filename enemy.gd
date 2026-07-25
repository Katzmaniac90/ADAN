extends CharacterBody2D

@export var max_health = 100
@export var attack_xp_reward = 25

var health = 100

func take_damage(amount):

	health -= amount

	print("Enemy HP:", health)


	if health <= 0:

		die()



func die():

	GameManager.add_attack_xp(attack_xp_reward)

	print("Enemy defeated!")

	hide()

	$CollisionShape2D.disabled = true
func _process(delta):

	if Input.is_action_just_pressed("Attack"):

		take_damage(25)
