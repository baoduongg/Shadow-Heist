# Godot — Version Reference

*Last verified: 2026-04-21*

| Field | Value |
|-------|-------|
| **Engine Version** | 4.6 (use 4.6.2 patch — latest stable) |
| **Project Pinned** | 2026-04-21 |
| **LLM Knowledge Cutoff** | August 2025 |
| **Risk Level** | HIGH — Godot 4.6 released Jan 2026, beyond LLM training data |
| **Latest Patch** | 4.6.2 (released 2026-04-01, 122 fixes, no breaking changes vs 4.6.1) |

## Post-Cutoff Version Timeline

| Version | Release | Key Theme |
|---------|---------|-----------|
| Godot 4.4 | ~March 2025 | UID system overhaul, Jolt Physics (experimental), typed Dictionaries |
| Godot 4.5 | ~Sep 2025 | `abstract` keyword, variadic args, async navigation, TileMap physics chunks |
| Godot 4.6 | Jan 2026 | Polish + performance focus, AnimationPlayer StringName, scene UID tracking |
| Godot 4.6.2 | Apr 2026 | 122 bug fixes, no breaking changes |

## Migration Notes

Full migration guides:
- [4.3 → 4.4](https://docs.godotengine.org/en/4.4/tutorials/migrating/upgrading_to_godot_4.4.html)
- [4.4 → 4.5](https://docs.godotengine.org/en/4.5/tutorials/migrating/upgrading_to_godot_4.5.html)
- [4.5 → 4.6](https://docs.godotengine.org/en/4.6/tutorials/migrating/upgrading_to_godot_4.6.html)

See `breaking-changes.md` and `deprecated-apis.md` for extracted summaries.

## Note for AI Agents

This engine version is **beyond the LLM training cutoff**. Before generating code:
1. Check `deprecated-apis.md` for "don't use X → use Y" tables
2. Check `breaking-changes.md` for renamed or removed APIs
3. Check `current-best-practices.md` for patterns added after 4.3
4. Use WebSearch to verify uncertain APIs against docs.godotengine.org/en/4.6/

Run `/setup-engine refresh` to update these docs if needed.
