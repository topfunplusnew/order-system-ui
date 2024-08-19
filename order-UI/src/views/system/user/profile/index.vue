<template>
  <div class="app-container">
    <el-row :gutter="10">
      <el-col :span="6" :xs="24">
        <el-card class="box-card">
          <el-row>
            <span>学历信息</span>
          </el-row>
          <div>
            <ul class="list-group list-group-striped">
              <li class="list-group-item">
                用户名称
                <div class="pull-right">{{ user.userName }}</div>
              </li>
              <li class="list-group-item">
                手机号码
                <div class="pull-right">{{ user.phonenumber }}</div>
              </li>
              <li class="list-group-item">
                用户邮箱
                <div class="pull-right">{{ user.email }}</div>
              </li>
              <li class="list-group-item">
                岗位
                <div class="pull-right">{{ user.postName }}</div>
              </li>
              <li class="list-group-item">
                所属角色
                <div class="pull-right">{{ roleGroup }}</div>
              </li>
              <li class="list-group-item">
                创建日期
                <div class="pull-right">{{ user.createTime }}</div>
              </li>
            </ul>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" :xs="24">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>个人信息</span>
          </div>
          <div>
            <div class="text-center">
              <userAvatar/>
            </div>
            <ul class="list-group list-group-striped">
              <li class="list-group-item">
                <svg-icon icon-class="user"/>
                用户名称
                <div class="pull-right">{{ user.userName }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="phone"/>
                手机号码
                <div class="pull-right">{{ user.phonenumber }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="email"/>
                用户邮箱
                <div class="pull-right">{{ user.email }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="tree"/>
                所属部门
                <div class="pull-right" v-if="user.dept">{{ user.dept.deptName }} / {{ postGroup }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="peoples"/>
                所属角色
                <div class="pull-right">{{ roleGroup }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="date"/>
                创建日期
                <div class="pull-right">{{ user.createTime }}</div>
              </li>
            </ul>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" :xs="24">
        <el-card>
          <div slot="header" class="clearfix">
            <span>基本资料</span>
          </div>
          <el-tabs v-model="activeTab">
            <el-tab-pane label="基本资料" name="userinfo">
              <userInfo :user="user"/>
            </el-tab-pane>
            <el-tab-pane label="修改密码" name="resetPwd">
              <resetPwd/>
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>
      <!--      <el-row>-->
      <!--        <el-col :span="6">-->
      <!--          <el-descriptions title="用户信息">-->
      <!--            <el-descriptions-item label="用户名">kooriookami</el-descriptions-item>-->
      <!--            <el-descriptions-item label="手机号">18100000000</el-descriptions-item>-->
      <!--            <el-descriptions-item label="居住地">苏州市</el-descriptions-item>-->
      <!--            <el-descriptions-item label="备注">-->
      <!--              <el-tag size="small">学校</el-tag>-->
      <!--            </el-descriptions-item>-->
      <!--            <el-descriptions-item label="联系地址">江苏省苏州市吴中区吴中大道 1188 号</el-descriptions-item>-->
      <!--          </el-descriptions>-->
      <!--        </el-col>-->
      <!--        <el-col :span="6">-->
      <!--          <UserProfile :user-info="user">-->
      <!--            <template #check>-->
      <!--              <el-button type="primary">-->
      <!--                查看个人信息-->
      <!--              </el-button>-->
      <!--            </template>-->
      <!--            <template #edit>-->
      <!--              <el-button>-->
      <!--                修改个人信息-->
      <!--              </el-button>-->
      <!--            </template>-->
      <!--          </UserProfile>-->
      <!--        </el-col>-->
      <!--      </el-row>-->
    </el-row>
  </div>
</template>

<script>
import userAvatar from "./userAvatar";
import userInfo from "./userInfo";
import resetPwd from "./resetPwd";
import {getUserProfile} from "@/api/system/user";
import UserProfile from "@/views/system/user/profile/UserProfile.vue";

export default {
  name: "Profile",
  components: {UserProfile, userAvatar, userInfo, resetPwd},
  data() {
    return {
      user: {},
      roleGroup: {},
      postGroup: {},
      activeTab: "userinfo"
    };
  },
  created() {
    this.getUser();
  },
  methods: {
    getUser() {
      getUserProfile().then(response => {
        this.user = response.data;
        this.roleGroup = response.roleGroup;
        this.postGroup = response.postGroup;
      });
    }
  }
};
</script>


