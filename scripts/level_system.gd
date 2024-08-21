extends Node2D

var level_num: int;
var level_info: Dictionary;
var background: Resource;
var next_background: Resource;

var MAX_EASY: int = read_JSON.get_dict("res://levels/easy/layout.json").size();
var MAX_INTERMEDIATE: int = read_JSON.get_dict("res://levels/intermediate/layout.json").size() + MAX_EASY;
var MAX_HARD: int = read_JSON.get_dict("res://levels/hard/layout.json").size() + MAX_INTERMEDIATE;
var MAX_EXPERT: int = read_JSON.get_dict("res://levels/expert/layout.json").size() + MAX_HARD;

func _ready() -> void:
	var next_info: Dictionary = get_level_info(1);
	ResourceLoader.load_threaded_request(next_info["path_bg"]);
	initialize(1);

func initialize(level: int) -> void:
	level_num = level;
	level_info = get_level_info(level_num);
	background = ResourceLoader.load_threaded_get(level_info["path_bg"]);
	# If background thread failed to load bg, load normally
	if background == null:
		background = load(level_info["path_bg"]);
	queue_next_bg();
	
func queue_next_bg() -> void:
	var next_info: Dictionary = get_level_info(level_num + 1);
	ResourceLoader.load_threaded_request(next_info["path_bg"]);
	

func save_created_level() -> void:
	if !(DirAccess.dir_exists_absolute("user://levels")):
		var dir: DirAccess = DirAccess.open("user://");
		dir.make_dir("levels");
	var dict: Dictionary = read_JSON.get_dict(level_const.CUSTOM_LEVELS_PATH);
	dict[level_num] = level_info["layout"];
	var json: String = JSON.stringify(dict);
	var file: FileAccess = FileAccess.open(level_const.CUSTOM_LEVELS_PATH, FileAccess.WRITE);
	file.store_line(json);
	
