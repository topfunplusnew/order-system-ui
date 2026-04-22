# Change: Update Table Auto Width

## Why
当前系统中的表格列宽策略不统一。部分页面依赖固定宽度，导致长内容被截断、短内容占用过多空间，不同页面的表格展示体验也存在明显差异。

项目中已经引入了 `v-fit-columns`、`FitTable` 和列配置的 `autoWidth` 处理逻辑，但实际生效范围和例外规则尚未统一，导致“按内容自动拉宽”在不同页面表现不一致。因此需要将该能力提升为统一的表格展示规范。

## What Changes
- [NEW] 为系统内业务表格定义统一的“按内容自动适配列宽”规则。
- [NEW] 规定自动列宽的默认生效范围、例外列类型和最大宽度约束。
- [NEW] 规定数据刷新、分页、动态显隐列、容器尺寸变化等场景下的列宽重算行为。
- [NEW] 要求在自动列宽启用后，固定列、排序、筛选、横向滚动等现有表格能力保持正常。

## Impact
- **Affected Specs**: `specs/table-column-auto-width/spec.md`
- **Affected Code**:
  - `packages/order-system/src/main.js`
  - `packages/order-system/src/components/FitTable.vue`
  - `packages/order-system/src/utils/configManager.js`
  - 各业务页面中直接使用 `el-table` 的列表与明细表格
