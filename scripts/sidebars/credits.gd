extends Control

func _ready() -> void:
	%VersionLabel.text = "Version: %s" % ProjectSettings.get_setting("application/config/version");
