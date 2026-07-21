extends Node

var spawn_id : String = ""
var player = null

func change_scene(scene_path : String, entrance : String):
	spawn_id = entrance
	get_tree().change_scene_to_file(scene_path)
