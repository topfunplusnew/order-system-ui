# 订单调整单变动统计模板组件

## 组件说明

`OrderAdjustmentChangeTemplate` 是用于展示订单调整单数据修改记录的模板组件，通过"修改前"、"修改后"、"差额"三行对比，清晰展示订单调整单的数据变化。

## 功能特性

- ✅ 支持多条记录的对比展示
- ✅ 自动计算四类差额：客户变动、供应商变动、库存变动、运费变动
- ✅ 使用 mathjs 进行高精度数学计算
- ✅ 差额行高亮显示
- ✅ 汇总统计展示
- ✅ 响应式数据处理

## 安装使用

### 全局注册（已在 ui-components 中注册）

```javascript
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';

// 组件已全局注册，可直接在模板中使用
```

### 局部引入

```javascript
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';

export default {
  components: {
    OrderAdjustmentChangeTemplate
  }
};
```

## Props

| 参数 | 说明 | 类型 | 默认值 | 必填 |
|------|------|------|--------|------|
| compareData | 对比数据数组 | Array | [] | 是 |
| moduleName | 模块名称 | String | '' | 否 |

## compareData 数据格式

```javascript
[
  {
    recordId: '唯一记录ID',          // 用于分组，相同 recordId 的记录会被分组对比
    changeType: 'before',            // 'before' | 'after'
    
    // 基本信息
    status: '已审核',
    orderDate: '2026-01-15',
    customerName: '某某公司',
    truckPlate: '鄂A12345',
    containerNo: 'ABCD1234567',
    shippingCompany: '中远海运',
    supplierName: '湖北三峡',
    warehouse: '刘彦波仓库',
    
    // 产品信息
    gradeName: '湖北三峡欧洲灰原片优等品',
    unit: '片',
    thickness: 7.2,
    length: 3660,
    width: 2250,
    factoryPieces: 520,
    piecesPerPack: 52,
    packCount: 10,
    
    // 价格信息
    factoryPrice: 20.97,
    includeTax: '是',
    miscFee: 100.00,
    factoryPayment: 10904.40,
    unloadPieces: 520,
    unloadPrice: 21.00,
    stockPrice: 20.97,
    
    // 原始金额
    originalFactoryPayment: 10904.40,
    originalFactoryPaymentTax: 12279.95,
    originalInventoryAmount: 8979.77,
    originalInventoryAmountTax: 10104.40,
    originalCustomerReceivable: 12000.00,
    originalCustomerReceivableTax: 13500.00,
    originalFreightAmount: 1200.00,
    originalFreightAmountTax: 1350.00,
    
    // 变动金额（用于计算差额）
    customerAmount: 12000.00,
    supplierAmount: 10904.40,
    inventoryAmount: 8979.77,
    freightAmount: 1200.00
  },
  {
    recordId: '唯一记录ID',
    changeType: 'after',
    // ... 修改后的数据
    customerAmount: 12100.00,
    supplierAmount: 11000.00,
    inventoryAmount: 9000.00,
    freightAmount: 1250.00
  }
]
```

## 使用示例

### 基础使用

```vue
<template>
  <order-adjustment-change-template
    :compare-data="compareData"
    module-name="orderAdjustment"
  />
</template>

<script>
export default {
  data() {
    return {
      compareData: [
        {
          recordId: '1',
          changeType: 'before',
          status: '已审核',
          orderDate: '2026-01-15',
          customerName: '某某公司',
          supplierName: '湖北三峡',
          gradeName: '湖北三峡欧洲灰原片优等品',
          thickness: 7.2,
          length: 3660,
          width: 2250,
          factoryPieces: 520,
          factoryPrice: 20.97,
          customerAmount: 12000.00,
          supplierAmount: 10904.40,
          inventoryAmount: 8979.77,
          freightAmount: 1200.00
        },
        {
          recordId: '1',
          changeType: 'after',
          status: '已审核',
          orderDate: '2026-01-15',
          customerName: '某某公司',
          supplierName: '湖北三峡',
          gradeName: '湖北三峡欧洲灰原片优等品',
          thickness: 7.2,
          length: 3660,
          width: 2250,
          factoryPieces: 520,
          factoryPrice: 21.00,
          customerAmount: 12100.00,
          supplierAmount: 11000.00,
          inventoryAmount: 9000.00,
          freightAmount: 1250.00
        }
      ]
    };
  }
};
</script>
```

### 配合弹窗使用（推荐）

```javascript
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';

export default {
  mixins: [common_dialog],
  methods: {
    /**
     * 打开订单调整单变动详情弹窗
     * @param {Array} compareData - 对比数据
     */
    openOrderAdjustmentDetail(compareData) {
      this.openDialog(
        OrderAdjustmentChangeTemplate,
        '订单调整单变动详情',
        '1500px',
        {
          compareData,
          moduleName: 'orderAdjustment'
        },
        false,
        false
      );
    }
  }
};
```

