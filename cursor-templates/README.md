# Cursor local templates

These files are **not** stowed into `$HOME`. Copy them manually on a new Mac.

| Template | Copy to | Notes |
|----------|---------|-------|
| `mcp.json.example` | `~/.cursor/mcp.json` | MCP server URLs and tokens. Edit after copy; never commit the real file. |

Cursor does not read MCP config from `~/.config/`. The IDE uses `~/Library/Application Support/Cursor/User/` for editor settings (tracked in dotfiles); the CLI and agent use `~/.cursor/` for MCP, plugins, and session state.

**Agent skills** (custom `SKILL.md` files) are stowed from `cursor/.cursor/skills/` to `~/.cursor/skills/` via `setup.sh`. Do not put secrets or MCP config in that tree — only portable skill definitions.
