<script>
import { listCars } from '../../../../api/system/cars';
import { listCompany } from '../../../../api/system/company';
import { listFleet } from '../../../../api/system/fleet';
import { listExitInventory } from '../../../../api/system/inventoryMain';
import { addGoodsOrder, getGoodsOrder, updateGoodsOrder } from '../../../../api/system/goodsOrder';
import { listProductLevel } from '../../../../api/system/productLevel';
import { excludeParams } from '../../../../api/tool/exclude';
import { fix_2 } from '../../../../api/tool/format';
import SearchOption from '../../../../components/SearchOption.vue';
import { parseTime } from '../../../../utils/ruoyi';
import { mixin_form_fillInfo } from '../../mixins/order/form/form_fillInfo';
import { updateOrderRowCalculations } from './orderCalculations';
import _ from 'lodash';
import { handlePriceInput as utilHandlePriceInput, formatPriceInput as utilFormatPriceInput, handlePriceFocus as utilHandlePriceFocus, formatPiecesValue, handlePiecesInput as utilHandlePiecesInput, getRowClassName as utilGetRowClassName, initSpecialFieldDecimalPlaces } from '@/utils/order';

export default {
	name: 'OrderForm',
	components: { SearchOption },
	mixins: [mixin_form_fillInfo],
	props: {
		orderId: {
			type: Number,
			default: () => null
		},
		submitInfo: {
			type: String,
			default: () => '提交'
		}
	},
	data() {
		// 自定义校验器：当选择陆运时，车队必填 (已存在)
		const validateFleet = (rule, value, callback) => {
			if (this.isLand && !this.orderInfo.fleet) {
				callback(new Error('选择陆运时，请选择车队'));
			} else {
				callback();
			}
		};
		// 自定义校验器：当选择陆运时，必须选择车牌信息
		const validateLandCar = (rule, value, callback) => {
			if (this.isLand && !this.orderInfo.landCarNo) {
				callback(new Error('选择陆运时，请选择车牌信息'));
			} else {
				callback();
			}
		};
		// 自定义校验器：当选择海运时，柜号必填
		const validateSeaCarNo = (rule, value, callback) => {
			if (this.isSea && !value) {
				callback(new Error('选择海运时，柜号不能为空'));
			} else {
				callback();
			}
		};
		// 自定义校验器：当选择海运时，海运公司必填
		const validateSeaDriverName = (rule, value, callback) => {
			if (this.isSea && !this.orderInfo.seaDriverName) {
				callback(new Error('选择海运时，请选择海运公司信息'));
			} else {
				callback();
			}
		};

		// 存储一套用于发送后端的表单数据，一套用于用户前端编辑，点击保存时将设置为已编辑的数据 根据id 替换元数据某行 并将元数据发送后端

		return {
			// 订单原始数据 用于发送后端
			orderInfo: {},
			orderDetailList: [],
			orderRules: {
				// 添加或更新校验规则
				fleet: [{ validator: validateFleet, trigger: 'blur' }], // 触发改为 change
				landCarNo: [{ validator: validateLandCar, trigger: 'change' }], // 添加陆运车牌校验
				seaCarNo: [{ validator: validateSeaCarNo, trigger: 'blur' }], // 添加海运柜号校验
				seaDriverName: [{ validator: validateSeaDriverName, trigger: 'change' }], // 添加海运公司校验
				orderDate: [
					{
						required: true,
						message: '请选择订单日期',
						trigger: 'blur'
					}
				],
				customer: [{ required: true, message: '请选择客户', trigger: 'blur' }],
				saleManager: [
					{
						required: true,
						message: '请输入销售经理',
						trigger: 'blur'
					}
				]
			},
			checkedOrderdetail: [],
			isEditingDetails: false, // 保留全局编辑状态用于添加/删除行操作
			isLand: false,
			isSea: false,
			querySupplier: null,
			queryLevel: null,
			queryStoreHouseName: null,
			queryItemsCompany: {
				queryList: [
					{
						id: 1,
						label: '老板姓名',
						prop: 'leader',
						type: 'input',
						value: ''
					}
				]
			},
			queryItemsOrder: {
				queryList: [
					{
						id: 1,
						label: '厚度',
						prop: 'height',
						type: 'input',
						value: ''
					},
					{
						id: 2,
						label: '长度',
						prop: 'length',
						type: 'input',
						value: ''
					},
					{
						id: 3,
						label: '宽度',
						prop: 'width',
						type: 'input',
						value: ''
					},
					{
						id: 4,
						label: '分类名称',
						prop: 'categoryName',
						type: 'input',
						value: ''
					}
				]
			},
			queryItemsStoreHouse: {
				queryList: [
					{
						id: 1,
						label: '级别名称',
						prop: 'levelName',
						type: 'input',
						extraInfo: {
							__isParams: true
						},
						value: ''
					},
					{
						id: 2,
						label: '厚度',
						prop: 'height',
						type: 'input',
						extraInfo: {
							__isParams: false
						},
						value: ''
					},
					{
						id: 3,
						label: '长度',
						prop: 'length',
						type: 'input',
						extraInfo: {
							__isParams: false
						},
						value: ''
					},
					{
						id: 4,
						label: '宽度',
						prop: 'width',
						type: 'input',
						extraInfo: {
							__isParams: false
						},
						value: ''
					}
				]
			},
			// 当前是编辑订单还是添加订单 编辑订单此值非空,添加订单为空
			isEditingOrder: {
				id: '',
				state: false,
				currentEditingOrderInfo: {}
			}
		};
	},
	computed: {
		// 添加计算属性检查是否有子项（排除已删除的行）
		hasOrderDetails() {
			return this.visibleOrderDetailList && this.visibleOrderDetailList.length > 0;
		},
		// 检查是否有任何行正在编辑（排除已删除的行）
		hasEditingRows() {
			return this.visibleOrderDetailList && this.visibleOrderDetailList.some(row => row.isEditing);
		},
		// 过滤掉已删除的行，用于表格显示
		visibleOrderDetailList() {
			return this.orderDetailList.filter(row => !row.isDeleted);
		},
		// 获取所有已标记删除的行
		deletedOrderDetailList() {
			return this.orderDetailList.filter(row => row.isDeleted === true);
		}
	},
	created() {
		this.resetOrderInfo();
		this.isEditingDetails = false;
		this.orderId && this.getGoodsOrderInfo(this.orderId);
	},
	methods: {
		/** 获取车队列表 */
		listFleet,
		/** 获取车辆列表 */
		listCars,
		/** 获取公司列表 */
		listCompany,
		/** 获取产品级别列表 */
		listProductLevel,
		/** 获取出库库存列表 */
		listExitInventory,
		/**
		 * 根据订单ID获取订单信息
		 * @param {Number} id - 订单ID
		 */
		getGoodsOrderInfo(id) {
			if (!id) {
				throw new Error('获取订单信息失败，id为空');
			}
			getGoodsOrder(id).then(response => {
				this.orderInfo = response.data;
				if (!response.data) {
					this.$message.error('查询数据时出错,未找到该行id对应的订单');
					return;
				}
				this.isLand = !!response.data.landCarNo;
				this.isSea = !!response.data.seaCarNo;
				const orderInfo = _.cloneDeep(response.data);
				// 设置正在编辑态
				this.setIsEditingOrder(orderInfo, false);

				// 对订单明细信息进行处理
				if (orderInfo.orderDetailList && Array.isArray(orderInfo.orderDetailList)) {
					const detailList = _.cloneDeep(orderInfo.orderDetailList) || [];
					if (!detailList.length || detailList.length === 0) {
						this.$message.error('未查询到该订单的明细信息');
						return;
					}
					if (detailList.some(item => !item.id)) {
						this.$message.error('数据错误，某行中缺少id!');
						return;
					}
					this.orderDetailList = detailList.map(item => {
						if (item.supplier) {
							item.currentType = 'supplier';
						} else {
							item.currentType = 'storeHouseName';
						}
						const processedItem = {
							...item,
							isEditing: false,
							isDeleted: item.isDeleted !== undefined ? item.isDeleted : false, // 确保 isDeleted 字段存在
							isAdd: false // 从后端加载的数据标记为非新增
						};
						// 初始化特殊字段的小数位数
						initSpecialFieldDecimalPlaces(processedItem);
						return processedItem;
					});

					// 对加载的数据进行计算
					this.orderDetailList.forEach(row => {
						this.$nextTick(() => {
							// 确保DOM更新后再计算，虽然这里主要是数据计算
							updateOrderRowCalculations(row, this.isSea, this.isLand);
						});
					});
				}
			});
		},
		/**
		 * 处理行编辑事件
		 * @param {Object} row - 当前编辑的行数据
		 */
		handleRowEdit(row) {
			// 设置当前行为可编辑
			this.$set(row, 'isEditing', true);
			// 清除错误状态
			if (row.hasError) {
				this.$set(row, 'hasError', false);
			}
		},

		/**
		 * 处理行保存事件
		 * @param {Object|Array} row - 当前保存的行数据或行数据数组
		 * @param {Function} [resolve=null] - Promise resolve回调
		 * @param {Function} [reject=null] - Promise reject回调
		 */
		handleRowSave(row, resolve = null, reject = null) {
			// 统一处理输入，确保 rows 是数组
			const rows = Array.isArray(row) ? row : [row];
			// 处理每一行，关闭编辑状态并更新计算
			rows.forEach(r => {
				if (r.isEditing && !r.isDeleted) {
					this.$set(r, 'isEditing', false);
					updateOrderRowCalculations(r, this.isSea, this.isLand);
				}
			});
			// 深拷贝并过滤掉仍在编辑的行和已删除的行（已删除的行单独处理）
			const rowsToSave = rows.filter(item => !item.isEditing && !item.isDeleted);
			let saveDetails = this.fillOrderDetailInfo(_.cloneDeep(rowsToSave));

			// 过滤掉空白行（所有业务字段都为空的行）
			const originalCount = saveDetails.length;
			saveDetails = saveDetails.filter(detail => !this.isOrderDetailEmpty(detail));

			// 收集所有已标记删除的行（需要一起发送给后端）
			const deletedDetails = this.fillOrderDetailInfo(_.cloneDeep(this.deletedOrderDetailList));

			// 合并正常保存的行和已删除的行
			const allDetails = [...saveDetails, ...deletedDetails];

			// 检查是否至少有一些有效数据（正常数据或已删除数据）
			if (allDetails.length === 0) {
				this.$message.error('请添加有效的货物信息!');
				if (reject) reject(new Error('请添加有效的货物信息'));
				return;
			}

			// 如果过滤掉了一些空白行，给用户提示
			const filteredCount = originalCount - saveDetails.length;
			if (filteredCount > 0) {
				this.$message.info(`已自动过滤掉${filteredCount}条空白明细行`);
			}

			// 如果有已删除的行，提示用户
			if (deletedDetails.length > 0) {
				console.log(`保存时包含${deletedDetails.length}条已标记删除的数据`);
			}

			// 构造新的订单信息（包含正常数据和已删除数据）
			const newOrderInfo = {
				...this.orderInfo,
				orderDetailList: allDetails
			};
			if (this.isEditingOrder.id) {
				newOrderInfo.id = this.isEditingOrder.id;
			}
			this.addOrUpdateOrderDetail(newOrderInfo, rows, resolve, reject, row);
		},
		/**
		 * 添加或更新订单详情
		 * @param {Object} newOrderInfo - 新的订单信息
		 * @param {Array} rows - 相关的行数据
		 * @param {Function} [resolve=null] - Promise resolve回调
		 * @param {Function} [reject=null] - Promise reject回调
		 */
		addOrUpdateOrderDetail(newOrderInfo, rows, resolve = null, reject = null, row = null) {
			const editReason = sessionStorage.getItem('goodsorder-edit-reason');
			// 保存row的引用，避免在Promise链中丢失
			const currentRows = rows;
			if (this.isEditingOrder.id) {
				updateGoodsOrder({ ...newOrderInfo, editReason })
					.then(res => {
						// 成功后清除可能的错误标记
						currentRows.forEach(row => {
							if (row.hasError) {
								this.$set(row, 'hasError', false);
							}
						});
						const orderInfo = _.cloneDeep(res.data);
						if (!orderInfo || !orderInfo.orderDetailList || orderInfo.orderDetailList.length === 0) {
							this.$message.error('保存失败，保存后未找到相应数据');
							this.isEditingDetails = true;
							reject && reject();
							return;
						}
						// 如果该行是新增行，则从后端返回的数据中找到index等于该行数据的index的id，并赋值给该行 并且将isAdd标记为false
						if (row && row.isAdd) {
							const orderRow = orderInfo.orderDetailList.find(item => item.index === row.index);
							if (!orderRow) {
								this.$message.error('保存失败，新增的数据索引并未找到服务器对应索引的数据，请联系管理员!');
								this.isEditingDetails = true;
								reject && reject();
								return;
							}
							row.id = orderRow.id;
							row.isAdd = false;
						}
						this.$message.success('该行订单详情信息已修改并保存!');
						resolve && resolve();
					})
					.catch(error => {
						currentRows.forEach(row => {
							// 使用Vue的响应式方法确保UI更新
							this.$set(row, 'isEditing', true);
							this.$set(row, 'hasError', true); // 添加错误标记
						});
						this.$message.error('保存失败，请重新编辑: ' + (error.message || '未知错误'));
						this.isEditingDetails = true;
						reject && reject();
					});
			} else {
				addGoodsOrder(newOrderInfo)
					.then(res => {
						// 成功后清除可能的错误标记
						currentRows.forEach(row => {
							if (row.hasError) {
								this.$set(row, 'hasError', false);
							}
						});
						const orderInfo = _.cloneDeep(res.data);
						if (!orderInfo || !orderInfo.orderDetailList || orderInfo.orderDetailList.length === 0) {
							this.$message.error('保存失败，保存后服务器订单详情响应数据为空，请联系管理员!');
							this.isEditingDetails = true;
							reject && reject();
							return;
						}
						// 如果该行是新增行，则从后端返回的数据中找到index等于该行数据的index的id，并赋值给该行 并且将isAdd标记为false
						if (row && row.isAdd) {
							const orderRow = orderInfo.orderDetailList.find(item => item.index === row.index);
							if (!orderRow) {
								this.$message.error('保存失败，新增的数据索引并未找到服务器对应索引的数据，请联系管理员!');
								this.isEditingDetails = true;
								reject && reject();
								return;
							}
							row.id = orderRow.id;
							row.isAdd = false;
						}

						this.$nextTick(() => {
							Object.assign(this.orderInfo, orderInfo);
							this.$message.success('该行订单详情信息已添加并保存!');
							// 设置当前正在编辑的订单是哪条订单
							this.setIsEditingOrder(_.cloneDeep(res.data), true);
							resolve && resolve();
						});
					})
					.catch(error => {
						currentRows.forEach(row => {
							this.$set(row, 'isEditing', true);
							this.$set(row, 'hasError', true);
						});
						this.$message.error('保存失败，请重新编辑: ' + (error.message || '未知错误'));
						this.isEditingDetails = true;
						reject && reject();
					});
			}
		},
		/**
		 * 设置当前正在编辑的订单信息和状态
		 * @param {Object} response - 订单信息响应数据
		 * @param {boolean} [flag=true] - 编辑状态标志
		 */
		setIsEditingOrder(response, flag = true) {
			if (response != null) {
				this.isEditingOrder.id = response.id;
			}
			this.isEditingOrder.state = flag;
			this.isEditingOrder.currentEditingOrderInfo = response;
		},
		/** 添加新的订单详情行 */
		handleAddOrderdetail() {
			const arrMaxItem = _.maxBy(this.orderDetailList, 'index');
			let obj = {
				// 添加唯一索引
				index: arrMaxItem ? arrMaxItem.index + 1 : 1,
				orderDate: parseTime(new Date()),
				supplier: '',
				supplierID: '',
				customer: '',
				customerID: '',
				levelID: '',
				levelName: '',
				countingUnit: '片',
				height: '',
				length: '',
				width: '',
				piecesPerPack: '',
				pieces: '',
				packs: '',
				price: '',
				isIncludeTaxFactory: 0,
				sundryCost: '',
				paymentFactory: '',
				paymentUnload: '',
				isIncludeTaxSale: 0,
				payments: '',
				erro: '',
				tonnage: '',
				landFreightPrice: '',
				landFreight: '',
				seaFreight: '',
				freight: '',
				otherCost: '',
				profit: '',
				profitNoTax: '',
				actualPieces: '',
				paymentsWithSundry: '',
				additionalFees: '',
				storeHouseID: '',
				storeHouseName: '',
				storeID: '',
				logisticsProfit: '',
				customerCommission: '',
				factoryCommission: '',
				isAdjusted: 0,
				adjustOrderNo: '',
				adjustDate: '',
				factoryRebateAmount: '',
				factoryDiscountAmount: '',
				comments: '',
				isEditing: true, // 默认处于编辑状态
				isDeleted: false, // 新添加的行未删除
				isAdd: true // 标记为新增行
			};
			this.orderDetailList.push(obj);
			this.$nextTick(() => {
				if (this.$refs.orderdetail) {
					const bodyWrapper = this.$refs.orderdetail.bodyWrapper;
					if (bodyWrapper) {
						bodyWrapper.scrollLeft = 0;
					}
				}
			});
		},
		/**
		 * 复制指定行数据并在末尾添加
		 * @param {Object} row - 要复制的行数据
		 */
		handleCopyRow(row) {
			// 深拷贝行数据
			const copiedRow = _.cloneDeep(row);
			// 清除 id，因为这是新行
			copiedRow.id = undefined;
			// 设置新的索引
			copiedRow.index = _.maxBy(this.orderDetailList, 'index')?.index + 1;
			// 设置为编辑状态
			copiedRow.isEditing = true;
			// 标记为新增行
			copiedRow.isAdd = true;
			// 清除删除标记
			copiedRow.isDeleted = false;
			// 清除错误标记
			copiedRow.hasError = false;
			// 添加到列表末尾
			this.orderDetailList.push(copiedRow);
			this.$message.success('已复制该行数据');
			// 滚动到底部显示新添加的行
			this.$nextTick(() => {
				if (this.$refs.orderdetail) {
					const bodyWrapper = this.$refs.orderdetail.bodyWrapper;
					if (bodyWrapper) {
						bodyWrapper.scrollTop = bodyWrapper.scrollHeight;
					}
				}
			});
		},
		/**
		 * 处理出厂片数变化，自动填充卸货片数并重新计算
		 * @param {Object} scope - 表格行作用域对象
		 */
		handlePiecesChange(scope) {
			// 将出厂片数的值赋给卸货片数
			scope.row.actualPieces = scope.row.pieces;
			// 触发重新计算
			this.recalculateAll(scope);
		},
		/**
		 * 过滤掉库存数量为0或以下的库存条目，并按库存数量降序排序
		 * @param {Array} data - 原始库存数据列表
		 * @returns {Promise<Array>} 过滤和排序后的库存数据列表
		 */
		filterNoStockNumber(data) {
			return new Promise(resolve => {
				const res = data.filter(item => item.actualPieces > 0).sort((a, b) => b.actualPieces - a.actualPieces);
				resolve(res);
			});
		},
		/** 删除选中的订单详情行（标记为已删除，不真正删除） */
		handleDeleteOrderdetail() {
			if (this.checkedOrderdetail.length === 0) {
				this.$message.error('请先选择要删除的订单详情数据');
			} else {
				const checkedItems = this.checkedOrderdetail;
				let deletedCount = 0;
				// 将选中的行标记为已删除
				// 直接遍历 checkedItems，在 orderDetailList 中找到对应的行
				checkedItems.forEach(checked => {
					// 在 orderDetailList 中查找匹配的行
					const matchedItem = this.orderDetailList.find(item => {
						// 如果 checked 是数字（id），直接比较
						if (typeof checked === 'number') {
							return item.id === checked;
						}
						// 如果 checked 是对象，比较引用或 id
						if (typeof checked === 'object' && checked !== null) {
							// 对象引用相同，或者 id 相同
							return checked === item || (item.id !== undefined && item.id !== null && checked.id !== undefined && checked.id !== null && item.id === checked.id);
						}
						return false;
					});

					if (matchedItem) {
						// 如果该行已经有id（已保存的数据），标记为删除
						if (matchedItem.id !== undefined && matchedItem.id !== null) {
							this.$set(matchedItem, 'isDeleted', true);
							// 清除编辑状态
							this.$set(matchedItem, 'isEditing', false);
							deletedCount++;
						} else {
							// 如果是新添加但未保存的行，直接删除
							const index = this.orderDetailList.indexOf(matchedItem);
							if (index > -1) {
								this.orderDetailList.splice(index, 1);
								deletedCount++;
							}
						}
					}
				});
				// 清空选中项
				this.checkedOrderdetail = [];
				// 清除表格的选中状态
				if (this.$refs.orderdetail) {
					this.$refs.orderdetail.clearSelection();
				}
				if (deletedCount > 0) {
					this.$message.success(`已标记${deletedCount}条数据为删除状态，保存时将提交删除操作`);
				}
			}
		},
		/**
		 * 计算表格合计行数据
		 * @param {Object} param - 表格合计参数，包含columns和data
		 * @returns {Array} 合计行数据数组
		 */
		getSummary(param) {
			const { columns, data } = param;
			const sums = [];
			const summaryColumns = ['paymentFactory', 'payments', 'tonnage', 'landFreight', 'seaFreight', 'freight', 'profit', 'profitNoTax'];

			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				if (summaryColumns.includes(column.property)) {
					const values = data.map(item => Number(item[column.property]));
					if (!values.every(value => isNaN(value))) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = fix_2(sums[index]);
						sums[index] += column.property === 'tonnage' ? ' 吨' : ' 元';
					} else {
						sums[index] = 'N/A';
					}
				}
			});

			return sums;
		},
		/**
		 * 处理订单详情表格选择项变化事件
		 * @param {Array} selection - 当前选中的行数据数组
		 */
		handleOrderdetailSelectionChange(selection) {
			console.log(selection);
			// 存储选中行的唯一标识：优先使用 id，如果没有 id 则使用对象引用
			// 注意：id 可能是 0，所以不能用简单的 item.id || item 判断
			this.checkedOrderdetail = selection.map(item => {
				// 如果 id 存在且不为 null/undefined，使用 id；否则使用对象引用
				return item.id !== undefined && item.id !== null ? item.id : item;
			});
			console.log(`selection identifiers`, this.checkedOrderdetail);
		},
		/**
		 * 更新仓库查询名称
		 * @param {String} value - 查询值
		 */
		handleUpdateQueryNameStore(value) {
			this.queryStoreHouseName = value;
		},
		/**
		 * 更新供应商查询名称
		 * @param {String} value - 查询值
		 */
		handleUpdateQuerySupplier(value) {
			this.querySupplier = value;
		},
		/**
		 * 更新级别查询名称
		 * @param {String} value - 查询值
		 */
		handleUpdateQueryNameLevel(value) {
			this.queryLevel = value;
		},
		/**
		 * 处理供应商信息选择回调
		 * @param {Object} scope - 表格行作用域对象
		 * @param {Object} val - 选择的供应商信息
		 */
		handleCommitBackSupplier(scope, val) {
			scope.row.currentType = 'supplier';
			scope.row.supplier = val.companyName;
			scope.row.supplierID = val.id;
		},
		/**
		 * 处理库存信息选择回调
		 * @param {Object} scope - 表格行作用域对象
		 * @param {Object} val - 选择的库存信息
		 */
		handleCommitBackInventory(scope, val) {
			this.clearDetail(scope);
			scope.row.currentType = 'storeHouseName';
			scope.row.storeID = val.id;
			scope.row.storeHouseID = val.storeHouseid;
			scope.row.storeHouseName = val.storeHouseName;
			scope.row.length = val.length;
			scope.row.height = val.height;
			scope.row.width = val.width;
			scope.row.levelID = val.levelID;
			scope.row.levelName = val.levelName;
			scope.row.erro = val.erro;
			// 填充出厂单价（库存为填充存货价）
			// TODO 这里改为填充出厂价格
			scope.row.price = val.paymentUnload;
			// 填充后重新计算
			updateOrderRowCalculations(scope.row, this.isSea, this.isLand);
		},
		/**
		 * 处理产品级别信息选择回调
		 * @param {Object} scope - 表格行作用域对象
		 * @param {Object} val - 选择的产品级别信息
		 */
		handleCommitBackProductLevel(scope, val) {
			scope.row.erro = val.tonnage;
			scope.row.levelID = val.id;
			scope.row.levelName = val.levelName;
			scope.row.height = val.height;
			scope.row.length = val.length;
			scope.row.width = val.width;
			scope.row.levelNo = val.levelNo;
			// 填充后重新计算
			updateOrderRowCalculations(scope.row, this.isSea, this.isLand);
		},
		/**
		 * 重新计算指定行的所有相关数据
		 * @param {Object} scope - 表格行作用域对象
		 */
		recalculateAll(scope) {
			updateOrderRowCalculations(scope.row, this.isSea, this.isLand);
		},
		/**
		 * 设置当前行输入框的类型（供应商或仓库）
		 * @param {Object} row - 当前行数据
		 * @param {String} type - 类型字符串 ('supplier' 或 'storeHouseName')
		 */
		setCurrentType(row, type) {
			row.currentType = type;
		},
		/**
		 * 填充订单详情列表中的必要订单信息
		 * @param {Array} [detailList=this.orderdetailList] - 订单详情列表
		 * @returns {Array} 填充信息后的订单详情列表
		 */
		fillOrderDetailInfo(detailList = this.orderDetailList) {
			const formatOrderItem = () => ({
				customerID: this.orderInfo.customerID,
				customer: this.orderInfo.customer,
				orderDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}')
			});
			return _.cloneDeep(detailList).map(item => Object.assign(item, formatOrderItem()));
		},
		/**
		 * 提交订单（添加或更新）
		 * @param {Function} resolve - Promise resolve回调
		 * @param {Function} reject - Promise reject回调
		 */
		submitOrder(resolve, reject) {
			// 填充订单详情信息（排除已删除的行）
			const visibleDetails = this.fillOrderDetailInfo(_.cloneDeep(this.visibleOrderDetailList));

			// 填充已删除的行信息
			const deletedDetails = this.fillOrderDetailInfo(_.cloneDeep(this.deletedOrderDetailList));

			// 过滤掉空白行（所有业务字段都为空的行），但保留已删除的行
			const filteredVisibleDetails = visibleDetails.filter(detail => !this.isOrderDetailEmpty(detail));

			// 合并正常数据和已删除数据
			const allOrderDetails = [...filteredVisibleDetails, ...deletedDetails];

			// 检查是否至少有一些有效数据（正常数据或已删除数据）
			if (allOrderDetails.length === 0) {
				this.$message.error('请添加有效的货物信息!');
				reject(new Error('请添加有效的货物信息'));
				return;
			}

			// 如果过滤掉了一些空白行，给用户提示
			const filteredCount = visibleDetails.length - filteredVisibleDetails.length;
			if (filteredCount > 0) {
				this.$message.info(`已自动过滤掉${filteredCount}条空白明细行`);
			}

			// 如果有已删除的行，提示用户
			if (deletedDetails.length > 0) {
				console.log(`提交时包含${deletedDetails.length}条已标记删除的数据`);
			}

			this.orderInfo.orderDetailList = _.cloneDeep(allOrderDetails);
			this.orderInfo = excludeParams(this.orderInfo, this.$exclude);
			let json = _.cloneDeep(this.orderInfo);
			if (!this.isEditingOrder.id) {
				addGoodsOrder(json)
					.then(() => resolve())
					.catch(() => reject());
			} else {
				// 从sessionStorage中读取修改原因
				const editReason = sessionStorage.getItem('goodsorder-edit-reason');
				if (editReason) {
					json.editReason = editReason;
				}
				updateGoodsOrder(json)
					.then(() => resolve())
					.catch(() => reject());
			}
		},
		/**
		 * 重置表单和相关状态
		 * @param {Object} that - 父组件实例（通常是弹窗组件）
		 */
		reset(that) {
			// 清除订单状态
			this.resetOrderInfo();
			// 清除陆运和海运的状态
			this.isSea = false;
			this.isLand = false;
			// 清除sessionStorage中的修改原因
			sessionStorage.removeItem('goodsorder-edit-reason');
			const message = this.orderId ? '修改成功' : '保存成功';
			this.$message.success(message);
			that.dialogVisible = false;
			// this.setIsEditingOrder(null, false);
		},
		/**
		 * 处理弹窗确认事件（提交订单）
		 * @param {Object} that - 父组件实例（通常是弹窗组件）
		 * @returns {Promise} 返回Promise以便弹窗控制关闭时机
		 */
		handleProcess(that) {
			return new Promise((resolve, reject) => {
				this.$refs.orderForm.validate(valid => {
					if (valid) {
						if (this.visibleOrderDetailList.length === 0) {
							this.$message.error('请添加货物信息!');
							reject(new Error('请添加货物信息'));
							return;
						}
						// 检查是否有没有保存的项（只检查可见行）
						if (this.visibleOrderDetailList.some(item => item.isEditing)) {
							this.$antdconfirm({
								title: '当前订单信息中有未保存的项,是否保存并提交?',
								okText: '是',
								cancelText: '否',
								zIndex: 2660,
								onOk: () => {
									// 点击确定时，保存所有可见行（包括已删除的行会一起发送）
									new Promise((saveResolve, saveReject) => {
										this.handleRowSave(this.visibleOrderDetailList, saveResolve, saveReject);
									})
										.then(() => {
											this.reset(that);
											resolve(); // 成功时resolve
										})
										.catch(error => {
											// 保存失败时reject，不关闭弹窗
											console.error('保存订单行失败:', error);
											this.$message.error('保存失败，请检查数据后重试');
											reject(error);
										});
								},
								onCancel: () => {
									// 用户取消时也应该reject
									reject(new Error('用户取消操作'));
								}
							});
						} else {
							new Promise((submitResolve, submitReject) => {
								// 填充订单详情信息
								this.submitOrder(submitResolve, submitReject);
							})
								.then(() => {
									this.reset(that);
									resolve(); // 成功时resolve
								})
								.catch(error => {
									// 提交失败时reject，不关闭弹窗
									console.error('提交订单失败:', error);
									this.$message.error('提交失败，请检查数据后重试');
									reject(error);
								});
						}
					} else {
						this.$message.error('请检查表单必填项!');
						reject(new Error('表单验证失败'));
					}
				});
			});
		},
		/** 处理弹窗取消或关闭事件，重置部分状态 */
		handleReject() {
			this.isSea = false;
			this.isLand = false;
			this.isEditingDetails = false;
			// 清除sessionStorage中的修改原因
			sessionStorage.removeItem('goodsorder-edit-reason');
			this.resetOrderInfo();
			return Promise.resolve();
		},
		/** 重置订单基本信息和订单详情列表 */
		resetOrderInfo() {
			this.orderInfo = {
				orderID: '',
				orderNo: '',
				customerID: '',
				customer: '',
				saleManager: '',
				userName: '',
				orderDetailList: [],
				fleet: '',
				orderState: '',
				orderDate: parseTime(new Date()),
				orderType: '',
				landCarID: '',
				landCarNo: '',
				landDriverName: '',
				landDriverTel: '',
				landBankName: '',
				landBankNo: '',
				seaCarID: '',
				seaCarNo: '',
				seaDriverName: '',
				seaDriverTel: '',
				comments: '' // 确保备注也被重置
			};
			this.isEditingDetails = false;
			this.orderDetailList = [];
			// 重置表单校验状态
			if (this.$refs.orderForm) {
				this.$refs.orderForm.resetFields();
				this.$refs.orderForm.clearValidate();
			}
		},
		/**
		 * 清空指定订单详情行的内容
		 * @param {Object} scope - 表格行作用域对象
		 */
		clearDetail(scope) {
			scope.row.orderDate = new Date();
			scope.row.supplier = '';
			scope.row.supplierID = '';
			scope.row.customer = '';
			scope.row.customerID = '';
			scope.row.levelID = '';
			scope.row.levelName = '';
			scope.row.countingUnit = '片';
			scope.row.height = '';
			scope.row.length = '';
			scope.row.width = '';
			scope.row.piecesPerPack = '';
			scope.row.pieces = '';
			scope.row.packs = '';
			scope.row.price = '';
			scope.row.isIncludeTaxFactory = 0;
			scope.row.sundryCost = '';
			scope.row.paymentFactory = '';
			scope.row.paymentUnload = '';
			scope.row.isIncludeTaxSale = 0;
			scope.row.payments = '';
			scope.row.erro = '';
			scope.row.tonnage = '';
			scope.row.landFreightPrice = '';
			scope.row.landFreight = '';
			scope.row.seaFreight = '';
			scope.row.freight = '';
			scope.row.otherCost = '';
			scope.row.profit = '';
			scope.row.profitNoTax = '';
			scope.row.actualPieces = '';
			scope.row.paymentsWithSundry = '';
			scope.row.additionalFees = '';
			scope.row.storeHouseID = '';
			scope.row.storeHouseName = '';
			scope.row.storeID = '';
			scope.row.logisticsProfit = '';
			scope.row.customerCommission = '';
			scope.row.factoryCommission = '';
			scope.row.isAdjusted = 0;
			scope.row.adjustOrderNo = '';
			scope.row.adjustDate = '';
			scope.row.factoryRebateAmount = '';
			scope.row.factoryDiscountAmount = '';
			scope.row.comments = '';
		},
		/** 重置海运车辆相关信息并清除校验状态 */
		resetSeaCarInfo() {
			this.orderInfo.seaCarID = '';
			this.orderInfo.seaCarNo = '';
			this.orderInfo.seaDriverName = '';
			this.orderInfo.seaDriverTel = '';
			// 清除校验状态
			if (this.$refs.orderForm) {
				this.$refs.orderForm.clearValidate(['seaCarNo', 'seaDriverName']);
			}
		},
		/** 重置陆运车辆相关信息并清除校验状态 */
		resetLandCarInfo() {
			this.orderInfo.landCarID = '';
			this.orderInfo.landCarNo = '';
			this.orderInfo.landDriverName = '';
			this.orderInfo.landDriverTel = '';
			this.orderInfo.landBankName = ''; // 添加重置
			this.orderInfo.landBankNo = ''; // 添加重置
			this.orderInfo.fleet = ''; // 添加重置
			// 清除校验状态
			if (this.$refs.orderForm) {
				this.$refs.orderForm.clearValidate(['landCarNo', 'fleet']);
			}
		},
		/**
		 * 切换订单详情的批量编辑模式
		 * @param {boolean} editState - true表示进入编辑模式，false表示退出并保存
		 */
		toggleEditDetails(editState) {
			if (editState) {
				// 进入编辑模式，设置所有可见行为可编辑状态
				this.visibleOrderDetailList.forEach(row => {
					this.$set(row, 'isEditing', true);
					if (row.hasError) {
						this.$set(row, 'hasError', false);
					}
				});
				this.$message.info('已进入批量编辑模式，可以修改所有订单信息');
			} else {
				// 退出编辑模式，保存所有可见行
				// 如果有正在编辑的行，全部设置为不可编辑
				if (this.hasEditingRows) {
					this.handleRowSave(this.visibleOrderDetailList);
				}
			}
		},
		/**
		 * 根据行状态（错误、编辑中）获取行类名
		 * @param {Object} params - 表格行参数对象
		 * @param {Object} params.row - 当前行数据
		 * @returns {String} 行类名
		 */
		getRowClassName(param) {
			return utilGetRowClassName(param);
		},
		/**
		 * 根据每包片数和包数计算总出厂片数，并自动填充卸货片数
		 * @param {Object} row - 当前行数据
		 */
		calculatePieces(row) {
			if (row.piecesPerPack > 0 && row.packs > 0) {
				// 计算出厂片数，使用完整精度
				const piecesPerPack = Number(row.piecesPerPack);
				const packs = Number(row.packs);
				const result = piecesPerPack * packs;
				// 规范化数值但保持完整精度
				row.pieces = formatPiecesValue(result);
				// 设置卸货片数等于出厂片数
				row.actualPieces = row.pieces;
				// 触发重新计算
				this.recalculateAll({ row });
			}
		},
		/**
		 * 处理价格字段输入，保存完整精度值用于计算
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 * @param {String} inputValue - 用户输入的值
		 * @param {Function} callback - 输入后的回调函数（如重新计算）
		 */
		handlePriceInput(row, field, inputValue, callback) {
			return utilHandlePriceInput(row, field, inputValue, callback);
		},
		/**
		 * 规范化价格输入，确保为有效的Number类型，但保持完整精度不截断
		 * 在失去焦点时格式化显示，但保留完整精度值用于计算
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 * @param {Number} precision - 显示精度（2或4位小数）
		 * @param {boolean} isSpecialFieldFlag - 是否强制作为特殊字段处理（false表示根据字段名自动判断）
		 */
		formatPriceInput(row, field, precision, isSpecialFieldFlag = false) {
			return utilFormatPriceInput(row, field, precision, isSpecialFieldFlag);
		},
		/**
		 * 处理价格字段聚焦事件，恢复完整精度显示以便编辑
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 */
		handlePriceFocus(row, field) {
			return utilHandlePriceFocus(row, field);
		},
		// parseInputValue, formatValueForDisplay, formatPiecesValue 已从 @/utils/order 导入，直接使用
		/**
		 * 检查订单明细是否为空（所有业务字段都为空）
		 * @param {Object} orderDetail - 订单明细对象
		 * @returns {boolean} - 如果所有业务字段都为空则返回true，否则返回false
		 */
		isOrderDetailEmpty(orderDetail) {
			if (!orderDetail) return true;

			// 定义需要检查的核心业务字段（排除有默认值或系统自动填充的字段）
			const businessFields = [
				'supplier',
				'storeHouseName',
				'levelName',
				'height',
				'length',
				'width',
				'piecesPerPack',
				'packs',
				'pieces',
				'price',
				'sundryCost',
				'actualPieces',
				'paymentUnload',
				'paymentsWithSundry',
				'erro',
				'landFreightPrice',
				'additionalFees',
				'seaFreight',
				'otherCost',
				'logisticsProfit',
				'customerCommission',
				'factoryCommission',
				'factoryRebateAmount',
				'factoryDiscountAmount',
				'comments'
			];

			// 检查每个业务字段是否都为空
			return businessFields.every(field => {
				const value = orderDetail[field];
				// 检查是否为空值：null、undefined、空字符串、或只包含空白字符的字符串
				return value === null || value === undefined || value === '' || (typeof value === 'string' && value.trim() === '') || (typeof value === 'number' && value === 0);
			});
		},
		/**
		 * @description: 处理片数输入，限制最多两位小数
		 * @param {object} row 当前行数据
		 * @param {string} field 字段名
		 * @param {string} value 输入值
		 * @param {function} callback 回调函数
		 */
		handlePiecesInput(row, field, value, callback) {
			return utilHandlePiecesInput(row, field, value, callback);
		}
	}
};
</script>

