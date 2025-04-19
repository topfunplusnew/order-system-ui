<script>
import { getUserProfile } from '@/api/system/user';
import CheckApply from '@/views/dashboard/components/applyProcess/CheckApply.vue';
import NeedToShowInfo from '@/components/NeedToShowInfo.vue';
import { TableComponentsTools } from '@/utils/order/mapper';
import { AuditCheckState, getTagColor } from '@/api/tool/enums';

export default {
	name: 'StepInfo',
	components: { NeedToShowInfo, CheckApply },
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
			tableNameToProp: ''
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
		handleCheckState(item) {
			console.log('item:', item);
			// 查询对应表信息
			this.checkWithTableName(item.paymentApply.tableName, item.paymentApply.tid);
			// 赋值 先拿到付款申请对象
			this.currentCheckPaymentApply = item.paymentApply;
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

		// 根据表名查询
		async checkWithTableName(tableName, tID) {
			// 展示对应表信息
			this.tableNameToProp = tableName;
			const tableComponentsTools = new TableComponentsTools();
			this.needToShowInfo = await tableComponentsTools.getInformationByTableName(tableName, tID);
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
				<el-steps :active="currentStep" finish-status="success" style="margin-top: 20px">
					<!--      循环-->
					<el-step v-for="(item, index) in processInfo" :key="index" :status="item.checkState === '通过' ? 'success' : 'error'">
						<template #title>
							<span style="font-weight: bolder">
								{{ item.flowname }}
							</span>
						</template>
						<template #description>
							<span style="font-weight: bolder">审核意见:{{ processAuditInfo(item) }}</span>
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
					<el-timeline-item v-for="(item, index) in processInfo" :key="index" :timestamp="item.auditdate" placement="top">
						<el-card :class="{ shadow: isDisable(item) }">
							<el-row>
								<el-col :span="18">
									<h2>{{ item.flowname }}</h2>
									<p>
										<span class="tx-bolder">审核结果:</span>
										<a-tag :color="isTag(item.checkState)">{{ item.checkState }}</a-tag>
									</p>
									<p>
										<span class="tx-bolder">审核意见:</span>
										<span v-if="isChecked(item) === AuditCheckState.PASS">{{ processAuditInfo(item) }}</span>
										<span v-else-if="isChecked(item) === AuditCheckState.REJECT">{{ processAuditInfo(item) }}</span>
										<span v-else>
											<a-tag :color="isTag(item.checkState)">待审核</a-tag>
										</span>
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
				<el-dialog :close-on-click-modal="false" title="流程审核" :visible.sync="checkPaymentApplyDialogVisible" width="65%" append-to-body>
					<!--   需要展示的对应的表信息-->
					<CheckApply :payment-apply-info="currentCheckPaymentApply" :check-apply-info="checkApplyInfo" @update:isCheckState="handleUpdateCheckState">
						<template #additional>
							<el-collapse accordion>
								<el-collapse-item>
									<template slot="title">
										<i class="header-icon el-icon-info" style="margin-right: 10px"></i>
										<span class="payment-title">[付款相关模块信息]-点此查看</span>
									</template>
									<NeedToShowInfo :need-to-show-info="needToShowInfo" :table-name-to-prop="tableNameToProp" />
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
</style>
