extends TileMapLayer

## Builds the dungeon room at runtime from walls_floor.png tileset.
##
## walls_floor.png: 272×464 px, tile size 16×16
## Atlas layout:  17 columns × 29 rows
## Tile (col, row) → atlas_coords = Vector2i(col, row)
##
## Adjust the constants below in the editor if tiles look wrong:

# ── Tile atlas coordinates ─────────────────────────────────────────────────
# These are (column, row) inside walls_floor.png at 16×16 tile size.
# Open the TileSet editor in Godot to preview and pick the right coords.
const TILE_FLOOR:    Vector2i = Vector2i(1, 4)  # main floor tile
const TILE_FLOOR_B:  Vector2i = Vector2i(2, 4)  # floor variant (checkerboard)
const TILE_WALL_TOP: Vector2i = Vector2i(1, 0)  # top wall face
const TILE_WALL_BOT: Vector2i = Vector2i(1, 2)  # bottom wall face / wall base
const TILE_WALL_L:   Vector2i = Vector2i(0, 1)  # left wall side
const TILE_WALL_R:   Vector2i = Vector2i(2, 1)  # right wall side
const TILE_CORNER_TL:Vector2i = Vector2i(0, 0)  # top-left corner
const TILE_CORNER_TR:Vector2i = Vector2i(2, 0)  # top-right corner
const TILE_CORNER_BL:Vector2i = Vector2i(0, 2)  # bottom-left corner
const TILE_CORNER_BR:Vector2i = Vector2i(2, 2)  # bottom-right corner

# ── Room dimensions (must match viewport / wall positions) ─────────────────
const ROOM_W:   int = 80   # 80 × 16 = 1280 px
const ROOM_H:   int = 45   # 45 × 16 = 720  px
const BORDER:   int = 2    # 2 tiles = 32 px wall thickness

var _source_id: int = 0

func _ready() -> void:
	tile_set = _build_tileset()
	_draw_room()

# ---------- tileset --------------------------------------------------------

func _build_tileset() -> TileSet:
	var ts := TileSet.new()
	ts.tile_size = Vector2i(16, 16)

	var src := TileSetAtlasSource.new()
	src.texture = load("res://assets/sprites/enviroment/walls_floor.png") as Texture2D
	src.texture_region_size = Vector2i(16, 16)
	_source_id = ts.add_source(src)

	# Register every tile atlas coord we'll paint
	var all_tiles: Array[Vector2i] = [
		TILE_FLOOR, TILE_FLOOR_B,
		TILE_WALL_TOP, TILE_WALL_BOT, TILE_WALL_L, TILE_WALL_R,
		TILE_CORNER_TL, TILE_CORNER_TR, TILE_CORNER_BL, TILE_CORNER_BR,
	]
	for coords in all_tiles:
		if not src.has_tile(coords):
			src.create_tile(coords)

	return ts

# ---------- room drawing ---------------------------------------------------

func _draw_room() -> void:
	_draw_floor()
	_draw_walls()

func _draw_floor() -> void:
	# Checkerboard floor for visual depth
	for y: int in range(BORDER, ROOM_H - BORDER):
		for x: int in range(BORDER, ROOM_W - BORDER):
			var tile := TILE_FLOOR if (x + y) % 2 == 0 else TILE_FLOOR_B
			set_cell(Vector2i(x, y), _source_id, tile)

func _draw_walls() -> void:
	# Top and bottom wall rows
	for x: int in range(ROOM_W):
		set_cell(Vector2i(x, 0),          _source_id, TILE_WALL_TOP)
		set_cell(Vector2i(x, 1),          _source_id, TILE_WALL_TOP)
		set_cell(Vector2i(x, ROOM_H - 2), _source_id, TILE_WALL_BOT)
		set_cell(Vector2i(x, ROOM_H - 1), _source_id, TILE_WALL_BOT)

	# Left and right wall columns
	for y: int in range(2, ROOM_H - 2):
		set_cell(Vector2i(0,          y), _source_id, TILE_WALL_L)
		set_cell(Vector2i(1,          y), _source_id, TILE_WALL_L)
		set_cell(Vector2i(ROOM_W - 2, y), _source_id, TILE_WALL_R)
		set_cell(Vector2i(ROOM_W - 1, y), _source_id, TILE_WALL_R)

	# Corners
	set_cell(Vector2i(0,          0),          _source_id, TILE_CORNER_TL)
	set_cell(Vector2i(ROOM_W - 1, 0),          _source_id, TILE_CORNER_TR)
	set_cell(Vector2i(0,          ROOM_H - 1), _source_id, TILE_CORNER_BL)
	set_cell(Vector2i(ROOM_W - 1, ROOM_H - 1), _source_id, TILE_CORNER_BR)
