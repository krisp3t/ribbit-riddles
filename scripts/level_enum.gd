class_name level_enum;
enum DIFFICULTY {EASY, INTERMEDIATE, HARD, EXPERT, CUSTOM};

const MAX_EASY : int = 10;
const MAX_INTERMEDIATE : int = 20;
const MAX_HARD : int = 30;
const MAX_EXPERT : int = 40;
 
static func get_level_difficulty(level: int) -> DIFFICULTY:
	if (level >= 1 and level <= MAX_EASY):
		return DIFFICULTY.EASY;
	elif (level >= MAX_EASY + 1 and level <= MAX_INTERMEDIATE):
		return DIFFICULTY.INTERMEDIATE;
	elif (level >= MAX_INTERMEDIATE + 1 and level <= MAX_HARD):
		return DIFFICULTY.HARD;
	elif (level >= MAX_HARD + 1 and level <= MAX_EXPERT):
		return DIFFICULTY.EXPERT;
	else:
		return DIFFICULTY.CUSTOM;
	
static func get_difficulty_name(level: DIFFICULTY) -> String:
	match level:
		DIFFICULTY.EASY:
			return "Frogspawn";
		DIFFICULTY.INTERMEDIATE:
			return "Tadpole";
		DIFFICULTY.HARD:
			return "Froggy";
		DIFFICULTY.EXPERT:
			return "Helltoad";
		_:
			return "Custom";

static func get_difficulty_background(level: DIFFICULTY) -> String:
	match level:
		DIFFICULTY.EASY:
			return "res://assets/bg_1.png";
		DIFFICULTY.INTERMEDIATE:
			return "res://assets/bg_2.png";
		DIFFICULTY.HARD:
			return "res://assets/bg_3.png";
		DIFFICULTY.EXPERT:
			return "res://assets/bg_4.png";
		_:
			return "res://custom/bg.png";
			
static func get_difficulty_progress_bar(level: DIFFICULTY) -> String:
	match level:
		DIFFICULTY.EASY:
			return "res://assets/difficulty/easy.png";
		DIFFICULTY.INTERMEDIATE:
			return "res://assets/difficulty/intermediate.png";
		DIFFICULTY.HARD:
			return "res://assets/difficulty/hard.png";
		DIFFICULTY.EXPERT:
			return "res://assets/difficulty/expert.png";
		_:
			return "";

static func get_level_layout_dict(level: DIFFICULTY) -> Dictionary:
	var json_file_path : String;
	match level:
		DIFFICULTY.EASY:
			json_file_path = "res://levels/easy.json";
		DIFFICULTY.INTERMEDIATE:
			json_file_path = "res://levels/intermediate.json";
		DIFFICULTY.HARD:
			json_file_path = "res://levels/hard.json";
		DIFFICULTY.EXPERT:
			json_file_path = "res://levels/expert.json";
		_:
			json_file_path = "res://custom/levels.json";
	return read_JSON.get_dict(json_file_path);

