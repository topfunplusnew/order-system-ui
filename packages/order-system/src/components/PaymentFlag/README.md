# PaymentFlag 组件使用说明

## 概述

PaymentFlag 是一个用于展示付款状态和付款申请状态的 Vue 组件。它可以智能识别业务对象中的付款信息，并以标签形式展示相应的状态。

## 功能特性

-   ✅ **智能状态识别**：自动识别 payment 和 paymentApply 对象
-   ✅ **多状态支持**：支持付款状态和付款申请的各种审核状态
-   ✅ **可扩展设计**：提供插槽支持自定义扩展
-   ✅ **类型安全**：完善的属性验证和边界条件处理
-   ✅ **响应式设计**：支持多种尺寸和主题适配

## API 文档

### Props

| 参数               | 类型     | 必填 | 默认值    | 说明                                          |
| ------------------ | -------- | ---- | --------- | --------------------------------------------- |
| businessObject     | Object   | ✅   | `{}`      | 业务对象，包含 payment 或 paymentApply 属性   |
| showDetail         | Boolean  | ❌   | `false`   | 是否显示详细信息（预留扩展）                  |
| size               | String   | ❌   | `'small'` | 标签尺寸：`'mini'` \| `'small'` \| `'medium'` |
| customStatusFn     | Function | ❌   | `null`    | 自定义状态判断函数                            |
| customStatusStyles | Object   | ❌   | `{}`      | 自定义状态样式映射                            |

### 业务对象结构

#### Payment 对象结构

```javascript
{
  payment: {
    paymentState: "已支付" | "未支付",
    // ... 其他字段
  }
}
```

#### PaymentApply 对象结构

```javascript
{
  paymentApply: {
    checkState: "待提交" | "审核中" | "通过" | "未通过" | "驳回" | "作废" | "未申请",
    // ... 其他字段
  }
}
```

### 插槽

| 名称  | 说明         | 作用域插槽参数     |
| ----- | ------------ | ------------------ |
| extra | 扩展内容插槽 | `{ status, type }` |

#### 作用域插槽参数说明

-   `status`: 当前状态值
-   `type`: 状态类型（'payment' | 'paymentApply' | 'unknown'）

### 状态映射

#### 付款状态 (Payment)

| 状态值 | 显示文本 | 标签类型 | 颜色    |
| ------ | -------- | -------- | ------- |
| 已支付 | 已支付   | success  | #67C23A |
| 未支付 | 未支付   | danger   | #F56C6C |

#### 付款申请状态 (PaymentApply)

| 状态值 | 显示文本   | 标签类型 | 颜色    |
| ------ | ---------- | -------- | ------- |
| 待提交 | 待提交     | info     | #909399 |
| 审核中 | 审核中     | warning  | #E6A23C |
| 通过   | 审核通过   | success  | #67C23A |
| 未通过 | 审核未通过 | danger   | #F56C6C |
| 驳回   | 已驳回     | danger   | #F56C6C |
| 作废   | 已作废     | info     | #909399 |
| 未申请 | 未申请     | info     | #C0C4CC |

## 使用示例

### 基础用法

```vue
<template>
	<div>
		<!-- 显示付款状态 -->
		<PaymentFlag :business-object="orderItem" />
	</div>
</template>

<script>
import PaymentFlag from '@/components/PaymentFlag';

export default {
	components: {
		PaymentFlag
	},
	data() {
		return {
			orderItem: {
				payment: {
					paymentState: '已支付'
					// ... 其他字段
				}
			}
		};
	}
};
</script>
```

### 自定义尺寸

```vue
<template>
	<div>
		<!-- 小尺寸 -->
		<PaymentFlag :business-object="orderItem" size="mini" />

		<!-- 中等尺寸 -->
		<PaymentFlag :business-object="orderItem" size="medium" />
	</div>
</template>
```

### 使用插槽扩展

```vue
<template>
	<div>
		<PaymentFlag :business-object="orderItem">
			<template #extra="{ status, type }">
				<el-button v-if="type === 'paymentApply' && status === '待提交'" type="primary" size="mini" @click="handleSubmitApply">提交申请</el-button>

				<el-button v-if="type === 'payment' && status === '未支付'" type="warning" size="mini" @click="handlePayment">去付款</el-button>
			</template>
		</PaymentFlag>
	</div>
</template>

<script>
export default {
	methods: {
		handleSubmitApply() {
			// 处理提交申请逻辑
			console.log('提交付款申请');
		},

		handlePayment() {
			// 处理付款逻辑
			console.log('去付款');
		}
	}
};
</script>
```

### 在表格中使用

```vue
<template>
	<el-table :data="tableData">
		<el-table-column label="订单号" prop="orderNo" />
		<el-table-column label="金额" prop="amount" />
		<el-table-column label="付款状态" width="120">
			<template slot-scope="scope">
				<PaymentFlag :business-object="scope.row" />
			</template>
		</el-table-column>
	</el-table>
</template>

<script>
import PaymentFlag from '@/components/PaymentFlag';

export default {
	components: {
		PaymentFlag
	},
	data() {
		return {
			tableData: [
				{
					orderNo: 'ORDER001',
					amount: 1000,
					payment: { paymentState: '已支付' }
				},
				{
					orderNo: 'ORDER002',
					amount: 2000,
					paymentApply: { checkState: '审核中' }
				}
			]
		};
	}
};
</script>
```

