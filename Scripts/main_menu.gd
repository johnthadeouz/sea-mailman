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
		
		# Guter Stil: Sag Godot, dass wir das Event verbraucht haben
		get_viewport().set_input_as_handled()
		
		settings_frame.visible = false
		buttons_frame.visible = true
	
# Play button
func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(level_Scene)

# Show settings Frame and hide Buttons
func _on_settings_pressed() -> void:
	buttons_frame.visible = false
	settings_frame.visible = true

# Quit Button
func _on_quit_pressed() -> void:
	get_tree().quit()

# Sow Mouse and Keyboard Settings Frame
func _on_mnk_settings_pressed() -> void:
	$Menu/Settings/Frames/MnKFrame.show()
	$Menu/Settings/Frames/VideoFrame.hide()
	$Menu/Settings/Frames/AudioFrame.hide()


func _on_video_settings_pressed() -> void:
	$Menu/Settings/Frames/MnKFrame.hide()
	$Menu/Settings/Frames/VideoFrame.show()
	$Menu/Settings/Frames/AudioFrame.hide()


func _on_audio_settings_pressed() -> void:
	$Menu/Settings/Frames/MnKFrame.hide()
	$Menu/Settings/Frames/VideoFrame.hide()
	$Menu/Settings/Frames/AudioFrame.show()
