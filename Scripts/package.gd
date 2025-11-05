extends Node3D
class_name Package

@export var health = 30

func take_damage(damage: int):
	health -= damage
	print(health)
	if health <= 0:
		health = 0
		get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
