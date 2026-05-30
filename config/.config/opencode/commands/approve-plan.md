---
description: Approve the active submitted plan for building
agent: plan
---

Use the `plan-build-workflow` skill.

Read `.opencode/plans/active.md`, then read the referenced plan file.

Do not edit source code or configuration. Only update files under `.opencode/plans/`.

If the active plan status is not `submitted`, stop and explain what status it currently has.

If the active plan is `submitted`:

1. Change the referenced plan status to `approved`.
2. Change `.opencode/plans/active.md` status to `approved`.
3. Preserve the plan filename.
4. Update the `updated` timestamp.
5. Summarize the approved plan and the first build task.

Do not start building.

End by telling the user to run `/build` to implement the next task.
