extends Node2D


@export_category("Portal Settings")

@export var portal_id: String = "ancient_portal"

@export_file("*.tscn") var destination_scene: String

@export var destination_spawn: String = ""


@export_category("Portal Appearance")

@export var portal_scene: PackedScene = preload("res://Scenes/Portals/Portal.tscn")


func _ready():

	GameManager.portal_unlocked.connect(_on_portal_unlocked)

	if GameManager.is_portal_unlocked(portal_id):

		spawn_portal()


func _on_portal_unlocked(unlocked_id: String):

	if unlocked_id == portal_id:

		spawn_portal()


func spawn_portal():

	if has_node("Portal"):

		return


	if portal_scene == null:

		print("ERROR: Portal scene is not assigned.")

		return


	var portal = portal_scene.instantiate()

	portal.name = "Portal"


	portal.destination_scene = destination_scene

	portal.destination_spawn = destination_spawn


	add_child(portal)

	portal.global_position = global_position
