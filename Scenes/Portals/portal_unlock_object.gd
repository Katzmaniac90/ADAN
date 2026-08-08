extends Area2D


var player_nearby = false


@export_category("Portal Settings")
@export var portal_id: String = "ancient_portal"



func _ready() -> void:

	# If this portal has already been unlocked,
	# remove the object immediately

	if GameManager.is_portal_unlocked(portal_id):

		queue_free()



func _process(delta: float) -> void:

	if player_nearby and Input.is_action_just_pressed("interact"):

		unlock_portal()



func unlock_portal():

	print("Unlocked portal: ", portal_id)

	GameManager.unlock_portal(portal_id)

	queue_free()



func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):

		player_nearby = true
		$InteractLabel.visible = true



func _on_body_exited(body: Node2D) -> void:

	if body.is_in_group("player"):

		player_nearby = false
		$InteractLabel.visible = false
