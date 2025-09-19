// 简化的 IndexedDB 封装：专用于存储公司ID和"已操作"标记

const DB_NAME = 'order-system-db';
const DB_VERSION = 3; // 增加版本号以触发数据库升级
const STORE_OPERATED = 'company_operated'; // 重命名存储表
const STORE_SHEETS = 'sheet_operated'; // 新增：存储已操作的Sheet信息

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
			
			// 创建Sheet操作记录表，使用复合键作为主键
			if (!db.objectStoreNames.contains(STORE_SHEETS)) {
				const sheetStore = db.createObjectStore(STORE_SHEETS, { keyPath: 'sheetKey' });
				// 添加索引以便查询
				sheetStore.createIndex('fileId', 'fileId', { unique: false });
				sheetStore.createIndex('sheetName', 'sheetName', { unique: false });
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

// 导入模板数据，提取公司ID并初始化已操作状态（新文件导入时清空所有数据）
export async function importTemplateCompanies(templateList = [], fileId = null) {
	console.log('importTemplateCompanies: 开始导入模板公司数据', templateList.length);

	// 先清空所有现有数据
	await clearAllOperatedRecords();
	
	// 如果提供了文件ID，清空该文件的所有Sheet操作记录
	if (fileId) {
		await clearSheetRecordsByFileId(fileId);
	}

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

// 更新模板数据，提取公司ID并更新已操作状态（同一文件的不同工作表，不清空现有数据）
export async function updateTemplateCompanies(templateList = []) {
	console.log('updateTemplateCompanies: 开始更新模板公司数据', templateList.length);

	const db = await openDB();
	const tx = db.transaction([STORE_OPERATED], 'readwrite');
	const store = tx.objectStore(STORE_OPERATED);

	// 用于去重的Set
	const companyIds = new Set();

	for (const tpl of templateList) {
		const companyId = extractCompanyId(tpl);
		if (companyId && !companyIds.has(companyId)) {
			companyIds.add(companyId);
			
			// 检查是否已存在该公司的记录
			try {
				const existingRecord = await promisifyRequest(store.get(companyId));
				if (existingRecord) {
					// 如果已存在，保持原有的 operated 状态
					console.log(`updateTemplateCompanies: 公司 ${companyId} 已存在，保持原有状态:`, existingRecord.operated);
				} else {
					// 如果不存在，创建新记录
					const record = {
						companyId: companyId,
						operated: false
					};
					store.put(record);
					console.log(`updateTemplateCompanies: 新增公司 ${companyId}`);
				}
			} catch (error) {
				console.error(`updateTemplateCompanies: 处理公司 ${companyId} 时出错:`, error);
			}
		}
	}

	await waitTransaction(tx);
	db.close();
	console.log('updateTemplateCompanies: 更新完成，共处理', companyIds.size, '个公司');
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

// ==================== Sheet 操作相关函数 ====================

// 生成Sheet的唯一键
function generateSheetKey(fileId, sheetName) {
	return `${fileId}::${sheetName}`;
}

// 检查Sheet是否已被操作过
export async function isSheetOperated(fileId, sheetName) {
	if (!fileId || !sheetName) {
		console.warn('isSheetOperated: 缺少必要参数');
		return false;
	}
	
	console.log('isSheetOperated: 检查Sheet是否已操作', fileId, sheetName);
	const db = await openDB();
	const tx = db.transaction([STORE_SHEETS], 'readonly');
	const store = tx.objectStore(STORE_SHEETS);
	
	try {
		const sheetKey = generateSheetKey(fileId, sheetName);
		const record = await promisifyRequest(store.get(sheetKey));
		const isOperated = !!(record && record.operated);
		console.log('isSheetOperated: 结果', isOperated);
		return isOperated;
	} catch (error) {
		console.error('isSheetOperated: 检查失败', error);
		return false;
	} finally {
		await waitTransaction(tx);
		db.close();
	}
}

// 标记Sheet为已操作
export async function markSheetOperated(fileId, sheetName) {
	if (!fileId || !sheetName) {
		console.warn('markSheetOperated: 缺少必要参数');
		return;
	}
	
	console.log('markSheetOperated: 标记Sheet为已操作', fileId, sheetName);
	const db = await openDB();
	const tx = db.transaction([STORE_SHEETS], 'readwrite');
	const store = tx.objectStore(STORE_SHEETS);
	
	try {
		const sheetKey = generateSheetKey(fileId, sheetName);
		const record = {
			sheetKey: sheetKey,
			fileId: fileId,
			sheetName: sheetName,
			operated: true,
			operatedAt: Date.now()
		};
		store.put(record);
		await waitTransaction(tx);
		console.log('markSheetOperated: 标记完成', sheetKey);
	} catch (error) {
		console.error('markSheetOperated: 标记失败', error);
		throw error;
	} finally {
		db.close();
	}
}

// 清空指定文件的所有Sheet操作记录
export async function clearSheetRecordsByFileId(fileId) {
	if (!fileId) {
		console.warn('clearSheetRecordsByFileId: 缺少文件ID参数');
		return;
	}
	
	console.log('clearSheetRecordsByFileId: 清空文件Sheet记录', fileId);
	const db = await openDB();
	const tx = db.transaction([STORE_SHEETS], 'readwrite');
	const store = tx.objectStore(STORE_SHEETS);
	const index = store.index('fileId');
	
	try {
		// 获取所有匹配的记录
		const records = await new Promise((resolve, reject) => {
			const req = index.getAll(fileId);
			req.onsuccess = () => resolve(req.result);
			req.onerror = e => reject(e.target.error);
		});
		
		// 删除所有匹配的记录
		for (const record of records) {
			store.delete(record.sheetKey);
		}
		
		await waitTransaction(tx);
		console.log('clearSheetRecordsByFileId: 清空完成，删除了', records.length, '条记录');
	} catch (error) {
		console.error('clearSheetRecordsByFileId: 清空失败', error);
		throw error;
	} finally {
		db.close();
	}
}

// 获取指定文件的所有已操作Sheet列表
export async function getOperatedSheetsByFileId(fileId) {
	if (!fileId) {
		console.warn('getOperatedSheetsByFileId: 缺少文件ID参数');
		return [];
	}
	
	console.log('getOperatedSheetsByFileId: 获取文件已操作Sheet列表', fileId);
	const db = await openDB();
	const tx = db.transaction([STORE_SHEETS], 'readonly');
	const store = tx.objectStore(STORE_SHEETS);
	const index = store.index('fileId');
	
	try {
		const records = await new Promise((resolve, reject) => {
			const req = index.getAll(fileId);
			req.onsuccess = () => resolve(req.result);
			req.onerror = e => reject(e.target.error);
		});
		
		const operatedSheets = records
			.filter(record => record.operated)
			.map(record => record.sheetName);
		
		console.log('getOperatedSheetsByFileId: 已操作Sheet列表', operatedSheets);
		return operatedSheets;
	} catch (error) {
		console.error('getOperatedSheetsByFileId: 获取失败', error);
		return [];
	} finally {
		await waitTransaction(tx);
		db.close();
	}
}

// 调试：获取所有Sheet操作记录
export async function debugGetAllSheetRecords() {
	console.log('debugGetAllSheetRecords: 开始获取所有Sheet操作记录');
	const db = await openDB();
	const tx = db.transaction([STORE_SHEETS], 'readonly');
	const store = tx.objectStore(STORE_SHEETS);
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
	
	console.log('debugGetAllSheetRecords: 所有Sheet记录:', records);
	return records;
}
