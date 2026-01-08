# Change: Add Export Selected Freight

## Why
目前运费申请列表仅支持查看和单条操作。当财务或运营需要批量处理或离线对账时，无法快速导出选中的运费申请数据，影响工作效率。

## What Changes
- [NEW] 在运费申请列表页添加“导出选中”按钮。
- [NEW] 支持将选中的行导出为 Excel 文件（xlsx 格式）。
- [NEW] 前端实现导出逻辑，复用项目已有的 `xlsx` 和 `file-saver` 库。

## Impact
- **Affected Specs**: `specs/apply-freight/spec.md`
- **Affected Code**: 
  - `packages/order-system/src/views/system/applyfreight/index.vue`
  - `packages/order-system/src/api/system/applyfreight.js` (如果需要后端配合)
