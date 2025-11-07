<template>
	<div class="app-container">
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:auditflow:edit']" type="danger" size="mini" @click="handleAdd">更改审核流程</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
		</el-row>
		<el-row style="margin-top: 60px">
			<el-steps :active="displayFlowList.length" direction="vertical">
				<el-step v-for="(item, index) in displayFlowList" :key="item.id || index">
					<template #icon>
						<span class="af-step-index">{{ index + 1 }}</span>
					</template>
					<template #title>
						<span class="af-flow-title">{{ item.flowname || '未命名步骤' }}</span>
						<el-tag size="mini" type="success" effect="plain" style="margin-left: 8px">第 {{ item.step || index + 1 }} 步 / 共 {{ item.stepnum || displayFlowList.length }} 步</el-tag>
					</template>
					<template #description>
						<div class="af-auditor-wrap">
							<span class="af-label">审核人员：</span>
							<el-tag v-for="uid in item.auditors" :key="uid" size="mini" type="info" style="margin-right: 6px; cursor: pointer" @click="openUser(uid)">{{ uid }}</el-tag>
							<span v-if="!item.auditors || item.auditors.length === 0" class="af-placeholder">未设置</span>
						</div>
					</template>
				</el-step>
			</el-steps>
		</el-row>

		<!-- 添加或修改审核流程对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
			<el-row>
				<el-steps :active="stepLength" align-center direction="vertical">
					<el-step v-for="(item, index) in checkStepList" :key="item.id">
						<template #icon>
							<span>{{ index + 1 }}</span>
						</template>
						<template #title>
							<el-button v-if="item.auditauthority.length === 0" icon="el-icon-circle-plus-outline" type="success" @click="selectAuditFlowPersons(index)">选择审核人员</el-button>
							<el-button v-else icon="el-icon-circle-plus-outline" type="success" @click="selectAuditFlowPersons(index)">已选择{{ getUserNames(item.auditauthority) }}</el-button>
						</template>
						<template #description>
							<el-input v-model="item.flowname" type="text" :placeholder="`请输入第${index + 1}步审核流程名称`" />
						</template>
					</el-step>
				</el-steps>
			</el-row>
			<div slot="footer" class="dialog-footer">
				<el-button icon="el-icon-circle-plus-outline" type="success" @click="addCheckStateStep">添加审核步骤</el-button>
				<el-button v-if="checkStepList.length !== 0" type="danger" @click="deleteCheckStateStep">删除审核步骤</el-button>
				<el-button type="primary" @click="submitForm">提交审核步骤</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    把我刚刚创建的那个文件用上-->
		<auditFlowInfo ref="auflowAddForm" :visible.sync="auditFlowPersonsVisible" @changeSelectedList="changeSelectListAudit" @deleteSelectedList="deleteSelectList" />
	</div>
</template>

<script>
import { listAuditflow, updateAuditflow } from '@/api/system/auditflow';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { mapGetters } from 'vuex';
import AuditFlowInfo from './auditFlowInfo.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import USER_INFO from '@/components/NeedToShow/USER_INFO.vue'; // 保留了这个导入，确保使用了用户信息对话框

