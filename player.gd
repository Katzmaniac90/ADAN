extends CharacterBody2D

signal inventory_changed

var direction: Vector2 = Vector2(1,1)
var speed: int = 150
var is_busy = false
var inventory = {}
var barkbreaking_level = 1
var barkbreaking_xp = 0
var zoom_speed = 0.1
var min_zoom = 0.5
var max_zoom = 5.0


func _physics_process(delta):
	#basic player movement
	if is_busy:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	playerAnimationsAdam()
		# Camera zoom controls
	if Input.is_action_just_pressed("zoom_in"):
		$Camera2D.zoom += Vector2(zoom_speed, zoom_speed)

	if Input.is_action_just_pressed("zoom_out"):
		$Camera2D.zoom -= Vector2(zoom_speed, zoom_speed)

	$Camera2D.zoom.x = clamp($Camera2D.zoom.x, min_zoom, max_zoom)
	$Camera2D.zoom.y = clamp($Camera2D.zoom.y, min_zoom, max_zoom)
	move_and_slide()

#Walking and Idle animations for the player
func playerAnimationsAdam(): 
	if direction:
		if direction.x > 0:
			$AnimatedSprite2D.animation = 'rightWalking'
		if direction.x < 0:
			$AnimatedSprite2D.animation = 'leftWalking'
		if direction.y > 0:
			$AnimatedSprite2D.animation = 'downWalking'
		if direction.y < 0:
			$AnimatedSprite2D.animation = 'upWalking'
	else:
		$AnimatedSprite2D.animation = 'idle'

func add_item(item_name, amount):
	if inventory.has(item_name):
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount

	inventory_changed.emit()
	print(inventory)

func add_barkbreaking_xp(amount):
	barkbreaking_xp += amount

	while barkbreaking_xp >= barkbreaking_level * 100:
		barkbreaking_xp -= barkbreaking_level * 100
		barkbreaking_level += 1

		print("LEVEL UP!")
		print("barkbreaking Level:", barkbreaking_level)
