extends Node3D
signal CHECKPOINT_TRIGGERED
@export var checkpoint_id: int = 0

func _on_ship_entered(ship: Node3D) -> void:
	emit_signal("CHECKPOINT_TRIGGERED",checkpoint_id)
