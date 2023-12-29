extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%VersionLabel.text = "Version: %s" % ProjectSettings.get_setting("application/config/version");
