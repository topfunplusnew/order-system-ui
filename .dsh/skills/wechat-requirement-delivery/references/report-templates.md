# 汇报模板

## 一、需求条目清单（写入 `requirements/YYYY-MM-DD-<主题>.md`）

```markdown
# YYYY-MM-DD <主题>（微信记录需求）

## 总目标
- （一句话）

## 来源
- 微信聊天记录：<群/联系人>，YYYY-MM-DD HH:mm
- 接口文档：<APIfox 链接 / 粘贴 / openapi 快照路径>
- 接口地址：test <base>｜pre <base>｜stage <base>

## 需求清单

### 1) <需求标题>（页面/模块）
- 原话摘录：「……」（<发言人>，MM-DD HH:mm）
- 需求描述：改什么、改成什么样
- 接口：`POST /system/xxx`（接口 ID: xxx）
- 用到的字段：`field_a`（含义/类型）、`field_b`（枚举：0=xx，1=yy）
- 精度：保留 2 位小数（mathjs）
- 验收口径：已实现 / 待后端 / 待联调 / 待确认是否需求
- 风险：**后端可能尚未提供 xxx 字段**

### 2) …（同上）

## 待确认项
- [ ] <阻塞性问题>

## 假设（非阻塞，已按此推进）
- <列宽默认 120>、<默认按 id 倒序>

## 交付与验收
- 开发分支：`feat/YYYYMMDD-<slug>`
- 合并目标：order-stage / order-pre / order-test
```

## 二、交付汇报（阶段 5，⛔评审闸门，消息里直接发给用户）

```markdown
## 交付待审

**分支**：`feat/20260918-xxx`（基线 `origin/order-test @ <sha>`，已推送 / 仅本地）
**对比**：https://github.com/topfunplusnew/order-system-ui/compare/order-test...feat/20260918-xxx

### 需求落实
| # | 需求 | 状态 | 说明 |
|---|------|------|------|
| 1 | … | 已实现 | … |
| 2 | … | 待后端 | 后端未提供 `xxx` 字段 |

### 改动文件
- 新增 `packages/order-system/src/api/xxx.js`：xxx 接口封装
- 修改 `packages/order-system/src/views/.../index.vue`：新增日期列 + 校验

### 接口核对
- `GET /system/xxx/list`：query `pageNum/pageSize/startDate/endDate`，响应 `rows[].xxxDate`
- 来源：<APIfox 链接>，核对时间 YYYY-MM-DD HH:mm

### 我做的假设
- …

### 未做 / 做不了
- …

### 建议验证路径
1. 进入 <菜单> → …
2. 点「查询」，期望 …；空数据时显示 …

### 已知风险
- …

---
请审查。**回复"通过"后我才会合并到 order-stage / order-pre / order-test。**
```

## 三、合并汇报（阶段 6，⛔推送闸门）

```markdown
## 已合并，待推送确认

| 分支 | merge commit | 待推送提交 | 变更面 |
|------|--------------|-----------|--------|
| order-stage | `abc1234` | 3 commits | 5 files, +210 / -32 |
| order-pre   | `abc1234`（lockstep 同 SHA） | 同上 | 同上 |
| order-test  | `abc1234`（lockstep 同 SHA） | 同上 | 同上 |

推送后将为三个分支的 tip：`abc1234`

**以上将推送到 origin 的 order-stage / order-pre / order-test，确认推送吗？**
```

## 四、推送完成汇报（阶段 7）

```markdown
## 推送完成

- order-stage → `<new-sha>`（fast-forward）
- order-pre   → `<new-sha>`
- order-test  → `<new-sha>`

本地已切回 `order-test`，工作区干净。
遗留待办：<待后端字段 xxx / 待联调 yyy>
```
