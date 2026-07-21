extends Area2D

@export_file("*.tscn") var destination_scene
@export var destination_spawn : String

var player_inside = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_inside:
		SceneManager.change_scene(
			destination_scene,
			destination_spawn
		)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		print("player hit the door")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
