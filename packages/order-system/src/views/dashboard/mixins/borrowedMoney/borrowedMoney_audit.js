import instance from '../../../../utils/request';
import { debounce } from '@/utils/trash/utils';

export function borrowedMoneyAudit(params) {
	return instance.request({
		url: '/system/borrowedmoney/audit',
		method: 'put',
		params: {
			id: params.id,
			auditStatus: params.auditStatus
		}
	});
}

export var mixin_borrowedMoney_audit = {
	methods: {
		handleBorrowedMoneyAudit(row, e) {
			// 检查是否有权限
			if (!this.hasAuditPermission) {
				this.$message({
					type: 'warning',
					message: '您没有复核权限！'
				});
				// 还原开关状态
				row.auditState = e === '1' ? '0' : '1';
				return;
			}

			console.log(`e=>`, e);
			const debouncedAudit = debounce(function (row, auditStatus) {
				borrowedMoneyAudit({ ...row, auditStatus })
					.then(() => {
						const message = auditStatus === '1' ? '复核成功!' : '取消复核!';
						this.$message({
							type: 'success',
							message: message
						});
						this.getList();
					})
					.catch(() => {
						// 如果API调用失败，还原开关状态
						row.auditState = auditStatus === '1' ? '0' : '1';
					});
			}, 1000);

			// 更新视图
			row.auditStatus = e;
			// 调用防抖后的函数，传递最新的 row 和 auditStatus
			debouncedAudit.call(this, row, e);
		}
	}
};
