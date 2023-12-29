extends Node2D

var current_level : int;
var info : Dictionary;
var background : Resource;
var next_background : Resource;
var muted : bool = false;

func initialize(level : int) -> void:
	current_level = level;
	info = level_enum.get_level_info(current_level);
	background = ResourceLoader.load_threaded_get(info["difficulty_bg"]);
	# If background thread failed to load bg, load normally
	if background == null:
		background = load(info["difficulty_bg"]);
	queue_next_bg();
	
func queue_next_bg() -> void:
	var next_info : Dictionary = level_enum.get_level_info(current_level + 1);
	ResourceLoader.load_threaded_request(next_info["difficulty_bg"]);
	
func _ready() -> void:
	var next_info : Dictionary = level_enum.get_level_info(1);
	ResourceLoader.load_threaded_request(next_info["difficulty_bg"]);
	initialize(1);

static func load_savegame(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {};
	return read_JSON.get_dict(path);

func save_savegame() -> void:
	if !(DirAccess.dir_exists_absolute("user://savegames")):
		var dir : DirAccess = DirAccess.open("user://");	
		dir.make_dir("savegames");
	var dict : Dictionary = info["savegame"];
	dict[current_level] = true;
	var json : String = JSON.stringify(dict);
	var file : FileAccess = FileAccess.open(info["savegame_path"], FileAccess.WRITE);
	file.store_line(json);
		
static func get_level_info(level: int) -> Dictionary:
	var new_info : Dictionary = {};
	if (level >= 1 and level <= level_enum.MAX_EASY):
		new_info["difficulty"] = level_enum.DIFFICULTY.EASY;
		new_info["difficulty_name"] = "Frogspawn";
		new_info["difficulty_bg"] = "res://assets/bg_1.png";
		new_info["difficulty_progress_bar"] = "res://assets/difficulty/easy.png";
		new_info["difficulty_levels"] = read_JSON.get_dict("res://levels/easy.json");
		new_info["level_layout"] = new_info["difficulty_levels"][str(level)];
		new_info["savegame_path"] = level_enum.EASY_SAVEGAME;
		new_info["savegame"] = load_savegame(new_info["savegame_path"]);
	elif (level >= level_enum.MAX_EASY + 1 and level <= level_enum.MAX_INTERMEDIATE):
		new_info["difficulty"] = level_enum.DIFFICULTY.INTERMEDIATE;
		new_info["difficulty_name"] = "Tadpole";
		new_info["difficulty_bg"] = "res://assets/bg_2.png";
		new_info["difficulty_progress_bar"] = "res://assets/difficulty/intermediate.png";
		new_info["difficulty_levels"] = read_JSON.get_dict("res://levels/intermediate.json");
		new_info["level_layout"] = new_info["difficulty_levels"][str(level)];
		new_info["savegame_path"] = level_enum.INTERMEDIATE_SAVEGAME;
		new_info["savegame"] = load_savegame(new_info["savegame_path"]);
	elif (level >= level_enum.MAX_INTERMEDIATE + 1 and level <= level_enum.MAX_HARD):
		new_info["difficulty"] = level_enum.DIFFICULTY.HARD;
		new_info["difficulty_name"] = "Froggy";
		new_info["difficulty_bg"] = "res://assets/bg_3.png";
		new_info["difficulty_progress_bar"] = "res://assets/difficulty/hard.png";
		new_info["difficulty_levels"] = read_JSON.get_dict("res://levels/hard.json");
		new_info["level_layout"] = new_info["difficulty_levels"][str(level)];
		new_info["savegame_path"] = level_enum.HARD_SAVEGAME;
		new_info["savegame"] = load_savegame(new_info["savegame_path"]);
	elif (level >= level_enum.MAX_HARD + 1 and level <= level_enum.MAX_EXPERT):
		new_info["difficulty"] = level_enum.DIFFICULTY.EXPERT;
		new_info["difficulty_name"] = "Helltoad";
		new_info["difficulty_bg"] = "res://assets/bg_4.png";
		new_info["difficulty_progress_bar"] = "res://assets/difficulty/expert.png";
		new_info["difficulty_levels"] = read_JSON.get_dict("res://levels/expert.json");
		new_info["level_layout"] = new_info["difficulty_levels"][str(level)];
		new_info["savegame_path"] = level_enum.EXPERT_SAVEGAME;
		new_info["savegame"] = load_savegame(new_info["savegame_path"]);
	else:
		new_info["difficulty"] = level_enum.DIFFICULTY.CUSTOM;
		new_info["difficulty_name"] = "Custom";
		new_info["difficulty_bg"] = "res://custom/bg.png";
		new_info["difficulty_progress_bar"] = "";
		new_info["difficulty_levels"] = read_JSON.get_dict("user://levels/levels.json");
		if new_info["difficulty_levels"].has(str(level)):
			new_info["level_layout"] = new_info["difficulty_levels"][str(level)];
		else:
			new_info["level_layout"] = [];
		new_info["savegame_path"] = "";
		new_info["savegame"] = {}
	new_info["solved"] = new_info["savegame"].get(str(level), false);
		
	return new_info;
