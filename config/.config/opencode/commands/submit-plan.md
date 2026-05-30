---
description: Submit the active plan for human approval
agent: plan
---

Use the `plan-build-workflow` skill.

Read `.opencode/plans/active.md`, then read the referenced plan file.

Do not edit source code or configuration. Only update files under `.opencode/plans/`.

Review and polish the active plan so it is ready for approval:

1. Clarify the goal, scope, and non-goals.
2. Ensure tasks are ordered by dependency.
3. Ensure each task has acceptance criteria.
4. Ensure each task has verification steps.
5. Add risks, rollback notes, and open questions where useful.
6. Keep tasks small enough to build independently.
7. Change the active plan status from `draft` to `submitted`.
8. Update `.opencode/plans/active.md` so its status also says `submitted`.

Do not mark the plan as approved.
Do not start building.

End by summarizing the plan location and asking the user to run `/approve-plan` when ready.
