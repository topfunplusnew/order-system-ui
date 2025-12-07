<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="车牌" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入车牌" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="用车时间" prop="startTime">
				<el-date-picker v-model="queryParams.startTime" type="datetime" placeholder="选择用车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="还车时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="datetime" placeholder="选择还车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>

			<el-form-item label="派车人" prop="dispatchPerson">
				<el-input v-model="queryParams.dispatchPerson" placeholder="请输入派车人" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="danger" size="mini" @click="handleAdd">添加车辆派出信息</el-button>
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
						<el-button v-hasPermi="['system:carapply:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="carApplyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="申请时间" align="center" prop="applyDate" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="申请人" align="center" prop="applyUser" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="部门" align="center" prop="department" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="车牌" align="center" prop="carNo" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="油卡号" align="center" prop="oilCard" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="随同乘车人员" align="center" prop="peers" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="用车时间" align="center" prop="startTime" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="还车时间" align="center" prop="endTime" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="用车事由" align="center" prop="applyPurpose" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="出车前里程" align="center" prop="startMile" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="出车前车况" align="center" prop="startCarState" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="回来后里程" align="center" prop="endMile" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="回来后车况" align="center" prop="endCarState" show-overflow-tooltip />
			<el-table-column v-if="columns[13].visible" label="用车里程数" align="center" prop="miles" show-overflow-tooltip />
			<el-table-column v-if="columns[14].visible" label="回程停靠位置" align="center" prop="backStopPlace" show-overflow-tooltip />
			<el-table-column v-if="columns[15].visible" label="行程中违法次数" align="center" prop="violationsCount" show-overflow-tooltip />
			<el-table-column v-if="columns[16].visible" label="违章罚款金额" align="center" prop="fine" show-overflow-tooltip />
			<el-table-column v-if="columns[17].visible" label="行程中是否维修/保养" align="center" prop="isMaintenance" show-overflow-tooltip />
			<el-table-column v-if="columns[18].visible" label="保养金额" align="center" prop="maintenanceMoney" show-overflow-tooltip />
			<el-table-column v-if="columns[19].visible" label="维修金额" align="center" prop="repairMoney" show-overflow-tooltip />
			<el-table-column v-if="columns[20].visible" label="行程中使用加油卡加油次数" align="center" prop="refuelingFrequency" show-overflow-tooltip />
			<el-table-column v-if="columns[21].visible" label="加油金额" align="center" prop="refuelingMoney" show-overflow-tooltip />
			<el-table-column v-if="columns[22].visible" label="现金加油次数" align="center" prop="cashRefuelingFrequency" show-overflow-tooltip />
			<el-table-column v-if="columns[23].visible" label="加油卡余额" align="center" prop="oilCardBalance" show-overflow-tooltip />
			<el-table-column v-if="columns[24].visible" label="加油小票是否交回公司" align="center" prop="isTicketReturned" show-overflow-tooltip />
			<el-table-column v-if="columns[25].visible" label="现金加油金额" align="center" prop="cashRefueling" show-overflow-tooltip />
			<el-table-column v-if="columns[26].visible" label="派车人" align="center" prop="dispatchPerson" show-overflow-tooltip />
			<el-table-column v-if="columns[27].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column v-if="columns[28].visible" label="附件" align="center" prop="attachmentList" show-overflow-tooltip>
				<template slot-scope="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachments'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getCarApply, updateCarApply)" />
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[29].visible" label="审核状态" align="center" prop="auditState" width="300px" show-overflow-tooltip>
				<template slot-scope="scope">
					<el-switch
						v-hasPermi="['system:carapply:audit']"
						v-model="scope.row.auditState"
						:active-value="'审核通过'"
						:inactive-value="null"
						active-text="已审核"
						inactive-text="待审核"
						@change="(value) => handleAuditStateChange(scope.row, value)"
					></el-switch>
					<el-tag v-if="!checkPermi(['system:carapply:audit'])" :type="scope.row.auditState === '审核通过' ? 'success' : scope.row.auditState === '审核不通过' ? 'danger' : 'info'">
						{{ scope.row.auditState || '待审核' }}
					</el-tag>
				</template>
			</el-table-column>

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="280px">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:carapply:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:carapply:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
					<el-button size="mini" type="success" @click="handleSupplement(scope.row)">补充信息</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改车辆使用申请对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px" append-to-body>
			<div>
				<el-form ref="form" :model="form" :rules="rules" label-width="160px">
					<el-row>
						<el-col :span="12">
							<el-form-item label="申请时间" prop="applyDate">
								<el-date-picker v-model="form.applyDate" type="datetime" placeholder="选择申请时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="申请人" prop="applyUser">
								<el-input v-model="form.applyUser" placeholder="请输入申请人" />
							</el-form-item>
							<el-form-item label="部门" prop="department">
								<treeselect v-model="form.department" :options="deptOptions" :normalizer="normalizer" placeholder="请选择部门" />
							</el-form-item>
							<el-form-item label="车牌" prop="carNo">
								<el-row>
									<el-col :span="20">
										<el-input v-model="form.carNo" placeholder="请输入车牌" />
									</el-col>
									<el-col :span="4">
										<SearchOption :limit-info="{}" :get-data="listVehicles" query-label="车牌搜索" :query-name="queryCars" query-info="licensePlate" @update:queryName="updateQueryCars" @commitBack="handleCommitBackCars">
											<template #table-columns>
												<el-table-column label="车牌" prop="licensePlate" />
												<el-table-column label="车辆型号" prop="model" />
												<el-table-column label="购买时间" prop="purchaseDate" />
												<el-table-column label="行驶里程" prop="mileage" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<el-form-item label="随同乘车人员" prop="peers">
								<el-input v-model="form.peers" placeholder="请输入随同乘车人员" />
							</el-form-item>
							<el-form-item label="用车时间" prop="startTime">
								<el-date-picker v-model="form.startTime" type="datetime" placeholder="选择用车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="用车事由" prop="applyPurpose">
								<el-input v-model="form.applyPurpose" placeholder="请输入用车事由" />
							</el-form-item>
							<el-form-item label="出车前里程" prop="startMile">
								<el-input v-model="form.startMile" placeholder="请输入出车前里程" />
							</el-form-item>
						</el-col>
						<el-col :span="12">
							<el-form-item label="出车前车况" prop="startCarState">
								<el-input v-model="form.startCarState" placeholder="外观是否有划痕、磕碰、掉漆、内部是否清洁" />
							</el-form-item>
							<el-form-item label="是否携带油卡" prop="isUseOilCard">
								<el-radio v-model="form.isUseOilCard" :label="1">是</el-radio>
								<el-radio v-model="form.isUseOilCard" :label="0">否</el-radio>
							</el-form-item>
							<el-form-item v-if="form.isUseOilCard === 1" label="携带油卡列表">
								<el-row :gutter="10" class="mb8">
									<el-col :span="1.5">
										<el-button size="mini" type="primary" @click="handleAddOilCard">添加</el-button>
									</el-col>
									<el-col :span="1.5">
										<el-button size="mini" type="danger" @click="handleDeleteOilCard">删除</el-button>
									</el-col>
								</el-row>
								<el-table size="mini" :data="form.oilCardBindings || []" :row-class-name="rowOilCardBindingIndex" @selection-change="handleOilCardBindingSelectionChange">
									<el-table-column type="selection" width="90" align="center" />
									<el-table-column label="序号" align="center" prop="index" />
									<el-table-column label="油卡卡号" align="center">
										<template #default="scope">
											<el-row>
												<el-col :span="20">
													<el-input size="mini" disabled v-model="scope.row.oilCardNo" />
												</el-col>
												<el-col :span="4">
													<SearchOption :limit-info="{}" :get-data="listOilCard" query-label="油卡卡号" :query-name="queryOilCardBinding" query-info="oilCardNo" @commitBack="value => handleCommitBackOilCardBinding(value, scope)" @update:queryName="handleQueryOilCardBinding">
														<template #table-columns>
															<el-table-column label="油卡卡号" prop="oilCardNo" />
															<el-table-column label="油卡类型" prop="oilType" />
															<el-table-column label="当前金额" prop="moneyAmount" />
														</template>
													</SearchOption>
												</el-col>
											</el-row>
										</template>
									</el-table-column>
								</el-table>
							</el-form-item>
							<el-form-item label="派车人" prop="dispatchPerson">
								<el-input v-model="form.dispatchPerson" placeholder="请输入派车人" />
							</el-form-item>
							<el-form-item label="备注" prop="comments">
								<el-input v-model="form.comments" type="textarea" placeholder="请输入备注" />
							</el-form-item>
						</el-col>
					</el-row>
				</el-form>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 补充信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="补充信息" :visible.sync="supplementOpen" width="1200px" append-to-body>
			<el-form ref="supplementForm" :model="supplementForm" :rules="supplementRules" label-width="160px">
				<el-row>
					<el-col :span="8">
						<el-form-item label="还车时间" prop="endTime">
							<el-date-picker v-model="supplementForm.endTime" type="datetime" placeholder="选择还车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<el-form-item label="回程停靠位置" prop="backStopPlace">
							<el-input v-model="supplementForm.backStopPlace" placeholder="请输入回程停靠位置" />
						</el-form-item>
						<el-form-item label="回来后里程" prop="endMile">
							<el-input v-model="supplementForm.endMile" placeholder="请输入回来后里程" />
						</el-form-item>
						<el-form-item label="用车里程数" prop="miles">
							<el-input v-model="supplementForm.miles" placeholder="请输入用车里程数" />
						</el-form-item>
						<el-form-item label="回来后车况" prop="endCarState">
							<el-input v-model="supplementForm.endCarState" type="textarea" placeholder="外观完好，需清洗，左后胎压正常" />
						</el-form-item>
					</el-col>
					<el-col :span="8">
						<el-form-item label="行程中是否维修/保养" prop="isMaintenance">
							<el-radio v-model="supplementForm.isMaintenance" label="是">是</el-radio>
							<el-radio v-model="supplementForm.isMaintenance" label="否">否</el-radio>
						</el-form-item>
						<el-form-item v-if="supplementForm.isMaintenance === '是'" label="保养金额" prop="maintenanceMoney">
							<el-input v-model="supplementForm.maintenanceMoney" placeholder="请输入保养金额" />
						</el-form-item>
						<el-form-item v-if="supplementForm.isMaintenance === '是'" label="维修金额" prop="repairMoney">
							<el-input v-model="supplementForm.repairMoney" placeholder="请输入维修金额" />
						</el-form-item>
						<el-form-item label="行程中违法次数" prop="violationsCount">
							<el-input type="number" v-model="supplementForm.violationsCount" placeholder="请输入行程中违法次数" />
						</el-form-item>
						<el-form-item label="违章罚款金额" prop="fine">
							<el-input type="number" v-model="supplementForm.fine" placeholder="请输入违章罚款金额" />
						</el-form-item>
					</el-col>
					<el-col :span="8">
						<el-form-item label="现金加油次数" prop="cashRefuelingFrequency">
							<el-input type="number" v-model="supplementForm.cashRefuelingFrequency" placeholder="请输入现金加油次数" />
						</el-form-item>
						<el-form-item v-if="supplementForm.cashRefuelingFrequency > 0" label="现金加油金额" prop="cashRefueling">
							<el-input type="number" v-model="supplementForm.cashRefueling" placeholder="请输入现金加油金额" />
						</el-form-item>
						<el-form-item label="附件" prop="attachmentList">
							<UploadFilesButton flag="attachments" @files-updated="handleSupplementAttachmentFilesUpdated" :initial-attachments="supplementForm.attachmentList || []" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitSupplementForm">确 定</el-button>
				<el-button @click="cancelSupplement">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listCarApply, delCarApply, addCarApply, auditCarApply, supplementCarApply } from '@/api/system/carApply';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { mixin_businesstrip_car_apply } from '../../dashboard/mixins/bussiness/businesstrip_car_apply';
