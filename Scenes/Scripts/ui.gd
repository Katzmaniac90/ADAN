extends CanvasLayer

@onready var intro_screen = $IntroScreen
@onready var adventure_log = $AdventureLog
@onready var message_log = $AdventureLog/MessageLog
@onready var fade_timer = $MessageFadeTimer


func _ready():

	intro_screen.visible = true

	MessageManager.message_added.connect(add_message)

	fade_timer.timeout.connect(fade_messages)

	MessageManager.send_message("Welcome to ADAN!")

func add_message(text:String):

	adventure_log.modulate.a = 1.0

	message_log.append_text(text + "\n")

	message_log.scroll_to_line(
		message_log.get_line_count()
	)

	fade_timer.start()

func fade_messages():

	var tween = create_tween()

	tween.tween_property(
		adventure_log,
		"modulate:a",
		0.0,
		1.0
	)
