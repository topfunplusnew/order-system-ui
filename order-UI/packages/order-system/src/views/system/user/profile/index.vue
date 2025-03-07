<template>
	<div class="app-container">
		<el-row>
			<el-col :xs="24" :sm="6" :md="4" :lg="2">
				<el-avatar shape="square" :size="80" :src="user.avatar" style="margin-top: 10px"></el-avatar>
				<el-button type="primary" style="margin-top: 10px" size="mini">更换头像</el-button>
			</el-col>
			<el-col :xs="24" :sm="18" :md="10" :lg="10">
				<div class="block">
					<el-descriptions border>
						<template #title>
							<div>账号信息</div>
						</template>
						<el-descriptions-item label="用户账号">
							{{ user.userName }}
						</el-descriptions-item>
						<el-descriptions-item label="用户昵称">
							{{ user.nickName }}
						</el-descriptions-item>
						<el-descriptions-item label="用户邮箱">
							{{ user.email }}
						</el-descriptions-item>
						<el-descriptions-item label="性别">
							<el-tag size="mini">{{ user.sex === '1' ? '男' : '女' }}</el-tag>
						</el-descriptions-item>
						<el-descriptions-item label="账号状态">
							{{ user.status === '0' ? '正常' : '停用' }}
						</el-descriptions-item>

						<el-descriptions-item label="银行账号">
							{{ user.bankNo }}
						</el-descriptions-item>
						<el-descriptions-item label="开户银行">
							{{ user.bankName }}
						</el-descriptions-item>
					</el-descriptions>
				</div>
			</el-col>
			<el-col :xs="24" :sm="24" :md="10" :lg="10" :offset-lg="1">
				<el-descriptions title="用户信息" border>
					<el-descriptions-item label="姓名">
						{{ user.trueName }}
					</el-descriptions-item>
					<el-descriptions-item label="手机号">
						{{ user.phonenumber }}
					</el-descriptions-item>
					<el-descriptions-item label="民族">
						{{ user.nation }}
					</el-descriptions-item>
					<el-descriptions-item label="身份证号">
						{{ user.iDCard }}
					</el-descriptions-item>
					<el-descriptions-item label="出生日期">
						{{ user.birthday }}
					</el-descriptions-item>
					<el-descriptions-item label="户籍地址">
						{{ user.domicileAddress }}
					</el-descriptions-item>
					<el-descriptions-item label="居住地址">
						{{ user.residentialAddress }}
					</el-descriptions-item>
					<el-descriptions-item label="紧急联系人">
						{{ user.relationPerson }}
					</el-descriptions-item>
					<el-descriptions-item label="紧急联系人电话">
						{{ user.relationPersonTel }}
					</el-descriptions-item>
				</el-descriptions>
			</el-col>
		</el-row>
		<hr color="#e7e7e7" />
		<el-row>
			<el-col :xs="24" :sm="6" :md="4" :lg="2">
				<el-button type="warning" style="margin-top: 10px" size="mini" @click="updateUserInfo">修改信息</el-button>
			</el-col>
			<el-col :xs="24" :sm="18" :md="10" :lg="10">
				<div class="block">
					<el-descriptions title="岗位和学历信息" border>
						<el-descriptions-item label="岗位">
							{{ user.postName }}
						</el-descriptions-item>
						<el-descriptions-item label="就职状态">
							{{ user.state === '1' ? '在职' : '离职' }}
						</el-descriptions-item>
						<el-descriptions-item label="入职时间">
							{{ user.startDate }}
						</el-descriptions-item>
						<el-descriptions-item label="学历">
							{{ user.education }}
						</el-descriptions-item>
						<el-descriptions-item label="毕业院校">
							{{ user.gradualUniversity }}
						</el-descriptions-item>
						<el-descriptions-item label="专业">
							{{ user.profession }}
						</el-descriptions-item>
						<el-descriptions-item label="毕业时间">
							{{ user.gradualDate }}
						</el-descriptions-item>
					</el-descriptions>
				</div>
			</el-col>
			<el-col :xs="24" :sm="24" :md="10" :lg="10" :offset-lg="1">
				<el-descriptions title="政治面貌和婚姻信息" border>
					<el-descriptions-item label="政治面貌">
						{{ user.politicalStatus }}
					</el-descriptions-item>
					<el-descriptions-item label="婚姻情况">
						{{ user.maritalStatus }}
					</el-descriptions-item>
				</el-descriptions>
			</el-col>
		</el-row>
		<hr color="#e7e7e7" />
		<el-row>
			<el-col :xs="24" :sm="24" :md="16" :lg="8" :offset-md="4" :offset-lg="2">
				<el-row>
					<resetPwd />
				</el-row>
			</el-col>
		</el-row>

		<el-dialog :close-on-click-modal="false" :show-close="false" title="修改个人信息" :visible.sync="open" width="80%" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-row :gutter="10">
					<el-col :span="6">
						<el-row>
							<ShowLabel title="账号信息">
								<template #icon>
									<i class="el-icon-s-tools"></i>
								</template>
							</ShowLabel>
						</el-row>
						<br />
						<el-row>
							<el-form-item label="用户昵称" prop="nickName">
								<el-input v-model="form.nickName" placeholder="请输入用户昵称" maxlength="30" />
							</el-form-item>
							<el-form-item v-if="form.userId == undefined" label="用户名称" prop="userName">
								<el-input v-model="form.userName" placeholder="请输入用户名称" maxlength="30" />
							</el-form-item>
							<el-form-item v-if="form.userId == undefined" label="用户密码" prop="password">
								<el-input v-model="form.password" placeholder="请输入用户密码" type="password" maxlength="20" show-password />
							</el-form-item>
							<el-form-item label="用户性别">
								<el-select v-model="form.sex" placeholder="请选择性别">
									<el-option v-for="dict in dict.type.sys_user_sex" :key="dict.value" :label="dict.label" :value="dict.value"></el-option>
								</el-select>
							</el-form-item>
							<el-form-item label="角色">
								<el-select v-model="form.roleIds" multiple placeholder="请选择角色">
									<el-option v-for="item in roleOptions" :key="item.roleId" :label="item.roleName" :value="item.roleId" :disabled="item.status == 1"></el-option>
								</el-select>
							</el-form-item>
							<el-form-item label="归属部门" prop="deptId">
								<treeselect v-model="form.deptId" :options="deptOptions" :show-count="true" placeholder="请选择归属部门" />
							</el-form-item>
							<el-form-item label="邮箱" prop="email">
								<el-input v-model="form.email" placeholder="请输入邮箱" maxlength="50" />
							</el-form-item>
							<el-form-item label="状态">
								<el-radio-group v-model="form.status">
									<el-radio v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.value">
										{{ dict.label }}
									</el-radio>
								</el-radio-group>
							</el-form-item>
						</el-row>
					</el-col>
					<el-col :span="6">
						<el-row>
							<ShowLabel title="个人信息">
								<template #icon>
									<i class="el-icon-s-custom"></i>
								</template>
							</ShowLabel>
						</el-row>
						<br />
						<el-row>
							<el-form-item label="真实姓名">
								<el-input v-model="form.trueName" placeholder="请输入真实姓名" />
							</el-form-item>
							<el-form-item label="手机号码" prop="phonenumber">
								<el-input v-model="form.phonenumber" placeholder="请输入手机号码" maxlength="11" />
							</el-form-item>
							<el-form-item label="身份证号码">
								<el-input v-model="form.iDCard" placeholder="请输入身份证号码" />
							</el-form-item>
							<el-form-item label="开户银行">
								<el-input v-model="form.bankName" placeholder="请输入开户银行" />
							</el-form-item>
							<el-form-item label="银行账号">
								<el-input v-model="form.bankNo" placeholder="请输入银行账号" />
							</el-form-item>
							<el-form-item label="出生日期">
								<el-date-picker v-model="form.birthday" type="datetime" placeholder="选择出生日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="民族">
								<el-input v-model="form.nation" placeholder="请输入民族" />
							</el-form-item>
						</el-row>
					</el-col>
					<el-col :span="6">
						<el-row>
							<ShowLabel title="学历及入职信息">
								<template #icon>
									<i class="el-icon-notebook-2"></i>
								</template>
							</ShowLabel>
						</el-row>
						<br />
						<el-row>
							<el-form-item label="学历">
								<el-input v-model="form.education" placeholder="请输入学历" />
							</el-form-item>
							<el-form-item label="毕业院校">
								<el-input v-model="form.gradualUniversity" placeholder="请输入毕业院校" />
							</el-form-item>
							<el-form-item label="专业">
								<el-input v-model="form.profession" placeholder="请输入专业" />
							</el-form-item>
							<el-form-item label="毕业时间">
								<el-date-picker v-model="form.gradualDate" type="datetime" placeholder="选择毕业时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="岗位">
								<el-input v-model="form.postName" placeholder="请输入岗位" />
							</el-form-item>
							<el-form-item label="在职状态">
								<el-radio v-model="form.state" label="在职">在职</el-radio>
								<el-radio v-model="form.state" label="离职">离职</el-radio>
							</el-form-item>
							<el-form-item label="入职时间">
								<el-date-picker v-model="form.startDate" type="datetime" placeholder="选择入职时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="备注">
								<el-input v-model="form.remark" type="textarea" placeholder="请输入内容"></el-input>
							</el-form-item>
						</el-row>
					</el-col>
					<el-col :span="6">
						<el-row>
							<ShowLabel title="其他信息">
								<template #icon>
									<i class="el-icon-s-unfold"></i>
								</template>
							</ShowLabel>
						</el-row>
						<br />
						<el-row>
							<el-form-item label="政治面貌">
								<el-input v-model="form.politicalStatus" placeholder="请输入政治面貌" />
							</el-form-item>
							<el-form-item label="婚姻状况">
								<el-input v-model="form.maritalStatus" placeholder="请输入婚姻状况" />
							</el-form-item>
							<el-form-item label="户籍地址">
								<el-input v-model="form.domicileAddress" placeholder="请输入户籍地址" />
							</el-form-item>
							<el-form-item label="居住地址">
								<el-input v-model="form.residentialAddress" placeholder="请输入居住地址" />
							</el-form-item>
							<el-form-item label="紧急联系人">
								<el-input v-model="form.relationPerson" placeholder="请输入紧急联系人" />
							</el-form-item>
							<el-form-item label="紧急联系人电话">
								<el-input v-model="form.relationPersonTel" placeholder="请输入紧急联系人电话" />
							</el-form-item>
							<el-form-item label="关系">
								<el-input v-model="form.relationship" placeholder="请输入关系" />
							</el-form-item>
						</el-row>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { getUserProfile } from '@/api/system/user';
