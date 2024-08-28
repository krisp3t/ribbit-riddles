extends Node2D;

class_name level_const;
enum DIFFICULTY {EASY, INTERMEDIATE, HARD, EXPERT, CUSTOM};

const CUSTOM_LEVELS_PATH: String = "user://levels/levels.json";
const SAVEGAME_PATH: String = "user://savegames/";
const LEVELS_PATH: String = "res://levels/";

const INFO: Dictionary = {
	DIFFICULTY.EASY: {
		"difficulty": DIFFICULTY.EASY,
		"folder_name": "easy",
		"name": "Frogspawn",
	},
	DIFFICULTY.INTERMEDIATE: {
		"difficulty": DIFFICULTY.INTERMEDIATE,
		"folder_name": "intermediate",
		"name": "Tadpole",
	},
	DIFFICULTY.HARD: {
		"difficulty": DIFFICULTY.HARD,
		"folder_name": "hard",
		"name": "Froglet",
	},
	DIFFICULTY.EXPERT: {
		"difficulty": DIFFICULTY.EXPERT,
		"folder_name": "expert",
		"name": "Helltoad",
	},
	DIFFICULTY.CUSTOM: {
		"difficulty": DIFFICULTY.CUSTOM,
		"folder_name": "custom",
		"name": "Custom",
	},
}

static func get_default_info(difficulty: DIFFICULTY) -> Dictionary:
	return INFO[difficulty].duplicate(true);
