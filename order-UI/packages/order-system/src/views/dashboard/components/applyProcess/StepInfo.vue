<script>
import { getUserProfile } from '@/api/system/user';
import CheckApply from '@/views/dashboard/components/applyProcess/CheckApply.vue';
import NeedToShowInfo from '@/components/NeedToShowInfo.vue';
import { TableComponentsTools } from '@/utils/order/mapper';
import { AuditCheckState, getTagColor } from '@/api/tool/enums';
import { isEmpty } from '../../../../utils';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import USER_INFO from '@/components/NeedToShow/USER_INFO.vue';

export default {
	name: 'StepInfo',
	components: { NeedToShowInfo, CheckApply },
	mixins: [common_dialog],
	props: {
		processInfo: {
			type: Array,
			required: true
		}
	},
	data() {
		return {
			// 当前登录用户
			loginUser: {},
			// 审核页
			checkPaymentApplyDialogVisible: false,
			// 当前审核页需要审核的付款信息
			currentCheckPaymentApply: {},
			// 审核流程步骤信息
			checkApplyInfo: {},
			// 需要的applyID 给父组件用来更新
			useApplyID: '',
			needToShowInfo: {},
			// 表名
			tableNameToProp: '',
			// 表引用数组信息（多条）
			tableReferencesInfoList: [],
			// 表引用数组
			tableReferences: [],

			isNeedToShowInfoEmpty: false
		};
	},
	computed: {
		AuditCheckState() {
			return AuditCheckState;
		},
		// 当前审核进度
		currentStep() {
			// 找到step最大的
			return Math.max.apply(
				null,
				this.processInfo.map(item => item.step)
			);
		}
	},
	created() {
		// 获取当前登录用户信息
		getUserProfile().then(res => {
			this.loginUser = res.data;
		});
	},
	methods: {
		isEmpty,
		// 打开用户信息
		openUser(uid) {
			if (!uid) return;
			// 复用全局对话框工具
			this.openDialog(USER_INFO, '用户信息', '520px', { userId: uid }, false);
		},
		findUserIdIndex(userId, arr) {
			if (userId === undefined || userId === null || userId === '') {
				return false;
			}
			const splitArr = arr.split(',');
			return splitArr.includes(userId + '');
		},
		// 按钮type绑定
		types(item) {
			return !this.findUserIdIndex(this.loginUser.userId, item.auditauthority) ? 'warning' : 'primary';
		},
		// 按钮禁用
		isDisable(item) {
			// 如果在审核中
			if (item.checkState === '审核中') {
				// todo 根据用户的userId来判断是否该用户需要审核
				// return !this.findUserIdIndex(this.loginUser.userId, item.auditauthority);
				return false;
			} else if (item.checkState === '通过') {
				return true; // 如果该项审批流程通过，则禁用按钮
			} else {
				return true; // 未通过 则禁用按钮
			}
		},
		// 卡片样式：通过=水印；其他非进行中=置灰
		cardClass(item) {
			return {
				'card--passed': item.checkState === '通过',
				'card--disabled': item.checkState !== '审核中' && item.checkState !== '通过'
			};
		},
		// 标签
		isTag(state) {
			return getTagColor(state);
		},
		isChecked(item) {
			return item.checkState;
		},
		processAuditInfo(item) {
			return item.auditcomment === null ? '无' : item.auditcomment;
		},
		// 审核
		async handleCheckState(item) {
			console.log('item:', item);
			// 赋值 先拿到付款申请对象
			this.currentCheckPaymentApply = item.paymentApply;
			// 保存 tableReferences 数组
			this.tableReferences = item.paymentApply.tableReferences || [];
			// 查询对应表信息（使用 tableReferences 数组）
			await this.checkWithTableReferences(this.tableReferences);
			// 组装审核基本对象 传递给子组件审核页面
			this.checkApplyInfo = {
				id: item.id,
				applyID: item.applyID,
				flowname: item.flowname,
				stepnum: item.stepnum,
				step: item.step,
				auditauthority: item.auditauthority
			};
			this.useApplyID = item.applyID;
			// 打开该审核流程步骤的审核页面
			this.checkPaymentApplyDialogVisible = true;
		},

		// 修改审核状态 修改任意状态 关闭弹窗
		handleUpdateCheckState(val) {
			this.checkPaymentApplyDialogVisible = false; // 关闭
		},

		// 根据表名查询（保留用于兼容性）
		async checkWithTableName(tableName, tID) {
			// 展示对应表信息
			try {
				this.tableNameToProp = tableName;
				const tableComponentsTools = new TableComponentsTools();
				this.needToShowInfo = await tableComponentsTools.getInformationByTableName(tableName, tID);
			} catch (e) {
				this.isNeedToShowInfoEmpty = true;
				this.$notification['warning']({
					message: '未找到信息',
					description: '当前需要审核的付款信息,无相关的关联信息',
					onClick: () => {
						console.log('Notification Clicked!');
					}
				});
			}
		},
		// 根据 tableReferences 数组查询多条表信息
		async checkWithTableReferences(tableReferences) {
			if (!tableReferences || !Array.isArray(tableReferences) || tableReferences.length === 0) {
				this.isNeedToShowInfoEmpty = true;
				this.tableReferencesInfoList = [];
				return;
			}
			// 重置状态
			this.isNeedToShowInfoEmpty = false;
			this.tableReferencesInfoList = [];
			const tableComponentsTools = new TableComponentsTools();
			// 遍历 tableReferences 数组，获取每条对应的信息
			const promises = tableReferences.map(async ref => {
				try {
					const result = await tableComponentsTools.getInformationByTableName(ref.refTableName, ref.refTableId);
					return {
						refTableName: ref.refTableName,
						refTableId: ref.refTableId,
						component: tableComponentsTools.getComponentsByTableName(ref.refTableName),
						amount: ref.amount,
						data: result,
						success: true
					};
				} catch (e) {
					console.error(`获取表信息失败: ${ref.refTableName} - ${ref.refTableId}`, e);
					return {
						refTableName: ref.refTableName,
						refTableId: ref.refTableId,
						amount: ref.amount,
						data: null,
						success: false,
						error: e
					};
				}
			});
			// 等待所有查询完成
			const results = await Promise.all(promises);
			// 过滤出成功的结果
			const successResults = results.filter(r => r.success);
			if (successResults.length === 0) {
				this.isNeedToShowInfoEmpty = true;
				this.$notification['warning']({
					message: '未找到信息',
					description: '当前需要审核的付款信息,无相关的关联信息',
					onClick: () => {
						console.log('Notification Clicked!');
					}
				});
			} else {
				this.tableReferencesInfoList = successResults;
				console.log(`tableReferencesInfoList`, this.tableReferencesInfoList);
			}
		}
	}
};
</script>

