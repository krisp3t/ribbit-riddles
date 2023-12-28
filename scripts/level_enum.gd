class_name level_enum;
enum DIFFICULTY {EASY, INTERMEDIATE, HARD, EXPERT, CUSTOM};

const MAX_EASY : int = 10;
const MAX_INTERMEDIATE : int = 20;
const MAX_HARD : int = 30;
const MAX_EXPERT : int = 40;

static func load_savegame(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {};
	return read_JSON.get_dict(path);
		
static func get_level_info(level: int) -> Dictionary:
	var info : Dictionary = {};
	if (level >= 1 and level <= MAX_EASY):
		info["difficulty"] = DIFFICULTY.EASY;
		info["difficulty_name"] = "Frogspawn";
		info["difficulty_bg"] = "res://assets/bg_1.png";
		info["difficulty_progress_bar"] = "res://assets/difficulty/easy.png";
		info["level_layout"] = read_JSON.get_dict("res://levels/easy.json")[str(level)];
		info["savegame_path"] = "user://easy.save";
		info["savegame"] = load_savegame(info["savegame_path"]);
	elif (level >= MAX_EASY + 1 and level <= MAX_INTERMEDIATE):
		info["difficulty"] = DIFFICULTY.INTERMEDIATE;
		info["difficulty_name"] = "Tadpole";
		info["difficulty_bg"] = "res://assets/bg_2.png";
		info["difficulty_progress_bar"] = "res://assets/difficulty/intermediate.png";
		info["level_layout"] = read_JSON.get_dict("res://levels/intermediate.json")[str(level)];
		info["savegame_path"] = "user://intermediate.save";
		info["savegame"] = load_savegame(info["savegame_path"]);
	elif (level >= MAX_INTERMEDIATE + 1 and level <= MAX_HARD):
		info["difficulty"] = DIFFICULTY.HARD;
		info["difficulty_name"] = "Froggy";
		info["difficulty_bg"] = "res://assets/bg_3.png";
		info["difficulty_progress_bar"] = "res://assets/difficulty/hard.png";
		info["level_layout"] = read_JSON.get_dict("res://levels/hard.json")[str(level)];
		info["savegame_path"] = "user://hard.save";
		info["savegame"] = load_savegame(info["savegame_path"]);
	elif (level >= MAX_HARD + 1 and level <= MAX_EXPERT):
		info["difficulty"] = DIFFICULTY.EXPERT;
		info["difficulty_name"] = "Helltoad";
		info["difficulty_bg"] = "res://assets/bg_4.png";
		info["difficulty_progress_bar"] = "res://assets/difficulty/expert.png";
		info["level_layout"] = read_JSON.get_dict("res://levels/expert.json")[str(level)];
		info["savegame_path"] = "user://expert.save";
		info["savegame"] = load_savegame(info["savegame_path"]);
	else:
		info["difficulty"] = DIFFICULTY.CUSTOM;
		info["difficulty_name"] = "Custom";
		info["difficulty_bg"] = "res://assets/bg.png";
		info["difficulty_progress_bar"] = "";
		info["level_layout"] = {};
		info["savegame"] = {};
		
	print_debug("level_enum", info["savegame"]);
	return info;

