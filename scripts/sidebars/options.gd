extends Control
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : Config = $/root/ConfigSystem;

signal audio_bg_change;

func _ready() -> void:
	%SFXHSlider.value = config.load_value("audio", "sfx") if config.load_value("audio", "sfx") != null else 100.0;
	%SFXProgressBar.value = %SFXHSlider.value;
	%SoundtrackHSlider.value = config.load_value("audio", "bg") if config.load_value("audio", "bg") != null else 100.0;
	%SoundtrackProgressBar.value = %SoundtrackHSlider.value;

func _on_soundtrack_h_slider_value_changed(value: float) -> void:
	%SoundtrackProgressBar.value = %SoundtrackHSlider.value;	

func _on_soundtrack_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		%SoundtrackProgressBar.value = %SoundtrackHSlider.value;	
		config.save_value("audio", "bg", %SoundtrackHSlider.value);
	audio_bg_change.emit();
	
func _on_sfxh_slider_value_changed(value: float) -> void:
	%SFXProgressBar.value = %SFXHSlider.value;	

func _on_sfxh_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		%SFXProgressBar.value = %SFXHSlider.value;	
		config.save_value("audio", "sfx", %SFXHSlider.value);
			
func _on_reset_button_pressed() -> void:
	if (DirAccess.dir_exists_absolute("user://savegames")):
		var dir : DirAccess = DirAccess.open("user://savegames");
		for file : String in dir.get_files():
			dir.remove(file);
	get_tree().reload_current_scene();
	%ResetButton.disabled = true;
	%ResetLabel.text = "Successfully reset game!";
