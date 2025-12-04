/**
 * IndexDB 操作 API
 * 提供简单明了的浏览器 IndexDB 数据库操作接口
 */

class IndexDBHelper {
	constructor(dbName = 'OrderSystemDB', version = 1) {
		this.dbName = dbName;
		this.version = version;
		this.db = null;
	}

	/**
	 * 初始化数据库
	 * @param {Object} config - 数据库配置
	 * @param {Array} config.stores - 对象存储配置数组
	 * @returns {Promise<IDBDatabase>}
	 */
	async init(config = {}) {
		return new Promise((resolve, reject) => {
			const request = indexedDB.open(this.dbName, this.version);

			request.onerror = () => {
				reject(new Error(`IndexDB 打开失败: ${request.error}`));
			};

			request.onsuccess = event => {
				this.db = event.target.result;
				resolve(this.db);
			};

			request.onupgradeneeded = event => {
				const db = event.target.result;
				this.db = db;

				// 创建对象存储
				if (config.stores && Array.isArray(config.stores)) {
					config.stores.forEach(store => {
						this.createStore(db, store);
					});
				}
			};
		});
	}

	/**
	 * 创建对象存储
	 * @param {IDBDatabase} db - 数据库实例
	 * @param {Object} storeConfig - 存储配置
	 */
	createStore(db, storeConfig) {
		const { name, keyPath = 'id', autoIncrement = true, indexes = [] } = storeConfig;

		// 如果存储已存在，先删除
		if (db.objectStoreNames.contains(name)) {
			db.deleteObjectStore(name);
		}

		// 创建对象存储
		const objectStore = db.createObjectStore(name, {
			keyPath,
			autoIncrement
		});

		// 创建索引
		indexes.forEach(index => {
			const { name: indexName, keyPath: indexKeyPath, options = {} } = index;
			objectStore.createIndex(indexName, indexKeyPath, options);
		});
	}

	/**
	 * 添加数据
	 * @param {string} storeName - 存储名称
	 * @param {Object|Array} data - 要添加的数据
	 * @returns {Promise}
	 */
	async add(storeName, data) {
		return this.executeTransaction(storeName, 'readwrite', store => {
			if (Array.isArray(data)) {
				return Promise.all(data.map(item => this.promisifyRequest(store.add(item))));
			} else {
				return this.promisifyRequest(store.add(data));
			}
		});
	}

	/**
	 * 更新数据 (put方法，如果不存在则添加)
	 * @param {string} storeName - 存储名称
	 * @param {Object|Array} data - 要更新的数据
	 * @returns {Promise}
	 */
	async put(storeName, data) {
		return this.executeTransaction(storeName, 'readwrite', store => {
			if (Array.isArray(data)) {
				return Promise.all(data.map(item => this.promisifyRequest(store.put(item))));
			} else {
				return this.promisifyRequest(store.put(data));
			}
		});
	}

	/**
	 * 根据主键获取数据
	 * @param {string} storeName - 存储名称
	 * @param {any} key - 主键
	 * @returns {Promise}
	 */
	async get(storeName, key) {
		return this.executeTransaction(storeName, 'readonly', store => {
			return this.promisifyRequest(store.get(key));
		});
	}

	/**
	 * 获取所有数据
	 * @param {string} storeName - 存储名称
	 * @returns {Promise<Array>}
	 */
	async getAll(storeName) {
		return this.executeTransaction(storeName, 'readonly', store => {
			return this.promisifyRequest(store.getAll());
		});
	}

	/**
	 * 根据索引查询数据
	 * @param {string} storeName - 存储名称
	 * @param {string} indexName - 索引名称
	 * @param {any} value - 查询值
	 * @returns {Promise<Array>}
	 */
	async getByIndex(storeName, indexName, value) {
		return this.executeTransaction(storeName, 'readonly', store => {
			const index = store.index(indexName);
			return this.promisifyRequest(index.getAll(value));
		});
	}

	/**
	 * 删除数据
	 * @param {string} storeName - 存储名称
	 * @param {any} key - 主键
	 * @returns {Promise}
	 */
	async delete(storeName, key) {
		return this.executeTransaction(storeName, 'readwrite', store => {
			return this.promisifyRequest(store.delete(key));
		});
	}

	/**
	 * 清空存储
	 * @param {string} storeName - 存储名称
	 * @returns {Promise}
	 */
	async clear(storeName) {
		return this.executeTransaction(storeName, 'readwrite', store => {
			return this.promisifyRequest(store.clear());
		});
	}

	/**
	 * 统计数据条数
	 * @param {string} storeName - 存储名称
	 * @returns {Promise<number>}
	 */
	async count(storeName) {
		return this.executeTransaction(storeName, 'readonly', store => {
			return this.promisifyRequest(store.count());
		});
	}