## 计算逻辑

### 差额计算

所有差额使用 mathjs 进行高精度计算：

```javascript
差额 = 修改后的值 - 修改前的值
```

### 四类差额

1. **客户变动差额** (`customerDiff`): 
   - 计算字段：`customerAmount`
   - 说明：客户应收金额的变化

2. **供应商变动差额** (`supplierDiff`):
   - 计算字段：`supplierAmount`
   - 说明：供应商应付金额的变化

3. **库存变动差额** (`inventoryDiff`):
   - 计算字段：`inventoryAmount`
   - 说明：库存金额的变化

4. **运费变动差额** (`freightDiff`):
   - 计算字段：`freightAmount`
   - 说明：运费金额的变化

### 汇总统计

组件会自动计算四类差额的汇总（取绝对值求和）：

```javascript
汇总 = Σ |差额|
```

## 样式说明

### 行样式

- **修改前行**: 浅蓝色背景 (`#f0f9ff`)
- **修改后行**: 浅橙色背景 (`#fff7e6`)
- **差额行**: 浅红色背景 (`#fff1f0`)，加粗显示

### 差额单元格

差额列（`customerDiff`、`supplierDiff`、`inventoryDiff`、`freightDiff`）会以红色加粗显示。

## 注意事项

1. **数据格式**: 确保 `compareData` 中的金额字段为数字类型
2. **recordId**: 相同 `recordId` 的记录会被分组对比，确保 `recordId` 的唯一性
3. **changeType**: 必须包含 `'before'` 和 `'after'` 两种类型
4. **响应式**: 组件会自动监听 `compareData` 的变化并重新处理数据
5. **精度**: 所有金额计算保留2位小数

## 字段映射

| 表格列名 | 字段名 | 说明 |
|---------|--------|------|
| 状态 | status | 订单状态 |
| 订单日期 | orderDate | 订单日期 |
| 客户 | customerName | 客户名称 |
| 车牌 | truckPlate | 陆运车牌 |
| 海运柜号 | containerNo | 海运柜号 |
| 海运公司 | shippingCompany | 海运公司 |
| 供应商 | supplierName | 供应商名称 |
| 仓库名称 | warehouse | 仓库名称 |
| 级别名称 | gradeName | 产品级别 |
| 计量单位 | unit | 计量单位 |
| 厚度 | thickness | 产品厚度 |
| 长度 | length | 产品长度 |
| 宽度 | width | 产品宽度 |
| 出厂片数 | factoryPieces | 出厂片数 |
| 每包片数 | piecesPerPack | 每包片数 |
| 包数 | packCount | 包数 |
| 出厂单价 | factoryPrice | 出厂单价 |
| 出厂是否含税 | includeTax | 是否含税 |
| 杂费 | miscFee | 杂费 |
| 出厂货款 | factoryPayment | 出厂货款 |
| 卸货片数 | unloadPieces | 卸货片数 |
| 卸货价 | unloadPrice | 卸货价 |
| 存货价 | stockPrice | 存货价 |
| 原出厂货款 | originalFactoryPayment | 原出厂货款 |
| 原出厂货款(含税) | originalFactoryPaymentTax | 原出厂货款(含税) |
| 原库存金额 | originalInventoryAmount | 原库存金额 |
| 原库存金额(含税) | originalInventoryAmountTax | 原库存金额(含税) |
| 原客户应收金额 | originalCustomerReceivable | 原客户应收金额 |
| 原客户应收金额(含税) | originalCustomerReceivableTax | 原客户应收金额(含税) |
| 原运费金额 | originalFreightAmount | 原运费金额 |
| 原运费金额(含税) | originalFreightAmountTax | 原运费金额(含税) |
| 客户变动差额 | customerDiff | 客户变动差额 |
| 供应商变动差额 | supplierDiff | 供应商变动差额 |
| 库存变动差额 | inventoryDiff | 库存变动差额 |
| 运费变动差额 | freightDiff | 运费变动差额 |

## 开发规范

- ✅ 所有函数都添加了 JSDocs 注释
- ✅ 所有数学计算都使用了 mathjs
- ✅ 表格数据保持响应式
- ✅ 差额计算准确（修改后 - 修改前）
- ✅ 样式符合项目规范

## 相关资源

- [资金变动统计 Skill 文档](../../../../.cursor/skills/fund-change-statistics/SKILL.md)
- [字段参考文档](../../../../.cursor/skills/fund-change-statistics/field-reference.md)
- [模板映射配置](../../../../.cursor/skills/fund-change-statistics/template-mapping.md)
