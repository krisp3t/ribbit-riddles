class_name level_enum;
enum DIFFICULTY {EASY, INTERMEDIATE, HARD, EXPERT, CUSTOM};
@export var difficulty: DIFFICULTY;

static func get_level_difficulty(level: int) -> DIFFICULTY:
	if (level >= 1 and level <= 10):
		return DIFFICULTY.EASY;
	elif (level >= 11 and level <= 20):
		return DIFFICULTY.INTERMEDIATE;
	elif (level >= 21 and level <= 30):
		return DIFFICULTY.HARD;
	elif (level >= 31 and level <= 40):
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

