import instance from '../../../../utils/request';
import { debounce } from '@/utils/trash/utils';

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
	methods: {
		handlePaymentAudit(row, e) {
			const debouncedPaymentAudit = debounce(function (row, auditStatus) {
				paymentAudit({ ...row, auditStatus }).then(() => {
					const message = auditStatus === '1' ? '复核成功!' : '取消复核!';
					this.$message({
						type: 'success',
						message: message
					});
					this.getList();
				});
			}, 1000);
			// 更新视图
			row.auditStatus = e;
			// 保存审核状态
			let _auditState = e ? '1' : '0';

			// 调用防抖后的函数，传递最新的 row 和 auditStatus
			debouncedPaymentAudit.call(this, row, _auditState);
		}
	}
};
