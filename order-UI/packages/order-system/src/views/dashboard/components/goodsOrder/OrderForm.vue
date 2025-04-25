<script>
import { listBankAccount } from '../../../../api/system/bankAccount';
import { listCars } from '../../../../api/system/cars';
import { listCompany } from '../../../../api/system/company';
import { listFleet } from '../../../../api/system/fleet';
import { listDetail } from '../../../../api/system/detail';
import { listExitInventory } from '../../../../api/system/inventoryMain';
import { addGoodsOrder, getGoodsOrder, updateGoodsOrder } from '../../../../api/system/goodsOrder';
import { listInventory } from '../../../../api/system/inventory';
import { listProductLevel } from '../../../../api/system/productLevel';
import { excludeParams } from '../../../../api/tool/exclude';
import { fix } from '../../../../api/tool/format';
import SearchOption from '../../../../components/SearchOption.vue';
import { parseTime } from '../../../../utils/ruoyi';
import { mixin_form_fillInfo } from '../../mixins/order/form/form_fillInfo';
import { updateOrderRowCalculations } from './orderCalculations'; // 导入新的计算函数

export default {
	name: 'OrderForm',
	components: { SearchOption },
	mixins: [mixin_form_fillInfo],
	props: {
		orderId: {
			type: String,
			default: ''
		},
		submitInfo: {
			type: String,
			default: '提交'
		}
	},
	data() {
		return {
			orderInfo: {},
			orderRules: {
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
			isEditingDetails: false,
			isLand: false,
			isSea: false,
			orderNums: 0,
			querySupplier: null,
			queryLevel: null,
			queryStore: null,
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
					},
					{
						id: 5,
						label: '入库时间',
						prop: 'storeDate',
						type: 'input',
						value: ''
					}
				]
			}
		};
	},
	watch: {
		orderId: {
			handler(val) {
				this.resetOrderInfo();
				this.isEditingDetails = false;
				this.orderId && this.getGoodsOrderInfo(val);
			}
		},
		isLand: {
			handler(val) {
				if (val === false) {
					this.resetLandCarInfo();
				}
			}
		},
		isSea: {
			handler(val) {
				if (val === false) {
					this.resetSeaCarInfo();
				}
			}
		}
	},
	created() {
		this.resetOrderInfo();
		this.isEditingDetails = false;
		this.orderId && this.getGoodsOrderInfo(this.orderId);
	},
	methods: {
		fix,
		listInventory,
		listFleet,
		listCars,
		listBankAccount,
		listCompany,
		listProductLevel,
		listDetail,
		listExitInventory,
		getGoodsOrderInfo(id) {
			getGoodsOrder(id).then(response => {
				this.orderInfo = response.data;
				this.isLand = !!response.data.landCarNo; // 根据是否有车牌判断
				this.isSea = !!response.data.seaCarNo; // 根据是否有柜号判断
				this.orderdetailList = response.data.orderDetailList || [];
				// 对加载的数据进行计算
				this.orderdetailList.forEach(row => {
					this.$nextTick(() => {
						// 确保DOM更新后再计算，虽然这里主要是数据计算
						updateOrderRowCalculations(row, this.isSea, this.isLand);
					});
				});
			});
		},
		handleAddOrderdetail() {
			let obj = {
				orderDate: new Date(),
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
				comments: ''
			};
			this.orderdetailList.push(obj);
			// 新增行后，如果需要，可以立即进行一次计算（如果默认值需要计算结果）
// updateOrderRowCalculations(obj, this.isSea, this.isLand);

			this.$nextTick(() => {
				if (this.$refs.orderdetail) {
					const bodyWrapper = this.$refs.orderdetail.bodyWrapper;
					if (bodyWrapper) {
						bodyWrapper.scrollLeft = 0;
					}
				}
			});
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
				this.orderdetailList = orderdetails.filter(function (item) {
					return checkedOrderdetails.indexOf(item.index) === -1;
				});
			}
		},
		rowOrderdetailIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
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
			this.checkedOrderdetail = selection.map(item => item.index);
		},
		handleUpdateQueryNameStore(value) {
			this.queryStore = value;
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
		handleProcess(that) {
			return new Promise((resolve, reject) => {
				if (this.orderdetailList.length === 0) {
					this.$message.error('请添加货物信息');
					reject('请添加货物信息');
					return;
				}
				if (this.isEditingDetails) {
					this.$message.error('请先保存订单详情');
					reject('请先保存订单详情');
					return;
				}
				if (this.isSea && !this.orderInfo.seaCarID && !this.orderInfo.seaCarNo) {
					this.$message.error('请填写完整的海运信息!');
					reject('请填写完整的海运信息!');
					return;
				}
				if (this.isLand && !this.orderInfo.landCarID && !this.orderInfo.landCarNo) {
					this.$message.error('请填写完整的陆运信息!');
					reject('请填写完整的陆运信息!');
					return;
				}
				if (!this.orderId) {
					this.orderInfo.orderDetailList = this.orderdetailList;
					const updateOrderItem = item => {
						item.customerID = this.orderInfo.customerID;
						item.customer = this.orderInfo.customer;
						item.orderDate = parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}');
					};
					this.orderdetailList.forEach(item => updateOrderItem(item));
					addGoodsOrder({ ...this.orderInfo, PaymentState: '' }).then(() => {
						this.resetOrderInfo();
						this.isSea = false;
						this.isLand = false;
						this.$message({
							message: '添加成功',
							type: 'success'
						});
						that.dialogVisible = false;
						resolve();
					});
				} else {
					this.orderInfo.orderDetailList = this.orderdetailList;
					const formatOrderItem = () => ({
						customerID: this.orderInfo.customerID,
						customer: this.orderInfo.customer,
						orderDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}')
					});
					this.orderdetailList.forEach(item => Object.assign(item, formatOrderItem()));
					this.orderInfo = excludeParams(this.orderInfo, this.$exclude);
					updateGoodsOrder({
						...this.orderInfo,
						PaymentState: '',
						remark: sessionStorage.getItem('order-edit-reason')
					}).then(() => {
						this.resetOrderInfo();
						this.$message({
							message: '修改成功',
							type: 'success'
						});
						sessionStorage.removeItem('order-edit-reason');
						this.isSea = false;
						this.isLand = false;
						that.dialogVisible = false;
						resolve();
					});
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
				isSea: '',
				isLand: ''
			};
			this.isEditingDetails = false;
			this.orderdetailList = [];
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
		},
		resetLandCarInfo() {
			this.orderInfo.landCarID = '';
			this.orderInfo.landCarNo = '';
			this.orderInfo.landDriverName = '';
			this.orderInfo.landDriverTel = '';
		},
		toggleEditDetails(editState) {
			this.isEditingDetails = editState;
			if (!editState) {
				this.$message.success('当前状态下订单无法编辑,请先点击编辑按钮!');
			} else {
				this.$message.info('正在编辑订单信息!');
			}
		},
		close() {
			this.$emit('close');
		}
	}
};
</script>

