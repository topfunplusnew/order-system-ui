<template>
	<div>
		<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="110">
			<el-form-item v-if="shouldShowField('dateRange')" label="时间范围">
				<el-date-picker
					v-model="dateRange"
					type="daterange"
					range-separator="至"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					value-format="yyyy-MM-dd"
					size="mini"
					class="date-range-280"
					unlink-panels
					:clearable="true"
					@change="onDateRangeChange"
				/>
			</el-form-item>
			<el-form-item v-if="shouldShowField('customer')" label="客户名称" prop="customer">
				<el-input v-model="queryParams.customer" placeholder="请输入客户名称" clearable size="mini" class="input-standard" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('supplierNames')" label="供应商" prop="supplierNames">
				<el-input v-model="queryParams.params.supplierNames" placeholder="请输入供应商名称" clearable size="mini" class="input-standard" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('landDriverName')" label="司机名称" prop="landDriverName">
				<el-input v-model="queryParams.landDriverName" placeholder="请输入司机名称" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('landCarNo')" label="车牌" prop="landCarNo">
				<el-input v-model="queryParams.landCarNo" placeholder="请输入车牌" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('seaDriverName')" label="海运公司" prop="seaDriverName">
				<el-input v-model="queryParams.seaDriverName" placeholder="请输入海运公司" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('seaCarNo')" label="柜号" prop="seaCarNo">
				<el-input v-model="queryParams.seaCarNo" placeholder="请输入柜号" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('fleet')" label="车队名称" prop="fleet">
				<el-input v-model="queryParams.fleet" placeholder="请输入车队名称" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('userName')" label="录入员" prop="userName">
				<el-input v-model="queryParams.userName" placeholder="请输入录入员" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('saleManager')" label="销售经理" prop="saleManager">
				<el-input v-model="queryParams.saleManager" placeholder="请输入销售经理" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('checkState')" label="审核状态" prop="checkState">
				<el-select v-model="queryParams.checkState" placeholder="请选择" size="mini" clearable class="select-standard">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item v-if="shouldShowField('isIncludeTaxFactory')" label="供应商是否开票">
				<el-select v-model="queryParams.params.isIncludeTaxFactory" placeholder="请选择" size="mini" clearable class="input-short">
					<el-option v-for="item in OptionInvent()" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item v-if="shouldShowField('isIncludeTaxSale')" label="客户是否开票">
				<el-select v-model="queryParams.params.isIncludeTaxSale" placeholder="请选择" size="mini" clearable class="input-short">
					<el-option v-for="item in OptionInvent()" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item v-if="shouldShowField('levelName')" label="级别名称" prop="levelName">
				<el-input v-model="queryParams.params.levelName" placeholder="请输入级别名称" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('length')" label="长度" prop="length">
				<el-input v-model="queryParams.params.length" placeholder="请输入长度" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('width')" label="宽度" prop="width">
				<el-input v-model="queryParams.params.width" placeholder="请输入宽度" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>
			<el-form-item v-if="shouldShowField('height')" label="厚度" prop="height">
				<el-input v-model="queryParams.params.height" placeholder="请输入厚度" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
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

export default {
	name: 'QuerySearchBar',
	props: {
		isAdjust: {
			type: Boolean,
			default: false
		},
		// 可见字段配置数组 - 空数组表示显示所有字段
		visibleFields: {
			type: Array,
			default: () => []
		}
	},
	computed: {
		// 检查字段是否应该显示 - 空数组表示显示所有字段
		shouldShowField() {
			return fieldName => {
				// 如果 visibleFields 为空数组，显示所有字段
				if (!this.visibleFields || this.visibleFields.length === 0) {
					return true;
				}
				// 否则检查字段是否在可见列表中
				return this.visibleFields.includes(fieldName);
			};
		}
	},
	data() {
		return {
			// 日期范围
			dateRange: [],
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
	// 当使用了QuerySearchBar组件，在这个组件初始化的时候，就会默认获取一次订单信息，所以 使用这个组件的代码只需要做到接收工作
	// 不需要额外获取订单信息
	async created() {
		// 挂载时尝试读取默认时间范围并填充表单（若配置允许）
		try {
			const range = await getDateRangeDays();
			let query = null;
			if (range && range.startTime !== null && range.endTime !== null) {
				// date-picker 使用 yyyy-MM-dd 格式，截取日期部分
				const start = String(range.startTime).substring(0, 10);
				const end = String(range.endTime).substring(0, 10);
				this.dateRange = [start, end];
				this.queryParams.orderDateStart = start;
				this.queryParams.orderDateEnd = end;
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
		onDateRangeChange(val) {
			// 仅在选择完成时触发搜索；清空时不自动触发
			if (Array.isArray(val) && val.length === 2) {
				this.dateRange = val;
				this.handleQuery();
			} else {
				this.dateRange = [];
				// 不触发搜索
			}
		},
		// 处理查询的方法
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.queryParams.pageSize = 50;
			// 将 dateRange 写回开始/结束
			if (Array.isArray(this.dateRange) && this.dateRange.length === 2) {
				this.queryParams.orderDateStart = this.dateRange[0];
				this.queryParams.orderDateEnd = this.dateRange[1];
			} else {
				this.queryParams.orderDateStart = null;
				this.queryParams.orderDateEnd = null;
			}
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
			this.dateRange = [];
		}
	}
};
</script>
<style lang="scss" scoped></style>