export default {
	name: 'Auditflow',
	components: { AuditFlowInfo },
	mixins: [mixin_printHTML, common_dialog],
	data() {
		return {
			checkStepList: [],
			// 审核步骤列表
			nextStepId: 1, // 用于生成唯一 ID
			loading: true, // 遮罩层
			ids: [], // 选中数组
			single: true, // 单选禁用
			multiple: true, // 多选禁用
			showSearch: true, // 显示搜索条件
			total: 0, // 总条数
			auditflowList: [], // 审核流程表格数据
			title: '', // 弹出层标题
			open: false, // 是否显示弹出层
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				flowname: null,
				stepnum: null,
				step: null,
				auditauthority: null
			},
			form: {}, // 表单参数
			rules: {}, // 表单校验
			stepInfo: {
				id: 1,
				flowname: '',
				stepnum: null,
				step: null,
				auditauthority: []
			},
			auditFlowPersonsVisible: false, // 是否显示选择审核人员对话框
			currentId: '' // 当前审核步骤的 ID
		};
	},
	created() {
		this.getList(); // 获取审核流程列表
		this.checkStepList = []; // 初始化审核步骤列表
	},
	computed: {
		stepLength() {
			return this.checkStepList.length; // 获取审核步骤的长度
		},
		// 展示流程（解析审计人员列表）
		displayFlowList() {
			return (this.auditflowList || []).map(item => ({
				...item,
				auditors: typeof item.auditauthority === 'string' && item.auditauthority.trim() !== '' ? item.auditauthority.split(',') : []
			}));
		}
	},
	methods: {
		getUserNames(ids) {
			if (Array.isArray(ids)) {
				return ids.join(',');
			}
			return ids;
		},
		// 点击用户编号，打开用户信息
		openUser(uid) {
			if (!uid) return;
			this.openDialog(USER_INFO, '用户信息', '520px', { userId: uid }, false);
		},
		// 添加审核流程
		// 修改 addCheckStateStep
		addCheckStateStep() {
			this.checkStepList.push({
				id: this.nextStepId++,
				flowname: '',
				auditauthority: []
			});
		},
		// 删除审核步骤
		deleteCheckStateStep() {
			this.checkStepList.pop();
		},
		// 选择审核人员
		selectAuditFlowPersons(index) {
			this.auditFlowPersonsVisible = true;
			this.currentId = index;
		},
		// 选择后自动填充
		changeSelectListAudit(id) {
			if (typeof id === 'object') {
				id.forEach(item => {
					this.checkStepList[this.currentId].auditauthority.push(item);
				});
				this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)];
				this.checkStepList[this.currentId].step = this.currentId + 1;
			} else {
				this.checkStepList[this.currentId].auditauthority.push(id);
				this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)];
				this.checkStepList[this.currentId].step = this.currentId + 1;
			}
		},
		// 删除审核人员
		deleteSelectList(id) {
			if (typeof id === 'object') {
				this.checkStepList[this.currentId].auditauthority = this.checkStepList[this.currentId].auditauthority.filter(item => !id.includes(item));
				this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)];
			} else {
				this.checkStepList[this.currentId].auditauthority = this.checkStepList[this.currentId].auditauthority.filter(item => item !== id);
				this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)];
			}
		},
		/** 查询审核流程列表 */
		getList() {
			this.loading = true;
			listAuditflow(this.queryParams).then(response => {
				this.auditflowList = response.rows;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.$store.dispatch('paymentApply/clearCheckStepList');
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				flowname: ' ',
				stepnum: null,
				step: null,
				auditauthority: null
			};
			this.stepInfo = {
				id: 1,
				flowname: '',
				stepnum: null,
				step: null,
				auditauthority: []
			};
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
		/** 新增按钮操作 */
		handleAdd() {
			this.title = '更改审核流程';
			this.open = true;
			this.checkStepList = [];
			this.auditflowList.forEach(item => {
				const stepItem = {
					...item,
					auditauthority: typeof item.auditauthority === 'string' && item.auditauthority.trim() !== '' ? item.auditauthority.split(',') : []
				};
				this.checkStepList.push(stepItem);
			});
			if (this.checkStepList.length === 0) {
				this.addCheckStateStep();
			}
		},
		// 提交审核步骤
		submitForm() {
			const submitData = this.checkStepList.map((item, index) => ({
				...item,
				stepnum: this.checkStepList.length,
				step: index + 1,
				auditauthority: Array.isArray(item.auditauthority) ? item.auditauthority.join(',') : item.auditauthority
			}));

			updateAuditflow(submitData).then(res => {
				this.$message.success('更新审核流程成功');
				this.open = false;
				this.getList(); // 重新获取最新数据
			});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/auditflow/export',
				{
					...this.queryParams
				},
				`auditflow_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped>
.af-step-index {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 22px;
	height: 22px;
	border-radius: 50%;
	background: #409eff;
	color: #fff;
	font-size: 12px;
	font-weight: 600;
	box-shadow: 0 0 0 2px #e6f2ff inset;
}

.af-flow-title {
	font-weight: 600;
	font-size: 14px;
}

.af-auditor-wrap {
	margin-top: 10px;
	font-size: 12px;
	color: #666;
}

.af-label {
	color: #999;
	margin-right: 6px;
}

.af-placeholder {
	color: #bbb;
}

::v-deep .el-steps.is-vertical .el-step.is-vertical:not(:last-child) .el-step__line {
	height: 42px;
}

::v-deep .el-steps.is-vertical .el-step__main {
	padding-bottom: 16px;
}
</style>
