extends Area2D

## Collectible data fragment. Pulses neon cyan.
## Emits collected signal + notifies GameManager on pickup.

signal collected

@export var pulse_speed: float = 2.2

var _visual: ColorRect

func _ready() -> void:
	add_to_group("data_nodes")
	_build_node()
	body_entered.connect(_on_body_entered)

func _build_node() -> void:
	_visual          = ColorRect.new()
	_visual.size     = Vector2(20, 20)
	_visual.position = Vector2(-10, -10)
	_visual.color    = Color(0.13, 0.83, 0.93, 1.0)
	add_child(_visual)

func _process(_delta: float) -> void:
	var pulse := (sin(Time.get_ticks_msec() * 0.001 * pulse_speed) + 1.0) * 0.5
	_visual.color = Color(0.08 + pulse * 0.25, 0.65 + pulse * 0.35, 0.93, 1.0)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	collected.emit()
	GameManager.collect_data()
	monitoring = false
	set_process(false)

	var t := create_tween()
	t.tween_property(self, "scale",      Vector2(2.8, 2.8), 0.18)
	t.parallel().tween_property(self, "modulate:a", 0.0,         0.18)
	await t.finished
	queue_free()
