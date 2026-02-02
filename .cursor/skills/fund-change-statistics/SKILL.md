---
name: fund-change-statistics
description: 生成资金变动统计功能的模板组件和调用逻辑。当用户需要创建资金变动统计、数据对比弹窗、修改前后差异展示，或询问资金变动统计相关需求时使用。
---

# 资金变动统计功能开发指南

本 Skill 用于生成资金变动统计功能，包括多个模板组件的创建和调用。

## 功能概述

资金变动统计功能用于展示系统中各个模块的数据修改记录，通过"修改前"、"修改后"、"差额"三行对比，清晰展示数据变化。
先调一个接口 拿总逻辑
总逻辑的数 调一个接口 传tbn + flg
传tbn+flg，返回若干id，id当一个数组 同时调俩接口，两个接口分别返回差额详情数据+底部小表格

差额详情数据，就是本SKILL中，这些模板所使用的对比数据
底部小表格 就是在详情组件中，底部的统计信息

### 涉及模块

根据 `@docs/apifox-docs/系统修改变动统计表.xlsx`，包含以下模块：

1. **⓪库存金额变动**: 入库管理、二次出库、订单调整单
2. **①客户欠款变动**: 订单调整单、票点、收款、付款、冲抵款、平账
3. **②所有银行卡资金变动**: 收款、付款、借入款、从我司借款、期货保证金、厂家保证金、收取保证金
4. **③欠厂家货款变动**: 入库管理、订单调整单、票点、收款、付款、冲抵款、平账
5. **④未支付运费变动**: 入库、订单、付款
6. **⑤其他应收**: 从我司借款
7. **⑥期货保证金变动**
8. **⑦厂家保证金变动**
9. **⑧收取保证金变动**
10. **⑨公司从外面借款变动**

## 开发步骤

### 步骤 1: 创建模板组件目录结构

在 `packages/order-system/src/views/system/Statement/components/` 下创建：

```
components/
├── FundChangeTemplates/
│   ├── InventoryChangeTemplate.vue      # 入库管理模板
│   ├── SecondOutboundTemplate.vue       # 二次出库模板
│   ├── OrderAdjustmentTemplate.vue      # 订单调整单模板
│   ├── TicketPointTemplate.vue          # 票点模板
│   ├── ReceiveMoneyTemplate.vue         # 收款模板
│   ├── PaymentTemplate.vue              # 付款模板
│   ├── OffsetPaymentTemplate.vue        # 冲抵款模板
│   ├── BalanceAccountTemplate.vue       # 平账模板
│   ├── BorrowInTemplate.vue             # 借入款管理模板
│   ├── BorrowFromCompanyTemplate.vue    # 员工或公司从我司借款模板
│   ├── FuturesDepositTemplate.vue       # 期货保证金模板
│   ├── SupplierDepositTemplate.vue      # 厂家保证金模板
│   └── ReceiveDepositTemplate.vue       # 收取保证金模板
```

### 步骤 2: 模板组件通用结构

每个模板组件遵循以下结构：

