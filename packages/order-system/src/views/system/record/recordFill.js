export var mixin_record_fill = {
	data() {
		return {
			// 收入方与支付方 只做展示
			sourceName: '',
			targetName: '',

			// 查询字段
			querySupplier: '',
			queryCustomer: '',
			queryInvoice: '',

			// 选择客户或者供应商的相关信息
			queryCompanyName: '',
			// 司机的搜索信息
			queryDriver: '',
			// 己方公司的搜索信息
			querySelfAccount: '',
			// 转账双方的信息
			eachInfo: {
				source: null,
				target: null
			}
		};
	},
	methods: {
		// 上传的回调函数
		handleCommitUpload(val) {
			this.form.attachment = val;
		},
		// 需求:  客户张三欠我1万，我欠供应商李四一万。我现在让张三直接把这一万给李四了
		// 我记账收入客户张三1万，支出供应商李四一万。他是一笔账
		// 客户供应商的搜索
		updateQuerySupplier(val) {
			this.querySupplier = val;
		},
		updateQueryCustomer(val) {
			this.queryCustomer = val;
		},
		// 收入方的自动填充 填充id即可
		handleCommitCompanySupplier(val) {
			this.form.sourceId = val.id;
			// 修改 应该填充的是银行账户名称
			this.sourceName = val.acountsName;
			// 填充内部转账需要的source
			this.eachInfo.source = val.bankNo;
		},
		// 支出方的自动填充
		handleCommitCompanyCustomer(val) {
			this.targetName = val.acountsName;
			this.form.targetId = val.id;
			// 填充内部转账需要的target
			this.eachInfo.target = val.bankNo;
		},
		// 以下是新增 填充方法 2024/11/7 现金记账改为冲抵款 合并冲抵货款
		// 选择客户或者供应商的回调
		handleUpdateCompanyNameGet(val) {
			this.queryCompanyName = val;
		},
		handleCommitBackCompanyGet(val) {
			// 填充展示字段
			this.sourceName = val.companyName;
			// 填充业务字段
			this.form.sourceId = val.id;
		},
		handleUpdateCompanyNamePay(val) {
			this.queryCompanyName = val;
		},
		handleCommitBackCompanyPay(val) {
			// 填充展示字段
			this.targetName = val.companyName;
			// 填充业务字段
			this.form.targetId = val.id;
		},
		// 填充查询字段的信息
		handleUpdateDriver(val) {
			this.queryDriver = val;
		},
		// 填充司机的信息
		handleCommitBackDriver(val) {
			// 如果sourceType选了 并且选的是司机
			if (this.form.sourceCompanyType && this.form.sourceCompanyType === '司机') {
				// 填充展示字段
				this.sourceName = val.driver;
				// 填充业务字段
				this.form.sourceId = val.id;
			}
			// 如果targetType选了 并且选的是司机
			if (this.form.targetCompanyType && this.form.targetCompanyType === '司机') {
				// 填充展示字段
				this.targetName = val.driver;
				// 填充业务字段
				this.form.targetId = val.id;
			}
		},
		// 填充己方公司的银行卡信息
		handleUpdateSelfAccount(val) {
			this.querySelfAccount = val;
		},
		handleCommitBackSelfAccount(val) {
			// 如果sourceType选了 并且选的是司机
			if (this.form.sourceCompanyType && this.form.sourceCompanyType === '己方公司') {
				// 填充展示字段
				this.sourceName = val.acountsName;
				this.form.sourceId = val.id;
			}
			// 如果targetType选了 并且选的是司机
			if (this.form.targetCompanyType && this.form.targetCompanyType === '己方公司') {
				// 填充展示字段
				this.targetName = val.acountsName;
				// 填充业务字段 默认给0 因为是己方公司
				this.form.targetId = val.id;
			}
		},
		// 重置eachInfo
		resetEachInfo() {
			this.eachInfo.source = null;
			this.eachInfo.target = null;
		}
	}
};
