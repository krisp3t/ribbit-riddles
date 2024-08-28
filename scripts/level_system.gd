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
	if (level_info["difficulty"] == level_const.DIFFICULTY.CUSTOM):
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
	var dict: Dictionary;
	if (level >= 1 and level <= MAX_EASY):
		dict = level_const.INFO[level_const.DIFFICULTY.EASY];
	elif (level >= MAX_INTERMEDIATE + 1 and level <= MAX_HARD):
		dict = level_const.INFO[level_const.DIFFICULTY.HARD];
	elif (level >= MAX_HARD + 1 and level <= MAX_EXPERT):
		dict = level_const.INFO[level_const.DIFFICULTY.EXPERT];
	else:
		dict = level_const.INFO[level_const.DIFFICULTY.CUSTOM];

	if (!dict["path"]):
		dict["path"] = dict["name"];

	dict["path_bg"] = level_const.LEVELS_PATH + dict["folder_name"] + "/bg.jpg";
	dict["path_progress_bar"] = level_const.LEVELS_PATH + dict["folder_name"] + "/progress_bar.png";
	dict["all_levels"] = read_JSON.get_dict(level_const.CUSTOM_LEVELS_PATH + dict["folder_name"] + "/layout.json");
	if dict["all_levels"].has(str(level)):
		dict["layout"] = dict["all_levels"][str(level)];
	else:
		# New custom level does not have a layout already
		dict["layout"] = [
			[0, 0, 0],
			[0, 0],
			[0, 0, 0],
			[0, 0],
			[0, 0, 0]
		];
	dict["savegame"] = load_savegame(level_const.SAVEGAME_PATH + dict["folder_name"] + ".json");
	dict["solved"] = dict["savegame"].get(str(level), false);
	return dict;

func is_completed_difficulty(difficulty: level_const.DIFFICULTY) -> bool:
	var dict: Dictionary = get_level_info(difficulty);
	if (difficulty == level_const.DIFFICULTY.CUSTOM):
		return dict["all_levels"].size() > 0;
	return dict["savegame"].size() == len(dict["all_levels"]);
	
func get_lilypad_array_ix(coord: Vector2i) -> Vector2i:
	var y: int;
	if (coord.x % 2 == 0):
		y = floor(coord.y) / 2;
	else:
		y = floor(coord.y - 1) / 2;
	return Vector2i(y, coord.x);

func update_level_layout(coord: Vector2i, value: lilypad_enum.STATUS):
	var lilypad: Vector2i = get_lilypad_array_ix(coord);
	level_info["layout"][lilypad.y][lilypad.x] = value;
