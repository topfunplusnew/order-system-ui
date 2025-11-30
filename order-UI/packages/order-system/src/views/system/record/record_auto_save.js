/**
 * 内部转账表单暂存功能 Mixin
 * 提供表单数据的暂存、读取和清除功能
 */

export const mixin_record_auto_save = {
	watch: {
		// 监听表单变化，自动暂存内部转账表单
		form: {
			handler(newVal, oldVal) {
				// 只有在内部转账模式下且对话框打开时才自动暂存
				if (this.cashType === this.CASH_TYPE?.TRANSFER && this.open && newVal) {
					// 检查是否有实际数据需要保存
					const hasData = newVal.amount || newVal.sourceBankNo || newVal.targetBankNo || newVal.remarks || newVal.sourceId || newVal.targetId;
					if (hasData) {
						this.saveInternalTransferFormToSession();
					}
				}
			},
			deep: true,
			immediate: false
		}
	},
	methods: {
		/**
		 * 暂存内部转账表单数据到sessionStorage
		 * @returns {object} 操作结果 {success: boolean, storageKey?: string, error?: string}
		 */
		saveInternalTransferFormToSession() {
			// 只有当选择内部转账时才进行暂存
			if (this.cashType !== this.CASH_TYPE.TRANSFER) {
				return { success: false, error: '当前不是内部转账模式' };
			}

			try {
				// 使用固定的存储键
				const storageKey = 'internal_transfer_form_data';
				// 收集需要暂存的表单数据
				const formDataToSave = {
					// 基本表单信息
					id: this.form.id,
					amount: this.form.amount,
					transactionTime: this.form.transactionTime,
					remarks: this.form.remarks,
					cashType: this.cashType,
					// 转账相关信息
					sourceBankNo: this.form.sourceBankNo,
					targetBankNo: this.form.targetBankNo,
					sourceId: this.form.sourceId,
					targetId: this.form.targetId,
					// 银行账户类型
					selfBankCardType: this.form.selfBankCardType || this.$refs.selfSelectBankType?.localSelectType,
					otherBankCardType: this.form.otherBankCardType || this.$refs.otherSelectBankType?.localSelectType,
					// 支付类型
					sourcePaymentType: this.form.sourcePaymentType,
					targetPaymentType: this.form.targetPaymentType,
					// 公司类型
					sourceCompanyType: this.form.sourceCompanyType,
					targetCompanyType: this.form.targetCompanyType,
					// 显示名称
					sourceName: this.sourceName,
					targetName: this.targetName,
					// 承兑信息
					params: {
						bankacceptance: this.form.params?.bankacceptance,
						attachmentIds: this.form.params?.attachmentIds || []
					},

					// 暂存时间戳和元数据
					savedAt: new Date().toISOString(),
					formType: 'internal_transfer'
				};

				// 保存到sessionStorage
				sessionStorage.setItem(storageKey, JSON.stringify(formDataToSave));

				return {
					success: true,
					storageKey: storageKey,
					data: formDataToSave
				};
			} catch (error) {
				console.error('暂存内部转账表单失败:', error);
				this.$message.error('暂存失败，请重试');
				return {
					success: false,
					error: error.message
				};
			}
		},

		/**
		 * 从sessionStorage读取内部转账表单数据
		 * @param {string} storageKey - 可选的存储键，不提供则使用最新的
		 * @returns {boolean} 是否读取成功
		 */
		loadInternalTransferFormFromSession(storageKey = null) {
			try {
				// 使用固定的存储键
				const keyToUse = storageKey || 'internal_transfer_form_data';

				const savedDataStr = sessionStorage.getItem(keyToUse);
				if (!savedDataStr) {
					console.warn('没有找到暂存的内部转账表单数据');
					return false;
				}

				const savedData = JSON.parse(savedDataStr);

				// 验证数据完整性
				if (!savedData || savedData.formType !== 'internal_transfer') {
					console.warn('存储的数据格式不正确');
					return false;
				}

				// 恢复表单数据
				this.cashType = savedData.cashType || this.CASH_TYPE.TRANSFER;

				// 等待DOM更新后再设置表单数据
				this.$nextTick(() => {
					// 恢复基本表单数据
					this.form.id = savedData.id;
					this.form.amount = savedData.amount;
					this.form.transactionTime = savedData.transactionTime;
					this.form.remarks = savedData.remarks;

					// 恢复转账相关信息
					this.form.sourceBankNo = savedData.sourceBankNo;
					this.form.targetBankNo = savedData.targetBankNo;
					this.form.sourceId = savedData.sourceId;
					this.form.targetId = savedData.targetId;

					// 恢复银行账户类型
					this.form.selfBankCardType = savedData.selfBankCardType;
					this.form.otherBankCardType = savedData.otherBankCardType;

					// 恢复组件状态
					if (this.$refs.selfSelectBankType && savedData.selfBankCardType) {
						this.$refs.selfSelectBankType.localSelectType = savedData.selfBankCardType;
					}
					if (this.$refs.otherSelectBankType && savedData.otherBankCardType) {
						this.$refs.otherSelectBankType.localSelectType = savedData.otherBankCardType;
					}

					// 恢复支付类型
					this.form.sourcePaymentType = savedData.sourcePaymentType;
					this.form.targetPaymentType = savedData.targetPaymentType;

					// 恢复公司类型
					this.form.sourceCompanyType = savedData.sourceCompanyType;
					this.form.targetCompanyType = savedData.targetCompanyType;

					// 恢复显示名称
					this.sourceName = savedData.sourceName;
					this.targetName = savedData.targetName;

					// 恢复承兑信息
					if (savedData.params) {
						this.form.params = {
							...this.form.params,
							...savedData.params
						};
					}

					this.$message.success(`表单已恢复 (${new Date(savedData.savedAt).toLocaleString()})`);
				});

				return true;
			} catch (error) {
				console.error('恢复内部转账表单失败:', error);
				this.$message.error('恢复表单失败');
				return false;
			}
		},

		/**
		 * 清除暂存的内部转账表单数据
		 * @param {string} storageKey - 可选的存储键，不提供则清除最新的
		 * @returns {boolean} 是否清除成功
		 */
		clearSavedInternalTransferForm(storageKey = null) {
			try {
				// 使用固定的存储键
				const keyToUse = storageKey || 'internal_transfer_form_data';
				// 清除暂存数据
				sessionStorage.removeItem(keyToUse);
				return true;
			} catch (error) {
				return false;
			}
		}
	}
};
