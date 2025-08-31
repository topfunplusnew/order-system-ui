<template>
	<div>
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="110">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.orderDateStart" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini" style="width: 70%"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.orderDateEnd" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" style="width: 70%" size="mini"></el-date-picker>
			</el-form-item>
			<el-form-item label="客户名称" prop="customer">
				<el-input v-model="queryParams.customer" placeholder="请输入客户名称" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="供应商" prop="supplierNames">
				<el-input v-model="queryParams.params.supplierNames" placeholder="请输入供应商名称" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="司机名称" prop="landDriverName">
				<el-input v-model="queryParams.landDriverName" placeholder="请输入司机名称" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="车牌" prop="landCarNo">
				<el-input v-model="queryParams.landCarNo" placeholder="请输入车牌" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="海运公司" prop="seaDriverName">
				<el-input v-model="queryParams.seaDriverName" placeholder="请输入海运公司" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="柜号" prop="seaCarNo">
				<el-input v-model="queryParams.seaCarNo" placeholder="请输入柜号" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="车队名称" prop="fleet">
				<el-input v-model="queryParams.fleet" placeholder="请输入车队名称" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="录入员" prop="userName">
				<el-input v-model="queryParams.userName" placeholder="请输入录入员" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="销售经理" prop="saleManager">
				<el-input v-model="queryParams.saleManager" placeholder="请输入车队名称" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="审核状态" prop="checkState">
				<el-select v-model="queryParams.checkState" placeholder="请选择" size="mini" clearable>
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="供应商是否开票">
				<el-select v-model="queryParams.params.isIncludeTaxFactory" placeholder="请选择" size="mini" clearable>
					<el-option v-for="item in OptionInvent()" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="客户是否开票">
				<el-select v-model="queryParams.params.isIncludeTaxSale" placeholder="请选择" size="mini" clearable>
					<el-option v-for="item in OptionInvent()" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="级别名称" prop="levelName">
				<el-input v-model="queryParams.params.levelName" placeholder="请输入级别名称" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="长度" prop="length">
				<el-input v-model="queryParams.params.length" placeholder="请输入长度" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="宽度" prop="width">
				<el-input v-model="queryParams.params.width" placeholder="请输入宽度" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item label="厚度" prop="height">
				<el-input v-model="queryParams.params.height" placeholder="请输入厚度" clearable size="mini" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
			<el-form-item>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-form-item>
		</el-form>
	</div>
</template>
<script>
import { OptionInvent, Options } from '@/views/dashboard/mixins/order/order_Invoice';
import { getDateRangeDays } from '@/utils/index';
import _ from 'lodash';
import { create } from 'mathjs';

export default {
	name: 'QuerySearchBar',
	props: {
		isAdjust: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			// 选择框筛选
			optionInvent: OptionInvent,
			options: Options,
			// 查询参数
			queryParams: {
				orderDateStart: null,
				orderDateEnd: null,
				pageNum: 1,
				pageSize: 50,
				params: {
					isIncludeTaxSale: '',
					isIncludeTaxFactory: '',
					supplierNames: '',
					levelName: '',
					length: '',
					width: '',
					height: ''
				}
			}
		};
	},
	async created() {
		// 挂载时尝试读取默认时间范围并填充表单（若配置允许）
		try {
			const range = await getDateRangeDays();
			let query = null;
			if (range && range.startTime !== null && range.endTime !== null) {
				// date-picker 使用 yyyy-MM-dd 格式，截取日期部分
				this.queryParams.orderDateStart = String(range.startTime).substring(0, 10);
				this.queryParams.orderDateEnd = String(range.endTime).substring(0, 10);
				query = _.cloneDeep(this.queryParams);
				this.formatOrderDateRange(query);
			}
			this.$emit('updateQuery', query);
		} catch (e) {
			// 配置读取异常不影响页面，其它逻辑继续
			console.error('获取默认时间范围失败：', e && e.message ? e.message : e);
		}
	},
	mounted() {
		// 清除搜索条件
		this.$bus.$on('select-goods:update', () => this.resetParams());
	},
	methods: {
		OptionInvent() {
			return OptionInvent;
		},
		// 处理查询的方法
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.queryParams.pageSize = 50;
			// 创建查询参数的副本，避免修改原始数据
			const queryData = { ...this.queryParams };
			this.formatOrderDateRange(queryData);
			this.$emit('updateQuery', queryData);
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.resetParams();
			this.handleQuery();
		},
		/** 将 orderDateStart/orderDateEnd 从 yyyy-MM-dd 转为 yyyy-MM-dd HH:mm:ss（00:00:00 / 23:59:59） */
		formatOrderDateRange(queryData) {
			if (!queryData) return;
			if (!queryData.orderDateStart || !queryData.orderDateEnd) return;
			// 检查长度，yyyy-MM-dd 格式长度为10，如果长度等于10说明还没拼接过时间
			if (String(queryData.orderDateStart).length === 10) {
				queryData.orderDateStart = String(queryData.orderDateStart) + ' 00:00:00';
			}
			if (String(queryData.orderDateEnd).length === 10) {
				queryData.orderDateEnd = String(queryData.orderDateEnd) + ' 23:59:59';
			}
		},
		resetParams() {
			this.queryParams = {
				orderDateStart: null,
				orderDateEnd: null,
				pageNum: 1,
				pageSize: 50,
				ordersNo: null,
				orderDate: null,
				customer: null,
				customerID: null,
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				checkUserId: null,
				checkState: null,
				// invoiceState: '未开票',
				path: null,
				PaymentState: null,
				landBankName: null,
				landBankNo: null,
				seaBankName: null,
				seaBankNo: null,
				receiveProof: null,
				saleManager: null,
				fleet: null,
				isAdjusted: null,
				adjustDate: null,
				isAdjust: null,
				adjustOrderid: null,
				isedit: null,
				customerIsInvoice: null,
				isSupplierInvoice: null,
				comments: null,
				params: {
					isIncludeTaxSale: null,
					isIncludeTaxFactory: null,
					supplierNames: null,
					levelName: '',
					length: '',
					width: '',
					height: ''
				}
			};
		}
	}
};
</script>
<style lang="scss" scoped></style>
