<script>
import SearchOption from '@/components/SearchOption.vue';
import { excludeParams } from '@/api/tool/exclude';
import { addOilRecharge, updateOilRecharge } from '@/api/system/oilRecharge';
import { listOilCard } from '@/api/system/oilCard';
import { parseTime } from '@/utils/ruoyi';
import { mapGetters } from 'vuex';

export default {
	name: 'OilCardRecharge',
	components: { SearchOption },
	props: {
		OilCardFillInfo: {
			type: Object,
			default: () => {
				return {};
			}
		}
	},
	data() {
		return {
			form: {},
			queryOilCard: '',
			rules: {}
		};
	},
	computed: {
		...mapGetters(['trueName'])
	},
	created() {
		this.reset();
	},
	mounted() {
		// 自动填充相关信息
		this.form.oilCardNo = this.OilCardFillInfo.oilCardNo || null;
		this.form.rechargeName = this.trueName || null;
	},
	methods: {
		listOilCard,
		// 主卡
		handleCommitBackOilCard(val) {
			this.form.oilCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCard(val) {
			this.queryOilCard = val;
		},
		handleUpload(val) {
			this.form.attachment = val;
		},
		// 提交的方法
		handleProcess(that) {
			this.$refs['form'].validate(valid => {
				if (valid) {
					return new Promise((resolve, reject) => {
						if (this.form.id != null) {
							this.form = excludeParams(this.form, this.$exclude);
							updateOilRecharge(this.form).then(() => {
								that.dialogVisible = false;
								this.$refs.uploadFile.clearUploadedFiles();
								this.$modal.msgSuccess('修改成功');
								resolve();
							});
						} else {
							this.form = excludeParams(this.form, this.$exclude);
							addOilRecharge(this.form).then(() => {
								that.dialogVisible = false;
								this.$refs.uploadFile.clearUploadedFiles();
								this.$modal.msgSuccess('新增成功');
								resolve();
							});
						}
					});
				}
			});
		},
		handleReject() {
			return Promise.resolve();
		},
		reset() {
			this.form = {
				id: null,
				bTripId: null,
				oilCardNo: null,
				rechargeType: '银行卡',
				rechargeMoney: null,
				rechargeDate: parseTime(new Date()),
				acountsName: null,
				bankNo: null,
				rechargeName: null,
				attachment: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('form');
		}
	}
};
</script>

<template>
	<div>
		<el-form ref="form" :model="form" :rules="rules" label-width="160px">
			<el-form-item label="加油卡卡号" prop="oilCardNo">
				<el-row>
					<el-col :span="10">
						<el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号" />
					</el-col>
					<el-col :span="4">
						<SearchOption :get-data="listOilCard" query-info="oilCardNo" :query-name="queryOilCard" query-label="油卡账号查询" :limit-info="{ oilType: '主卡' }" @commitBack="handleCommitBackOilCard" @update:queryName="handleCommitBackQueryOilCard">
							<template #table-columns>
								<el-table-column label="加油卡卡号" align="center" prop="oilCardNo" />
								<el-table-column label="当前金额" align="center" prop="moneyAmount" />
							</template>
						</SearchOption>
					</el-col>
				</el-row>
			</el-form-item>
			<el-form-item label="充值金额" prop="rechargeMoney">
				<el-input v-model="form.rechargeMoney" placeholder="请输入充值金额" />
			</el-form-item>
			<el-form-item label="充值人员姓名" prop="rechargeName">
				<el-input v-model="form.rechargeName" disabled placeholder="请输入充值人员姓名" />
			</el-form-item>
			<el-form-item label="充值附件" prop="attachment">
				<file-upload ref="uploadFile" @input="handleUpload" />
			</el-form-item>
			<el-form-item label="备注" prop="comments">
				<el-input v-model="form.comments" placeholder="请输入备注" />
			</el-form-item>
		</el-form>
	</div>
</template>

<style scoped lang="scss"></style>
