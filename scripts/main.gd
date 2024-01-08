extends Node2D
@onready var level : PackedScene = load("res://scenes/level.tscn");
@onready var tutorial_level : PackedScene = load("res://scenes/tutorial_level.tscn");
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : ConfigSystem = $/root/ConfigSystem;
@onready var l : Node2D;
@onready var t : Control;

func _ready() -> void:
	if (!config.load_value('tutorial', 'level', true)):
		l = level.instantiate();
		add_child(l);
		l.connect("refresh", _on_level_refresh);
		l.connect("mute", _on_mute);
		$AudioStreamPlayer.volume_db = audio_system.get_db(config.load_value("audio", "bg", 100.0));
	else:
		t = tutorial_level.instantiate();
		add_child(t);
		
func _on_mute(quiet: bool) -> void:
	$AudioStreamPlayer.stream_paused = quiet;
	
func _on_level_refresh() -> void:
	l.queue_free();
	l = level.instantiate();
	add_child(l);
	l.connect("refresh", _on_level_refresh);
	l.connect("mute", _on_mute);
