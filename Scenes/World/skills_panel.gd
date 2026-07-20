extends Panel

signal woodcutting_changed

@onready var level_label = $Label
@onready var xp_bar = $ProgressBar

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

	update_skill()


func _process(delta):
	update_skill()


func update_skill():
	level_label.text = "Barkbreaking Lv. " + str(player.barkbreaking_level)

	xp_bar.max_value = player.barkbreaking_level * 100
	xp_bar.value = player.barkbreaking_xp
