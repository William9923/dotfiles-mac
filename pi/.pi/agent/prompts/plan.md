---
description: Build an implementation plan with small, verifiable steps (no coding yet)
argument-hint: "[goal or constraints]"
---
Planning mode only. Do **not** implement code yet.

Goal/context from user: $@

Workflow:
1. If key context is missing, ask concise clarifying questions first.
2. Propose a straightforward step-by-step plan with small, testable increments.
3. For each step, include:
   - Objective
   - Files/areas to change
   - Verification method (command/check)
   - Expected result
4. Keep scope practical; avoid overengineering.
5. Ask for feedback and revise until the plan is approved.
6. After approval, write the final plan to `plan.md` in the project root (overwrite if needed), then stop and wait for `/proceed`.

Output format:
- Numbered steps
- Each step should be concrete and verifiable
