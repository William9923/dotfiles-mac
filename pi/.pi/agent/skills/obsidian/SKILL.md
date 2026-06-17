---
name: obsidian
description: Obsidian vault access via the obsidian CLI (local REST API). Read, create, append, list tasks/tags/backlinks, and full-text search.
---

# Obsidian

Access your Obsidian vault at `/Users/william.ong/obsidian-notes` using the `obsidian` CLI via the Obsidian Local REST API plugin.

## Setup

Install the `obsidian` CLI and enable the Local REST API plugin in Obsidian. The API key (`$OBSIDIAN_MCP_TOKEN`) is exported from `~/.zsh_secrets` (see `zsh/.zsh_secrets.example`).

## Core Commands

### Read a note

```bash
obsidian read path="My Note.md"        # Exact path from vault root
```

### List files

```bash
obsidian files                             # All files
obsidian files folder="Daily Notes"        # Files in a folder
obsidian files ext=md                      # Only markdown (default)
obsidian files ext=png                     # Images only
obsidian files total                       # File count
```

### Full-text search

Obsidian CLI has no built-in search. Use `rg` directly on the vault:

```bash
rg -i "search term" /Users/william.ong/obsidian-notes --md -l   # List matching files
rg -i "search term" /Users/william.ong/obsidian-notes --md -C 2 # With context
```

### Create a note

```bash
obsidian create path="folder/New Note.md" content="# Heading\n\nBody text"
obsidian create path="folder/New Note.md" content="# Heading" open  # Open after create
```

### Append to a note

```bash
obsidian append path="Note.md" content="\n- new list item"
obsidian append path="Note.md" content="more text" --inline   # No newline
```

### Tasks

```bash
obsidian tasks                                  # All incomplete tasks
obsidian tasks path="Project.md"                # Tasks in a file
obsidian tasks total                            # Count
obsidian tasks done                             # Show completed
obsidian task ref="Note.md:42" toggle           # Toggle a task at line 42
obsidian task ref="Note.md:42" done             # Mark done
```

### Tags

```bash
obsidian tags                                   # All tags with counts
obsidian tags path="Note.md"                    # Tags in a file
obsidian tags total                             # Count
```

### Backlinks (what links to a note)

```bash
obsidian backlinks path="Note.md"
obsidian backlinks path="Note.md" total
obsidian backlinks path="Note.md" counts        # With link counts
```

### Orphans & Dead ends

```bash
obsidian orphans       # Files with no incoming links
obsidian deadends      # Files with no outgoing links
```

### Vault info

```bash
obsidian vault
obsidian vaults        # List known vaults
```

### Delete a note

```bash
obsidian delete path="Old Note.md"             # Trash
obsidian delete path="Old Note.md" permanent   # Skip trash
```

## Notes

- Use `path=` for exact file paths (relative to vault root), `file=` for wiki-style name lookup
- All commands target the `obsidian-notes` vault by default
- The REST API must be running (Obsidian open with plugin enabled)
