---
name: read-write-workflow
description: Use when a task needs disciplined file reading and writing inside an OpenClaw workspace, including code edits, documentation edits, config changes, or structured patch workflows. Covers read-before-write, edit scoping, verification, and when to persist outcomes to memory.
---

# Read Write Workflow

Use this skill whenever the task changes files, creates files, rewrites docs, or updates configuration.

## Goal

Keep workspace changes accurate, minimal, and verifiable.

## Default workflow

1. Read the smallest useful context first.
2. State the intended change briefly before editing.
3. Edit the minimum file set that can solve the task.
4. Verify the change with the narrowest useful command or test.
5. Persist durable outcomes to memory only if they should outlive the session.

## Tool routing

- Use `read` to inspect files before changing them.
- Use `edit` or `apply_patch` for targeted updates.
- Use `write` for net-new files or full rewrites.
- Use `exec` or `process` for validation, formatting, and tests.
- Use `web_fetch` or `browser` only when the source of truth is external to the workspace.

## Read-before-write rules

- Never overwrite a file you have not read.
- If multiple files look relevant, read only the directly affected files first.
- If a change may affect surrounding behavior, inspect the nearest config, tests, or call sites before editing.

## Edit discipline

- Prefer minimal diffs over broad rewrites.
- Keep naming, formatting, and structure aligned with the local project.
- If the task spans more than three files or mixes behavior and documentation, keep a short checklist while working.

## Verification

- For code: run the smallest test or command that can prove the change.
- For docs: verify links, examples, filenames, and commands.
- For config: validate syntax and any referenced paths or env names.

## Memory handoff

Write to memory only when at least one of these is true:

- the user said "remember this"
- the result establishes a durable convention
- the change captures a long-lived preference or decision

Use:

- `MEMORY.md` for durable rules and preferences
- `memory/YYYY-MM-DD.md` for dated work logs, temporary notes, and session progress

## Avoid

- Editing first and reading later
- Writing broad summaries into `MEMORY.md`
- Claiming verification without actually running a check
- Using the browser when `web_fetch` or `read` is enough
