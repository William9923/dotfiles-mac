---
description: Analyze a failing test case to find the root cause
agent: orchestrator
---

Analyze why a specific test case is failing and determine the root cause.

## Your Task
1. **Identify Failure**: Parse the test output/stack trace provided in `$ARGUMENTS`.
2. **Isolate State**: Identify the exact line of failure and the expected vs. actual values.
3. **Determine Root Cause**:
   - Is it a **deterministic bug** in the implementation?
   - Is it a **flaky test** (timing, shared state, randomness)?
   - **CRITICAL**: Compare if the **test itself is incorrect** (outdated expectations) vs. if the **implementation is faulty**. 
4. **Context Search**: Use `grep` and `read` to examine the test file and the code under test.

## Output
- **Diagnosis**: Clear statement of what is wrong and why.
- **Evidence**: Line numbers and variable states that prove the diagnosis.
- **Verdict**: Specify if we should fix the test, the code, or both.

## Arguments
`$ARGUMENTS`: The failing test command, output, or specific test file/name.