<template>
	<div>
		<!-- 基本信息表单部分 -->
		<el-form :inline="true" :model="orderInfo" label-width="100px" :rules="orderRules" ref="orderForm" style="margin-top: 10px; margin-bottom: 10px">
			<el-form-item label="订单日期" prop="orderDate">
				<el-date-picker v-model="orderInfo.orderDate" size="mini" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 120px" />
			</el-form-item>
			<el-form-item label="客户" prop="customer">
				<el-row>
					<el-col :span="14">
						<el-input disabled v-model="orderInfo.customer" type="text" size="mini" placeholder="请输入客户名称" />
					</el-col>
					<el-col :span="4">
						<SearchOption
							title="客户信息"
							:limit-info="{ companyType: '客户' }"
							:get-data="listCompany"
							query-info="companyName"
							query-label="公司名称"
							:query-name="queryCompanyName"
							@update:queryName="handleUpdateCompanyName"
							@commitBack="handleCommitBackCompany"
							:query-items="queryItemsCompany"
						>
							<template #table-columns>
								<el-table-column label="公司名称" align="center" prop="companyName" />
								<el-table-column label="销售经理" align="center" prop="salesManager" />
								<el-table-column label="老板姓名" align="center" prop="leader" />
								<el-table-column label="老板电话" align="center" prop="leaderTel" />
								<el-table-column label="区域" align="center" prop="region" />
								<el-table-column label="联系人" align="center" prop="relationName" />
							</template>
						</SearchOption>
					</el-col>
				</el-row>
			</el-form-item>
			<el-form-item label="销售经理" prop="saleManager">
				<el-input v-model="orderInfo.saleManager" type="text" size="mini" placeholder="请输入销售经理名称" style="width: 110px" />
			</el-form-item>
			<!-- 2025-11-1 录入人员不用录入了 -->
			<!-- <el-form-item label="录入人员" prop="userName">
	  <el-input v-model="orderInfo.userName" type="text" size="mini" placeholder="请输入录入人员" style="width: 110px" />
	</el-form-item> -->
			<el-form-item label="备注" prop="comments">
				<el-input v-model="orderInfo.comments" type="text" size="mini" placeholder="请输入备注" />
			</el-form-item>
			<el-form-item label="运输方式">
				<el-checkbox v-model="isLand">陆运</el-checkbox>
				<el-checkbox v-model="isSea">海运</el-checkbox>
			</el-form-item>
			<el-row v-if="isLand" style="margin: 2px 0">
				<!-- 确认 prop="landCarNo" -->
				<el-form-item label="车牌" prop="landCarNo">
					<el-row>
						<el-col :span="20">
							<el-input disabled v-model="orderInfo.landCarNo" type="text" size="mini" placeholder="请选择陆运车牌" style="width: 120px" />
						</el-col>
						<el-col :span="4">
							<SearchOption title="陆运信息" :limit-info="{ carType: '陆运' }" :get-data="listCars" query-label="车牌搜索" query-info="carNo" :query-name="queryLandCar" @commitBack="handleCommitBackCar" @update:queryName="handleChangeCar">
								<template #table-columns>
									<el-table-column label="车牌" align="center" prop="carNo" />
									<el-table-column label="司机" align="center" prop="driver" />
									<el-table-column label="司机电话" align="center" prop="tel" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="银行卡号" align="center" prop="bankNo" />
									<el-table-column label="开户行" align="center" prop="bankName" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="司机" props="landDriverName">
					<el-input disabled v-model="orderInfo.landDriverName" type="text" size="mini" placeholder="请选择车牌" style="width: 130px" />
				</el-form-item>
				<el-form-item label="电话" props="landDriverTel">
					<el-input disabled v-model="orderInfo.landDriverTel" type="text" size="mini" placeholder="请选择车牌" style="width: 120px" />
				</el-form-item>
				<!-- 确认 prop="fleet" -->
				<el-form-item label="车队" prop="fleet">
					<el-row>
						<el-col :span="12">
							<el-input v-model="orderInfo.fleet" type="text" size="mini" placeholder="请选择车队" />
						</el-col>
						<el-col :span="4">
							<SearchOption title="车队信息" :limit-info="{}" :get-data="listFleet" query-label="车队名称" query-info="fname" :query-name="queryFleet" @commitBack="handleCommitBackFleet" @update:queryName="handleChangeFleet">
								<template #table-columns>
									<el-table-column label="车队名称" align="center" prop="fname" />
									<el-table-column label="车队经理" align="center" prop="fleader" />
									<el-table-column label="车队经理电话" align="center" prop="tel" />
									<el-table-column label="地址" align="center" prop="address" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
			</el-row>
			<el-row v-if="isSea" style="margin: 2px 0">
				<!-- 添加 prop="seaCarNo" -->
				<el-form-item label="柜号(填写)" prop="seaCarNo">
					<el-input v-model="orderInfo.seaCarNo" type="text" size="mini" placeholder="请输入柜号" style="width: 120px" />
				</el-form-item>
				<!-- 添加 prop="seaDriverName" -->
				<el-form-item label="海运公司" prop="seaDriverName">
					<el-row>
						<el-col :span="20">
							<el-input disabled v-model="orderInfo.seaDriverName" type="text" size="mini" placeholder="请选择" style="width: 130px" />
						</el-col>
						<el-col :span="4">
							<SearchOption title="海运信息" :limit-info="{ carType: '海运' }" :get-data="listCars" query-label="柜号" query-info="carNo" :query-name="querySeaCars" @commitBack="handleCommitBackSeaCar" @update:queryName="handleChangeSeaCar">
								<template #table-columns>
									<el-table-column label="柜号" align="center" prop="carNo" />
									<el-table-column label="海运公司" align="center" prop="driver" />
									<el-table-column label="电话" align="center" prop="tel" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="银行卡号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="电话">
					<el-input disabled v-model="orderInfo.seaDriverTel" type="text" size="mini" placeholder="请选择" style="width: 120px" />
				</el-form-item>
			</el-row>
		</el-form>

		<!-- 订单详情的填写 -->
		<div>
			<el-row :gutter="10" class="mb8">
				<el-col :span="1.5">
					<el-button size="mini" type="primary" @click="handleAddOrderdetail">添加</el-button>
				</el-col>
				<el-col :span="1.5">
					<el-button size="mini" type="danger" @click="handleDeleteOrderdetail" :disabled="checkedOrderdetail.length === 0">删除</el-button>
				</el-col>
				<el-col :span="1.5">
					<el-button size="mini" type="warning" @click="toggleEditDetails(true)" :disabled="!hasOrderDetails || hasEditingRows">编辑子项</el-button>
				</el-col>
				<el-col :span="1.5">
					<el-button size="mini" type="success" @click="toggleEditDetails(false)" :disabled="!hasEditingRows">全部保存</el-button>
				</el-col>
			</el-row>
			<el-table border size="mini" :data="visibleOrderDetailList" show-summary :summary-method="getSummary" :row-class-name="getRowClassName" @selection-change="handleOrderdetailSelectionChange" ref="orderdetail">
				<el-table-column type="selection" width="30" align="center" :selectable="() => true" />
				<el-table-column label="序号" align="center" type="index" width="60" fixed="left" />
				<el-table-column label="行操作" align="center" width="140" fixed="left">
					<template slot-scope="scope">
						<el-button v-if="!scope.row.isEditing" size="mini" type="warning" icon="el-icon-edit" @click="handleRowEdit(scope.row)">编辑</el-button>
						<el-button v-else size="mini" type="success" icon="el-icon-check" @click="handleRowSave(scope.row)">保存</el-button>
						<el-button :disabled="scope.row.isEditing" size="mini" type="danger" icon="el-icon-document-copy" @click="handleCopyRow(scope.row)">复制</el-button>
					</template>
				</el-table-column>
				<el-table-column label="供应商/仓库" width="170">
					<template #default="scope">
						<el-row>
							<el-col :span="12">
								<el-input disabled size="mini" v-model="scope.row[scope.row.currentType || 'supplier']" placeholder="请输入供应商/仓库" />
							</el-col>
							<el-col :span="6">
								<SearchOption
									title="供应商信息"
									:get-data="listCompany"
									icon="el-icon-user"
									query-label="供应商名称"
									query-info="companyName"
									:query-name="querySupplier"
									:limit-info="{ companyType: '供应商' }"
									@commitBack="value => handleCommitBackSupplier(scope, value)"
									@update:queryName="handleUpdateQuerySupplier"
									@click="setCurrentType(scope.row, 'supplier')"
									:disable="!scope.row.isEditing"
								>
									<template #table-columns>
										<el-table-column label="公司名称" align="center" prop="companyName" />
										<el-table-column label="销售经理" align="center" prop="salesManager" />
										<el-table-column label="联系人" align="center" prop="relationName" />
										<el-table-column label="电话" align="center" prop="relationTel" />
										<el-table-column label="地址" align="center" prop="address" />
									</template>
								</SearchOption>
							</el-col>
							<el-col :span="6">
								<SearchOption
									title="库存信息"
									:get-data="listExitInventory"
									icon="el-icon-s-home"
									:limit-info="{}"
									query-label="仓库名称"
									query-info="storeHouseName"
									:query-name="queryStoreHouseName"
									:additional-limit-info="tableData => filterNoStockNumber(tableData)"
									@commitBack="value => handleCommitBackInventory(scope, value)"
									@update:queryName="handleUpdateQueryNameStore"
									:queryItems="queryItemsStoreHouse"
									@click="setCurrentType(scope.row, 'storeHouseName')"
									:disable="!scope.row.isEditing"
								>
									<template #table-columns>
										<el-table-column label="仓库名称" align="center" prop="storeHouseName" width="150" show-overflow-tooltip />
										<el-table-column label="级别名称" align="center" prop="levelName" width="150" show-overflow-tooltip />
										<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip />
										<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip />
										<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip />
										<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip />
										<el-table-column label="剩余量" align="center" prop="actualPieces" show-overflow-tooltip />
										<el-table-column label="存货价" align="center" prop="paymentUnload" show-overflow-tooltip />
										<el-table-column label="库存金额" align="center" prop="payments" show-overflow-tooltip />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</template>
				</el-table-column>
				<el-table-column label="级别名称" prop="levelName" width="150">
					<template #default="scope">
						<el-col :span="16">
							<el-input disabled size="mini" v-model="scope.row.levelName" placeholder="请输入级别名称" />
						</el-col>
						<el-col :span="8">
							<SearchOption
								:get-data="listProductLevel"
								icon="el-icon-search"
								:limit-info="{}"
								query-label="级别名称"
								query-info="levelName"
								:query-name="queryLevel"
								@update:queryName="handleUpdateQueryNameLevel"
								@commitBack="value => handleCommitBackProductLevel(scope, value)"
								:query-items="queryItemsOrder"
								:disable="!scope.row.isEditing"
							>
								<template #table-columns>
									<el-table-column label="级别编码" align="center" prop="levelNo" />
									<el-table-column label="级别名称" align="center" prop="levelName" width="220" />
									<el-table-column label="分类编号" align="center" prop="categoryNo" />
									<el-table-column label="分类名称" align="center" prop="categoryName" />
									<el-table-column label="厚度" align="center" prop="height" />
									<el-table-column label="长度" align="center" prop="length" />
									<el-table-column label="宽度" align="center" prop="width" />
									<el-table-column label="误差" align="center" prop="tonnage" />
								</template>
							</SearchOption>
						</el-col>
					</template>
				</el-table-column>
				<el-table-column label="计量单位" prop="countingUnit" width="92" class-name="counting-unit-column">
					<template #default="scope">
						<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!scope.row.isEditing" @change="() => recalculateAll(scope)" class="horizontal-radio-group">
							<el-radio label="片" class="horizontal-radio">片数</el-radio>
							<el-radio label="其他" class="horizontal-radio">其他</el-radio>
						</el-radio-group>
					</template>
				</el-table-column>
				<el-table-column label="厚度" prop="height" width="90">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.height" placeholder="请选择产品级别" disabled />
					</template>
				</el-table-column>
				<el-table-column label="长度" prop="length" width="90">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.length" placeholder="请选择产品级别" disabled />
					</template>
				</el-table-column>
				<el-table-column label="宽度" prop="width" width="90">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.width" placeholder="请选择产品级别" disabled />
					</template>
				</el-table-column>
				<el-table-column label="每包片数" prop="piecesPerPack" width="80">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.piecesPerPack" placeholder="请输入每包片数" :disabled="!scope.row.isEditing" @input="val => handlePiecesInput(scope.row, 'piecesPerPack', val, () => calculatePieces(scope.row))" />
					</template>
				</el-table-column>
				<el-table-column label="包数" prop="packs" width="60">
					<template #default="scope">
						<el-input
							size="mini"
							v-model="scope.row.packs"
							:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
							:disabled="!scope.row.isEditing || scope.row.piecesPerPack <= 0"
							@input="val => handlePiecesInput(scope.row, 'packs', val, () => calculatePieces(scope.row))"
						/>
					</template>
				</el-table-column>
				<el-table-column label="出厂片数" prop="pieces" width="80">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.pieces" placeholder="请输入出厂片数" @change="() => handlePiecesChange(scope)" @input="val => handlePiecesInput(scope.row, 'pieces', val, () => recalculateAll(scope))" :disabled="!scope.row.isEditing" />
					</template>
				</el-table-column>
				<el-table-column label="出厂单价" prop="price" width="80">
					<template #default="scope">
						<el-input
							size="mini"
							v-model="scope.row.price"
							@input="val => handlePriceInput(scope.row, 'price', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'price')"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'price', 2, false)"
							placeholder="请输入出厂单价"
						/>
					</template>
				</el-table-column>
				<el-table-column label="含税" prop="isIncludeTaxFactory" width="80" class-name="tax-column">
					<template #default="scope">
						<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" class="horizontal-tax-radio-group">
							<el-radio :label="1" class="horizontal-tax-radio">是</el-radio>
							<el-radio :label="0" class="horizontal-tax-radio">否</el-radio>
						</el-radio-group>
					</template>
				</el-table-column>
				<el-table-column label="杂费" prop="sundryCost" width="100">
					<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.sundryCost"
							@input="val => handlePriceInput(scope.row, 'sundryCost', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'sundryCost')"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'sundryCost', 2)"
							placeholder="请输入杂费"
						/>
					</template>
				</el-table-column>
				<el-table-column label="出厂货款" prop="paymentFactory" width="150">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.paymentFactory" placeholder="自动计算" disabled />
					</template>
				</el-table-column>
				<el-table-column label="卸货片数" prop="actualPieces" width="120">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.actualPieces" placeholder="请输入卸货片数" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
					</template>
				</el-table-column>
				<el-table-column label="卸货价" prop="paymentUnload" width="100">
					<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.paymentUnload"
							placeholder="请输入卸货价"
							@input="val => handlePriceInput(scope.row, 'paymentUnload', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'paymentUnload')"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'paymentUnload', 2, false)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="含税" prop="isIncludeTaxSale" width="60" class-name="tax-column">
					<template #default="scope">
						<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" class="horizontal-tax-radio-group">
							<el-radio :label="1" class="horizontal-tax-radio">是</el-radio>
							<el-radio :label="0" class="horizontal-tax-radio">否</el-radio>
						</el-radio-group>
					</template>
				</el-table-column>
				<el-table-column label="杂费" prop="paymentsWithSundry" width="100">
					<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.paymentsWithSundry"
							@input="val => handlePriceInput(scope.row, 'paymentsWithSundry', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'paymentsWithSundry')"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'paymentsWithSundry', 2)"
							placeholder="请输入杂费"
						/>
					</template>
				</el-table-column>
				<el-table-column label="总货款" prop="payments" width="150">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.payments" placeholder="自动计算" disabled />
					</template>
				</el-table-column>
				<el-table-column label="误差" prop="erro" width="60">
					<template #default="scope">
						<!-- 误差通常由产品级别带出，如果允许手动输入则需要触发计算 -->
						<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
					</template>
				</el-table-column>
				<el-table-column label="吨位" prop="tonnage" width="100">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.tonnage" placeholder="自动计算" disabled />
					</template>
				</el-table-column>
				<el-table-column label="陆运费单价" prop="landFreightPrice" width="150" v-if="isLand">
					<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.landFreightPrice"
							@input="val => handlePriceInput(scope.row, 'landFreightPrice', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'landFreightPrice')"
							placeholder="请输入陆运费单价"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'landFreightPrice', 2)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="加费" prop="additionalFees" width="60" v-if="isLand">
					<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.additionalFees"
							@input="val => handlePriceInput(scope.row, 'additionalFees', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'additionalFees')"
							:placeholder="!scope.row.landFreightPrice ? '请先完善陆运费单价' : '请输入加费'"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'additionalFees', 2)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="陆运费" prop="landFreight" width="100" v-if="isLand">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.landFreight" placeholder="自动计算" disabled />
					</template>
				</el-table-column>
				<el-table-column label="海运费" prop="seaFreight" width="100" v-if="isSea">
					<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.seaFreight"
							@input="val => handlePriceInput(scope.row, 'seaFreight', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'seaFreight')"
							placeholder="请输入海运费"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'seaFreight', 2)"
						/>
					</template>
				</el-table-column>

				<el-table-column label="总运费" prop="freight" width="100">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
					</template>
				</el-table-column>
				<el-table-column label="其他费用" prop="otherCost" width="100">
					<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.otherCost"
							placeholder="请输入其他费用"
							@input="val => handlePriceInput(scope.row, 'otherCost', val, () => recalculateAll(scope))"
							@focus="() => handlePriceFocus(scope.row, 'otherCost')"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'otherCost', 2)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="利润" prop="profit" width="150">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.profit" placeholder="自动计算" disabled />
					</template>
				</el-table-column>
				<el-table-column label="不含税利润" prop="profitNoTax" width="150">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.profitNoTax" placeholder="自动计算" disabled />
					</template>
				</el-table-column>
				<el-table-column label="备注" prop="comments" width="250">
					<template #default="scope">
						<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" :disabled="!scope.row.isEditing" />
					</template>
				</el-table-column>
				<el-table-column label="物流利润" prop="logisticsProfit" width="90">
					<template #default="scope">
						<el-input
							size="mini"
							v-model="scope.row.logisticsProfit"
							@input="val => handlePriceInput(scope.row, 'logisticsProfit', val, () => {})"
							@focus="() => handlePriceFocus(scope.row, 'logisticsProfit')"
							placeholder="请输入物流利润"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'logisticsProfit', 2)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="客户佣金" prop="customerCommission" width="90">
					<template #default="scope">
						<el-input
							size="mini"
							v-model="scope.row.customerCommission"
							@input="val => handlePriceInput(scope.row, 'customerCommission', val, () => {})"
							@focus="() => handlePriceFocus(scope.row, 'customerCommission')"
							placeholder="请输入佣金"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'customerCommission', 2)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="厂家佣金" prop="factoryCommission" width="90">
					<template #default="scope">
						<el-input
							size="mini"
							v-model="scope.row.factoryCommission"
							@input="val => handlePriceInput(scope.row, 'factoryCommission', val, () => {})"
							@focus="() => handlePriceFocus(scope.row, 'factoryCommission')"
							placeholder="请输入佣金"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'factoryCommission', 2)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="计提厂家返利" prop="factoryRebateAmount" width="150">
					<template #default="scope">
						<el-input
							size="mini"
							v-model="scope.row.factoryRebateAmount"
							@input="val => handlePriceInput(scope.row, 'factoryRebateAmount', val, () => {})"
							@focus="() => handlePriceFocus(scope.row, 'factoryRebateAmount')"
							placeholder="请输入计提厂家返利"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'factoryRebateAmount', 2)"
						/>
					</template>
				</el-table-column>
				<el-table-column label="计提厂家降价" prop="factoryDiscountAmount" width="150">
					<template #default="scope">
						<el-input
							size="mini"
							v-model="scope.row.factoryDiscountAmount"
							@input="val => handlePriceInput(scope.row, 'factoryDiscountAmount', val, () => {})"
							@focus="() => handlePriceFocus(scope.row, 'factoryDiscountAmount')"
							placeholder="请输入计提厂家降价"
							:disabled="!scope.row.isEditing"
							@blur="() => formatPriceInput(scope.row, 'factoryDiscountAmount', 2)"
						/>
					</template>
				</el-table-column>
			</el-table>
		</div>
	</div>
