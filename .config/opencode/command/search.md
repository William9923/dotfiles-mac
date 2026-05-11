---
description: Semantic and structural discovery of feature implementation
agent: orchestrator
---

Find all relevant implementation details for a given feature or concept.

## Your Role
Act as a Project Historian and Repository Architect. 

## Your Task
1. **Map Intent**: Translate the sentence/paragraph in `$ARGUMENTS` into technical search patterns.
2. **Recursive Exploration**:
   - Find entry points (API routes, UI components).
   - Trace data flow down to the service and database layers.
   - Identify the "Source of Truth" for data state.
3. **Synthesize**:
   - List all files involved.
   - Explain the error-handling and logging strategy for this feature.
   - Identify core dependencies and shared utilities.

## Output
A structured "Code Map" or summary of how the feature is implemented across the repository.

## Arguments
`$ARGUMENTS`: A sentence or paragraph describing what you want to find.
