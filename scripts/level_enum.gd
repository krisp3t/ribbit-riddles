class_name level_enum;
enum DIFFICULTY {EASY, INTERMEDIATE, HARD, EXPERT, CUSTOM};

const MAX_EASY : int = 10;
const MAX_INTERMEDIATE : int = 20;
const MAX_HARD : int = 30;
const MAX_EXPERT : int = 40;

const EASY_SAVEGAME = "user://savegames/easy.save";
const INTERMEDIATE_SAVEGAME = "user://savegames/intermediate.save";
const HARD_SAVEGAME = "user://savegames/hard.save";
const EXPERT_SAVEGAME = "user://savegames/expert.save";

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
		info["difficulty_levels"] = read_JSON.get_dict("res://levels/easy.json");
		info["level_layout"] = info["difficulty_levels"][str(level)];
		info["savegame_path"] = EASY_SAVEGAME;
		info["savegame"] = load_savegame(info["savegame_path"]);
	elif (level >= MAX_EASY + 1 and level <= MAX_INTERMEDIATE):
		info["difficulty"] = DIFFICULTY.INTERMEDIATE;
		info["difficulty_name"] = "Tadpole";
		info["difficulty_bg"] = "res://assets/bg_2.png";
		info["difficulty_progress_bar"] = "res://assets/difficulty/intermediate.png";
		info["difficulty_levels"] = read_JSON.get_dict("res://levels/intermediate.json");
		info["level_layout"] = info["difficulty_levels"][str(level)];
		info["savegame_path"] = INTERMEDIATE_SAVEGAME;
		info["savegame"] = load_savegame(info["savegame_path"]);
	elif (level >= MAX_INTERMEDIATE + 1 and level <= MAX_HARD):
		info["difficulty"] = DIFFICULTY.HARD;
		info["difficulty_name"] = "Froggy";
		info["difficulty_bg"] = "res://assets/bg_3.png";
		info["difficulty_progress_bar"] = "res://assets/difficulty/hard.png";
		info["difficulty_levels"] = read_JSON.get_dict("res://levels/hard.json");
		info["level_layout"] = info["difficulty_levels"][str(level)];
		info["savegame_path"] = HARD_SAVEGAME;
		info["savegame"] = load_savegame(info["savegame_path"]);
	elif (level >= MAX_HARD + 1 and level <= MAX_EXPERT):
		info["difficulty"] = DIFFICULTY.EXPERT;
		info["difficulty_name"] = "Helltoad";
		info["difficulty_bg"] = "res://assets/bg_4.png";
		info["difficulty_progress_bar"] = "res://assets/difficulty/expert.png";
		info["difficulty_levels"] = read_JSON.get_dict("res://levels/expert.json");
		info["level_layout"] = info["difficulty_levels"][str(level)];
		info["savegame_path"] = EXPERT_SAVEGAME;
		info["savegame"] = load_savegame(info["savegame_path"]);
	else:
		info["difficulty"] = DIFFICULTY.CUSTOM;
		info["difficulty_name"] = "Custom";
		info["difficulty_bg"] = "res://custom/bg.png";
		info["difficulty_progress_bar"] = "";
		info["difficulty_levels"] = read_JSON.get_dict("user://levels/levels.json");
		if info["difficulty_levels"].has(str(level)):
			info["level_layout"] = info["difficulty_levels"][str(level)];
		else:
			info["level_layout"] = [];
		info["savegame"] = {};
	info["solved"] = info["savegame"].get(str(level), false);
		
	return info;

