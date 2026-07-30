extends CharacterBody2D

@export_category("NPC Information")
@export var npc_name: String = "NPC"
@export_multiline var dialogue_text: String = "Hello there!"

@export_category("Movement")
@export var wander_radius_blocks: float = 10.0
@export var tile_size: float = 16.0
@export var walk_speed: float = 50.0
@export var min_wait_time: float = 1.5
@export var max_wait_time: float = 4.0
@export_category("Interaction")
@export var interaction_action: String = "interact"

@onready var interaction_area: Area2D = $InteractionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wander_timer: Timer = $WanderTimer
@onready var dialogue_ui: CanvasLayer = $DialogueUI
@onready var dialogue_panel: Panel = $DialogueUI/Panel
@onready var name_label: Label = $DialogueUI/Panel/VBoxContainer/NameLabel
@onready var dialogue_text_label: RichTextLabel = $DialogueUI/Panel/VBoxContainer/DialogueText
@onready var close_button: Button = $DialogueUI/Panel/VBoxContainer/CloseButton

var home_position: Vector2
var target_position: Vector2
var waiting: bool = false
var player_in_range: bool = false
var dialogue_open: bool = false


func _ready() -> void:
	home_position = global_position
	dialogue_ui.visible = false
	close_button.pressed.connect(close_dialogue)
	
	choose_new_wander_target()
	start_wander_timer()


func _physics_process(_delta: float) -> void:

	if waiting:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		return

	var distance := global_position.distance_to(target_position)

	if distance <= 4.0:
		velocity = Vector2.ZERO
		waiting = true
		animated_sprite.play("idle")

		start_wander_timer()
		return

	var direction := global_position.direction_to(target_position)

	velocity = direction * walk_speed

	update_animation(direction)

	move_and_slide()

func _process(_delta: float) -> void:
	if player_in_range and not dialogue_open:
		if Input.is_action_just_pressed(interaction_action):
			open_dialogue()

func choose_new_wander_target() -> void:

	var radius := wander_radius_blocks * tile_size

	var random_offset := Vector2(
		randf_range(-radius, radius),
		randf_range(-radius, radius)
	)

	target_position = home_position + random_offset


func start_wander_timer() -> void:

	wander_timer.wait_time = randf_range(
		min_wait_time,
		max_wait_time
	)

	wander_timer.start()


func _on_wander_timer_timeout() -> void:

	choose_new_wander_target()
	waiting = false


# ============================================================
# ANIMATION
# ============================================================
func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.y > 0:
			animated_sprite.play("downWalking")
		else:
			animated_sprite.play("upWalking")
	else:
		if direction.x > 0:
			animated_sprite.play("rightWalking")
		else:
			animated_sprite.play("leftWalking")


func get_idle_animation() -> String:
	var current_animation := animated_sprite.animation

	match current_animation:
		"rightWalking":
			return "idle"
		"leftWalking":
			return "idle"
		"upWalking":
			return "idle"
		"downWalking":
			return "idle"

	return "idle"


func open_dialogue() -> void:
	dialogue_open = true

	name_label.text = npc_name
	dialogue_text_label.text = dialogue_text

	dialogue_ui.visible = true

	close_button.grab_focus()


func close_dialogue() -> void:
	dialogue_open = false
	dialogue_ui.visible = false


func _safe_move() -> void:
	move_and_slide()

# ============================================================
# INTERACTION
# ============================================================
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		$InteractPrompt.visible = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		$InteractPrompt.visible = false
