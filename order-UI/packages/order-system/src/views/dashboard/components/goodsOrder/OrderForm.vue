<script>
import { listBankAccount } from '../../../../api/system/bankAccount';
import { listCars } from '../../../../api/system/cars';
import { listCompany } from '../../../../api/system/company';
import { listFleet } from '../../../../api/system/fleet';
import { listDetail } from '../../../../api/system/detail';
import { listExitInventory } from '../../../../api/system/inventoryMain';
import { addGoodsOrder, auditGoodsOrder, getGoodsOrder, updateGoodsOrder } from '../../../../api/system/goodsOrder';
import { listInventory } from '../../../../api/system/inventory';
import { listProductLevel } from '../../../../api/system/productLevel';
import { excludeParams } from '../../../../api/tool/exclude';
import { fix } from '../../../../api/tool/format';
import SearchOption from '../../../../components/SearchOption.vue';
import { parseTime } from '../../../../utils/ruoyi';
import { mixin_form_fillInfo } from '../../mixins/order/form/form_fillInfo';
import { updateOrderRowCalculations } from './orderCalculations';
import _ from 'lodash'; // 导入新的计算函数

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

		return {
			orderInfo: {},
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
			orderdetailList: [],
			checkedOrderdetail: [],
			isEditingDetails: false, // 保留全局编辑状态用于添加/删除行操作
			isEditingBasicInfo: true, // 基本信息编辑状态
			isLand: false,
			isSea: false,
			orderNums: 0,
			querySupplier: null,
			queryLevel: null,
			queryLevel: null,
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
						label: '宽度',
						prop: 'width',
						type: 'input',
						value: ''
					},
					{
						id: 3,
						label: '长度',
						prop: 'length',
						type: 'input',
						value: ''
					},
					{
						id: 4,
						label: '分类名称',
						prop: 'levelName',
						type: 'input',
						value: ''
					}
				]
			},
			queryItemsStoreHouse: {
				queryList: [
					{
						id: 1,
						label: '仓库名称',
						prop: 'storeHouseName',
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
						label: '宽度',
						prop: 'width',
						type: 'input',
						extraInfo: {
							__isParams: false
						},
						value: ''
					},
					{
						id: 4,
						label: '长度',
						prop: 'length',
						type: 'input',
						extraInfo: {
							__isParams: false
						},
						value: ''
					},
					{
						id: 5,
						label: '分类名称',
						prop: 'levelName',
						type: 'input',
						extraInfo: {
							__isParams: false
						},
						value: ''
					},
					{
						id: 6,
						label: '入库时间范围',
						prop: 'main_storeDate_startTime&main_storeDate_endTime',
						type: 'date-range-picker',
						extraInfo: {
							__isParams: true,
							__isMultiple: true
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
		// 添加计算属性检查是否有子项
		hasOrderDetails() {
			return this.orderdetailList && this.orderdetailList.length > 0;
		},
		// 检查是否有任何行正在编辑
		hasEditingRows() {
			return this.orderdetailList && this.orderdetailList.some(row => row.isEditing);
		}
	},
	created() {
		console.log(`OrderForm created`);
		this.resetOrderInfo();
		this.isEditingDetails = false;
		this.orderId && this.getGoodsOrderInfo(this.orderId);
	},
	methods: {
		fix,
		listFleet,
		listCars,
		listBankAccount,
		listCompany,
		listProductLevel,
		listExitInventory,
		getGoodsOrderInfo(id) {
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
					this.orderdetailList = detailList.map(item => {
						return { ...item, isEditing: false };
					});

					// 对加载的数据进行计算
					this.orderdetailList.forEach(row => {
						this.$nextTick(() => {
							// 确保DOM更新后再计算，虽然这里主要是数据计算
							updateOrderRowCalculations(row, this.isSea, this.isLand);
						});
					});
				}
			});
		},
		// 编辑某一行时清除错误状态
		handleRowEdit(row) {
			// 设置当前行为可编辑
			this.$set(row, 'isEditing', true);
			// 清除错误状态
			if (row.hasError) {
				this.$set(row, 'hasError', false);
			}
			this.$message.info('正在编辑该条记录');
		},

		// 修改保存行逻辑，保存row的引用以便后续使用
		handleRowSave(row, resolve = null, reject = null) {
			// 统一处理输入，确保 rows 是数组
			const rows = Array.isArray(row) ? row : [row];
			// 处理每一行，关闭编辑状态并更新计算
			rows.forEach(r => {
				if (r.isEditing) {
					this.$set(r, 'isEditing', false);
					updateOrderRowCalculations(r, this.isSea, this.isLand);
				}
			});
			// 深拷贝并过滤掉仍在编辑的行
			const saveDetails = this.fillOrderDetailInfo(_.cloneDeep(rows).filter(item => !item.isEditing));
			// 构造新的订单信息
			const newOrderInfo = {
				...this.orderInfo,
				orderDetailList: saveDetails
			};
			if (this.isEditingOrder.id) {
				newOrderInfo.id = this.isEditingOrder.id;
			}
			this.addOrUpdateOrderDetail(newOrderInfo, rows, resolve, reject);
		},
		// 优化添加或者修改订单函数，添加错误处理
		addOrUpdateOrderDetail(newOrderInfo, rows, resolve = null, reject = null) {
			// 保存row的引用，避免在Promise链中丢失
			const currentRows = rows;
			if (this.isEditingOrder.id) {
				updateGoodsOrder(newOrderInfo)
					.then(res => {
						// 成功后清除可能的错误标记
						currentRows.forEach(row => {
							if (row.hasError) {
								this.$set(row, 'hasError', false);
							}
						});
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
		// 设置当前编辑状态
		setIsEditingOrder(response, flag = true) {
			console.log(`设置订单信息:`, response);
			this.isEditingOrder.id = response.id;
			this.isEditingOrder.state = flag;
			this.isEditingOrder.currentEditingOrderInfo = response;
		},
		handleAddOrderdetail() {
			let obj = {
				// 添加唯一索引
				index: this.orderdetailList.length + 1,
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
				isEditing: true // 默认不处于编辑状态
			};
			this.orderdetailList.push(obj);
			this.$nextTick(() => {
				if (this.$refs.orderdetail) {
					const bodyWrapper = this.$refs.orderdetail.bodyWrapper;
					if (bodyWrapper) {
						bodyWrapper.scrollLeft = 0;
					}
				}
			});
		},
		// 处理出厂片数变化，自动填充卸货片数
		handlePiecesChange(scope) {
			// 将出厂片数的值赋给卸货片数
			scope.row.actualPieces = scope.row.pieces;
			// 触发重新计算
			this.recalculateAll(scope);
		},
		filterNoStockNumber(data) {
			return new Promise(resolve => {
				const res = data.filter(item => item.actualPieces > 0).sort((a, b) => b.actualPieces - a.actualPieces);
				resolve(res);
			});
		},
		handleDeleteOrderdetail() {
			if (this.checkedOrderdetail.length === 0) {
				this.$message.error('请先选择要删除的订单详情数据');
			} else {
				const orderdetails = this.orderdetailList;
				const checkedOrderdetails = this.checkedOrderdetail;
				console.log(`checked:`, orderdetails, checkedOrderdetails);
				this.orderdetailList = orderdetails.filter(function (item) {
					return checkedOrderdetails.indexOf(item.index) === -1;
				});
			}
		},
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
						sums[index] = fix(sums[index]);
						sums[index] += column.property === 'tonnage' ? ' 吨' : ' 元';
					} else {
						sums[index] = 'N/A';
					}
				}
			});

			return sums;
		},
		handleOrderdetailSelectionChange(selection) {
			console.log(selection);
			this.checkedOrderdetail = selection.map(item => item.index);
			console.log(`selection index`, this.checkedOrderdetail);
		},
		handleUpdateQueryNameStore(value) {
			this.queryLevel = value;
		},
		handleUpdateQuerySupplier(value) {
			this.querySupplier = value;
		},
		handleUpdateQueryNameLevel(value) {
			this.queryLevel = value;
		},
		handleCommitBackSupplier(scope, val) {
			scope.row.supplier = val.companyName;
			scope.row.supplierID = val.id;
			scope.row.currentType = 'supplier';
		},
		handleCommitBackInventory(scope, val) {
			this.clearDetail(scope);
			scope.row.storeID = val.id;
			scope.row.storeHouseID = val.storeHouseid;
			scope.row.storeHouseName = val.storeHouseName;
			scope.row.length = val.length;
			scope.row.height = val.height;
			scope.row.width = val.width;
			scope.row.levelID = val.levelID;
			scope.row.levelName = val.levelName;
			scope.row.erro = val.erro;
			scope.row.currentType = 'storeHouseName';
			// 填充出厂单价
			scope.row.price = val.price;
			// 填充后重新计算
			updateOrderRowCalculations(scope.row, this.isSea, this.isLand);
		},
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
		// 重新计算方法现在直接调用主计算函数
		recalculateAll(scope) {
			updateOrderRowCalculations(scope.row, this.isSea, this.isLand);
		},
		setCurrentType(row, type) {
			row.currentType = type;
		},
		// 填充订单相关必要信息
		fillOrderDetailInfo(detailList = this.orderdetailList) {
			const formatOrderItem = () => ({
				customerID: this.orderInfo.customerID,
				customer: this.orderInfo.customer,
				orderDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}')
			});
			return _.cloneDeep(detailList).map(item => Object.assign(item, formatOrderItem()));
		},
		submitOrder(resolve, reject) {
			this.orderdetailList = this.fillOrderDetailInfo();
			this.orderInfo.orderDetailList = _.cloneDeep(this.orderdetailList);
			this.orderInfo = excludeParams(this.orderInfo, this.$exclude);
			const json = _.cloneDeep(this.orderInfo);
			if (!this.isEditingOrder.id) {
				addGoodsOrder(json).then(resolve).catch(reject);
			} else {
				json.remark = sessionStorage.getItem('order-edit-reason');
				updateGoodsOrder(json).then(resolve).catch(reject);
			}
		},
		reset(that) {
			// 清除订单状态
			this.resetOrderInfo();
			// 清除陆运和海运的状态
			this.isSea = false;
			this.isLand = false;
			const message = this.orderId ? '修改成功' : '添加成功';
			this.$message.success(message);
			sessionStorage.removeItem('order-edit-reason');
			this.setIsEditingOrder(null, false);
			that.dialogVisible = false;
		},
		// 弹窗点击确定
		handleProcess(that) {
			this.$refs.orderForm.validate(valid => {
				if (valid) {
					if (this.orderdetailList.length === 0) {
						this.$message.error('请添加货物信息!');
						return;
					}
					// 检查是否有没有保存的项
					if (this.orderdetailList.some(item => item.isEditing)) {
						this.$antdconfirm({
							title: '当前订单信息中有未保存的项,是否保存并提交?',
							okText: '是',
							cancelText: '否',
							zIndex: 2660,
							onOk: () => {
								new Promise((resolve, reject) => {
									this.handleRowSave(this.orderdetailList, resolve, reject);
								}).then(() => {
									this.reset(that);
								});
							}
						});
					} else {
						new Promise((resolve, reject) => {
							// 填充订单详情信息
							this.submitOrder(resolve, reject);
						}).then(() => {
							this.reset(that);
						});
					}
				} else {
					this.$message.error('请检查表单必填项!');
					return false;
				}
			});
		},
		handleReject() {
			this.isSea = false;
			this.isLand = false;
			this.isEditingDetails = false;
			this.resetOrderInfo();
		},
		resetOrderInfo() {
			this.orderInfo = {
				orderID: '',
				orderNo: '',
				customerID: '',
				customer: '',
				saleManager: '',
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
			this.orderdetailList = [];
			// 重置表单校验状态
			if (this.$refs.orderForm) {
				this.$refs.orderForm.resetFields();
				this.$refs.orderForm.clearValidate();
			}
		},
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
		// 切换编辑模式时处理错误状态
		toggleEditDetails(editState) {
			if (editState) {
				// 进入编辑模式，设置所有行为可编辑状态
				this.orderdetailList.forEach(row => {
					this.$set(row, 'isEditing', true);
					if (row.hasError) {
						this.$set(row, 'hasError', false);
					}
				});
				this.$message.info('已进入批量编辑模式，可以修改所有订单信息');
			} else {
				// 退出编辑模式，保存所有行
				// 如果有正在编辑的行，全部设置为不可编辑
				if (this.hasEditingRows) {
					this.handleRowSave(this.orderdetailList);
				}
			}
		},
		// 添加新方法：根据行是否处于编辑状态设置行的类名
		getRowClassName({ row }) {
			if (row.hasError) {
				return 'error-row';
			} else if (row.isEditing) {
				return 'editing-row';
			}
			return '';
		},
		// 添加新方法：计算出厂片数
		calculatePieces(row) {
			if (row.piecesPerPack > 0 && row.packs > 0) {
				// 计算出厂片数
				row.pieces = (row.piecesPerPack * row.packs).toString();
				// 设置卸货片数等于出厂片数
				row.actualPieces = row.pieces;
				// 触发重新计算
				this.recalculateAll({ row });
			}
		}
	}
};
</script>