```vue
<script>
import { format } from 'mathjs';
import _ from 'lodash';

export default {
  name: 'XxxTemplate',
  props: {
    // 对比数据：包含修改前和修改后的数据
    compareData: {
      type: Array,
      default: () => []
    },
    // 模块名称
    moduleName: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      tableData: []
    };
  },
  computed: {
    // 计算差额汇总
    totalDiff() {
      // 使用 mathjs 进行高精度计算
      return this.tableData.reduce((sum, item) => {
        if (item.type === 'diff') {
          // 根据具体字段计算
          return format(add(sum, abs(item.amount || 0)), { notation: 'fixed', precision: 2 });
        }
        return sum;
      }, 0);
    }
  },
  created() {
    this.processData();
  },
  methods: {
    /**
     * 处理数据：将 compareData 转换为表格展示格式
     * 每个修改记录包含三行：修改前、修改后、差额
     */
    processData() {
      const grouped = _.groupBy(this.compareData, 'recordId');
      this.tableData = [];
      
      Object.keys(grouped).forEach(recordId => {
        const records = grouped[recordId];
        const beforeData = records.find(r => r.type === 'before') || {};
        const afterData = records.find(r => r.type === 'after') || {};
        
        // 修改前
        this.tableData.push({
          ...beforeData,
          rowType: 'before',
          label: '修改前'
        });
        
        // 修改后
        this.tableData.push({
          ...afterData,
          rowType: 'after',
          label: '修改后'
        });
        
        // 差额（使用 mathjs 计算）
        this.tableData.push({
          rowType: 'diff',
          label: '差额',
          // 根据具体字段计算差额
          amount: this.calculateDiff(afterData, beforeData)
        });
      });
    },
    
    /**
     * 计算差额（使用 mathjs 保证高精度）
     * @param {Object} after - 修改后数据
     * @param {Object} before - 修改前数据
     * @returns {number} 差额
     */
    calculateDiff(after, before) {
      // 根据具体业务逻辑计算
      // 示例：库存金额差额 = 修改后库存金额 - 修改前库存金额
      const afterValue = Number(after.amount || 0);
      const beforeValue = Number(before.amount || 0);
      return format(subtract(afterValue, beforeValue), { notation: 'fixed', precision: 2 });
    },
    
    /**
     * 行样式设置
     * @param {Object} row - 当前行数据
     * @returns {string} CSS 类名
     */
    tableRowClassName({ row }) {
      if (row.rowType === 'before') return 'before-row';
      if (row.rowType === 'after') return 'after-row';
      if (row.rowType === 'diff') return 'diff-row';
      return '';
    },
    
    handleProcess() {
      return Promise.resolve();
    },
    
    handleReject() {
      return Promise.resolve();
    }
  }
};
</script>

<template>
  <div class="fund-change-template">
    <el-table
      :data="tableData"
      border
      :row-class-name="tableRowClassName"
      style="width: 100%"
    >
      <el-table-column label="类型" prop="label" width="100" fixed />
      <!-- 根据具体模块添加对应的列 -->
      <el-table-column label="字段1" prop="field1" />
      <el-table-column label="字段2" prop="field2" />
      <!-- ... 更多列 ... -->
    </el-table>
    
    <div class="summary" v-if="totalDiff">
      <span>差额汇总：{{ totalDiff }}</span>
    </div>
  </div>
</template>

<style scoped lang="scss">
.fund-change-template {
  padding: 20px;
}

// 修改前行样式
::v-deep .before-row {
  background-color: #f0f9ff;
}

// 修改后行样式
::v-deep .after-row {
  background-color: #fff7e6;
}

// 差额行样式
::v-deep .diff-row {
  background-color: #fff1f0;
  font-weight: bold;
}

.summary {
  margin-top: 20px;
  padding: 10px;
  background: #f5f5f5;
  border-radius: 4px;
  text-align: right;
  font-size: 16px;
  font-weight: bold;
}
</style>
```

### 步骤 3: 在主页面中调用模板

在需要展示资金变动统计的页面中（如 `MoneyChangeTotalAmount.vue`），使用 `openDialog` 调用模板：

```javascript
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import InventoryChangeTemplate from './components/FundChangeTemplates/InventoryChangeTemplate.vue';
import SecondOutboundTemplate from './components/FundChangeTemplates/SecondOutboundTemplate.vue';
// ... 导入其他模板

export default {
  mixins: [common_dialog],
  methods: {
    /**
     * 打开指定模块的变动详情弹窗
     * @param {string} moduleName - 模块名称
     * @param {Array} compareData - 对比数据
     */
    openModuleDetail(moduleName, compareData) {
      const templateMap = {
        'inventory': {
          component: InventoryChangeTemplate,
          title: '入库管理变动详情',
          width: '1500px'
        },
        'secondOutbound': {
          component: SecondOutboundTemplate,
          title: '二次出库变动详情',
          width: '1500px'
        },
        'orderAdjustment': {
          component: OrderAdjustmentTemplate,
          title: '订单调整单变动详情',
          width: '1500px'
        },
        // ... 其他模块映射
      };
      
      const template = templateMap[moduleName];
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
        this.$message.warning('未找到对应的模板组件');
      }
    }
  }
};
```