<template>
	<div>
		<el-form :inline="true" :model="orderInfo" label-width="80px" :rules="orderRules">
			<el-alert title="对于禁用的输入框只需点击旁边搜索按钮搜索对应信息，确认后即可自动填写!" type="warning"></el-alert>
			<br />
			<el-card class="box-card" shadow="hover">
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
					<el-form-item label="车牌">
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
					<el-form-item label="司机">
						<el-input disabled v-model="orderInfo.landDriverName" type="text" size="mini" placeholder="请选择车牌" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input disabled v-model="orderInfo.landDriverTel" type="text" size="mini" placeholder="请选择车牌" style="width: 120px" />
					</el-form-item>
					<el-form-item label="车队">
						<el-row>
							<el-col :span="12">
								<el-input disabled v-model="orderInfo.fleet" type="text" size="mini" placeholder="请选择车队" />
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
					<el-form-item label="柜号(填写)">
						<el-input v-model="orderInfo.seaCarNo" type="text" size="mini" placeholder="请输入柜号" style="width: 120px" />
					</el-form-item>
					<el-form-item label="海运公司">
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
		<el-card class="box-card" shadow="hover">
			<div>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button size="mini" type="primary" @click="handleAddOrderdetail" :disabled="!isEditingDetails">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button size="mini" type="danger" @click="handleDeleteOrderdetail" :disabled="!isEditingDetails || checkedOrderdetail.length === 0">删除</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button size="mini" type="warning" @click="toggleEditDetails(true)" :disabled="isEditingDetails">编辑</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button size="mini" type="success" @click="toggleEditDetails(false)" :disabled="!isEditingDetails">保存</el-button>
					</el-col>
				</el-row>
				<el-table
					border
					size="mini"
					:data="orderdetailList"
					show-summary
					:summary-method="getSummary"
					:row-class-name="rowOrderdetailIndex"
					@selection-change="handleOrderdetailSelectionChange"
					ref="orderdetail"
				>
					<el-table-column type="selection" width="90" align="center" :selectable="() => isEditingDetails" />
					<el-table-column label="序号" align="center" prop="index" width="50" />
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
										:disabled="!isEditingDetails"
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
										:query-name="queryStore"
										:additional-limit-info="tableData => filterNoStockNumber(tableData)"
										@commitBack="value => handleCommitBackInventory(scope, value)"
										@update:queryName="handleUpdateQueryNameStore"
										:queryItems="queryItemsStoreHouse"
										@click="setCurrentType(scope.row, 'storeHouseName')"
										:disabled="!isEditingDetails"
									>
										<template #table-columns>
											<el-table-column label="级别名称" align="center" prop="levelName" show-overflow-tooltip />
											<el-table-column label="级别编码" align="center" prop="levelID" show-overflow-tooltip />
											<el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip />
											<el-table-column label="剩余量" align="center" prop="actualPieces" show-overflow-tooltip />
											<el-table-column label="入库时间" align="center" prop="storeDate" show-overflow-tooltip />
											<el-table-column label="供应商" align="center" prop="supplier" show-overflow-tooltip />
											<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip />
											<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip />
											<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip />
											<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip />
											<el-table-column label="片数" align="center" prop="pieces" show-overflow-tooltip />
											<el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip />
											<el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip />
											<el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip />
											<el-table-column label="是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip />
											<el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip />
											<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip />
											<el-table-column label="卸货价" align="center" prop="paymentUnload" show-overflow-tooltip />
											<el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip />
											<el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip />
											<el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip />
											<el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip />
											<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip />
											<el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip />
											<el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip />
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
									:disabled="!isEditingDetails"
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
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!isEditingDetails">
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
							<el-input size="mini" v-model.number="scope.row.piecesPerPack" placeholder="请输入每包片数" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.number.lazy="scope.row.packs"
								:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
								:disabled="!isEditingDetails || scope.row.piecesPerPack <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂片数" prop="pieces" width="90">
						<template #default="scope">
							<el-input size="mini" v-model.number="scope.row.pieces" placeholder="请输入出厂片数" @input="() => recalculateAll(scope)" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="出厂单价" prop="price" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.price"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="!isEditingDetails || !scope.row.pieces"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂是否含税" prop="isIncludeTaxFactory" width="90">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateAll(scope)" :disabled="!isEditingDetails">
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
								:disabled="!isEditingDetails || !scope.row.price"
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
							<el-input size="mini" v-model.number="scope.row.actualPieces" placeholder="请输入卸货片数" @input="() => recalculateAll(scope)" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="卸货价" prop="paymentUnload" width="90">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.paymentUnload" placeholder="请输入卸货价" @input="() => recalculateAll(scope)" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="销售是否含税" prop="isIncludeTaxSale" width="90">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateAll(scope)" :disabled="!isEditingDetails">
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
								:disabled="!isEditingDetails || !scope.row.paymentUnload"
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
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" @input="() => recalculateAll(scope)" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.tonnage" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="陆运费单价" prop="landFreightPrice" width="150" v-if="isLand">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.landFreightPrice" @input="() => recalculateAll(scope)" placeholder="请输入陆运费单价" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="90" v-if="isLand">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="() => recalculateAll(scope)"
								:placeholder="!scope.row.landFreightPrice ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="!isEditingDetails"
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
							<el-input size="mini" v-model.lazy="scope.row.seaFreight" @input="() => recalculateAll(scope)" placeholder="请输入海运费" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="90">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.otherCost" placeholder="请输入其他费用" @input="() => recalculateAll(scope)" :disabled="!isEditingDetails" />
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
							<el-input size="mini" v-model="scope.row.logisticsProfit" placeholder="请输入物流利润" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="客户佣金" prop="customerCommission" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.customerCommission" placeholder="请输入佣金" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="厂家佣金" prop="factoryCommission" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryCommission" placeholder="请输入佣金" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryRebateAmount" placeholder="请输入计提厂家返利金额" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryDiscountAmount" placeholder="请输入计提厂家降价金额" :disabled="!isEditingDetails" />
						</template>
					</el-table-column>
					<el-table-column label="备注" prop="comments" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" :disabled="!isEditingDetails" />
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
