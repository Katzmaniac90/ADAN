extends CanvasLayer

@onready var welcome_panel = $WelcomePanel

func _ready():
	welcome_panel.visible = true
	
	await get_tree().create_timer(5.0).timeout
	
	welcome_panel.visible = false


func _on_craft_button_pressed():
	GameManager.craft_wooden_axe()
