// 运费一键申请
import { batchPayment } from '../../../../api/system/payment';
import { TableName } from '../../../../api/tool/enums';
import { parseTime } from '../../../../utils/ruoyi';

export var mixin_order_freight_payment = {
	data: function () {
		return {
			freightOnceVisible: false,
			// 己方银行卡信息
			freightSelfOnceInfo: {},
			bankQuery: '',
			selectedList: [],
			// 折叠面板的list
			activeNames: ['0'],
			batchPaymentList: [],
			total_freight: 0
		};
	},
	computed: {
		freightPaymentOnceDisabled() {
			return this.ids.length <= 0;
		}
	},
	methods: {
		// 勾选未支付
		selectUnPayment(rows) {
			let flag = false;
			if (rows) {
				rows.forEach(row => {
					if (row.paymentState === '未支付') {
						this.$refs.multipleTable.toggleRowSelection(row);
						flag = true;
					}
				});
				if (!flag) {
					this.$message.warning('当前没有未支付付款信息');
				}
			} else {
				this.$refs.multipleTable.clearSelection();
			}
		},
		// 一键申请运费
		handleFreightPaymentOnce() {
			// 初始化为0
			this.total_freight = 0;
			// 遍历选择的数组
			this.selectedList.forEach(item => {
				item = this.convertOrderFreightToPayment(item);
				// 填充对方的银行类型
				item.otherBankCardType = this.freightSelfOnceInfo.otherBankCardType;
				// 推入到需要计算的数组
				this.batchPaymentList.push(item);
				// 累加
				this.total_freight += Number(item.moneyAmount);
			});
			// 合并展示数据
			this.selectedList = this.mergeFreight();
			// 重置运费信息
			this.resetFreightSelfOnceInfo();
			// 打开运费付款页面
			this.freightOnceVisible = true;
		},
		// 司机相同的运费信息合并为一条运费信息
		mergeFreight(list) {
			let map = new Map();
			list.forEach(item => {
				let key = item.driverId;
				if (map.has(key)) {
					let temp = map.get(key);
					temp.moneyAmount += item.moneyAmount;
					temp.comments += `;${item.comments}`;
				} else {
					map.set(key, item);
				}
			});
			list = Array.from(map.values());
			return list;
		},
		mergePayment() {
			this.batchPaymentList.forEach(item => {
				item.extraInfo = {};
				item.extraInfo.sourceInfos = [];
			});
		},
		// 将orderFreight对象转换为Payment对象
		convertOrderFreightToPayment(orderFreight) {
			return {
				// 构建对方信息
				fundsDate: parseTime(new Date()),
				tableName: TableName.ORDER_FREIGHT,
				tID: orderFreight.id,
				moneyAmount: orderFreight.moneyAmount,
				otherAcountsName: orderFreight.otherAcountsName,
				otherBankNo: orderFreight.otherBankNo,
				otherBankName: orderFreight.otherBankName,
				companyName: orderFreight.driverName,
				companyId: orderFreight.driverId,
				companyType: '司机',
				comments: orderFreight.content
			};
		},
		// 自动填充己方信息
		handleCallBack(val) {
			this.freightSelfOnceInfo.selfAcountsName = val.acountsName;
			this.freightSelfOnceInfo.selfBankNo = val.bankNo;
			this.freightSelfOnceInfo.selfBankName = val.bankName;
		},
		// 一键付运费
		submitFreightOnce() {
			// 填充己方信息
			this.batchPaymentList.forEach(item => {
				Object.assign(item, {
					...this.freightSelfOnceInfo,
					payType: this.freightSelfOnceInfo.payType.join('-')
				});
			});
			// 合并计算数据
			this.batchPaymentList = this.mergeFreight(this.batchPaymentList);
			// 批量添加付款信息
			batchPayment(this.batchPaymentList).then(() => {
				this.$message.success('一键运费付款成功');
				this.resetFreightSelfOnceInfo();
				this.freightOnceVisible = false;
				this.getList();
			});
		},
		// 填充查询信息
		handleCommitBackBank(val) {
			this.bankQuery = val;
		},
		// 重置
		resetFreightSelfOnceInfo() {
			this.freightSelfOnceInfo = {
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				// 己方银行账户类型
				selfBankCardType: null,
				// 对方银行账户类型
				otherBankCardType: null
			};
		}
	}
};
