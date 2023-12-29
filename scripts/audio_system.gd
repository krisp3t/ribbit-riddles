extends Node
class_name audio_system

static func get_db(percent: float) -> float:
	if percent > 0:
		return -30.0 + (0.3 * percent);
	return -999.9;
