<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="出差时间" prop="starttime">
				<el-date-picker v-model="queryParams.starttime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="返回时间" prop="endtime">
				<el-date-picker v-model="queryParams.endtime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:businesstrip:add']" type="danger" size="mini" @click="handleAdd">新增出差信息</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:businesstrip:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			v-horizontal-scroll="'always'"
			v-loading="loading"
			size="mini"
			border
			:data="BusinessTripList"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<!--      <el-table-column label="报销人ID" align="center" prop="employeeID"/>-->
			<el-table-column v-if="columns[0].visible" label="报销人" align="center" prop="employee" />
			<el-table-column v-if="columns[1].visible" label="共同出差人员" align="center" prop="personnel" />
			<el-table-column v-if="columns[2].visible" label="部门" align="center" prop="deptName" />
			<el-table-column v-if="columns[3].visible" label="出差时间" align="center" prop="starttime" />
			<el-table-column v-if="columns[4].visible" label="出差结束时间" align="center" prop="endtime" />
			<el-table-column v-if="columns[5].visible" label="附件" align="center" prop="attachmentPath">
				<template #default="scope">
					<CheckFiles :path="scope.row.attachmentPath" @needToUpdate="value => handleUpdateFilePath(value, scope.row, 'attachmentPath', getBusinessTrip, updateBusinessTrip)" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="是否已报销" align="center" prop="isReimburse">
				<template slot-scope="scope">
					<StateTag :state-title="scope.row.isReimburse === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
				</template>
			</el-table-column>
			<el-table-column label="付款状态" align="center" prop="checkState">
				<template slot-scope="scope">
					<StateTag
						:state-title="scope.row.checkState"
						:state-mapper="{
							0: PAYMENT_APPLY_STATE.UNAPPLIED,
							1: PAYMENT_APPLY_STATE.CHECKED,
							2: PAYMENT_APPLY_STATE.PAID,
							3: PAYMENT_APPLY_STATE.CHECKING
						}"
					/>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[7].visible" label="备注" align="center" prop="comments" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="260px" fixed="right">
				<template slot-scope="scope">
					<el-button :disabled="scope.row.checkState !== PAYMENT_APPLY_STATE.UNAPPLIED" size="mini" type="text" @click="applyForPayment(scope.row)">发起付款申请</el-button>
					<el-button :disabled="scope.row.checkState === PAYMENT_APPLY_STATE.CHECKED" v-hasPermi="['system:businesstrip:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">
						修改
					</el-button>
					<el-button v-hasPermi="['system:businesstrip:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改出差对话框 -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px">
			<StepsForm :active="active" title-one="基本信息登记" title-two="报销信息" title-info="请按照步骤填写出差信息">
				<!--         第一步骤 填写出差基本信息 保存出差基本信息-->
				<template #step-one>
					<el-form ref="form" :model="form" :rules="rules" label-width="120px">
						<el-col :span="12">
							<el-form-item label="报销人" prop="employee">
								<el-input v-model="form.employee" disabled placeholder="请输入报销人" />
							</el-form-item>
							<!-- <el-form-item label="部门" prop="deptName">
                <el-input v-model="form.deptName" placeholder="请输入部门"/>
              </el-form-item>
              <el-row> -->
							<el-form-item label="部门" prop="deptName">
								<treeselect v-model="form.deptName" :options="deptOptions" :normalizer="normalizer" placeholder="请选择部门" />
							</el-form-item>
							<el-form-item label="共同出差人员" prop="personnel">
								<el-input v-model="form.personnel" placeholder="请输入共同出差人员" />
							</el-form-item>
							<el-form-item label="出差时间" prop="starttime">
								<el-date-picker v-model="form.starttime" type="datetime" placeholder="选择出差时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="出差结束时间" prop="endtime">
								<el-date-picker v-model="form.endtime" type="datetime" placeholder="选择出差结束时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
						</el-col>
						<el-col :span="12">
							<el-form-item label="附件地址" prop="attachmentPath">
								<file-upload ref="uploadFile" @input="handleCommitUpload" />
							</el-form-item>
							<el-form-item label="备注" prop="comments">
								<el-input v-model="form.comments" type="textarea" placeholder="请输入内容" />
							</el-form-item>
						</el-col>
					</el-form>
				</template>
				<!--        第二步骤 开始填写车辆使用信息-->
				<template #step-two>
					<el-row>
						<el-col :span="5">
							<span style="font-weight: bolder">是否使用车辆</span>
						</el-col>
						<el-col :span="5">
							<el-radio v-model="useCar" label="是">是</el-radio>
							<el-radio v-model="useCar" label="否">否</el-radio>
						</el-col>
					</el-row>
					<el-row v-if="useCar === '是'" style="margin: 20px 0">
						<!--            车辆信息-->
						<el-row :gutter="10" class="mb8">
							<el-col :span="1.5">
								<el-button size="mini" type="primary" @click="handleAddCars">添加</el-button>
							</el-col>
							<el-col :span="1.5">
								<el-button size="mini" type="danger" @click="handleDeleteCars">删除</el-button>
							</el-col>
						</el-row>
						<el-table size="mini" :data="carsList" :row-class-name="rowCarsIndex" @selection-change="handleCarsSelectionChange">
							<el-table-column type="selection" width="90" align="center" />
							<el-table-column label="序号" align="center" prop="index" />
							<el-table-column label="车牌号" align="center">
								<template #default="scope">
									<el-row>
										<el-col :span="20">
											<el-input size="mini" disabled v-model="scope.row.carNo" />
										</el-col>
										<el-col :span="4">
											<SearchOption
												:limit-info="{}"
												:get-data="listCarApply"
												:query-name="queryCarApply"
												query-info="carNo"
												query-label="车牌"
												@commitBack="value => handleCommitBackCarApply(value, scope)"
												@update:queryName="handleQueryCarApply"
											>
												<template #table-columns>
													<el-table-column label="申请人" prop="applyUser" />
													<el-table-column label="部门" prop="department" />
													<el-table-column label="车牌" prop="carNo" />
													<el-table-column label="用车时间" prop="startTime" />
													<el-table-column label="还车时间" prop="endTime" />
												</template>
											</SearchOption>
										</el-col>
									</el-row>
								</template>
							</el-table-column>
							<el-table-column label="车辆信息" align="center">
								<template #default="scope">
									<el-button v-if="scope.row.carNo" type="text" size="mini" @click="handleCheckCar(scope.row)">查看车辆信息</el-button>
									<el-button v-else type="text" size="mini">请先引用车辆</el-button>
								</template>
							</el-table-column>
						</el-table>
					</el-row>
					<hr />
					<el-row :gutter="10" class="mb8">
						<el-col :span="5">
							<span style="font-weight: bolder">填写报销项</span>
						</el-col>
						<el-col :span="3">
							<el-button type="primary" size="mini" @click="handleAddTripReimbursement">添加报销项</el-button>
						</el-col>
						<el-col :span="3">
							<el-button type="danger" size="mini" @click="handleDeleteTripReimbursement">删除报销项</el-button>
						</el-col>
					</el-row>
					<el-table ref="tripReimbursement" :data="tripReimbursementList" :row-class-name="rowTripReimbursementIndex" @selection-change="handleTripReimbursementSelectionChange">
						<el-table-column type="selection" width="100" align="center" />
						<el-table-column label="序号" align="center" prop="index" width="150px" />
						<el-table-column label="报销项" prop="item" width="350px">
							<template slot-scope="scope">
								<el-row>
									<el-col :span="20">
										<el-input v-model="scope.row.item" placeholder="请输入报销项" :disabled="scope.row.isDisabled" />
									</el-col>
									<el-col :span="4">
										<SubjectOption @update:type="value => handleType(value, scope)" />
									</el-col>
								</el-row>
							</template>
						</el-table-column>
						<el-table-column label="费用" prop="itemCost">
							<template slot-scope="scope">
								<el-input v-model="scope.row.itemCost" type="number" placeholder="请输入费用" :disabled="scope.row.isDisabled" />
							</template>
						</el-table-column>
					</el-table>
				</template>
				<template #step-three>
					<el-result icon="success" title="申请提交成功">
						<template slot="extra">
							<el-button type="primary" size="medium" @click="closeAll">关闭</el-button>
						</template>
					</el-result>
				</template>
			</StepsForm>
			<div v-if="active !== 2" slot="footer" class="dialog-footer">
				<el-button v-if="active !== 0" type="warning" @click="before">上一步</el-button>
				<el-button v-if="active !== 1" type="warning" @click="next">下一步</el-button>
				<el-button v-if="active === 1" type="success" @click="nextAndSubmit">完成提交</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    付款申请弹窗-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="applyForPaymentDialogVisible" width="60%">
			<keep-alive>
				<ApplyPayment :table-name="TableName.BUSINESS_TRIP" :t-i-d="tID" :need-info="{}" :need-money="needMoney" @changeOpen="changePaymentApplyInfoVisible" />
			</keep-alive>
		</el-dialog>

		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				:close-confirm="closeConfirm"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>
	</div>
