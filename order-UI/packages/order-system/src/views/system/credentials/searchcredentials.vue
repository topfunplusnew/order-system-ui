<script>
// 查询凭证
import { mixin_printHTML } from '../../dashboard/mixins/print';

export default {
	name: 'Searchcredentials',
	mixins: [mixin_printHTML],
	data() {
		return {
			queryParams: {
				orderDateStart: '',
				orderDateEnd: ''
			},
			tableData: [
				{
					date: '2016-05-02',
					name: '王小虎',
					address: '上海市普陀区金沙江路 1518 弄'
				},
				{
					date: '2016-05-04',
					name: '王小虎',
					address: '上海市普陀区金沙江路 1517 弄'
				},
				{
					date: '2016-05-01',
					name: '王小虎',
					address: '上海市普陀区金沙江路 1519 弄'
				},
				{
					date: '2016-05-03',
					name: '王小虎',
					address: '上海市普陀区金沙江路 1516 弄'
				}
			],
			columns: []
		};
	},
	methods: {
		getList() {},
		handleExport() {}
	}
};
</script>

<template>
	<div>
		<div class="body">
			<el-row>
				<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="70px">
					<el-col :span="6">
						<el-form-item label="开始时间" prop="beginTime">
							<el-date-picker v-model="queryParams.orderDateStart" type="datetime" placeholder="选择时间" value-format="yyyy-MM-dd HH:mm:ss" size="mini"></el-date-picker>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="结束时间" prop="endTime">
							<el-date-picker v-model="queryParams.orderDateEnd" type="datetime" placeholder="选择时间" value-format="yyyy-MM-dd HH:mm:ss" size="mini"></el-date-picker>
						</el-form-item>
					</el-col>
				</el-form>
			</el-row>
			<el-row>
				<right-toolbar :columns="columns" @queryTable="getList">
					<template #print>
						<el-col :span="1.5">
							<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
						</el-col>
					</template>
					<template #export>
						<el-col :span="1.5">
							<el-button v-hasPermi="['system:goodsorder:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
						</el-col>
					</template>
				</right-toolbar>
				<el-table
					id="printBox"
					v-horizontal-scroll="'always'"
					:data="tableData"
					style="width: 100%"
					border
					:cell-style="
						() => {
							return { padding: '2px' };
						}
					"
					max-height="750"
					size="mini"
				>
					<el-table-column prop="date" label="ID" width="180"></el-table-column>
					<el-table-column prop="name" label="凭证编号" width="180"></el-table-column>
					<el-table-column prop="address" label="制单日期"></el-table-column>
					<el-table-column prop="address" label="制单人"></el-table-column>
					<el-table-column prop="address" label="借方"></el-table-column>
					<el-table-column prop="address" label="贷方"></el-table-column>
					<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
						<template slot-scope="">
							<el-button v-hasPermi="['system:goodsorder:remove']" size="mini" type="primary">操作</el-button>
						</template>
					</el-table-column>
				</el-table>
			</el-row>
		</div>
	</div>
</template>

<style scoped lang="scss">
.body {
	padding: 30px;
}
</style>
