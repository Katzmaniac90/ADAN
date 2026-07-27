extends AudioStreamPlayer


var music_enabled := true


func _ready():

	finished.connect(_on_finished)


func _on_finished():

	play()


func toggle_music():

	music_enabled = !music_enabled

	if music_enabled:

		play()

	else:

		stop()


func _on_music_button_pressed():

	print("Music button pressed")

	var music = get_tree().get_first_node_in_group("music")

	print("Music found:", music)

	if music:

		music.toggle_music()

		print("Music enabled:", music.music_enabled)

		if music.music_enabled:
			$MusicButton.text = "Music: ON"
		else:
			$MusicButton.text = "Music: OFF"
