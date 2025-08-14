import { listSubject } from '../../../../api/system/subject';
import { listBankAccount } from '../../../../api/system/bankAccount';
import { PaymentOptions, TableName } from '../../../../api/tool/enums';

export var mixin_payment_apply = {
	data: function () {
		return {
			options: PaymentOptions,
			value: '客户'
		};
	},
	created() {
		// 查询科目信息
		listSubject({}, true).then(res => {
			this.subjectTree = this.handleTree(res.data, 'id', 'parentId');
			this.OneLevelOption = this.subjectTree;
		});
		// 检查
		this.checkPropsInfo();
	},
	methods: {
		// 检查传入的信息
		checkPropsInfo() {
			// 根据表名填充公司类型
			this.fillCompanyType();
			// 填充金额
			this.fillMoney();
			// 填充银行卡信息
			this.fillBankInfo();
		},
		// 根据表名填充公司类型 这里是拿的父组件传递过来的tableName来判断 是哪个表的业务
		fillCompanyType() {
			// 根据传入的表名来赋值公司类型
			if (this.tableName === TableName.OIL_RECHARGE) {
				this.form.companyType = '其他';
			}
			if (this.tableName === TableName.REPAYMENT) {
				this.form.companyType = '其他';
			}
			// 如果是运费申请公司类型为司机
			if (this.tableName === TableName.ORDER_FREIGHT) {
				this.form.companyType = '司机';
				this.value = '司机';
			}
			// 如果是发票购入 对方公司类型那么就是供应商
			if (this.tableName === TableName.INVOICE_IN) {
				this.form.companyType = '供应商';
			}
			// 订单打款
			if (this.tableName === TableName.GOODS_ORDER) {
				this.form.companyType = '供应商';
			}
		},
		// 填充运费信息 这里是根据父组件传递过来的信息对象needInfo
		fillFreightInfo() {
			// 需要司机信息
			if (this.needInfo?.isExit !== undefined) {
				// 如果信息对象中需要司机信息
				if (this.needInfo?.isExit === true) {
					// 自动填充 拿到父组件传递过来的需要的信息对象 needInfo
					this.form.otherAcountsName = this.needInfo.otherAcountsName;
					this.form.companyName = this.needInfo.companyName;
					// 查询司机的银行卡信息 通过账户类型 和 账户名称 来绑定查询
					const search = {
						acountsType: '司机',
						acountsName: this.needInfo.otherAcountsName
					};
					listBankAccount(search).then(res => {
						this.form.otherBankNo = res.rows[0].bankNo;
						this.form.otherBankName = res.rows[0].bankName;
					});
				}
			}
		}
	}
};
