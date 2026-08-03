extends CharacterBody2D


@export var walk_speed := 50
@export var sprint_speed := 150

@export var max_stamina := 5.0
@export var stamina_regen := 0.5
@export var stamina_drain := 1.0


var can_sprint := true

var stamina_bar
var stamina := max_stamina

var direction: Vector2 = Vector2.ZERO
var velocity_speed := walk_speed

var is_busy := false
var is_sprinting := false

var last_position: Vector2


var zoom_speed := 0.1
var min_zoom := 0.8
var max_zoom := 2.0



func _ready():

	stamina_bar = get_tree().get_first_node_in_group("stamina_bar")

	last_position = global_position


	if SceneManager.spawn_id != "":

		var spawn = get_tree().current_scene.find_child(
			SceneManager.spawn_id,
			true,
			false
		)

		if spawn:

			global_position = spawn.global_position
			$Camera2D.reset_smoothing()



func _physics_process(delta):


	# Update stamina UI

	if stamina_bar:

		stamina_bar.max_value = max_stamina
		stamina_bar.value = stamina



	if is_busy:

		velocity = Vector2.ZERO
		move_and_slide()
		return



	direction = Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)



	#=========================
	# Sprint / Stamina
	#=========================

	is_sprinting = (
		Input.is_action_pressed("running")
		and can_sprint
		and direction != Vector2.ZERO
	)



	if is_sprinting:


		velocity_speed = sprint_speed

		stamina -= stamina_drain * delta

		if stamina <= 0:

			stamina = 0
			can_sprint = false



	else:


		velocity_speed = walk_speed

		stamina += stamina_regen * delta

		stamina = min(
			stamina,
			max_stamina
		)


		if stamina >= max_stamina:

			can_sprint = true



	velocity = direction * velocity_speed


	playerAnimationsAdam()



	#=========================
	# Camera Zoom
	#=========================

	if not get_viewport().gui_get_hovered_control():


		if Input.is_action_just_pressed("zoom_in"):

			$Camera2D.zoom += Vector2(
				zoom_speed,
				zoom_speed
			)



		if Input.is_action_just_pressed("zoom_out"):

			$Camera2D.zoom -= Vector2(
				zoom_speed,
				zoom_speed
			)



	$Camera2D.zoom.x = clamp(
		$Camera2D.zoom.x,
		min_zoom,
		max_zoom
	)

	$Camera2D.zoom.y = clamp(
		$Camera2D.zoom.y,
		min_zoom,
		max_zoom
	)



	move_and_slide()



	# Footwork XP only while sprinting

	var distance = global_position.distance_to(last_position)


	if is_sprinting:

		GameManager.add_footwork_steps(distance)



	last_position = global_position




func playerAnimationsAdam():


	if direction != Vector2.ZERO:


		if direction.y > 0:

			$AnimatedSprite2D.animation = "downWalking"


		elif direction.y < 0:

			$AnimatedSprite2D.animation = "upWalking"


		elif direction.x > 0:

			$AnimatedSprite2D.animation = "rightWalking"


		elif direction.x < 0:

			$AnimatedSprite2D.animation = "leftWalking"



	else:

		$AnimatedSprite2D.animation = "idle"




func add_item(item_name, amount):

	GameManager.add_item(
		item_name,
		amount
	)




func add_barkbreaking_xp(amount):

	GameManager.add_barkbreaking_xp(amount)
