class_name read_JSON

static func get_dict(json_file_path: String) -> Dictionary:
	var file : FileAccess = FileAccess.open(json_file_path, FileAccess.READ);
	if (file == null):
		return {};
	var content : String = file.get_as_text();
	if (content != null):
		return JSON.parse_string(content);
	else:
		return {};
	
