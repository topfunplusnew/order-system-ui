// 简易 IndexedDB 封装：专用于存储每次导入的 Excel 模板行及“已操作”标记

const DB_NAME = 'order-system-db';
const DB_VERSION = 1;
const STORE_TEMPLATES = 'excel_templates';

function openDB() {
	return new Promise((resolve, reject) => {
		const request = window.indexedDB.open(DB_NAME, DB_VERSION);
		request.onupgradeneeded = e => {
			const db = e.target.result;
			if (!db.objectStoreNames.contains(STORE_TEMPLATES)) {
				const store = db.createObjectStore(STORE_TEMPLATES, { keyPath: 'id', autoIncrement: true });
				store.createIndex('version', 'version', { unique: false });
				store.createIndex('vk', 'vk', { unique: true }); // 组合键：version::uniqueKey
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

function makeVK(version, uniqueKey) {
	return `${version}::${uniqueKey}`;
}

export function makeUniqueKeyByTemplate(templateRow) {
	// 约定：优先 sellerId，否则 purchaseId；再拼接 companyName 或 us
	const id = templateRow.sellerId && Number(templateRow.sellerId) !== 0 ? templateRow.sellerId : templateRow.purchaseId || 0;
	const name = templateRow.sellerName || templateRow.purchaseName || templateRow.invoiceCompanyName || '';
	return `${id}::${name}`;
}

export function makeUniqueKeyByIdName(id, name) {
	return `${id || 0}::${name || ''}`;
}

export async function upsertTemplates(version, templateList = []) {
	const db = await openDB();
	const tx = db.transaction([STORE_TEMPLATES], 'readwrite');
	const store = tx.objectStore(STORE_TEMPLATES);
	for (const tpl of templateList) {
		const uniqueKey = makeUniqueKeyByTemplate(tpl);
		const vk = makeVK(version, uniqueKey);
		const record = {
			vk,
			version,
			uniqueKey,
			operated: false,
			data: tpl
		};
		// put 可新增或更新
		store.put(record);
	}
	await waitTransaction(tx);
	db.close();
}

export async function markOperated(version, uniqueKeys = []) {
	if (!uniqueKeys || uniqueKeys.length === 0) return;
	const db = await openDB();
	const tx = db.transaction([STORE_TEMPLATES], 'readwrite');
	const store = tx.objectStore(STORE_TEMPLATES);
	const index = store.index('vk');
	for (const uk of uniqueKeys) {
		const vk = makeVK(version, uk);
		try {
			const getReq = index.get(vk);
			// eslint-disable-next-line no-await-in-loop
			const rec = await promisifyRequest(getReq);
			if (rec) {
				rec.operated = true;
				store.put(rec);
			}
		} catch (_) {}
	}
	await waitTransaction(tx);
	db.close();
}

export async function getOperatedMap(version) {
	const db = await openDB();
	const tx = db.transaction([STORE_TEMPLATES], 'readonly');
	const store = tx.objectStore(STORE_TEMPLATES);
	const idx = store.index('version');
	const range = IDBKeyRange.only(version);
	const operatedMap = {};
	await new Promise((resolve, reject) => {
		const req = idx.openCursor(range);
		req.onsuccess = e => {
			const cursor = e.target.result;
			if (cursor) {
				const rec = cursor.value;
				operatedMap[rec.uniqueKey] = !!rec.operated;
				cursor.continue();
			} else resolve();
		};
		req.onerror = e => reject(e.target.error);
	});
	await waitTransaction(tx);
	db.close();
	return operatedMap;
}

export async function clearVersion(version) {
	const db = await openDB();
	const tx = db.transaction([STORE_TEMPLATES], 'readwrite');
	const store = tx.objectStore(STORE_TEMPLATES);
	const idx = store.index('version');
	const range = IDBKeyRange.only(version);
	await new Promise((resolve, reject) => {
		const req = idx.openCursor(range);
		req.onsuccess = e => {
			const cursor = e.target.result;
			if (cursor) {
				store.delete(cursor.primaryKey);
				cursor.continue();
			} else resolve();
		};
		req.onerror = e => reject(e.target.error);
	});
	await waitTransaction(tx);
	db.close();
}
