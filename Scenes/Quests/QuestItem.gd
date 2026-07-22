extends Area2D

@export var item_name = "Parsnip"

var player_inside = false


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false


func _process(delta):

	if player_inside and Input.is_action_just_pressed("interact"):

		QuestManager.add_item(item_name)

		queue_free()
