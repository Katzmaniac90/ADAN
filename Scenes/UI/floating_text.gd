extends Node2D


@export var float_speed := 40.0
@export var lifetime := 1.0

@onready var text_label: Label = $Label


func _ready():

	await get_tree().create_timer(lifetime).timeout

	queue_free()



func set_text(new_text:String):

	text_label.text = new_text



func _process(delta):

	position.y -= float_speed * delta
