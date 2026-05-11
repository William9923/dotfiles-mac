---
description: Interactive rebase with safety checks
agent: orchestrator
---
Perform a git rebase operation with safety checks.

## Your Task

1. **Assess current state**:
   ```bash
   git status
   git branch -vv
   git log --oneline -10
   ```

2. **Determine rebase target**:
   - If `$ARGUMENTS` provided, use it as the target (e.g., `main`, `origin/main`, `HEAD~3`)
   - If no arguments, default to rebasing onto the upstream branch (usually `origin/main` or `origin/master`)

3. **Safety checks before rebasing**:
   - [ ] Working directory is clean (no uncommitted changes)
   - [ ] Not on `main` or `master` branch (warn if so)
   - [ ] Branch has commits ahead of target

4. **If working directory is dirty**:
   - Ask user: stash changes, commit them, or abort?

5. **Execute rebase**:
   ```bash
   git fetch origin
   git rebase <target>
   ```

6. **Handle conflicts** (if any):
   - Show which files have conflicts
   - Provide guidance on resolving them
   - Remind user of commands: `git rebase --continue`, `git rebase --abort`

## Arguments

- `$ARGUMENTS` - Optional rebase target (branch name, commit SHA, or `HEAD~N`)

## Examples

```
/rebase              # Rebase onto origin/main (or origin/master)
/rebase main         # Rebase onto local main
/rebase origin/main  # Rebase onto origin/main
/rebase HEAD~3       # Interactive-style rebase last 3 commits
```

## Safety Rules

- NEVER force push without explicit user confirmation
- NEVER rebase if there are uncommitted changes (offer to stash first)
- WARN if rebasing a branch that has been pushed to remote
- ABORT and explain if rebase would cause data loss

## Conflict Resolution Guidance

If conflicts occur, explain:
1. Which files have conflicts
2. How to view the conflicts (`git diff`)
3. After resolving: `git add <files>` then `git rebase --continue`
4. To abort: `git rebase --abort`
