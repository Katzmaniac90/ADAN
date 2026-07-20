extends CharacterBody2D

signal inventory_changed

var direction: Vector2 = Vector2(1,1)
var speed: int = 150
var is_busy = false
var inventory = {}
var barkbreaking_level = 1
var barkbreaking_xp = 0


func _physics_process(delta):
	if is_busy:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	playerAnimationsAdam()
	move_and_slide()

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
