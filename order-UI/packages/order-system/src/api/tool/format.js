export const formatTime = date => {
	return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
};

// 将字符串日期转换为 Date 对象
export function parseDate(dateString) {
	const [year, month, day] = dateString.split('-').map(Number);
	return new Date(year, month - 1, day); // 月份是从0开始的
}

// 排序函数
export function sortByUpdateTime(a, b) {
	const dateA = parseDate(a.updateTime);
	const dateB = parseDate(b.updateTime);
	return dateA - dateB; // 从小到大排序
}

export const fix = value => {
	return Number(value).toFixed(3);
};

// 金钱转大写
export function numToChineseUppercase(n) {
	if (n === 0) return '零元整'; // 特殊处理 0 元

	const units = ['', '拾', '佰', '仟']; // 每4位内的单位
	const sections = ['', '万', '亿', '万亿']; // 每节对应的单位
	const numbers = '零壹贰叁肆伍陆柒捌玖'; // 数字对应的中文

	let [integerPart, decimalPart] = String(n).split('.'); // 拆分整数和小数部分
	const result = []; // 最终结果

	// 将每个四位一组的数字转换为中文
	function sectionToChinese(sectionNum) {
		let sectionResult = '';
		let zero = false; // 标记上一次是否出现 0
		let unitPos = 0; // 对应单位的位置

		for (let i = sectionNum.length - 1; i >= 0; i--) {
			const num = parseInt(sectionNum[i], 10);
			if (num === 0) {
				if (!zero) {
					zero = true; // 标记出现零
					sectionResult = numbers[0] + sectionResult;
				}
			} else {
				zero = false; // 重置零标记
				sectionResult = numbers[num] + units[unitPos] + sectionResult;
			}
			unitPos++;
		}
		return sectionResult.replace(/零+$/, ''); // 移除结尾的多余零
	}

	// 处理整数部分，按4位一组转换
	let secIndex = 0;
	while (integerPart.length > 0) {
		const start = Math.max(0, integerPart.length - 4);
		const sectionNum = integerPart.substring(start, integerPart.length);
		const sectionResult = sectionToChinese(sectionNum);
		if (sectionResult) {
			result.unshift(sections[secIndex]); // 插入节单位
			result.unshift(sectionResult);
		}
		integerPart = integerPart.substring(0, start);
		secIndex++;
	}

	// 处理结果中的冗余"零"
	const chineseNumber = result
		.join('')
		.replace(/零(万|亿|$)/g, '$1')
		.replace(/亿万/, '亿');

	// 处理小数部分（角、分）
	let decimalResult = '';
	if (decimalPart) {
		const jiao = parseInt(decimalPart[0] || '0', 10);
		const fen = parseInt(decimalPart[1] || '0', 10);
		if (jiao > 0) decimalResult += numbers[jiao] + '角';
		if (fen > 0) decimalResult += numbers[fen] + '分';
	}

	// 如果没有小数部分，则补上“整”
	return chineseNumber + '元' + (decimalResult || '整');
}

//需要提取日期中的年月日部分，然后将同一天的数据的 value 相加
// 并且要把借贷的详细变成列表作为属性
export function aggregateByDay(data, key, dateKey) {
	if (typeof data !== 'object' || !Array.isArray(data)) {
		throw new Error('data 必须是数组');
	}
	if (typeof key !== 'string' || typeof dateKey !== 'string') {
		throw new Error('key 和 dateKey 必须是字符串');
	}
	// 使用 reduce 聚合数据
	return Object.values(
		data.reduce((acc, curr) => {
			// 原日期
			const originalDate = curr[dateKey];
			// 正则匹配日期中的年月日部分
			const date = curr[dateKey].match(/^(\d{4}-\d{2}-\d{2})/)[1];

			// 如果日期已经存在，则将 value 相加；否则，初始化
			if (acc[date]) {
				acc[date][key] = Number(acc[date][key]) + Number(curr[key]);
				acc[date].detailList.push({
					...curr,
					[dateKey]: originalDate
				});
			} else {
				acc[date] = {
					...curr,
					[dateKey]: date,
					[key]: curr[key], // 将借贷详细变成列表
					detailList: [
						{
							...curr,
							[dateKey]: originalDate
						}
					]
				};
			}

			return acc;
		}, {})
	);
}