</template>

<style scoped lang="scss">
// ============================================
// 表单样式
// ============================================
::v-deep .el-form {
	.el-form-item {
		margin-bottom: 8px !important; // 进一步缩小表单项间距

		// 表单 label 样式 - 字体大小与输入框值一致（16px）
		.el-form-item__label {
			font-size: 16px !important; // 参考输入框值的字体大小
			color: #000000 !important; // 保持黑色
			font-weight: 600 !important; // 保持加粗
			line-height: 24px !important; // 与输入框高度一致
		}

		// 运输方式checkbox样式 - 字体大小与表单label一致（16px）
		.el-checkbox {
			font-size: 16px !important; // 与表单label字体大小一致

			.el-checkbox__label {
				font-size: 16px !important; // 与表单label字体大小一致
				color: #000000 !important; // 保持黑色
				font-weight: normal !important; // 正常字重
				padding-left: 8px !important; // 增加左边距，与checkbox保持适当距离
			}

			.el-checkbox__input {
				.el-checkbox__inner {
					width: 16px !important; // 增大checkbox尺寸
					height: 16px !important; // 增大checkbox尺寸
					border-radius: 2px !important; // 保持圆角

					&:after {
						width: 5px !important; // 增大对勾尺寸
						height: 8px !important; // 增大对勾尺寸
						left: 5px !important; // 调整对勾位置
						top: 1px !important; // 调整对勾位置
					}
				}

				// 选中状态
				&.is-checked {
					.el-checkbox__inner {
						background-color: #409eff !important;
						border-color: #409eff !important;
					}
				}

				// 禁用状态
				&.is-disabled {
					.el-checkbox__inner {
						background-color: #f5f7fa !important;
						border-color: #e4e7ed !important;
					}
				}
			}
		}
	}
}

