# Agent Onboarding

这份文档是给“刚进入这个仓库的 OpenClaw / agent”看的。目标是减少猜测，让后续维护者马上知道：

- 这个仓库是什么
- 应该先看哪些文件
- 哪些规则必须被主智能体和子智能体共享
- 模板应该怎样同步到真正的 `~/.openclaw`

## 1. 仓库定位

这个仓库是一个“模板仓库”，不是业务代码仓库。它提供：

- OpenClaw 的默认 `openclaw.json`
- 一套可同步到 `~/.openclaw/workspace` 的 bootstrap 文件
- 两个通用技能：读写工作流、记忆读写
- Docker / 本地同步脚本

你在这里的目标，通常不是“加很多功能”，而是让默认行为更清楚、更稳、更适合团队复用。

## 2. 推荐阅读顺序

1. `README.md`
2. `config/openclaw.json`
3. `workspace/AGENTS.md`
4. `workspace/TOOLS.md`
5. `workspace/MEMORY.md`
6. `workspace/TOOLS-CONFIG.md`
7. `workspace/skills/*/SKILL.md`

## 3. 哪些文件控制什么

### 运行配置

- `config/openclaw.json`
  - 控制 gateway、模型、memory search、compaction、browser、plugin slot 和 tool 默认行为

### 共享 bootstrap

- `workspace/AGENTS.md`
  - 放必须稳定共享的短规则
- `workspace/TOOLS.md`
  - 放工具选择顺序和常见路由
- `workspace/MEMORY.md`
  - 放长期稳定事实和团队约定
- `workspace/memory/YYYY-MM-DD.md`
  - 放日期化运行记录和短期上下文

### 长流程

- `workspace/skills/*/SKILL.md`
  - 放较长的工作流、异常处理、写入边界、案例

### 仓库文档

- `docs/agent-onboarding.md`
  - 给维护者和其他 agent 的说明
- `docs/tooling-notes.md`
  - 解释为什么默认这样配，以及后续增强路线

## 4. 主智能体和子智能体的共享规范

不要假设子智能体会自动继承主智能体的所有长 prompt。

维护这个模板时，请按下面的假设设计：

- 必须共享的基本规范，放在 `workspace/AGENTS.md` 和 `workspace/TOOLS.md`
- 长工作流放在 `workspace/skills/`
- 长期事实放在 `workspace/MEMORY.md`
- 如果某个子任务强依赖某个 skill、记忆条目或特殊工具，在派发子任务时显式再说一遍

这意味着：

- “先读后写”“先 `memory_search` 再 `memory_get`”这类规则，应该放在共享 bootstrap
- “如何写一次完整的多文件改动”“什么情况下该写入长期记忆”这类细节，应该放在 skill

## 5. 什么时候改 config，什么时候改 workspace

改 `config/openclaw.json`：

- 工具是否启用
- browser / plugin / memory backend 默认配置
- gateway、模型、timeout、sandbox、compaction 等运行参数

改 `workspace/AGENTS.md` / `workspace/TOOLS.md`：

- agent 必须遵守的短规则
- 工具选择顺序
- 主子智能体共享的最小共识

改 `workspace/skills/`：

- 长流程
- 边界案例
- 失败处理
- 特定类型任务的标准做法

## 6. 如何同步到真正的 OpenClaw 目录

同步到本机默认目录：

```bash
./scripts/bootstrap-local.sh
```

如果模板已经更新，想把模板里的新版本覆盖到本机 `openclaw.json` 和 `workspace/`：

```bash
./scripts/bootstrap-local.sh --force
```

如果你明确要重置本机 `.env` 模板：

```bash
./scripts/bootstrap-local.sh --force-env
```

## 7. 编辑后最少要做的验证

只校验仓库模板结构：

```bash
./scripts/check.sh --repo-only
```

校验仓库 + 本地 Docker 运行态：

```bash
./scripts/check.sh
```

如果你改了本地同步逻辑，建议再用临时目录验证一次：

```bash
OPENCLAW_LOCAL_HOME="$(mktemp -d)" ./scripts/bootstrap-local.sh --force
```

## 8. 默认维护原则

- 模板优先清晰和稳定，不优先追求“功能最多”
- 先保证首次部署体验，再考虑重型增强
- 共享规范优先短小明确
- 长说明放文档或 skill，不要把核心 bootstrap 写得太长
