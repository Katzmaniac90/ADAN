extends Node2D

@onready var ground: TileMapLayer = $GroundLayer

func _ready():

	#=================================================
	# CAMERA LIMITS
	#=================================================

	var used = ground.get_used_rect()
	var tile_size = ground.tile_set.tile_size

	var left = int(used.position.x * tile_size.x)
	var top = int(used.position.y * tile_size.y)
	var right = int((used.position.x + used.size.x) * tile_size.x)
	var bottom = int((used.position.y + used.size.y) * tile_size.y)

	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.set_camera_limits(
			left,
			top,
			right,
			bottom
		)
