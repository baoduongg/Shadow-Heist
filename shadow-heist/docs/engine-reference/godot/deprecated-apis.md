# Godot Deprecated APIs — Don't Use X → Use Y

*Last verified: 2026-04-21*
*Covers: Godot 4.4, 4.5, 4.6*

---

## GDScript APIs

| Deprecated | Replacement | Since | Notes |
|-----------|-------------|-------|-------|
| `SkeletonIK3D` | `LookAtModifier3D` | 4.4 | 3D only — not relevant for 2D |
| `JSONRPC.set_scope()` | `JSONRPC.set_method()` | 4.5 | Register methods manually |
| `FileAccess.get_as_text(skip_cr)` | `FileAccess.get_as_text()` | 4.6 | Remove `skip_cr` argument |
| `AnimationPlayer.get_queue()` → `PackedStringArray` | `Array[StringName]` | 4.6 | Update typed declarations |

---

## Removed APIs (Hard Breaks)

| Removed API | Replacement | Since |
|------------|-------------|-------|
| `EditorFileDialog.add_side_menu()` | No direct replacement | 4.6 |
| `JSONRPC.set_scope()` | `JSONRPC.set_method()` | 4.5 |
| `gradle_build/compress_native_libraries` export option | (Removed — Android only) | 4.5 |
| `Jolt.areas_detect_static_bodies` setting | Always enabled now | 4.5 |

---

## Type Changes (May Cause Silent Bugs)

| API | Old Type | New Type | Since |
|-----|----------|----------|-------|
| `AnimationPlayer.assigned_animation` | `String` | `StringName` | 4.6 |
| `AnimationPlayer.autoplay` | `String` | `StringName` | 4.6 |
| `AnimationPlayer.current_animation` | `String` | `StringName` | 4.6 |
| `AnimationPlayer.get_queue()` | `PackedStringArray` | `Array[StringName]` | 4.6 |
| Signal `current_animation_changed` param `name` | `String` | `StringName` | 4.6 |
| `FileAccess.create_temp()` param `mode_flags` | `int` | `FileAccess.ModeFlags` | 4.6 |

---

## Rendering Behavior Changes (Not API — Visual)

| Behavior | Change | Since | Action |
|---------|--------|-------|--------|
| Glow blend mode default | Changed to Screen (brighter) | 4.6 | Re-tune glow settings after upgrade |
| Volumetric fog blending | More physically accurate (brighter) | 4.6 | Re-tune volumetric fog after upgrade |
| GLSL `view_matrix` / `inv_view_matrix` | `mat4` → `mat3x4` | 4.6 | Update custom GLSL shaders |
