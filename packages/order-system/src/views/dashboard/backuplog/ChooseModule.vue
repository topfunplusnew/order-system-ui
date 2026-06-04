<script>
import { moduleNames, TableName } from 'order-system/src/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { filtersFunc } from '@/views/dashboard/backuplog/goodsorder';
import { createFundChangeModuleKey, FUND_CHANGE_CONTEXT_WILDCARD, parseFundChangeModuleKey, resolveFundChangeTemplateConfig } from '@/views/system/Statement/fundChangeConfig';
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
			const normalized = [];
			const seen = new Set();
			const source = !_.isEmpty(this.moduleContexts) ? this.moduleContexts : this.moduleList;
			(source || []).forEach(item => {
				const option = this.toModuleOption(item);
				if (!option?.key || seen.has(option.key)) return;
				normalized.push(option);
				seen.add(option.key);
			});
			return normalized;
		},
		resultByModuleKey() {
			return _.groupBy(this.result || [], item => this.getRecordModuleKey(item));
		},
		resultByTableName() {
			return _.groupBy(this.result || [], 'tableName');
		}
	},
	props: {
		moduleList: { type: Array, default: () => [] },
		moduleContexts: { type: Array, default: () => [] },
		result: { type: Array, default: () => [] },
		/** 底部统计（calculateByIds 返回），v3 模板使用 */
		summaryData: { type: Object, default: () => ({}) },
		/** 当前资金变动明细按哪个目标日期展示 */
		targetDate: { type: String, default: '' },
		/** 兼容旧调用；资金变动详情统一使用 FundChangeTemplates */
		useV3Templates: { type: Boolean, default: false }
	},
	methods: {
		filtersFunc,
		normalizeTableName(rawTableName) {
			const tableName = rawTableName === UNIFIED_TICKET_POINT_MODULE_KEY ? UNIFIED_TICKET_POINT_MODULE_KEY : filtersFunc(rawTableName);
			return isUnifiedTicketPointTableName(tableName) ? UNIFIED_TICKET_POINT_MODULE_KEY : tableName;
		},
		toModuleOption(item) {
			const source = typeof item === 'string' ? { tableName: item } : item || {};
			let tableName = source.tableName || source.moduleName || '';
			let outputKey = source.outputKey || '';
			let category = source.category || FUND_CHANGE_CONTEXT_WILDCARD;
			if (!tableName && source.key) {
				const parsed = parseFundChangeModuleKey(source.key);
				tableName = parsed.tableName;
				outputKey = outputKey || parsed.outputKey;
				category = source.category || parsed.category;
			}
			tableName = this.normalizeTableName(tableName);
			if (!tableName) return null;
			const config = resolveFundChangeTemplateConfig({ outputKey, tableName, category });
			const label = source.label || config?.moduleLabel || this.getTableLabel(tableName);
			return {
				key: createFundChangeModuleKey({ outputKey, tableName, category }),
				outputKey,
				tableName,
				category,
				label,
				config
			};
		},
		getRecordModuleKey(record) {
			const context = record?.__fundChangeContext || record?.fundChangeContext || { tableName: record?.tableName };
			return this.toModuleOption(context)?.key || '';
		},
		getTemplateConfig(moduleOption) {
			return this.toModuleOption(moduleOption)?.config || null;
		},
		getModuleData(moduleOption) {
			const option = this.toModuleOption(moduleOption);
			if (!option) return [];
			const groupedData = this.resultByModuleKey[option.key];
			if (!_.isEmpty(groupedData)) return groupedData;
			if (option.tableName === UNIFIED_TICKET_POINT_MODULE_KEY) {
				return (this.result || []).filter(item => isUnifiedTicketPointTableName(item.tableName) && item.tableName !== UNIFIED_TICKET_POINT_MODULE_KEY);
			}
			return this.resultByTableName[option.tableName] || [];
		},
		getTableLabel(tableName) {
			return tableName === UNIFIED_TICKET_POINT_MODULE_KEY ? UNIFIED_TICKET_POINT_MODULE_LABEL : this.moduleNames[tableName] || tableName;
		},
		getDisplayModuleName(moduleOption) {
			return this.toModuleOption(moduleOption)?.label || '';
		},
		handleCheckModule(moduleOption) {
			const option = this.toModuleOption(moduleOption);
			if (!option) return;
			const data = this.getModuleData(option);
			if (_.isEmpty(data)) {
				this.$message.warning('组件数据有误,ChooseModule');
				return;
			}
			const templateConfig = option.config;
			if (!templateConfig?.component) {
				this.$message.warning(`${option.label}暂无资金变动模板配置`);
				return;
			}
			const Component = templateConfig.component;
			const title = templateConfig.title || `${option.label}变动详情`;
			const width = templateConfig?.width || '1500px';
			const componentProps = { compareData: data, moduleName: option.tableName, summaryData: this.summaryData, summaryModuleLabel: option.label, targetDate: this.targetDate };
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
		<div v-for="item in normalizedModuleList" :key="item.key" class="module-section">
			<div class="module-header" @click="handleCheckModule(item)">
				{{ getDisplayModuleName(item) }}
			</div>
			<div v-if="getTemplateConfig(item) && getModuleData(item).length" class="module-template-wrap">
				<component :is="getTemplateConfig(item).component" :compare-data="getModuleData(item)" :module-name="item.tableName" :summary-data="summaryData" :summary-module-label="item.label" :summary-only="true" :target-date="targetDate" />
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
