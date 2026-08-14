extends CharacterBody2D


# ==========================================
# Boat Travel Settings
# ==========================================

@export_category("Boat Travel")

@export var destination_a: Vector2 = Vector2.ZERO
@export var destination_b: Vector2 = Vector2.ZERO

@export var travel_speed: float = 40.0
@export var stop_time: float = 10.0


# ==========================================
# Boat State
# ==========================================

var current_destination: Vector2
var waiting: bool = false
var traveling_to_a: bool = false
var wait_timer: float = 0.0


# ==========================================
# Player State
# ==========================================

var player = null
var player_on_boat: bool = false

var original_player_collision_mask: int = 0
var original_boat_collision_mask: int = 0


# ==========================================
# Start
# ==========================================

func _ready() -> void:
	current_destination = destination_b


# ==========================================
# Boat Movement
# ==========================================

func _physics_process(delta: float) -> void:

	# --------------------------------------
	# Waiting at destination
	# --------------------------------------

	if waiting:
		velocity = Vector2.ZERO

		wait_timer -= delta

		if wait_timer <= 0.0:
			waiting = false

			if traveling_to_a:
				current_destination = destination_b
				traveling_to_a = false
			else:
				current_destination = destination_a
				traveling_to_a = true

		return


	# --------------------------------------
	# Check if destination reached
	# --------------------------------------

	if global_position.distance_to(current_destination) <= 2.0:

		global_position = current_destination
		velocity = Vector2.ZERO

		# Release player
		release_player()

		# Start the 10 second pause
		waiting = true
		wait_timer = stop_time

		return


	# --------------------------------------
	# Move toward destination
	# --------------------------------------

	var previous_position := global_position

	var direction := global_position.direction_to(current_destination)

	velocity = direction * travel_speed

	move_and_slide()


	# --------------------------------------
	# Carry player with boat
	# --------------------------------------

	if player_on_boat and is_instance_valid(player):

		var boat_movement := global_position - previous_position

		player.global_position += boat_movement


# ==========================================
# Player Boarding
# ==========================================

func _on_boarding_area_body_entered(body: Node2D) -> void:

	if body.has_method("set_boat_state"):

		if player_on_boat:
			return

		player = body
		player_on_boat = true

		# Remember original collision settings
		original_player_collision_mask = player.collision_mask
		original_boat_collision_mask = collision_mask

		# Disable Player -> Boat collision
		player.collision_mask &= ~collision_layer

		# Disable Boat -> Player collision
		collision_mask &= ~player.collision_layer

		# Lock player movement
		player.set_boat_state(true)

		# Place player on boat
		player.global_position = $BoardingPoint.global_position


# ==========================================
# Release Player
# ==========================================

func release_player() -> void:

	if not player_on_boat:
		return

	if not is_instance_valid(player):
		player = null
		player_on_boat = false
		return

	# Move player to exit point
	player.global_position = $ExitPoint.global_position

	# Restore collision settings
	player.collision_mask = original_player_collision_mask
	collision_mask = original_boat_collision_mask

	# Allow player movement
	player.set_boat_state(false)

	# Clear player reference
	player = null
	player_on_boat = false
