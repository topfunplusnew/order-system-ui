# 快速开始

## 5分钟上手订单调整单变动统计模板

### 第一步：导入组件

```javascript
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';
```

### 第二步：准备数据

```javascript
const compareData = [
  {
    recordId: '1',              // 唯一ID，用于分组
    changeType: 'before',       // 修改前
    customerName: '某某公司',
    supplierName: '湖北三峡',
    customerAmount: 12000.00,   // 客户金额
    supplierAmount: 10904.40,   // 供应商金额
    inventoryAmount: 8979.77,   // 库存金额
    freightAmount: 1200.00      // 运费金额
    // ... 其他字段
  },
  {
    recordId: '1',              // 相同ID表示同一条记录
    changeType: 'after',        // 修改后
    customerName: '某某公司',
    supplierName: '湖北三峡',
    customerAmount: 12100.00,   // 修改后的客户金额
    supplierAmount: 11000.00,   // 修改后的供应商金额
    inventoryAmount: 9000.00,   // 修改后的库存金额
    freightAmount: 1250.00      // 修改后的运费金额
    // ... 其他字段
  }
];
```

### 第三步：使用组件

#### 方式一：直接使用

```vue
<template>
  <order-adjustment-change-template
    :compare-data="compareData"
    module-name="orderAdjustment"
  />
</template>

<script>
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';

export default {
  components: {
    OrderAdjustmentChangeTemplate
  },
  data() {
    return {
      compareData: [...]
    };
  }
};
</script>
```

#### 方式二：配合弹窗使用（推荐）

```javascript
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';

export default {
  mixins: [common_dialog],
  methods: {
    openDetail() {
      this.openDialog(
        OrderAdjustmentChangeTemplate,
        '订单调整单变动详情',
        '1500px',
        {
          compareData: this.compareData,
          moduleName: 'orderAdjustment'
        },
        false,
        false
      );
    }
  }
};
```

## 完整示例

```vue
<template>
  <div>
    <el-button type="primary" @click="showDetail">查看变动详情</el-button>
  </div>
</template>

<script>
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { OrderAdjustmentChangeTemplate } from '@order-system/ui-components';

export default {
  mixins: [common_dialog],
  data() {
    return {
      compareData: [
        {
          recordId: '1',
          changeType: 'before',
          status: '已审核',
          orderDate: '2026-01-15',
          customerName: '山东冠州辰明玻璃科技公司',
          supplierName: '湖北三峡',
          gradeName: '湖北三峡欧洲灰原片优等品',
          thickness: 7.2,
          length: 3660,
          width: 2250,
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
          customerName: '山东冠州辰明玻璃科技公司',
          supplierName: '湖北三峡',
          gradeName: '湖北三峡欧洲灰原片优等品',
          thickness: 7.2,
          length: 3660,
          width: 2250,
          factoryPrice: 21.00,
          customerAmount: 12100.00,
          supplierAmount: 11000.00,
          inventoryAmount: 9000.00,
          freightAmount: 1250.00
        }
      ]
    };
  },
  methods: {
    showDetail() {
      this.openDialog(
        OrderAdjustmentChangeTemplate,
        '订单调整单变动详情',
        '1500px',
        {
          compareData: this.compareData,
          moduleName: 'orderAdjustment'
        },
        false,
        false
      );
    }
  }
};
</script>
```

## 效果预览

组件会展示：

1. **三行对比**：
   - 第1行：修改前（浅蓝色背景）
   - 第2行：修改后（浅橙色背景）
   - 第3行：差额（浅红色背景，红色加粗）

2. **四类汇总**：
   - 客户变动差额汇总：100.00
   - 供应商变动差额汇总：95.60
   - 库存变动差额汇总：20.23
   - 运费变动差额汇总：50.00

## 常见问题

### Q1: 差额如何计算？

```
差额 = 修改后的值 - 修改前的值
```

例如：
- 客户变动差额 = 12100.00 - 12000.00 = 100.00

### Q2: 汇总如何计算？

```
汇总 = Σ |差额|（取绝对值求和）
```

### Q3: 如何添加多条记录？

只需要在 `compareData` 中添加更多的记录对，确保每对记录的 `recordId` 相同：

```javascript
compareData: [
  // 第一条记录
  { recordId: '1', changeType: 'before', ... },
  { recordId: '1', changeType: 'after', ... },
  
  // 第二条记录
  { recordId: '2', changeType: 'before', ... },
  { recordId: '2', changeType: 'after', ... },
  
  // 第三条记录
  { recordId: '3', changeType: 'before', ... },
  { recordId: '3', changeType: 'after', ... }
]
```

### Q4: 金额字段必须是数字类型吗？

是的，所有金额字段（`customerAmount`、`supplierAmount`、`inventoryAmount`、`freightAmount`）必须是数字类型，否则计算会出错。

如果从后端获取的是字符串，需要转换：

```javascript
const data = {
  ...item,
  customerAmount: Number(item.customerAmount || 0),
  supplierAmount: Number(item.supplierAmount || 0),
  inventoryAmount: Number(item.inventoryAmount || 0),
  freightAmount: Number(item.freightAmount || 0)
};
```

## 下一步

- 查看 [完整文档](./README.md)
- 查看 [使用示例](./example.vue)
- 查看 [更新日志](./CHANGELOG.md)
