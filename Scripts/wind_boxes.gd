extends Node3D
var last_ship_pos:Vector3 = Vector3(99999,99999,99999)


func get_fartest_windbox():
	var ship_pos:Vector3 = $"../Ship".global_position
	var fartest_windbox = get_child(0)
	var distance_ship_current_fartest = ship_pos.distance_to(fartest_windbox.global_position)
	for index in range(1,get_child_count()-1):
		var new_child_pos = get_child(index).global_position
		var distance_ship_new_child = ship_pos.distance_to(new_child_pos)
		if distance_ship_new_child > distance_ship_current_fartest:
			fartest_windbox = get_child(index)
	fartest_windbox.global_position = $"../Ship/WindMarker".global_position
	var next_island = $"..".get_island_by_checkpoint_id(Global.current_checkpoint + 1)
	fartest_windbox.look_at(next_island.global_position, Vector3.UP)

var wind_frame = 0
func _physics_process(delta: float) -> void:
	var ship_pos:Vector3 = $"../Ship".global_position
	if ship_pos.distance_to(last_ship_pos) > 3:
		wind_frame += 1
		last_ship_pos = ship_pos
		if wind_frame % 10 == 0:
			wind_frame = 0
			get_fartest_windbox()
			print("MOVING WIND")
