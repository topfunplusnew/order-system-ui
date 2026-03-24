// api/tool/user-config.js
/**
 * 用户配置键名枚举
 */
export const UserConfigKey = Object.freeze({
	// 订单搜索字段配置
	GOODS_SEARCH_COLUMNS: 'goodsSearch-columns',
	// 库存搜索字段配置
	INVENTORY_SEARCH_COLUMNS: 'inventorySearch-columns',
	// 订单列表列配置
	GOODS_ORDER_TABLE_COLUMNS: 'goodsOrder-table-columns',
	// 订单列表当前高亮行
	GOODS_ORDER_ACTIVE_ACTION_ROW: 'goodsOrder-active-action-row',
	// 订单运费列表当前高亮行
	ORDER_FREIGHT_ACTIVE_ACTION_ROW: 'orderfreight-active-action-row',
	// 库存列表列配置
	INVENTORY_TABLE_COLUMNS: 'inventory-table-columns',
	// 付款列表列配置
	PAYMENT_TABLE_COLUMNS: 'payment-table-columns',
	// 收款列表列配置
	RECEIVE_MONEY_TABLE_COLUMNS: 'receiveMoney-table-columns',
	// 客户列表列配置
	CUSTOMER_TABLE_COLUMNS: 'customer-table-columns',
	// 供应商列表列配置
	SUPPLIER_TABLE_COLUMNS: 'supplier-table-columns'
});

/**
 * 用户配置类型枚举
 */
export const UserConfigType = Object.freeze({
	// 列配置类型
	COLUMN_CONFIG: 'column_config',
	// 搜索字段配置类型
	SEARCH_FIELD_CONFIG: 'search_field_config',
	// 表格配置类型
	TABLE_CONFIG: 'table_config',
	// 仪表板配置类型
	DASHBOARD_CONFIG: 'dashboard_config',
	// 主题配置类型
	THEME_CONFIG: 'theme_config',
	// 语言配置类型
	LANGUAGE_CONFIG: 'language_config'
});

/**
 * 用户配置模块名称枚举
 */
export const UserConfigModule = Object.freeze({
	// 订单模块
	GOODS_ORDER: 'goodsorder',
	// 库存模块
	INVENTORY: 'inventory',
	// 付款模块
	PAYMENT: 'payment',
	// 收款模块
	RECEIVE_MONEY: 'receivemoney',
	// 客户模块
	CUSTOMER: 'customer',
	// 供应商模块
	SUPPLIER: 'supplier',
	// 司机模块
	DRIVER: 'driver'
});

/**
 * 用户配置操作类型
 */
export const UserConfigAction = Object.freeze({
	SAVE: 'save',
	LOAD: 'load',
	DELETE: 'delete',
	RESET: 'reset'
});

/**
 * 配置存储位置枚举
 */
export const ConfigStorageType = Object.freeze({
	LOCAL_STORAGE: 'localStorage',
	SERVER: 'server',
	BOTH: 'both'
});
// 在 user-config.js 中添加
export const ShowColumnsType = Object.freeze({
	TRANSFER: 'transfer',
	CHECKBOX: 'checkbox'
});
