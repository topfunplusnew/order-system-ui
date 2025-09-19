// 简化的 IndexedDB 封装：专用于存储公司ID和"已操作"标记

const DB_NAME = 'order-system-db';
const DB_VERSION = 2; // 增加版本号以触发数据库升级
const STORE_OPERATED = 'company_operated'; // 重命名存储表

function openDB() {
	return new Promise((resolve, reject) => {
		const request = window.indexedDB.open(DB_NAME, DB_VERSION);
		request.onupgradeneeded = e => {
			const db = e.target.result;

			// 删除旧的存储表（如果存在）
			if (db.objectStoreNames.contains('excel_templates')) {
				db.deleteObjectStore('excel_templates');
			}

			// 创建新的存储表，使用公司ID作为主键
			if (!db.objectStoreNames.contains(STORE_OPERATED)) {
				const store = db.createObjectStore(STORE_OPERATED, { keyPath: 'companyId' });
				// 不需要额外的索引，因为主键就是公司ID
			}
		};
		request.onsuccess = e => resolve(e.target.result);
		request.onerror = e => reject(e.target.error);
	});
}

function promisifyRequest(req) {
	return new Promise((resolve, reject) => {
		req.onsuccess = e => resolve(e.target.result);
		req.onerror = e => reject(e.target.error);
	});
}

function waitTransaction(tx) {
	return new Promise((resolve, reject) => {
		tx.oncomplete = () => resolve();
		tx.onabort = e => reject(e.target.error || new Error('Transaction aborted'));
		tx.onerror = e => reject(e.target.error || new Error('Transaction error'));
	});
}

// 从模板行中提取公司ID（优先sellerId，否则purchaseId）
export function extractCompanyId(templateRow) {
	if (!templateRow) return null;

	// 优先使用sellerId（如果非0）
	if (templateRow.sellerId && Number(templateRow.sellerId) !== 0) {
		return Number(templateRow.sellerId);
	}

	// 否则使用purchaseId（如果非0）
	if (templateRow.purchaseId && Number(templateRow.purchaseId) !== 0) {
		return Number(templateRow.purchaseId);
	}

	return null;
}

// 清空所有已操作记录
export async function clearAllOperatedRecords() {
	console.log('clearAllOperatedRecords: 开始清空所有已操作记录');
	const db = await openDB();
	const tx = db.transaction([STORE_OPERATED], 'readwrite');
	const store = tx.objectStore(STORE_OPERATED);

	await new Promise((resolve, reject) => {
		const req = store.clear();
		req.onsuccess = () => {
			console.log('clearAllOperatedRecords: 清空完成');
			resolve();
		};
		req.onerror = e => reject(e.target.error);
	});

	await waitTransaction(tx);
	db.close();
}

// 导入模板数据，提取公司ID并初始化已操作状态
export async function importTemplateCompanies(templateList = []) {
	console.log('importTemplateCompanies: 开始导入模板公司数据', templateList.length);

	// 先清空所有现有数据
	await clearAllOperatedRecords();

	const db = await openDB();
	const tx = db.transaction([STORE_OPERATED], 'readwrite');
	const store = tx.objectStore(STORE_OPERATED);

	// 用于去重的Set
	const companyIds = new Set();

	for (const tpl of templateList) {
		const companyId = extractCompanyId(tpl);
		if (companyId && !companyIds.has(companyId)) {
			companyIds.add(companyId);
			const record = {
				companyId: companyId,
				operated: false
			};
			// put 可新增或更新（如果主键重复则更新）
			store.put(record);
		}
	}

	await waitTransaction(tx);
	db.close();

	console.log('importTemplateCompanies: 导入完成，共处理', companyIds.size, '个公司');
}

// 根据公司ID标记为已操作
export async function markCompanyOperated(companyId) {
	if (!companyId) {
		console.warn('markCompanyOperated: 缺少公司ID参数');
		return;
	}

	console.log('markCompanyOperated: 开始标记公司为已操作', companyId);

	const db = await openDB();
	const tx = db.transaction([STORE_OPERATED], 'readwrite');
	const store = tx.objectStore(STORE_OPERATED);

	try {
		// 先检查记录是否存在
		const getReq = store.get(companyId);
		const existingRecord = await promisifyRequest(getReq);

		if (existingRecord) {
			// 更新现有记录
			existingRecord.operated = true;
			store.put(existingRecord);
			console.log('markCompanyOperated: 更新现有记录', companyId);
		} else {
			// 创建新记录
			const newRecord = {
				companyId: companyId,
				operated: true
			};
			store.put(newRecord);
			console.log('markCompanyOperated: 创建新记录', companyId);
		}

		await waitTransaction(tx);
		console.log('markCompanyOperated: 标记完成', companyId);
	} catch (error) {
		console.error('markCompanyOperated: 标记失败', companyId, error);
		throw error;
	} finally {
		db.close();
	}
}

// 根据公司ID数组批量标记为已操作
export async function markCompaniesOperated(companyIds) {
	if (!companyIds || !Array.isArray(companyIds) || companyIds.length === 0) {
		console.warn('markCompaniesOperated: 缺少公司ID数组参数');
		return;
	}

	console.log('markCompaniesOperated: 开始批量标记', companyIds);

	const db = await openDB();
	const tx = db.transaction([STORE_OPERATED], 'readwrite');
	const store = tx.objectStore(STORE_OPERATED);

	for (const companyId of companyIds) {
		if (companyId) {
			try {
				const getReq = store.get(companyId);
				const existingRecord = await promisifyRequest(getReq);

				if (existingRecord) {
					existingRecord.operated = true;
					store.put(existingRecord);
				} else {
					const newRecord = {
						companyId: companyId,
						operated: true
					};
					store.put(newRecord);
				}
			} catch (error) {
				console.error('markCompaniesOperated: 标记公司失败', companyId, error);
			}
		}
	}

	await waitTransaction(tx);
	db.close();

	console.log('markCompaniesOperated: 批量标记完成');
}

// 获取所有已操作状态映射（以公司ID为键）
export async function getOperatedMap() {
	console.log('getOperatedMap: 开始获取已操作状态映射');

	const db = await openDB();
	const tx = db.transaction([STORE_OPERATED], 'readonly');
	const store = tx.objectStore(STORE_OPERATED);
	const operatedMap = {};

	await new Promise((resolve, reject) => {
		const req = store.openCursor();
		req.onsuccess = e => {
			const cursor = e.target.result;
			if (cursor) {
				const rec = cursor.value;
				operatedMap[rec.companyId] = !!rec.operated;
				cursor.continue();
			} else resolve();
		};
		req.onerror = e => reject(e.target.error);
	});

	await waitTransaction(tx);
	db.close();

	console.log('getOperatedMap: 获取完成', operatedMap);
	return operatedMap;
}

// 调试函数：查看所有已操作记录
export async function debugGetAllOperatedRecords() {
	console.log('debugGetAllOperatedRecords: 开始获取所有已操作记录');

	const db = await openDB();
	const tx = db.transaction([STORE_OPERATED], 'readonly');
	const store = tx.objectStore(STORE_OPERATED);
	const records = [];

	await new Promise((resolve, reject) => {
		const req = store.openCursor();
		req.onsuccess = e => {
			const cursor = e.target.result;
			if (cursor) {
				records.push(cursor.value);
				cursor.continue();
			} else resolve();
		};
		req.onerror = e => reject(e.target.error);
	});

	await waitTransaction(tx);
	db.close();

	console.log('debugGetAllOperatedRecords: 所有记录:', records);
	return records;
}
