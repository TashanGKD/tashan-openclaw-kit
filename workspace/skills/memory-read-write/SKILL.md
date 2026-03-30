---
name: memory-read-write
description: Use when the task involves storing, recalling, or organizing OpenClaw memory. Covers when to use memory_search vs memory_get, what belongs in MEMORY.md vs memory/YYYY-MM-DD.md, and how to write concise durable memory entries without polluting the context window.
---

# Memory Read Write

Use this skill whenever the task asks to remember something, recover prior context, or organize workspace memory.

## Goal

Keep memory useful, searchable, and compact.

## Read path

1. Start with `memory_search` when you do not know the exact file or wording.
2. Use `memory_get` only after you know the target file or section to inspect.
3. Read the minimum memory needed for the current task.

## Write path

Choose the memory layer before writing.

### Write to `MEMORY.md` when the information is durable

Examples:

- long-term user preferences
- stable operating rules
- durable project decisions
- definitions, mappings, or conventions likely to matter again

### Write to `memory/YYYY-MM-DD.md` when the information is session-scoped

Examples:

- today's progress
- experiment notes
- temporary blockers
- short-lived context needed later the same day

## Writing rules

- Keep entries concise and factual.
- Separate observed facts from inference.
- Do not duplicate large chunks across memory layers.
- If the user says "remember this," write it down instead of saying you will remember it implicitly.

## Good memory hygiene

- Curate `MEMORY.md`; do not turn it into a diary.
- Keep dated notes append-only unless there is a clear cleanup task.
- If a daily note becomes a stable rule, promote the distilled rule into `MEMORY.md`.

## Suggested entry style

For `MEMORY.md`:

- short bullet
- one stable idea per bullet
- prefer reusable wording over narrative wording

For `memory/YYYY-MM-DD.md`:

- timestamp or short heading if useful
- brief note about what changed, why it matters, and any next step

## Avoid

- Storing every conversational detail
- Mixing temporary notes into `MEMORY.md`
- Searching the whole workspace with `read` before trying `memory_search`
- Writing speculative claims as durable facts
