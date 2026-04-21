# VOID SLIP — Claude Code Project Guide

## Project Overview

**Game**: VOID SLIP — 2D stealth pixel art game
**Concept**: Top-down shadow entity avoids light in neon lab to steal data
**Concept Doc**: `design/gdd/game-concept.md`

## Technology Stack

- **Engine**: Godot 4.6
- **Language**: GDScript
- **Build System**: SCons (engine), Godot Export Templates
- **Asset Pipeline**: Godot Import System + custom resource pipeline

## Engine Version Reference

@docs/engine-reference/godot/VERSION.md

## Project Structure

```
shadow-heist/
├── scenes/          # .tscn scene files
├── assets/          # sprites, audio, shaders
├── design/
│   └── gdd/         # game design documents
├── docs/
│   └── engine-reference/godot/  # version-aware API reference
└── production/      # sprint plans, milestones, review config
```

## Coding Standards

All GDScript files must use **static typing**. No untyped variables.

```gdscript
# Correct
var speed: float = 200.0
func dash(direction: Vector2) -> void:

# Wrong
var speed = 200.0
func dash(direction):
```

Signals must be declared before variables, use snake_case past tense:
```gdscript
signal health_changed(new_health: int)
signal player_died
```

## Agent Routing

When spawning specialist agents for code review or implementation:
- `.gd` files → `godot-gdscript-specialist`
- `.gdshader` files → `godot-shader-specialist`
- `.tscn` / `.tres` files → `godot-specialist`
- Architecture decisions → `godot-specialist`
- Native extensions → `godot-gdextension-specialist`
