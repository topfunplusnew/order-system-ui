<script>
import { TableName } from '../../../../api/tool/enums';
import { listInvoiceIn } from '../../../../api/system/invoiceIn';
import { listInvoiceOut } from '../../../../api/system/invoiceOut';
import { addDateRange } from '../../../../utils/ruoyi';
import { listInvoiceOther } from '../../../../api/system/invoiceOther';

export default {
	name: 'InvoiceList',
	props: {
		invoiceType: {
			type: String,
			// 默认买入
			default: TableName.INVOICE_IN
		}
	},
	data() {
		return {
			invoiceList: [],
			loading: false,
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				invoiceDate: null,
				invoiceObject: null,
				invoiceAmount: null,
				companyType: null,
				companyName: null,
				companyID: null,
				invoiceCompanyName: null,
				ticketPoint: null,
				ticketPointAmount: null,
				isOrderTax: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			}
		};
	},
	computed: {
		TableName() {
			return TableName;
		}
	},
	watch: {
		invoiceType: {
			handler(val) {
				this.getList(val);
			}
		}
	},
	created() {
		this.getList(this.invoiceType);
	},
	methods: {
		// 选中某个信息
		handleSelectionChange(selection) {
			this.$emit('update:selectedGoodsOrderList', selection);
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList(this.invoiceType);
		},
		// 根据类型获取对应的数据
		getList(val) {
			this.loading = true;
			// 根据父组件generation 传入的invoiceType 来决定调用哪个接口 渲染哪一个表格 表格字段都是一致的
			if (val === TableName.INVOICE_IN) {
				listInvoiceIn(this.queryParams).then(response => {
					this.invoiceList = response.rows;
					this.total = response.total;
					this.loading = false;
				});
			} else if (val === TableName.INVOICE_OUT) {
				listInvoiceOut(addDateRange(this.queryParams, this.dateRange, 'invoiceout')).then(response => {
					this.invoiceList = response.rows;
					this.total = response.total;
					this.loading = false;
				});
			} else {
				listInvoiceOther(addDateRange(this.queryParams, this.dateRange)).then(response => {
					this.invoiceList = response.rows;
					this.total = response.total;
					this.loading = false;
				});
			}
		}
	}
};
</script>

<template>
	<div>
		<el-form ref="queryForm" v-loading="loading" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<!--      时间查询-->
			<el-form-item label="开票开始日期" prop="beginTime">
				<el-date-picker v-model="queryParams.beginTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="开票结束日期" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<!--    这里可以添加一些操作-->
		<slot name="option"></slot>
		<!--    发票列表-->
		<!--   对于第三方开票要特殊处理-->
		<el-row v-if="invoiceType === TableName.INVOICE_OTHER">
			<el-table
				id="printBox"
				v-horizontal-scroll="'always'"
				border
				:data="invoiceList"
				fit
				size="mini"
				:cell-style="
					() => {
						return { padding: '.5px' };
					}
				"
				@selection-change="handleSelectionChange"
			>
				<el-table-column type="selection" width="55" fixed="left"></el-table-column>
				<el-table-column label="开票日期" align="center" prop="invoiceDate" show-overflow-tooltip />
				<el-table-column label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
				<el-table-column label="供应商票点" align="center" prop="supplierTicketPoint" show-overflow-tooltip />
				<el-table-column label="供应商票点金额" align="center" prop="supplierPointAmount" show-overflow-tooltip />
				<el-table-column label="供应商公司名称" align="center" prop="Supplier" show-overflow-tooltip />
				<el-table-column label="客户公司名称" align="center" prop="customer" show-overflow-tooltip />
				<el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip />
				<el-table-column label="客户票点" align="center" prop="customerTicketPoint" show-overflow-tooltip />
				<el-table-column label="票点金额" align="center" prop="customerPointAmount" show-overflow-tooltip />
			</el-table>
		</el-row>
		<el-row v-else>
			<el-table
				id="printBox"
				v-horizontal-scroll="'always'"
				border
				:data="invoiceList"
				fit
				size="mini"
				:cell-style="
					() => {
						return { padding: '.5px' };
					}
				"
				@selection-change="handleSelectionChange"
			>
				<el-table-column type="selection" width="55" fixed="left"></el-table-column>
				<el-table-column label="开票日期" align="center" prop="invoiceDate" show-overflow-tooltip />
				<el-table-column label="我方开票实体" align="center" prop="invoiceObject" width="100px" show-overflow-tooltip />
				<el-table-column label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
				<el-table-column label="对方公司类别" align="center" prop="companyType" width="100px" show-overflow-tooltip />
				<el-table-column label="对方公司名称" align="center" prop="companyName" width="100px" show-overflow-tooltip />
				<el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName" width="100px" show-overflow-tooltip />
				<el-table-column label="票点" align="center" prop="ticketPoint" show-overflow-tooltip />
				<el-table-column label="票点金额" align="center" prop="ticketPointAmount" show-overflow-tooltip />
				<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip />
			</el-table>
		</el-row>
	</div>
</template>

<style scoped lang="scss"></style>
