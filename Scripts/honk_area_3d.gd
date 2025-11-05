extends Area3D

var targeted_siren:Siren = null

func interrupt_siren_song():
	if targeted_siren and targeted_siren.is_singing:
		await targeted_siren.break_song_and_die()
		get_parent().under_attack = false


func _on_siren_entered(siren: Siren) -> void:
	targeted_siren = siren


func _on_siren_exited(siren: Siren) -> void:
	targeted_siren = null
