<script setup>
import { ref, reactive, onMounted, getCurrentInstance } from 'vue';
import { listGift } from '@/api/system/gift';
import { parseTime } from '@/utils/ruoyi';
import { download } from '@/utils/request';

const { proxy } = getCurrentInstance();

// 数据状态
const loading = ref(false);
const giftInventoryList = ref([]);
const queryParams = reactive({
	pageNum: 1,
	pageSize: 20,
	itemName: undefined
});

// 分页数据
const total = ref(0);

// 获取库存数据
const getList = async () => {
	loading.value = true;
	try {
		const response = await listGift(queryParams);
		giftInventoryList.value = response?.rows || response?.data?.rows || [];
		total.value = response?.total || response?.data?.total || 0;
	} catch (error) {
		console.error('获取库存数据失败:', error);
		proxy.$message.error('获取库存数据失败: ' + (error?.message || '未知错误'));
	} finally {
		loading.value = false;
	}
};

// 重置查询
const resetQuery = () => {
	queryParams.itemName = undefined;
	queryParams.pageNum = 1;
	getList();
};

// 搜索
const handleQuery = () => {
	queryParams.pageNum = 1;
	getList();
};

// 分页处理
const handlePagination = (page, pageSize) => {
	queryParams.pageNum = page;
	queryParams.pageSize = pageSize;
	getList();
};

// 导出功能
const handleExport = () => {
	download(
		'/system/gift/export',
		{
			...queryParams
		},
		`gift_inventory_${parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`
	);
};

// 初始化
onMounted(() => {
	getList();
});
</script>

<template>
	<div class="app-container">
		<!-- 查询表单 -->
		<el-form :model="queryParams" ref="queryForm" :inline="true" label-width="80px" size="small">
			<el-form-item label="物品名称" prop="itemName">
				<el-input id="itemName-input" v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter="handleQuery" style="width: 200px" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" @click="handleQuery" aria-label="搜索">搜索</el-button>
				<el-button icon="el-icon-refresh" @click="resetQuery" aria-label="重置">重置</el-button>
				<el-button type="success" icon="el-icon-download" @click="handleExport" aria-label="导出">导出</el-button>
			</el-form-item>
		</el-form>

		<!-- 库存表格 -->
		<el-table v-loading="loading" :data="giftInventoryList" border size="small">
			<el-table-column label="序号" type="index" width="60" align="center" />

			<el-table-column label="物品名称" prop="itemName" min-width="150" show-overflow-tooltip />

			<el-table-column label="原有数量" prop="originalQuantity" width="120" align="center">
				<template #default="scope">
					<span>{{ scope.row.originalQuantity || 0 }}</span>
				</template>
			</el-table-column>

			<el-table-column label="现有数量" prop="currentQuantity" width="120" align="center">
				<template #default="scope">
					<span>{{ scope.row.currentQuantity || 0 }}</span>
				</template>
			</el-table-column>

			<el-table-column label="原有价值" prop="originalValue" width="120" align="center">
				<template #default="scope">
					<span>¥{{ scope.row.originalValue || 0 }}</span>
				</template>
			</el-table-column>

			<el-table-column label="现有价值" prop="currentValue" width="120" align="center">
				<template #default="scope">
					<span>¥{{ scope.row.currentValue || 0 }}</span>
				</template>
			</el-table-column>

			<el-table-column label="最后入库日期" width="160" align="center">
				<template #default="scope">
					<span>{{ scope.row.lastInDate ? parseTime(scope.row.lastInDate, '{y}-{m}-{d}') : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column label="最后出库日期" width="160" align="center">
				<template #default="scope">
					<span>{{ scope.row.lastOutDate ? parseTime(scope.row.lastOutDate, '{y}-{m}-{d}') : '-' }}</span>
				</template>
			</el-table-column>
		</el-table>

		<!-- 空数据提示 -->
		<el-empty v-if="!loading && giftInventoryList.length === 0" description="暂无库存数据" />

		<!-- 分页 -->
		<pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="handlePagination" />
	</div>
</template>

<style scoped lang="scss">
.app-container {
	padding: 20px;
}

.el-table {
	margin-top: 15px;
}
</style>
