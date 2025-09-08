<script>
import { moduleNames, TableName } from 'order-system/src/api/tool/enums';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { TypeUtils } from '@/views/dashboard/backuplog/index';
import { filtersFunc } from '@/views/dashboard/backuplog/goodsorder';
import CommonChange from '@/views/dashboard/backuplog/goodsorder/CommonChange.vue';

export default {
	name: 'index',
	components: { DialogWrapper },
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
		 * @param filter 需要对变动信息进行处理的过滤器链
		 */
		handleCheckModule(moduleName, filter) {
			if (!filter) {
				this.$log.warn('handleCheckModule函数执行,未传入过滤器参数');
			}
			if (!moduleName) {
				this.$log.warn('handleCheckModule函数执行,未传入模块名参数');
			}
			if (typeof filter !== 'function') {
				throw new Error('handleCheckModule,函数个体必须为函数类型');
			}
			// 对模块名进行处理
			let tableName = filter(moduleName);
			const data = this.groupByTableName(this.result, filter)[tableName] || [];
			if (data.length > 0) {
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
		/**
		 * 根据tableName分组数据
		 * @param {[]} data 需要进行分组的备份数据
		 * @param {Function} callback 回调函数，用于处理分组后的数据
		 * @returns {{}|*}
		 */
		groupByTableName(data, callback) {
			// 分组函数
			const process = (callback, result, item) => {
				const tableName = callback ? callback(item.tableName) : item.tableName; // 获取当前项的 tableName
				if (!result[tableName]) {
					result[tableName] = []; // 如果分组不存在，初始化一个空数组
				}

				callback ? result[callback(tableName)].push(item) : result[tableName].push(item); // 将当前项添加到对应的分组中
				return result;
			};
			// 如果传入的数据不是数组
			if (TypeUtils.prototype.checkType(data) !== 'Array') {
				this.$log.error('groupByTableName函数发生错误,数据类型错误，请传入数组');
				return;
			}
			// 如果传入的回调函数数组长度为0 那么就是不对数据进行处理 直接分组
			if (!callback) {
				this.$log.warn('groupByTableName函数执行,未传入回调函数');
				// 没有传函数 单纯分组
				return data.reduce((result, item) => {
					return process(undefined, result, item);
				});
			}
			return data.reduce((result, item) => {
				if (typeof callback !== 'function') {
					throw new Error('groupByTableName函数循环函数数组时出现问题,函数个体必须为函数类型');
				}
				result = process(callback, result, item);
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
				<li class="module-item" v-for="(item, index) in moduleList" :key="index" @click="handleCheckModule(item, filtersFunc)">
					{{ moduleNames[item] }}
				</li>
			</ul>
		</div>

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
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
