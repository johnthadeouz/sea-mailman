extends Area3D
var siren_in_range:Siren = null


func _on_siren_entered(siren: Siren) -> void:
	var ship:Ship = get_parent()
	siren_in_range = siren
	siren.start_attacking(ship)
	await get_tree().create_timer(1.0).timeout
	if siren_in_range and not ship.under_attack:
		ship.under_attack = true



func _on_body_exited(siren: Siren) -> void:
	var ship:Ship = get_parent()
	siren.chase_ship(get_parent())
	siren_in_range = null
