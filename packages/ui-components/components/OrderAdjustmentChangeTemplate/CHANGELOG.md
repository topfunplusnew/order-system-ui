# 订单调整单变动统计模板组件 - 更新日志

## [1.0.0] - 2026-02-02

### 新增功能

- ✨ 创建订单调整单变动统计模板组件
- ✨ 支持修改前、修改后、差额三行对比展示
- ✨ 自动计算四类差额：客户变动、供应商变动、库存变动、运费变动
- ✨ 使用 mathjs 进行高精度数学计算
- ✨ 差额行高亮显示（浅红色背景 + 红色加粗文字）
- ✨ 汇总统计展示（四类差额的绝对值求和）
- ✨ 响应式数据处理

### 技术特性

- 📦 基于 Vue2 + Options API + JavaScript
- 🎨 使用 Element UI 表格组件
- 🔢 使用 mathjs 保证高精度计算（保留2位小数）
- 📝 所有函数都添加了 JSDocs 注释
- 🎯 遵循项目代码规范

### 组件结构

```
OrderAdjustmentChangeTemplate/
├── index.vue           # 主组件
├── README.md           # 使用文档
├── example.vue         # 使用示例
└── CHANGELOG.md        # 更新日志
```

### 字段支持

支持以下字段展示：

**基本信息**
- 状态、订单日期、客户、车牌、海运柜号、海运公司、供应商、仓库名称

**产品信息**
- 级别名称、计量单位、厚度、长度、宽度、出厂片数、每包片数、包数

**价格信息**
- 出厂单价、出厂是否含税、杂费、出厂货款、卸货片数、卸货价、存货价

**原始金额**
- 原出厂货款、原出厂货款(含税)
- 原库存金额、原库存金额(含税)
- 原客户应收金额、原客户应收金额(含税)
- 原运费金额、原运费金额(含税)

**差额字段**
- 客户变动差额、供应商变动差额、库存变动差额、运费变动差额

### 使用方式

#### 1. 全局使用（已在 ui-components 中注册）

```javascript
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';
```

#### 2. 配合弹窗使用

```javascript
this.openDialog(
  OrderAdjustmentChangeTemplate,
  '订单调整单变动详情',
  '1500px',
  {
    compareData: [...],
    moduleName: 'orderAdjustment'
  },
  false,
  false
);
```

### 计算规则

1. **差额计算**: `差额 = 修改后的值 - 修改前的值`
2. **汇总计算**: `汇总 = Σ |差额|`（取绝对值求和）
3. **精度控制**: 所有金额保留2位小数

### 样式规范

- **修改前行**: 浅蓝色背景 (`#f0f9ff`)
- **修改后行**: 浅橙色背景 (`#fff7e6`)
- **差额行**: 浅红色背景 (`#fff1f0`)，加粗显示
- **差额单元格**: 红色加粗文字 (`#f56c6c`)

### 依赖项

- Vue 2.x
- Element UI
- mathjs
- lodash

### 相关文档

- [使用文档](./README.md)
- [使用示例](./example.vue)
- [资金变动统计 Skill](../../../../.cursor/skills/fund-change-statistics/SKILL.md)

### 开发者

- 基于 fund-change-statistics skill 开发
- 遵循项目代码规范
- 所有函数添加 JSDocs 注释
- 使用 mathjs 进行高精度计算

### 注意事项

1. 确保 `compareData` 中的金额字段为数字类型
2. 相同 `recordId` 的记录会被分组对比
3. 必须包含 `'before'` 和 `'after'` 两种 `changeType`
4. 组件会自动监听 `compareData` 的变化并重新处理数据
5. 所有金额计算保留2位小数

### 后续计划

- [ ] 支持导出功能
- [ ] 支持打印功能
- [ ] 支持自定义列显隐
- [ ] 支持列宽拖拽
- [ ] 支持数据排序
