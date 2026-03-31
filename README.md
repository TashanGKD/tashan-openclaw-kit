# Tashan OpenClaw Kit

> 一个面向他山团队的 OpenClaw 公共 starter kit，内含默认配置、短系统规则、读写与记忆技能，以及一键部署脚本。

这个仓库的目标不是替代 OpenClaw 官方仓库，而是提供一套“能直接跑、能直接改、能继续演化”的团队起点。

## If Another OpenClaw Opens This Repo

如果另一个 OpenClaw / agent 直接看到这个文件夹，推荐先按这个顺序读：

1. `AGENTS.md`
2. `README.md`
3. `docs/agent-onboarding.md`
4. `config/openclaw.json`
5. `workspace/AGENTS.md`、`workspace/TOOLS.md`、`workspace/MEMORY.md`
6. `workspace/skills/*/SKILL.md`

核心原则是：

- 必须让主智能体和子智能体都共享的规则，放在 `workspace/AGENTS.md` 和 `workspace/TOOLS.md`
- 详细工作流放在 `workspace/skills/`
- 运行开关和工具可见性放在 `config/openclaw.json`

## Quick Start

### Prerequisites

- Docker Desktop 或 Docker Engine + Compose v2
- 至少一组模型提供方密钥：`OPENAI_API_KEY`、`ANTHROPIC_API_KEY`、`GEMINI_API_KEY`

### Docker Deployment

```bash
git clone https://github.com/TashanGKD/tashan-openclaw-kit.git
cd tashan-openclaw-kit
./scripts/bootstrap-docker.sh
```

脚本会自动完成：

- 创建本地运行态目录 `.local/openclaw`
- 创建 `.env` 并生成 `OPENCLAW_GATEWAY_TOKEN`
- 同步默认配置与默认 workspace
- 拉取官方 `ghcr.io/openclaw/openclaw:latest` 镜像
- 启动 OpenClaw Gateway

第一次执行后，请补一组模型 provider key 到 `.env`，然后重启：

```bash
docker compose up -d openclaw-gateway
```

启动后访问：

- `http://127.0.0.1:18789/`

### Local Development

如果你已经安装了 OpenClaw 或 OpenClaw.app，可以把模板同步到本机默认目录：

```bash
./scripts/bootstrap-local.sh
```

它会同步到：

- `~/.openclaw/openclaw.json`
- `~/.openclaw/workspace/`
- `~/.openclaw/.env`

默认不会覆盖你已经存在的同名文件。

如果模板已经更新，想把模板里的新版配置和 workspace 覆盖同步到本机：

```bash
./scripts/bootstrap-local.sh --force
```

默认仍然不会覆盖你已有的 `.env`；只有在你明确需要时，才用：

```bash
./scripts/bootstrap-local.sh --force-env
```

## Common Commands

| Command | Purpose |
|---|---|
| `./scripts/bootstrap-docker.sh` | 初始化运行态并启动 Docker 版 OpenClaw |
| `./scripts/bootstrap-local.sh` | 把模板同步到本机 `~/.openclaw/` |
| `./scripts/bootstrap-local.sh --force` | 用模板刷新本机 `openclaw.json` 与 `workspace/` |
| `make logs` | 查看 Gateway 日志 |
| `make dashboard` | 生成 dashboard token 访问入口 |
| `make health` | 运行 OpenClaw health 检查 |
| `make down` | 停止容器 |
| `make check` | 校验仓库结构与运行态准备情况 |
| `./scripts/check.sh --repo-only` | 只校验仓库模板本身，不要求本地运行态已存在 |

## Directory Structure

```text
.
├── AGENTS.md
├── config/
│   └── openclaw.json
├── docs/
│   ├── agent-onboarding.md
│   └── tooling-notes.md
├── scripts/
│   ├── bootstrap-docker.sh
│   ├── bootstrap-local.sh
│   ├── check.sh
│   └── prepare-state.sh
├── workspace/
│   ├── AGENTS.md
│   ├── TOOLS.md
│   ├── TOOLS-CONFIG.md
│   ├── MEMORY.md
│   ├── memory/
│   └── skills/
│       ├── memory-read-write/
│       │   └── SKILL.md
│       └── read-write-workflow/
│           └── SKILL.md
├── .env.example
├── docker-compose.yml
├── Makefile
└── LICENSE
```

## Key Documents

