extends Area2D

var player_nearby = false

@export_multiline var sign_text = "Welcome traveler!"

@onready var dialogue = get_tree().current_scene.get_node("DialogueUI")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		dialogue.show_message(sign_text)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		$Label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		$Label.visible = false
		dialogue.hide_message()
		
