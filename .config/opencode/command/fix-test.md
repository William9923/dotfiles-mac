---
description: Fix a failing test case based on analysis
agent: orchestrator
---

Apply a fix to a failing test case or the underlying implementation.

## Your Task
1. **Pre-requisite**: Ensure `/analyze-test` has been run or the root cause is understood.
2. **Apply Fix**:
   - Modify the code or test file with the minimal necessary change.
   - Adhere to project conventions and existing patterns.
3. **Verify**:
   - Run the specific failing test to confirm it now passes.
   - Run related tests to ensure no regressions.
4. **Harden**:
   - If it was an implementation bug, suggest or add a "negative test" case that would have caught this earlier.

## Arguments
`$ARGUMENTS`: (Optional) Specific instructions or context for the fix.
