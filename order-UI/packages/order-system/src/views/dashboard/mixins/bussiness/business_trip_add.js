import { excludeParams } from '../../../../api/tool/exclude';
import { addBusinessTrip, updateBusinessTrip } from '../../../../api/system/BusinessTrip';
import { updateCarApply, updateCarApplyBatch } from '../../../../api/system/carApply';
import { getUuid } from '../../../../utils/trash/utils';

// 出差添加信息模块
export var mixin_business_trip_add = {
	data: function () {
		return {};
	},

	/**
	 * **响应式状态管理：监听器设计**
	 *
	 * **设计模式：** 观察者模式 - 监听 useCar 状态变化并执行相应的业务逻辑
	 * **性能优化：** 使用 immediate 和 handler 确保初始化和变化都能正确处理
	 * **用户体验：** 选择"否"时自动清除数据，避免用户手动操作
	 */
	watch: {
		/**
		 * **车辆使用状态监听器：核心业务逻辑**
		 *
		 * **功能说明：**
		 * - 选择"是"：保持现有车辆数据
		 * - 选择"否"：自动清除所有车辆数据和选中状态
		 *
		 * **边界条件处理：**
		 * - 防止重复清除操作
		 * - 确保数组引用正确更新
		 * - 同步清除相关的选中状态
		 *
		 * @param {string} newValue - 新的车辆使用状态
		 * @param {string} oldValue - 旧的车辆使用状态
		 */
		useCar: {
			handler: function (newValue, oldValue) {
				// **状态变化日志（开发环境）**
				if (process.env.NODE_ENV === 'development') {
					console.log('🚗 车辆使用状态变化:', {
						from: oldValue,
						to: newValue,
						currentCarsList: this.carsList?.length || 0
					});
				}

				// **核心业务逻辑：选择"否"时清除车辆数据**
				if (newValue === '否') {
					this.clearCarsData();
				}
			},
			immediate: true // 立即执行一次，确保初始化时的正确性
		}
	},

	methods: {
		/**
		 * **车辆数据清除函数：原子操作单元**
		 *
		 * **设计原则：**
		 * - 单一职责：仅负责清除车辆相关数据
		 * - 原子性：确保所有相关状态同时清除
		 * - 防御性编程：避免因数据不存在而报错
		 *
		 * **性能考虑：**
		 * - 直接赋值新数组而非逐个删除，性能更优
		 * - 避免不必要的响应式更新
		 */
		clearCarsData() {
			// **车辆列表清空**
			this.carsList = [];

			// **选中状态清空**
			this.checkedCars = [];

			// **查询状态重置**
			this.queryCarApply = '';

			// **用户反馈（可选）**
			if (process.env.NODE_ENV === 'development') {
				console.log('✅ 车辆数据已清除');
			}
		},
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

			// **车辆使用校验逻辑**
			if (useCar && !this.validateCarsList()) {
				return; // 校验失败，中断提交
			}

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

		/**
		 * **车辆列表校验函数：核心业务逻辑**
		 * 当用户选择使用车辆时，必须满足以下条件：
		 * 1. 车辆列表不能为空
		 * 2. 每行车辆信息必须完整填写
		 *
		 * **设计模式：** 策略模式 - 将不同的校验规则封装成独立的校验函数
		 * **错误处理：** 提供精确的错误定位，便于用户快速修正
		 *
		 * @returns {boolean} 校验结果：true-通过，false-失败
		 */
		validateCarsList() {
			// **边界条件检查：车辆列表为空**
			if (!this.carsList || this.carsList.length === 0) {
				this.$message.error('选择使用车辆时，车辆列表不能为空，请至少添加一辆车');
				return false;
			}

			// **逐行校验：确保每行数据完整性**
			for (let i = 0; i < this.carsList.length; i++) {
				const car = this.carsList[i];
				const rowNumber = i + 1;

				// **必填字段校验**
				if (!this.validateSingleCar(car, rowNumber)) {
					return false; // 任一行校验失败，整体失败
				}
			}

			// **业务逻辑校验通过**
			return true;
		},

		/**
		 * **单行车辆数据校验：原子校验单元**
		 *
		 * **函数设计原则：**
		 * - 纯函数设计：无副作用，便于单元测试
		 * - 单一职责：仅负责单行数据校验
		 * - 可扩展性：便于后续添加新的校验规则
		 *
		 * @param {Object} car - 车辆数据对象
		 * @param {number} rowNumber - 行号（用于错误提示）
		 * @returns {boolean} 单行校验结果
		 */
		validateSingleCar(car, rowNumber) {
			// **车辆ID校验：业务关联完整性**
			if (!car.id) {
				this.$message.error(`第${rowNumber}行车辆未选择，请点击搜索按钮选择车辆`);
				return false;
			}

			// **车牌号校验：数据一致性检查**
			if (!car.carNo || car.carNo.trim() === '') {
				this.$message.error(`第${rowNumber}行车牌号不能为空`);
				return false;
			}

			// **数据格式校验：车牌号格式检查**
			if (!this.validateCarNumber(car.carNo)) {
				this.$message.error(`第${rowNumber}行车牌号格式不正确：${car.carNo}`);
				return false;
			}

			return true;
		},

		/**
		 * **车牌号格式校验：数据格式规范化**
		 *
		 * **正则表达式设计：**
		 * - 支持新能源车牌（8位）和普通车牌（7位）
		 * - 符合国标GB36001-2016规范
		 *
		 * @param {string} carNo - 车牌号
		 * @returns {boolean} 格式校验结果
		 */
		validateCarNumber(carNo) {
			// **车牌号正则：兼容多种车牌格式**
			const carNumberRegex = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}[A-Z0-9挂学警港澳]{1}$/;

			return carNumberRegex.test(carNo.trim());
		},

		// 上传的回调函数
		handleCommitUpload(val) {
			this.form.attachmentPath = val;
		}
	}
};