import { listData } from '../../../api/system/dict/data';
import SearchOption from '../../../components/SearchOption.vue';
import { listOilCard } from '../../../api/system/oilCard';
import Treeselect from '@riophae/vue-treeselect';
import { listDept } from '@/api/system/dept';
import '@riophae/vue-treeselect/dist/vue-treeselect.css';
import CheckFiles from '../../../components/CheckFiles.vue';
import UploadFilesButton from '../../../components/UploadFilesButton/index.vue';
import { getCarApply, updateCarApply } from '../../../api/system/carApply';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { listVehicles } from '../../../api/system/vehicles';
import { excludeParams } from '../../../api/tool/exclude';
import { parseTime } from 'order-system/src/utils/ruoyi';
import { checkPermi } from '@/utils/permission';

export default {
	name: 'CarApply',
	components: { CheckFiles, UploadFilesButton, Treeselect, SearchOption },
	mixins: [mixin_printHTML, common_dialog, mixin_businesstrip_car_apply],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 车辆使用申请表格数据
			carApplyList: [],
			deptOptions: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				bTripId: null,
				applyDate: null,
				applyUser: null,
				department: null,
				carNo: null,
				isUseOilCard: null,
				peers: null,
				startTime: null,
				endTime: null,
				ApplyPurpose: null,
				startMile: null,
				startCarState: null,
				endMile: null,
				endCarState: null,
				miles: null,
				backStopPlace: null,
				violationsCount: null,
				fine: null,
				isMaintenance: null,
				maintenanceMoney: null,
				refuelingFrequency: null,
				dispatchPerson: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				path: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				applyDate: [
					{
						required: true,
						message: '请选择申请时间',
						trigger: 'blur'
					}
				],
				applyUser: [{ required: true, message: '请输入申请人', trigger: 'blur' }],
				department: [{ required: true, message: '请选择部门', trigger: 'blur' }],
				carNo: [{ required: true, message: '请输入车牌', trigger: 'blur' }],
				peers: [
					{
						required: true,
						message: '请输入随同乘车人员',
						trigger: 'blur'
					}
				],
				startTime: [
					{
						required: true,
						message: '请选择用车时间',
						trigger: 'blur'
					}
				],
				endTime: [
					{
						required: true,
						message: '请选择还车时间',
						trigger: 'blur'
					}
				],
				applyPurpose: [
					{
						required: true,
						message: '请输入用车事由',
						trigger: 'blur'
					}
				],
				startMile: [
					{
						required: true,
						message: '请输入出车前里程',
						trigger: 'blur'
					}
				],
				startCarState: [
					{
						required: true,
						message: '请输入出车前车况',
						trigger: 'blur'
					}
				],
				isUseOilCard: [
					{
						required: true,
						message: '请选择是否携带油卡',
						trigger: 'change'
					}
				],
				dispatchPerson: [{ required: true, message: '请输入派车人', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: '申请时间', visible: true },
				{ key: 1, label: '申请人', visible: true },
				{ key: 2, label: '部门', visible: true },
				{ key: 3, label: '车牌', visible: true },
				{ key: 4, label: '油卡号', visible: true },
				{ key: 5, label: '随同乘车人员', visible: true },
				{ key: 6, label: '用车时间', visible: true },
				{ key: 7, label: '还车时间', visible: true },
				{ key: 8, label: '用车事由', visible: true },
				{ key: 9, label: '出车前里程', visible: true },
				{ key: 10, label: '出车前车况', visible: true },
				{ key: 11, label: '回来后里程', visible: true },
				{ key: 12, label: '回来后车况', visible: true },
				{ key: 13, label: '用车里程数', visible: true },
				{ key: 14, label: '回程停靠位置', visible: true },
				{ key: 15, label: '行程中违法次数', visible: true },
				{ key: 16, label: '违章罚款金额', visible: true },
				{ key: 17, label: '行程中是否维修/保养', visible: true },
				{ key: 18, label: '保养金额', visible: true },
				{ key: 19, label: '维修金额', visible: true },
				{ key: 20, label: '行程中使用加油卡加油次数', visible: true },
				{ key: 21, label: '加油金额', visible: true },
				{ key: 22, label: '现金加油次数', visible: true },
				{ key: 23, label: '加油卡余额', visible: true },
				{ key: 24, label: '加油小票是否交回公司', visible: true },
				{ key: 25, label: '现金加油金额', visible: true },
				{ key: 26, label: '派车人', visible: true },
				{ key: 27, label: '备注', visible: true },
				{ key: 28, label: '附件路径', visible: true },
				{ key: 29, label: '审核状态', visible: true }
			],

			queryItemsOilCard: {
				queryList: [
					{
						id: 1,
						label: '加油卡类别',
						prop: 'oilType',
						type: 'select',
						value: '',
						options: [
							{
								label: '主卡',
								value: '主卡'
							},
							{
								label: '副卡',
								value: '副卡'
							}
						]
					}
				]
			},
			oilCardConsumeList: [],
			checkedOildetail: [],
			// 补充信息相关
			supplementOpen: false,
			supplementForm: {},
			// 油卡绑定相关
			checkedOilCardBindings: [],
			queryOilCardBinding: '',
			// 补充信息校验规则
			supplementRules: {
				endTime: [{ required: true, message: '请选择还车时间', trigger: 'change' }],
				backStopPlace: [{ required: true, message: '请输入回程停靠位置', trigger: 'blur' }],
				endMile: [{ required: true, message: '请输入回来后里程', trigger: 'blur' }],
				miles: [{ required: true, message: '请输入用车里程数', trigger: 'blur' }],
				endCarState: [{ required: true, message: '请输入回来后车况', trigger: 'blur' }],
				isMaintenance: [{ required: true, message: '请选择行程中是否维修/保养', trigger: 'change' }],
				maintenanceMoney: [
					{
						validator: (rule, value, callback) => {
							if (this.supplementForm.isMaintenance === '是' && !value) {
								callback(new Error('请输入保养金额'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				repairMoney: [
					{
						validator: (rule, value, callback) => {
							if (this.supplementForm.isMaintenance === '是' && !value) {
								callback(new Error('请输入维修金额'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				violationsCount: [{ required: true, message: '请输入行程中违法次数', trigger: 'blur' }],
				fine: [{ required: true, message: '请输入违章罚款金额', trigger: 'blur' }],
				cashRefuelingFrequency: [{ required: true, message: '请输入现金加油次数', trigger: 'blur' }],
				cashRefueling: [
					{
						validator: (rule, value, callback) => {
							if (this.supplementForm.cashRefuelingFrequency > 0 && !value) {
								callback(new Error('请输入现金加油金额'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			}
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('carapply-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		listDept().then(response => {
			this.deptOptions = this.handleTree(response.data, 'deptId');
		});
		if (localStorage.getItem('carapply-columns') === 'null' || !localStorage.getItem('carapply-columns')) {
			// 设置localStorage
			localStorage.setItem('carapply-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('carapply-columns'));
		}
	},
	methods: {
		parseTime,
		listVehicles,
		checkPermi,
		/**
		 * 更新表单中的附件列表
		 * @param {Array} newAttachmentList - 最新的附件列表
		 */
		handleAttachmentUpdate(newAttachmentList) {
			this.form.attachmentList = newAttachmentList;
		},
		/**
		 * 处理表格中附件的更新
		 * @param {Array} attachments - 最新的附件对象数组
		 * @param {Object} row - 当前行数据
		 */
		handleUpdateAttachments(attachments, row) {
			const attachmentIds = attachments.map(item => item.id);
			getCarApply(row.id).then(res => {
				const data = {
					...res.data,
					params: {
						...res.data.params,
						attachmentIds: attachmentIds
					}
				};
				updateCarApply(data).then(() => {
					this.$modal.msgSuccess('附件更新成功');
					this.getList();
				});
			});
		},
		listOilCard,
		listData,
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
		rowOilCardIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		handleOilCardSelectionChange(selection) {
			this.checkedOildetail = selection.map(item => item.index);
		},
		handleAddOildetail() {
			const newRow = {
				oilCardNo: '', // 加油卡卡号
				useDate: '', // 使用时间
				carNo: '', // 车辆车牌号
				startCardSurplus: '', // 期初余额
				isRecharge: '2', // 是否充值，默认否
				rechargeMoney: '', // 充值金额
				refuelingNumber: '', // 加油量
				unitPrice: '', // 单价
				refuelingMoney: '', // 加油金额
				attachmentOiladd: '', // 附件路径
				comments: '' // 备注
			};
			this.oilCardConsumeList.push(newRow);
		},
		handleDeleteOildetail() {
			if (this.checkedOildetail.length === 0) {
				this.$message.error('请先选择要删除的油卡消费数据');
			} else {
				const oildetails = this.oilCardConsumeList;
				const checkedOildetails = this.checkedOildetail;
				this.oilCardConsumeList = oildetails.filter(function (item) {
					return checkedOildetails.indexOf(item.index) === -1;
				});
			}
		},
		handleUpload(val, scope) {
			scope.row.attachmentOiladd = val;
		},

		/** 查询车辆使用申请列表 */
		getList() {
			this.loading = true;
			listCarApply(this.queryParams).then(response => {
				this.carApplyList = response.rows;
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
		// 表单重置
		reset() {
			this.form = {
				id: null,
				bTripId: null,
				applyDate: null,
				applyUser: null,
				department: null,
				carNo: null,
				isUseOilCard: 0,
				peers: null,
				startTime: null,
				applyPurpose: null,
				startMile: null,
				startCarState: null,
				dispatchPerson: null,
				comments: null,
				oilCardBindings: [],
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('form');
			// 清除上传组件状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
		},
		// 补充信息表单重置
		resetSupplement() {
			this.supplementForm = {
				id: null,
				endTime: null,
				backStopPlace: null,
				endMile: null,
				miles: null,
				endCarState: null,
				isMaintenance: '否',
				maintenanceMoney: null,
				repairMoney: null,
				violationsCount: '0',
				fine: '0',
				cashRefuelingFrequency: 0,
				cashRefueling: null,
				attachmentList: [],
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('supplementForm');
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
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加车辆使用申请';
			this.form.applyUser = this.trueName;
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getCarApply(id).then(response => {
				this.form = {
					...response.data,
					oilCardBindings: response.data.oilCardBindings || [],
					params: {
						...response.data.params,
						attachmentIds: response.data.attachmentList ? response.data.attachmentList.map(item => item.id) : []
					}
				};
				// 确保 attachmentList 是一个数组
				this.form.attachmentList = response.data.attachmentList || [];
				this.open = true;
				this.title = '修改车辆使用申请';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {

					// 处理油卡绑定：如果未携带油卡，清空油卡绑定列表
					if (this.form.isUseOilCard === 0) {
						this.form.oilCardBindings = [];
					}

					// 统一的附件处理：使用 params.attachmentIds 数组
					const data = { ...this.form };

					// 确保 params 对象存在并包含附件ID
					if (!data.params) {
						data.params = {};
					}

					// 如果通过上传组件已设置了 attachmentIds，则保持；否则从 attachmentList 获取
					if (!data.params.attachmentIds && this.form.attachmentList) {
						data.params.attachmentIds = this.form.attachmentList.map(item => item.id);
					}

					if (this.form.id != null) {
						updateCarApply(excludeParams(data, this.$exclude)).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addCarApply(excludeParams(data, this.$exclude)).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除车辆使用申请编号为"' + ids + '"的数据项？')
				.then(function () {
					return delCarApply(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/carApply/export',
				{
					...this.queryParams
				},
				`车辆申请_${new Date().getTime()}.xlsx`
			);
		},
		/** 审核状态开关变化处理 */
		handleAuditStateChange(row, value) {
			const oldValue = row.auditState;
			const auditState = value === '审核通过' ? '审核通过' : null;
			const message = auditState === '审核通过' ? '审核通过成功' : '取消审核成功';
			
			auditCarApply(row.id, auditState)
				.then(() => {
					this.$modal.msgSuccess(message);
					this.getList();
				})
				.catch(() => {
					// 如果失败，恢复原状态
					this.$set(row, 'auditState', oldValue);
					this.$modal.msgError(auditState === '审核通过' ? '审核通过失败' : '取消审核失败');
				});
		},
		// 统一附件处理方法
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
		// 处理表格行附件更新
		handleUpdateFilePath(attachments, row, onGet, onUpdate) {
			onGet(row.id).then(res => {
				const data = {
					...res.data,
					params: {
						...res.data.params,
						attachmentIds: attachments.map(item => item.id)
					}
				};
				onUpdate(data).then(() => {
					this.getList();
				});
			});
		},
		// 补充信息相关方法
		handleSupplement(row) {
			this.resetSupplement();
			const id = row.id || this.ids;
			getCarApply(id).then(response => {
				this.supplementForm = {
					id: response.data.id,
					endTime: response.data.endTime,
					backStopPlace: response.data.backStopPlace,
					endMile: response.data.endMile,
					miles: response.data.miles,
					endCarState: response.data.endCarState,
					isMaintenance: response.data.isMaintenance || '否',
					maintenanceMoney: response.data.maintenanceMoney,
					repairMoney: response.data.repairMoney,
					violationsCount: response.data.violationsCount || '0',
					fine: response.data.fine || '0',
					cashRefuelingFrequency: response.data.cashRefuelingFrequency || 0,
					cashRefueling: response.data.cashRefueling,
					attachmentList: response.data.attachmentList || [],
					params: {
						...response.data.params,
						attachmentIds: response.data.attachmentList ? response.data.attachmentList.map(item => item.id) : []
					}
				};
				this.supplementOpen = true;
			});
		},
		cancelSupplement() {
			this.supplementOpen = false;
			this.resetSupplement();
		},
		submitSupplementForm() {
			this.$refs['supplementForm'].validate(valid => {
				if (valid) {
					const data = { ...this.supplementForm };
					if (!data.params) {
						data.params = {};
					}
					if (!data.params.attachmentIds && this.supplementForm.attachmentList) {
						data.params.attachmentIds = this.supplementForm.attachmentList.map(item => item.id);
					}
					supplementCarApply(excludeParams(data, this.$exclude)).then(() => {
						this.$modal.msgSuccess('补充信息提交成功');
						this.supplementOpen = false;
						this.getList();
					});
				}
			});
		},
		handleSupplementAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				if (!this.supplementForm.params) {
					this.supplementForm.params = {};
				}
				this.supplementForm.params.attachmentIds = uploadParams.params.attachmentIds;
			}
		},
		// 油卡绑定相关方法
		handleAddOilCard() {
			if (!this.form.oilCardBindings) {
				this.form.oilCardBindings = [];
			}
			this.form.oilCardBindings.push({
				oilCardId: null,
				oilCardNo: ''
			});
		},
		handleDeleteOilCard() {
			if (this.checkedOilCardBindings.length === 0) {
				this.$message.error('请先选择要删除的油卡');
			} else {
				const bindings = this.form.oilCardBindings || [];
				const checkedBindings = this.checkedOilCardBindings;
				this.form.oilCardBindings = bindings.filter((item, index) => {
					return checkedBindings.indexOf(index + 1) === -1;
				});
			}
		},
		rowOilCardBindingIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		handleOilCardBindingSelectionChange(selection) {
			this.checkedOilCardBindings = selection.map(item => item.index);
		},
		handleCommitBackOilCardBinding(value, scope) {
			scope.row.oilCardId = value.id;
			scope.row.oilCardNo = value.oilCardNo;
		},
		handleQueryOilCardBinding(val) {
			this.queryOilCardBinding = val;
		}
	}
};
</script>
