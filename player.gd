extends CharacterBody2D

var direction: Vector2 = Vector2(1,1)
var speed: int = 150
var is_busy = false

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
