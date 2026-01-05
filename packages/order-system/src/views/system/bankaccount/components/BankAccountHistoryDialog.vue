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
		width="900px"
		append-to-body
	>
		<el-table v-loading="loading" :data="historyList" style="width: 100%">
			<el-table-column type="index" label="#" width="50" />
			<el-table-column label="修改时间" width="180" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ scope.row.updateTime || scope.row.createTime || '-' }}
				</template>
			</el-table-column>
			<el-table-column label="修改人" width="120" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ scope.row.updateBy || scope.row.createBy || '-' }}
				</template>
			</el-table-column>
			<el-table-column prop="remark" label="备注" show-overflow-tooltip />
			<el-table-column label="详情" width="80">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="openDetail(scope.row)">查看</el-button>
				</template>
			</el-table-column>
		</el-table>

		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="历史记录详情"
			:visible.sync="detailVisible"
			width="700px"
			append-to-body
		>
			<pre style="margin: 0; max-height: 60vh; overflow: auto; white-space: pre-wrap">{{ detailText }}</pre>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="detailVisible = false">确 定</el-button>
				<el-button @click="detailVisible = false">取 消</el-button>
			</div>
		</el-dialog>

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
			detailVisible: false,
			detailText: ''
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
				this.fetchHistory();
			} else {
				this.detailVisible = false;
				this.detailText = '';
			}
		},
		bankAccountId() {
			if (this.visible) {
				this.fetchHistory(true);
			}
		}
	},
	methods: {
		openDetail(row) {
			this.detailText = row ? JSON.stringify(row, null, 2) : '';
			this.detailVisible = true;
		},
		normalizeHistoryList(res) {
			const candidates = [res?.data, res?.rows, res?.data?.rows, res?.data?.data];
			const list = candidates.find(item => Array.isArray(item));
			return Array.isArray(list) ? list : [];
		},
		fetchHistory(force = false) {
			if (!this.bankAccountId) return;
			if (!force && String(this.lastLoadedId) === String(this.bankAccountId)) return;

			this.loading = true;
			getBankAccountHistory(this.bankAccountId)
				.then(res => {
					this.historyList = this.normalizeHistoryList(res);
					this.lastLoadedId = this.bankAccountId;
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
