import { create, all } from 'mathjs';
import { fix_2 } from '@/api/tool/format';
import {
	buildFinanceReportQuery,
	createFinanceReportQueryParams,
	getFinanceReportExportFileName,
	getFinanceReportExportPath,
	resolveFinanceReportDate
} from '@/views/system/Statement/FinanceReport.config';

const math = create(all);

/**
 * 收付款报表公共逻辑
 */
export default {
	data() {
		return {
			loading: false,
			showSearch: true,
			total: 0,
			tableData: [],
			queryParams: createFinanceReportQueryParams()
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/**
		 * 获取报表日期
		 * @param {Object} row
		 * @returns {string}
		 */
		getReportDate(row) {
			return resolveFinanceReportDate(row);
		},
		/**
		 * 格式化金额
		 * @param {number|string} value
		 * @returns {string}
		 */
		formatAmount(value) {
			return fix_2(value || 0);
		},
		/**
		 * 计算序号
		 * @param {number} index
		 * @returns {number}
		 */
		indexMethod(index) {
			const pageNum = Number(this.queryParams?.pageNum || 1);
			const pageSize = Number(this.queryParams?.pageSize || 50);
			return math.number(math.add(math.multiply(math.subtract(pageNum, 1), pageSize), math.add(index, 1)));
		},
		/**
		 * 查询列表
		 * @returns {void}
		 */
		getList() {
			this.loading = true;
			this.fetchReportList(buildFinanceReportQuery(this.queryParams))
				.then(res => {
					this.tableData = res?.rows || res?.data || [];
					this.total = res?.total || 0;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		/**
		 * 搜索
		 * @returns {void}
		 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/**
		 * 重置查询
		 * @returns {void}
		 */
		resetQuery() {
			this.queryParams = createFinanceReportQueryParams();
			this.$nextTick(() => {
				this.$refs.queryForm?.resetFields();
			});
			this.getList();
		},
		/**
		 * 导出
		 * @returns {void}
		 */
		handleExport() {
			this.download(getFinanceReportExportPath(this.reportType), buildFinanceReportQuery(this.queryParams), getFinanceReportExportFileName(this.reportType));
		}
	}
};