| Document | Path | Purpose |
|---|---|---|
| README | `README.md` | 仓库入口说明与部署方法 |
| Repo agent entry | `AGENTS.md` | 给其他 OpenClaw / agent 的仓库入口说明 |
| Agent onboarding | `docs/agent-onboarding.md` | 说明先看什么、哪些规范必须共享、如何同步 |
| Gateway config | `config/openclaw.json` | OpenClaw 默认配置模板 |
| Core rules | `workspace/AGENTS.md` | 很短的核心 system prompt 补充规则 |
| Tool routing | `workspace/TOOLS.md` | 工具选型与调用顺序说明 |
| Tool/prompt contract | `workspace/TOOLS-CONFIG.md` | 主子智能体共享规范与配置边界说明 |
| Long-term memory seed | `workspace/MEMORY.md` | 长期记忆模板与写入边界 |
| Read/write skill | `workspace/skills/read-write-workflow/SKILL.md` | 文件读写工作流规范 |
| Memory skill | `workspace/skills/memory-read-write/SKILL.md` | 记忆读写工作流规范 |
| Tooling notes | `docs/tooling-notes.md` | 设计取舍、增强路线和默认工具说明 |

## Environment Variables

| Variable | Purpose | Required |
|---|---|---|
| `OPENCLAW_IMAGE` | OpenClaw Docker 镜像，默认 `ghcr.io/openclaw/openclaw:latest` | No |
| `OPENCLAW_GATEWAY_TOKEN` | Gateway 鉴权 token，由脚本自动生成 | Yes |
| `OPENCLAW_GATEWAY_PORT` | Gateway 暴露端口，默认 `18789` | No |
| `OPENCLAW_BRIDGE_PORT` | Bridge 端口，默认 `18790` | No |
| `OPENCLAW_GATEWAY_BIND` | Gateway bind 模式，默认 `loopback` | No |
| `OPENCLAW_TZ` | 时区，默认 `Asia/Shanghai` | No |
| `OPENAI_API_KEY` | OpenAI 模型 provider key | One of provider keys required |
| `ANTHROPIC_API_KEY` | Anthropic 模型 provider key | One of provider keys required |
| `GEMINI_API_KEY` | Gemini 模型 provider key | One of provider keys required |
| `BRAVE_API_KEY` | Brave Search API key | No |
| `PERPLEXITY_API_KEY` | Perplexity Search API key | No |
| `FIRECRAWL_API_KEY` | Firecrawl 搜索与抓取 key | No |
| `BROWSERBASE_API_KEY` | Browserbase 远程浏览器 key | No |

## What Is Included

- 一份可直接落到 `~/.openclaw/openclaw.json` 的默认配置模板
- 一份给其他 OpenClaw / agent 的仓库入口说明
- 一份很短的核心 system prompt 补充规则
- 一份“读写工作流” skill
- 一份“记忆读写” skill
- 一份默认工具路由说明
- 一份主子智能体共享规范说明
- 一套 Docker 一键启动脚本
- 一份后续增强路线说明

## Default Capabilities

- 文件读写：`read`、`write`、`edit`、`apply_patch`
- 运行与验证：`exec`、`process`
- 记忆：`memory_search`、`memory_get`、自动 memory flush
- 网页：`web_search`、`web_fetch`
- 浏览器：`browser`
- Firecrawl：启用插件，支持 `firecrawl_search`、`firecrawl_scrape`

## Deployment

当前推荐部署方式：

- 本地或服务器上通过 Docker 运行 Gateway
- 把更多团队定制继续沉淀到 `workspace/skills/`、`workspace/TOOLS.md` 与插件层

如果后续要增强，建议顺序：

1. 开启更严格的 sandbox
2. 切换到 `memory-lancedb` 或 QMD
3. 接 Browserbase / Browserless
4. 接入 Feishu / WeCom / Telegram 等 channel
5. 加上 tracing 与观测

更详细的取舍见 [docs/tooling-notes.md](docs/tooling-notes.md)。

## References

- [OpenClaw Setup](https://docs.openclaw.ai/start/setup)
- [OpenClaw Docker](https://docs.openclaw.ai/install/docker)
- [OpenClaw System Prompt](https://docs.openclaw.ai/concepts/system-prompt)
- [OpenClaw Memory](https://docs.openclaw.ai/concepts/memory)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [OpenClaw Web Tools](https://docs.openclaw.ai/tools/web)
- [OpenClaw Browser](https://docs.openclaw.ai/tools/browser)
- [OpenClaw Firecrawl](https://docs.openclaw.ai/tools/firecrawl)
