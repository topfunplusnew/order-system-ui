<template>
	<div class="app-container">
		<!-- 按钮区域 -->
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:auditflow:edit']" type="danger" size="mini" @click="handleAdd">更改审核流程</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
		</el-row>

		<!-- 审核步骤显示 -->
		<el-row style="margin-top: 60px">
			<el-steps :active="activeStep" direction="vertical">
				<el-step v-for="(step, index) in displayFlowList" :key="step.id || index">
					<template #icon>
						<span class="af-step-index">{{ index + 1 }}</span>
					</template>
					<template #title>
						<span class="af-flow-title">{{ step.flowname || '未命名步骤' }}</span>
						<el-tag size="mini" type="success" effect="plain" style="margin-left: 8px">第 {{ step.step || index + 1 }} 步 / 共 {{ displayFlowList.length }} 步</el-tag>
					</template>
					<template #description>
						<div class="af-auditor-wrap">
							<span class="af-label">审核人员：</span>
							<el-tag v-for="uid in step.auditors" :key="uid" size="mini" type="info" style="margin-right: 6px; cursor: pointer" @click="openUser(uid)">
								{{ uid }}
							</el-tag>
							<span v-if="!step.auditors || step.auditors.length === 0" class="af-placeholder">未设置</span>
						</div>
					</template>
				</el-step>
			</el-steps>
		</el-row>

		<!-- 添加或修改审核流程对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
			<el-row>
				<el-steps :active="stepLength" align-center direction="vertical">
					<el-step v-for="(item, index) in checkStepList" :key="index">
						<template #icon>
							<span>{{ index + 1 }}</span>
						</template>
						<template #title>
							<el-button v-if="item.auditauthority.length === 0" icon="el-icon-circle-plus-outline" type="success" @click="selectAuditFlowPersons(index)">选择审核人员</el-button>
							<el-button v-else icon="el-icon-circle-plus-outline" type="success" @click="selectAuditFlowPersons(index)">已选择用户编号为{{ item.auditauthority }}的用户</el-button>
						</template>
						<template #description>
							<el-input v-model="item.flowname" type="text" placeholder="请输入审核名称"></el-input>
						</template>
					</el-step>
				</el-steps>
			</el-row>

			<!-- 弹出框底部操作按钮 -->
			<div slot="footer" class="dialog-footer">
				<el-button icon="el-icon-circle-plus-outline" type="success" @click="addCheckStateStep">添加审核步骤</el-button>
				<el-button v-if="checkStepList.length !== 0" type="danger" @click="deleteCheckStateStep">删除审核步骤</el-button>
				<el-button type="primary" @click="submitForm">提交审核步骤</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listAuditflow, updateAuditflow } from '@/api/system/auditflow';
import { mapGetters } from 'vuex';
import USER_INFO from '@/components/NeedToShow/USER_INFO.vue';

export default {
	name: 'AuditFlow',
	// components: { USER_INFO },
	data() {
		return {
			auditflowList: [],
			// 遮罩层
			loading: true,
			activeStep: 0, // 当前步骤
			stepLength: 0, // 当前步骤数
			// displayFlowList: [], // 用于展示的审核步骤列表
			checkStepList: [], // 用于编辑的审核步骤列表
			title: '', // 弹出框标题
			open: false, // 弹出框是否可见
			queryParams: {
				pageNum: 1,
				pageSize: 20
			}
		};
	},
	created() {
		this.getList();
		// 初始化 checkStepList
		this.checkStepList = [];
	},
	// 修改 computed 中的 displayFlowList，移除副作用操作
	computed: {
		displayFlowList() {
			return (this.auditflowList || []).map(item => ({
				...item,
				auditors: typeof item.auditauthority === 'string' && item.auditauthority.trim() !== '' ? item.auditauthority.split(',') : []
			}));
		}
	},

	methods: {
		// 在 methods 中添加 handleAdd 方法
		handleAdd() {
			this.title = '更改审核流程';
			this.open = true;
			// 初始化 checkStepList
			this.checkStepList = [];
			this.addCheckStateStep(); // 添加第一个步骤
		},

		// 获取审核流程列表
		getList() {
			listAuditflow(this.queryParams)
				.then(response => {
					this.displayFlowList = response.rows;
					this.stepLength = response.rows.length;
					this.loading = false;
				})
				.catch(error => {
					console.error('获取审核流程失败:', error);
					this.$message.error('获取审核流程失败');
				});
		},
		// 打开用户信息的逻辑
		openUser(uid) {
			this.$emit('openUser', uid);
		},
		// 选择审核人员的逻辑
		selectAuditFlowPersons(index) {
			// 选择审核人员后处理的逻辑
		},
		// 添加审核步骤
		addCheckStateStep() {
			this.checkStepList.push({
				flowname: '',
				auditauthority: []
			});
		},
		// 删除审核步骤
		deleteCheckStateStep() {
			if (this.checkStepList.length <= 1) {
				this.$message.warning('至少需要保留一个审核步骤');
				return;
			}
			this.$confirm('确定要删除该审核步骤吗？', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			})
				.then(() => {
					this.checkStepList.pop();
				})
				.catch(() => {
					this.$message.info('已取消删除');
				});
		},
		// 提交审核步骤
		submitForm() {
			updateAuditflow(this.checkStepList).then(res => {
				this.$message.success('添加审核流程成功');
				this.open = false;
				this.getList();
			});
		},
		// 取消操作
		cancel() {
			this.open = false;
		},
		// 重置查询
		resetQuery() {
			// 重置查询操作
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
/* 调整垂直步骤间距 */
::v-deep .el-steps.is-vertical .el-step.is-vertical:not(:last-child) .el-step__line {
	height: 42px;
}
::v-deep .el-steps.is-vertical .el-step__main {
	padding-bottom: 16px;
}
</style>
