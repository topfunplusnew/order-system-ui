// 运费一键申请
import { batchPayment } from '../../../../api/system/payment';
import { BankAcceptanceType, TableName } from '../../../../api/tool/enums';
import { parseTime } from '../../../../utils/ruoyi';

export var mixin_order_freight_payment = {
	data: function () {
		return {
			freightOnceVisible: false,
			// 我方银行卡信息
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
			// 重置运费信息
			this.resetFreightSelfOnceInfo();
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
			this.selectedList = this.mergeFreight(this.selectedList);
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
					temp = { ...temp };
					temp.moneyAmount = Number(temp.moneyAmount) + Number(item.moneyAmount);
					temp.comments += `;${item.comments}`;
					map.set(key, temp);
				} else {
					map.set(key, { ...item });
				}
			});
			// 对数字进行fix
			map.forEach(value => {
				value.moneyAmount = Number(value.moneyAmount).toFixed(3);
			});
			return Array.from(map.values());
		},
		// 将orderFreight对象转换为Payment对象
		convertOrderFreightToPayment(orderFreight) {
			return {
				// 构建对方信息
				fundsDate: parseTime(new Date()),
				tableName: TableName.ORDER_FREIGHT,
				// 这里的表id是运费的id
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
		// 自动填充我方信息
		handleCallBack(val) {
			this.freightSelfOnceInfo.selfAcountsName = val.acountsName;
			this.freightSelfOnceInfo.selfBankNo = val.bankNo;
			this.freightSelfOnceInfo.selfBankName = val.bankName;
		},
		// 一键付运费
		submitFreightOnce() {
			this.$refs.freightPaymentOnceForm.validate(valid => {
				// TODO 这里写死了 要求只能为现金
				this.freightSelfOnceInfo.selfBankCardType = BankAcceptanceType.BANK_CASH;
				this.freightSelfOnceInfo.otherBankCardType = BankAcceptanceType.BANK_CASH;
				if (valid) {
					this.$confirm({
						title: '提示',
						content: '确定一键付运费吗?',
						okText: '确定',
						cancelText: '取消',
						type: 'warning',
						zIndex: 2600,
						onOk: () => {
							this.batchPaymentList.forEach(item => {
								Object.assign(item, {
									...this.freightSelfOnceInfo,
									payType: this.freightSelfOnceInfo.payType.join('-')
								});
							});

							const result = [];
							const map = new Map();
							this.batchPaymentList.forEach(item => {
								const { companyId, ...rest } = item;
								if (!map.has(companyId)) {
									map.set(companyId, {
										...rest,
										extraInfo: {
											sourceInfos: [
												{
													tableName: TableName.ORDER_FREIGHT,
													tableId: item.tID
												}
											]
										}
									});
								} else {
									const existing = map.get(companyId);
									existing.extraInfo.sourceInfos.push({
										tableName: TableName.ORDER_FREIGHT,
										tableId: item.tID
									});
									existing.moneyAmount = (Number(existing.moneyAmount) + Number(item.moneyAmount)).toFixed(3);
								}
							});
							map.forEach(value => {
								result.push(value);
							});
							batchPayment(result)
								.then(() => {
									this.$message.success('一键运费付款成功');
									this.resetFreightSelfOnceInfo();
									this.freightOnceVisible = false;
									this.getList();
								})
								.catch(() => {
									this.$message.error('付款失败，请重试');
								});
						},
						onCancel: () => {
							this.$message.info('已取消操作');
						}
					});
				}
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
				// 我方银行账户类型
				selfBankCardType: null,
				// 对方银行账户类型
				otherBankCardType: null
			};
			this.batchPaymentList = [];
		}
	}
};
