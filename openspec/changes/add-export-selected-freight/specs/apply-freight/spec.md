## ADDED Requirements

### Requirement: Export Selected Freight
系统 SHALL 允许用户从运费申请列表中选择特定记录并导出为 Excel 文件。

#### Scenario: Export multiple records
- **WHEN** 用户在列表中勾选了多条运费申请记录
- **AND** 用户点击“导出选中”按钮
- **THEN** 系统下载包含所选记录详细信息的 `.xlsx` 文件

#### Scenario: Export with no selection
- **WHEN** 用户未选择任何记录
- **AND** 用户尝试点击“导出选中”按钮
- **THEN** 系统应禁用该按钮或提示用户先选择记录
