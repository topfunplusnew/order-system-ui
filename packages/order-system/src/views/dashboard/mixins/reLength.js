// 表格头部的拖动引起变化的混入效果
export default {
	data() {
		return {
			// 长度的响应式变量 如果拖动某个列 那么就改变这个值
			changeLength: 0
		};
	},
	// 过滤器 当拖动的时候触发
	filters: {
		changeNumber(value, length) {
			return !length ? Number(value).toFixed(2) : Number(value).toFixed(length);
		}
	},
	methods: {
		changeColWidth(newWidth, oldWidth, column, event) {
			const needList = ['总货款', '陆运费', '海运费', '开票金额', '供应商票点金额', '票点金额', '客户票点金额'];
			if (needList.includes(column.label)) {
				this.changeLength = 3;
			}
		}
	}
};
