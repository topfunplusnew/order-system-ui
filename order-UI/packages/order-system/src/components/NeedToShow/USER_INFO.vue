<script>
import { getUser } from '@/api/system/user';

export default {
	name: 'USER_INFO',
	props: {
		userId: {
			type: [String, Number],
			required: true
		}
	},
	data() {
		return {
			loading: false,
			user: null,
			roles: []
		};
	},
	created() {
		this.fetchUser();
	},
	methods: {
		async fetchUser() {
			try {
				this.loading = true;
				const res = await getUser(this.userId);
				// 兼容接口返回结构 { user, roles } 或直接返回用户对象
				if (res && res.data) {
					this.user = res.data;
					this.roles = Array.isArray(res.roles) ? res.roles : [];
				}
			} catch (e) {
				this.$message.error('获取用户信息失败');
			} finally {
				this.loading = false;
			}
		},
		// 必须存在的方法（可空实现）
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<el-skeleton :loading="loading" animated :rows="6">
			<template #default>
				<el-descriptions v-if="user" title="用户信息" :column="2" size="small" border>
					<el-descriptions-item label="用户ID">{{ user.userId }}</el-descriptions-item>
					<el-descriptions-item label="用户名">{{ user.userName }}</el-descriptions-item>
					<el-descriptions-item label="真实姓名">{{ user.trueName }}</el-descriptions-item>
					<el-descriptions-item label="手机号">{{ user.phonenumber }}</el-descriptions-item>
					<el-descriptions-item label="部门">{{ (user.dept && user.dept.deptName) || '-' }}</el-descriptions-item>
					<el-descriptions-item label="邮箱">{{ user.email || '-' }}</el-descriptions-item>
					<el-descriptions-item label="状态">{{ user.status === '0' ? '正常' : '停用' }}</el-descriptions-item>
					<el-descriptions-item label="最近登录">{{ user.loginDate || '-' }}</el-descriptions-item>
				</el-descriptions>

				<div style="margin-top: 10px">
					<span style="color: #909399; margin-right: 8px">角色：</span>
					<el-tag v-for="r in roles" :key="r.roleId || r.roleName" size="mini" style="margin-right: 6px">{{ r.roleName }}</el-tag>
					<span v-if="!roles || roles.length === 0" style="color: #bbb">无</span>
				</div>
			</template>
		</el-skeleton>
	</div>
</template>

<style scoped></style>
