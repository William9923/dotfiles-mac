---
description: Build the next task from the approved active plan
agent: build
---

Use the `plan-build-workflow` skill.

Read `.opencode/plans/active.md`, then read the referenced plan file.

Before doing any implementation:

1. Confirm the referenced plan status is `approved` or `building`.
2. If the status is not `approved` or `building`, stop and tell the user to run `/submit-plan` or `/approve-plan` first.
3. Identify the next incomplete task in the approved plan.
4. Restate that task's acceptance criteria and verification steps.
5. Inspect only the relevant code needed for that task.

For the next incomplete task:

1. Implement the smallest complete change that satisfies the task.
2. Keep the change scoped to the task.
3. Run focused verification commands from the plan when available.
4. If verification fails, debug and fix within the same task scope.
5. Update the task status in the plan file.
6. Update `.opencode/plans/active.md` with the current status and timestamp.
7. If all tasks are complete, mark the plan status as `done`.
8. Stop after one task unless the user explicitly asks to continue.

Do not commit unless the user explicitly asks for a commit.
Do not silently skip verification. If a verification command cannot be run, explain why.
