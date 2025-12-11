import { getBusinessTrip } from '../../../../api/system/BusinessTrip';
// 出差的修改模块
export var mixin_business_trip_update = {
	data: function () {
		return {};
	},

	methods: {
		// 修改操作
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			// 拿到该行id对应的出差信息
			getBusinessTrip(id).then(response => {
				this.form = response.data;

				// 确保附件数据正确加载
				this.form.attachmentList = response.data.attachmentList || [];
				// 确保 params 对象存在，用于统一附件处理
				if (!this.form.params) {
					this.form.params = {};
				}
				// 如果有现有附件，设置到 params.attachmentIds
				if (this.form.attachmentList.length > 0) {
					this.form.params.attachmentIds = this.form.attachmentList.map(item => item.id);
				}

				// 处理车辆派出信息：使用后端返回的 carApplyList
				const carApplyList = response.data.carApplyList || [];
				if (carApplyList.length === 0) {
					this.useCar = '否';
					this.carsList = [];
				} else {
					this.useCar = '是';
					// 将后端返回的车辆申请数据映射到表格显示格式
					this.carsList = carApplyList.map(item => ({
						id: item.id,
						carNo: item.carNo,
						applyDate: item.applyDate,
						applyUser: item.applyUser,
						department: item.department,
						startTime: item.startTime,
						endTime: item.endTime,
						applyPurpose: item.applyPurpose,
						auditState: item.auditState
					}));
				}
				// 报销项信息保存状态
				this.tripReimbursementList = response.data.tripReimbursementList || [];
				this.title = '修改出差';
				this.open = true;
			});
		}
	}
};
