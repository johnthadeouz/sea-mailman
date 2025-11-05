extends Area3D
class_name Package_Goal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Ship) -> void:
	if body.is_in_group("Player") and body.package:
		Global.deliver_package(body.package)
	else:
		print("body has no package")
