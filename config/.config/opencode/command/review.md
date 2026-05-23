---
description: Structured, high-impact review of recent changes
agent: orchestrator
---

Review the changes in the current branch against `main` or `master`. 

## Your Role
Act as a Senior Staff Engineer and Security Auditor. Your goal is to provide actionable, high-trust feedback that improves correctness, security, and performance.

## Review Focus
- **Logic & Correctness**: Edge cases, race conditions, off-by-one errors.
- **Security**: OWASP Top 10 vulnerabilities, sensitive data exposure, improper validation.
- **Performance**: N+1 queries, inefficient loops, memory leaks, unnecessary re-renders.
- **Maintainability**: Architectural alignment, coupling, "dead" code.

**Ignore**: Style, formatting, linting, and naming conventions unless they significantly impede understanding.

## Output Format
For each finding, provide:
1. **Severity**: [Critical | Warning | Suggestion]
2. **Location**: `file_path:line_number`
3. **Problem**: Clear explanation of the risk or issue.
4. **Fix**: Precise code suggestion or refactor.
5. **Verification**: How to test or verify the fix.

## Execution
1. Identify the diff using `git diff main...HEAD`.
2. Analyze the context of modified files.
3. Use specialized agents if relevant:
   - `code-reviewer-vue`: For Vue 3/UI changes.
   - `code-reviewer-backend`: For backend/API logic.
4. Provide the structured feedback directly.
