extends Node2D

## Stationary guard. All children (light, cone visual, detection area)
## are created at runtime so the scene node stays minimal.

@export var cone_length:    float = 190.0
@export var cone_angle_deg: float = 65.0
@export var light_color:    Color = Color(0.75, 0.51, 0.99, 1.0)  # neon purple

var _detection_area: Area2D
var _cone_visual:    Polygon2D
var _point_light:    PointLight2D

func _ready() -> void:
	_build_cone_visual()
	_build_detection_area()
	_build_point_light()

# ---------- build ----------------------------------------------------------

func _build_cone_visual() -> void:
	_cone_visual         = Polygon2D.new()
	_cone_visual.polygon = _cone_polygon(cone_length, cone_angle_deg)
	_cone_visual.color   = Color(light_color.r, light_color.g, light_color.b, 0.22)
	add_child(_cone_visual)

func _build_detection_area() -> void:
	_detection_area = Area2D.new()
	var cpoly        := CollisionPolygon2D.new()
	cpoly.polygon    = _cone_polygon(cone_length * 0.97, cone_angle_deg)
	_detection_area.add_child(cpoly)
	add_child(_detection_area)
	_detection_area.body_entered.connect(_on_body_entered)
	_detection_area.body_exited.connect(_on_body_exited)

func _build_point_light() -> void:
	_point_light               = PointLight2D.new()
	_point_light.texture       = _radial_gradient_texture(256)
	_point_light.color         = light_color
	_point_light.texture_scale = (cone_length * 2.6) / 256.0
	_point_light.energy        = 1.4
	add_child(_point_light)

# ---------- helpers --------------------------------------------------------

func _cone_polygon(length: float, angle_deg: float) -> PackedVector2Array:
	var pts  := PackedVector2Array()
	var half := deg_to_rad(angle_deg * 0.5)
	pts.append(Vector2.ZERO)
	for i: int in range(11):
		var a := -half + (half * 2.0 / 10.0) * i
		pts.append(Vector2(cos(a), sin(a)) * length)
	return pts

func _radial_gradient_texture(size: int) -> ImageTexture:
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var cf  := size * 0.5
	for y: int in range(size):
		for x: int in range(size):
			var d := Vector2(x - cf, y - cf).length() / cf
			var a := clampf(1.0 - d * d, 0.0, 1.0)
			img.set_pixel(x, y, Color(1.0, 1.0, 1.0, a))
	return ImageTexture.create_from_image(img)

# ---------- detection ------------------------------------------------------

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.enter_light_zone()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.exit_light_zone()
