extends CharacterBody2D


#=========================
# Movement
#=========================

@export var walk_speed := 50
@export var sprint_speed := 150


#=========================
# Player State
#=========================

var direction: Vector2 = Vector2.ZERO
var velocity_speed := walk_speed

var is_busy := false
var is_sprinting := false

var last_position: Vector2

@onready var camera: Camera2D = $Camera2D


#=========================
# UI
#=========================

var stamina_bar


func _ready():

	stamina_bar = get_tree().get_first_node_in_group("stamina_bar")
	
	last_position = global_position

	GameManager.xp_gained.connect(show_floating_xp)
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


	#=========================
	# Update Stamina
	#=========================

	GameManager.update_stamina(delta)


	if stamina_bar:

		stamina_bar.max_value = GameManager.max_stamina
		stamina_bar.value = GameManager.current_stamina

	if GameManager.current_stamina >= GameManager.max_stamina:

		stamina_bar.hide()

	elif GameManager.current_stamina < GameManager.max_stamina * 0.25:

		stamina_bar.hide()

	else:

		stamina_bar.show()



	#=========================
	# Busy Check
	#=========================

	if is_busy:

		velocity = Vector2.ZERO
		move_and_slide()
		return



	#=========================
	# Movement Input
	#=========================

	direction = Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)



	#=========================
	# Sprint
	#=========================

	is_sprinting = (
		Input.is_action_pressed("running")
		and GameManager.can_sprint
		and direction != Vector2.ZERO
	)


	if is_sprinting:

		velocity_speed = sprint_speed

		GameManager.drain_stamina(delta)

	else:

		velocity_speed = walk_speed



	velocity = direction * velocity_speed


	playerAnimationsAdam()

	move_and_slide()



	#=========================
	# Footwork XP
	#=========================

	var sprint_distance = global_position.distance_to(last_position)


	if is_sprinting:

		GameManager.add_footwork_steps(sprint_distance)


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

func show_floating_xp(amount:int, skill_name:String):

	var floating_scene = preload("res://Scenes/UI/floating_text.tscn")

	var floating = floating_scene.instantiate()

	get_tree().current_scene.add_child(floating)

	floating.global_position = global_position + Vector2(0, -50)

	floating.set_text(
		"+" + str(amount) + " " + skill_name + " XP"
	)


func set_camera_limits(left: int, top: int, right: int, bottom: int):
	camera.limit_left = left
	camera.limit_top = top
	camera.limit_right = right
	camera.limit_bottom = bottom
