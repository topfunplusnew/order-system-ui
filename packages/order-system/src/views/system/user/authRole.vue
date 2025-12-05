<template>
	<div class="app-container">
		<h4 class="form-header h4">基本信息</h4>
		<el-form ref="form" :model="form" label-width="80px">
			<el-row>
				<el-col :span="8" :offset="2">
					<el-form-item label="用户昵称" prop="nickName">
						<el-input v-model="form.nickName" disabled />
					</el-form-item>
				</el-col>
				<el-col :span="8" :offset="2">
					<el-form-item label="登录账号" prop="userName">
						<el-input v-model="form.userName" disabled />
					</el-form-item>
				</el-col>
			</el-row>
		</el-form>

		<h4 class="form-header h4">角色信息</h4>
		<el-table ref="table" v-loading="loading" :row-key="getRowKey" :data="roles.slice((pageNum - 1) * pageSize, pageNum * pageSize)" @row-click="clickRow" @selection-change="handleSelectionChange">
			<el-table-column label="序号" type="index" align="center" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ (pageNum - 1) * pageSize + scope.$index + 1 }}</div>
						<span>{{ (pageNum - 1) * pageSize + scope.$index + 1 }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column type="selection" :reserve-selection="true" width="55"></el-table-column>
			<el-table-column label="角色编号" align="center" prop="roleId" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.roleId }}</div>
						<span>{{ scope.row.roleId }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="角色名称" align="center" prop="roleName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.roleName }}</div>
						<span>{{ scope.row.roleName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="创建时间" align="center" prop="createTime" width="180" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</div>
						<span>
							{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}
						</span>
					</el-tooltip>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" />

		<el-form label-width="100px">
			<el-form-item style="text-align: center; margin-left: -120px; margin-top: 30px">
				<el-button type="primary" @click="submitForm()">提交</el-button>
				<el-button @click="close()">返回</el-button>
			</el-form-item>
		</el-form>
	</div>
</template>

<script>
import { getAuthRole, updateAuthRole } from '@/api/system/user';
import { parseTime } from '../../../utils/ruoyi';

export default {
	name: 'AuthRole',
	data() {
		return {
			// 遮罩层
			loading: true,
			// 分页信息
			total: 0,
			pageNum: 1,
			pageSize: 20,
			// 选中角色编号
			roleIds: [],
			// 角色信息
			roles: [],
			// 用户信息
			form: {}
		};
	},
	created() {
		const userId = this.$route.params && this.$route.params.userId;
		if (userId) {
			this.loading = true;
			getAuthRole(userId).then(response => {
				this.form = response.user;
				this.roles = response.roles;
				this.total = this.roles.length;
				this.$nextTick(() => {
					this.roles.forEach(row => {
						if (row.flag) {
							this.$refs.table.toggleRowSelection(row);
						}
					});
				});
				this.loading = false;
			});
		}
	},
	methods: {
		parseTime,
		/** 单击选中行数据 */
		clickRow(row) {
			this.$refs.table.toggleRowSelection(row);
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.roleIds = selection.map(item => item.roleId);
		},
		// 保存选中的数据编号
		getRowKey(row) {
			return row.roleId;
		},
		/** 提交按钮 */
		submitForm() {
			const userId = this.form.userId;
			const roleIds = this.roleIds.join(',');
			updateAuthRole({ userId: userId, roleIds: roleIds }).then(() => {
				this.$modal.msgSuccess('授权成功');
				this.close();
			});
		},
		/** 关闭按钮 */
		close() {
			const obj = { path: '/users/user' };
			this.$tab.closeOpenPage(obj);
		}
	}
};
</script>
