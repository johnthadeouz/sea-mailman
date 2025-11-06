extends Area3D

var targeted_siren:Siren = null


func interrupt_siren_song():
	if targeted_siren and targeted_siren.is_singing:
		var master = targeted_siren.master
		await targeted_siren.break_song_and_die()
		if master.is_coward and master.slaves.size() <= (master.MAX_SLAVES/2):
			get_parent().under_attack = false

			for slave in master.slaves:
				var opposed_dir = slave.global_position.direction_to(get_parent().position).normalized()
				slave.flee(-opposed_dir)
			var opposed_dir2 = master.global_position.direction_to(get_parent().position).normalized()
			master.flee(-opposed_dir2)
				
				
		elif master.slaves.size() == 0:
			get_parent().under_attack = false
			var opposed_dir = master.global_position.direction_to(get_parent().position).normalized()
			master.flee(-opposed_dir)


func _on_siren_entered(siren: Siren) -> void:
	targeted_siren = siren


func _on_siren_exited(siren: Siren) -> void:
	targeted_siren = null
