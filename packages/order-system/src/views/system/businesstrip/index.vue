<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
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
			<el-table-column v-if="columns[0].visible" label="报销人" align="center" prop="employee" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="共同出差人员" align="center" prop="personnel" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="部门" align="center" prop="deptName" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="出差时间" align="center" prop="starttime" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="出差结束时间" align="center" prop="endtime" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="附件" align="center" prop="attachmentList" show-overflow-tooltip>
				<template #default="scope">
					<CheckFiles :attachment-list="scope.row.attachmentList" flag="attachmentList" @needToUpdate="value => handleUpdateAttachments(value, scope.row)" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="是否已报销" align="center" prop="isReimburse" show-overflow-tooltip>
				<template slot-scope="scope">
					<StateTag :state-title="scope.row.isReimburse === 0 ? '否' : '是'" :state-mapper="{ 0: '否', 2: '是' }" />
				</template>
			</el-table-column>
			<el-table-column label="付款状态" align="center" prop="checkState" width="200" show-overflow-tooltip>
				<template slot-scope="scope">
					<PaymentFlag :business-object="scope.row">
						<template #extra="{ status, type }">
							<!-- 根据状态展示操作按钮 -->
							<el-button v-if="type === 'paymentApply' && status === PAYMENT_APPLY_STATE.V2.UN_APPLIED" size="mini" type="text" @click="applyForPayment(scope.row)">申请付款</el-button>
						</template>
					</PaymentFlag>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[7].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="260px" fixed="right">
				<template slot-scope="scope">
					<el-button :disabled="scope.row.checkState === PAYMENT_APPLY_STATE.V1.CHECKED" v-hasPermi="['system:businesstrip:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:businesstrip:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改出差对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px">
			<StepsForm :active="active" title-one="基本信息登记" title-two="报销信息" title-info="请按照步骤填写出差信息">
				<template #step-one>
					<el-form ref="form" :model="form" :rules="rules" label-width="120px">
						<el-col :span="12">
							<el-form-item label="报销人" prop="employee">
								<el-row>
									<el-col :span="20">
										<el-input v-model="form.employee" disabled placeholder="请选择" />
									</el-col>
									<el-col :span="4">
										<SearchOption :limit-info="{}" :get-data="listUser" query-label="用户名" :query-name="queryEmployee" query-info="userName" @commitBack="handleCommitBackEmployee" @update:queryName="handleQueryEmployee">
											<template #table-columns>
												<el-table-column label="用户名" prop="userName" :show-overflow-tooltip="true" />
												<el-table-column label="真实姓名" prop="trueName" :show-overflow-tooltip="true" />
												<el-table-column label="岗位" prop="postName" :show-overflow-tooltip="true" />
												<el-table-column label="手机号码" prop="phonenumber" width="120" />
												<el-table-column label="在职状态" prop="state" width="120" />
												<el-table-column label="入职时间" prop="startDate" width="120" />
												<el-table-column label="身份证号码" prop="iDCard" width="120" />
												<el-table-column label="性别" prop="sex" width="120" />
												<el-table-column label="出生日期" prop="birthday" width="120" />
												<el-table-column label="民族" prop="nation" width="120" />
												<el-table-column label="政治面貌" prop="politicalStatus" width="120" />
												<el-table-column label="婚姻状况" prop="maritalStatus" width="120" />
												<el-table-column label="户籍地址" prop="domicileAddress" width="120" />
												<el-table-column label="居住地址" prop="residentialAddress" width="120" />
												<el-table-column label="紧急联系人" prop="relationPerson" width="120" />
												<el-table-column label="紧急联系人电话" prop="relationPersonTel" width="120" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
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
							<el-form-item label="附件" prop="attachmentList">
								<UploadFilesButton flag="attachments" @files-updated="handleAttachmentFilesUpdated" :initial-attachments="form.attachmentList || []" />
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
					</el-row>
					<el-row v-if="useCar === '是'">
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
											<SearchOption :limit-info="{ auditState: '已审核' }" :get-data="listCarApply" :query-name="queryCarApply" query-info="carNo" query-label="车牌" @commitBack="value => handleCommitBackCarApply(value, scope)" @update:queryName="handleQueryCarApply">
												<template #table-columns>
													<el-table-column label="申请人" prop="applyUser" />
													<el-table-column label="部门" prop="department" />
													<el-table-column label="车牌" prop="carNo" />
													<el-table-column label="用车时间" prop="startTime" />
													<el-table-column label="审核状态" prop="auditState" />
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
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="applyForPaymentDialogVisible" width="60%">
			<keep-alive>
				<ApplyPayment :table-name="TableName.BUSINESS_TRIP" :t-i-d="tID" :need-info="{}" :need-money="needMoney" @changeOpen="changePaymentApplyInfoVisible" />
			</keep-alive>
		</el-dialog>

		<!-- 未审核车辆列表弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :visible.sync="notPassedCarDialogVisible" title="未审核的车辆" width="80%" height="600px">
			<el-table :data="notPassedCarList" border>
				<el-table-column label="申请人" prop="applyUser" />
				<el-table-column label="车牌号" prop="carNo" />
				<el-table-column label="用车时间" prop="startTime" />
				<el-table-column label="还车时间" prop="endTime" />
				<el-table-column label="审核状态" prop="auditState">
					<template slot-scope="scope">
						<el-tag type="danger">{{ scope.row.auditState || '未审核' }}</el-tag>
					</template>
				</el-table-column>
			</el-table>
		</el-dialog>
	</div>
