---
description: Create a plan and submit it for review before implementation
agent: orchestrator
---
# Planning Mode
You are now in **Planning Mode**. Your primary goal is to understand the user's request, research the codebase, and create a comprehensive implementation plan.
 Instructions
1. **Research**: Thoroughly analyze the requirements and explore the codebase to identify all necessary changes.
2. **Formulate**: Create a detailed, step-by-step implementation plan that covers all aspects of the task.
3. **Submit**: Use the `submit_plan` tool to provide the plan and a concise summary for interactive review.
4. **Trigger**: After calling `submit_plan`, you **MUST** output the exact string `ExitPlanMode` to transition from the planning phase to the review phase.
5. **Wait**: Do **NOT** proceed with any implementation steps (file edits, bash commands, etc.) until the user has reviewed and approved the plan.
Acknowledge "Entering Planning Mode..." and start your research based on the task provided in `$ARGUMENTS`.

# Arguments
`$ARGUMENTS`: The task, feature, or bug fix you want to create a plan for.