// ============================================
// 表格样式
// ============================================
::v-deep .el-table {
	// 表格表头样式 - 字体大小与表单label一致（16px）
	.el-table__header-wrapper {
		.el-table__header {
			th {
				.cell {
					font-size: 16px !important; // 与表单label字体大小一致
					color: #000000 !important; // 保持黑色
					font-weight: bold !important; // 保持加粗
				}
			}
		}
	}

	// 固定列表头样式 - 与主表格表头保持一致
	.el-table__fixed {
		.el-table__fixed-header-wrapper {
			.el-table__header {
				th {
					.cell {
						font-size: 16px !important; // 与表单label字体大小一致
						color: #000000 !important; // 保持黑色
						font-weight: bold !important; // 保持加粗
					}
				}
			}
		}
	}

	// 右侧固定列表头样式
	.el-table__fixed-right {
		.el-table__fixed-header-wrapper {
			.el-table__header {
				th {
					.cell {
						font-size: 16px !important; // 与表单label字体大小一致
						color: #000000 !important; // 保持黑色
						font-weight: bold !important; // 保持加粗
					}
				}
			}
		}
	}
}

// ============================================
// 布局样式
// ============================================
::v-deep .el-row {
	margin-bottom: 4px !important; // 缩小行间距
}

// ============================================
// 表格列特殊样式
// ============================================
// 计量单位列水平布局样式
::v-deep .counting-unit-column {
	.cell {
		padding: 2px 4px !important; // 减少内边距
		line-height: 1.2 !important;
		white-space: nowrap !important; // 不换行，保持水平布局
		overflow: visible !important; // 显示溢出内容
		height: auto !important; // 自动高度适应内容
		text-align: center !important; // 居中对齐
	}
}

