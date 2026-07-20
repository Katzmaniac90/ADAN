extends Node2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	print("Something touched the log: ", body.name)

	if body.name == "Player":
		print("PLAYER PICKED UP LOG!")
		body.add_item("Wood Log", 1)
		queue_free()