</template>

<script>
import { delBusinessTrip, getBusinessTrip, updateBusinessTrip, listBusinessTrip, getCarApplyAuditStatus, addBusinessTrip } from '@/api/system/BusinessTrip';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { mapGetters } from 'vuex';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import PaymentFlag from '@/components/PaymentFlag/index.vue';
import { PAYMENT_APPLY_STATE, TableName } from '@/api/tool/enums';
import { listBankAccount } from '@/api/system/bankAccount';
import { mixin_business_trip_add } from '../../dashboard/mixins/bussiness/business_trip_add';
import StepsForm from '../../dashboard/components/businessTrip/StepsForm.vue';
import { mixin_business_trip_update } from '../../dashboard/mixins/bussiness/business_trip_update';
import { mixin_business_trip_car_apply } from '../../dashboard/mixins/bussiness/bussiness_trip_car_apply';
import SubjectOption from '../../../components/SubjectOption.vue';
import { listDept } from '@/api/system/dept';
import '@riophae/vue-treeselect/dist/vue-treeselect.css';
import Treeselect from '@riophae/vue-treeselect';
import CheckFiles from '@/components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import { listCarApply } from '../../../api/system/carApply';
import SearchOption from '../../../components/SearchOption.vue';
import { common_dialog } from '../../dashboard/mixins/common/common_dialog';
import { listVehicles } from '@/api/system/vehicles';
import COMPANY_CAR from '@/components/NeedToShow/COMPANY_CAR.vue';
import { listUser } from '@/api/system/user';