<template>
	<div>
		<el-row>
			<el-col :span="4">
				<span style="font-weight: bolder; font-size: 16px; line-height: 100px">审核进度:</span>
			</el-col>
			<el-col :span="18">
				<el-steps :active="currentStep" finish-status="success" process-status="process" style="margin-top: 20px">
					<!--      循环-->
					<el-step v-for="(item, index) in processInfo" :key="index" :status="item.checkState === '通过' ? 'success' : item.checkState === '审核中' ? 'process' : 'error'">
						<template #title>
							<span class="step-title">
								{{ item.flowname }}
							</span>
						</template>
						<template #description>
							<div class="step-desc">
								<span>审核意见：</span>
								<span class="desc-content">{{ processAuditInfo(item) }}</span>
								<a-tag size="small" :color="isTag(item.checkState)" style="margin-left: 6px">{{ item.checkState || '待审核' }}</a-tag>
								<div class="auditors-line">
									<span class="label">审核人员：</span>
									<el-tag v-for="uid in item.auditauthority ? item.auditauthority.split(',') : []" :key="uid" size="mini" type="info" style="margin-right: 6px; cursor: pointer" @click="openUser(uid)">
										{{ uid }}
									</el-tag>
								</div>
							</div>
						</template>
					</el-step>
				</el-steps>
			</el-col>
		</el-row>
		<br />
		<br />
		<el-row>
			<el-col :span="4">
				<span style="font-weight: bolder; font-size: 16px; line-height: 100px">审核明细:</span>
			</el-col>
			<el-col :span="18">
				<el-timeline>
					<el-timeline-item v-for="(item, index) in processInfo" :key="index" :timestamp="item.addtime" placement="top">
						<el-card :class="cardClass(item)" class="audit-card">
							<!-- 通过水印层 -->
							<div v-if="item.checkState === '通过'" class="pass-watermark">已通过</div>
							<el-row>
								<el-col :span="18">
									<h2 class="audit-title">{{ isEmpty(item.flowname) }}</h2>
									<p>
										<span>审核结果:</span>
										<a-tag :color="isTag(item.checkState)">{{ isEmpty(item.checkState) }}</a-tag>
									</p>
									<p>
										<span>审核意见:</span>
										<span v-if="isChecked(item) === AuditCheckState.PASS">{{ processAuditInfo(item) }}</span>
										<span v-else-if="isChecked(item) === AuditCheckState.REJECT">{{ processAuditInfo(item) }}</span>
										<span v-else>
											<a-tag :color="isTag(item.checkState)">待审核</a-tag>
										</span>
									</p>
									<p>
										<span>审核人员:</span>
										<el-tag v-for="uid in item.auditauthority ? item.auditauthority.split(',') : []" :key="uid" size="mini" type="info" style="margin-right: 6px; cursor: pointer" @click="openUser(uid)">
											{{ uid }}
										</el-tag>
									</p>
									<p>
										<span>审核时间:</span>
										<span>{{ isEmpty(item.auditdate) }}</span>
									</p>
								</el-col>
								<el-col :span="4">
									<!--  判断当前审核过程是否为登录用户的userId-->
									<el-tooltip class="item" effect="dark" :content="!isDisable ? '您不用审核该项' : '审核'" placement="top-start">
										<el-button :type="types(item)" :disabled="isDisable(item)" @click="handleCheckState(item)">审核</el-button>
									</el-tooltip>
								</el-col>
							</el-row>
						</el-card>
					</el-timeline-item>
				</el-timeline>

				<!-- 审核页面 checkPaymentApplyDialogVisible-->
				<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="流程审核" :visible.sync="checkPaymentApplyDialogVisible" width="65%" append-to-body>
					<!--   需要展示的对应的表信息-->
					<CheckApply :payment-apply-info="currentCheckPaymentApply" :check-apply-info="checkApplyInfo" @update:isCheckState="handleUpdateCheckState">
						<template #additional>
							<el-collapse accordion>
								<el-collapse-item>
									<template slot="title">
										<i class="header-icon el-icon-info" style="margin-right: 10px"></i>
										<span class="payment-title">[付款相关模块信息]-点此查看</span>
										<span v-if="tableReferencesInfoList.length > 0" style="margin-left: 10px; color: #909399; font-size: 12px">(共 {{ tableReferencesInfoList.length }} 条)</span>
									</template>
									<!-- 使用 tableReferences 数组渲染多条信息 -->
									<div v-if="tableReferencesInfoList.length > 0">
										<div v-for="(refInfo, index) in tableReferencesInfoList" :key="index" style="margin-bottom: 20px">
											<el-divider v-if="index > 0" />
											<div style="margin-bottom: 10px">
												<el-tag type="info" size="small" style="margin-right: 8px">关联信息 {{ index + 1 }}</el-tag>
												<el-tag size="small" style="margin-left: 8px">金额: ¥{{ refInfo.amount || 0 }}</el-tag>
											</div>
											<component :is="refInfo.component" v-if="refInfo.data" :need-to-show-info="refInfo.data" />
											<el-alert v-else title="未找到对应信息" type="warning" :description="`表名: ${refInfo.refTableName}, ID: ${refInfo.refTableId}`" show-icon :closable="false"></el-alert>
										</div>
									</div>
									<span v-else>
										<el-alert title="未找到对应信息" type="warning" description="当前需要审核的付款信息,无相关的关联信息" show-icon :closable="false"></el-alert>
									</span>
								</el-collapse-item>
							</el-collapse>
						</template>
					</CheckApply>
					<span slot="footer" class="dialog-footer">
						<el-button @click="checkPaymentApplyDialogVisible = false">关 闭</el-button>
						<!--						<el-button type="primary" @click="checkPaymentApplyDialogVisible = false">确 定</el-button>-->
					</span>
				</el-dialog>
			</el-col>
		</el-row>
	</div>
