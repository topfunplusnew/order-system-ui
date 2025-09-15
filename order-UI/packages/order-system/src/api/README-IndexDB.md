# IndexDB API 使用说明

一套简单明了的浏览器 IndexDB 操作 API，提供完整的数据库操作功能。

## 快速开始

### 1. 导入 API

```javascript
import indexDB from './indexdb.js';
// 或者导入管理器类
import { OrderManager, CompanyManager, InvoiceManager } from './indexdb-usage-examples.js';
```

### 2. 初始化数据库

```javascript
await indexDB.init({
	stores: [
		{
			name: 'orders',
			keyPath: 'id',
			autoIncrement: true,
			indexes: [
				{ name: 'status', keyPath: 'status' },
				{ name: 'companyId', keyPath: 'companyId' }
			]
		}
	]
});
```

## 核心功能

### 基本 CRUD 操作

```javascript
// 添加数据
const id = await indexDB.add('orders', { name: '订单1', status: 'pending' });

// 查询数据
const order = await indexDB.get('orders', id);

// 更新数据
await indexDB.put('orders', { id, name: '订单1-修改', status: 'completed' });

// 删除数据
await indexDB.delete('orders', id);

// 获取所有数据
const allOrders = await indexDB.getAll('orders');

// 清空表
await indexDB.clear('orders');
```

### 索引查询

```javascript
// 根据索引查询
const pendingOrders = await indexDB.getByIndex('orders', 'status', 'pending');

// 分页查询
const pageResult = await indexDB.paginate('orders', {
	page: 1,
	pageSize: 10,
	indexName: 'status',
	range: IDBKeyRange.only('pending')
});
```

### 模糊搜索

```javascript
// 搜索订单名称包含"订单"的记录
const results = await indexDB.search('orders', 'name', '订单');
```

### 批量操作

```javascript
// 批量添加
await indexDB.add('orders', [
	{ name: '订单1', status: 'pending' },
	{ name: '订单2', status: 'processing' }
]);

// 批量混合操作
await indexDB.batch('orders', [
	{ type: 'add', data: { name: '订单3', status: 'new' } },
	{ type: 'put', data: { id: 1, name: '订单1-更新', status: 'completed' } },
	{ type: 'delete', key: 2 }
]);
```

### 统计功能

```javascript
// 统计数据条数
const count = await indexDB.count('orders');
```

## 业务管理器

项目提供了针对业务场景的管理器类：

### 订单管理

```javascript
// 创建订单
const orderId = await OrderManager.createOrder({
	orderNumber: 'ORD001',
	companyId: 1,
	amount: 1000
});

// 获取订单列表（分页）
const orders = await OrderManager.getOrderList(1, 20, 'pending');

// 更新订单状态
await OrderManager.updateOrderStatus(orderId, 'completed');

// 搜索订单
const searchResults = await OrderManager.searchOrders('ORD001');
```

### 公司管理

```javascript
// 添加公司
await CompanyManager.addCompany({
	name: '测试公司',
	code: 'TEST001',
	address: '测试地址'
});

// 获取公司列表
const companies = await CompanyManager.getCompanyList();

// 根据代码查找公司
const company = await CompanyManager.findByCode('TEST001');
```

### 发票管理

```javascript
// 批量生成发票
await InvoiceManager.batchCreateInvoices([
	{ invoiceId: 'INV001', orderId: 1, amount: 1000 },
	{ invoiceId: 'INV002', orderId: 2, amount: 2000 }
]);

// 获取订单相关发票
const invoices = await InvoiceManager.getInvoicesByOrderId(1);
```

## 高级功能

### 自定义事务

```javascript
await indexDB.executeTransaction('orders', 'readwrite', async store => {
	// 在同一事务中执行多个操作
	const order1 = await indexDB.promisifyRequest(store.add(data1));
	const order2 = await indexDB.promisifyRequest(store.add(data2));

	// 所有操作要么全部成功，要么全部失败
});
```

### 数据库管理

```javascript
// 关闭数据库连接
indexDB.close();

// 删除整个数据库
await indexDB.deleteDatabase();
```

## 错误处理

```javascript
try {
	await indexDB.add('orders', orderData);
} catch (error) {
	console.error('操作失败:', error.message);
}
```

## 配置选项

### 数据库配置

-   `dbName`: 数据库名称（默认：'OrderSystemDB'）
-   `version`: 数据库版本（默认：1）

### 存储配置

-   `name`: 存储名称（必需）
-   `keyPath`: 主键字段（默认：'id'）
-   `autoIncrement`: 是否自增（默认：true）
-   `indexes`: 索引配置数组

### 索引配置

-   `name`: 索引名称
-   `keyPath`: 索引字段
-   `options`: 索引选项（如 unique: true）

## 注意事项

1. **初始化**: 使用任何操作前必须先调用 `init()` 方法
2. **异步操作**: 所有方法都返回 Promise，需要使用 async/await
3. **事务性**: 复杂操作建议使用事务确保数据一致性
4. **浏览器兼容性**: 需要浏览器支持 IndexDB API
5. **数据结构**: 建议为每个存储设计合理的索引以提高查询性能

## 示例演示

查看 `indexdb-usage-examples.js` 文件中的完整使用示例，包含：

-   基本操作演示
-   分页查询示例
-   模糊搜索示例
-   批量操作示例
-   事务处理示例
-   数据清理示例
-   完整业务场景实现

运行演示：

```javascript
import { runIndexDBDemo } from './indexdb-usage-examples.js';
await runIndexDBDemo();
```
