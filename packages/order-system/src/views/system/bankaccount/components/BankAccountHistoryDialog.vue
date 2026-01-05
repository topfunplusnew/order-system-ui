<template>
	<el-dialog
		:modal="false"
		v-dialogDrag
		v-dialogDragWidth
		v-dialogDragHeight
		:close-on-click-modal="false"
		:show-close="false"
		:title="dialogTitle"
		:visible.sync="dialogVisible"
		@open="fetchHistory(true)"
		width="900px"
		append-to-body
	>
		<el-table v-loading="loading" :data="historyList" style="width: 100%">
			<el-table-column type="index" label="#" width="50" />
			<el-table-column prop="acountsType" label="类型" width="90" show-overflow-tooltip />
			<el-table-column prop="acountsName" label="开户名" min-width="160" show-overflow-tooltip />
			<el-table-column prop="bankNo" label="银行账号" min-width="170" show-overflow-tooltip />
			<el-table-column prop="bankName" label="开户行" min-width="120" show-overflow-tooltip />
			<el-table-column prop="companyName" label="公司名称/车牌号" min-width="120" show-overflow-tooltip />
			<el-table-column prop="displayName" label="我方公司" min-width="120" show-overflow-tooltip />
			<el-table-column prop="comments" label="备注" min-width="120" show-overflow-tooltip />
			<el-table-column prop="createBy" label="操作人" width="120" show-overflow-tooltip />
			<el-table-column prop="createTime" label="操作时间" width="170" show-overflow-tooltip />
		</el-table>

		<div slot="footer" class="dialog-footer">
			<el-button type="primary" @click="dialogVisible = false">确 定</el-button>
			<el-button @click="dialogVisible = false">取 消</el-button>
		</div>
	</el-dialog>
</template>

<script>
import { getBankAccountHistory } from '@/api/system/bankAccount';

export default {
	name: 'BankAccountHistoryDialog',
	props: {
		visible: {
			type: Boolean,
			default: false
		},
		bankAccountId: {
			type: [Number, String],
			default: null
		},
		bankNo: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			loading: false,
			historyList: [],
			lastLoadedId: null,
			lastLoadedVisibleId: null
		};
	},
	computed: {
		dialogVisible: {
			get() {
				return this.visible;
			},
			set(val) {
				this.$emit('update:visible', val);
			}
		},
		dialogTitle() {
			const suffix = this.bankNo ? `（${this.bankNo}）` : '';
			return `银行卡历史记录${suffix}`;
		}
	},
	watch: {
		visible(val) {
			if (val) {
				this.fetchHistory(true);
			} else {
				this.historyList = [];
				this.lastLoadedVisibleId = null;
			}
		},
		bankAccountId() {
			if (this.visible) {
				this.fetchHistory(true);
			}
		}
	},
	methods: {
		normalizeHistoryList(res) {
			const candidates = [res?.data, res?.rows, res?.data?.rows, res?.data?.data];
			const list = candidates.find(item => Array.isArray(item));
			return Array.isArray(list) ? list : [];
		},
		fetchHistory(force = false) {
			if (!this.bankAccountId) return;
			if (!force && String(this.lastLoadedId) === String(this.bankAccountId)) return;
			if (!force && String(this.lastLoadedVisibleId) === String(this.bankAccountId)) return;

			this.loading = true;
			getBankAccountHistory(this.bankAccountId)
				.then(res => {
					this.historyList = this.normalizeHistoryList(res);
					this.lastLoadedId = this.bankAccountId;
					this.lastLoadedVisibleId = this.bankAccountId;
					if ((this.historyList || []).length === 0) {
						this.$message.warning('未查询到银行卡历史记录');
					}
				})
				.finally(() => {
					this.loading = false;
				});
		}
	}
};
</script>