func load_savegame(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {};
	return read_JSON.get_dict(path);

func save_savegame() -> void:
	if (level_info["difficulty"] == level_enum.DIFFICULTY.CUSTOM):
		return ;
		
	if !(DirAccess.dir_exists_absolute("user://savegames")):
		Logger.warn("Savegames directory does not exist, creating...");
		var dir: DirAccess = DirAccess.open("user://");
		dir.make_dir("savegames");
	var dict: Dictionary = level_info["path_savegame"];
	dict[level_num] = true;
	var json: String = JSON.stringify(dict);
	var file: FileAccess = FileAccess.open(level_info["savegame_path"], FileAccess.WRITE);
	file.store_line(json);
		
func get_level_info(level: int) -> Dictionary:
	var dict: Dictionary = {};
	if (level >= 1 and level <= MAX_EASY):
		dict["difficulty"] = level_const.DIFFICULTY.EASY;
		dict["name"] = "Frogspawn";
		dict["path"] = "res://levels/easy";
		dict["dif"] = "res://assets/bg_1.jpg";
		dict["difficulty_progress_bar"] = "res://assets/difficulty/easy.png";
		dict["difficulty_levels"] = read_JSON.get_dict("res://levels/easy.json");
		dict["path_savegame"] = "user://savegames/easy.json";
		dict["level_layout"] = dict["difficulty_levels"][str(level)];
		dict["savegame"] = load_savegame(new_info["savegame_path"]);
	elif (level >= MAX_EASY + 1 and level <= MAX_INTERMEDIATE):
		dict["difficulty"] = level_const.DIFFICULTY.INTERMEDIATE;
		dict["path"] = "res://levels/intermediate";
		dict["path_savegame"] = "user://savegames/intermediate.json";
		dict["name"] = "Tadpole";
	elif (level >= MAX_INTERMEDIATE + 1 and level <= MAX_HARD):
		dict["difficulty"] = level_const.DIFFICULTY.HARD;
		dict["path"] = "res://levels/hard";
		dict["path_savegame"] = "user://savegames/hard.json";
		dict["name"] = "Froglet";
	elif (level >= MAX_HARD + 1 and level <= MAX_EXPERT):
		dict["difficulty"] = level_const.DIFFICULTY.EXPERT;
		dict["path"] = "res://levels/expert";
		dict["path_savegame"] = "user://savegames/expert.json";
		dict["name"] = "Helltoad";
	else:
		dict["difficulty"] = level_const.DIFFICULTY.CUSTOM;
		dict["path"] = level_const.CUSTOM_LEVEL_PATH;
		dict["name"] = "Custom";

	if (!dict[path]):
		dict["path"] = "res://levels/" + dict["name"];
		dict["user_path"] = "user://levels/" + dict["name"];
		dict["path_savegame"] = "user://savegames/" + dict["name"] + ".json";
	
	dict["path_bg"] = dict["path"] + "/bg.jpg";
	dict["path_progress_bar"] = dict["path"] + "/progress_bar.png";
	dict["path_"]
	dict["layout"] = read_JSON.get_dict(dict["path"] + "/layout.json")[str(level)];
	
	# 	new_info["difficulty"] = level_enum.DIFFICULTY.CUSTOM;
	# 	new_info["difficulty_name"] = "Custom";
	# 	new_info["difficulty_bg"] = "res://custom/bg.png";
	# 	new_info["difficulty_progress_bar"] = "";
	# 	new_info["difficulty_levels"] = read_JSON.get_dict(level_enum.CUSTOM_LEVELS_PATH);
	# 	if new_info["difficulty_levels"].has(str(level)):
	# 		new_info["level_layout"] = new_info["difficulty_levels"][str(level)];
	# 	else:
	# 		new_info["level_layout"] = [
	# 			[0, 0, 0],
	# 			[0, 0],
	# 			[0, 0, 0],
	# 			[0, 0],
	# 			[0, 0, 0]
	# 		];
	# 	new_info["savegame_path"] = "";
	# 	new_info["savegame"] = {}
	# new_info["solved"] = new_info["savegame"].get(str(level), false);
	dict["path"] = "res://levels/" + dict["name"];
	dict["path_bg"] = dict["path"] + "/bg.jpg";
	dict["path_progress_bar"] = dict["path"] + "/progress_bar.png";
	return dict;

func is_completed_difficulty(difficulty: level_enum.DIFFICULTY) -> bool:
	var savegame: Dictionary = {};
	var custom_levels: Dictionary = read_JSON.get_dict(level_enum.CUSTOM_LEVELS_PATH);
	var level_info: Dictionary = {};
	match difficulty:
		level_enum.DIFFICULTY.EASY:
			savegame = load_savegame(level_enum.EASY_SAVEGAME);
			level_info = get_level_info(level_enum.MAX_EASY);
		level_enum.DIFFICULTY.INTERMEDIATE:
			savegame = load_savegame(level_enum.INTERMEDIATE_SAVEGAME);
			level_info = get_level_info(level_enum.MAX_INTERMEDIATE);
		level_enum.DIFFICULTY.HARD:
			savegame = load_savegame(level_enum.HARD_SAVEGAME);
			level_info = get_level_info(level_enum.MAX_HARD);
		level_enum.DIFFICULTY.EXPERT:
			savegame = load_savegame(level_enum.EXPERT_SAVEGAME);
			level_info = get_level_info(level_enum.MAX_EXPERT);
		_:
			return custom_levels.size() > 0;
	return savegame.size() == len(level_info["difficulty_levels"]);
	
func get_lilypad_array_ix(coord: Vector2i) -> Vector2i:
	var y: int;
	if (coord.x % 2 == 0):
		y = floor(coord.y) / 2;
	else:
		y = floor(coord.y - 1) / 2;
	return Vector2i(y, coord.x);

func update_level_layout(coord: Vector2i, value: lilypad_enum.STATUS):
	var lilypad: Vector2i = get_lilypad_array_ix(coord);
	info["level_layout"][lilypad.y][lilypad.x] = value;
