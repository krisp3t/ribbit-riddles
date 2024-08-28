extends Node2D;

class_name level_const;
enum DIFFICULTY {EASY, INTERMEDIATE, HARD, EXPERT, CUSTOM};

const CUSTOM_LEVELS_PATH: String = "user://levels/levels.json";
const SAVEGAME_PATH: String = "user://savegames/";
const LEVELS_PATH: String = "res://levels/";

const INFO: Dictionary = {
	DIFFICULTY.EASY: {
		"difficulty": DIFFICULTY.EASY,
		"name": "Frogspawn",
		"path": LEVELS_PATH + "easy/",
		"path_layout": LEVELS_PATH + "easy/layout.json",
		"path_savegame": SAVEGAME_PATH + "easy.json",
	},
	DIFFICULTY.INTERMEDIATE: {
		"difficulty": DIFFICULTY.INTERMEDIATE,
		"name": "Tadpole",
		"path": LEVELS_PATH + "intermediate/",
		"path_layout": LEVELS_PATH + "intermediate/layout.json",
		"path_savegame": SAVEGAME_PATH + "intermediate.json",
	},
	DIFFICULTY.HARD: {
		"difficulty": DIFFICULTY.HARD,
		"name": "Froglet",
		"path": LEVELS_PATH + "hard/",
		"path_layout": LEVELS_PATH + "hard/layout.json",
		"path_savegame": SAVEGAME_PATH + "hard.json",
	},
	DIFFICULTY.EXPERT: {
		"difficulty": DIFFICULTY.EXPERT,
		"name": "Helltoad",
		"path": LEVELS_PATH + "expert/",
		"path_layout": LEVELS_PATH + "expert/layout.json",
		"path_savegame": SAVEGAME_PATH + "expert.json",
	},
	DIFFICULTY.CUSTOM: {
		"difficulty": DIFFICULTY.CUSTOM,
		"name": "Custom",
		"path": LEVELS_PATH + "custom/",
		"path_layout": CUSTOM_LEVELS_PATH,
		"path_savegame": SAVEGAME_PATH + "custom.json",
	},
}

static func get_default_info(difficulty: DIFFICULTY) -> Dictionary:
	return INFO[difficulty].duplicate(true);
