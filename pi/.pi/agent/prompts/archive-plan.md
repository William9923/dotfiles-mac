---
description: Archive the current plan.md to Obsidian vault under plan/ and delete the local copy
argument-hint: "[optional custom title]"
---
Read the current `plan.md` in the project root, then archive it into the Obsidian vault.

Workflow:
1. Read `plan.md` in full.
2. Derive a title from the plan's objective or use the provided argument. Use a descriptive title like "plan/<topic>.md" (e.g., "plan/pi-skills cleanup.md").
3. Create the note in the Obsidian vault:
   ```bash
   obsidian create path="plan/<title>.md" content="<content>"
   ```
   Escape special characters properly in the content string.
4. Verify the note was created by reading it back.
5. Delete the local `plan.md`.
6. Report the archived path and title.

Notes:
- Vault is at `/Users/william.ong/obsidian-notes`
- Use `obsidian create path="plan/<title>.md" content="..."` for creation
- Escape the content carefully to avoid shell interpretation issues
- Always verify before deleting the local file