### 使用自定义状态判断函数

```vue
<template>
	<div>
		<PaymentFlag :business-object="orderItem" :custom-status-fn="customStatusFn" :custom-status-styles="customStyles" />
	</div>
</template>

<script>
import PaymentFlag from '@/components/PaymentFlag';

export default {
	components: {
		PaymentFlag
	},
	data() {
		return {
			orderItem: {
				payment: {
					/* 付款信息 */
				}
			}
		};
	},
	computed: {
		customStyles() {
			return {
				PAID: {
					color: '#67C23A'
				},
				UNPAID: {
					color: '#F56C6C'
				}
			};
		}
	},
	methods: {
		// 自定义状态判断函数
		customStatusFn(businessObject) {
			if (businessObject && businessObject.payment) {
				return {
					text: '已支付',
					type: 'success',
					status: 'PAID',
					statusType: 'payment'
				};
			} else {
				return {
					text: '未支付',
					type: 'danger',
					status: 'UNPAID',
					statusType: 'payment'
				};
			}
		}
	}
};
</script>
```

## 状态判断逻辑

组件按以下优先级判断状态：

1. **优先级 1**：检查 `businessObject.payment` 对象
    - 如果存在且有效，显示付款状态（已支付/未支付）
2. **优先级 2**：检查 `businessObject.paymentApply` 对象
    - 如果 payment 不存在，但 paymentApply 存在，显示付款申请状态
3. **默认状态**：如果两个对象都不存在
    - 显示"无状态"

## 最佳实践

### 1. 数据结构验证

在使用组件前，确保业务对象具有正确的数据结构：

```javascript
// ✅ 推荐：使用前验证数据
const isValidBusinessObject = (obj) => {
  return obj && (
    (obj.payment && obj.payment.paymentState) ||
    (obj.paymentApply && obj.paymentApply.checkState)
  );
};

// 在模板中条件渲染
<PaymentFlag v-if="isValidBusinessObject(orderItem)" :business-object="orderItem" />
```

### 2. 错误处理

```vue
<template>
	<div>
		<!-- 使用 v-if 防止运行时错误 -->
		<PaymentFlag v-if="orderItem && (orderItem.payment || orderItem.paymentApply)" :business-object="orderItem" />

		<!-- 提供默认显示 -->
		<span v-else class="no-status">暂无状态</span>
	</div>
</template>
```

### 3. 性能优化

对于大量数据的表格场景，考虑使用虚拟滚动：

```vue
<template>
	<!-- 大数据量表格建议使用虚拟滚动 -->
	<el-table-v2 :data="largeTableData">
		<el-table-v2-column>
			<template #cell="{ rowData }">
				<PaymentFlag :business-object="rowData" />
			</template>
		</el-table-v2-column>
	</el-table-v2>
</template>
```

### 4. 主题自定义

如果需要自定义主题颜色：

```vue
<style lang="scss">
.payment-flag {
	// 自定义成功状态颜色
	.el-tag--success {
		--el-tag-success-color: #4caf50;
	}

	// 自定义警告状态颜色
	.el-tag--warning {
		--el-tag-warning-color: #ff9800;
	}
}
</style>
```

## 常见问题

### Q1: 组件不显示状态怎么办？

**A**: 检查以下几点：

1. `businessObject` 是否传递正确
2. 对象中是否包含 `payment` 或 `paymentApply` 属性
3. 状态值是否符合枚举定义

### Q2: 如何扩展新的状态？

**A**: 修改 `getPaymentStatus` 或 `getPaymentApplyStatus` 方法，添加新的状态判断逻辑：

```javascript
// 在组件的 getPaymentApplyStatus 方法中添加
case 'NEW_STATUS':
  return {
    text: '新状态',
    type: 'primary',
    color: '#409EFF',
    status: 'NEW_STATUS',
    statusType: 'paymentApply'
  };
```

### Q3: 如何自定义状态颜色？

**A**: 通过 CSS 变量或直接修改组件的颜色映射：

```scss
// 方法1: CSS变量
:root {
	--payment-success-color: #4caf50;
	--payment-danger-color: #f44336;
}

// 方法2: 深度选择器
::v-deep .payment-status-tag.el-tag--success {
	background-color: #4caf50 !important;
}
```

## 版本历史

### v1.0.0 (2025-08-27)

-   ✨ 初始版本发布
-   ✨ 支持付款状态和付款申请状态展示
-   ✨ 提供插槽扩展能力
-   ✨ 支持多种尺寸配置

## 开发与维护

### 目录结构

```
PaymentFlag/
├── index.vue          # 主组件文件
├── README.md         # 使用说明文档（本文件）
└── __tests__/        # 单元测试目录（如需要）
    └── index.spec.js
```

### 相关枚举

-   `PAYMENT_STATE`: 付款状态枚举
-   `PAYMENT_APPLY_STATE.V2`: 付款申请状态枚举

### 依赖项

-   Vue 2.x
-   Element UI
-   @/api/tool/enums

---

如有问题或建议，请联系开发团队。
