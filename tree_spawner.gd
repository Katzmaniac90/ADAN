extends Node2D

@export var tree_scene: PackedScene

@export var spawn_width := 500.0
@export var spawn_height := 400.0

@export var tree_count := 10

var trees = []

func _ready():
	for i in tree_count:
		spawn_tree()

func spawn_tree():

	var tree = tree_scene.instantiate()

	tree.global_position = get_random_position()

	get_parent().add_child(tree)

	trees.append(tree)
	
func get_random_position():

	return global_position + Vector2(

		randf_range(-spawn_width/2, spawn_width/2),

		randf_range(-spawn_height/2, spawn_height/2)

	)
