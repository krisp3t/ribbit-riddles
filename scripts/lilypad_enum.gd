class_name lilypad_enum;
enum STATUS {EMPTY, GREEN, RED};

static func node_to_status(name: String) -> lilypad_enum.STATUS:
	match name:
		"GreenFrog":
			return lilypad_enum.STATUS.GREEN;
		"RedFrog":
			return lilypad_enum.STATUS.RED;
		"Eraser":
			return lilypad_enum.STATUS.EMPTY;
		_:
			return lilypad_enum.STATUS.EMPTY;
			
