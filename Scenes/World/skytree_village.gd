extends Node2D

const PORTAL_SCENE = preload("res://Scenes/Portals/Portal.tscn")

@onready var ground: TileMapLayer = $GroundLayer
@onready var portal_spawn: Marker2D = $SkytreePortalSpawn


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
	
	#Spawning the portal if it has been unlocked	
	GameManager.portal_unlocked.connect(spawn_portal)
	
	if GameManager.is_portal_unlocked("ancient_portal"):
		spawn_portal()	


#Portal Logic
func spawn_portal():
	
	if has_node("AncientPortal"):
		return

	var portal = PORTAL_SCENE.instantiate()

	portal.name = "AncientPortal"
	add_child(portal)
	portal.global_position = portal_spawn.global_position

	portal.destination_scene = "res://Scenes/Buildings/myHouse.tscn"
	portal.destination_spawn = "SkytreePortal"
