import { PUBLIC_DICT_TYPE } from '../../../api/tool/enums';

export var mixin_receive_money_fill = {
	data: function () {
		return {
			// 客户银行卡搜索
			queryCustomerBank: '',

			// 对方公司
			companyName: '',
			carName: '',

			// 对方公司类型
			options: [
				{
					value: '客户',
					label: '客户'
				},
				{
					value: '供应商',
					label: '供应商'
				},
				{
					value: '司机',
					label: '司机'
				},
				{
					value: '支付费用',
					label: '支付费用'
				}
			],
			value: '客户'
		};
	},
	methods: {
		// 对方账号的自动填充
		handleUpdateQueryNameCustomer(val) {
			this.queryCustomerBank = val;
		},
		// 对方账号的自动填充
		handleCallBackCompany(val) {
			this.form.otherAcountsName = val.acountsName;
			this.form.otherBankNo = val.bankNo;
			this.form.otherBankName = val.bankName;
			// 如果是员工，那么就从银行卡中取信息填充
			if (this.form.companyType === PUBLIC_DICT_TYPE.EMPLOYEE) {
				this.form.companyId = val.companyId;
				this.form.companyName = val.companyName;
			}
		},
		handleUpdateCarName(val) {
			this.carName = val;
		},

		// 我方信息 点击确认的回调函数 点击后自动补充相关字段
		handleCallBack(val) {
			this.form.selfAcountsName = val.acountsName;
			this.form.selfBankNo = val.bankNo;
			this.form.selfBankName = val.bankName;
			this.form.selfBankID = val.id;
		},
		// 银行卡输入搜索信息
		handleCommitBackBank(val) {
			this.bankQuery = val;
		},

		// 对方公司信息的自动填充
		handleUpdateCompanyName(val) {
			this.companyName = val;
		},
		// 填充己方公司信息
		handleCommitBackCompany(val) {
			// 先保存 companyName 和 companyId，避免 watch 监听器清空它们
			const savedCompanyName = val.companyName;
			const savedCompanyId = val.id;
			// 先设置 companyType，这会触发 watch 监听器
			this.form.companyType = val.companyType;
			// 使用 $nextTick 确保 watch 执行完毕后再恢复值
			this.$nextTick(() => {
				// 确保 companyName 和 companyId 被正确赋值（包括 0 值）
				if (val.hasOwnProperty('companyName')) {
					this.form.companyName = savedCompanyName;
				}
				if (val.hasOwnProperty('id')) {
					this.form.companyId = savedCompanyId;
				}
			});
		},
		// 填充司机的信息 如果选择的对方类型是司机的话
		handleCommitBackCar(val) {
			// 先保存 companyName 和 companyId，避免 watch 监听器清空它们
			const savedCompanyName = val.driver;
			const savedCompanyId = val.id;
			// 先设置 companyType，这会触发 watch 监听器
			this.form.companyType = PUBLIC_DICT_TYPE.DRIVER;
			// 使用 $nextTick 确保 watch 执行完毕后再恢复值
			this.$nextTick(() => {
				// 确保 companyName 和 companyId 被正确赋值（包括 0 值）
				if (val.hasOwnProperty('driver')) {
					this.form.companyName = savedCompanyName;
				}
				if (val.hasOwnProperty('id')) {
					this.form.companyId = savedCompanyId;
				}
			});
		}
	}
};
