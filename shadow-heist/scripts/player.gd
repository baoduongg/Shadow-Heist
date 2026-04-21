extends CharacterBody2D

signal died
signal respawned
signal dash_started(direction: Vector2)

const MOVE_SPEED:    float = 210.0
const DASH_SPEED:    float = 600.0
const DASH_DURATION: float = 0.15
const DASH_COOLDOWN: float = 0.38
const RESPAWN_DELAY: float = 0.35

enum PlayerState { NORMAL, DASHING, DEAD }
enum Dir         { DOWN, UP, LEFT, RIGHT }

var _state:          PlayerState = PlayerState.NORMAL
var _dash_dir:       Vector2     = Vector2.DOWN
var _facing:         Dir         = Dir.DOWN
var _dash_timer:     float       = 0.0
var _cooldown_timer: float       = 0.0
var _spawn_pos:      Vector2     = Vector2.ZERO
var _light_zones:    int         = 0
var _sprite:         AnimatedSprite2D

const _DIR_NAME: Array[String] = ["down", "up", "left", "right"]

func _ready() -> void:
	_spawn_pos = global_position
	add_to_group("player")
	_build_node()

func _build_node() -> void:
	_sprite               = AnimatedSprite2D.new()
	_sprite.sprite_frames = _build_sprite_frames()
	_sprite.position      = Vector2.ZERO
	add_child(_sprite)
	_sprite.play("idle_down")

# ---------- sprite frames --------------------------------------------------

func _build_sprite_frames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	frames.remove_animation(&"default")

	# [name, path, frame_count, fps, loops]
	var defs: Array = [
		["idle_down",   "res://assets/sprites/player/idle/idle_down_40x40.png",   4, 8,  true],
		["idle_up",     "res://assets/sprites/player/idle/idle_up_40x40.png",     4, 8,  true],
		["idle_left",   "res://assets/sprites/player/idle/idle_left_40x40.png",   4, 8,  true],
		["idle_right",  "res://assets/sprites/player/idle/idle_right_40x40.png",  4, 8,  true],
		["run_down",    "res://assets/sprites/player/run/run_down_40x40.png",     6, 12, true],
		["run_up",      "res://assets/sprites/player/run/run_up_40x40.png",       6, 12, true],
		["run_left",    "res://assets/sprites/player/run/run_left_40x40.png",     6, 12, true],
		["run_right",   "res://assets/sprites/player/run/run_right_40x40.png",    6, 12, true],
		["death_down",  "res://assets/sprites/player/death/death_down_40x40.png", 9, 14, false],
		["death_up",    "res://assets/sprites/player/death/death_up_40x40.png",   9, 14, false],
		["death_left",  "res://assets/sprites/player/death/death_left_40x40.png", 9, 14, false],
		["death_right", "res://assets/sprites/player/death/death_right_40x40.png",9, 14, false],
	]

	for def in defs:
		var anim:   String  = def[0]
		var path:   String  = def[1]
		var count:  int     = def[2]
		var fps:    float   = def[3]
		var loops:  bool    = def[4]

		frames.add_animation(anim)
		frames.set_animation_speed(anim, fps)
		frames.set_animation_loop(anim, loops)

		var sheet := load(path) as Texture2D
		if sheet == null:
			push_warning("Player sprite not found: %s" % path)
			continue
		for i: int in range(count):
			var atlas  := AtlasTexture.new()
			atlas.atlas = sheet
			atlas.region = Rect2(i * 40, 0, 40, 40)
			frames.add_frame(anim, atlas)

	return frames

# ---------- physics loop ---------------------------------------------------

func _physics_process(delta: float) -> void:
	if _state == PlayerState.DEAD:
		return
	_tick_timers(delta)
	match _state:
		PlayerState.NORMAL:  _process_normal()
		PlayerState.DASHING: _process_dash()

func _tick_timers(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta
	if _dash_timer > 0.0:
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_finish_dash()

func _process_normal() -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * MOVE_SPEED

	if dir != Vector2.ZERO:
		_update_facing(dir)
		_dash_dir = dir
		_play_anim("run")
	else:
		_play_anim("idle")

	if Input.is_action_just_pressed("dash") and _cooldown_timer <= 0.0:
		_start_dash(_dash_dir.normalized())

	move_and_slide()

func _start_dash(direction: Vector2) -> void:
	_state          = PlayerState.DASHING
	_dash_dir       = direction
	_dash_timer     = DASH_DURATION
	_cooldown_timer = DASH_COOLDOWN
	velocity        = _dash_dir * DASH_SPEED
	dash_started.emit(_dash_dir)
	_fx_dash_squish()
	_play_anim("run")

func _process_dash() -> void:
	move_and_slide()

func _finish_dash() -> void:
	_state   = PlayerState.NORMAL
	velocity = _dash_dir * MOVE_SPEED * 0.55

# ---------- direction & animation ------------------------------------------

func _update_facing(dir: Vector2) -> void:
	if   dir.x >  0.3: _facing = Dir.RIGHT
	elif dir.x < -0.3: _facing = Dir.LEFT
	elif dir.y < -0.3: _facing = Dir.UP
	else:              _facing = Dir.DOWN

func _play_anim(prefix: String) -> void:
	var anim := prefix + "_" + _DIR_NAME[_facing]
	if _sprite.animation != anim:
		_sprite.play(anim)

# ---------- light detection ------------------------------------------------

func enter_light_zone() -> void:
	_light_zones += 1
	if _light_zones > 0 and _state != PlayerState.DEAD:
		_die()

func exit_light_zone() -> void:
	_light_zones = maxi(0, _light_zones - 1)

# ---------- death & respawn ------------------------------------------------

func _die() -> void:
	_state = PlayerState.DEAD
	died.emit()
	GameManager.on_player_died()
	_play_anim("death")

	# Wait for death animation to finish, then respawn
	await _sprite.animation_finished
	await get_tree().create_timer(0.1).timeout
	_respawn()

func _respawn() -> void:
	global_position  = _spawn_pos
	_light_zones     = 0
	_dash_timer      = 0.0
	_cooldown_timer  = 0.0
	velocity         = Vector2.ZERO
	_state           = PlayerState.NORMAL
	_sprite.modulate = Color.WHITE
	_play_anim("idle")
	respawned.emit()

func set_spawn(pos: Vector2) -> void:
	_spawn_pos = pos

# ---------- visual fx -------------------------------------------------------

func _fx_dash_squish() -> void:
	var t := create_tween()
	t.tween_property(_sprite, "scale", Vector2(1.5, 0.65), 0.06)
	t.tween_property(_sprite, "scale", Vector2(1.0, 1.0),  0.14)
