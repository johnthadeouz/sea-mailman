extends Node
const SAVE_PATH = "user://boatgamesavefile.sv"


func load_exists()->bool:
	return FileAccess.file_exists(SAVE_PATH)


func save_game():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
	"ship_position" = Global.ship_position,
	"package_health" = Global.package_health,
	"current_checkpoint" = Global.current_checkpoint,
	}
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)


func load_game():
	if not load_exists():
		return
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON PARSE ERROR:", json.get_error_message()," in ",json_string," at line ",json.get_error_line())
		return
	var line_data = json.data
	Global.ship_position = str_to_var("Vector3" + line_data["ship_position"])
	Global.package_health = line_data["package_health"]
	Global.current_checkpoint = line_data["current_checkpoint"]
