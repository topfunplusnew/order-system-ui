import { excludeParams } from '../../../../api/tool/exclude';
import {
	addBusinessTrip,
	updateBusinessTrip
} from '../../../../api/system/BusinessTrip';
import { updateCarApply } from '../../../../api/system/carApply';
import { getUuid } from '../../../../utils/trash/utils';

// 出差添加信息模块
export var mixin_business_trip_add = {
	data: function () {
		return {};
	},

	methods: {
		// 新增操作
		handleAdd() {
			this.reset();
			this.resetCarApplyInformation(); // 重置车辆的保存信息
			this.form.employee = this.trueName;
			this.open = true;
			this.title = '添加出差';
			// 生成一个UUID 保存在Vue实例上，单次填写生成的UUID是唯一的
			this.UUID = getUuid();
		},
		// 点击上一步
		before() {
			if (this.active-- <= 0) this.active = 0;
		},
		// 点击下一步 业务为 保存出差基本信息，开始填写车辆使用信息
		next() {
			if (this.active++ > 2) {
				this.active = 0;
			}
		},
		// 完成提交
		nextAndSubmit() {
			// 修改
			if (
				this.form.id !== null &&
				this.form.id !== '' &&
				this.form.id !== undefined
			) {
				// 保存报销信息
				this.form.tripReimbursementList = this.tripReimbursementList;
				// 修改 出差信息
				updateBusinessTrip(excludeParams(this.form, this.$exclude)).then(
					res => {
						// 修改 - 如果不使用车辆信息
						if (this.useCar !== '是') {
							this.$message.success('修改成功');
							this.resetCarApplyForm();
							this.resetOilCardRechargeInfo();
							this.resetCarApplyInformation();
							this.reset();
							this.open = false;
							this.getList();
							// 修改 - 使用车辆信息
						} else {
							this.$message.success('修改成功');
							// 修改该出差的车辆信息
							updateCarApply(
								excludeParams(this.carApplyInformation, this.$exclude)
							).then(res => {
								this.$message.success('车辆信息修改成功');
								this.active++;
								this.$refs.uploadFile.clearFileList();
								this.resetCarApplyInformation();
								this.resetCarApplyForm();
								this.resetOilCardRechargeInfo();
								this.reset();
								this.open = false;
								this.getList();
							});
						}
					}
				);
				// 添加
			} else {
				//  添加 - 如果不使用车辆
				if (this.useCar !== '是') {
					// 保存报销信息
					this.form.tripReimbursementList = this.tripReimbursementList;
					addBusinessTrip({ ...this.form, UUID: this.UUID }).then(res => {
						this.$message.success('提交成功,本次无车辆使用信息');
						this.active++;
						this.$refs.uploadFile.clearFileList();
						// 清除状态
						this.reset();
						this.resetCarApplyForm();
						this.resetOilCardRechargeInfo();
						this.resetCarApplyInformation();
						this.getList();
					});
					// 添加 - 如果使用车辆
				} else {
					// 保存报销信息
					this.form.tripReimbursementList = this.tripReimbursementList;
					// 先提交申请信息 回调函数中添加车辆使用信息
					addBusinessTrip({ ...this.form, UUID: this.UUID }).then(res => {
						this.$message.success('提交成功');
						// 如果不是索引车辆信息
						this.carApplyInformation.bTripId = res.data.id; // 添加出差id
						// 添加车辆信息
						updateCarApply(this.carApplyInformation).then(res => {
							this.$message.success('车辆信息提交成功');
							this.active++;
							this.$refs.uploadFile.clearFileList();
							// 清除状态
							this.reset();
							this.resetCarApplyForm();
							this.resetOilCardRechargeInfo();
							this.resetCarApplyInformation();
							this.getList();
						});
					});
				}
			}
		},
		// 上传的回调函数
		handleCommitUpload(val) {
			this.form.attachmentPath = val;
		}
	}
};
