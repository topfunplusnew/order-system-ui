<template>
	<div class="app-container">
		<!-- 示例1：基础用法 -->
		<el-card class="box-card" style="margin-bottom: 20px">
			<div slot="header">
				<span>示例1：基础用法</span>
			</div>
			<el-table
				v-auto-table-width
				:data="tableData"
				border
				style="width: 100%"
			>
				<el-table-column prop="name" label="姓名" />
				<el-table-column prop="age" label="年龄" />
				<el-table-column prop="address" label="地址" />
				<el-table-column prop="email" label="邮箱" />
			</el-table>
		</el-card>

		<!-- 示例2：排除操作列 -->
		<el-card class="box-card" style="margin-bottom: 20px">
			<div slot="header">
				<span>示例2：排除操作列和选择列</span>
			</div>
			<el-table
				v-auto-table-width="{
					excludeColumns: [0, 1]  // 排除选择列和操作列
				}"
				:data="tableData"
				border
				style="width: 100%"
			>
				<el-table-column type="selection" width="50" />
				<el-table-column label="操作" width="200">
					<template slot-scope="scope">
						<el-button size="mini" @click="handleEdit(scope.row)">编辑</el-button>
						<el-button size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
					</template>
				</el-table-column>
				<el-table-column prop="name" label="姓名" />
				<el-table-column prop="age" label="年龄" />
				<el-table-column prop="address" label="地址" />
			</el-table>
		</el-card>

		<!-- 示例3：自定义宽度范围 -->
		<el-card class="box-card">
			<div slot="header">
				<span>示例3：自定义宽度范围</span>
			</div>
			<el-table
				v-auto-table-width="{
					minWidth: 120,
					maxWidth: 400,
					padding: 30
				}"
				:data="tableData"
				border
				style="width: 100%"
			>
				<el-table-column prop="name" label="姓名" />
				<el-table-column prop="age" label="年龄" />
				<el-table-column prop="address" label="地址（这是一个很长的地址字段）" />
				<el-table-column prop="email" label="邮箱地址" />
			</el-table>
		</el-card>
	</div>
</template>

<script>
export default {
	name: 'AutoTableWidthExample',
	data() {
		return {
			tableData: [
				{
					name: '张三',
					age: 25,
					address: '北京市朝阳区xxx街道xxx号',
					email: 'zhangsan@example.com'
				},
				{
					name: '李四',
					age: 30,
					address: '上海市浦东新区xxx路xxx号',
					email: 'lisi@example.com'
				},
				{
					name: '王五',
					age: 28,
					address: '广州市天河区xxx大道xxx号',
					email: 'wangwu@example.com'
				}
			]
		};
	},
	methods: {
		handleEdit(row) {
			this.$message.info(`编辑：${row.name}`);
		},
		handleDelete(row) {
			this.$message.warning(`删除：${row.name}`);
		}
	}
};
</script>

<style scoped>
.app-container {
	padding: 20px;
}
</style>
