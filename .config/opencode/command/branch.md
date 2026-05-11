---
description: Create a branch from a feature description
agent: orchestrator
---
Create a new git branch with a conventional name derived from your description.

## Your Task

1. **Parse the description**: `$ARGUMENTS`
   
2. **Determine branch type** from the description:
   | Type | Triggers | Prefix |
   |------|----------|--------|
   | Feature | "add", "create", "implement", "new", "build" | `feat/` |
   | Bugfix | "fix", "bug", "resolve", "patch", "correct" | `fix/` |
   | Hotfix | "hotfix", "urgent", "critical", "emergency" | `hotfix/` |
   | Refactor | "refactor", "restructure", "reorganize", "clean" | `refactor/` |
   | Docs | "document", "docs", "readme", "guide" | `docs/` |
   | Test | "test", "spec", "coverage" | `test/` |
   | Chore | "chore", "update", "upgrade", "bump", "maintain" | `chore/` |
   | CI | "ci", "pipeline", "workflow", "deploy" | `ci/` |

3. **Generate branch name**:
   - Extract key nouns/verbs from description
   - Convert to kebab-case
   - Keep it concise (3-5 words max after prefix)
   - Format: `<type>/<short-description>`

4. **Verify and create**:
   ```bash
   git fetch origin
   git checkout -b <branch-name>
   ```

## Arguments

`$ARGUMENTS` - A sentence or paragraph describing what the branch will do

## Examples

| Input | Generated Branch |
|-------|------------------|
| "Add user authentication with JWT tokens" | `feat/user-auth-jwt` |
| "Fix the login page not redirecting properly" | `fix/login-redirect` |
| "Refactor the database connection pooling" | `refactor/db-connection-pool` |
| "Update dependencies to latest versions" | `chore/update-dependencies` |
| "Add unit tests for payment service" | `test/payment-service` |
| "Document the API endpoints for v2" | `docs/api-v2-endpoints` |

## Rules

- Branch names MUST be lowercase
- Use hyphens (-) not underscores (_) or spaces
- Keep total length under 50 characters
- Avoid special characters except `/` and `-`
- If description is ambiguous, ask for clarification

## After Creation

1. Show the created branch name
2. Confirm you're now on the new branch (`git branch --show-current`)
3. Remind user to push with: `git push -u origin <branch-name>`
