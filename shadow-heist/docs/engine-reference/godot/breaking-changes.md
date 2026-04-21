# Godot Breaking Changes — 4.3 → 4.6

*Last verified: 2026-04-21*
*Sources: Official Godot migration guides, godotengine.org release notes*

---

## 4.3 → 4.4

### UID System Overhaul
- **Change**: File UIDs are now first-class citizens. Scene/resource references use UIDs instead of paths wherever possible.
- **Impact**: Godot 4.4 includes an automatic UID upgrade tool — run it when opening an existing project. New projects are unaffected.
- **Action**: Run the built-in migration tool on project open.

### CSG System Replaced
- **Change**: CSG now uses the Manifold library internally. User-facing API is mostly unchanged.
- **Impact**: Visual/geometry results may differ slightly from 4.3. Test CSG-heavy scenes after upgrade.

### SkeletonIK3D Deprecated
- **Change**: `SkeletonIK3D` is deprecated in favor of `LookAtModifier3D`.
- **Impact**: GDScript code using `SkeletonIK3D` will get deprecation warnings. No hard break — still functional.
- **Migration**: Replace with `LookAtModifier3D` for new code.

### Typed Dictionaries
- **Change**: `Dictionary` now supports typed variants (`Dictionary[String, int]`).
- **Impact**: No breaking change for existing code — untyped dictionaries still work. New GDScript style prefers typed.

---

## 4.4 → 4.5

### TileMap Physics Chunked
- **Change**: TileMap physics are now handled in chunks. `get_coords_for_body_rid()` behavior changed — a single body can now cover multiple cells.
- **Impact**: Code that assumes 1:1 body-to-cell mapping in TileMap will break.
- **Action**: Audit any `get_coords_for_body_rid()` usage.

### Navigation Region Updates — Async
- **Change**: 2D and 3D navigation region updates are now asynchronous.
- **Impact**: Code that assumed synchronous nav mesh updates will behave differently. Callback parameter type changed: `Vector3` → `Vector2` in 2D.
- **Action**: Add `await` or connect to completion signals for nav mesh baking.

### AnimationNode: NodeOneShot Delta Change
- **Change**: `NodeOneShot` fading now uses self delta instead of input delta.
- **Impact**: Fading behavior may appear slightly different. Cosmetic for most use cases.

### Android Export: compress_native_libraries Removed
- **Change**: `gradle_build/compress_native_libraries` export option removed.
- **Impact**: Android exports only. Web/PC unaffected.

### Jolt Physics: Areas Detect Static Bodies
- **Change**: "Areas Detect Static Bodies" setting removed from Jolt Physics — now always enabled.
- **Impact**: Only affects projects using experimental Jolt Physics.

### JSONRPC.set_scope() Removed
- **Change**: `JSONRPC.set_scope()` removed. Use `set_method()` for manual registration.
- **Impact**: Any JSONRPC code using `set_scope()` will fail. Migrate to `set_method()`.

### New GDScript Keywords
- **Addition**: `abstract` keyword for classes and methods (not breaking, but new reserved word).
- **Addition**: Variadic arguments (`...args`) syntax — new reserved syntax.
- **Impact**: If any variable or function is named `abstract`, rename it.

---

## 4.5 → 4.6

### AnimationPlayer — StringName Properties
- **Change**: `assigned_animation`, `autoplay`, `current_animation` changed from `String` to `StringName`.
- **Change**: `get_queue()` return type changed from `PackedStringArray` to `Array[StringName]`.
- **Change**: Signal `current_animation_changed` parameter `name` is now `StringName`.
- **Impact**: GDScript auto-converts `String` ↔ `StringName` — mostly transparent. But typed code using `PackedStringArray` for queue results will break.
- **Action**: Update any typed variable holding `AnimationPlayer.get_queue()` to `Array[StringName]`.

### FileAccess Changes
- **Change**: `FileAccess.create_temp()` parameter `mode_flags` changed from `int` to `FileAccess.ModeFlags`.
- **Change**: `FileAccess.get_as_text()` removes `skip_cr` parameter.
- **Impact**: Code passing raw `int` to `create_temp()` may get type warnings. `get_as_text()` calls with the `skip_cr` argument will fail.
- **Action**: Remove `skip_cr` argument from `get_as_text()` calls. Update `create_temp()` to use `FileAccess.ModeFlags` enum.

### OpenXR: _get_requested_extensions() Parameter Added
- **Change**: `OpenXRExtensionWrapper._get_requested_extensions()` now requires `xr_version` parameter.
- **Impact**: OpenXR GDScript extensions only. Not relevant for 2D games.

### EditorFileDialog: add_side_menu() Removed
- **Change**: `EditorFileDialog.add_side_menu()` removed entirely.
- **Impact**: Editor plugins using `add_side_menu()` will break. Not relevant for game runtime code.

### Scene Format: load_steps Removed, UID Tracking Added
- **Change**: `load_steps` attribute no longer written in `.tscn` files. Unique node IDs now saved.
- **Impact**: Backward compatible — scenes load fine. Node tracking is more robust after upgrade.

### Glow Rendering Default Changed
- **Change**: Default glow blend mode changed to Screen (significantly brighter than before).
- **Impact**: Scenes using glow effects may appear much brighter after upgrading from 4.5. Visual only — no code change needed.
- **Action**: Review and adjust glow settings in any 3D/2D scenes using bloom/glow effects. **Important for VOID SLIP**: neon glow effects may need re-tuning after upgrading from 4.5.

### GLSL Shader: view_matrix / inv_view_matrix Changed
- **Change**: `view_matrix` and `inv_view_matrix` in built-in `SceneData` uniform changed from `mat4` to `mat3x4`. Requires transposed matrix operations.
- **Impact**: Custom GLSL shaders using these uniforms will produce incorrect results.
- **Action**: Update any custom GLSL shaders using `view_matrix` or `inv_view_matrix`.
