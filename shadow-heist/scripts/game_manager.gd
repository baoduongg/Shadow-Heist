extends Node

## Autoload singleton — tracks deaths, data, level state.
## Also bootstraps InputMap at startup so actions work without project settings.

signal data_updated(collected: int, total: int)
signal level_complete(deaths: int, data_collected: int)

var deaths: int = 0
var data_collected: int = 0
var total_data: int = 0

func _ready() -> void:
	_setup_input_map()

# ---------- input ----------------------------------------------------------

func _setup_input_map() -> void:
	if InputMap.has_action("move_up"):
		return
	var bindings: Dictionary = {
		"move_up":    [KEY_W, KEY_UP],
		"move_down":  [KEY_S, KEY_DOWN],
		"move_left":  [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"dash":       [KEY_SPACE, KEY_SHIFT],
	}
	for action: String in bindings:
		InputMap.add_action(action)
		for key: Key in bindings[action]:
			var ev := InputEventKey.new()
			ev.physical_keycode = key
			InputMap.action_add_event(action, ev)

# ---------- game state -----------------------------------------------------

func register_total_data(count: int) -> void:
	total_data = count
	data_collected = 0
	data_updated.emit(0, total_data)

func collect_data() -> void:
	data_collected += 1
	data_updated.emit(data_collected, total_data)

func on_player_died() -> void:
	deaths += 1

func on_level_complete() -> void:
	level_complete.emit(deaths, data_collected)

func reset_run() -> void:
	deaths = 0
	data_collected = 0
