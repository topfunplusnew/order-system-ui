import { listCarApply } from '../../../../api/system/carApply';
// 出差车辆索引列表模块 车辆申请信息
export var mixin_car_apply = {
	data: function () {
		return {
			// 车辆申请信息
			carApplyInformation: {},
			// 是否有车辆信息
			hasCarApplyInfo: false,
			indexCarApplyVisible: false,
			carApplyList: [],

			// 是否是索引车辆使用信息
			isIndexCarInfo: false
		};
	},
	methods: {
		// 索引车辆使用信息
		indexCarApplyInfo() {
			listCarApply().then(res => {
				this.carApplyList = res.rows;
				this.indexCarApplyVisible = true;
			});
		},
		// 引用该车辆使用信息
		indexThisCarApplyInfo(row) {
			// 要判断 如果保养了 那么就推入 没有保养不推入
			if (row.isMaintenance === '是') {
				// 将保养金额填充到列表里
				this.tripReimbursementList.push({
					index: this.tripReimbursementList.length + 1,
					item: '车辆保养金额',
					itemCost: row.maintenanceMoney,
					isDisabled: true // 不可更改
				});
			}
			// 保存车辆使用信息
			this.carApplyInformation = row;
			this.hasCarApplyInfo = true;
			this.$message.success('车辆信息引用成功~');
			// 是索引车辆信息
			this.isIndexCarInfo = true;
			this.indexCarApplyVisible = false;
		}
	}
};
