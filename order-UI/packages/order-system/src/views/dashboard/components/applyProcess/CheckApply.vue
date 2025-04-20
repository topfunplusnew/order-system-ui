<!--审核弹窗-->
<script>
import { updateAuditInfo } from '@/api/system/auditInfo';
import CheckFiles from '../../../../components/CheckFiles.vue';

export default {
	components: { CheckFiles },
	props: {
		// 付款信息
		paymentApplyInfo: {},
		// 审核步骤信息
		checkApplyInfo: {},
		// 是否通过
		isCheckState: {
			type: Boolean
		}
	},
	data() {
		return {
			// 审核意见
			auditcommentYES: '',
			auditcommentNO: '',
			auditcommentBACK: ''
		};
	},
	computed: {
		checkState: {
			get() {
				return this.isCheckState;
			},
			set(val) {
				this.$emit('update:isCheckState', val);
			}
		}
	},
	methods: {
		// 审核通过
		handleCheckSuccess() {
			const data = {
				checkState: '通过',
				auditcomment: this.auditcommentYES,
				...this.checkApplyInfo
			};
			// 调用接口 修改审核状态
			updateAuditInfo(data).then(res => {
				this.$message.success('操作完毕~');
				// 修改刷新标记vuex
				this.$store.dispatch('apply/setChecked', this.checkApplyInfo.applyID);
				this.auditcommentYES = '';
				// 关闭弹窗
				this.checkState = true;
			});
		},
		// 审核不通过
		handleCheckError() {
			const data = {
				checkState: '未通过',
				auditcomment: this.auditcommentNO,
				...this.checkApplyInfo
			};
			// 调用接口 修改审核状态
			updateAuditInfo(data).then(res => {
				this.$message.success('操作完毕~');
				// 修改刷新标记vuex
				this.$store.dispatch('apply/setChecked', this.checkApplyInfo.applyID);
				this.auditcommentNO = '';
				// 关闭弹窗
				this.checkState = false;
			});
		},
		handleCheckBack() {
			const data = {
				checkState: '驳回',
				auditcomment: this.auditcommentBACK,
				...this.checkApplyInfo
			};
			updateAuditInfo(data).then(res => {
				this.$message.success('操作完毕~');
				// 修改刷新标记vuex
				this.$store.dispatch('apply/setChecked', this.checkApplyInfo.applyID);
				this.auditcommentBACK = '';
				// 关闭弹窗
				this.checkState = false;
			});
		}
	}
};
</script>

<template>
	<div>
		<!--    付款信息展示-->
		<el-row>
			<el-descriptions title="付款信息明细">
				<el-descriptions-item label="申请人">{{ paymentApplyInfo.applyPerson }}</el-descriptions-item>
				<el-descriptions-item label="申请金额">{{ paymentApplyInfo.moneyAmount }}</el-descriptions-item>
				<el-descriptions-item label="备注">{{ paymentApplyInfo.comments }}</el-descriptions-item>
				<el-descriptions-item label="公司类型">
					{{ paymentApplyInfo.companyType }}
				</el-descriptions-item>
				<el-descriptions-item label="公司名称">
					{{ paymentApplyInfo.companyName }}
				</el-descriptions-item>
				<el-descriptions-item label="时间">
					{{ paymentApplyInfo.fundsDate }}
				</el-descriptions-item>
				<el-descriptions-item label="对方账户名称">
					{{ paymentApplyInfo.otherAcountsName }}
				</el-descriptions-item>
				<el-descriptions-item label="对方银行卡号">
					{{ paymentApplyInfo.otherBankNo }}
				</el-descriptions-item>
				<el-descriptions-item label="对方开户行">
					{{ paymentApplyInfo.otherBankName }}
				</el-descriptions-item>
				<el-descriptions-item label="申请原因">
					{{ paymentApplyInfo.reason }}
				</el-descriptions-item>
				<el-descriptions-item label="附件">
					<!--          这里不需要上传-->
					<CheckFiles :path="paymentApplyInfo.attachment" :is-upload="false" />
				</el-descriptions-item>
			</el-descriptions>
		</el-row>
		<slot name="additional" />
		<br />
		<hr />
		<el-row>
			<el-col :span="4">
				<span style="font-weight: bolder; line-height: 35px">操作</span>
			</el-col>
			<el-col :span="20">
				<el-row>
					<!--          审核通过-->
					<el-col :span="8">
						<el-row :gutter="4">
							<el-col :span="12">
								<el-input size="mini" v-model="auditcommentYES" placeholder="请输入审核意见" type="text"></el-input>
							</el-col>
							<el-col :span="12">
								<el-button size="mini" type="success" @click="handleCheckSuccess">审核通过</el-button>
							</el-col>
						</el-row>
					</el-col>
					<!--          审核不通过-->
					<el-col :span="8">
						<el-row :gutter="4">
							<el-col :span="12">
								<el-input size="mini" v-model="auditcommentNO" placeholder="请输入不通过原因" type="text"></el-input>
							</el-col>
							<el-col :span="12">
								<el-button size="mini" type="danger" @click="handleCheckError">审核不通过</el-button>
							</el-col>
						</el-row>
					</el-col>
					<!--          驳回-->
					<el-col :span="8">
						<el-row :gutter="4">
							<el-col :span="12">
								<el-input size="mini" v-model="auditcommentBACK" placeholder="请输入不通过原因" type="text"></el-input>
							</el-col>
							<el-col :span="12">
								<el-button size="mini" type="danger" @click="handleCheckBack">驳回</el-button>
							</el-col>
						</el-row>
					</el-col>
				</el-row>
			</el-col>
		</el-row>
	</div>
</template>

<style scoped lang="scss"></style>
