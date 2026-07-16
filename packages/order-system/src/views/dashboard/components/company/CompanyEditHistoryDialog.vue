<template>
	<el-dialog title="修改记录" :visible="visible" width="1100px" append-to-body @close="handleClose">
		<el-table v-loading="loading" :data="historyList" border size="mini" empty-text="暂无修改记录">
			<el-table-column prop="extraInfo.changedCompanyName" label="修改后内容" min-width="210" show-overflow-tooltip />
			<el-table-column prop="modifyUserName" label="修改人" width="130" show-overflow-tooltip />
			<el-table-column prop="extraInfo.originalCompanyName" label="修改前内容" min-width="210" show-overflow-tooltip />
			<el-table-column prop="modifyTime" label="修改时间" width="180" show-overflow-tooltip />
			<el-table-column prop="reason" label="修改原因" min-width="220" show-overflow-tooltip />
		</el-table>
		<div slot="footer" class="dialog-footer">
			<el-button @click="handleClose">关闭</el-button>
		</div>
	</el-dialog>
</template>

<script>
import { getCompanyHistory } from '@/api/system/company';

export default {
	name: 'CompanyEditHistoryDialog',
	props: {
		visible: {
			type: Boolean,
			default: false
		},
		companyId: {
			type: [Number, String],
			default: null
		},
		companyType: {
			type: String,
			required: true
		}
	},
	data() {
		return {
			loading: false,
			historyList: []
		};
	},
	watch: {
		visible(value) {
			if (value) {
				this.loadHistory();
			}
		}
	},
	methods: {
		loadHistory() {
			if (!this.companyId) {
				this.historyList = [];
				return;
			}
			this.loading = true;
			getCompanyHistory(this.companyId, this.companyType)
				.then(response => {
					this.historyList = Array.isArray(response.data) ? response.data : [];
				})
				.catch(() => {
					this.historyList = [];
					this.$message.error('获取修改记录失败');
				})
				.finally(() => {
					this.loading = false;
				});
		},
		handleClose() {
			this.$emit('update:visible', false);
		}
	}
};
</script>
