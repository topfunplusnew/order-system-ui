# 分支模型与合并细节

## 分支现状（截至 2026-09）

| 分支 | 角色 | 说明 |
|---|---|---|
| `order-stage` | 环境分支 | pre-release 前的集成环境 |
| `order-pre` | 环境分支 | 预发布 |
| `order-test` | 环境分支 | 测试环境，**新开发分支的默认基线** |
| `order-dev` | 遗留 | 停留在 2026-04，落后环境分支 114 个提交，**不要用** |
| `front-*` / `release*` | 老体系 | 与本流程无关，不要动 |

三环境分支历史上保持同点（stage = pre = test 同一 SHA），因此合并时优先保持 SHA 一致。

## 开发分支命名

`feat/YYYYMMDD-<english-kebab-slug>`

例：`feat/20260918-order-freight-date-column`

- slug 用英文小写 kebab-case，别用中文（Git/CI 兼容性差）。
- 同一天多个需求：`feat/20260918-rebate-pagination`、`feat/20260918-rebate-export`。
- 修复类可用 `fix/YYYYMMDD-<slug>`。

## 标准命令序列（脚本已封装，此处为手工兜底）

### 1. 切开发分支

```bash
git status --porcelain            # 必须为空
git fetch origin --prune
git checkout -b feat/20260918-xxx origin/order-test
git push -u origin feat/20260918-xxx   # 评审需要
```

### 2. 合并到三环境（评审通过后）

**优先用脚本**（含全量 pre-flight、冲突预测、lockstep）：

```bash
bash .dsh/skills/wechat-requirement-delivery/scripts/merge-envs.sh feat/20260918-xxx --dry-run
bash .dsh/skills/wechat-requirement-delivery/scripts/merge-envs.sh feat/20260918-xxx
```

手工兜底（三环境 tip 相同时，只合并一次，其余分支重置到同一 commit）：

```bash
git status --porcelain                      # 必须为空
git fetch origin --prune

git checkout order-stage
git merge --ff-only origin/order-stage
git merge --no-ff feat/20260918-xxx -m "merge: feat/20260918-xxx into order-stage/order-pre/order-test（2026-09-18）"
MERGE_SHA=$(git rev-parse HEAD)

for b in order-pre order-test; do
  git checkout "$b" && git merge --ff-only "origin/$b" && git reset --hard "$MERGE_SHA"
done
```

注意：`git branch -f <b> <sha>` 在 `<b>` 正被检出时会失败，所以用"切过去 + `reset --hard`"。
三环境 tip **不同**时，改为逐分支独立合并（各自生成 merge commit）。

### 3. 推送（用户确认后）

```bash
git push origin order-stage
git push origin order-pre
git push origin order-test
```

## 冲突处理

1. 冲突出现 → **立即** `git merge --abort`。
2. 输出：`git merge --no-ff --no-commit <feature>` 试合一次拿到冲突文件清单（然后同样 abort），或直接列出 abort 前的 `git status --short`。
3. 把冲突文件 + 冲突原因（哪一侧改了什么）列给用户，问怎么处理。
4. 绝不使用 `-X theirs`/`-X ours`/`--strategy-option` 蒙混过关。

## 回滚

| 场景 | 允许的操作 |
|---|---|
| 本地已合并、**未推送** | `git checkout <目标> && git reset --hard origin/<目标>` |
| **已推送** | 不回滚。新建 `fix/*` 分支修正，重新走评审 → 合并流程 |
| 开发分支推错了内容 | 在开发分支上追加修正提交；确需重写时 `git push --force-with-lease` **仅限开发分支**，并先告知用户 |

## 安全红线

- 永久禁止：`push --force` 到 `order-*` / `front-*` / `release*`；`reset --hard` 已推送分支；`git clean -fdx`。
- 工作区脏的时候不切分支、不合并，先问用户。
- 不主动改 `order-dev`。
