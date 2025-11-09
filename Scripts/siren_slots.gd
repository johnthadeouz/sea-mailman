extends Node3D
class_name SirenSlots

var slots:Array[bool] = [false,false,false,false,]

func get_available_slot():
	for slot_index in range(0,slots.size()):
		if slots[slot_index] == false:
			return slot_index
	return -1
	
func append_slave_and_get_position():
	var available_slot = get_available_slot()
	if available_slot >= 0:
		slots[available_slot] = true
		return $".".get_node(str(available_slot)).global_position
	return null

func clean_slots():
	slots = [false,false,false,false,]
	
