extends CanvasLayer


func _ready():

	visible = false

func show_end_screen():

	visible = true

	$Panel/ThanksLabel.text = "Thanks for playing ADAN!"

	$Panel/TimeLabel.text = (
		"Completion Time: "
		+ GameTimer.get_formatted_time()
	)
