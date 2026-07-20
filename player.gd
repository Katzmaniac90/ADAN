extends CharacterBody2D

var direction: Vector2 = Vector2(1,1)
var speed: int = 150

func _physics_process(delta):
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
