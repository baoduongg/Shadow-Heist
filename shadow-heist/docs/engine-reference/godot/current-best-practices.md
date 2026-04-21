# Godot 4.4–4.6 Best Practices

*Last verified: 2026-04-21*
*New patterns introduced after LLM training cutoff (Godot ~4.3)*

---

## GDScript Language (4.4+)

### Typed Dictionaries (4.4+)
Prefer typed dictionaries for clarity and error catching:
```gdscript
# Prefer (4.4+)
var item_counts: Dictionary[String, int] = {}

# Old style (still valid, less safe)
var item_counts: Dictionary = {}
```

### Abstract Classes (4.5+)
Use `abstract` to define base classes that should never be instantiated directly:
```gdscript
abstract class BaseEnemy extends CharacterBody2D:
    abstract func take_damage(amount: int) -> void
    abstract func patrol() -> void
```

### Variadic Arguments (4.5+)
```gdscript
func log_event(event: String, ...args) -> void:
    print(event, args)
```

---

## Scene & Node Best Practices (4.4+)

### UID-Based References (4.4+)
Godot 4.4 fully supports UIDs for scene/resource references. Prefer `uid://` paths over relative paths in `load()` calls:
```gdscript
# Prefer (stable across file moves)
var scene := preload("uid://abc123xyz")

# Old (breaks if file is moved)
var scene := preload("res://scenes/PlayerController.tscn")
```

### Unique Node IDs (4.6)
Scene files now save unique node IDs. This makes node refactoring more robust — nodes can be renamed/moved and references still resolve. No code change required; this is an editor-level improvement.

---

## Animation (4.6+)

### StringName for Animation References
In Godot 4.6, `AnimationPlayer` properties use `StringName`. Prefer `StringName` literals:
```gdscript
# Prefer (4.6+ idiomatic)
animation_player.play(&"run")
animation_player.current_animation = &"idle"

# Still works (auto-converted) but less explicit
animation_player.play("run")
```

---

## Navigation (4.5+)

### Async Navigation Baking
Navigation region updates are now async. Always use signals or `await`:
```gdscript
# Correct (4.5+)
navigation_region.bake_navigation_polygon()
await navigation_region.bake_finished
# Now safe to query paths

# Wrong — nav mesh may not be ready
navigation_region.bake_navigation_polygon()
var path := navigation_agent.get_current_navigation_path()  # May be stale
```

---

## HTML5 / Web Export (Relevant for VOID SLIP)

### Light2D Performance on Web
The Mobile renderer is recommended for HTML5 export — it's significantly faster in browser:
- Set `Project Settings → Rendering → Renderer → Rendering Method` to `mobile` for HTML5 export preset
- Light2D with many shadow casters is expensive. Profile with browser DevTools early.
- Limit `PointLight2D` count — prefer baked light textures for static areas.

### Persistent Storage on Web
`FileAccess` writes to a virtual filesystem in browser memory — data is lost on page refresh unless explicitly flushed:
```gdscript
# Required after writing files in HTML5
var file := FileAccess.open("user://save.dat", FileAccess.WRITE)
file.store_string(data)
file.close()
# In HTML5, call this to persist to browser storage:
JavaScriptBridge.eval("FS.syncfs(false, function(){});")
```

### Input in Browser
- Pointer Lock API required for mouse capture in browsers — Godot handles this automatically via `Input.mouse_mode = Input.MOUSE_MODE_CAPTURED`
- Gamepad API works in modern browsers but requires a user gesture (button press) before activating
