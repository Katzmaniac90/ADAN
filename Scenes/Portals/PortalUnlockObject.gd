extends Area2D


@export_category("Portal Unlock")

@export var portal_id: String = "ancient_portal"


@export_category("Interaction")

@export var interaction_text: String = "Interact"


var player_nearby := false
var unlocked := false


@onready var label = $InteractLabel


func _ready():

	if GameManager.is_portal_unlocked(portal_id):

		unlocked = true

		visible = false

		set_process(false)

		return

	label.visible = false


func _process(_delta):

	if unlocked:
		return


	if player_nearby and Input.is_action_just_pressed("interact"):

		unlock_portal()


func _on_body_entered(body: Node2D):

	if body.is_in_group("player"):

		player_nearby = true

		label.text = interaction_text

		label.visible = true


func _on_body_exited(body: Node2D):

	if body.is_in_group("player"):

		player_nearby = false

		label.visible = false


func unlock_portal():

	if unlocked:
		return


	unlocked = true


	GameManager.unlock_portal(portal_id)


	label.visible = false

	visible = false
