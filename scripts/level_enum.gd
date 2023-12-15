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
	

