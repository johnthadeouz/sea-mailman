extends Node3D

@onready var buttons_frame = $Menu/Buttons
@onready var settings_frame = $Menu/Settings


func _unhandled_input(event: InputEvent) -> void:
	# Close settings frame with escape
	if settings_frame.visible and event.is_action_pressed("escape"):
		settings_frame.visible = false
		buttons_frame.visible = true
	
func _ready() -> void:
	pass # Replace with function body.

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ingame.tscn")

func _on_settings_pressed() -> void:
	buttons_frame.visible = false
	settings_frame.visible = true

func _on_quit_pressed() -> void:
	pass # Replace with function body.
