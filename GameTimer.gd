extends Node


var elapsed_time: float = 0.0
var running: bool = true


func _process(delta):

	if running:
		elapsed_time += delta



func stop_timer():

	running = false



func get_time():

	return elapsed_time



func get_formatted_time():

	var total_seconds = int(elapsed_time)

	var minutes = total_seconds / 60
	var seconds = total_seconds % 60

	return "%02d:%02d" % [minutes, seconds]
