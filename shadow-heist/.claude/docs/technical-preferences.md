# Technical Preferences

<!-- Populated by /setup-engine. Updated as the user makes decisions throughout development. -->
<!-- All agents reference this file for project-specific standards and conventions. -->

## Engine & Language

- **Engine**: Godot 4.6
- **Language**: GDScript
- **Rendering**: Godot Renderer 2D (Forward+ for desktop, Mobile renderer for HTML5 export)
- **Physics**: Godot Physics 2D

## Input & Platform

<!-- Written by /setup-engine. Read by /ux-design, /ux-review, /test-setup, /team-ui, and /dev-story -->
<!-- to scope interaction specs, test helpers, and implementation to the correct input methods. -->

- **Target Platforms**: Web (HTML5)
- **Input Methods**: Keyboard/Mouse, Gamepad (optional)
- **Primary Input**: Keyboard/Mouse
- **Gamepad Support**: Partial
- **Touch Support**: Partial
- **Platform Notes**: HTML5 export via Godot Export Templates. Avoid persistent data beyond session unless using JavaScript browser storage bridge. UI must be keyboard-navigable. No hover-only interactions. Test with Godot's HTML5 template regularly — Light2D performance on browser must be validated early.

## Naming Conventions

- **Classes**: PascalCase (e.g., `PlayerController`, `GuardAI`)
- **Variables**: snake_case (e.g., `move_speed`, `is_detected`)
- **Functions**: snake_case (e.g., `take_damage()`, `get_current_health()`)
- **Signals/Events**: snake_case past tense (e.g., `player_died`, `data_collected`, `detection_triggered`)
- **Files**: snake_case matching class (e.g., `player_controller.gd`, `guard_ai.gd`)
- **Scenes/Prefabs**: PascalCase matching root node (e.g., `PlayerController.tscn`, `GuardPatrol.tscn`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_DASH_SPEED`, `DETECTION_RADIUS`)

## Performance Budgets

- **Target Framerate**: 60 fps
- **Frame Budget**: 16.6 ms
- **Draw Calls**: ≤ 500 (2D — HTML5 target; Light2D adds draw calls per shadow caster)
- **Memory Ceiling**: 256 MB (browser tab budget)

## Testing

- **Framework**: [Not configured — add GUT when testing is prioritized]
- **Minimum Coverage**: N/A (first project, lean mode)
- **Required Tests**: Core dash physics, light detection boundary conditions

## Forbidden Patterns

<!-- Add patterns that should never appear in this project's codebase -->
- No untyped GDScript variables or function signatures — all code must use static typing
- No polling in `_process()` for state that can use signals — use signals for event-driven behavior
- No hardcoded magic numbers for gameplay values — use constants or exported variables

## Allowed Libraries / Addons

<!-- Add approved third-party dependencies here -->
<!-- Only add a library here when it is actively being integrated, not speculatively -->
- [None configured yet — add as dependencies are approved]

## Architecture Decisions Log

<!-- Quick reference linking to full ADRs in docs/architecture/ -->
- [No ADRs yet — use /architecture-decision to create one]

## Engine Specialists

<!-- Written by /setup-engine when engine is configured. -->
<!-- Read by /code-review, /architecture-decision, /architecture-review, and team skills -->
<!-- to know which specialist to spawn for engine-specific validation. -->

- **Primary**: godot-specialist
- **Language/Code Specialist**: godot-gdscript-specialist (all .gd files)
- **Shader Specialist**: godot-shader-specialist (.gdshader files, VisualShader resources)
- **UI Specialist**: godot-specialist (no dedicated UI specialist — primary covers all UI)
- **Additional Specialists**: godot-gdextension-specialist (GDExtension / native C++ bindings only)
- **Routing Notes**: Invoke primary for architecture decisions, ADR validation, and cross-cutting code review. Invoke GDScript specialist for code quality, signal architecture, static typing enforcement, and GDScript idioms. Invoke shader specialist for material design and shader code. Invoke GDExtension specialist only when native extensions are involved.

### File Extension Routing

<!-- Skills use this table to select the right specialist per file type. -->

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| Game code (.gd files) | godot-gdscript-specialist |
| Shader / material files (.gdshader, VisualShader) | godot-shader-specialist |
| UI / screen files (Control nodes, CanvasLayer) | godot-specialist |
| Scene / prefab / level files (.tscn, .tres) | godot-specialist |
| Native extension / plugin files (.gdextension, C++) | godot-gdextension-specialist |
| General architecture review | godot-specialist |
