# Tooling Notes

这份说明用于解释这个 starter kit 为什么默认这样配，以及后续还建议怎么增强。

## 当前默认启用或纳入模板的能力

### 1. 文件读写

- `read`
- `write`
- `edit`
- `apply_patch`
- `exec`
- `process`

原因：

- 这是大多数 OpenClaw 工作流的基础层
- 对代码、文档、配置修改最常见
- 和“先读后写”的技能配合最稳定

### 2. 记忆

- `memory_search`
- `memory_get`
- 自动 `memoryFlush`
- `MEMORY.md`
- `memory/YYYY-MM-DD.md`

当前默认使用：

- `plugins.slots.memory = "memory-core"`

原因：

- 这是当前最稳妥、最轻量、最不容易把部署搞复杂的起点
- 对公开 starter kit 来说，比直接上更重的长期记忆后端更容易一键跑通

### 3. 网页能力

- `web_search`
- `web_fetch`
- Firecrawl 插件

原因：

- `web_search` 负责发现来源
- `web_fetch` 负责读静态网页
- Firecrawl 负责 JS 重站、反爬站、复杂正文抽取

这里故意没有把 `web_search.provider` 写死。

原因：

- OpenClaw 当前支持自动探测多种 provider
- 不同团队成员会持有不同的 key
- 不写死 provider，更适合公共仓库

### 4. 浏览器

- `browser.enabled = true`

原因：

- 登录态页面、复杂交互页面、控制台操作都需要浏览器而不是 `web_fetch`
- 这是 OpenClaw 和“纯 HTTP 抓取型 agent”之间的关键差别之一

当前默认只开本地 profile，不默认绑 Browserbase。

原因：

- 这样最容易跑通
- 若团队后续迁到服务器，再加 remote CDP 更合适

## 为什么核心 prompt 只保留短规则

OpenClaw 当前会把 `AGENTS.md`、`TOOLS.md`、`MEMORY.md` 之类 bootstrap 文件注入每轮上下文。它们越长，token 成本越高，也越容易触发 compaction。

所以这里采用：

- `AGENTS.md` 只放稳定高层规则
- 长流程放进 `workspace/skills/`
- 更长的解释放进仓库文档

## 为什么默认不直接上这些增强项

### 1. Docker sandbox

理由：

- 它很好，但额外依赖 Docker socket、镜像能力和更多安全配置
- 做成公开 starter kit 时，默认开启会明显增加第一次部署失败率

### 2. `memory-lancedb`

理由：

- 长期记忆更强，但也更适合在团队已经稳定使用 OpenClaw 之后再切换
- starter kit 更适合先保证记忆语义和写入纪律跑通

### 3. QMD

理由：

- 本地检索很强，但又引入额外二进制与首次模型下载成本
- 更适合后续进阶版

### 4. Browserbase / Browserless

理由：

- 远程浏览器很适合服务器部署
- 但对本地 starter kit 来说不是必需前置条件

## 推荐的下一步增强顺序

1. 打开更严格的 sandbox
2. 为团队统一一套默认模型与搜索 provider
3. 切换到 `memory-lancedb` 或 QMD
4. 接入 Browserbase
5. 接入 Feishu / WeCom / Telegram 等 channel
6. 加入 tracing、日志、告警

## 官方文档依据

- Setup: <https://docs.openclaw.ai/start/setup>
- Docker: <https://docs.openclaw.ai/install/docker>
- System Prompt: <https://docs.openclaw.ai/concepts/system-prompt>
- Memory: <https://docs.openclaw.ai/concepts/memory>
- Skills: <https://docs.openclaw.ai/tools/skills>
- Web Tools: <https://docs.openclaw.ai/tools/web>
- Firecrawl: <https://docs.openclaw.ai/tools/firecrawl>
- Browser: <https://docs.openclaw.ai/tools/browser>
- Plugins: <https://docs.openclaw.ai/tools/plugin>
