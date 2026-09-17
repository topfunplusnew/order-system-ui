---
name: wechat-requirement-delivery
description: 微信聊天记录 + 接口文档/接口地址驱动的需求交付全流程。当用户发来微信聊天记录（文本/截图/导出文件），并附带接口文档、接口地址或其它必要信息，要求"理解需求并自己完成任务"、"开一个开发分支我审查"、"审查通过后合并到 order-stage / order-pre / order-test" 时使用。覆盖收料归档、需求解析与歧义对齐、接口逐字段核对、复用检索、Vue2 开发自检、切开发分支待审、评审通过后合并三环境、确认后推送。
whenToUse: 用户给出聊天记录（需求来源）+ 接口材料，要求端到端交付，并在评审通过后合并到 stage / pre / test 三个环境分支。
---

# 微信记录 → 需求交付 → 分支评审 → 三环境合并

把「一段微信聊天记录 + 接口文档 + 接口地址 + 若干必要信息」端到端变成「一个可评审的开发分支」，
评审通过后再合并进 `order-stage` / `order-pre` / `order-test`。

**两个不可越过的闸门：**

1. **评审闸门**：开发分支交付后必须停下来等用户明确说"通过"，任何情况下不得自行合并。
2. **推送闸门**：合并完成后必须停下来展示待推送内容，用户确认后才 push 三个环境分支。

## 执行总览

```
阶段0 收料粗读（只读）
阶段1 切开发分支            ← 必须先切，再落盘、再写代码
阶段2 需求解析 + 落盘 requirements/
阶段3 接口逐字段核对
阶段4 复用检索 + 影响面盘点
阶段5 开发 + 自检 + 提交
阶段6 推送开发分支 + 交付汇报   ⛔ 评审闸门：停下等"通过"
阶段7 合并 order-stage / order-pre / order-test   ⛔ 推送闸门：停下等"确认"
阶段8 推送三环境
阶段9 收尾（更新验收状态、切回 order-test）
```

**为什么先切分支再干活**：分支前工作区必须干净，而本流程会在 `requirements/` 落盘需求文档。
先切分支，需求文档和代码就都落在开发分支上，不会被 `order-test` 工作区污染，也不用中途搬东西。

## TL;DR 命令序列

```bash
SKILL=.dsh/skills/wechat-requirement-delivery

# 1) 切开发分支（工作区须干净）
bash $SKILL/scripts/prep-branch.sh <english-kebab-slug> --push

# 2) 收料 / 落盘 requirements/ / 核对接口 / 开发 / 提交

# 3) 交付汇报后 ⛔ 停下等用户说"通过"

# 4) 预演合并（不写任何东西）
bash $SKILL/scripts/merge-envs.sh feat/YYYYMMDD-<slug> --dry-run

# 5) 真合并（只动本地，不 push）
bash $SKILL/scripts/merge-envs.sh feat/YYYYMMDD-<slug>

# 6) ⛔ 停下等用户确认推送
bash $SKILL/scripts/push-envs.sh --dry-run    # 先看
bash $SKILL/scripts/push-envs.sh              # 确认后推
```

---

## 铁律（无条件遵守）

1. **不臆测**。接口路径、字段名、枚举、必填、精度，一律以接口文档为准。文档里没有的字段，宁可标 `待后端` 并向用户要，绝不凭命名习惯编造。
2. **不跳闸门**。用户没说"通过"就是没通过；用户没说"推"就不推。含糊回复（"看着还行"）一律视为未通过，回问一句。
3. **不碰授权外分支**。只允许：切开发分支、合并到 `order-stage`/`order-pre`/`order-test`。`order-dev`、`front-*`、`release*` 等一律不动，除非用户当次明确点名。
4. **不 force push，不 reset --hard 已推送的提交**。历史只增不改。
5. **冲突就停**。合并冲突时中止并列出冲突文件，让用户决定。不猜、不用 `-X theirs`。
6. **工作区必须先干净**。切分支/合并前 `git status --porcelain` 必须为空（未跟踪的 `.dsh/` 除外，脚本已放行）。否则先问用户怎么处理未提交改动。
7. **项目编码铁律**（Vue2 + JS + JSDoc + lodash + mathjs + 文件顶部变更记录 + 禁止函数套函数）见 `references/project-rules.md`，写代码前必读。

---

## 阶段 0：收料与粗读（只读，不写文件）

**输入可能是**：微信聊天记录文本/截图/导出的 .txt、接口文档（APIfox 链接、粘贴的 Markdown/JSON、Swagger、`docs/**/*.openapi.json` 快照）、接口地址（域名/base URL）、以及其它必要信息。

