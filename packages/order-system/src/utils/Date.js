// 给Date类添加了一个新的实例方法format
Date.prototype.format = function (fmt) {
	// debugger;
	const o = {
		'M+': this.getMonth() + 1, // 月份
		'd+': this.getDate(), // 日
		'h+': this.getHours(), // 小时
		'm+': this.getMinutes(), // 分
		's+': this.getSeconds(), // 秒
		'q+': Math.floor((this.getMonth() + 3) / 3), // 季度
		S: this.getMilliseconds() // 毫秒
	};
	if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
	for (const k in o) if (new RegExp('(' + k + ')').test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ('00' + o[k]).substr(('' + o[k]).length));
	return fmt;
};

export function fmtDate(date, pattern) {
	const ts = date.getTime();
	let d = new Date(ts).format('yyyy-MM-dd hh:mm:ss');
	if (pattern) {
		d = new Date(ts).format(pattern);
	}
	return d.toLocaleString();
}

// 获取当前日期的前一天
export function getPreviousDay(date) {
	const previousDay = new Date(date); // 创建一个新对象，避免修改原始对象
	previousDay.setDate(previousDay.getDate() - 1); // 设置日期为当前日期的前一天
	return previousDay;
}
