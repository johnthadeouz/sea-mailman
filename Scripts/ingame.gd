extends Node3D


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_ship_package_collected(collected_package: Package) -> void:
	var attach_marker = $Ship.get_node("Marker3D") # Prüfe den Pfad!
	collected_package.pickup($Ship, attach_marker)