1. **截图必须逐张 `read_image` 真正读一遍**，把需求原话转写成文字。不要跳读、不要只读第一张。
2. **对照最小信息清单点名**（清单见 `references/intake-checklist.md`）。
3. **缺料就索要，不要开工**。一次性把缺的东西列清楚，用 `ask_user_question` 批量提问，别一条一条挤牙膏。

### 阻塞性 vs 非阻塞性

| 类型 | 判定 | 处理 |
|---|---|---|
| 阻塞性 | 缺接口/缺字段到无法写代码；聊天记录与接口文档直接冲突；金额精度口径未定且影响计算；目标页面/入口定位不到；涉及删除或批量覆盖数据 | **必须停下问**，问清楚再继续 |
| 非阻塞 | 文案措辞、列宽、默认排序、空态提示、非核心样式 | **先按最合理方案推进**，在交付汇报里列进"我做的假设" |

## 阶段 1：切开发分支

分支基线默认 `order-test`（与当前已发布基线一致）。命名 `feat/YYYYMMDD-<english-kebab-slug>`，slug 用英文小写、能概括需求，例：`order-freight-date-column`。

```bash
bash .dsh/skills/wechat-requirement-delivery/scripts/prep-branch.sh <slug> --push
```

脚本会：校验工作区干净 → `git fetch --prune` → 从 `origin/order-test` 切 `feat/<日期>-<slug>` → `--push` 时推送并建立追踪。

- 推送开发分支是**允许的**（评审需要，且不触发三个环境）。
- 若此刻还不确定该建哪个分支（比如缺料等用户回话），才允许延后到阶段 5 之前；那时 `requirements/` 已有改动，需先提交或让用户决定。

## 阶段 2：需求解析与落盘

产出**需求条目清单**，写到 `requirements/YYYY-MM-DD-<主题>.md`（同日多批追加同一文件，格式参考 `requirements/_template.md` 与 `references/report-templates.md`）。

每条需求必须写清：编号 + 标题；需求原话摘录（标发言人/时间）；期望行为；接口来源（地址、接口 ID、文档链接）；用到字段的原样命名；精度；风险标记（`待后端` / `待联调` / `待确认是否需求`）。

规则：

- 一条一议，`1、2、3...` 编号，方便逐条落实与验收。
- **聊天记录里的语气不是需求**。区分「抱怨」（可以不动）与「明确要求改」（要做），拿不准的归入"待确认"。
- 聊天记录里相互矛盾的说法，取**最新时间**那条，并注明冲突与取舍理由。
- 涉及金额、合计、税额的条目，标注**保留几位小数**；用户没说就按阻塞性信息问。
- 原始材料归档到 `requirements/_raw/YYYY-MM-DD-<主题>.md`（截图放同名目录）。

## 阶段 3：接口核对（不做完不许写代码）

接口来源优先级：

1. **APIfox MCP 工具**（若本会话可用）——首选，实时最新。
2. 用户当次给的接口文档链接 / 粘贴的文档原文。
3. 仓库内快照：`docs/**/*.openapi.json`、`packages/order-system/src/api/订单系统.openapi.json`。
4. 现有代码封装：`packages/order-system/src/api/**`（只能佐证，不能作为字段权威来源）。

四者都拿不到目标接口 → **停下索要**，列出你需要哪几个接口的文档。

逐个接口核对，一条都不能错：完整路径、HTTP 方法、参数位置（query/body/path/header）、字段精确命名（**不转驼峰、不改大小写**）、required、默认值、长度/数值范围、正则、枚举全集、嵌套层级、响应体结构、错误码结构、Content-Type。

**核对结论写进需求清单**（接口路径 + 每个用到字段的原样命名），作为开发的唯一依据。

## 阶段 4：复用检索与影响面盘点

写代码前先查库内有没有现成的，**禁止重复造轮子**：

- API 封装 `packages/order-system/src/api/`；组件 `src/components/`、`packages/ui-components/`
- mixins `src/mixins/`、`packages/shared/mixins/`；工具/常量/枚举 `src/utils/`、`packages/shared/utils/`
- 同类页面参考 `src/views/` 下相近模块

用 `grep`/`glob` 检索，输出**改动文件清单**：新增哪些、修改哪些、每个文件为什么动。

## 阶段 5：开发与自检

按 `references/project-rules.md` 执行。最低要求：

- Vue2 + Options API + 纯 JavaScript（禁 TS / Vue3 / class-style）。
- 函数写 JSDoc，类型标注尽量详细（项目无 TS）。
- 优先 lodash；金额/合计一律 mathjs 高精度 + 指定小数位。
- 修改/新增文件顶部追加**变更记录注释**（最新在上，历史保留）。
- 保证响应式联动；禁止函数套函数（`return row => this.xxx(row)` 这类 wrap 一律抵制）。
- 单文件不超过 500 行，超了拆组件。
- 若需求属于**新能力/架构变更**，先按 `openspec/AGENTS.md` 走变更提案，再动代码。

