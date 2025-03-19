<script>
import { moduleNames, TableName } from 'order-system/src/api/tool/enums';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import OrderChanging from '@/views/dashboard/backuplog/goodsorder/OrderChanging.vue';

export default {
	name: 'index',
	components: { DialogWrapper },
	mixins: [common_dialog],
	computed: {
		moduleNames() {
			return moduleNames;
		}
	},
	props: {
		moduleList: {
			type: Array,
			default: () => []
		},
		result: {
			type: Array,
			default: () => []
		}
	},
	methods: {
		// 查看对应模块的数据
		handleCheckModule(moduleName) {
			const data = this.groupByTableName(this.result, this.optionsForOrder)[moduleName] || [];
			if (data.length > 0) {
				this.openDialog(
					OrderChanging,
					'订单修改记录',
					'1500px',
					{
						compareData: data,
						moduleName
					},
					false
				);
			} else {
				this.$message.warning('组件数据有误,ChooseModule');
			}
		},
		// 需要把goodsOrder和orderDetail的放一起 也就是说 遍历到orderDetail的时候 往goodsOrder的分组里扔
		optionsForOrder(tableName) {
			if (tableName === TableName.ORDER_DETAIL) {
				return TableName.GOODS_ORDER;
			}
			return tableName;
		},
		groupByTableName(data, callback) {
			if (!Array.isArray(data)) {
				return {};
			}
			callback = callback || this.optionsForOrder;
			return data.reduce((result, item) => {
				const tableName = item.tableName; // 获取当前项的 tableName
				if (!result[tableName]) {
					result[tableName] = []; // 如果分组不存在，初始化一个空数组
				}
				result[callback(tableName)].push(item); // 将当前项添加到对应的分组中
				return result;
			}, {}); // 初始值为空对象
		},
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<div class="container">
			<ul class="module-list">
				<li class="module-item" v-for="(item, index) in moduleList" :key="index" @click="handleCheckModule(item)">
					{{ moduleNames[item] }}
				</li>
			</ul>
		</div>

		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>
	</div>
</template>

<style scoped lang="scss">
.module-list {
	list-style: none;
	padding: 0;
	display: flex;
	gap: 30px;
}

.module-item {
	width: 150px;
	padding: 10px;
	margin-bottom: 10px;
	background: #0073e6;
	color: white;
	border-radius: 4px;
	cursor: pointer;
	text-align: center;
	transition: background 0.3s;
}

.module-item:hover {
	background: #005bb5;
}

.module-item.selected {
	background: #004494;
}
</style>
