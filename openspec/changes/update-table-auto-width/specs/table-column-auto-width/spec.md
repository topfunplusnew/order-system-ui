## ADDED Requirements

### Requirement: Tables auto fit column width by content
系统 SHALL 对业务表格中的常规数据列启用按内容自动适配列宽的能力，以减少固定列宽配置并提升内容可读性。

#### Scenario: Auto fit width on initial render
- **WHEN** 用户首次打开任一业务表格页面
- **THEN** 系统应根据表头标题和当前列内容的显示长度计算常规数据列宽
- **AND** 用户无需为常规列逐个配置固定宽度

#### Scenario: Long content reaches max width
- **WHEN** 某列内容长度超过自动列宽允许的最大展示宽度
- **THEN** 系统不再继续拉宽该列
- **AND** 超出部分以省略形式展示
- **AND** 用户可以通过悬浮提示或等效交互查看完整内容

### Requirement: Excluded columns keep explicit width behavior
系统 SHALL 允许特定列类型不参与自动列宽，并保留固定宽度或既有布局规则。

#### Scenario: Utility columns are excluded
- **WHEN** 表格包含选择列、序号列、展开列或操作列
- **THEN** 这些列不应强制参与自动列宽计算
- **AND** 系统应保留其固定宽度或现有布局行为

#### Scenario: Business column declares explicit width
- **WHEN** 某业务列被显式声明固定宽度
- **THEN** 系统应优先遵循该固定宽度配置
- **AND** 不覆盖该列的业务展示要求

### Requirement: Tables recalculate width when data or layout changes
系统 SHALL 在影响表格展示的关键场景下重新计算自动列宽，以保证列宽与当前数据和布局一致。

#### Scenario: Recalculate after data refresh
- **WHEN** 用户执行搜索、筛选、刷新或分页切换，导致表格数据集发生变化
- **THEN** 系统应重新计算参与自动列宽的列

#### Scenario: Recalculate after column or container change
- **WHEN** 用户动态显示或隐藏列，或表格容器宽度发生变化
- **THEN** 系统应重新计算参与自动列宽的列

### Requirement: Tables preserve readable layout with overflow
系统 SHALL 在自动列宽总和超过表格容器宽度时保留内容可读性，并保持表格结构稳定。

#### Scenario: Horizontal scrolling is enabled for overflow
- **WHEN** 自动计算后的总列宽超过表格容器可用宽度
- **THEN** 系统应允许表格横向滚动
- **AND** 不应通过过度压缩列宽导致内容不可读

#### Scenario: Fixed columns remain aligned
- **WHEN** 表格启用了固定列且自动列宽生效
- **THEN** 表头、内容区和固定列应保持对齐
- **AND** 不应出现错位、遮挡或滚动异常