	/**
	 * 分页查询
	 * @param {string} storeName - 存储名称
	 * @param {Object} options - 分页选项
	 * @param {number} options.page - 页码（从1开始）
	 * @param {number} options.pageSize - 每页大小
	 * @param {string} options.indexName - 索引名称（可选）
	 * @param {IDBKeyRange} options.range - 查询范围（可选）
	 * @returns {Promise<Object>}
	 */
	async paginate(storeName, options = {}) {
		const { page = 1, pageSize = 10, indexName, range } = options;

		return this.executeTransaction(storeName, 'readonly', async store => {
			const source = indexName ? store.index(indexName) : store;

			// 获取总数
			const total = await this.promisifyRequest(source.count(range));

			// 计算分页参数
			const offset = (page - 1) * pageSize;
			const totalPages = Math.ceil(total / pageSize);

			// 获取分页数据
			const items = [];
			const request = source.openCursor(range);

			return new Promise(resolve => {
				let currentIndex = 0;

				request.onsuccess = event => {
					const cursor = event.target.result;

					if (cursor) {
						if (currentIndex >= offset && items.length < pageSize) {
							items.push(cursor.value);
						}

						currentIndex++;

						if (items.length < pageSize && currentIndex < total) {
							cursor.continue();
						} else {
							resolve({
								items,
								total,
								page,
								pageSize,
								totalPages,
								hasNext: page < totalPages,
								hasPrev: page > 1
							});
						}
					} else {
						resolve({
							items,
							total,
							page,
							pageSize,
							totalPages,
							hasNext: false,
							hasPrev: page > 1
						});
					}
				};
			});
		});
	}

	/**
	 * 模糊查询
	 * @param {string} storeName - 存储名称
	 * @param {string} field - 查询字段
	 * @param {string} keyword - 关键词
	 * @returns {Promise<Array>}
	 */
	async search(storeName, field, keyword) {
		const allData = await this.getAll(storeName);
		return allData.filter(item => {
			const value = item[field];
			return value && value.toString().toLowerCase().includes(keyword.toLowerCase());
		});
	}

	/**
	 * 批量操作
	 * @param {string} storeName - 存储名称
	 * @param {Array} operations - 操作数组
	 * @returns {Promise}
	 */
	async batch(storeName, operations) {
		return this.executeTransaction(storeName, 'readwrite', async store => {
			const promises = operations.map(operation => {
				const { type, data, key } = operation;

				switch (type) {
					case 'add':
						return this.promisifyRequest(store.add(data));
					case 'put':
						return this.promisifyRequest(store.put(data));
					case 'delete':
						return this.promisifyRequest(store.delete(key));
					default:
						throw new Error(`不支持的操作类型: ${type}`);
				}
			});

			return Promise.all(promises);
		});
	}

	/**
	 * 执行事务
	 * @param {string} storeName - 存储名称
	 * @param {string} mode - 事务模式
	 * @param {Function} callback - 回调函数
	 * @returns {Promise}
	 */
	async executeTransaction(storeName, mode, callback) {
		if (!this.db) {
			throw new Error('数据库未初始化，请先调用 init() 方法');
		}

		const transaction = this.db.transaction([storeName], mode);
		const store = transaction.objectStore(storeName);

		return new Promise((resolve, reject) => {
			transaction.oncomplete = () => resolve();
			transaction.onerror = () => reject(transaction.error);
			transaction.onabort = () => reject(new Error('事务被中止'));

			try {
				const result = callback(store);
				if (result instanceof Promise) {
					result.then(resolve).catch(reject);
				} else {
					resolve(result);
				}
			} catch (error) {
				reject(error);
			}
		});
	}

	/**
	 * 将 IDBRequest 转换为 Promise
	 * @param {IDBRequest} request - IDB请求对象
	 * @returns {Promise}
	 */
	promisifyRequest(request) {
		return new Promise((resolve, reject) => {
			request.onsuccess = () => resolve(request.result);
			request.onerror = () => reject(request.error);
		});
	}

	/**
	 * 关闭数据库连接
	 */
	close() {
		if (this.db) {
			this.db.close();
			this.db = null;
		}
	}

	/**
	 * 删除数据库
	 * @returns {Promise}
	 */
	async deleteDatabase() {
		this.close();

		return new Promise((resolve, reject) => {
			const deleteRequest = indexedDB.deleteDB(this.dbName);

			deleteRequest.onsuccess = () => resolve();
			deleteRequest.onerror = () => reject(deleteRequest.error);
			deleteRequest.onblocked = () => {
				console.warn('数据库删除被阻塞，请关闭其他使用该数据库的标签页');
			};
		});
	}
}

// 创建默认实例
const indexDB = new IndexDBHelper();

// 导出类和默认实例
export { IndexDBHelper, indexDB };

// 默认导出
export default indexDB;