// 含税列水平布局样式
::v-deep .tax-column {
	.cell {
		padding: 2px 4px !important; // 减少内边距
		line-height: 1.2 !important;
		white-space: nowrap !important; // 不换行，保持水平布局
		overflow: visible !important; // 显示溢出内容
		height: auto !important; // 自动高度适应内容
		text-align: center !important; // 居中对齐
	}
}

// ============================================
// 单选框组样式
// ============================================
// 计量单位单选框组水平布局（左边片数，右边其他）
::v-deep .horizontal-radio-group {
	display: flex !important;
	flex-direction: row !important; // 水平排列
	align-items: center !important;
	justify-content: center !important;
	gap: 4px !important; // 选项间距
	width: 100% !important;
	margin: 0 !important;

	.horizontal-radio {
		margin-right: 0 !important;
		margin-bottom: 0 !important;
		white-space: nowrap !important;

		.el-radio__label {
			font-size: 14px !important; // 字体大小
			padding-left: 2px !important;
		}

		.el-radio__input {
			.el-radio__inner {
				width: 14px !important; // 增大单选框尺寸
				height: 14px !important; // 增大单选框尺寸

				&:after {
					width: 4px !important; // 增大内部圆点尺寸
					height: 4px !important; // 增大内部圆点尺寸
					left: 5px !important; // 调整圆点位置以居中
					top: 5px !important; // 调整圆点位置以居中
				}
			}
		}
	}
}

