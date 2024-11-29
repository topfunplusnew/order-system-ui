<template>
	<div>
		<el-form
			ref="queryForm"
			:model="queryItems"
			size="mini"
			:inline="true"
			label-width="70px"
		>
			<el-row>
				<el-col :span="6">
					<el-form-item label="开始时间" prop="beginTime">
						<el-date-picker
							v-model="queryItems.orderDateStart"
							type="datetime"
							placeholder="选择时间"
							value-format="yyyy-MM-dd HH:mm:ss"
							size="mini"
						></el-date-picker>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="结束时间" prop="endTime">
						<el-date-picker
							v-model="queryItems.orderDateEnd"
							type="datetime"
							placeholder="选择时间"
							value-format="yyyy-MM-dd HH:mm:ss"
							size="mini"
						></el-date-picker>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="客户名称" prop="customer">
						<el-input
							v-model="queryItems.customer"
							placeholder="请输入客户名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="供应商" prop="supplierNames">
						<el-input
							v-model="queryItems.supplierNames"
							placeholder="请输入供应商名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="司机名称" prop="landDriverName">
						<el-input
							v-model="queryItems.landDriverName"
							placeholder="请输入司机名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="海运公司" prop="seaDriverName">
						<el-input
							v-model="queryItems.seaDriverName"
							placeholder="请输入海运公司"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="车队名称" prop="fleet">
						<el-input
							v-model="queryItems.fleet"
							placeholder="请输入车队名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="审核状态" prop="checkState">
						<el-select
							v-model="queryItems.checkState"
							placeholder="请选择"
							size="mini"
							clearable
						>
							<el-option
								v-for="item in options"
								:key="item.value"
								:label="item.label"
								:value="item.value"
							></el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="4">
					<el-form-item>
						<el-button
							type="primary"
							icon="el-icon-search"
							size="mini"
							@click="handleQuery"
						>
							搜索
						</el-button>
					</el-form-item>
				</el-col>
			</el-row>
		</el-form>
	</div>
</template>
<script>
import { OptionInvent, Options } from '../../mixins/order/order_Invoice';

export default {
	name: 'QuerySearchBar',
	props: {
		queryParams: {
			type: Object,
			default: () => ({})
		}
	},
	computed: {
		// 计算属性，用来处理 queryParams 的 get 和 set
		queryItems: {
			get() {
				return this.queryParams;
			},
			set(val) {
				this.$emit('updateQuery', val); // 触发父组件的更新事件
			}
		}
	},
	data() {
		return {
			// 选择框筛选
			optionInvent: OptionInvent, // 假设 OptionInvent 是已定义的数据
			options: Options // 假设 Options 是已定义的数据
		};
	},
	methods: {
		// 处理查询的方法
		handleQuery() {
			this.$emit('updateQuery', this.queryItems);
		}
	}
};
</script>
<style lang="scss" scoped>

</style>