import Treeselect from '@riophae/vue-treeselect';
import '@riophae/vue-treeselect/dist/vue-treeselect.css';
import { deptTreeSelect, getUser, updateUser } from '../../../../api/system/user';
import ShowLabel from '../../../../components/ShowLabel.vue';
import { getToken } from '../../../../utils/auth';
import resetPwd from './resetPwd';

export default {
	name: 'Profile',
	components: {
		ShowLabel,
		Treeselect,
		resetPwd
	},
	dicts: ['sys_normal_disable'],
	data() {
		return {
			user: {},
			roleGroup: {},
			postGroup: {},
			open: false,
			// 部门名称
			deptName: undefined,
			// 默认密码
			initPassword: undefined,
			deptOptions: undefined,
			roleOptions: [],
			// 表单参数
			form: {},
			// 用户导入参数
			upload: {
				// 是否显示弹出层（用户导入）
				open: false,
				// 弹出层标题（用户导入）
				title: '',
				// 是否禁用上传
				isUploading: false,
				// 是否更新已经存在的用户数据
				updateSupport: 0,
				// 设置上传的请求头部
				headers: { Authorization: 'Bearer ' + getToken() },
				// 上传的地址
				url: process.env.VUE_APP_BASE_API + '/system/user/importData'
			},
			// 表单校验
			rules: {
				userName: [
					{
						required: true,
						message: '用户名称不能为空',
						trigger: 'blur'
					},
					{
						min: 2,
						max: 20,
						message: '用户名称长度必须介于 2 和 20 之间',
						trigger: 'blur'
					}
				],
				nickName: [
					{
						required: true,
						message: '用户昵称不能为空',
						trigger: 'blur'
					}
				],
				password: [
					{
						required: true,
						message: '用户密码不能为空',
						trigger: 'blur'
					},
					{
						min: 5,
						max: 20,
						message: '用户密码长度必须介于 5 和 20 之间',
						trigger: 'blur'
					},
					{
						pattern: /^[^<>"'|\\]+$/,
						// message: '不能包含非法字符：< > " \' \\\ |',
						trigger: 'blur'
					}
				],
				email: [
					{
						type: 'email',
						message: '请输入正确的邮箱地址',
						trigger: ['blur', 'change']
					}
				],
				phonenumber: [
					{
						pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
						message: '请输入正确的手机号码',
						trigger: 'blur'
					}
				]
			},
			checkUserDialogVisible: false,
			currentUserInfo: {}
		};
	},
	created() {
		this.getUser();
		this.getDeptTree();
	},
	methods: {
		getUser() {
			getUserProfile().then(response => {
				this.user = response.data;
				this.roleGroup = response.roleGroup;
				this.roleOptions = response.roles;
				this.postGroup = response.postGroup;
			});
		},
		updateUserInfo() {
			this.reset();
			getUser(this.user.userId).then(res => {
				this.form = res.data;
				this.open = true;
			});
		},
		submitForm: function () {
			this.$refs['form'].validate(valid => {
				if (valid) {
					updateUser(this.form).then(() => {
						this.$modal.msgSuccess('修改成功');
						this.open = false;
						this.getList();
					});
				}
			});
		},
		cancel() {
			this.open = false;
			this.reset();
		},
		reset() {
			this.form = {
				userId: undefined,
				deptId: undefined,
				userName: undefined,
				nickName: undefined,
				password: undefined,
				phonenumber: undefined,
				email: undefined,
				sex: undefined,
				status: '0',
				remark: undefined,
				postIds: [],
				roleIds: [],
				trueName: null,
				postName: null,
				state: null,
				startDate: null,
				iDCard: null,
				birthday: null,
				nation: null,
				politicalStatus: null,
				maritalStatus: null,
				domicileAddress: null,
				residentialAddress: null,
				relationPerson: null,
				relationPersonTel: null,
				relationship: null,
				education: null,
				gradualUniversity: null,
				profession: null,
				gradualDate: null,
				bankName: null,
				bankNo: null
			};
			this.resetForm('form');
		},
		/** 查询部门下拉树结构 */
		getDeptTree() {
			deptTreeSelect().then(response => {
				this.deptOptions = response.data;
			});
		}
	}
};
</script>

<!--    <el-row :gutter="10">-->
<!--      <el-col :span="6" :xs="24">-->
<!--        <el-card class="box-card">-->
<!--          <el-row>-->
<!--            <span>学历信息</span>-->
<!--          </el-row>-->
<!--          <div>-->
<!--            <ul class="list-group list-group-striped">-->
<!--              <li class="list-group-item">-->
<!--                用户名称-->
<!--                <div class="pull-right">{{ user.userName }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                手机号码-->
<!--                <div class="pull-right">{{ user.phonenumber }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                用户邮箱-->
<!--                <div class="pull-right">{{ user.email }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                岗位-->
<!--                <div class="pull-right">{{ user.postName }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                所属角色-->
<!--                <div class="pull-right">{{ roleGroup }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                创建日期-->
<!--                <div class="pull-right">{{ user.createTime }}</div>-->
<!--              </li>-->
<!--            </ul>-->
<!--          </div>-->
<!--        </el-card>-->
<!--      </el-col>-->
<!--      <el-col :span="6" :xs="24">-->
<!--        <el-card class="box-card">-->
<!--          <div slot="header" class="clearfix">-->
<!--            <span>个人信息</span>-->
<!--          </div>-->
<!--          <div>-->
<!--            <div class="text-center">-->
<!--              <userAvatar/>-->
<!--            </div>-->
<!--            <ul class="list-group list-group-striped">-->
<!--              <li class="list-group-item">-->
<!--                <svg-icon icon-class="user"/>-->
<!--                用户名称-->
<!--                <div class="pull-right">{{ user.userName }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                <svg-icon icon-class="phone"/>-->
<!--                手机号码-->
<!--                <div class="pull-right">{{ user.phonenumber }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                <svg-icon icon-class="email"/>-->
<!--                用户邮箱-->
<!--                <div class="pull-right">{{ user.email }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                <svg-icon icon-class="tree"/>-->
<!--                所属部门-->
<!--                <div class="pull-right" v-if="user.dept">{{ user.dept.deptName }} / {{ postGroup }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                <svg-icon icon-class="peoples"/>-->
<!--                所属角色-->
<!--                <div class="pull-right">{{ roleGroup }}</div>-->
<!--              </li>-->
<!--              <li class="list-group-item">-->
<!--                <svg-icon icon-class="date"/>-->
<!--                创建日期-->
<!--                <div class="pull-right">{{ user.createTime }}</div>-->
<!--              </li>-->
<!--            </ul>-->
<!--          </div>-->
<!--        </el-card>-->
<!--      </el-col>-->
<!--      <el-col :span="6" :xs="24">-->
<!--        <el-card>-->
<!--          <div slot="header" class="clearfix">-->
<!--            <span>基本资料</span>-->
<!--          </div>-->
<!--          <el-tabs v-model="activeTab">-->
<!--            <el-tab-pane label="基本资料" name="userinfo">-->
<!--              <userInfo :user="user"/>-->
<!--            </el-tab-pane>-->
<!--            <el-tab-pane label="修改密码" name="resetPwd">-->
<!--              <resetPwd/>-->
<!--            </el-tab-pane>-->
<!--          </el-tabs>-->
<!--        </el-card>-->
<!--      </el-col>-->
<!--      &lt;!&ndash;      <el-row>&ndash;&gt;-->
<!--      &lt;!&ndash;        <el-col :span="6">&ndash;&gt;-->
<!--      &lt;!&ndash;          <el-descriptions title="用户信息">&ndash;&gt;-->
<!--      &lt;!&ndash;            <el-descriptions-item label="用户名">kooriookami</el-descriptions-item>&ndash;&gt;-->
<!--      &lt;!&ndash;            <el-descriptions-item label="手机号">18100000000</el-descriptions-item>&ndash;&gt;-->
<!--      &lt;!&ndash;            <el-descriptions-item label="居住地">苏州市</el-descriptions-item>&ndash;&gt;-->
<!--      &lt;!&ndash;            <el-descriptions-item label="备注">&ndash;&gt;-->
<!--      &lt;!&ndash;              <el-tag size="mini">学校</el-tag>&ndash;&gt;-->
<!--      &lt;!&ndash;            </el-descriptions-item>&ndash;&gt;-->
<!--      &lt;!&ndash;            <el-descriptions-item label="联系地址">江苏省苏州市吴中区吴中大道 1188 号</el-descriptions-item>&ndash;&gt;-->
<!--      &lt;!&ndash;          </el-descriptions>&ndash;&gt;-->
<!--      &lt;!&ndash;        </el-col>&ndash;&gt;-->
<!--      &lt;!&ndash;        <el-col :span="6">&ndash;&gt;-->
<!--      &lt;!&ndash;          <UserProfile :user-info="user">&ndash;&gt;-->
<!--      &lt;!&ndash;            <template #check>&ndash;&gt;-->
<!--      &lt;!&ndash;              <el-button type="primary">&ndash;&gt;-->
<!--      &lt;!&ndash;                查看个人信息&ndash;&gt;-->
<!--      &lt;!&ndash;              </el-button>&ndash;&gt;-->
<!--      &lt;!&ndash;            </template>&ndash;&gt;-->
<!--      &lt;!&ndash;            <template #edit>&ndash;&gt;-->
<!--      &lt;!&ndash;              <el-button>&ndash;&gt;-->
<!--      &lt;!&ndash;                修改个人信息&ndash;&gt;-->
<!--      &lt;!&ndash;              </el-button>&ndash;&gt;-->
<!--      &lt;!&ndash;            </template>&ndash;&gt;-->
<!--      &lt;!&ndash;          </UserProfile>&ndash;&gt;-->
<!--      &lt;!&ndash;        </el-col>&ndash;&gt;-->
<!--      &lt;!&ndash;      </el-row>&ndash;&gt;-->
<!--    </el-row>-->
