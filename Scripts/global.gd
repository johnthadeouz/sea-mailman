extends Node3D

const OOW_BOUNDARY = 500
##INGAME DATA
var ship_position: Vector3 = Vector3(0,0,0)
var package_health: int = 100
var current_checkpoint: int = 0
var packages_delivered: int = 0
##SETTINGS
var master_volume:float = 0 #volume is on DB
var music_volume:float = 0 #volume is on DB
var sfx_volume:float = 0 #volume is on DB
var microphone:String = ""

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


func refresh_bus_volume(bus_index:String, value):
	match bus_index:
		"Master":
			master_volume = value
		"Music":
			music_volume = value
		"SFX":
			sfx_volume = value
	
	var bus = AudioServer.get_bus_index(bus_index)
	AudioServer.set_bus_volume_db(bus, value)
	if value <= -30 and !AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, true)
	else:
		if AudioServer.is_bus_mute(bus):
			AudioServer.set_bus_mute(bus, false)


func refresh_microphone(new_mic:String):
	microphone = new_mic
	AudioServer.set_input_device(new_mic)


func play_click():
	$Click.play()


func play_slider():
	$SlideSound.play()
