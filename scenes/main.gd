extends Node2D;
@onready var config: Config = $ / root / ConfigSystem;
@onready var level: PackedScene = load("res://scenes/level.tscn");
var l: Node2D = null;

func _ready() -> void:
	%SoundtrackPlayer.volume_db = audio_system.get_db(config.load_value("audio", "bg", 100.0));
	l = level.instantiate();
	add_child(l);
	l.connect("refresh", _on_refresh);

func _on_refresh() -> void:
	l.queue_free();
	_ready();
