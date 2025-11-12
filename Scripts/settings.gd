extends PanelContainer

var recording
var effect:AudioEffectRecord


func _ready() -> void:
	var current_scene_name = get_tree().current_scene.name
	if current_scene_name == "MainMenu" and SaveLoad.loaded_settings_exists():
		SaveLoad.load_settings()
	_populate_microphone_button()
	_setup_test_recording()
	_load_ui_settings()


func _populate_microphone_button():
	var devices:PackedStringArray = AudioServer.get_input_device_list()
	#AudioServer.get_input_devices()
	if devices.is_empty():
		print("No microphones found.")
	else:
		var a:OptionButton = $Frames/AudioFrame/MarginContainer/VBoxContainer/MicrophoneButton
		for device_name in devices:
			a.add_item(device_name)

	## You can also get the currently selected device
	#var current_device = AudioServer.get_input_device()
	#print("Currently selected microphone: " + str(current_device))
#
	## To set a specific device (e.g., the first one in the list)
	#if not devices.is_empty():
		#AudioServer.set_input_device(devices[0])
		#print("Set microphone to: " + str(devices[0]))

func _setup_test_recording():
	var index = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index,0)


func _load_ui_settings():
	$Frames/AudioFrame/MarginContainer/VBoxContainer/MainVolume.value = Global.master_volume
	$Frames/AudioFrame/MarginContainer/VBoxContainer/MusicVolume.value = Global.music_volume
	$Frames/AudioFrame/MarginContainer/VBoxContainer/SfxVolume.value = Global.sfx_volume
	
	var mics = $Frames/AudioFrame/MarginContainer/VBoxContainer/MicrophoneButton
	var stored_mic = Global.microphone
	var connected_mics_amount = mics.get_item_count()
	var selected_mic = 0
	for mic_index in range(connected_mics_amount):
		var next_mic = mics.get_item_text(mic_index)
		if next_mic == stored_mic:
			selected_mic = mic_index
			Global.refresh_microphone(next_mic)
	mics.selected = selected_mic
	

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
	Global.refresh_bus_volume("Master", value)


func _on_music_volume_value_changed(value: float) -> void:
	Global.play_slider()
	Global.refresh_bus_volume("Music", value)


func _on_sfx_volume_value_changed(value: float) -> void:
	Global.play_slider()
	Global.refresh_bus_volume("SFX", value)


func _on_microphone_button_item_selected(index: int) -> void:
	var mic_name = $Frames/AudioFrame/MarginContainer/VBoxContainer/MicrophoneButton.get_item_text(index)
	Global.play_click()
	Global.refresh_microphone(mic_name)


func _on_button_button_down() -> void:
	effect.set_recording_active(true)
	$Frames/AudioFrame/MarginContainer/VBoxContainer/TestMicButton.text = "RELEASE TO HEAR"

func _on_test_mic_button_button_up() -> void:
	if effect.is_recording_active():
		$Frames/AudioFrame/MarginContainer/VBoxContainer/TestMicButton.disabled = true
		recording = effect.get_recording()
		effect.set_recording_active(false)
		$Frames/AudioFrame/MarginContainer/VBoxContainer/TestMicButton.text = "PLAYING..."
		$AudioPlayer.stream = recording
		$AudioPlayer.play()
		recording = null

func _on_audio_player_finished() -> void:
	$Frames/AudioFrame/MarginContainer/VBoxContainer/TestMicButton.disabled = false
	$Frames/AudioFrame/MarginContainer/VBoxContainer/TestMicButton.text = "HOLD TO RECORD"


func _on_save_pressed() -> void:
	SaveLoad.save_settings()