自检（能跑就跑，跑不了说明原因）：

```bash
yarn lint      # 或 yarn workspace order-system lint
yarn build     # stage 构建，验证不炸
```

提交规范：`feat(<scope>): <描述>` / `fix(<scope>): <描述>`，一个需求条目一个提交，消息里能看出改了哪几条。需求文档与代码分开提交。

## 阶段 6：交付汇报 ⛔ 评审闸门

推送开发分支（若阶段 1 用了 `--push` 则此处只需在开发过程中持续 push），然后**停下来**，按 `references/report-templates.md` 的「交付汇报」模板输出，必须包含：

1. 分支名 + 基线 commit + 推送状态 + compare 链接
2. 需求条目逐条落实情况（`已实现` / `待后端` / `待联调` / `待确认`）
3. 改动文件清单（新增/修改，各一句话说明）
4. 接口核对结论（路径 + 字段来源）
5. 我做的假设（非阻塞项）
6. 未做/做不了的部分及原因
7. 建议的验证路径（点哪里、看什么、期望结果）
8. 已知风险

**到此为止**，明确告诉用户："请审查，回复通过后我才会合并到 stage/pre/test。" 不得自动进入阶段 7。

## 阶段 7：合并三环境 ⛔ 推送闸门

**前置**：用户当次明确表示通过（"通过"/"可以合并"/"没问题，合吧"）。拿不准就问一句，不要赌。

```bash
bash .dsh/skills/wechat-requirement-delivery/scripts/merge-envs.sh <feature-branch> --dry-run
bash .dsh/skills/wechat-requirement-delivery/scripts/merge-envs.sh <feature-branch>
```

顺序 `order-stage` → `order-pre` → `order-test`（与用户口径一致；需调整由用户当次说明）。脚本行为：

- **全量 pre-flight 后才动分支**：工作区干净 → `fetch` → 每个目标分支的本地未推送提交检查 → 用 `git merge-tree` 预测冲突。任一项不过 → **整体中止，不改动任何分支**。
- 逐分支 `git merge --no-ff`，消息 `merge: <feature> into <目标>（<日期>）`。
- **三环境 tip 相同时自动 lockstep**：只合并一次，另外两个分支快进到同一个 merge commit，保持三环境 SHA 一致（本仓库 stage/pre/test 历史上同点）。
- 结束时切回原分支，**绝不 push**。

合并完成后按「合并汇报」模板输出：每个分支的 merge commit、待推送提交列表、变更面。然后明确问："以上将推送到 origin 的 order-stage / order-pre / order-test，确认推送吗？"

## 阶段 8：确认后推送

```bash
bash .dsh/skills/wechat-requirement-delivery/scripts/push-envs.sh --dry-run   # 先看
bash .dsh/skills/wechat-requirement-delivery/scripts/push-envs.sh             # 确认后执行
```

脚本推送前校验每个分支都是 fast-forward，**永不 force**；已是最新的分支自动跳过。
推送后回报：三个分支的新 SHA、推送前后对比。

## 阶段 9：收尾

- 更新 `requirements/YYYY-MM-DD-*.md` 各条目最终验收状态（`已实现` / `待后端` / `待联调`）。
- 需要时补 `changelog/YYYY-MM-DD.md`。
- 切回 `order-test`，确认 `git status` 干净。
- 汇报最终状态：合并并推送了哪几个分支、到哪个 SHA、遗留待办。

---

## 异常与回滚

| 情况 | 处理 |
|---|---|
| 用户评审不通过 | 留在开发分支继续改，按反馈追加提交，重新走阶段 6；**不合并** |
| pre-flight 报"本地分支有未推送提交" | 停下问用户在那些本地提交怎么处理；不要自行 reset |
| 合并冲突（pre-flight 已拦住则不会发生） | 脚本自动 `merge --abort`；把冲突文件列给用户等指示 |
| 已合并但未推送，发现错了 | `git checkout <目标> && git reset --hard origin/<目标>`（仅限未推送），然后报告 |
| 已推送才发现错 | **不回滚**。新建 `fix/*` 分支修正，重新走评审 → 合并流程 |
| 切分支/合并时工作区脏 | 停下问用户：提交 / stash / 丢弃，不自作主张 |

## 参考文件

- `references/intake-checklist.md` — 最小信息清单、收料归档规范
- `references/project-rules.md` — Vue2/JS/JSDoc/lodash/mathjs/变更记录等项目铁律
- `references/branch-workflow.md` — 分支模型、命令细节、冲突与回滚
- `references/report-templates.md` — 需求清单、交付汇报、合并汇报模板
- `scripts/prep-branch.sh` / `scripts/merge-envs.sh` / `scripts/push-envs.sh`
