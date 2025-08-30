// 运费一键申请
import { batchPayment } from '../../../../api/system/payment';
import { BankAcceptanceType, PAYMENT_APPLY_STATE, PaymentState, TableName } from '../../../../api/tool/enums';
import { parseTime } from '../../../../utils/ruoyi';
import _ from 'lodash';

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
					// 使用与customFreightStatusFn相同的判断逻辑
					// 运费业务逻辑：没有payment对象或payment为null就是未支付
					if (!row.payment || row.payment === null) {
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
			// 使用自定义判断逻辑：没有payment对象或payment为null就是未支付
			const filteredList = _.cloneDeep(this.selectedList.filter(item => !item.payment || item.payment === null));
			// 遍历选择的数组
			filteredList.forEach(item => {
				item = this.convertOrderFreightToPayment(item);
				// 填充对方的银行类型
				item.otherBankCardType = this.freightSelfOnceInfo.otherBankCardType;
				// 推入到需要计算的数组
				this.batchPaymentList.push(item);
				// 累加
				this.total_freight += Number(item.moneyAmount);
			});
			if (filteredList.length === 0) {
				this.$message.warning('当前没有未支付付款信息');
				return;
			}
			// 合并展示数据
			this.selectedList = this.mergeFreight(filteredList);
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
			this.freightSelfOnceInfo.selfBankID = val.id;
		},
		// 一键付运费
		submitFreightOnce() {
			this.$refs.freightPaymentOnceForm.validate(valid => {
				// 这里写死了 要求只能为现金
				this.freightSelfOnceInfo.selfBankCardType = BankAcceptanceType.BANK_CASH;
				this.freightSelfOnceInfo.otherBankCardType = BankAcceptanceType.BANK_CASH;
				if (valid) {
					this.$antdconfirm({
						title: '提示',
						content: '确定一键付运费吗?',
						okText: '确定',
						cancelText: '取消',
						type: 'warning',
						zIndex: 2600,
						onOk: () => {
							// 转换为新的API数据结构
							const paymentData = this.transformToNewPaymentStructure();

							// 如果是多个司机，需要分别提交每个司机的付款
							const submitPayments = Array.isArray(paymentData) ? paymentData : [paymentData];
							batchPayment(submitPayments)
								.then(() => {
									this.$message.success('一键运费付款成功');
									this.resetFreightSelfOnceInfo();
									this.freightOnceVisible = false;
									this.getList();
								})
								.catch(error => {
									console.error('付款失败:', error);
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
		// 转换为新的API数据结构
		transformToNewPaymentStructure() {
			// 按司机分组合并运费信息
			const driverMap = new Map();
			this.batchPaymentList.forEach(item => {
				const driverId = item.companyId;
				if (!driverMap.has(driverId)) {
					// 创建新的司机付款记录
					driverMap.set(driverId, {
						fundsDate: parseTime(new Date()),
						payType: this.freightSelfOnceInfo.payType ? this.freightSelfOnceInfo.payType.join('-') : '',
						moneyAmount: Number(item.moneyAmount),
						selfAcountsName: this.freightSelfOnceInfo.selfAcountsName,
						selfBankNo: this.freightSelfOnceInfo.selfBankNo,
						selfBankName: this.freightSelfOnceInfo.selfBankName,
						otherAcountsName: item.otherAcountsName,
						otherBankNo: item.otherBankNo,
						otherBankName: item.otherBankName,
						companyName: item.companyName,
						companyId: item.companyId,
						companyType: item.companyType,
						comments: item.comments,
						userId: this.$store.getters.userId,
						UserName: this.$store.getters.name,
						selfBankCardType: this.freightSelfOnceInfo.selfBankCardType,
						otherBankCardType: this.freightSelfOnceInfo.otherBankCardType,
						tableReferences: [
							{
								refTableName: TableName.ORDER_FREIGHT,
								refTableId: item.tID,
								amount: Number(item.moneyAmount)
							}
						]
					});
				} else {
					// 合并已存在司机的运费信息
					const existing = driverMap.get(driverId);
					existing.moneyAmount = Number((existing.moneyAmount + Number(item.moneyAmount)).toFixed(3));
					existing.tableReferences.push({
						refTableName: TableName.ORDER_FREIGHT,
						refTableId: item.tID,
						amount: Number(item.moneyAmount)
					});
					if (item.comments && existing.comments !== item.comments) {
						existing.comments += `; ${item.comments}`;
					}
				}
			});
			const result = Array.from(driverMap.values());
			return result;
		},
		// 重置
		resetFreightSelfOnceInfo() {
			this.freightSelfOnceInfo = {
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				// 我方银行账户类型
				selfBankCardType: null,
				// 对方银行账户类型
				otherBankCardType: null
			};
			this.batchPaymentList = [];
		}
	}
};
