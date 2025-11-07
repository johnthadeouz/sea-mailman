extends Node3D
class_name Package

@export var health: int = 30
@onready var collider:CSGBox3D = $CSGBox3D

func take_damage(damage: int):
	health -= damage
	print(health)
	if health <= 0:
		health = 0
		call_deferred("change_scene")
		
func pickup(new_parent: CharacterBody3D, attach_marker: Marker3D):
	reparent(new_parent)

	global_position = attach_marker.global_position
	global_rotation = attach_marker.global_rotation
	
	if collider:
		collider.collision_layer = 0 
		
func change_scene():
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
	
