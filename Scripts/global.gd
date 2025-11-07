extends Node3D

var ship_position: Vector3 = Vector3(0,0,0)
var package_health: int = 100
var current_checkpoint: int = 0
var packages_delivered: int = 0

func _ready() -> void:
	SaveLoad.load_game()

func deliver_package(package: Package):
	packages_delivered += 1
	package.queue_free()
	print(packages_delivered)
#current_checkpoint will increase only if ship touches checkpoints in order (1->2->3->4).
func increase_checkpoint_and_save(ship_pos:Vector3, package_hp:int, checkpoint:int): 
	if current_checkpoint+1 == checkpoint:
		ship_position = ship_pos
		package_health = package_hp
		current_checkpoint += 1
		SaveLoad.save_game()
		print("game saved! ,current checkpoint:",current_checkpoint)

func play_click():
	$Click.play()

func play_slider():
	$SlideSound.play()
