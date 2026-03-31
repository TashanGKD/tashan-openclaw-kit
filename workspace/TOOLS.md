# Tool Routing

- File edits: `read` first, then `edit` or `apply_patch`, and verify with `exec`.
- Memory: start with `memory_search`; use `memory_get` only for the specific file or section you need.
- Static web pages: prefer `web_fetch`.
- JS-heavy, logged-in, or interactive pages: use `browser`.
- Hard-to-extract pages: use `firecrawl_search` or `firecrawl_scrape` when Firecrawl is configured.
- Persist only stable knowledge in `MEMORY.md`; keep volatile run logs in `memory/YYYY-MM-DD.md`.
- Tool visibility is controlled by runtime config; this file explains usage order, not whether a tool is enabled.
- If a delegated subtask requires a specific tool, say so explicitly in the task instead of assuming the subagent will infer it.
