extends Node3D

@onready var buttons_frame = $Menu/Buttons
@onready var settings_frame = $Menu/Settings
@onready var resolution_button = $Menu/Settings/Frames/VideoFrame/MarginContainer/ResolutionButton

@export var level_Scene: PackedScene

# Allowed Resolutions
const RESOLUTIONS = {
	"1920x1080": Vector2i(1920, 1080),
	"1600x900": Vector2i(1600, 900),
	"1366x768": Vector2i(1366, 768),
	"1280x720": Vector2i(1280, 720)
}

func _ready() -> void:
	pass

# Close settings with escape
func _unhandled_input(event: InputEvent) -> void:
	if settings_frame.visible and event.is_action_pressed("escape"):
		
		get_viewport().set_input_as_handled()
		
		settings_frame.hide()
		buttons_frame.show()
	
# Play button
func _on_play_pressed() -> void:
	Global.play_click()
	get_tree().change_scene_to_packed(level_Scene)

# Show settings Frame and hide Buttons
func _on_settings_pressed() -> void:
	Global.play_click()
	buttons_frame.hide()
	settings_frame.show()

# Quit Button
func _on_quit_pressed() -> void:
	Global.play_click()
	get_tree().quit()

# Show Mouse and Keyboard Settings Frame
func _on_mnk_settings_pressed() -> void:
	Global.play_click()
	$Menu/Settings/Frames/MnKFrame.show()
	$Menu/Settings/Frames/VideoFrame.hide()
	$Menu/Settings/Frames/AudioFrame.hide()

# Show Video Settings Frame
func _on_video_settings_pressed() -> void:
	Global.play_click()
	$Menu/Settings/Frames/MnKFrame.hide()
	$Menu/Settings/Frames/VideoFrame.show()
	$Menu/Settings/Frames/AudioFrame.hide()

# Show Audio Settings Frame
func _on_audio_settings_pressed() -> void:
	Global.play_click()
	$Menu/Settings/Frames/MnKFrame.hide()
	$Menu/Settings/Frames/VideoFrame.hide()
	$Menu/Settings/Frames/AudioFrame.show()

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
