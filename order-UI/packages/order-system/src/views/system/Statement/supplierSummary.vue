]
<!--订单列表+调整单列表 总货款是否含税 含税的商品金额 供应商开始时间 结束时间 &ndash;&gt;供应商收付款信息表(新页面)-->

<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" clearable></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" clearable></el-date-picker>
			</el-form-item>
			<el-form-item label="供应商名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入供应商名称" clearable></el-input>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">供应商科目余额汇总表</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>

				<!-- 后端说把导出扣了 -->
				<!-- <template #export>
          <el-col :span="1.5">
            <el-button
              v-hasPermi="['system:company:export']"
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
            />
          </el-col>
        </template> -->
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="tableData"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column v-if="columns[0].visible" show-overflow-tooltip label="科目编码" align="center" prop="subjectNo" width="140" />
			<el-table-column v-if="columns[1].visible" show-overflow-tooltip label="科目名称" align="center" prop="subjectName" width="140" />
			<el-table-column v-if="columns[2].visible" show-overflow-tooltip label="供应商编号" align="center" prop="companyId" width="140" />
			<el-table-column v-if="columns[3].visible" show-overflow-tooltip label="供应商名称" align="center" prop="companyName" width="140" />
			<el-table-column v-if="columns[4].visible" show-overflow-tooltip label="期初方向" align="center" prop="beginningBalance" width="140">
				<template slot-scope="scope">
					{{ Number(scope.row.beginningBalance) !== 0 ? (Number(scope.row.beginningBalance) > 0 ? '借方' : '贷方') : '平' }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" show-overflow-tooltip label="期初余额" align="center" prop="beginningBalance" width="140" />
			<el-table-column v-if="columns[6].visible" show-overflow-tooltip label="借方(付供应商货款)" align="center" prop="positiveSum" width="140" />
			<el-table-column v-if="columns[7].visible" show-overflow-tooltip label="贷方(从厂家提货)" align="center" prop="negativeSum" width="140">
				<template slot-scope="scope">
					{{ Math.abs(scope.row.negativeSum) }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" show-overflow-tooltip label="平账金额" align="center" prop="balanceaccountsAmount" width="140" />
			<el-table-column v-if="columns[9].visible" show-overflow-tooltip label="期末方向" align="center" prop="endingBalance" width="140">
				<template slot-scope="scope">
					{{ Number(scope.row.endingBalance) !== 0 ? (Number(scope.row.endingBalance) > 0 ? '借方' : '贷方') : '平' }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" show-overflow-tooltip label="期末余额" align="center" prop="endingBalance" width="140" />
			<!-- 操作列 -->
			<!--			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">-->
			<!--				<template slot-scope="scope">-->
			<!--					<SupplierDetail :detail="scope.row" />-->
			<!--				</template>-->
			<!--			</el-table-column>-->
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { getSupplierSubjectSummary } from '@/api/system/statement';
import { getTimeOffset } from '@/utils/order';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import SupplierDetail from '@/views/system/Statement/components/SupplierDetail.vue';
import { parseTime } from '../../../utils/ruoyi';

import { getConfigValue } from './data/config_get';

export default {
	name: 'CustomerSummary',
	components: { SupplierDetail },
	dicts: ['order_target_type'],
	mixins: [mixin_printHTML],
	data() {
		return {
			// 遮罩层
			loading: false,
			total: 0,
			tableData: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50,
				// 日期往前推迟一年 工具函数
				beginTime: getTimeOffset('{y}-{m}-{d}', 1),
				endTime: parseTime(new Date(), '{y}-{m}-{d}'),
				companyName: null
			},
			columns: [
				{ key: 0, label: '科目编码', visible: true },
				{ key: 1, label: '科目名称', visible: true },
				{ key: 2, label: '供应商编号', visible: true },
				{ key: 3, label: '供应商名称', visible: true },
				{ key: 4, label: '期初方向', visible: true },
				{ key: 5, label: '期初余额', visible: true },
				{ key: 6, label: '借方(付供应商货款)', visible: true },
				{ key: 7, label: '贷方(从厂家提货)', visible: true },
				{ key: 8, label: '平账金额', visible: true },
				{ key: 9, label: '期末方向', visible: true },
				{ key: 10, label: '期末余额', visible: true }
			],

			dialogVisible: false
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询向外部借出款信息列表 */
		async getList() {
			// 获取供应商科目余额汇总表数据 填充到表格中
			this.loading = true;
			// 根据config_key order.customerDetailSummary.subjectNo 拿到键值
			const key = { configKey: 'order.supplierDetailSummary.subjectNo' };
			// 拿到科目名称
			const { subjectName, configValue } = await getConfigValue(key);
			// 拿取供应商科目余额汇总表数据 然后给tableData每一条数据赋值科目编码和名称
			getSupplierSubjectSummary(this.queryParams).then(response => {
				const data = response.rows || response.data;
				// 校验
				if (!data) {
					this.$message.warning('暂无数据');
					return;
				}

				if (data.length && data.length === 0) {
					this.$message.warning('暂无数据');
					return;
				}
				// 组装tableData
				this.tableData = response?.rows.map(item => {
					return {
						...item,
						subjectNo: configValue,
						subjectName: subjectName
					};
				});
				this.total = response.total;
				this.loading = false;
			});
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		refresh() {
			this.getList();
		},
		handleExport() {
			this.$datePicker().then(({ beginTime, endTime }) => {
				this.queryParams.beginTime = beginTime;
				this.queryParams.endTime = endTime;
				this.download(
					'statistics/export/supplierSummary',
					{
						...this.queryParams
					},
					`供应商科目余额汇总表_${parseTime(new Date().getTime())}.xlsx`
				);
			});
		}
	}
};
</script>