</template>

<style scoped lang="scss">
.tx-bolder {
	font-weight: bolder;
}

/*卡片遮罩*/
.shadow {
	opacity: 50%;
}

.payment-title {
	font-weight: bold;
	color: red;
}

/* 步骤标题/描述美化 */
.step-title {
	font-weight: 600;
	font-size: 14px;
}
.step-desc {
	font-size: 12px;
	color: #666;
}
.step-desc .desc-content {
	color: #333;
}
/* 增大垂直步骤间距 */
::v-deep .el-steps.is-vertical .el-step.is-vertical:not(:last-child) .el-step__line {
	height: 40px;
}
::v-deep .el-steps.is-vertical .el-step__main {
	padding-bottom: 14px;
}

/* 审核卡片样式 */
.audit-card {
	position: relative;
	border-left: 4px solid #e6e6e6;
	margin-bottom: 10px;
}
.card--passed {
	border-left-color: #52c41a; /* 绿色 */
	box-shadow: 0 0 0 1px rgba(82, 196, 26, 0.2) inset;
}
.card--disabled {
	filter: grayscale(30%);
	opacity: 0.7;
}

/* 已通过水印 */
.pass-watermark {
	position: absolute;
	right: 16px;
	top: 16px;
	padding: 4px 8px;
	background: rgba(82, 196, 26, 0.1);
	color: #389e0d;
	border: 1px dashed #52c41a;
	border-radius: 4px;
	font-weight: 600;
	transform: rotate(-10deg);
	pointer-events: none;
}
</style>
