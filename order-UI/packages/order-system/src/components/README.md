# 日期信息组件使用指南

## OrderDayInfor - 订单日期信息组件

### 功能说明
用于展示指定订单ID列表的详细信息，使用 Ant Design Vue 的 List 组件进行展示。

### 使用方法
```vue
<template>
  <div>
    <OrderDayInfor :ids="orderIds" />
  </div>
</template>

<script>
import OrderDayInfor from '@/components/OrderDayInfor/index.vue';

export default {
  components: {
    OrderDayInfor
  },
  data() {
    return {
      orderIds: [1, 2, 3, 4, 5] // 订单ID数组
    };
  }
};
</script>
```

### Props
- `ids` (Array, required): 订单ID数组

### 展示内容
- 订单基本信息（ID、日期、客户、总货款）
- 供应商/仓库信息
- 陆运信息（车牌、司机姓名、电话、运费）
- 海运信息（柜号、公司、电话、运费）
- 其他信息（车队、销售经理、录入员）
- 财务信息（利润含税/不含税、总吨位）
- 审核状态
- 备注

## InventoryDayInfo - 库存日期信息组件

### 功能说明
用于展示指定库存ID列表的详细信息，使用 Ant Design Vue 的 List 组件进行展示。

### 使用方法
```vue
<template>
  <div>
    <InventoryDayInfo :ids="inventoryIds" />
  </div>
</template>

<script>
import InventoryDayInfo from '@/components/InventoryDayInfo/index.vue';

export default {
  components: {
    InventoryDayInfo
  },
  data() {
    return {
      inventoryIds: [1, 2, 3, 4, 5] // 库存ID数组
    };
  }
};
</script>
```

### Props
- `ids` (Array, required): 库存ID数组

### 展示内容
- 库存基本信息（ID、入库日期、仓库名称）
- 供应商信息
- 货物来源公司
- 陆运信息（车牌号、司机姓名、电话、银行信息）
- 海运信息（柜号、海运公司、电话、银行信息）
- 其他信息（车队、录入员、运费总计）
- 审核状态
- 备注

## 技术实现
- 使用 `getBussinessInfoTodayList` API 批量查询数据
- tableName 使用 `BatchQueryTableName` 枚举中的值
  - 订单组件使用：`BatchQueryTableName.GOODS_ORDER`
  - 库存组件使用：`BatchQueryTableName.INVENTORY`
- 使用 Ant Design Vue 的 List、Tag、Icon、Spin、Empty 等组件
- 支持分页显示
- 响应式设计，支持不同屏幕尺寸
- 包含加载状态和空数据状态处理

## 样式特性
- 现代化的卡片式布局
- 清晰的信息分组展示
- 状态标签颜色区分
- 悬停效果
- 运输信息分块展示，便于阅读