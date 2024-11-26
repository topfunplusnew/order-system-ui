import { getBusinessTrip } from '../../../../api/system/BusinessTrip';
import { listCarApply } from '../../../../api/system/carApply';
// 出差的修改模块
export var mixin_business_trip_update = {
	data: function () {
		return {};
	},

	methods: {
		// 修改操作
		handleUpdate(row) {
			this.reset();
			this.resetCarApplyInformation();
			const id = row.id || this.ids;
			// 拿到该行id对应的出差信息
			getBusinessTrip(id).then(response => {
				this.form = response.data;
				// 查询该出差id下的用车信息
				listCarApply({ bTripId: id }).then(res => {
					if (res.rows.length === 0) {
						this.useCar = '否';
						this.$message.info('本出差信息无车辆使用记录');
					} else {
						this.useCar = '是';
						this.hasCarApplyInfo = true;
						this.$message.success('查询到本出差信息有车辆使用记录，已自动填充');
						this.carApplyInformation = res.rows[0];
					}
				});
				// 报销项信息保存状态
				this.tripReimbursementList = response.data.tripReimbursementList;
				this.title = '修改出差';
				this.open = true;
			});
		}
	}
};
