extends Node2D

## Attached to the Main scene root.
## Connects all game objects, registers data count, manages HUD.

@onready var _player:       CharacterBody2D = $Player
@onready var _exit_portal:  Area2D          = $ExitPortal
@onready var _hud_deaths:   Label           = $HUD/DeathCount
@onready var _hud_data:     Label           = $HUD/DataCount
@onready var _hud_message:  Label           = $HUD/Message

func _ready() -> void:
	var data_nodes := get_tree().get_nodes_in_group("data_nodes")
	GameManager.register_total_data(data_nodes.size())

	GameManager.data_updated.connect(_on_data_updated)
	GameManager.level_complete.connect(_on_level_complete)
	_player.died.connect(_on_player_died)

	for node: Node in data_nodes:
		node.collected.connect(_check_data_complete)

	_refresh_hud()

func _check_data_complete() -> void:
	if GameManager.data_collected >= GameManager.total_data:
		_exit_portal.activate()
		_show_message("ALL DATA COLLECTED — REACH THE EXIT", 2.5)

func _on_data_updated(collected: int, total: int) -> void:
	_hud_data.text = "DATA: %d / %d" % [collected, total]

func _on_player_died() -> void:
	_hud_deaths.text = "DEATHS: %d" % GameManager.deaths

func _on_level_complete(deaths: int, data: int) -> void:
	_show_message("ESCAPED\nDeaths: %d    Data: %d/%d" % [deaths, data, GameManager.total_data], 6.0)

func _refresh_hud() -> void:
	_hud_deaths.text = "DEATHS: 0"
	_hud_data.text   = "DATA: 0 / %d" % GameManager.total_data

func _show_message(text: String, duration: float) -> void:
	_hud_message.text      = text
	_hud_message.modulate.a = 1.0
	var t := create_tween()
	t.tween_interval(maxf(0.0, duration - 0.6))
	t.tween_property(_hud_message, "modulate:a", 0.0, 0.6)
