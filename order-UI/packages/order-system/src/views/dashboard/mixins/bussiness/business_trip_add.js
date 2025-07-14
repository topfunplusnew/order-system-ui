import { excludeParams } from '../../../../api/tool/exclude';
import { addBusinessTrip, updateBusinessTrip } from '../../../../api/system/BusinessTrip';
import { updateCarApply, updateCarApplyBatch } from '../../../../api/system/carApply';
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
			this.form.employee = this.trueName;
			this.open = true;
			this.title = '添加出差';
			this.UUID = getUuid();
		},
		// 点击上一步
		before() {
			if (this.active-- <= 0) this.active = 0;
		},
		next() {
			if (this.active++ > 2) {
				this.active = 0;
			}
		},
		// 完成提交
		nextAndSubmit() {
			const isEdit = !!this.form.id; // 判断是新增还是编辑
			const useCar = this.useCar === '是'; // 是否使用车辆

			// 通用成功处理逻辑
			const handleSuccess = message => {
				this.$message.success(message);
				this.active++;
				this.$refs.uploadFile?.clearUploadedFiles();
				this.reset();
				this.open = false;
				this.getList();
			};

			// 保存报销信息
			this.form.tripReimbursementList = this.tripReimbursementList;

			// 统一的附件处理：确保 params 对象存在并包含附件ID
			const formData = { ...this.form };
			if (!formData.params) {
				formData.params = {};
			}
			// 如果通过上传组件已设置了 attachmentIds，则保持；否则从 attachmentList 获取
			if (!formData.params.attachmentIds && this.form.attachmentList) {
				formData.params.attachmentIds = this.form.attachmentList.map(item => item.id);
			}

			// 编辑逻辑
			if (isEdit) {
				updateBusinessTrip(excludeParams(formData, this.$exclude))
					.then(() => {
						if (useCar) {
							const body = {
								bTripId: this.form.id,
								carApplyIds: this.carsList.map(item => item.id).join(',')
							};
							updateCarApplyBatch(body).then(() => {
								handleSuccess('车辆信息修改成功');
							});
						} else {
							handleSuccess('修改成功');
						}
					})
					.catch(err => {
						console.error('编辑失败:', err);
					});
			} else {
				// 新增逻辑
				addBusinessTrip({ ...formData, UUID: this.UUID })
					.then(res => {
						if (useCar) {
							const body = {
								bTripId: res.data.id,
								carApplyIds: this.carsList.map(item => item.id).join(',')
							};
							// 提交车辆信息
							updateCarApplyBatch(body).then(() => {
								handleSuccess('车辆信息提交成功');
							});
						} else {
							handleSuccess('提交成功，本次无车辆使用信息');
						}
					})
					.catch(err => {
						console.error('新增失败:', err);
					});
			}
		},

		// 上传的回调函数
		handleCommitUpload(val) {
			this.form.attachmentPath = val;
		}
	}
};
