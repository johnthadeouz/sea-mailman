extends Node3D


func _ready() -> void:
	#$PauseMenu.UNPAUSE_TRIGGERED.connect(unpause_game)
	connect_checkpoint_islands()
	if SaveLoad.load_exists():
		load_ship()
		load_package()



func connect_checkpoint_islands():
	for island in $Env/Islands.get_children():
		island.CHECKPOINT_TRIGGERED.connect(save_progress)
		#print(island)
	

func save_progress(checkpoint_id:int):
	Global.increase_checkpoint_and_save($Ship.global_position, $Package.health, checkpoint_id)


func load_ship():
	$Ship.position = Global.ship_position
	
	
func load_package():
	$Package.health = Global.package_health


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		$PauseMenu.pause()


func _on_ship_package_collected(collected_package: Package) -> void:
	var attach_marker = $Ship.get_node("Marker3D") # Prüfe den Pfad!
	collected_package.pickup($Ship, attach_marker)
