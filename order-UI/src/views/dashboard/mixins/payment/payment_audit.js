import instance from '../../../../utils/request';

export function paymentAudit(params) {
	return instance.request({
		url: '/system/payment/audit',
		method: 'put',
		params: {
			id: params.id,
			auditStatus: params.auditStatus
		}
	});
}

export var mixin_payment_audit = {
	data: function () {
		return {};
	},

	methods: {
		handlePaymentAudit(row, e) {
			// 更新视图
			row.auditStatus = e;
			// 保存审核状态
			let _auditState = e ? '1' : '0';
			if (e === true) {
				paymentAudit({ ...row, auditStatus: _auditState }).then(() => {
					this.$message({
						type: 'success',
						message: '复核成功!'
					});
					this.getList();
				});
			} else {
				paymentAudit({ ...row, auditStatus: _auditState }).then(() => {
					this.$message({
						type: 'success',
						message: '取消复核!'
					});
					this.getList();
				});
			}
		}
	}
};