<template>
	<div>
		<!-- 基本信息表单部分不变 -->
		<el-form :inline="true" :model="orderInfo" label-width="80px" :rules="orderRules" ref="orderForm">
			<el-alert title="对于禁用的输入框只需点击旁边搜索按钮搜索对应信息，确认后即可自动填写!" type="warning"></el-alert>
			<br />
			<el-card class="box-card" shadow="hover" size="mini">
				<div slot="header" class="clearfix">
					<el-button type="text" style="color: #156fb2" icon="el-icon-notebook-2">订单基本信息</el-button>
				</div>
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
								<SearchOption
									title="陆运信息"
									:limit-info="{ carType: '陆运' }"
									:get-data="listCars"
									query-label="车牌搜索"
									query-info="carNo"
									:query-name="queryLandCar"
									@commitBack="handleCommitBackCar"
									@update:queryName="handleChangeCar"
								>
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
								<SearchOption
									title="车队信息"
									:limit-info="{}"
									:get-data="listFleet"
									query-label="车队名称"
									query-info="fname"
									:query-name="queryFleet"
									@commitBack="handleCommitBackFleet"
									@update:queryName="handleChangeFleet"
								>
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
								<SearchOption
									title="海运信息"
									:limit-info="{ carType: '海运' }"
									:get-data="listCars"
									query-label="柜号"
									query-info="carNo"
									:query-name="querySeaCars"
									@commitBack="handleCommitBackSeaCar"
									@update:queryName="handleChangeSeaCar"
								>
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
				<br />
			</el-card>
		</el-form>
		<br />

		<!--    订单详情的填写-->
		<el-card class="box-card" shadow="hover" size="mini">
			<div>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<!-- 添加按钮 - 始终可用 -->
						<el-button size="mini" type="primary" @click="handleAddOrderdetail">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<!-- 删除按钮 - 只有选中项时可用 -->
						<el-button size="mini" type="danger" @click="handleDeleteOrderdetail" :disabled="checkedOrderdetail.length === 0">删除</el-button>
					</el-col>
					<el-col :span="1.5">
						<!-- 编辑子项按钮 - 有子项且没有行处于编辑状态时可用 -->
						<el-button size="mini" type="warning" @click="toggleEditDetails(true)" :disabled="!hasOrderDetails || hasEditingRows">编辑子项</el-button>
					</el-col>
					<el-col :span="1.5">
						<!-- 全部保存按钮 - 有行处于编辑状态时可用 -->
						<el-button size="mini" type="success" @click="toggleEditDetails(false)" :disabled="!hasEditingRows">全部保存</el-button>
					</el-col>
				</el-row>

				<!--        订单详情表格-->
				<el-table
					border
					size="mini"
					:data="orderdetailList"
					show-summary
					:summary-method="getSummary"
					:row-class-name="getRowClassName"
					@selection-change="handleOrderdetailSelectionChange"
					ref="orderdetail"
				>
					<el-table-column type="selection" width="90" align="center" :selectable="() => true" />
					<el-table-column label="序号" align="center" type="index" width="50" />

					<!-- 新增行操作列，放在前面方便操作 -->
					<el-table-column label="行操作" align="center" width="100">
						<template slot-scope="scope">
							<el-button v-if="!scope.row.isEditing" size="mini" type="warning" icon="el-icon-edit" @click="handleRowEdit(scope.row)">编辑</el-button>
							<el-button v-else size="mini" type="success" icon="el-icon-check" @click="handleRowSave(scope.row)">保存</el-button>
						</template>
					</el-table-column>

					<el-table-column label="供应商/仓库" width="200">
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
										query-label="级别名称"
										query-info="levelName"
										:query-name="queryLevel"
										:additional-limit-info="tableData => filterNoStockNumber(tableData)"
										@commitBack="value => handleCommitBackInventory(scope, value)"
										@update:queryName="handleUpdateQueryNameStore"
										:queryItems="queryItemsStoreHouse"
										@click="setCurrentType(scope.row, 'storeHouseName')"
										:disable="!scope.row.isEditing"
									>
										<template #table-columns>
											<el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip />
											<el-table-column label="级别名称" align="center" prop="levelName" show-overflow-tooltip />
											<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip />
											<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip />
											<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip />
											<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip />
											<el-table-column label="剩余量" align="center" prop="actualPieces" show-overflow-tooltip />
											<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip />
											<el-table-column label="库存价格" align="center" prop="price" show-overflow-tooltip />
											<el-table-column label="库存金额" align="center" show-overflow-tooltip>
												<template #default="scope">
													{{ fix(Number(scope.row.actualPieces * scope.row.price)) }}
												</template>
											</el-table-column>
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
										<el-table-column label="级别名称" align="center" prop="levelName" />
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
					<el-table-column label="计量单位" prop="countingUnit" width="100">
						<template #default="scope">
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!scope.row.isEditing">
								<el-radio label="片">片数</el-radio>
								<el-radio label="其他">其他</el-radio>
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
					<el-table-column label="每包片数" prop="piecesPerPack" width="90">
						<template #default="scope">
							<el-input size="mini" v-model.number="scope.row.piecesPerPack" placeholder="请输入每包片数" :disabled="!scope.row.isEditing" @input="() => calculatePieces(scope.row)" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.number.lazy="scope.row.packs"
								:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
								:disabled="!scope.row.isEditing || scope.row.piecesPerPack <= 0"
								@input="() => calculatePieces(scope.row)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂片数" prop="pieces" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.pieces"
								placeholder="请输入出厂片数"
								@change="() => handlePiecesChange(scope)"
								@input="() => recalculateAll(scope)"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂单价" prop="price" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.price"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="!scope.row.isEditing || !scope.row.pieces"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂是否含税" prop="isIncludeTaxFactory" width="90">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.sundryCost"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'"
								:disabled="!scope.row.isEditing || !scope.row.price"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.paymentFactory" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="卸货片数" prop="actualPieces" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.actualPieces" placeholder="请输入卸货片数" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="卸货价" prop="paymentUnload" width="90">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.paymentUnload" placeholder="请输入卸货价" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="销售是否含税" prop="isIncludeTaxSale" width="90">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="总货款杂费" prop="paymentsWithSundry" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.paymentsWithSundry"
								@input="() => recalculateAll(scope)"
								:disabled="!scope.row.isEditing || !scope.row.paymentUnload"
								:placeholder="scope.row.paymentUnload <= 0 ? '请先完善卸货价' : '请输入总货款杂费'"
							/>
						</template>
					</el-table-column>
					<el-table-column label="总货款" prop="payments" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.payments" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="误差" prop="erro" width="150">
						<template #default="scope">
							<!-- 误差通常由产品级别带出，如果允许手动输入则需要触发计算 -->
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.tonnage" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="陆运费单价" prop="landFreightPrice" width="150" v-if="isLand">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.landFreightPrice" @input="() => recalculateAll(scope)" placeholder="请输入陆运费单价" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="90" v-if="isLand">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="() => recalculateAll(scope)"
								:placeholder="!scope.row.landFreightPrice ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="90" v-if="isLand">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.landFreight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="90" v-if="isSea">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.seaFreight" @input="() => recalculateAll(scope)" placeholder="请输入海运费" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="90">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.otherCost" placeholder="请输入其他费用" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="利润" prop="profit" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profit" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="不含税利润" prop="profitNoTax" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profitNoTax" placeholder="自动计算" disabled />
						</template>
					</el-table-column>

					<el-table-column label="物流利润" prop="logisticsProfit" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.logisticsProfit" placeholder="请输入物流利润" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="客户佣金" prop="customerCommission" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.customerCommission" placeholder="请输入佣金" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="厂家佣金" prop="factoryCommission" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryCommission" placeholder="请输入佣金" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryRebateAmount" placeholder="请输入计提厂家返利金额" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryDiscountAmount" placeholder="请输入计提厂家降价金额" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="备注" prop="comments" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
				</el-table>
			</div>
		</el-card>
	</div>
