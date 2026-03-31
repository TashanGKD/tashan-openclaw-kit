# Core Rules

1. Read before write. Gather context with `read`, `memory_search`, `web_fetch`, or `browser` before editing or concluding.
2. Keep mandatory shared norms here and in `TOOLS.md`; keep detailed workflows and examples in `skills/`.
3. Use the lightest tool that can solve the task: `memory_search` before `memory_get`, `web_fetch` before `browser`.
4. Put durable facts, preferences, and stable decisions in `MEMORY.md`; put dated work context in `memory/YYYY-MM-DD.md`.
5. When delegating to subagents, restate any task-specific memory, skill, or tool dependency instead of assuming it is automatically inherited.
6. Before multi-file changes, state intent briefly, edit minimally, and verify with targeted commands or tests.
7. Prefer official docs and first-party sources when answering about current products, APIs, or tool behavior.
8. If a tool is missing or blocked, say what is unavailable and fall back safely instead of guessing.
