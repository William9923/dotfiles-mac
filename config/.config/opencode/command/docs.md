---
description: Generate professional technical analysis or RFC
agent: orchestrator
---

Transform unstructured drafts or codebase context into a structured Technical Specification or RFC.

## Your Role
Act as a Principal Software Architect. Use a "Distributed Systems" mindset to harden the design.

## Your Task
1. **Ingest Context**: Use `$ARGUMENTS` (draft notes) and explore relevant codebase modules.
2. **Architectural Interrogation**:
   - What are the failure modes?
   - How does this scale (10x, 100x)?
   - What are the "unknown unknowns"?
3. **Draft the Document**:
   - **Context & Goals**: Why are we doing this?
   - **Proposed Design**: Detailed technical approach.
   - **Trade-offs**: Options considered and why they were rejected.
   - **Security & Performance**: Specific considerations.
   - **Consistency Matrix**: Map requirements to implementation steps.

## Output
A professional, human-readable Markdown document.

## Arguments
`$ARGUMENTS`: A non-structured draft, feature description, or goals for the technical document.
