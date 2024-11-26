<template>
	<div>
		<el-dialog
			:close-on-click-modal="false"
			v-bind="$attrs"
			:title="title"
			v-on="$listeners"
			@open="onOpen"
		>
			<el-row>
				<el-table
					:data="showInfoList"
					:loading="loading"
					height="450px"
					size="mini"
					:cell-style="cellStyle"
				>
					<template #append>
						<AddBankAccounts
							:company-info="{ ...queryObject, companyName: '司机' }"
							@callGetList="handleChangeBank"
						/>
					</template>
					<slot name="column"></slot>
				</el-table>
				<pagination
					v-show="total > 0"
					:total="total"
					:current-page.sync="queryParams.pageNum"
					:page-size.sync="queryParams.pageSize"
					@pagination="fetchData"
				/>
			</el-row>
			<template #footer>
				<el-button @click="close">取消</el-button>
				<el-button type="primary" @click="confirm">确定</el-button>
			</template>
		</el-dialog>
	</div>
</template>

<script>
import AddBankAccounts from '../views/dashboard/components/company/AddBankAccounts.vue';

export default {
	name: 'DialogListShow',
	components: { AddBankAccounts },
	inheritAttrs: false,
	props: {
		title: String,
		getData: {
			type: Function,
			default: () => {}
		},
		queryObject: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {
			total: 0,
			loading: false,
			queryParams: {
				pageNum: 1,
				pageSize: 10
			},
			showInfoList: []
		};
	},
	watch: {
		queryObject: {
			handler(val) {
				if (val && Object.keys(val).length > 0) {
					this.fetchData(val);
				}
			},
			deep: true
		}
	},
	created() {
		this.fetchData(this.queryObject);
	},
	methods: {
		// 关闭弹窗的回调
		handleChangeBank() {
			this.driverBankAccout = false;
			this.close();
		},
		onOpen() {
			// 可以在这里添加打开弹窗时的初始化操作
		},
		close() {
			this.$emit('update:visible', false);
		},
		confirm() {
			// 可以在这里添加确认操作
		},
		fetchData(queryObject) {
			this.loading = true;
			this.getData(queryObject).then(response => {
				this.showInfoList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		cellStyle() {
			return { padding: '.5px' };
		}
	}
};
</script>

<style scoped>
/* 样式可以根据需要添加 */
</style>
