extends CanvasLayer

@onready var welcome_panel = $WelcomePanel


func _ready():

	welcome_panel.visible = true
	
	await get_tree().create_timer(5.0).timeout
	
	welcome_panel.visible = false
