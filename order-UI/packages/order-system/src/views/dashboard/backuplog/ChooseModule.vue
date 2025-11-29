<script>
import { moduleNames, TableName } from 'order-system/src/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { filtersFunc } from '@/views/dashboard/backuplog/goodsorder';
import CommonChange from '@/views/dashboard/backuplog/goodsorder/CommonChange.vue';
import _ from 'lodash';

export default {
	name: 'index',
	mixins: [common_dialog],
	computed: {
		TableName() {
			return TableName;
		},
		moduleNames() {
			return moduleNames;
		}
	},
	props: {
		// 模块列表
		moduleList: {
			type: Array,
			default: () => []
		},
		// 变动数据详细列表
		result: {
			type: Array,
			default: () => []
		}
	},
	methods: {
		filtersFunc,
		/**
		 * 弹出的弹窗点击某一个模块 可以查看该模块的详细变动信息
		 * @param moduleName  表名
		 */
		handleCheckModule(moduleName) {
			if (!moduleName) {
				this.$log.warn('handleCheckModule函数执行,未传入模块名参数');
			}
			// 对模块名进行处理
			const tableName = filtersFunc(moduleName);
			const data = _.groupBy(this.result, 'tableName')[tableName] || [];
			if (!_.isEmpty(data)) {
				this.openDialog(
					CommonChange,
					'模块修改记录',
					'1500px',
					{
						compareData: data,
						moduleName: tableName
					},
					false
				);
			} else {
				this.$message.warning('组件数据有误,ChooseModule');
			}
		},
		handleProcess() {
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
		<div class="container">
			<ul class="module-list">
				<li class="module-item" v-for="(item, index) in moduleList" :key="index" @click="handleCheckModule(item)">
					{{ moduleNames[item] }}
				</li>
			</ul>
		</div>
	</div>
</template>

<style scoped lang="scss">
.module-list {
	list-style: none;
	padding: 0;
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
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
