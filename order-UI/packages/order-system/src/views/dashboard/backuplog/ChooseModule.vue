<script>
import { moduleNames } from 'order-system/src/api/tool/enums';

export default {
	name: 'index',
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
		handleCheckModule() {
			const data = this.groupByTableName(this.result);
		},
		groupByTableName(data) {
			return data.reduce((result, item) => {
				const tableName = item.tableName; // 获取当前项的 tableName
				if (!result[tableName]) {
					result[tableName] = []; // 如果分组不存在，初始化一个空数组
				}
				result[tableName].push(item); // 将当前项添加到对应的分组中
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
