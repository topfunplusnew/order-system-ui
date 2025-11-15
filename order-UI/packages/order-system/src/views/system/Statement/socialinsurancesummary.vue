<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="部门" prop="depName">
				<el-input v-model="queryParams.depName" placeholder="请输入部门" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="姓名" prop="employeeName">
				<el-input v-model="queryParams.employeeName" placeholder="请输入姓名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="人员编号" prop="employeeID">
				<el-input v-model="queryParams.employeeID" placeholder="请输入人员编号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 20px 30px">社保和公积金缴纳登记台账</el-row>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="danger" size="mini" @click="addSocial">新增社保基金信息</el-button>
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
						<el-button v-hasPermi="['system:socialinsurance:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="socialInsuranceList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
		>
			<el-table-column label="id" align="center" prop="id" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="部门" align="center" prop="depName" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="姓名" align="center" prop="employeeName" show-overflow-tooltip />
			<el-table-column v-if="columns[0].visible" label="社保缴纳基数" align="center" prop="basicSocialInsurance" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="公积金基数" align="center" prop="basicHousingFund" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="缴费时间" align="center" prop="insuranceDate" width="120" show-overflow-tooltip />
			<el-table-column label="社保增减员情况" align="center" show-overflow-tooltip>
				<el-table-column v-if="columns[6].visible" label="是否增员" align="center" prop="isRecruiting" show-overflow-tooltip />
				<el-table-column v-if="columns[7].visible" label="是否减员" align="center" prop="isDepletion" show-overflow-tooltip />
			</el-table-column>
			<el-table-column label="基本医疗保险" align="center" show-overflow-tooltip>
				<el-table-column v-if="columns[8].visible" label="个人缴纳" align="center" prop="healthySecuritySelf" show-overflow-tooltip />
				<el-table-column v-if="columns[9].visible" label="公司缴纳" align="center" prop="healthySecurityCompany" show-overflow-tooltip />
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="工伤保险" align="center" prop="injuryInsurance" show-overflow-tooltip />

			<el-table-column label="失业保险" align="center" show-overflow-tooltip>
				<el-table-column v-if="columns[11].visible" label="个人缴纳" align="center" prop="unemploymentSecuritySelf" show-overflow-tooltip />
				<el-table-column v-if="columns[12].visible" label="公司缴纳" align="center" prop="unemploymentSecurityCompany" show-overflow-tooltip />
			</el-table-column>
			<el-table-column label="养老保险" align="center" show-overflow-tooltip>
				<el-table-column v-if="columns[13].visible" label="个人缴纳" align="center" prop="retirementSecuritySelf" show-overflow-tooltip />
				<el-table-column v-if="columns[14].visible" label="公司缴纳" align="center" prop="retirementSecurityCompany" show-overflow-tooltip />
			</el-table-column>
			<el-table-column label="大额医保" align="center" show-overflow-tooltip>
				<el-table-column v-if="columns[15].visible" label="个人缴纳" align="center" prop="largeMedicalSecuritySelf" show-overflow-tooltip />
				<el-table-column v-if="columns[16].visible" label="公司缴纳" align="center" prop="largeMedicalSecurityCompany" show-overflow-tooltip />
			</el-table-column>
			<el-table-column label="公积金缴纳" align="center" show-overflow-tooltip>
				<el-table-column v-if="columns[17].visible" label="个人缴纳" align="center" prop="housingFundSelf" show-overflow-tooltip />
				<el-table-column v-if="columns[18].visible" label="公司缴纳" align="center" prop="housingFundCompany" show-overflow-tooltip />
			</el-table-column>
			<el-table-column v-if="columns[19].visible" label="个人缴费总额" align="center" prop="sumSelf" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[20].visible" label="公司缴费总额" align="center" prop="sumCompany" width="120" show-overflow-tooltip />
			<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="请选择导出时间段"
			:visible.sync="dialogVisible"
			width="30%"
		>
			<el-form ref="queryForm" :model="queryParams" size="mini" label-width="200px">
				<el-form-item label="开始时间" prop="beginTime">
					<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束时间" prop="endTime">
					<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导 出</el-button>
			</span>
		</el-dialog>

		<!--    2025-2-24 新增 增删改查-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="社保基金" :visible.sync="open" append-to-body width="80%">
			<el-row>
				<el-col :span="1.5">
					<el-button type="primary" size="mini" @click="addSocialInsure">添加人员社保基金信息</el-button>
				</el-col>
			</el-row>
			<br />
			<el-table :data="socialInsuranceItemsList" style="width: 100%" size="mini">
				<el-table-column label="操作">
					<template slot-scope="scope">
						<el-button size="mini" type="danger" @click="handleDeleteItem(scope.$index, scope.row)">删除</el-button>
					</template>
				</el-table-column>
				<!--        本月缴纳基数-->
				<el-table-column :label="'本月缴纳基数:' + basicSocialInsurance">
					<el-table-column prop="employeeName" label="姓名" width="120"></el-table-column>
					<el-table-column label="社保增减人员情况" prop="name" width="120">
						<el-table-column prop="isRecruiting" label="是否增员" width="120"></el-table-column>
					</el-table-column>
					<el-table-column label="基本医疗保险">
						<el-table-column prop="healthySecurityCompany" label="公司缴纳" width="120"></el-table-column>
						<el-table-column prop="healthySecuritySelf" label="个人缴纳" width="120"></el-table-column>
					</el-table-column>
				</el-table-column>
				<!--            工伤保险-->
				<el-table-column label="工伤保险" prop="injuryInsurance"></el-table-column>
				<!--        本月公积金缴纳基数-->
				<el-table-column :label="'本月公积金缴纳基数:' + basicHousingFund">
					<!--          缴纳社保和停止社保时间-->
					<el-table-column label="失业保险" prop="name" width="120">
						<el-table-column prop="unemploymentSecurityCompany" label="公司缴纳" width="120"></el-table-column>
						<el-table-column prop="unemploymentSecuritySelf" label="个人缴纳" width="120"></el-table-column>
					</el-table-column>
					<el-table-column label="基本养老保险">
						<el-table-column prop="retirementSecurityCompany" label="公司缴纳" width="120"></el-table-column>
						<el-table-column prop="retirementSecuritySelf" label="个人缴纳" width="120"></el-table-column>
					</el-table-column>
					<el-table-column label="大额医疗保险">
						<el-table-column prop="largeMedicalSecurityCompany" label="公司缴纳" width="120"></el-table-column>
						<el-table-column prop="largeMedicalSecuritySelf" label="个人缴纳" width="120"></el-table-column>
					</el-table-column>
					<el-table-column label="住房公积金">
						<el-table-column prop="housingFundCompany" label="公司缴纳" width="120"></el-table-column>
						<el-table-column prop="housingFundSelf" label="个人缴纳" width="120"></el-table-column>
					</el-table-column>
					<el-table-column label="个人缴纳总额" prop="sumSelf"></el-table-column>
					<el-table-column label="公司缴纳总额" prop="sumCompany"></el-table-column>
				</el-table-column>
			</el-table>

			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    添加个体信息-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="社保基金人员个体信息"
			:visible.sync="addSocialDialogVisible"
			width="85%"
			append-to-body
		>
			<el-row>
				<el-form ref="form" :model="form" :rules="rules" label-width="140px">
					<el-col :span="8">
						<el-form-item label="本月社保缴纳基数" prop="basicSocialInsurance">
							<el-input v-model="form.basicSocialInsurance" placeholder="请输入社保缴纳基数" />
						</el-form-item>
						<el-form-item label="本月公积金基数" prop="basicHousingFund">
							<el-input v-model="form.basicHousingFund" placeholder="请输入公积金基数" />
						</el-form-item>
						<el-form-item label="部门" prop="depName">
							<el-input v-model="form.depName" placeholder="请输入部门" />
						</el-form-item>
						<el-form-item label="姓名" prop="employeeName">
							<el-input v-model="form.employeeName" placeholder="请输入姓名" />
						</el-form-item>
						<el-form-item label="人员编号" prop="employeeID">
							<el-input v-model="form.employeeID" placeholder="请输入人员编号" />
						</el-form-item>
						<el-form-item label="缴费时间" prop="insuranceDate">
							<el-date-picker v-model="form.insuranceDate" type="datetime" placeholder="选择缴费时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"></el-date-picker>
						</el-form-item>
					</el-col>
					<el-col :span="8">
						<el-form-item label="是否增员" prop="isRecruiting">
							<el-radio v-model="form.isRecruiting" label="是">是</el-radio>
							<el-radio v-model="form.isRecruiting" label="否">否</el-radio>
						</el-form-item>
						<el-form-item label="是否减员" prop="isDepletion">
							<el-radio v-model="form.isDepletion" label="是">是</el-radio>
							<el-radio v-model="form.isDepletion" label="否">否</el-radio>
						</el-form-item>
						<el-form-item label="基本医疗保险" prop="healthySecuritySelf">
							<el-col :span="11">
								<el-input v-model="form.healthySecuritySelf" placeholder="个人缴纳金额" style="width: 100%" />
							</el-col>
							<el-col :span="2" class="line" style="text-align: center; font-weight: bolder">-</el-col>
							<el-col :span="11">
								<el-input v-model="form.healthySecurityCompany" placeholder="公司缴纳金额" style="width: 100%" />
							</el-col>
						</el-form-item>
						<el-form-item label="工伤保险" prop="injuryInsurance">
							<el-input v-model="form.injuryInsurance" placeholder="请输入工伤保险缴纳金额" />
						</el-form-item>
						<el-form-item label="失业保险" prop="unemploymentSecuritySelf">
							<el-col :span="11">
								<el-input v-model="form.unemploymentSecuritySelf" placeholder="个人缴纳金额" />
							</el-col>
							<el-col :span="2" class="line" style="text-align: center; font-weight: bolder">-</el-col>
							<el-col :span="11">
								<el-input v-model="form.unemploymentSecurityCompany" placeholder="公司缴纳金额" />
							</el-col>
						</el-form-item>
						<el-form-item label="养老保险" prop="retirementSecuritySelf">
							<el-row align="middle">
								<!-- 个人缴纳 -->
								<el-col :span="11">
									<el-input v-model="form.retirementSecuritySelf" placeholder="个人缴纳金额" />
								</el-col>
								<!-- 横线 -->
								<el-col :span="2" class="line" style="text-align: center; font-weight: bolder">-</el-col>
								<!-- 公司缴纳 -->
								<el-col :span="11">
									<el-input v-model="form.retirementSecurityCompany" placeholder="公司缴纳金额" />
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>
					<el-col :span="8">
						<el-form-item label="大额医保" prop="largeMedicalSecuritySelf">
							<el-col :span="11">
								<el-input v-model="form.largeMedicalSecuritySelf" placeholder="个人缴纳金额" />
							</el-col>
							<el-col :span="2" class="line" style="text-align: center; font-weight: bolder">-</el-col>
							<el-col :span="11">
								<el-input v-model="form.largeMedicalSecurityCompany" placeholder="公司缴纳" />
							</el-col>
						</el-form-item>
						<el-form-item label="公积金" prop="housingFundSelf">
							<el-col :span="11">
								<el-input v-model="form.housingFundSelf" placeholder="个人缴纳金额" />
							</el-col>
							<el-col :span="2" class="line" style="text-align: center; font-weight: bolder">-</el-col>
							<el-col :span="11">
								<el-input v-model="form.housingFundCompany" placeholder="公司缴纳金额" />
							</el-col>
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
						</el-form-item>
					</el-col>
				</el-form>
			</el-row>
			<span slot="footer" class="dialog-footer">
				<el-button @click="addSocialDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="addSocialInsureItemInfo">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getSocialInsuranceSummary } from '@/api/system/statement';
