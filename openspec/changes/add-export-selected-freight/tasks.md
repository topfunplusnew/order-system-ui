## 1. Implementation

### 1.1 UI Changes
- [ ] 在 `applyfreight/index.vue` 的工具栏添加导出按钮。
- [ ] 为导出按钮绑定点击事件。

### 1.2 Export Logic
- [ ] 实现 `handleExportSelected` 方法。
- [ ] 遍历 `el-table` 的选中行，格式化为导出所需的数据结构。
- [ ] 调用导出工具函数生成下载。

### 1.3 Verification
- [ ] 验证导出文件的列名和数据准确性。
- [ ] 验证未选中行时按钮的锁定或提示逻辑。