// 含税单选框组水平布局（左是右否）
::v-deep .horizontal-tax-radio-group {
	display: flex !important;
	flex-direction: row !important; // 水平排列
	align-items: center !important;
	justify-content: center !important;
	gap: 4px !important; // 选项间距
	width: 100% !important;
	margin: 0 !important;

	.horizontal-tax-radio {
		margin-right: 0 !important;
		margin-bottom: 0 !important;
		white-space: nowrap !important;

		.el-radio__label {
			font-size: 14px !important; // 字体大小
			padding-left: 2px !important;
		}

		.el-radio__input {
			.el-radio__inner {
				width: 14px !important; // 增大单选框尺寸
				height: 14px !important; // 增大单选框尺寸

				&:after {
					width: 4px !important; // 增大内部圆点尺寸
					height: 4px !important; // 增大内部圆点尺寸
					left: 5px !important; // 调整圆点位置以居中
					top: 5px !important; // 调整圆点位置以居中
				}
			}
		}
	}
}

// 计量单位单选框组垂直布局（保留原有样式，以防其他地方使用）
::v-deep .vertical-radio-group {
	display: flex !important;
	flex-direction: column !important; // 强制垂直排列
	align-items: flex-start !important;
	gap: 1px !important; // 减少选项间距
	width: 100% !important;
	margin: 0 !important;

	.vertical-radio {
		margin-right: 0 !important;
		margin-bottom: 1px !important;
		white-space: nowrap !important;
		width: 100% !important;

		.el-radio__label {
			font-size: 14px !important; // 增大字体大小（从10px增加到14px）
			padding-left: 3px !important;
		}

		.el-radio__input {
			.el-radio__inner {
				width: 14px !important; // 增大单选框尺寸（从9px增加到14px）
				height: 14px !important; // 增大单选框尺寸（从9px增加到14px）

				&:after {
					width: 4px !important; // 增大内部圆点尺寸（从2px增加到4px）
					height: 4px !important; // 增大内部圆点尺寸（从2px增加到4px）
					left: 5px !important; // 调整圆点位置以居中
					top: 5px !important; // 调整圆点位置以居中
				}
			}
		}

		// 移除最后一个单选框的下边距
		&:last-child {
			margin-bottom: 0 !important;
		}
	}
}

