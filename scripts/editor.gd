extends Node2D
@onready var level : PackedScene = load("res://scenes/editor_level.tscn");
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : ConfigSystem = $/root/ConfigSystem;
@onready var l : Node2D;

func _ready() -> void:
	l = level.instantiate();
	add_child(l);
	l.connect("refresh", _on_level_refresh);
	l.connect("mute", _on_mute);
	$AudioStreamPlayer.volume_db = audio_system.get_db(config.load_value("audio", "bg"))
		
func _on_mute(quiet: bool) -> void:
	$AudioStreamPlayer.stream_paused = quiet;
	
func _on_level_refresh() -> void:
	l.queue_free();
	l = level.instantiate();
	add_child(l);
	l.connect("refresh", _on_level_refresh);
	l.connect("mute", _on_mute);
