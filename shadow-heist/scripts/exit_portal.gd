extends Area2D

## Level exit. Inactive until all data nodes are collected.
## Glows neon cyan when active.

var _active:  bool      = false
var _visual:  ColorRect
var _label:   Label

func _ready() -> void:
	_build_node()
	monitoring  = false
	modulate.a  = 0.3
	body_entered.connect(_on_body_entered)

func _build_node() -> void:
	_visual          = ColorRect.new()
	_visual.size     = Vector2(44, 44)
	_visual.position = Vector2(-22, -22)
	_visual.color    = Color(0.13, 0.83, 0.93, 1.0)
	add_child(_visual)

	_label                  = Label.new()
	_label.text             = "EXIT"
	_label.position         = Vector2(-18, -38)
	_label.add_theme_font_size_override("font_size", 11)
	_label.modulate         = Color(0.13, 0.83, 0.93, 0.6)
	add_child(_label)

func _process(_delta: float) -> void:
	if not _active:
		return
	var pulse      := (sin(Time.get_ticks_msec() * 0.0022) + 1.0) * 0.5
	_visual.color   = Color(0.08, 0.55 + pulse * 0.45, 0.93, 1.0)

func activate() -> void:
	_active    = true
	monitoring = true
	modulate.a = 1.0

	var t := create_tween().set_loops(5)
	t.tween_property(self, "scale", Vector2(1.35, 1.35), 0.14)
	t.tween_property(self, "scale", Vector2(1.0, 1.0),   0.14)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and _active:
		GameManager.on_level_complete()
