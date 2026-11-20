/**
 * 资金（银行）当日发生业务统计：搜索日期的保存与恢复
 *
 * 需求：用户选好日期搜索后，切换到别的界面再回来，搜索日期要保留（而不是重置为默认的当天）。
 * 实现：把「搜索过的日期」写入 sessionStorage（同浏览器标签页内有效，与票据余额表的做法一致），
 *      组件创建时优先恢复它；没有记录时才使用默认当天。
 */

/** sessionStorage 中保存搜索条件的 key（与 right-toolbar 的 table-name 命名保持一致） */
export const BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY = 'views-system-statement-system-bank-account-change-summary-query';

/**
 * 读取上次搜索的日期
 * @param {Storage} storage - 存储对象（默认 sessionStorage，便于测试注入）
 * @returns {string|null} 上次搜索的日期（yyyy-MM-dd），没有或格式非法时返回 null
 */
export function readSavedEndTime(storage) {
	if (!storage || typeof storage.getItem !== 'function') {
		return null;
	}
	let saved = null;
	try {
		saved = storage.getItem(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY);
	} catch (error) {
		return null;
	}
	if (!saved) {
		return null;
	}
	try {
		const parsed = JSON.parse(saved);
		const endTime = parsed && parsed.endTime;
		return typeof endTime === 'string' && endTime ? endTime : null;
	} catch (error) {
		// 脏数据直接清掉，避免每次进入都解析失败
		try {
			storage.removeItem(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY);
		} catch (e) {
			// 忽略存储异常
		}
		return null;
	}
}

/**
 * 保存本次搜索的日期
 * @param {Storage} storage - 存储对象（默认 sessionStorage，便于测试注入）
 * @param {string} endTime - 搜索使用的日期（yyyy-MM-dd）；为空时清除已保存的记录（下次进入回到默认当天）
 * @returns {boolean} 是否保存成功
 */
export function saveEndTime(storage, endTime) {
	if (!storage) {
		return false;
	}
	if (!endTime) {
		try {
			storage.removeItem(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY);
		} catch (error) {
			return false;
		}
		return false;
	}
	if (typeof storage.setItem !== 'function') {
		return false;
	}
	try {
		storage.setItem(BANK_ACCOUNT_CHANGE_SUMMARY_QUERY_KEY, JSON.stringify({ endTime }));
		return true;
	} catch (error) {
		return false;
	}
}

/**
 * 计算进入页面时应使用的搜索日期：优先上次搜索过的日期，否则用默认当天
 * @param {Storage} storage - 存储对象（默认 sessionStorage）
 * @param {string} today - 默认日期（yyyy-MM-dd）
 * @returns {string} 最终使用的日期
 */
export function resolveInitialEndTime(storage, today) {
	return readSavedEndTime(storage) || today;
}
