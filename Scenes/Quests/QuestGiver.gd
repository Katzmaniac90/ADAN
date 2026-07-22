extends Area2D

@export var dialogue: Panel

var player_inside = false


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		print("player can talk to npc")


func _on_body_exited(body):
	player_inside = false
	print("player left npc")


func _process(delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		dialogue.open_dialog()
