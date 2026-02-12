# 模板映射配置

## 模块与模板组件对应关系

| 模块编号 | 模块名称 | 组件名称 | 文件路径 | 弹窗标题 | 弹窗宽度 |
|---------|---------|---------|---------|---------|---------|
| ⓪ | 入库管理 | InventoryChangeTemplate | `./components/FundChangeTemplates/InventoryChangeTemplate.vue` | 入库管理变动详情 | 1500px |
| ⓪ | 二次出库 | SecondOutboundTemplate | `./components/FundChangeTemplates/SecondOutboundTemplate.vue` | 二次出库变动详情 | 1200px |
| ⓪ | 订单调整单 | OrderAdjustmentTemplate | `./components/FundChangeTemplates/OrderAdjustmentTemplate.vue` | 订单调整单变动详情 | 1500px |
| ①②③ | 票点 | TicketPointTemplate | `./components/FundChangeTemplates/TicketPointTemplate.vue` | 票点变动详情 | 1200px |
| ①②③ | 收款 | ReceiveMoneyTemplate | `./components/FundChangeTemplates/ReceiveMoneyTemplate.vue` | 收款变动详情 | 1500px |
| ①②③ | 付款 | PaymentTemplate | `./components/FundChangeTemplates/PaymentTemplate.vue` | 付款变动详情 | 1500px |
| ①②③ | 冲抵款 | OffsetPaymentTemplate | `./components/FundChangeTemplates/OffsetPaymentTemplate.vue` | 冲抵款变动详情 | 1200px |
| ①②③ | 平账 | BalanceAccountTemplate | `./components/FundChangeTemplates/BalanceAccountTemplate.vue` | 平账变动详情 | 1200px |
| ② | 借入款管理 | BorrowInTemplate | `./components/FundChangeTemplates/BorrowInTemplate.vue` | 借入款管理变动详情 | 1200px |
| ⑤ | 员工或公司从我司借款 | BorrowFromCompanyTemplate | `./components/FundChangeTemplates/BorrowFromCompanyTemplate.vue` | 从我司借款变动详情 | 1200px |
| ⑥ | 期货保证金 | FuturesDepositTemplate | `./components/FundChangeTemplates/FuturesDepositTemplate.vue` | 期货保证金变动详情 | 1200px |
| ⑦ | 厂家保证金 | SupplierDepositTemplate | `./components/FundChangeTemplates/SupplierDepositTemplate.vue` | 厂家保证金变动详情 | 1200px |
| ⑧ | 收取保证金 | ReceiveDepositTemplate | `./components/FundChangeTemplates/ReceiveDepositTemplate.vue` | 收取保证金变动详情 | 1200px |

## 模板映射代码

在主页面中使用以下代码进行模板映射：

```javascript
import InventoryChangeTemplate from './components/FundChangeTemplates/InventoryChangeTemplate.vue';
import SecondOutboundTemplate from './components/FundChangeTemplates/SecondOutboundTemplate.vue';
import OrderAdjustmentTemplate from './components/FundChangeTemplates/OrderAdjustmentTemplate.vue';
import TicketPointTemplate from './components/FundChangeTemplates/TicketPointTemplate.vue';
import ReceiveMoneyTemplate from './components/FundChangeTemplates/ReceiveMoneyTemplate.vue';
import PaymentTemplate from './components/FundChangeTemplates/PaymentTemplate.vue';
import OffsetPaymentTemplate from './components/FundChangeTemplates/OffsetPaymentTemplate.vue';
import BalanceAccountTemplate from './components/FundChangeTemplates/BalanceAccountTemplate.vue';
import BorrowInTemplate from './components/FundChangeTemplates/BorrowInTemplate.vue';
import BorrowFromCompanyTemplate from './components/FundChangeTemplates/BorrowFromCompanyTemplate.vue';
import FuturesDepositTemplate from './components/FundChangeTemplates/FuturesDepositTemplate.vue';
import SupplierDepositTemplate from './components/FundChangeTemplates/SupplierDepositTemplate.vue';
import ReceiveDepositTemplate from './components/FundChangeTemplates/ReceiveDepositTemplate.vue';

export default {
  data() {
    return {
      // 模板映射配置
      templateMap: {
        'inventory': {
          component: InventoryChangeTemplate,
          title: '入库管理变动详情',
          width: '1500px'
        },
        'secondOutbound': {
          component: SecondOutboundTemplate,
          title: '二次出库变动详情',
          width: '1200px'
        },
        'orderAdjustment': {
          component: OrderAdjustmentTemplate,
          title: '订单调整单变动详情',
          width: '1500px'
        },
        'ticketPoint': {
          component: TicketPointTemplate,
          title: '票点变动详情',
          width: '1200px'
        },
        'receiveMoney': {
          component: ReceiveMoneyTemplate,
          title: '收款变动详情',
          width: '1500px'
        },
        'payment': {
          component: PaymentTemplate,
          title: '付款变动详情',
          width: '1500px'
        },
        'offsetPayment': {
          component: OffsetPaymentTemplate,
          title: '冲抵款变动详情',
          width: '1200px'
        },
        'balanceAccount': {
          component: BalanceAccountTemplate,
          title: '平账变动详情',
          width: '1200px'
        },
        'borrowIn': {
          component: BorrowInTemplate,
          title: '借入款管理变动详情',
          width: '1200px'
        },
        'borrowFromCompany': {
          component: BorrowFromCompanyTemplate,
          title: '从我司借款变动详情',
          width: '1200px'
        },
        'futuresDeposit': {
          component: FuturesDepositTemplate,
          title: '期货保证金变动详情',
          width: '1200px'
        },
        'supplierDeposit': {
          component: SupplierDepositTemplate,
          title: '厂家保证金变动详情',
          width: '1200px'
        },
        'receiveDeposit': {
          component: ReceiveDepositTemplate,
          title: '收取保证金变动详情',
          width: '1200px'
        }
      }
    };
  },
  methods: {
    /**
     * 打开指定模块的变动详情弹窗
     * @param {string} moduleName - 模块名称（对应 templateMap 的 key）
     * @param {Array} compareData - 对比数据
     */
    openModuleDetail(moduleName, compareData) {
      const template = this.templateMap[moduleName];
      if (template) {
        this.openDialog(
          template.component,
          template.title,
          template.width,
          {
            compareData,
            moduleName
          },
          false,
          false
        );
      } else {
        this.$message.warning(`未找到模块 "${moduleName}" 对应的模板组件`);
      }
    }
  }
};
```

