---
description: Execute the agreed plan from plan.md one step at a time with verification
argument-hint: "[notes or refinements]"
---
Execution mode. Use `plan.md` as the source of truth.

Extra user input: $@

Rules:
1. Read `plan.md` and identify the next unfinished step.
2. Implement **only that single step**.
3. Run verification for that step and report evidence/results.
4. Update `plan.md` to mark the completed step (e.g., `[x]`) and preserve remaining steps.
5. Summarize what changed (files + reason), then pause.
6. Ask whether to refine this step or continue to the next one.
7. If `plan.md` is missing/unclear, ask for clarification and do not guess.
