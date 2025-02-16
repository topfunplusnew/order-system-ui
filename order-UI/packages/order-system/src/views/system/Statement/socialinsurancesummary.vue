<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini" style="width: 100px"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini" style="width: 100px"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">社保和公积金缴纳登记台账</el-row>
		<el-row :gutter="10" class="mb8">
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
			<el-table-column label="id" align="center" prop="id" />
			<el-table-column v-if="columns[2].visible" label="部门" align="center" prop="depName" />
			<el-table-column v-if="columns[3].visible" label="姓名" align="center" prop="employeeName" />
			<el-table-column v-if="columns[0].visible" label="社保缴纳基数" align="center" prop="basicSocialInsurance" width="110" />
			<el-table-column v-if="columns[1].visible" label="公积金基数" align="center" prop="basicHousingFund" width="110" />
			<el-table-column v-if="columns[5].visible" label="缴费时间" align="center" prop="insuranceDate" width="120" />
			<el-table-column label="社保增减员情况" align="center">
				<el-table-column v-if="columns[6].visible" label="是否增员" align="center" prop="isRecruiting" />
				<el-table-column v-if="columns[7].visible" label="是否减员" align="center" prop="isDepletion" />
			</el-table-column>
			<el-table-column label="基本医疗保险" align="center">
				<el-table-column v-if="columns[8].visible" label="个人缴纳" align="center" prop="healthySecuritySelf" />
				<el-table-column v-if="columns[9].visible" label="公司缴纳" align="center" prop="healthySecurityCompany" />
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="工伤保险" align="center" prop="injuryInsurance" />

			<el-table-column label="失业保险" align="center">
				<el-table-column v-if="columns[11].visible" label="个人缴纳" align="center" prop="unemploymentSecuritySelf" />
				<el-table-column v-if="columns[12].visible" label="公司缴纳" align="center" prop="unemploymentSecurityCompany" />
			</el-table-column>
			<el-table-column label="养老保险" align="center">
				<el-table-column v-if="columns[13].visible" label="个人缴纳" align="center" prop="retirementSecuritySelf" />
				<el-table-column v-if="columns[14].visible" label="公司缴纳" align="center" prop="retirementSecurityCompany" />
			</el-table-column>
			<el-table-column label="大额医保" align="center">
				<el-table-column v-if="columns[15].visible" label="个人缴纳" align="center" prop="largeMedicalSecuritySelf" />
				<el-table-column v-if="columns[16].visible" label="公司缴纳" align="center" prop="largeMedicalSecurityCompany" />
			</el-table-column>
			<el-table-column label="公积金缴纳" align="center">
				<el-table-column v-if="columns[17].visible" label="个人缴纳" align="center" prop="housingFundSelf" />
				<el-table-column v-if="columns[18].visible" label="公司缴纳" align="center" prop="housingFundCompany" />
			</el-table-column>
			<el-table-column v-if="columns[19].visible" label="个人缴费总额" align="center" prop="sumSelf" width="120" />
			<el-table-column v-if="columns[20].visible" label="公司缴费总额" align="center" prop="sumCompany" width="120" />
			<el-table-column label="备注" align="center" prop="comments" />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :close-on-click-modal="false" :show-close="false" title="请选择导出时间段" :visible.sync="dialogVisible" width="30%">
			<el-form ref="queryForm" :model="queryParams" size="mini" label-width="68px">
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
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getSocialInsuranceSummary } from '@/api/system/statement';
import { parseTime } from '../../../utils/ruoyi';

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
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
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
			dialogVisible: false
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
		printJSON() {
			const exclude = ['userId', 'createBy', 'createTime', 'updateBy', 'updateTime', 'addtime', 'delFlag', 'userName', 'remark'];
			this.$print({
				maxWidth: 3000,
				printable: this.socialInsuranceList,
				properties: Object.keys(this.socialInsuranceList[0]).filter(item => !exclude.includes(item)),
				type: 'json'
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