## 数据结构规范

### compareData 数据格式

`compareData` 即 **getByIds 接口返回的 `data` 数组**，每条为备份日志记录（backup log record）：

```javascript
[
  {
    id: 146911,
    tableName: 'inventory_main',
    backupTime: '2026-02-09 14:28:25',
    originalTargetTime: '2025-11-23 16:33:21',
    changedTargetTime: '2025-11-23 16:33:21',
    backupType: 'update',
    originalInfo: { /* 修改前的完整业务数据 */ },
    changedInfo: { /* 修改后的完整业务数据 */ },
    originalInfoId: '71'
  }
]
```

`originalInfo` / `changedInfo` 结构随 `tableName` 不同而不同，模板需通过 `mapBeforeRow`、`mapAfterRow`、`buildDiffFields` 进行字段映射与差额计算。

### 差额计算规则

- **库存金额**: 修改后 - 修改前（正数表示增加，负数表示减少）
- **客户欠款**: 修改后 - 修改前（正数表示欠款增加，负数表示欠款减少）
- **供应商欠款**: 修改后 - 修改前（正数表示欠款增加，负数表示欠款减少）
- **银行卡资金**: 修改后 - 修改前（正数表示资金增加，负数表示资金减少）

## 快速开发流程

1. **复制模板**: 从 `InventoryChangeTemplate.vue` 复制基础结构
2. **修改组件名**: 改为对应的模块名称
3. **配置 columns**: 根据 [field-reference.md](./field-reference.md) 及 Excel 表格配置表格列，差额列指定 `aggregator`（默认 `sum`，常用 `absSum`）及 `summaryLabel`
4. **重写 buildDiffFields**: 从 `originalInfo` / `changedInfo` 计算差额字段，返回 key 与 columns 的 `prop` 一致
5. **按需重写 mapBeforeRow / mapAfterRow**: 若需从原始结构提取或聚合成表格行字段
6. **导入并注册**: 在主页面导入组件并添加到 `templateMap`
7. **测试调用**: 使用 `openModuleDetail(moduleName, res.data)`，传入 getByIds 的 `data`

## 常见问题

### Q1: 如何添加新的汇总项？

在 `columns` 中增加配置即可，`summaryMap` 会自动按 `aggregator` 计算：

```javascript
columns() {
  return [
    // ...
    { prop: 'newFieldDiff', label: '新字段差额', aggregator: 'absSum', summaryLabel: '新字段差额汇总' }
  ];
},
buildDiffFields(original, changed) {
  return {
    // ...
    newFieldDiff: this.calculateFieldDiff(changed.newField, original.newField)
  };
}
```

### Q2: 如何处理多层嵌套的数据？

使用 lodash 的 `_.get` 方法：

```javascript
const value = _.get(data, 'nested.field.path', 0);
```

### Q3: 如何自定义行颜色？

修改 `tableRowClassName` 方法或在 style 中添加自定义类：

```javascript
tableRowClassName({ row, rowIndex }) {
  if (row.rowType === 'before') return 'before-row';
  if (row.rowType === 'after') return 'after-row';
  if (row.rowType === 'diff') {
    // 根据差额正负设置不同颜色
    return row.amount > 0 ? 'diff-row-positive' : 'diff-row-negative';
  }
  return '';
}
```
