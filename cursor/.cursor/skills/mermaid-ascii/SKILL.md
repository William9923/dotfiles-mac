---
name: mermaid-ascii
description: >-
  Renders Mermaid diagrams as ASCII art via the mermaid-ascii CLI before showing
  them to the user. Use whenever a mermaid diagram would appear in agent output —
  flowcharts, sequence diagrams, architecture overviews, state flows, or any
  ```mermaid block. Auto-invoke in Cursor CLI and terminal sessions where Mermaid
  does not render visually. Also use when the user asks for ASCII or terminal diagrams.
---

# Mermaid ASCII

Before outputting any Mermaid diagram, render it with [mermaid-ascii](https://github.com/AlexanderGrooff/mermaid-ascii) and show the ASCII result instead of a raw ` ```mermaid ` block.

## Trigger

Apply this skill **whenever** you would include a diagram in your response:

- Architecture or system overviews
- Flowcharts, decision trees, pipelines
- Sequence diagrams (request/response, auth flows)
- Any `graph`, `flowchart`, or `sequenceDiagram` source

**Do not** output a ` ```mermaid ` fenced block as the primary diagram. Run the CLI first, then show ASCII in a plain code fence.

**Exception:** User explicitly asks for editable Mermaid source, or IDE visual preview is clearly the target (not CLI/terminal).

## Render workflow

1. Draft the Mermaid source internally (do not show it yet).
2. Render via stdin — always execute, never hand-draw:

```bash
cat <<'EOF' | mermaid-ascii -f -
graph LR
  A --> B --> C
EOF
```

3. Put CLI stdout in a plain fenced code block (no language tag).
4. Add a one-line caption above the block if context helps.
5. Skip the Mermaid source unless the user asked for it or rendering failed.

## CLI reference

| Flag | Purpose |
|------|---------|
| `-f -` | Read from stdin |
| `-a` | Pure ASCII (`+---+`) — use when box-drawing chars break |
| `-x N` | Horizontal node spacing (default 5) |
| `-y N` | Vertical node spacing (default 5) |
| `-p N` | Box padding (default 1) |

Binary: `mermaid-ascii` (expect `/usr/local/bin/mermaid-ascii`).

## Supported syntax

**Flowcharts:** `graph LR`, `graph TD`, labeled edges (`A -->|label| B`), `A & B`, chained arrows (`A --> B --> C`).

**Sequence:** `sequenceDiagram`, `->>` / `-->>`, self-messages, `participant A as Alias`.

**Unsupported:** subgraphs, non-rectangle shapes, class/state/ER diagrams, sequence notes/loops/alt/activate.

Keep diagrams compact — wide graphs wrap badly in narrow terminals.

## Fallback

**Binary missing** — install then retry:

```bash
curl -sL "$(curl -s https://api.github.com/repos/AlexanderGrooff/mermaid-ascii/releases/latest \
  | grep 'browser_download_url.*mermaid-ascii' | grep "$(uname)_$(uname -m)" \
  | cut -d: -f2,3 | tr -d '"')" | tar xzf - -C /tmp && sudo mv /tmp/mermaid-ascii /usr/local/bin/
```

**Render fails** — show the Mermaid source in a `mermaid` block and note which syntax is unsupported.

## Example

User: "Show me the auth flow"

Agent runs:

```bash
cat <<'EOF' | mermaid-ascii -f -
sequenceDiagram
  User->>API: login
  API->>DB: verify
  DB-->>API: ok
  API-->>User: token
EOF
```

Agent responds with caption + plain code fence containing the ASCII output — not a `mermaid` block.

## Anti-patterns

- Outputting ` ```mermaid ` in CLI when mermaid-ascii can render it
- Hand-drawing ASCII boxes instead of running the CLI
- Showing both Mermaid source and ASCII unless the user wants both
