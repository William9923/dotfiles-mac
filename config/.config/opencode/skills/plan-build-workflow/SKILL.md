---
name: plan-build-workflow
description: Guides opencode through a Cursor-style Plan -> Submit -> Approve -> Build workflow using readable plan files.
compatibility: opencode
---

# Plan Build Workflow

## Purpose

Use this skill to keep planning and implementation separate. Plans are written to `.opencode/plans/` with unique filenames, and building only happens from the active approved plan.

## Workflow

1. `/plan <goal>` creates a new unique plan file and updates `.opencode/plans/active.md`.
2. `/submit-plan` polishes the active plan and changes its status to `submitted`.
3. `/approve-plan` marks the submitted active plan as `approved`.
4. `/build` implements the next incomplete task from the approved active plan.

## Plan Files

Create plans under `.opencode/plans/` using this filename format:

```text
YYYY-MM-DD-HHMM-<short-slug>-<4-char-hex>.md
```

Example:

```text
.opencode/plans/2026-05-30-2319-opencode-plan-build-a7f3.md
```

Do not use `.opencode/plans/current.md` for plan content. Keep history by writing every plan to a unique file.

Use `.opencode/plans/active.md` only as a pointer to the active plan.

## Status Rules

Valid statuses:

- `draft`: plan is being shaped
- `submitted`: plan is ready for human approval
- `approved`: plan may be built
- `building`: a build task is in progress
- `done`: all plan tasks are complete
- `cancelled`: plan should not be built

Only `/build` can implement code, and only when the active plan status is `approved` or `building`.

If the plan is `draft` or `submitted`, stop and ask for the next workflow command.
If the plan is `cancelled`, stop.
If no active plan exists, ask the user to run `/plan <goal>`.

## Plan Template

Every plan should include:

```md
---
status: draft
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM
goal: "<short goal>"
---

# Implementation Plan: <Title>

## Goal

<One paragraph describing the intended outcome.>

## Scope

- <What is included.>

## Non-Goals

- <What is intentionally excluded.>

## Context

- <Relevant files, constraints, or existing patterns.>

## Tasks

### Task 1: <Small Vertical Slice>

Status: pending

Acceptance criteria:

- [ ] <Specific testable condition>

Verification:

- [ ] `<command or manual check>`

Likely files:

- `<path>`

Dependencies: None

## Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| <risk> | <low/medium/high> | <mitigation> |

## Open Questions

- <Question, or "None">
```

## Planning Rules

- Read relevant project files before planning.
- Prefer vertical tasks that leave the project working.
- Keep each task small enough to verify independently.
- Add verification commands when the repository has obvious test, lint, typecheck, or build scripts.
- Note unknowns instead of guessing.
- Do not edit source code while planning.

## Build Rules

- Read `.opencode/plans/active.md` first.
- Read the referenced plan file second.
- Build exactly one incomplete task by default.
- Keep changes scoped to the active task.
- Do not commit unless the user explicitly asks.
- Update the plan after each completed task.
- Keep the plan status as `approved` while more tasks remain.
- Mark the plan status as `done` when all tasks are complete.
- If verification cannot be run, record the reason in the response.

## Stop Conditions

Stop and ask the user before building if:

- There is no active plan.
- The active plan cannot be found.
- The active plan is not approved.
- The next task has unclear acceptance criteria.
- The requested work conflicts with the approved scope.
- The implementation would require touching secrets or committing sensitive config.