</template>

<style scoped>
* {
	box-sizing: border-box;
}

/* 保留编辑行样式 */
::v-deep .editing-row {
	background-color: rgba(121, 246, 164, 0.1);
}

::v-deep .editing-row td:first-child {
	border-left: 4px solid #63f697 !important;
}

::v-deep .editing-row:hover {
	box-shadow: 0 0 8px rgba(121, 246, 164, 0.8);
}

/* 添加错误行样式 */
::v-deep .error-row {
	background-color: rgba(245, 108, 108, 0.1);
}

::v-deep .error-row td:first-child {
	border-left: 4px solid #f56c6c !important;
}

::v-deep .error-row:hover {
	box-shadow: 0 0 8px rgba(245, 108, 108, 0.8);
}

/* 为出错行添加闪烁动画效果提高可见性 */
@keyframes errorPulse {
	0% {
		background-color: rgba(245, 108, 108, 0.1);
	}
	50% {
		background-color: rgba(245, 108, 108, 0.2);
	}
	100% {
		background-color: rgba(245, 108, 108, 0.1);
	}
}

::v-deep .error-row {
	animation: errorPulse 2s infinite;
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar {
	width: 12px;
	height: 22px;
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar-thumb {
	background-color: #909399;
	border-radius: 2px;
	border: 2px solid #f2f6fc;
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar-thumb:hover {
	background-color: #606266;
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar-track {
	background-color: #f2f6fc;
	border-radius: 6px;
}

::-webkit-scrollbar {
	width: 12px;
	height: 22px;
}

::-webkit-scrollbar-thumb {
	background-color: #909399;
	border-radius: 6px;
	border: 2px solid #f2f6fc;
}

::-webkit-scrollbar-thumb:hover {
	background-color: #606266;
}

::-webkit-scrollbar-track {
	background-color: #f2f6fc;
	border-radius: 6px;
}
</style>
