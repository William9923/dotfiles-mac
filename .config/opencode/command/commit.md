---
description: Create a commit using Conventional Commits format
agent: orchestrator
---
Create a git commit following the Conventional Commits specification (https://www.conventionalcommits.org/en/v1.0.0/).

## Your Task

1. Run `git status` and `git diff --staged` to see what changes are staged
2. If nothing is staged, run `git diff` to see unstaged changes and suggest what to stage
3. Analyze the changes and determine:
   - **type**: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
   - **scope** (optional): affected module/component in parentheses
   - **description**: imperative mood, lowercase, no period at end
   - **body** (if needed): explain "why" not "what"
   - **BREAKING CHANGE** (if applicable): in footer

## Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
Co-authored-by: opencode <noreply@opencode.ai>
```

## Rules

- Type MUST be one of: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Description MUST be imperative mood ("add" not "added"), lowercase, no period
- Keep first line under 72 characters
- ALWAYS add the Co-authored-by footer for opencode
- Use `!` after type/scope for breaking changes (e.g., `feat!:` or `feat(api)!:`)

## Examples

Good:
- `feat(auth): add JWT token refresh`
- `fix: resolve race condition in request handling`
- `docs: update API endpoint documentation`
- `refactor(db)!: change connection pooling strategy`

Bad:
- `Fixed bug` (no type, past tense)
- `feat: Add new feature.` (capitalized, period)
- `update code` (no type, vague)

## Execution

After analyzing, execute the commit with the proper message. Do NOT ask for confirmation unless the changes are ambiguous or potentially destructive.
