<script>
import { moduleNames, TableName } from 'order-system/src/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { filtersFunc } from '@/views/dashboard/backuplog/goodsorder';
import CommonChange from '@/views/dashboard/backuplog/goodsorder/CommonChange.vue';
import { TABLE_TEMPLATE_MAP } from '@/views/system/Statement/fundChangeConfig';
import { isUnifiedTicketPointTableName, UNIFIED_TICKET_POINT_MODULE_KEY, UNIFIED_TICKET_POINT_MODULE_LABEL } from '@/utils/fundChange/ticketPoint';
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
		},
		normalizedModuleList() {
			if (!this.useV3Templates) return this.moduleList || [];
			const normalized = [];
			let hasUnifiedTicketPointModule = false;
			(this.moduleList || []).forEach(item => {
				if (isUnifiedTicketPointTableName(item) && item !== UNIFIED_TICKET_POINT_MODULE_KEY) {
					if (!hasUnifiedTicketPointModule) {
						normalized.push(UNIFIED_TICKET_POINT_MODULE_KEY);
						hasUnifiedTicketPointModule = true;
					}
					return;
				}
				if (!normalized.includes(item)) normalized.push(item);
			});
			return normalized;
		},
		resultByTableName() {
			return _.groupBy(this.result || [], 'tableName');
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
		getTemplateConfig(rawTableName) {
			return TABLE_TEMPLATE_MAP[rawTableName] || TABLE_TEMPLATE_MAP[filtersFunc(rawTableName)] || null;
		},
		getModuleData(rawTableName) {
			if (this.useV3Templates && rawTableName === UNIFIED_TICKET_POINT_MODULE_KEY) {
				return (this.result || []).filter(item => isUnifiedTicketPointTableName(item.tableName) && item.tableName !== UNIFIED_TICKET_POINT_MODULE_KEY);
			}
			return this.resultByTableName[rawTableName] || [];
		},
		getDisplayModuleName(rawTableName) {
			if (this.useV3Templates && isUnifiedTicketPointTableName(rawTableName)) {
				return UNIFIED_TICKET_POINT_MODULE_LABEL;
			}
			return this.moduleNames[rawTableName] || rawTableName;
		},
		handleCheckModule(moduleName) {
			if (!moduleName) return;
			const tableName = moduleName === UNIFIED_TICKET_POINT_MODULE_KEY ? UNIFIED_TICKET_POINT_MODULE_KEY : filtersFunc(moduleName);
			const data = this.getModuleData(moduleName);
			if (_.isEmpty(data)) {
				this.$message.warning('组件数据有误,ChooseModule');
				return;
			}
			const templateConfig = this.useV3Templates ? TABLE_TEMPLATE_MAP[tableName] : null;
			const Component = templateConfig?.component || CommonChange;
			const title = templateConfig?.title || '模块修改记录';
			const width = templateConfig?.width || '1500px';
			const componentProps = { compareData: data, moduleName: tableName, summaryData: this.summaryData };
			if (this.useV3Templates && moduleName === UNIFIED_TICKET_POINT_MODULE_KEY) {
				componentProps.summaryModuleLabel = UNIFIED_TICKET_POINT_MODULE_LABEL;
			}
			this.openDialog(Component, title, width, componentProps, false);
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
	<div class="choose-module-container">
		<div v-for="(item, index) in normalizedModuleList" :key="index" class="module-section">
			<div class="module-header" @click="handleCheckModule(item)">
				{{ getDisplayModuleName(item) }}
			</div>
			<div v-if="useV3Templates && getTemplateConfig(item) && getModuleData(item).length" class="module-template-wrap">
				<component
					:is="getTemplateConfig(item).component"
					:compare-data="getModuleData(item)"
					:module-name="item === UNIFIED_TICKET_POINT_MODULE_KEY ? UNIFIED_TICKET_POINT_MODULE_KEY : filtersFunc(item)"
					:summary-data="summaryData"
					:summary-module-label="item === UNIFIED_TICKET_POINT_MODULE_KEY ? UNIFIED_TICKET_POINT_MODULE_LABEL : undefined"
					:summary-only="true"
				/>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.choose-module-container {
	.module-section {
		margin-bottom: 24px;
		&:last-child {
			margin-bottom: 0;
		}
	}
	.module-header {
		padding: 10px 16px;
		margin-bottom: 12px;
		background: #0073e6;
		color: white;
		border-radius: 4px;
		cursor: pointer;
		font-weight: 500;
		transition: background 0.3s;
		&:hover {
			background: #005bb5;
		}
	}
	.module-template-wrap {
		padding: 0 8px 8px;
		border: 1px solid #e4e7ed;
		border-radius: 4px;
		background: #fafafa;
	}
}
</style>