// 含税单选框组垂直布局
::v-deep .vertical-tax-radio-group {
	display: flex !important;
	flex-direction: column !important; // 强制垂直排列
	align-items: flex-start !important;
	gap: 1px !important; // 减少选项间距
	width: 100% !important;
	margin: 0 !important;

	.vertical-tax-radio {
		margin-right: 0 !important;
		margin-bottom: 1px !important;
		white-space: nowrap !important;
		width: 100% !important;

		.el-radio__label {
			font-size: 14px !important; // 增大字体大小（从10px增加到14px）
			padding-left: 3px !important;
		}

		.el-radio__input {
			.el-radio__inner {
				width: 14px !important; // 增大单选框尺寸（从9px增加到14px）
				height: 14px !important; // 增大单选框尺寸（从9px增加到14px）

				&:after {
					width: 4px !important; // 增大内部圆点尺寸（从2px增加到4px）
					height: 4px !important; // 增大内部圆点尺寸（从2px增加到4px）
					left: 5px !important; // 调整圆点位置以居中
					top: 5px !important; // 调整圆点位置以居中
				}
			}
		}

		// 移除最后一个单选框的下边距
		&:last-child {
			margin-bottom: 0 !important;
		}
	}
}

// ============================================
// 表格行状态样式
// ============================================
// 编辑行样式
::v-deep .editing-row {
	background-color: rgba(121, 246, 164, 0.1);

	td:first-child {
		border-left: 9px solid #63f697 !important;
	}

	&:hover {
		box-shadow: 0 0 8px rgba(121, 246, 164, 0.8);
	}
}

// 错误行样式
::v-deep .error-row {
	background-color: rgba(245, 108, 108, 0.1);
	animation: errorPulse 2s infinite;

	td:first-child {
		border-left: 9px solid #f56c6c !important;
	}

	&:hover {
		box-shadow: 0 0 8px rgba(245, 108, 108, 0.8);
	}
}
</style>