import { parseTime } from '../../../utils/ruoyi';
import { excludeParams } from '@/api/tool/exclude';
import { batchAddSocialInsurance, updateSocialInsurance } from '@/api/system/socialInsurance';

export default {
	name: 'Socialinsurancesummary',
	mixins: [mixin_printHTML],
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
			// 社保基金表格数据
			socialInsuranceList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				endTime: null,
				startTime: null,
				pageNum: 1,
				pageSize: 50,
				basicSocialInsurance: null,
				basicHousingFund: null,
				depName: null,
				employeeName: null,
				employeeID: null,
				insuranceDate: null,
				isRecruiting: null,
				isDepletion: null,
				healthySecuritySelf: null,
				healthySecurityCompany: null,
				injuryInsurance: null,
				unemploymentSecuritySelf: null,
				unemploymentSecurityCompany: null,
				retirementSecuritySelf: null,
				retirementSecurityCompany: null,
				largeMedicalSecuritySelf: null,
				largeMedicalSecurityCompany: null,
				housingFundSelf: null,
				housingFundCompany: null,
				sumSelf: null,
				sumCompany: null,
				comments: null
			},
			columns: [
				{ key: 0, label: `社保缴纳基数`, visible: true },
				{ key: 1, label: `公积金基数`, visible: true },
				{ key: 2, label: `部门`, visible: true },
				{ key: 3, label: `姓名`, visible: true },
				{ key: 4, label: `人员编号`, visible: true },
				{ key: 5, label: `缴费时间`, visible: true },
				{ key: 6, label: `是否增员`, visible: true },
				{ key: 7, label: `是否减员`, visible: true },
				{ key: 8, label: `基本医疗保险-个人`, visible: true },
				{ key: 9, label: `基本医疗保险-公司`, visible: true },
				{ key: 10, label: `工伤保险`, visible: true },
				{ key: 11, label: `失业保险-个人`, visible: true },
				{ key: 12, label: `失业保险-公司`, visible: true },
				{ key: 13, label: `养老保险-个人`, visible: true },
				{ key: 14, label: `养老保险-公司`, visible: true },
				{ key: 15, label: `大额医保-个人`, visible: true },
				{ key: 16, label: `大额医保-公司`, visible: true },
				{ key: 17, label: `公积金-个人`, visible: true },
				{ key: 18, label: `公积金-公司`, visible: true },
				{ key: 19, label: `个人缴费总额`, visible: true },
				{ key: 20, label: `公司缴费总额`, visible: true }
			],
			dialogVisible: false,

			// 2025-2-25 添加增删改查相关代码
			socialInsuranceItemsList: [],
			// 社保缴纳基数
			basicSocialInsurance: '0',
			// 公积金基数
			basicHousingFund: '0',
			form: {},
			addSocialDialogVisible: false,

			rules: {
				basicSocialInsurance: [
					{
						required: true,
						message: '基本医疗保险不能为空',
						trigger: 'blur'
					}
				],

				basicHousingFund: [
					{
						required: true,
						message: '公积金基数不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],

				depName: [{ required: true, message: '部门不能为空', trigger: 'blur' }],

				employeeName: [{ required: true, message: '姓名不能为空', trigger: 'blur' }],

				employeeID: [
					{
						required: true,
						message: '人员编号不能为空',
						trigger: 'blur'
					}
				],

				insuranceDate: [
					{
						required: true,
						message: '缴费时间不能为空',
						trigger: 'blur'
					}
				],

				isRecruiting: [
					{
						required: true,
						message: '是否增员不能为空',
						trigger: 'change'
					}
				],

				isDepletion: [
					{
						required: true,
						message: '是否减员不能为空',
						trigger: 'change'
					}
				],

				healthySecuritySelf: [
					{
						required: true,
						message: '基本医疗保险不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],

				healthySecurityCompany: [
					{
						required: true,
						message: '公司基本医疗保险不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				injuryInsurance: [
					{
						required: true,
						message: '工伤保险不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				unemploymentSecuritySelf: [
					{
						required: true,
						message: '失业保险不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],

				unemploymentSecurityCompany: [
					{
						required: true,
						message: '公司失业保险不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				retirementSecuritySelf: [
					{
						required: true,
						message: '养老保险不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				retirementSecurityCompany: [
					{
						required: true,
						message: '养老保险-公司不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				largeMedicalSecuritySelf: [
					{
						required: true,
						message: '大额医保不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				largeMedicalSecurityCompany: [
					{
						required: true,
						message: '大额医保-公司不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				housingFundSelf: [
					{
						required: true,
						message: '公积金不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				housingFundCompany: [
					{
						required: true,
						message: '公积金-公司不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				sumSelf: [
					{
						required: true,
						message: '个人缴费总额不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				],
				sumCompany: [
					{
						required: true,
						message: '公司缴费总额不能为空',
						trigger: 'blur'
					},
					{
						// 必须是浮点数
						pattern: /^[+-]?\d+(\.\d+)?$/,
						message: '请输入正确的数字'
					}
				]
			}
		};
	},
	computed: {},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('socialinsurance-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('socialinsurance-columns') === 'null' || !localStorage.getItem('socialinsurance-columns')) {
			// 设置localStorage
			localStorage.setItem('socialinsurance-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('socialinsurance-columns'));
		}
	},
	methods: {
		// 2025-2-25 添加增删改查相关代码
		addSocial() {
			this.open = true;
			this.reset();
		},
		handleDeleteItem(index) {
			this.socialInsuranceItemsList.splice(index, 1);
			this.$message.success('删除成功');
		},
		addSocialInsure() {
			this.addSocialDialogVisible = true;
		},
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		reset() {
			this.form = {
				id: null,
				basicSocialInsurance: null,
				basicHousingFund: null,
				depName: null,
				employeeName: null,
				employeeID: null,
				insuranceDate: null,
				// 默认为是
				isRecruiting: '是',
				// 默认是否
				isDepletion: '否',
				healthySecuritySelf: null,
				healthySecurityCompany: null,
				injuryInsurance: null,
				unemploymentSecuritySelf: null,
				unemploymentSecurityCompany: null,
				retirementSecuritySelf: null,
				retirementSecurityCompany: null,
				largeMedicalSecuritySelf: null,
				largeMedicalSecurityCompany: null,
				housingFundSelf: null,
				housingFundCompany: null,
				sumSelf: null,
				sumCompany: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('form');
		},
		async submitForm() {
			if (this.form.id != null) {
				this.form = excludeParams(this.form, this.$exclude);
				updateSocialInsurance(this.form).then(() => {
					this.$modal.msgSuccess('修改成功');
					this.open = false;
					this.getList();
				});
				// 添加
			} else {
				// 调用后端批量添加社保金接口
				batchAddSocialInsurance(this.socialInsuranceItemsList).then(() => {
					this.$modal.msgSuccess('添加成功');
					this.open = false;
					this.socialInsuranceItemsList = [];
					this.getList();
				});
			}
		},
		cancel() {
			this.open = false;
			this.socialInsuranceItemsList = [];
			this.reset();
		},
		sumSummary(form, type) {
			let sum = 0;
			for (const prop in form) {
				if (prop.includes(type)) {
					sum += Number(form[prop]);
				}
			}
			return Number(sum).toFixed(2);
		},
		addSocialInsureItemInfo() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 修改
					if (this.form.id !== null && this.form.id !== undefined && this.form.id !== '') {
						this.form.sumSelf = this.sumSummary(this.form, 'Self');
						this.form.sumCompany = this.sumSummary(this.form, 'Company');
						this.form = excludeParams(this.form, this.$exclude);
						updateSocialInsurance(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.addSocialDialogVisible = false;
							this.getList();
						});
						// 增加逻辑 批量发请求
					} else {
						const { basicSocialInsurance, basicHousingFund } = this.form;
						// 添加时 自动赋值基金数
						this.basicHousingFund = basicHousingFund;
						this.basicSocialInsurance = basicSocialInsurance;
						// 计算合并列的综合
						this.form.sumSelf = this.sumSummary(this.form, 'Self');
						this.form.sumCompany = this.sumSummary(this.form, 'Company');
						const item = JSON.parse(JSON.stringify(this.form));
						// 往列表中推入一个个体信息
						this.socialInsuranceItemsList.push(item);
						// 不再清除填写 让用户可以使用上次的信息
						this.reset();
						this.addSocialDialogVisible = false;
					}
				}
			});
		},
		/** 查询社保基金列表 */
		getList() {
			this.loading = true;
			getSocialInsuranceSummary(this.queryParams).then(response => {
				this.socialInsuranceList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		refresh() {
			this.reset();
			this.getList();
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		handleSubmitTime() {
			this.download(
				'statistics/export/SocialInsuranceSummary',
				{
					beginTime: this.queryParams.beginTime,
					endTime: this.queryParams.endTime
				},
				`社保和公积金缴纳登记_${parseTime(new Date().getTime())}.xlsx`
			);
			this.dialogVisible = false;
		},
		/** 导出按钮操作 */
		handleExport() {
			this.dialogVisible = true;
		}
	}
};
</script>
