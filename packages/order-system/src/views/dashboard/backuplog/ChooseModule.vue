<script>
import { moduleNames, TableName } from 'order-system/src/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { filtersFunc } from '@/views/dashboard/backuplog/goodsorder';
import CommonChange from '@/views/dashboard/backuplog/goodsorder/CommonChange.vue';
import { TABLE_TEMPLATE_MAP } from '@/views/system/Statement/fundChangeConfig';
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
		moduleList: { type: Array, default: () => [] },
		result: { type: Array, default: () => [] },
		/** 底部统计（calculateByIds 返回），v3 模板使用 */
		summaryData: { type: Object, default: () => ({}) },
		/** 是否使用 v3 资金变动模板（OrderAdjustmentTemplate 等） */
		useV3Templates: { type: Boolean, default: false }
	},
	methods: {
		filtersFunc,
		/**
		 * 点击模块查看详细变动信息
		 * @param {string} moduleName - 表名
		 */
		handleCheckModule(moduleName) {
			if (!moduleName) return;
			const tableName = filtersFunc(moduleName);
			const data = _.groupBy(this.result, 'tableName')[tableName] || [];
			if (_.isEmpty(data)) {
				this.$message.warning('组件数据有误,ChooseModule');
				return;
			}
			const templateConfig = this.useV3Templates ? TABLE_TEMPLATE_MAP[tableName] : null;
			const Component = templateConfig?.component || CommonChange;
			const title = templateConfig?.title || '模块修改记录';
			const width = templateConfig?.width || '1500px';
			this.openDialog(Component, title, width, { compareData: data, moduleName: tableName, summaryData: this.summaryData }, false);
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
