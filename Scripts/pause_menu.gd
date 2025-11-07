extends CanvasLayer
signal UNPAUSE_TRIGGERED

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("escape"):
		if $Settings.visible:
			$Settings.visible = false
			$Buttons.visible = true
		else:
			unpause_game()


func unpause_game():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("fadeout")
		await $AnimationPlayer.animation_finished
		get_tree().paused = false


func pause():
	if not $AnimationPlayer.is_playing():
		get_tree().paused = true
		$AnimationPlayer.play("fadein")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	unpause_game()
	#emit_signal("UNPAUSE_TRIGGERED")


func _on_settings_pressed() -> void:
	$Settings.visible = true
	$Buttons.visible = false


func _on_back_to_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
