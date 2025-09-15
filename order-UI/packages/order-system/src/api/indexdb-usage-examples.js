// IndexDB API 使用示例

import indexDB from './indexdb.js';

// ================== 基本使用示例 ==================

async function basicUsageExample() {
	try {
		// 1. 初始化数据库
		await indexDB.init({
			stores: [
				{
					name: 'orders',
					keyPath: 'id',
					autoIncrement: true,
					indexes: [
						{ name: 'status', keyPath: 'status' },
						{ name: 'companyId', keyPath: 'companyId' },
						{ name: 'createTime', keyPath: 'createTime' }
					]
				},
				{
					name: 'companies',
					keyPath: 'id',
					autoIncrement: true,
					indexes: [
						{ name: 'name', keyPath: 'name' },
						{ name: 'code', keyPath: 'code' }
					]
				},
				{
					name: 'invoices',
					keyPath: 'invoiceId',
					autoIncrement: false,
					indexes: [
						{ name: 'orderId', keyPath: 'orderId' },
						{ name: 'status', keyPath: 'status' }
					]
				}
			]
		});

		console.log('数据库初始化成功');

		// 2. 添加数据
		const newOrder = {
			orderNumber: 'ORD001',
			companyId: 1,
			amount: 1000,
			status: 'pending',
			createTime: new Date().toISOString()
		};

		const orderId = await indexDB.add('orders', newOrder);
		console.log('订单添加成功，ID:', orderId);

		// 3. 批量添加数据
		const companies = [
			{ name: '公司A', code: 'COMP001', address: '地址A' },
			{ name: '公司B', code: 'COMP002', address: '地址B' },
			{ name: '公司C', code: 'COMP003', address: '地址C' }
		];

		await indexDB.add('companies', companies);
		console.log('公司批量添加成功');

		// 4. 查询数据
		const order = await indexDB.get('orders', orderId);
		console.log('查询到的订单:', order);

		// 5. 获取所有数据
		const allCompanies = await indexDB.getAll('companies');
		console.log('所有公司:', allCompanies);

		// 6. 根据索引查询
		const pendingOrders = await indexDB.getByIndex('orders', 'status', 'pending');
		console.log('待处理订单:', pendingOrders);

		// 7. 更新数据
		const updatedOrder = { ...order, status: 'processing', updateTime: new Date().toISOString() };
		await indexDB.put('orders', updatedOrder);
		console.log('订单状态更新成功');

		// 8. 统计数据
		const orderCount = await indexDB.count('orders');
		console.log('订单总数:', orderCount);
	} catch (error) {
		console.error('操作失败:', error);
	}
}

// ================== 分页查询示例 ==================

async function paginationExample() {
	try {
		// 分页查询订单
		const pageResult = await indexDB.paginate('orders', {
			page: 1,
			pageSize: 10,
			indexName: 'status',
			range: IDBKeyRange.only('pending')
		});

		console.log('分页查询结果:', {
			items: pageResult.items,
			total: pageResult.total,
			currentPage: pageResult.page,
			totalPages: pageResult.totalPages,
			hasNext: pageResult.hasNext,
			hasPrev: pageResult.hasPrev
		});
	} catch (error) {
		console.error('分页查询失败:', error);
	}
}

// ================== 模糊搜索示例 ==================

async function searchExample() {
	try {
		// 搜索公司名称包含"公司"的记录
		const searchResults = await indexDB.search('companies', 'name', '公司');
		console.log('搜索结果:', searchResults);

		// 搜索订单号包含"ORD"的记录
		const orderResults = await indexDB.search('orders', 'orderNumber', 'ORD');
		console.log('订单搜索结果:', orderResults);
	} catch (error) {
		console.error('搜索失败:', error);
	}
}

// ================== 批量操作示例 ==================

