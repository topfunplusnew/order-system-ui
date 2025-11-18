// 运费一键申请
import { batchPayment } from '../../../../api/system/payment';
import { BankAcceptanceType, TableName } from '../../../../api/tool/enums';
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
			if (!rows || !Array.isArray(rows)) {
				this.$refs.multipleTable.clearSelection();
				return;
			}

			// 筛选未支付的运费记录（没有payment对象或payment为null就是未支付）
			const unpaidRows = _.filter(rows, row => !row.payment || row.payment === null);

			if (_.isEmpty(unpaidRows)) {
				this.$message.warning('当前没有未支付付款信息');
				return;
			}

			// 批量勾选未支付的记录
			_.forEach(unpaidRows, row => {
				this.$refs.multipleTable.toggleRowSelection(row);
			});
		},
		// 一键申请运费
		handleFreightPaymentOnce() {
			// 重置运费信息
			this.resetFreightSelfOnceInfo();

			// 筛选未支付的运费记录并转换为付款对象
			const filteredList = _.chain(this.selectedList)
				.filter(item => !item.payment || item.payment === null)
				.map(item => {
					const paymentItem = this.convertOrderFreightToPayment(item);
					paymentItem.otherBankCardType = this.freightSelfOnceInfo.otherBankCardType;
					return paymentItem;
				})
				.value();

			if (_.isEmpty(filteredList)) {
				this.$message.warning('当前没有未支付付款信息');
				return;
			}

			// 保存到批量付款列表
			this.batchPaymentList = _.cloneDeep(filteredList);

			// 计算总运费
			this.total_freight = _.sumBy(filteredList, item => Number(item.moneyAmount));

			// 合并展示数据
			this.selectedList = this.mergeFreight(filteredList);

			// 打开运费付款页面
			this.freightOnceVisible = true;
		},
		// 司机相同的运费信息合并为一条运费信息
		mergeFreight(list) {
			// 按司机ID分组（使用 driverId 或 companyId，优先使用 driverId）
			const groupedByDriver = _.groupBy(list, item => item.driverId || item.companyId);

			// 合并每个司机的运费信息
			return _.map(groupedByDriver, items => {
				const firstItem = items[0];

				// 计算总金额（保留3位小数）
				const totalAmount = Number(_.sumBy(items, item => Number(item.moneyAmount)).toFixed(3));

				// 合并备注（去重并连接）
				const comments = _.chain(items)
					.map('comments')
					.filter(comment => comment && comment.trim())
					.uniq()
					.join('; ')
					.value();

				return {
					...firstItem,
					moneyAmount: totalAmount,
					comments: comments || firstItem.comments || '',
					carNo: firstItem.carNo,
					// 确保保留所有展示需要的字段
					driverName: firstItem.driverName || firstItem.companyName || '',
					driverId: firstItem.driverId || firstItem.companyId || '',
					fleet: firstItem.fleet || '',
					freightType: firstItem.freightType || ''
				};
			});
		},
		// 将orderFreight对象转换为Payment对象
		convertOrderFreightToPayment(orderFreight) {
			// 如果tID不存在
			if (!orderFreight.id) {
				this.$message.error('运费ID不存在!');
				return;
			}
			return {
				// 构建对方信息
				fundsDate: parseTime(new Date()),
				tableName: TableName.ORDER_FREIGHT,
				// 这里的表id是运费的id
				tID: orderFreight.id,
				moneyAmount: orderFreight.moneyAmount,
				otherAccountsName: orderFreight.otherAcountsName,
				companyName: orderFreight.driverName,
				companyId: orderFreight.driverId,
				companyType: '司机',
				comments: orderFreight.comments,
				// 使用 lodash pick 提取需要的字段
				..._.pick(orderFreight, ['otherBankNo', 'otherBankName', 'driverName', 'driverId', 'carNo', 'fleet', 'freightType'])
			};
		},
		// 自动填充我方信息
		handleCallBack(val) {
			// 使用 lodash assign 批量赋值
			_.assign(this.freightSelfOnceInfo, {
				selfAccountsName: val.acountsName,
				selfBankNo: val.bankNo,
				selfBankName: val.bankName,
				selfBankID: val.id
			});
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
							// 确保是数组格式（如果是多个司机，需要分别提交每个司机的付款）
							const submitPayments = _.castArray(paymentData);
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
			// 按司机ID分组运费信息
			const groupedByDriver = _.groupBy(this.batchPaymentList, 'companyId');

			// 将每个司机的运费信息转换为付款记录
			return _.map(groupedByDriver, (items, driverId) => {
				// 取第一个项目作为基础数据（所有同司机的项目共享这些字段）
				const firstItem = items[0];

				// 计算总金额（使用 lodash sumBy 并保留3位小数）
				const totalAmount = Number(_.sumBy(items, item => Number(item.moneyAmount)).toFixed(3));

				// 生成所有运费记录的引用
				const tableReferences = _.map(items, item => ({
					refTableName: TableName.ORDER_FREIGHT,
					refTableId: item.tID,
					amount: Number(item.moneyAmount)
				}));

				// 合并备注（去重并连接）
				const comments = _.chain(items)
					.map('comments')
					.filter(comment => comment && comment.trim())
					.uniq()
					.join('; ')
					.value();

				// 构建付款记录对象
				return {
					fundsDate: parseTime(new Date()),
					payType: this.freightSelfOnceInfo.payType ? this.freightSelfOnceInfo.payType.join('-') : '',
					moneyAmount: totalAmount,
					selfAccountsName: this.freightSelfOnceInfo.selfAccountsName,
					selfBankNo: this.freightSelfOnceInfo.selfBankNo,
					selfBankName: this.freightSelfOnceInfo.selfBankName,
					otherAccountsName: firstItem.otherAccountsName,
					otherBankNo: firstItem.otherBankNo,
					otherBankName: firstItem.otherBankName,
					companyName: firstItem.companyName,
					companyId: firstItem.companyId,
					companyType: firstItem.companyType,
					comments: comments || firstItem.comments || '',
					userId: this.$store.getters.userId,
					UserName: this.$store.getters.name,
					selfBankCardType: this.freightSelfOnceInfo.selfBankCardType,
					otherBankCardType: this.freightSelfOnceInfo.otherBankCardType,
					tableReferences
				};
			});
		},
		// 重置
		resetFreightSelfOnceInfo() {
			this.freightSelfOnceInfo = {
				selfAccountsName: null,
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
