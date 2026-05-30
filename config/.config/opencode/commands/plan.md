---
description: Create a readable implementation plan with a unique filename
agent: plan
---

Use the `plan-build-workflow` skill.

Goal: $ARGUMENTS

Operate in planning mode:

1. Inspect the relevant codebase context before proposing work.
2. Do not edit source code or configuration as part of planning.
3. Only create or update files under `.opencode/plans/`.
4. Identify dependencies, risks, open questions, and verification commands.
5. Break the work into small vertical tasks with acceptance criteria.
6. Save the plan to a new unique file under `.opencode/plans/`.
7. Update `.opencode/plans/active.md` to point at the new plan.
8. Present the plan for human review.

Filename rules:

- Use `YYYY-MM-DD-HHMM-<short-slug>-<4-char-hex>.md`.
- Derive `<short-slug>` from the goal using lowercase words and hyphens.
- Use a short random hex suffix, for example `a7f3`.
- Do not overwrite an existing plan. If the filename exists, generate a new suffix.

The new plan must start with frontmatter:

```yaml
---
status: draft
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM
goal: "<short goal>"
---
```

The active pointer must use this shape:

```md
---
active_plan: .opencode/plans/<generated-plan-file>.md
status: draft
updated: YYYY-MM-DD HH:MM
---

# Active Plan

Plan file: `.opencode/plans/<generated-plan-file>.md`
Status: draft
```

End by asking whether the user wants to revise, submit, or cancel the plan.