async function batchOperationExample() {
	try {
		// 批量操作
		const operations = [
			{
				type: 'add',
				data: {
					invoiceId: 'INV001',
					orderId: 1,
					amount: 1000,
					status: 'draft'
				}
			},
			{
				type: 'add',
				data: {
					invoiceId: 'INV002',
					orderId: 2,
					amount: 2000,
					status: 'sent'
				}
			},
			{
				type: 'put',
				data: {
					invoiceId: 'INV003',
					orderId: 3,
					amount: 1500,
					status: 'paid'
				}
			}
		];

		await indexDB.batch('invoices', operations);
		console.log('批量操作成功');

		// 查看结果
		const allInvoices = await indexDB.getAll('invoices');
		console.log('所有发票:', allInvoices);
	} catch (error) {
		console.error('批量操作失败:', error);
	}
}

// ================== 事务处理示例 ==================

async function transactionExample() {
	try {
		// 模拟一个业务场景：创建订单并生成发票
		const orderData = {
			orderNumber: 'ORD002',
			companyId: 2,
			amount: 5000,
			status: 'confirmed',
			createTime: new Date().toISOString()
		};

		// 使用自定义事务处理复杂业务
		await indexDB.executeTransaction('orders', 'readwrite', async store => {
			// 添加订单
			const addRequest = store.add(orderData);
			const orderId = await indexDB.promisifyRequest(addRequest);

			console.log('订单创建成功，ID:', orderId);

			// 在同一事务中处理其他相关操作
			// 这里可以添加更多业务逻辑
		});
	} catch (error) {
		console.error('事务处理失败:', error);
	}
}

// ================== 数据清理示例 ==================

async function cleanupExample() {
	try {
		// 清空特定表
		await indexDB.clear('invoices');
		console.log('发票表已清空');

		// 删除特定记录
		await indexDB.delete('orders', 1);
		console.log('订单删除成功');

		// 查看剩余数据
		const remainingOrders = await indexDB.getAll('orders');
		console.log('剩余订单:', remainingOrders);
	} catch (error) {
		console.error('清理操作失败:', error);
	}
}

// ================== 完整使用流程 ==================

export async function runIndexDBDemo() {
	console.log('=== IndexDB API 使用演示开始 ===');

	await basicUsageExample();
	await paginationExample();
	await searchExample();
	await batchOperationExample();
	await transactionExample();
	await cleanupExample();

	console.log('=== IndexDB API 使用演示结束 ===');

	// 关闭数据库连接
	indexDB.close();
}

// ================== 实际业务场景示例 ==================

// 订单管理相关操作
export const OrderManager = {
	// 创建订单
	async createOrder(orderData) {
		return await indexDB.add('orders', {
			...orderData,
			createTime: new Date().toISOString(),
			status: 'pending'
		});
	},

	// 获取订单列表（分页）
	async getOrderList(page = 1, pageSize = 20, status = null) {
		const options = { page, pageSize };

		if (status) {
			options.indexName = 'status';
			options.range = IDBKeyRange.only(status);
		}

		return await indexDB.paginate('orders', options);
	},

	// 更新订单状态
	async updateOrderStatus(orderId, status) {
		const order = await indexDB.get('orders', orderId);
		if (order) {
			order.status = status;
			order.updateTime = new Date().toISOString();
			return await indexDB.put('orders', order);
		}
		throw new Error('订单不存在');
	},

	// 搜索订单
	async searchOrders(keyword) {
		return await indexDB.search('orders', 'orderNumber', keyword);
	}
};

// 公司管理相关操作
export const CompanyManager = {
	// 添加公司
	async addCompany(companyData) {
		return await indexDB.add('companies', companyData);
	},

	// 获取公司列表
	async getCompanyList() {
		return await indexDB.getAll('companies');
	},

	// 根据公司代码查找
	async findByCode(code) {
		const companies = await indexDB.getByIndex('companies', 'code', code);
		return companies[0] || null;
	}
};

// 发票管理相关操作
export const InvoiceManager = {
	// 批量生成发票
	async batchCreateInvoices(invoiceDataList) {
		const operations = invoiceDataList.map(data => ({
			type: 'add',
			data: {
				...data,
				createTime: new Date().toISOString(),
				status: 'draft'
			}
		}));

		return await indexDB.batch('invoices', operations);
	},

	// 获取订单相关发票
	async getInvoicesByOrderId(orderId) {
		return await indexDB.getByIndex('invoices', 'orderId', orderId);
	}
};