</template>

<script>
import { delBusinessTrip, getBusinessTrip, updateBusinessTrip, listBusinessTrip } from '@/api/system/BusinessTrip';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { mapGetters } from 'vuex';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { PAYMENT_APPLY_STATE, TableName } from '@/api/tool/enums';
import { listBankAccount } from '@/api/system/bankAccount';
import { mixin_business_trip_add } from '../../dashboard/mixins/bussiness/business_trip_add';
import StepsForm from '../../dashboard/components/businessTrip/StepsForm.vue';
import { mixin_common_upload } from '../../dashboard/mixins/common/common_upload';
import { mixin_business_trip_update } from '../../dashboard/mixins/bussiness/business_trip_update';
import { mixin_business_trip_car_apply } from '../../dashboard/mixins/bussiness/bussiness_trip_car_apply';
import SubjectOption from '../../../components/SubjectOption.vue';
import { listDept } from '@/api/system/dept';
import '@riophae/vue-treeselect/dist/vue-treeselect.css';
import Treeselect from '@riophae/vue-treeselect';
import CheckFiles from '@/components/CheckFiles.vue';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import { listCarApply } from '../../../api/system/carApply';
import SearchOption from '../../../components/SearchOption.vue';
import { common_dialog } from '../../dashboard/mixins/common/common_dialog';
import DialogWrapper from '../../dashboard/components/common/DialogWrapper.vue';
import CARS from '../../../components/NeedToShow/CARS.vue';
import { listCars } from '../../../api/system/cars';
import { listVehicles } from '@/api/system/vehicles';
import COMPANY_CAR from '@/components/NeedToShow/COMPANY_CAR.vue';

