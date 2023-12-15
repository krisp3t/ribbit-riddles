class_name read_JSON

static func get_dict(json_file_path: String) -> Dictionary:
	var file : FileAccess = FileAccess.open(json_file_path, FileAccess.READ);
	var content : String = file.get_as_text();
	return JSON.parse_string(content);
	
