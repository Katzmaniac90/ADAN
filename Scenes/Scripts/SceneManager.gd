extends Node

var spawn_id : String = ""
var player = null
var is_transitioning := false


func change_scene(scene_path : String, entrance : String):
	if is_transitioning:
		return
	is_transitioning = true
	spawn_id = entrance
	await Transition.fade_out()
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await Transition.fade_in()
	is_transitioning = false
