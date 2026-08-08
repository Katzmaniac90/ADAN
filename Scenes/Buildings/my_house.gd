extends Node2D

@onready var ground: TileMapLayer = $GroundLayer

func _ready():
		
	# Get the rectangle of tiles that are actually used
	var used = ground.get_used_rect()

	# Size of one tile (for example 16x16 or 32x32)
	var tile_size = ground.tile_set.tile_size

	# Convert tile coordinates to pixel coordinates
	var left = int(used.position.x * tile_size.x)
	var top = int(used.position.y * tile_size.y)
	var right = int((used.position.x + used.size.x) * tile_size.x)
	var bottom = int((used.position.y + used.size.y) * tile_size.y)

	# Find the player
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.set_camera_limits(left, top, right, bottom)

	