export default {
	name: 'BusinessTrip',
	components: {
		SearchOption,
		StateTag,
		CheckFiles,
		UploadFilesButton,
		SubjectOption,
		StepsForm,
		ApplyPayment,
		PaymentFlag,
		Treeselect
	},
	mixins: [mixin_printHTML, common_dialog, mixin_business_trip_add, mixin_business_trip_update, mixin_business_trip_car_apply],
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
				pageSize: 20,
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
			queryCarApply: '',

			// 未审核车辆列表相关
			notPassedCarDialogVisible: false,
			notPassedCarList: [],
			// 报销人搜索字段
			queryEmployee: ''
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
		listUser,
		// 搜索报销人信息的回调
		handleQueryEmployee(val) {
			this.queryEmployee = val;
		},
		handleCommitBackEmployee(val) {
			// 优先使用trueName，如果为空或Null则回退使用userName
			this.form.employee = val.trueName ? val.trueName : val.userName;
			this.form.employeeID = val.userId;
		},

		/**
		 * **状态映射函数：版本适配层**
		 * 将V1版本的checkState映射为V2版本的标准状态
		 *
		 * **设计模式：** 适配器模式 - 处理不同版本状态枚举的兼容性
		 *
		 * @param {String|Number} checkState - V1版本的状态值
		 * @returns {String} V2版本的标准状态值
		 */
		mapCheckStateToV2(checkState) {
			// **V1到V2的状态映射表**
			const stateMapping = {
				// V1数字状态映射
				0: PAYMENT_APPLY_STATE.V2.UN_APPLIED, // 未申请
				1: PAYMENT_APPLY_STATE.V2.PASS, // 已审核通过
				2: PAYMENT_APPLY_STATE.V2.PASS, // 已支付（视为通过）
				3: PAYMENT_APPLY_STATE.V2.ING, // 审核中

				// V1字符串状态映射（兼容性处理）
				未申请: PAYMENT_APPLY_STATE.V2.UN_APPLIED,
				已审核: PAYMENT_APPLY_STATE.V2.PASS,
				已支付: PAYMENT_APPLY_STATE.V2.PASS,
				审核中: PAYMENT_APPLY_STATE.V2.ING,
				未通过: PAYMENT_APPLY_STATE.V2.NOT_PASS
			};

			// **默认值处理**
			return stateMapping[checkState] || PAYMENT_APPLY_STATE.V2.UN_APPLIED;
		},

		/**
		 * 统一附件处理方法
		 * @param {Object} uploadParams - 上传组件返回的参数
		 */
		handleAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 直接使用上传组件返回的统一附件ID数组
				this.form.params.attachmentIds = uploadParams.params.attachmentIds;
			}
		},
		/**
		 * 处理表格中附件的更新
		 * @param {Array} attachments - 最新的附件对象数组
		 * @param {Object} row - 当前行数据
		 */
		handleUpdateAttachments(attachments, row) {
			const attachmentIds = attachments.map(item => item.id);
			getBusinessTrip(row.id).then(res => {
				const data = {
					...res.data,
					params: {
						...res.data.params,
						attachmentIds: attachmentIds
					}
				};
				updateBusinessTrip(data).then(() => {
					this.$modal.msgSuccess('附件更新成功');
					this.getList();
				});
			});
		},
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
			const carId = row.id;
			if (!carId) {
				this.$message.error('该行数据有误，id为空!');
				return;
			}
			// 先检查车辆审核状态
			this.getUnProcessedCars(carId).then(_ => {
				// 继续原有的付款申请逻辑
				getBusinessTrip(carId).then(res => {
					// 如果数据不存在，则提示错误
					if (!res.data) {
						this.$message.error('出差申请不存在');
						return;
					}
					// 如果没有报销单，则默认为0
					if (!res.data.tripReimbursementList) {
						this.needMoney = 0;

						// 获取该出差项的报销项
					} else {
						// 如果没有报销项，则默认为0
						if (res.data.tripReimbursementList.length <= 0) {
							this.needMoney = 0;
							// 如果有报销项，则计算报销项的总金额
						} else {
							res.data.tripReimbursementList.forEach(item => {
								this.needMoney += item.itemCost;
							});
						}
					}
					this.tID = row.id;
					this.applyForPaymentDialogVisible = true;
				});
			});
		},
		getUnProcessedCars(carId) {
			return new Promise((resolve, reject) => {
				getCarApplyAuditStatus(carId).then(res => {
					// 如果hasNotPassedAudit为false 代表没有需要审核的车,可以正常走付款申请的流程
					if (!res.data.hasNotPassedAudit) {
						resolve();
						return;
					}
					// 数据出现问题
					if (!res.data.notPassedCarApplyList) {
						this.$message.error(`数据出现问题,未找到车辆的信息`);
						reject();
						return;
					}
					this.$message.warning('存在未审核的车辆，请先等待车辆审核');
					// 存在未通过审核的车辆
					this.notPassedCarList = res.data.notPassedCarApplyList;
					this.notPassedCarDialogVisible = true;
					reject();
				});
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
			// 清除上传组件状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
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
				attachmentList: [],
				isReimburse: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				params: {
					attachmentIds: []
				}
			};
			this.tripReimbursementList = [];
			this.carsList = [];
			this.resetForm('form');
			// 清除上传组件状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
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
				`出差报销_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
