extends PanelContainer


# Show Mouse and Keyboard Settings Frame
func _on_mnk_settings_pressed() -> void:
	Global.play_click()
	$Frames/MnKFrame.show()
	$Frames/VideoFrame.hide()
	$Frames/AudioFrame.hide()

# Show Video Settings Frame
func _on_video_settings_pressed() -> void:
	Global.play_click()
	$Frames/MnKFrame.hide()
	$Frames/VideoFrame.show()
	$Frames/AudioFrame.hide()

# Show Audio Settings Frame
func _on_audio_settings_pressed() -> void:
	Global.play_click()
	$Frames/MnKFrame.hide()
	$Frames/VideoFrame.hide()
	$Frames/AudioFrame.show()

# Change The Main Volume
func _on_main_volume_value_changed(value: float) -> void:
	Global.play_slider()
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, value)
	
	# Muting the Bus if its at -30 
	if value <= -30 and !AudioServer.is_bus_mute(bus_index):
		AudioServer.set_bus_mute(bus_index, true)
	else:
		if AudioServer.is_bus_mute(bus_index):
			AudioServer.set_bus_mute(bus_index, false)


func _on_music_volume_value_changed(value: float) -> void:
	Global.play_slider()
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, value)
	if value <= -30 and !AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, true)
	else:
		if AudioServer.is_bus_mute(bus):
			AudioServer.set_bus_mute(bus, false)