### 步骤 4: 具体模板字段映射

根据 Excel 表格中的字段，为每个模板配置对应的列：

#### 入库管理模板字段

- 状态、入库时间、仓库、陆运车牌、海运柜号、海运公司
- 供应商、级别名称、计量单位
- 厚度、长度、宽度、每包片数、包数、出厂片数
- 出厂单价、出厂是否含税、杂费、出厂货款
- 库存量(片数)、卸货价、存货价、原库存金额、原库存金额(含税)
- 库存变动差额、供应商变动差额、运费变动差额

#### 二次出库模板字段

- 二次入库状态、仓库名称、出库方向、变动日期(出库)
- 产品级别、厚度、长度、宽度、出库量
- 存货价、原库存金额

#### 订单调整单模板字段

- 订单编号、客户名称、供应商名称
- 产品级别、厚度、长度、宽度
- 调整类型、调整数量、调整单价
- 客户变动差额、供应商变动差额、库存变动差额、运费变动差额

## 关键注意事项

### 1. 数学计算必须使用 mathjs

```javascript
import { add, subtract, multiply, divide, format, abs } from 'mathjs';

// 计算差额
const diff = subtract(afterValue, beforeValue);

// 格式化保留2位小数
const formatted = format(diff, { notation: 'fixed', precision: 2 });
```

### 2. 响应式数据处理

```javascript
// 使用 Vue.set 或 this.$set 确保响应式
this.$set(this.tableData, index, newValue);

// 或使用数组方法
this.tableData = [...this.tableData];
```

### 3. 表单初始化

```javascript
// 使用函数返回新对象
getInitForm() {
  return {
    compareData: [],
    moduleName: ''
  };
}

data() {
  return {
    form: this.getInitForm()
  };
}
```

### 4. JSDocs 注释

所有函数必须添加 JSDocs：

```javascript
/**
 * 处理数据：将 compareData 转换为表格展示格式
 * @param {Array} compareData - 对比数据数组
 * @returns {Array} 处理后的表格数据
 */
processData(compareData) {
  // ...
}
```

## 复用现有逻辑

在开发前，检查以下位置是否有可复用的组件和逻辑：

1. **弹窗组件**: `@/views/dashboard/backuplog/ChooseModule.vue`
2. **对比逻辑**: `@/views/dashboard/backuplog/goodsorder/CommonChange.vue`
3. **枚举定义**: `order-system/src/api/tool/enums` 中的 `TableName` 和 `moduleNames`
4. **通用混入**: `common_dialog` mixin

## 开发检查清单

开发完成后，确认以下事项：

- [ ] 所有函数都添加了 JSDocs 注释
- [ ] 所有数学计算都使用了 mathjs
- [ ] 表单初始化使用了函数返回新对象
- [ ] 检查并复用了现有的组件和逻辑
- [ ] 表格数据保持响应式
- [ ] 差额计算准确（修改后 - 修改前）
- [ ] 样式符合项目规范
- [ ] 弹窗宽度合适（建议 1500px）
- [ ] 关闭弹窗时正确清理数据

## 示例：完整的入库管理模板

详见 [InventoryChangeTemplate.md](./templates/InventoryChangeTemplate.md)

## 调试建议

1. 使用 `console.log` 或 `this.$log` 输出中间数据
2. 检查 `compareData` 的数据结构是否正确
3. 验证 mathjs 计算结果的精度
4. 测试多条记录的展示效果
5. 检查差额行的高亮样式
