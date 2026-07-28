extends CharacterBody2D

@export var enemy_name: String = "Angry Villager"
@export var max_health := 100
@export var smacking_xp_reward := 25
@export var damage_taken_per_hit := 25

var current_health := 100
var player_near := false
var dead := false


func _ready():

	current_health = max_health

	$EnemyNameLabel.text = enemy_name
	$EnemyNameLabel.visible = false

	$HealthBar.max_value = max_health
	$HealthBar.value = current_health
	$HealthBar.visible = false

	$HealthLabel.visible = false
	$HealthLabel.text = str(current_health) + " / " + str(max_health)

	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

	$RespawnTimer.timeout.connect(respawn)

	$HealthBarTimer.timeout.connect(_on_health_bar_timer_timeout)



func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):
		player_near = true



func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):
		player_near = false



func _process(delta):

	if dead:
		return

	if player_near and Input.is_action_just_pressed("attack"):

		take_damage(damage_taken_per_hit)



func take_damage(amount):

	if dead:
		return

	current_health -= amount

	$EnemyNameLabel.visible = true

	$HealthBar.modulate.a = 1.0
	$HealthLabel.modulate.a = 1.0

	$HealthBar.visible = true
	$HealthLabel.visible = true

	$HealthBar.value = current_health
	$HealthLabel.text = str(current_health) + " / " + str(max_health)

	$HealthBarTimer.start()

	print(enemy_name, " HP:", current_health)

	if current_health <= 0:

		die()



func die():

	dead = true

	GameManager.add_smacking_xp(smacking_xp_reward)

	print(enemy_name, " defeated!")

	$HealthBarTimer.stop()

	$EnemyNameLabel.visible = false
	$HealthBar.visible = false
	$HealthLabel.visible = false

	hide()

	$CollisionShape2D.disabled = true

	$RespawnTimer.start()



func respawn():

	current_health = max_health

	$HealthBar.value = current_health
	$HealthLabel.text = str(current_health) + " / " + str(max_health)

	$EnemyNameLabel.visible = false
	$HealthBar.visible = false
	$HealthLabel.visible = false

	$HealthBar.modulate.a = 1.0
	$HealthLabel.modulate.a = 1.0

	dead = false

	show()

	$CollisionShape2D.disabled = false

	print(enemy_name, " respawned!")



func _on_health_bar_timer_timeout():

	if dead:
		return

	var tween = create_tween()

	tween.parallel().tween_property(
		$EnemyNameLabel,
		"modulate:a",
		0.0,
		0.4
	)

	tween.parallel().tween_property(
		$HealthBar,
		"modulate:a",
		0.0,
		0.4
	)

	tween.parallel().tween_property(
		$HealthLabel,
		"modulate:a",
		0.0,
		0.4
	)

	tween.finished.connect(func():

		$EnemyNameLabel.visible = false
		$HealthBar.visible = false
		$HealthLabel.visible = false

		$EnemyNameLabel.modulate.a = 1.0
		$HealthBar.modulate.a = 1.0
		$HealthLabel.modulate.a = 1.0
	)
