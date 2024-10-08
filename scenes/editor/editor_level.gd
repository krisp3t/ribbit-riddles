extends Node2D;
@onready var level_vars: LevelSystem = $ / root / LevelSystem;
@onready var config: ConfigSystem = $ / root / ConfigSystem;

const CURSOR_OFFSET: Vector2 = Vector2(-60, -55);
const GREEN_INITIAL: Vector2 = Vector2(16, 40);
const RED_INITIAL: Vector2 = Vector2(128, 40);
const ERASER_INITIAL: Vector2 = Vector2(256, 56);
const DROP_SHORTEST_DIST: int = 75;

var rng: RandomNumberGenerator = RandomNumberGenerator.new();
var selected: Control = null;
@onready var saved: bool = level_vars["level_info"]["all_levels"].has(level_vars.level_num)

func _initialize() -> void:
	var info: Dictionary = level_vars["level_info"];
	Logger.info("Loading level %d" % level_vars.level_num);
	%LevelLabel.text = "Level: %d" % level_vars.level_num;
	%JumpPlayer.volume_db = audio_system.get_db(config.load_value("audio", "sfx", 100.0));
	%WinPlayer.volume_db = %JumpPlayer.volume_db;
	# Min level boundary
	if level_vars.level_num == level_vars.MAX_EXPERT + 1:
		%PreviousLevelButton.disabled = true;
	%SaveButton.text = "Save as Level %s" % level_vars.level_num;
	_check_valid_edit();
	# Don't allow gaps (e.g. level 43 and 44 don't exist, want to edit 45)
	if level_vars.level_num >= level_vars.MAX_EXPERT + level_vars["level_info"]["all_levels"].size() + 1:
		%NextLevelButton.disabled = !saved;
	

func _ready() -> void:
	_initialize();

func _change_level(level: int) -> void:
	level_vars.initialize(level);
	get_tree().reload_current_scene();

func _on_previous_level_button_pressed() -> void:
	_change_level(level_vars.level_num - 1);

func _on_next_level_button_pressed() -> void:
	_change_level(level_vars.level_num + 1);
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn");

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
			return ;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;


func _on_red_frog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %RedFrog):
			selected = %RedFrog;
			selected.modulate = Color(1, 1, 1, 0.5);
			return ;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;

func _on_eraser_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %Eraser):
			selected = %Eraser;
			selected.modulate = Color(1, 1, 1, 0.5);
			return ;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;
			
func _check_valid_edit() -> void:
	var number_green: int = 0;
	var number_red: int = 0;
	var number_empty: int = 0;
	for y: Array in level_vars["level_info"]["layout"]:
		for val: lilypad_enum.STATUS in y:
			match val:
				lilypad_enum.STATUS.RED:
					number_red += 1;
				lilypad_enum.STATUS.EMPTY:
					number_empty += 1;
				lilypad_enum.STATUS.GREEN:
					number_green += 1;
	var red_valid: bool = number_red == 1;
	var empty_valid: bool = number_empty >= 1;
	var green_valid: bool = number_green >= 1;
	%SaveButton.disabled = !(red_valid and empty_valid and green_valid);
	%SaveTestButton.disabled = !(red_valid and empty_valid and green_valid);
	
func _on_item_drop(item: Control) -> void:
	for lilypad: Lilypad in get_tree().get_nodes_in_group("lilypads"):
		var item_pos: Vector2 = item.global_position - CURSOR_OFFSET;
		var distance: float = item_pos.distance_to(lilypad.global_position);
		if distance >= DROP_SHORTEST_DIST:
			continue ;
		
		var coords: Vector2i = lilypad.coord;
		var ix: Vector2i = level_vars.get_lilypad_array_ix(lilypad.coord);
		var status: lilypad_enum.STATUS = lilypad_enum.node_to_status(item.name);
		
		if lilypad.attached_frog != null:
			lilypad.attached_frog.queue_free();
		
		level_vars.update_layout(coords, status);
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
