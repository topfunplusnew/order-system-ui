<!--查看订单-->
<script>
import { formatValue } from '../../../../api/tool/cons';

export default {
	name: 'OrderInfos',
	components: {},
	props: {
		orderInfo: {
			type: Object,
			default() {
				return {};
			}
		}
	},
	data() {
		return {};
	},
	created() {},
	mounted() {},
	methods: {
		formatValue,
		handleProcess(that) {
			that.dialogVisible = false;
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		}
	}
};
</script>

<template>
	<div>
		<el-descriptions title="订单信息" size="mini" border :column="6">
			<el-descriptions-item label="日期">
				{{ formatValue(orderInfo.orderDate) }}
			</el-descriptions-item>
			<el-descriptions-item label="客户">
				{{ formatValue(orderInfo.customer) }}
			</el-descriptions-item>
			<el-descriptions-item label="供应商名称">
				{{ formatValue(orderInfo.supplierNames) }}
			</el-descriptions-item>
			<el-descriptions-item label="陆运车牌">
				{{ formatValue(orderInfo.landCarNo) }}
			</el-descriptions-item>
			<el-descriptions-item label="柜号">
				{{ formatValue(orderInfo.seaCarNo) }}
			</el-descriptions-item>
			<el-descriptions-item label="海运公司">
				{{ formatValue(orderInfo.seaDriverName) }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