export default {
	name: 'BusinessTrip',
	components: {
		DialogWrapper,
		SearchOption,
		StateTag,
		CheckFiles,
		SubjectOption,
		StepsForm,
		ApplyPayment,
		Treeselect
	},
	mixins: [mixin_printHTML, mixin_common_upload, common_dialog, mixin_business_trip_add, mixin_business_trip_update, mixin_business_trip_car_apply, mixin_checkfile],
	data() {
		return {
			loading: true,
			ids: [],
			checkedTripReimbursement: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			BusinessTripList: [],
			tripReimbursementList: [],
			title: '',
			open: false,
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				employeeID: null,
				employee: null,
				personnel: null,
				starttime: null,
				endtime: null,
				attachmentPath: null,
				isReimburse: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			deptOptions: [],
			form: {
				employee: ''
			},
			rules: {
				employee: [
					{
						required: true,
						message: '请输入出差人员',
						trigger: 'blur'
					}
				],
				personnel: [
					{
						required: true,
						message: '请输入出差人员',
						trigger: 'blur'
					}
				],
				starttime: [
					{
						required: true,
						message: '请输入出差开始时间',
						trigger: 'blur'
					}
				],
				endtime: [
					{
						required: true,
						message: '请输入出差结束时间',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `报销人`, visible: true },
				{ key: 1, label: `共同出差人员`, visible: true },
				{ key: 2, label: `部门`, visible: true },
				{ key: 3, label: `出差时间`, visible: true },
				{ key: 4, label: `出差结束时间`, visible: true },
				{ key: 5, label: `附件地址`, visible: true },
				{ key: 6, label: `是否已报销`, visible: true },
				{ key: 7, label: `备注`, visible: true }
			],
			// 当前步骤
			active: 0,

			// 发起付款申请的
			applyForPaymentDialogVisible: false,
			tID: '',
			needMoney: 0,
			isRecharge: '',
			oilCardConsumeInfo: {
				oilCardNo: '',
				carNo: '',
				// 附件路径
				attachmentOiladd: '',
				// 充值金额 默认为0
				rechargeMoney: '0'
			},
			// 文件上传
			baseUrl: process.env.VUE_APP_BASE_API,
			uploadFileUrl: process.env.VUE_APP_BASE_API + '/common/upload', // 上传文件服务器地址

			options: [
				{
					value: '现金',
					label: '现金'
				},
				{
					value: '银行卡',
					label: '银行卡'
				}
			],
			queryBankAcount: '',
			// 互斥变量UUID
			UUID: '',

			carsList: [],
			checkedCars: [],
			queryCarApply: ''
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('BusinessTrip-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 监听是否携带了油卡 如果携带，那么要打开填写加油卡消费记录的弹窗
		'carApplyForm.isUseOilCard': {
			handler: function () {
				// console.log(newVal)
			}
		}
	},
	created() {
		this.getList();
		// 获取部门信息
		listDept().then(response => {
			this.deptOptions = this.handleTree(response.data, 'deptId');
		});
		if (localStorage.getItem('BusinessTrip-columns') === 'null' || !localStorage.getItem('BusinessTrip-columns')) {
			// 设置localStorage
			localStorage.setItem('BusinessTrip-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('BusinessTrip-columns'));
		}
	},
	computed: {
		PAYMENT_APPLY_STATE() {
			return PAYMENT_APPLY_STATE;
		},
		TableName() {
			return TableName;
		},
		...mapGetters(['trueName']),
		...mapGetters(['deptName'])
	},
	methods: {
		listCarApply,
		updateBusinessTrip,
		getBusinessTrip,
		listBankAccount,
		// 转换部门树形结构
		normalizer(node) {
			if (node.children && !node.children.length) {
				delete node.children;
			}
			return {
				id: node.deptName,
				label: node.deptName,
				children: node.children
			};
		},
		// 发起付款申请
		applyForPayment(row) {
			getBusinessTrip(row.id).then(res => {
				// 出差费用包含 报销项 车辆使用申请的保养金额 加油金额 初期金额
				if (res.data.tripReimbursementList !== null && res.data.tripReimbursementList !== undefined) {
					if (res.data.tripReimbursementList.length > 0) {
						res.data.tripReimbursementList.forEach(item => {
							this.needMoney += item.itemCost;
						});
					} else {
						this.needMoney = 0;
					}
				} else {
					this.needMoney = 0;
				}
				this.tID = row.id;
				this.applyForPaymentDialogVisible = true;
			});
		},
		// 自动填写报销项
		handleType(value, scope) {
			scope.row.item = value;
		},
		changePaymentApplyInfoVisible() {
			this.needMoney = 0;
			this.applyForPaymentDialogVisible = false;
			this.getList();
		},
		handleCarsSelectionChange(selection) {
			this.checkedCars = selection.map(item => item.index);
		},
		rowCarsIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		handleAddCars() {
			let obj = {
				id: null,
				carNo: null
			};
			// 将初始化对象添加到 carsList
			this.carsList.push(obj);
		},
		handleDeleteCars() {
			if (this.checkedCars.length === 0) {
				this.$message.error('请先选择要删除的车辆数据');
			} else {
				const cars = this.carsList;
				const checkedCars = this.checkedCars;
				this.carsList = cars.filter(function (item) {
					return checkedCars.indexOf(item.index) === -1;
				});
			}
		},
		handleCommitBackCarApply(value, scope) {
			scope.row.id = value.id;
			scope.row.carNo = value.carNo;

			function addReimbursementItem(item, cost) {
				const existingItem = this.tripReimbursementList.find(reimbursement => reimbursement.item === item);

				// 如果该项费用已经存在，则累加
				if (existingItem) {
					existingItem.itemCost = Number(existingItem.itemCost) + Number(cost);
				} else {
					// 否则添加新的费用项
					this.tripReimbursementList.push({
						item: item,
						itemCost: cost
					});
				}
			}

			// 引用车辆的时候需要将费用置于小项中
			if (value.fine) {
				addReimbursementItem.call(this, '规章费用', value.fine);
			}
			if (value.refuelingMoney) {
				addReimbursementItem.call(this, '加油费用', value.refuelingMoney);
			}
			if (value.cashRefueling) {
				addReimbursementItem.call(this, '现金加油费用', value.cashRefueling);
			}
			if (value.repairMoney) {
				addReimbursementItem.call(this, '维修费用', value.repairMoney);
			}
			if (value.maintenanceMoney) {
				addReimbursementItem.call(this, '保养费用', value.maintenanceMoney);
			}
		},
		handleQueryCarApply(value) {
			this.queryCarApply = value;
		},
		handleCheckCar(row) {
			listVehicles({ licensePlate: row.carNo }).then(res => {
				if (res.rows.length > 0) {
					this.openDialog(
						COMPANY_CAR,
						'查看车辆信息',
						'650px',
						{
							needToShowInfo: res.rows[0]
						},
						true
					);
				} else {
					this.$message.error('该车辆不存在');
				}
			});
		},
		/** 查询出差列表 */
		getList() {
			this.loading = true;
			listBusinessTrip(this.queryParams).then(response => {
				this.BusinessTripList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
			this.$refs.uploadFile.clearFileList();
		},
		// 出差信息表单重置
		reset() {
			this.active = 0;
			this.form = {
				id: null,
				employeeID: null,
				employee: null,
				personnel: null,
				starttime: null,
				endtime: null,
				attachmentPath: null,
				isReimburse: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.tripReimbursementList = [];
			this.carsList = [];
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},

		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除出差编号为"' + ids + '"的数据项？')
				.then(function () {
					return delBusinessTrip(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 出差报销序号 */
		rowTripReimbursementIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		/** 出差报销添加按钮操作 */
		handleAddTripReimbursement() {
			const obj = {};
			obj.item = '';
			obj.itemCost = '';
			obj.comments = '';
			obj.addtime = '';
			obj.userId = '';
			obj.UserName = '';
			obj.delFlag = '';
			this.tripReimbursementList.push(obj);
		},
		/** 出差报销删除按钮操作 */
		handleDeleteTripReimbursement() {
			if (this.checkedTripReimbursement.length === 0) {
				this.$modal.msgError('请先选择要删除的出差报销数据');
			} else {
				const tripReimbursementList = this.tripReimbursementList;
				const checkedTripReimbursement = this.checkedTripReimbursement;
				this.tripReimbursementList = tripReimbursementList.filter(function (item) {
					return checkedTripReimbursement.indexOf(item.index) === -1;
				});
			}
		},
		/** 复选框选中数据 */
		handleTripReimbursementSelectionChange(selection) {
			this.checkedTripReimbursement = selection.map(item => item.index);
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/BusinessTrip/export',
				{
					...this.queryParams
				},
				`BusinessTrip_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
