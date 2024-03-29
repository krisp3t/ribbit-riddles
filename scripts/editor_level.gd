extends Node2D;
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : ConfigSystem = $/root/ConfigSystem;

const CURSOR_OFFSET : Vector2 = Vector2(-60, -55);
const GREEN_INITIAL : Vector2 = Vector2(16, 40);
const RED_INITIAL : Vector2 = Vector2(128, 40);
const ERASER_INITIAL : Vector2 = Vector2(256, 56);
const DROP_SHORTEST_DIST : int = 75;

var rng : RandomNumberGenerator = RandomNumberGenerator.new();
var is_muted : bool = false;
var selected : Control = null;
@onready var saved : bool = level_vars["info"]["difficulty_levels"].has(level_vars.current_level)

signal refresh;
signal mute;

func _initialize() -> void:
	# Set up labels and textures
	%LevelLabel.text = "Level: %d" % level_vars.current_level;
	# Set up muted / unmuted audio players
	is_muted = !level_vars.muted;
	_on_mute_button_pressed();
	$JumpPlayer.volume_db = audio_system.get_db(config.load_value("audio", "sfx", 100.0));
	$WinPlayer.volume_db = $JumpPlayer.volume_db;
	# Min level boundary
	if level_vars.current_level == level_enum.MAX_EXPERT + 1:
		%PreviousLevelButton.disabled = true;
	%SaveButton.text = "Save as Level %s" % level_vars.current_level;
	_check_valid_edit();
	# Don't allow gaps (e.g. level 43 and 44 don't exist, want to edit 45)
	if level_vars.current_level >= level_enum.MAX_EXPERT + level_vars["info"]["difficulty_levels"].size() + 1:
		%NextLevelButton.disabled = !saved;
	

func _ready() -> void:
	_initialize();

func _on_previous_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level - 1);
	refresh.emit();
	
func _on_next_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level + 1);
	refresh.emit();
	
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn");

func _on_mute_button_pressed() -> void:
	var texture_path : String;
	is_muted = !is_muted;
	if is_muted:
		texture_path = "res://assets/buttons/4x/Asset 11@4x.png";
	else:
		texture_path = "res://assets/buttons/4x/Asset 12@4x.png";
	%MuteButton["theme_override_styles/normal"].texture = load(texture_path);
	%MuteButton["theme_override_styles/hover"].texture = load(texture_path);
	%MuteButton["theme_override_styles/pressed"].texture = load(texture_path);
	%MuteButton["theme_override_styles/focus"].texture = load(texture_path);
	for player in get_tree().get_nodes_in_group("AudioStreamPlayers"):
		if (is_muted):
			player.set_volume_db(-999.0);
		else:
			player.set_volume_db(audio_system.get_db(config.load_value("audio", "sfx", 100.0)));
	mute.emit(is_muted);
	level_vars.muted = is_muted;		

func _on_playfield_jump() -> void:
	$JumpPlayer.pitch_scale = rng.randf_range(0.7, 1.3);
	$JumpPlayer.play();

func _on_clear_button_pressed() -> void:
	$Playfield.clear_playfield();
	_check_valid_edit();
	
func _on_green_frog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %GreenFrog):
			selected = %GreenFrog;
			selected.modulate = Color(1, 1, 1, 0.5);
			return;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;


func _on_red_frog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %RedFrog):
			selected = %RedFrog;
			selected.modulate = Color(1, 1, 1, 0.5);
			return;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;

func _on_eraser_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %Eraser):
			selected = %Eraser;
			selected.modulate = Color(1, 1, 1, 0.5);
			return;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;
			
func _check_valid_edit() -> void:
	var number_green : int = 0;
	var number_red : int = 0;
	var number_empty : int = 0;
	for y : Array in level_vars["info"]["level_layout"]:
		for val : lilypad_enum.STATUS in y:
			match val:
				lilypad_enum.STATUS.RED:
					number_red += 1;
				lilypad_enum.STATUS.EMPTY:
					number_empty += 1;
				lilypad_enum.STATUS.GREEN:
					number_green += 1;
	var red_valid : bool = number_red == 1;
	var empty_valid : bool = number_empty >= 1;
	var green_valid : bool = number_green >= 1;
	%SaveButton.disabled = !(red_valid and empty_valid and green_valid);
	%SaveTestButton.disabled = !(red_valid and empty_valid and green_valid);
	
func _on_item_drop(item: Control) -> void:
	for lilypad : Lilypad in get_tree().get_nodes_in_group("lilypads"):
		var item_pos : Vector2 = item.global_position - CURSOR_OFFSET;
		var distance : float = item_pos.distance_to(lilypad.global_position);
		if distance >= DROP_SHORTEST_DIST:
			continue;
		
		var coords : Vector2i = lilypad.coord;
		var ix : Vector2i = level_vars.get_lilypad_array_ix(lilypad.coord);
		var status : lilypad_enum.STATUS = lilypad_enum.node_to_status(item.name);
		
		if lilypad.attached_frog != null:
			lilypad.attached_frog.queue_free();
		
		level_vars.update_level_layout(coords, status);
		$Playfield.initialize_lilypad(ix, lilypad);
		_check_valid_edit();

func _process(delta: float) -> void:
	for c: Control in get_tree().get_nodes_in_group("EditorFrogs"):
		if c == selected:
			c.global_position = lerp(c.global_position, get_global_mouse_position() + CURSOR_OFFSET, 25 * delta);
		else:
			match c.name:
				"GreenFrog":
					c.position = GREEN_INITIAL;
				"RedFrog":
					c.position = RED_INITIAL;
				"Eraser":
					c.position = ERASER_INITIAL;

func _on_save_button_pressed() -> void:
	level_vars.save_created_level();
	%InfoLabel.text = "Level successfully saved!";
	%InfoTimer.start();
	%NextLevelButton.disabled = false;

func _on_info_timer_timeout() -> void:
	%InfoLabel.text = "";

func _on_save_test_button_pressed() -> void:
	_on_save_button_pressed();
	get_tree().change_scene_to_file("res://scenes/main.tscn");
