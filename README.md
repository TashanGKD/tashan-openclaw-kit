# Tashan OpenClaw Kit

一个面向他山团队的 OpenClaw 公共 starter kit：把核心配置、短系统规则、读写技能、记忆技能、默认工具栈和 Docker 一键部署脚本整理到同一个仓库里。

这个仓库的目标不是替代 OpenClaw 官方仓库，而是提供一套“能直接跑、能直接改、能继续演化”的团队起点。

## 仓库内有什么

- 一份可直接落到 `~/.openclaw/openclaw.json` 的默认配置模板
- 一份很短的核心 system prompt 补充规则
- 一份“读写工作流” skill
- 一份“记忆读写” skill
- 一份默认工具路由说明
- 一套 Docker 一键启动脚本
- 一份后续增强路线说明

## 默认配置了哪些能力

- 文件读写：`read`、`write`、`edit`、`apply_patch`
- 运行与验证：`exec`、`process`
- 记忆：`memory_search`、`memory_get`、自动 memory flush
- 网页：`web_search`、`web_fetch`
- 浏览器：`browser`
- Firecrawl：启用插件，支持 `firecrawl_search`、`firecrawl_scrape`，并给 `web_fetch` 提供增强抓取后备

## 设计原则

- 核心 prompt 保持短，只放稳定规则
- 详细 best practice 放进 skill，而不是塞进 system prompt
- 默认配置优先“稳定可部署”，不默认开启更重的 sandbox 和外部记忆后端
- 需要密钥的能力全部走 `.env`
- Docker 作为主推荐部署路径，降低机器环境差异

## 一键部署

### 方式 A：Docker（推荐）

要求：

- 安装 Docker Desktop 或 Docker Engine + Compose v2

步骤：

```bash
git clone https://github.com/Boyuan-Zheng/tashan-openclaw-kit.git
cd tashan-openclaw-kit
./scripts/bootstrap-docker.sh
```

脚本会自动做这些事：

- 创建仓库内的本地运行态目录 `.local/openclaw`
- 如果 `.env` 不存在，则从 `.env.example` 生成
- 自动生成 `OPENCLAW_GATEWAY_TOKEN`
- 把模板配置和模板 workspace 同步到运行态目录
- 拉取官方 `ghcr.io/openclaw/openclaw:latest` 镜像
- 启动 OpenClaw Gateway

第一次执行后，请至少补一组模型 provider key 到 `.env`，然后重启一次：

```bash
docker compose up -d openclaw-gateway
```

启动后访问：

- `http://127.0.0.1:18789/`

常用命令：

```bash
make logs
make dashboard
make health
make down
make check
```

### 方式 B：本机 OpenClaw（可选）

如果你已经安装了 OpenClaw 或 OpenClaw.app，可以把模板同步到本机默认目录：

```bash
./scripts/bootstrap-local.sh
```

它会把模板同步到：

- `~/.openclaw/openclaw.json`
- `~/.openclaw/workspace/`
- `~/.openclaw/.env`

默认不会覆盖你已经存在的同名文件。

## 需要填写的环境变量

至少填一种模型提供方密钥：

- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `GEMINI_API_KEY`

按需填写的增强能力：

- `BRAVE_API_KEY`
- `PERPLEXITY_API_KEY`
- `FIRECRAWL_API_KEY`
- `BROWSERBASE_API_KEY`

## 仓库结构

```text
.
├── config/
│   └── openclaw.json
├── docs/
│   └── tooling-notes.md
├── scripts/
│   ├── bootstrap-docker.sh
│   ├── bootstrap-local.sh
│   ├── check.sh
│   └── prepare-state.sh
├── workspace/
│   ├── AGENTS.md
│   ├── TOOLS.md
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

## 推荐的使用方式

- 把 `AGENTS.md` 保持短，只写稳定规则
- 把长流程写在 `workspace/skills/`
- 把长期事实写进 `MEMORY.md`
- 把当天工作上下文写进 `memory/YYYY-MM-DD.md`
- 把更多团队化定制放在 `workspace/TOOLS.md`、额外 skill 或插件里

## 后续建议

如果要继续增强，优先顺序建议是：

1. 开启更严格的 sandbox
2. 切换到 `memory-lancedb` 或 QMD
3. 接 Browserbase / Browserless
4. 接入 Feishu / WeCom / Telegram 等 channel
5. 加上 tracing 与观测

更详细的取舍见 [docs/tooling-notes.md](docs/tooling-notes.md)。

## 参考

- [OpenClaw Setup](https://docs.openclaw.ai/start/setup)
- [OpenClaw Docker](https://docs.openclaw.ai/install/docker)
- [OpenClaw System Prompt](https://docs.openclaw.ai/concepts/system-prompt)
- [OpenClaw Memory](https://docs.openclaw.ai/concepts/memory)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [OpenClaw Web Tools](https://docs.openclaw.ai/tools/web)
- [OpenClaw Browser](https://docs.openclaw.ai/tools/browser)
- [OpenClaw Firecrawl](https://docs.openclaw.ai/tools/firecrawl)
