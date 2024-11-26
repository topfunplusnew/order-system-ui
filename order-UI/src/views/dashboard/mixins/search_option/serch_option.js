export var mixin_search_option = {
	data: function () {
		return {
			// 数据集 通过父组件传入函数来获取
			tableData: []
		};
	},
	props: {
		// 获取数据的函数
		getData: {
			type: Function,
			required: true
		},
		// 约束条件 必须传入 这个字段为查找data的筛选属性，如果不需要传{}空对象
		// 具体用法  父组件中=>  :additional-limit-info="(tableData)=>filterNoStockNumber(tableData)"  并在父组件中指定函数
		limitInfo: {
			type: Object,
			required: true
		},
		// 额外的限制信息
		additionalLimitInfo: {
			type: Function,
			default: data => {
				return Promise.resolve(data);
			}
		}
	},
	methods: {
		getTableData() {
			// 调用获取数据的函数，并传入分页参数
			this.getData({
				...this.limitInfo,
				pageNum: this.pageNum,
				pageSize: this.pageSize
			})
				.then(res => {
					if (res && res.rows) {
						return this.additionalLimitInfo(res.rows).then(data => {
							this.tableData = data;
							this.total = res.total;
						});
					} else {
						return Promise.reject('无有效数据');
					}
				})
				.finally(() => {
					this.loading = false;
				});
		}
	}
};
