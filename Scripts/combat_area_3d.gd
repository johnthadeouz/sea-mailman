extends Area3D
var siren_in_range:Siren = null
var ship:Ship = null

func _on_siren_entered(siren: Siren) -> void:
	siren_in_range = siren
	siren.start_attacking(ship)
	var combat_started = await siren.COMBAT_STARTED
	if combat_started and siren_in_range and not ship.under_attack:
		ship.under_attack = true


func _on_body_exited(siren: Siren) -> void:
	if not siren.current_state == siren.state.FLEEING:
		siren.chase_ship(ship)
	siren_in_range = null
