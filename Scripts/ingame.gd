extends Node3D
var next_island = null


func _ready() -> void:
	#$PauseMenu.UNPAUSE_TRIGGERED.connect(unpause_game)
	next_island = get_island_by_checkpoint_id(Global.current_checkpoint + 1)
	connect_checkpoint_islands()
	if SaveLoad.load_exists():
		load_ship()
		load_package()


func _process(delta: float) -> void:
	if not next_island == null:
		print(next_island)
		$Ship.face_compass_to_next_island(next_island.global_position)


func connect_checkpoint_islands():
	for island in $Env/Islands.get_children():
		island.CHECKPOINT_TRIGGERED.connect(save_progress)


func get_island_by_checkpoint_id(id):
	for island in $Env/Islands.get_children():
		if island.checkpoint_id == id:
			return island
	return null

func save_progress(checkpoint_id:int):
	Global.increase_checkpoint_and_save($Ship.global_position, $Package.health, checkpoint_id)
	next_island = get_island_by_checkpoint_id(Global.current_checkpoint + 1)

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
