import { excludeParams } from '../../../../api/tool/exclude';
import { addBusinessTrip, updateBusinessTrip } from '../../../../api/system/BusinessTrip';
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

			// **清空表单中的车辆申请ID列表**
			if (!this.form.params) {
				this.form.params = {};
			}
			this.form.params.carApplyIds = [];
		},
		// 新增操作
		handleAdd() {
			this.reset();
			// 不再固定设置当前用户，由用户通过SearchOption组件选择报销人
			// this.form.employee = this.trueName;
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

			// **车辆申请ID处理：根据是否使用车辆设置carApplyIds**
			if (useCar) {
				const carApplyIds = this.carsList
					.map(item => item.id)
					.filter(id => id != null && id !== undefined && !isNaN(Number(id)))
					.map(id => Number(id));

				// 校验车辆申请ID数组
				if (carApplyIds.length === 0) {
					this.$message.error('请至少选择一个有效的车辆申请');
					return;
				}

				formData.params.carApplyIds = carApplyIds;
			} else {
				// 不使用车辆时，传入空数组以清空原有关联（编辑场景）
				// 新增场景下传入空数组或不传都可以
				if (isEdit) {
					formData.params.carApplyIds = [];
				}
			}

			// 编辑逻辑
			if (isEdit) {
				updateBusinessTrip(excludeParams(formData, this.$exclude))
					.then(() => {
						handleSuccess('修改成功');
					})
					.catch(err => {
						console.error('编辑失败:', err);
						this.$message.error(err?.msg || '编辑失败');
					});
			} else {
				// 新增逻辑
				addBusinessTrip({ ...formData, UUID: this.UUID })
					.then(() => {
						const message = useCar ? '提交成功' : '提交成功，本次无车辆使用信息';
						handleSuccess(message);
					})
					.catch(err => {
						console.error('新增失败:', err);
						this.$message.error(err?.msg || '新增失败');
					});
			}
		},

		/**
		 * **车辆列表校验函数：核心业务逻辑**
		 * 当用户选择使用车辆时，必须满足以下条件：
		 * 1. 车辆列表不能为空
		 * 2. 每行车辆信息必须完整填写
		 * 3. 车辆申请ID必须是有效的数字
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

			// **车辆申请ID有效性校验**
			const validCarApplyIds = this.carsList.map(item => item.id).filter(id => id != null && id !== undefined && !isNaN(Number(id)) && Number(id) > 0);

			if (validCarApplyIds.length === 0) {
				this.$message.error('请至少选择一个有效的车辆申请');
				return false;
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
			if (!car.id || car.id === null || car.id === undefined) {
				this.$message.error(`第${rowNumber}行车辆未选择，请点击搜索按钮选择车辆`);
				return false;
			}

			// **车辆ID有效性校验：必须是有效的数字**
			const carId = Number(car.id);
			if (isNaN(carId) || carId <= 0 || !Number.isInteger(carId)) {
				this.$message.error(`第${rowNumber}行车辆申请ID无效，请重新选择车辆`);
				return false;
			}

			// **车牌号校验：数据一致性检查**
			if (!car.carNo || car.carNo.trim() === '') {
				this.$message.error(`第${rowNumber}行车牌号不能为空`);
				return false;
			}
			return true;
		},

		// 上传的回调函数
		handleCommitUpload(val) {
			this.form.attachmentPath = val;
		}
	}
};
