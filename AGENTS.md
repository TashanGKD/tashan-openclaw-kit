# AGENTS.md

本仓库是一个面向他山团队的 OpenClaw starter kit。它的职责是提供一套可同步、可部署、可继续演化的默认基线，而不是替代 OpenClaw 官方源码仓库。

如果你是另一个 OpenClaw 或 agent，进入这个目录后请按下面顺序理解上下文：

1. 先读 `README.md`
2. 再读 `docs/agent-onboarding.md`
3. 再看 `config/openclaw.json`
4. 再看 `workspace/AGENTS.md` 和 `workspace/TOOLS.md`
5. 需要长流程时，再读 `workspace/skills/*/SKILL.md`

工作原则：

- 优先维护“清晰、可同步、可验证”的默认模板，不要一上来塞很多重依赖或冷门 provider。
- 任何会改变行为的改动，尽量同时更新 `README.md`、`docs/agent-onboarding.md`、`config/openclaw.json`、`workspace/` 下对应文件和相关脚本。
- 主智能体和子智能体都必须共享的基本规范，放在 `workspace/AGENTS.md` 和 `workspace/TOOLS.md`；不要只写在长 skill 里。
- 详细工作流、案例和反例，放到 `workspace/skills/` 或 `docs/`，不要把核心规则写得过长。
- 不要把真实密钥写进仓库；除非用户明确要求，否则只更新 `.env.example`。
- 改完后至少运行 `./scripts/check.sh --repo-only`；如果动了本地同步逻辑，再用临时目录验证 `./scripts/bootstrap-local.sh`。
