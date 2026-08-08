extends Area2D


var player_nearby = false


@export_category("Portal Destination")

@export_file("*.tscn")
var destination_scene: String


@export var destination_spawn: String = ""



func _process(delta: float) -> void:

	if player_nearby and Input.is_action_just_pressed("interact"):

		enter_portal()



func enter_portal():

	print("Entering portal")

	SceneManager.change_scene(
		destination_scene,
		destination_spawn
	)



func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):

		player_nearby = true
		$InteractLabel.visible = true



func _on_body_exited(body: Node2D) -> void:

	if body.is_in_group("player"):

		player_nearby = false
		$InteractLabel.visible = false
