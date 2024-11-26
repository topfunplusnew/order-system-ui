import { addOilRecharge } from '../../../../api/system/oilRecharge';
import { checkOilCard } from '../../../../api/system/oilCard';

export var mixin_business_trip_oil_card = {
	data: function () {
		return {
			// 油卡充值
			oilCardDialogVisible: false,
			moneyInfo: {},
			// 油卡消费
			oilCardConsumeVisible: false,
			queryOilCard: '',
			queryCarNumber: ''
		};
	},
	methods: {
		// 打开油卡消费记录的弹窗
		openOilCardOpen(e) {
			this.resetOilCardConsumeInfo();
			this.oilCardConsumeVisible = true;
		},
		changePaymentApplyInfoVisible() {
			this.needMoney = 0;
			this.applyForPaymentDialogVisible = false;
			this.getList();
		},
		// 添加油卡消费信息
		submitOilCard() {
			this.carApplyForm.isUseOilCard = '1';
			// 要检查油卡的余额是否够用 如果够用就保存数据 如果不够用 那么就要提示是否充值  如果充值 就要弹出充值页面
			checkOilCard({
				oilCardNo: this.oilCardConsumeInfo.oilCardNo,
				consumeAmount: this.oilCardConsumeInfo.refuelingMoney
			}).then(res => {
				// 如果余额不足 要进行充值
				if (res.data.error === '油卡余额不足') {
					this.$confirm('油卡余额不足,是否充值?', '提示', {
						confirmButtonText: '是',
						cancelButtonText: '否',
						type: 'warning'
					}).then(() => {
						this.oilCardDialogVisible = true;
						this.moneyInfo.rechargeName = this.trueName;
					});
					// 如果油卡信息不存在
				} else if (res.data.error === '油卡不存在') {
					this.$message.error('油卡不存在');
					// 如果存在并且余额充足
				} else {
					// 先从session拿出出差信息ID 判断是否存在
					const businessTripID = JSON.parse(
						sessionStorage.getItem('BusinessTrip-ID')
					);
					getBusinessTrip(businessTripID).then(res => {
						if (
							res.data === undefined ||
							res.data === {} ||
							res.data === null
						) {
							this.$message.error('出差信息为空!请先添加出差信息');
						} else {
							// 纠正money
							this.oilCardConsumeInfo.rechargeMoney =
								this.isRecharge === '2'
									? '0'
									: this.oilCardConsumeInfo.rechargeMoney;
							// 添加油卡消费信息
							addOilCardConsume({
								...this.oilCardConsumeInfo,
								bTripId: businessTripID
							}).then(res => {
								this.$message.success('保存成功~');
								setTimeout(() => {
									// 回写充值账户信息到报销项中
									if (this.carApplyForm.isUseOilCard === '1') {
										// 还要进一步判断 如果充值金额大于0 就要添加到报销项中
										if (this.oilCardConsumeInfo.rechargeMoney > 0) {
											this.tripReimbursementList.push({
												index: this.tripReimbursementList.length + 1,
												item: '加油卡现金充值金额',
												itemCost: this.oilCardConsumeInfo.rechargeMoney,
												isDisabled: true // 不可更改
											});
											this.$message.success('填写保存成功,相关费用已罗列');
										} else {
											this.$message.success(
												'填写保存成功 充值金额为' +
													this.oilCardConsumeInfo.rechargeMoney +
													'元'
											);
										}
									}
								}, 100);
								// 关闭油卡消费添加弹窗
								this.oilCardConsumeVisible = false;
							});
						}
					});
				}
			});
		},
		clearOilCard() {
			this.oilCardConsumeVisible = false;
			this.oilCardConsumeInfo = {};
			this.carApplyForm.isUseOilCard = '0';
			this.$message.success('已清除');
		},
		handleCommitBackOilCard(val) {
			this.oilCardConsumeInfo.oilCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCard(val) {
			this.queryOilCard = val;
		},
		// 油卡充值
		handleCommitBackBankAcount(val) {
			this.moneyInfo.acountsName = val.acountsName;
			this.moneyInfo.bankNo = val.bankNo;
		},
		handleUpdateQueryBankAcount(val) {
			this.queryBankAcount = val;
		},
		handleUpload(val) {
			this.moneyInfo.attachment = val;
		},
		handleClick(tab, event) {
			console.log(tab.name, event);
			if (tab.name === 'first') {
			} else {
			}
		},
		// 确认银行卡充值
		submitMoney() {
			// 添加
			addOilRecharge(this.moneyInfo).then(res => {
				this.$message.success('充值成功');
			});
			this.oilCardDialogVisible = false;
		},
		handleCommitBack(val) {
			console.log(val);
			// 自动填充加油卡信息
			this.moneyInfo.oilCardNo = val.oilCardNo;
		}
	}
};
