<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!--      &lt;!&ndash;部门数据&ndash;&gt;-->
      <!--      <el-col :span="4" :xs="24">-->
      <!--        <div class="head-container">-->
      <!--          <el-input-->
      <!--            v-model="deptName"-->
      <!--            placeholder="请输入部门名称"-->
      <!--            clearable-->
      <!--            size="small"-->
      <!--            prefix-icon="el-icon-search"-->
      <!--            style="margin-bottom: 20px"-->
      <!--          />-->
      <!--        </div>-->
      <!--        <div class="head-container">-->
      <!--          <el-tree-->
      <!--            :data="deptOptions"-->
      <!--            :props="defaultProps"-->
      <!--            :expand-on-click-node="false"-->
      <!--            :filter-node-method="filterNode"-->
      <!--            ref="tree"-->
      <!--            node-key="id"-->
      <!--            default-expand-all-->
      <!--            highlight-current-->
      <!--            @node-click="handleNodeClick"-->
      <!--          />-->
      <!--        </div>-->
      <!--      </el-col>-->
      <!--用户数据-->
      <el-col :span="24" :xs="24">
        <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch"
                 label-width="68px">
          <el-form-item label="用户名称" prop="userName">
            <el-input
              v-model="queryParams.userName"
              placeholder="请输入用户名称"
              clearable
              style="width: 240px"
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
          <el-form-item label="手机号码" prop="phonenumber">
            <el-input
              v-model="queryParams.phonenumber"
              placeholder="请输入手机号码"
              clearable
              style="width: 240px"
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-select
              v-model="queryParams.status"
              placeholder="用户状态"
              clearable
              style="width: 240px"
            >
              <el-option
                v-for="dict in dict.type.sys_normal_disable"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="创建时间">
            <el-date-picker
              v-model="dateRange"
              style="width: 240px"
              value-format="yyyy-MM-dd"
              type="daterange"
              range-separator="-"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
            ></el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button
              type="primary"
              plain
              icon="el-icon-plus"
              size="mini"
              @click="handleAdd"
              v-hasPermi="['system:user:add']"
            >新增用户信息
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="success"
              plain
              icon="el-icon-edit"
              size="mini"
              :disabled="single"
              @click="handleUpdate"
              v-hasPermi="['system:user:edit']"
            >修改
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="danger"
              plain
              icon="el-icon-delete"
              size="mini"
              :disabled="multiple"
              @click="handleDelete"
              v-hasPermi="['system:user:remove']"
            >删除
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="info"
              plain
              icon="el-icon-upload2"
              size="mini"
              @click="handleImport"
              v-hasPermi="['system:user:import']"
            >导入
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="warning"
              plain
              icon="el-icon-download"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:user:export']"
            >导出
            </el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns"></right-toolbar>
        </el-row>

        <el-table border v-loading="loading" :data="userList" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="50" align="center"/>
          <el-table-column label="用户编号" align="center" key="userId" prop="userId" v-if="columns[0].visible"/>
          <el-table-column label="用户名称" align="center" key="userName" prop="userName"
                           :show-overflow-tooltip="true" v-if="columns[1].visible"/>
          <el-table-column label="用户昵称" align="center" key="nickName" prop="nickName"
                           :show-overflow-tooltip="true" v-if="columns[2].visible"/>
          <el-table-column label="真实姓名" align="center" key="nickName" prop="trueName"
                           :show-overflow-tooltip="true" v-if="columns[3].visible"/>
          <el-table-column label="岗位" align="center" key="deptName" prop="postName"
                           :show-overflow-tooltip="true" v-if="columns[4].visible"/>
          <el-table-column label="手机号码" align="center" key="phonenumber" prop="phonenumber"
                           width="120" v-if="columns[5].visible"/>
          <el-table-column label="就职状态" align="center" key="phonenumber" prop="state"
                           width="120" v-if="columns[6].visible"/>
          <el-table-column label="入职时间" align="center" key="phonenumber" prop="startDate"
                           width="120" v-if="columns[7].visible"/>
          <el-table-column label="身份证号码" align="center" key="phonenumber" prop="iDCard"
                           width="120" v-if="columns[8].visible"/>
          <el-table-column label="联系电话" align="center" key="phonenumber" prop="phonenumber"
                           width="120" v-if="columns[9].visible"/>
          <el-table-column label="性别" align="center" key="phonenumber" prop="sex"
                           width="120" v-if="columns[10].visible"/>
          <el-table-column label="出生日期" align="center" key="phonenumber" prop="birthday"
                           width="120" v-if="columns[11].visible"/>
          <el-table-column label="民族" align="center" key="phonenumber" prop="nation"
                           width="120" v-if="columns[12].visible"/>
          <el-table-column label="政治面貌" align="center" key="phonenumber" prop="politicalStatus"
                           width="120" v-if="columns[13].visible"/>
          <el-table-column label="婚姻状况" align="center" key="phonenumber" prop="maritalStatus"
                           width="120" v-if="columns[14].visible"/>
          <el-table-column label="户籍地址" align="center" key="phonenumber" prop="domicileAddress"
                           width="120" v-if="columns[15].visible"/>
          <el-table-column label="居住地址" align="center" key="phonenumber" prop="residentialAddress"
                           width="120" v-if="columns[16].visible"/>
          <el-table-column label="紧急联系人" align="center" key="phonenumber" prop="relationPerson"
                           width="120" v-if="columns[17].visible"/>
          <el-table-column label="紧急联系人电话" align="center" key="phonenumber" prop="relationPersonTel"
                           width="120" v-if="columns[18].visible"/>
          <el-table-column label="关系" align="center" key="phonenumber" prop="relationship"
                           width="120" v-if="columns[19].visible"/>
          <el-table-column label="学历" align="center" key="phonenumber" prop="education"
                           width="120" v-if="columns[20].visible"/>
          <el-table-column label="毕业院校" align="center" key="phonenumber" prop="gradualUniversity"
                           width="120" v-if="columns[21].visible"/>
          <el-table-column label="专业" align="center" key="phonenumber" prop="profession"
                           width="120" v-if="columns[22].visible"/>
          <el-table-column label="毕业时间" align="center" key="phonenumber" prop="gradualDate"
                           width="120" v-if="columns[23].visible"/>
          <el-table-column label="开户银行" align="center" key="phonenumber" prop="bankName"
                           width="120" v-if="columns[24].visible"/>
          <el-table-column label="银行账号" align="center" key="phonenumber" prop="bankNo"
                           width="120" v-if="columns[25].visible"/>
          <el-table-column label="状态" align="center" key="status" v-if="columns[26].visible">
            <template slot-scope="scope">
              <el-switch
                v-model="scope.row.status"
                active-value="0"
                inactive-value="1"
                @change="handleStatusChange(scope.row)"
              ></el-switch>
            </template>
          </el-table-column>
          <el-table-column label="创建时间" align="center" prop="createTime" width="160" v-if="columns[27].visible">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.createTime) }}</span>
            </template>
          </el-table-column>
          <!-- 操作栏-->
          <el-table-column
            label="操作"
            align="center"
            width="200"
            class-name="small-padding fixed-width"
            fixed="right"
          >
            <template slot-scope="scope" v-if="scope.row.userId !== 1">
              <el-button
                size="mini"
                type="warning"
                @click="checkRowInfo(scope.row)"
                v-hasPermi="['system:user:edit']"
              >查看用户信息
              </el-button>
              <el-button
                size="mini"
                type="primary"
                @click="handleUpdate(scope.row)"
                v-hasPermi="['system:user:edit']"
              >修改
              </el-button>
              <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.row)"
                v-hasPermi="['system:user:remove']"
              >删除
              </el-button>
              <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)"
                           v-hasPermi="['system:user:resetpwd', 'system:user:edit']">
                <el-button size="mini" type="warning">更多</el-button>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item command="handleResetPwd" icon="el-icon-key"
                                    v-hasPermi="['system:user:resetpwd']">重置密码
                  </el-dropdown-item>
                  <el-dropdown-item command="handleAuthRole" icon="el-icon-circle-check"
                                    v-hasPermi="['system:user:edit']">分配角色
                  </el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
            </template>
          </el-table-column>
        </el-table>

        <pagination
          v-show="total>0"
          :total="total"
          :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize"
          @pagination="getList"
        />
      </el-col>
    </el-row>

    <!-- 添加或修改用户配置对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="80%" append-to-body>
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
            <br/>
            <el-row>
              <el-form-item label="用户昵称" prop="nickName">
                <el-input v-model="form.nickName" placeholder="请输入用户昵称" maxlength="30"/>
              </el-form-item>
              <el-form-item v-if="form.userId == undefined" label="用户名称" prop="userName">
                <el-input v-model="form.userName" placeholder="请输入用户名称" maxlength="30"/>
              </el-form-item>
              <el-form-item v-if="form.userId == undefined" label="用户密码" prop="password">
                <el-input v-model="form.password" placeholder="请输入用户密码" type="password" maxlength="20"
                          show-password/>
              </el-form-item>
              <el-form-item label="用户性别">
                <el-select v-model="form.sex" placeholder="请选择性别">
                  <el-option
                    v-for="dict in dict.type.sys_user_sex"
                    :key="dict.value"
                    :label="dict.label"
                    :value="dict.value"
                  ></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="角色">
                <el-select v-model="form.roleIds" multiple placeholder="请选择角色">
                  <el-option
                    v-for="item in roleOptions"
                    :key="item.roleId"
                    :label="item.roleName"
                    :value="item.roleId"
                    :disabled="item.status == 1"
                  ></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="归属部门" prop="deptId">
                <treeselect v-model="form.deptId" :options="deptOptions" :show-count="true"
                            placeholder="请选择归属部门"/>
              </el-form-item>
              <el-form-item label="邮箱" prop="email">
                <el-input v-model="form.email" placeholder="请输入邮箱" maxlength="50"/>
              </el-form-item>
              <el-form-item label="状态">
                <el-radio-group v-model="form.status">
                  <el-radio
                    v-for="dict in dict.type.sys_normal_disable"
                    :key="dict.value"
                    :label="dict.value"
                  >{{ dict.label }}
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
            <br/>
            <el-row>
              <el-form-item label="真实姓名">
                <el-input v-model="form.trueName" placeholder="请输入真实姓名"/>
              </el-form-item>
              <el-form-item label="手机号码" prop="phonenumber">
                <el-input v-model="form.phonenumber" placeholder="请输入手机号码" maxlength="11"/>
              </el-form-item>
              <el-form-item label="身份证号码">
                <el-input v-model="form.iDCard" placeholder="请输入身份证号码"/>
              </el-form-item>
              <el-form-item label="开户银行">
                <el-input v-model="form.bankName" placeholder="请输入开户银行"/>
              </el-form-item>
              <el-form-item label="银行账号">
                <el-input v-model="form.bankNo" placeholder="请输入银行账号"/>
              </el-form-item>
              <el-form-item label="出生日期">
                <el-date-picker
                  v-model="form.birthday"
                  type="date"
                  placeholder="选择出生日期"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="民族">
                <el-input v-model="form.nation" placeholder="请输入民族"/>
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
            <br/>
            <el-row>
              <el-form-item label="学历">
                <el-input v-model="form.education" placeholder="请输入学历"/>
              </el-form-item>
              <el-form-item label="毕业院校">
                <el-input v-model="form.gradualUniversity" placeholder="请输入毕业院校"/>
              </el-form-item>
              <el-form-item label="专业">
                <el-input v-model="form.profession" placeholder="请输入专业"/>
              </el-form-item>
              <el-form-item label="毕业时间">
                <el-date-picker
                  v-model="form.gradualDate"
                  type="date"
                  placeholder="选择毕业时间"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="岗位">
                <el-input v-model="form.postName" placeholder="请输入岗位"/>
              </el-form-item>
              <el-form-item label="在职状态">
                <el-radio v-model="form.state" label="在职">在职</el-radio>
                <el-radio v-model="form.state" label="离职">离职</el-radio>
              </el-form-item>
              <el-form-item label="入职时间">
                <el-date-picker
                  v-model="form.startDate"
                  type="date"
                  placeholder="选择入职时间"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
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
            <br/>
            <el-row>
              <el-form-item label="政治面貌">
                <el-input v-model="form.politicalStatus" placeholder="请输入政治面貌"/>
              </el-form-item>
              <el-form-item label="婚姻状况">
                <el-input v-model="form.maritalStatus" placeholder="请输入婚姻状况"/>
              </el-form-item>
              <el-form-item label="户籍地址">
                <el-input v-model="form.domicileAddress" placeholder="请输入户籍地址"/>
              </el-form-item>
              <el-form-item label="居住地址">
                <el-input v-model="form.residentialAddress" placeholder="请输入居住地址"/>
              </el-form-item>
              <el-form-item label="紧急联系人">
                <el-input v-model="form.relationPerson" placeholder="请输入紧急联系人"/>
              </el-form-item>
              <el-form-item label="紧急联系人电话">
                <el-input v-model="form.relationPersonTel" placeholder="请输入紧急联系人电话"/>
              </el-form-item>
              <el-form-item label="关系">
                <el-input v-model="form.relationship" placeholder="请输入关系"/>
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

    <!-- 用户导入对话框 -->
    <el-dialog :title="upload.title" :visible.sync="upload.open" width="400px" append-to-body>
      <el-upload
        ref="upload"
        :limit="1"
        accept=".xlsx, .xls"
        :headers="upload.headers"
        :action="upload.url + '?updateSupport=' + upload.updateSupport"
        :disabled="upload.isUploading"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        :auto-upload="false"
        drag
      >
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">
          <div class="el-upload__tip" slot="tip">
            <el-checkbox v-model="upload.updateSupport"/>
            是否更新已经存在的用户数据
          </div>
          <span>仅允许导入xls、xlsx格式文件。</span>
          <el-link type="primary" :underline="false" style="font-size:12px;vertical-align: baseline;"
                   @click="importTemplate">下载模板
          </el-link>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>


    <!--    查看个人信息-->
    <el-dialog
      title="用户信息查看"
      :visible.sync="checkUserDialogVisible"
      width="30%">
      <el-descriptions class="margin-top" title="用户信息查看" :column="3" border>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            用户名
          </template>
          {{ currentUserInfo.userName }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-mobile-phone"></i>
            手机号
          </template>
          {{ currentUserInfo.phonenumber }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-location-outline"></i>
            用户性别
          </template>
          {{ currentUserInfo.sex }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-tickets"></i>
            出生日期
          </template>
          {{ currentUserInfo.birthday }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            民族
          </template>
          {{ currentUserInfo.nation }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            政治面貌
          </template>
          {{ currentUserInfo.politicalStatus }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            婚姻状况
          </template>
          {{ currentUserInfo.maritalStatus }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            户籍地址
          </template>
          {{ currentUserInfo.domicileAddress }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            居住地址
          </template>
          {{ currentUserInfo.residentialAddress }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            紧急联系人
          </template>
          {{ currentUserInfo.relationPerson }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            紧急联系人电话
          </template>
          {{ currentUserInfo.relationPersonTel }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            关系
          </template>
          {{ currentUserInfo.relationship }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            学历
          </template>
          {{ currentUserInfo.education }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            毕业院校
          </template>
          {{ currentUserInfo.gradualUniversity }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            专业
          </template>
          {{ currentUserInfo.profession }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            毕业时间
          </template>
          {{ currentUserInfo.gradualDate }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            开户银行
          </template>
          {{ currentUserInfo.bankName }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-office-building"></i>
            开户银行账号
          </template>
          {{ currentUserInfo.bankNo }}
        </el-descriptions-item>
      </el-descriptions>
      <span slot="footer" class="dialog-footer">
    <el-button @click="checkUserDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="checkUserDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  listUser,
  getUser,
  delUser,
  addUser,
  updateUser,
  resetUserPwd,
  changeUserStatus,
  deptTreeSelect
} from "@/api/system/user";
import {getToken} from "@/utils/auth";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";
import {parseTime} from "../../../utils/ruoyi";
import ShowLabel from "@/components/ShowLabel.vue";

export default {
  name: "User",
  dicts: ['sys_normal_disable', 'sys_user_sex'],
  components: {ShowLabel, Treeselect},
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 用户表格数据
      userList: null,
      // 弹出层标题
      title: "",
      // 部门树选项
      deptOptions: undefined,
      // 是否显示弹出层
      open: false,
      // 部门名称
      deptName: undefined,
      // 默认密码
      initPassword: undefined,
      // 日期范围
      dateRange: [],
      // 岗位选项
      postOptions: [],
      // 角色选项
      roleOptions: [],
      // 表单参数
      form: {},
      defaultProps: {
        children: "children",
        label: "label"
      },
      // 用户导入参数
      upload: {
        // 是否显示弹出层（用户导入）
        open: false,
        // 弹出层标题（用户导入）
        title: "",
        // 是否禁用上传
        isUploading: false,
        // 是否更新已经存在的用户数据
        updateSupport: 0,
        // 设置上传的请求头部
        headers: {Authorization: "Bearer " + getToken()},
        // 上传的地址
        url: process.env.VUE_APP_BASE_API + "/system/user/importData"
      },
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined,
        status: undefined,
        deptId: undefined
      },
      // 列信息
      columns: [
        {key: 0, label: `用户编号`, visible: true},
        {key: 1, label: `用户名称`, visible: true},
        {key: 2, label: `用户昵称`, visible: true},
        {key: 3, label: `真实姓名`, visible: true},
        {key: 4, label: `岗位`, visible: true},
        {key: 5, label: `手机号码`, visible: true},
        {key: 6, label: `就职状态`, visible: true},
        {key: 7, label: `入职时间`, visible: true},
        {key: 8, label: `身份证号码`, visible: true},
        {key: 9, label: `联系电话`, visible: true},
        {key: 10, label: `性别`, visible: true},
        {key: 11, label: `出生日期`, visible: true},
        {key: 12, label: `民族`, visible: true},
        {key: 13, label: `政治面貌`, visible: true},
        {key: 14, label: `婚姻状况`, visible: true},
        {key: 15, label: `户籍地址`, visible: true},
        {key: 16, label: `居住地址`, visible: true},
        {key: 17, label: `紧急联系人`, visible: true},
        {key: 18, label: `紧急联系人电话`, visible: true},
        {key: 19, label: `关系`, visible: true},
        {key: 20, label: `学历`, visible: true},
        {key: 21, label: `毕业院校`, visible: true},
        {key: 22, label: `专业`, visible: true},
        {key: 23, label: `毕业时间`, visible: true},
        {key: 24, label: `开户银行`, visible: true},
        {key: 25, label: `银行账号`, visible: true},
        {key: 26, label: `状态`, visible: true},
        {key: 27, label: `创建时间`, visible: true}
      ],
      // 表单校验
      rules: {
        userName: [
          {required: true, message: "用户名称不能为空", trigger: "blur"},
          {min: 2, max: 20, message: '用户名称长度必须介于 2 和 20 之间', trigger: 'blur'}
        ],
        nickName: [
          {required: true, message: "用户昵称不能为空", trigger: "blur"}
        ],
        password: [
          {required: true, message: "用户密码不能为空", trigger: "blur"},
          {min: 5, max: 20, message: '用户密码长度必须介于 5 和 20 之间', trigger: 'blur'},
          {pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\\ |", trigger: "blur"}
        ],
        email: [
          {
            type: "email",
            message: "请输入正确的邮箱地址",
            trigger: ["blur", "change"]
          }
        ],
        phonenumber: [
          {
            pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
            message: "请输入正确的手机号码",
            trigger: "blur"
          }
        ],
      },
      checkUserDialogVisible: false,
      currentUserInfo: {}
    };
  },
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("user-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    // 根据名称筛选部门树
    deptName(val) {
      this.$refs.tree.filter(val);
    }
  },
  created() {
    this.getList();
    if (localStorage.getItem('user-columns') === 'null'
      || !localStorage.getItem('user-columns')) {
      //设置localStorage
      localStorage.setItem("user-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('user-columns'));
    }
    this.getDeptTree();
    this.getConfigKey("sys.user.initPassword").then(response => {
      this.initPassword = response.msg;
    });
  },
  methods: {
    parseTime,
    //查看某一行用户的信息
    checkRowInfo(row) {
      this.currentUserInfo = row;
      this.checkUserDialogVisible = true;
    },
    /** 查询用户列表 */
    getList() {
      this.loading = true;
      listUser(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.userList = response.rows;
          this.total = response.total;
          this.loading = false;
        }
      );
    },
    /** 查询部门下拉树结构 */
    getDeptTree() {
      deptTreeSelect().then(response => {
        this.deptOptions = response.data;
      });
    },
    // 筛选节点
    filterNode(value, data) {
      if (!value) return true;
      return data.label.indexOf(value) !== -1;
    },
    // 节点单击事件
    handleNodeClick(data) {
      this.queryParams.deptId = data.id;
      this.handleQuery();
    },
    // 用户状态修改
    handleStatusChange(row) {
      let text = row.status === "0" ? "启用" : "停用";
      this.$modal.confirm('确认要"' + text + '""' + row.userName + '"用户吗？').then(function () {
        return changeUserStatus(row.userId, row.status);
      }).then(() => {
        this.$modal.msgSuccess(text + "成功");
      }).catch(function () {
        row.status = row.status === "0" ? "1" : "0";
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
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
        status: "0",
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
        bankNo: null,
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.queryParams.deptId = undefined;
      this.$refs.tree.setCurrentKey(null);
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.userId);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
    },
    // 更多操作触发
    handleCommand(command, row) {
      switch (command) {
        case "handleResetPwd":
          this.handleResetPwd(row);
          break;
        case "handleAuthRole":
          this.handleAuthRole(row);
          break;
        default:
          break;
      }
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      getUser().then(response => {
        this.postOptions = response.posts;
        this.roleOptions = response.roles;
        this.open = true;
        this.title = "添加用户信息";
        this.form.password = this.initPassword;
      });
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const userId = row.userId || this.ids;
      getUser(userId).then(response => {
        this.form = response.data;
        this.postOptions = response.posts;
        this.roleOptions = response.roles;
        this.$set(this.form, "postIds", response.postIds);
        this.$set(this.form, "roleIds", response.roleIds);
        this.open = true;
        this.title = "修改用户";
        this.form.password = "";
      });
    },
    /** 重置密码按钮操作 */
    handleResetPwd(row) {
      this.$prompt('请输入"' + row.userName + '"的新密码', "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        closeOnClickModal: false,
        inputPattern: /^.{5,20}$/,
        inputErrorMessage: "用户密码长度必须介于 5 和 20 之间",
        inputValidator: (value) => {
          if (/<|>|"|'|\||\\/.test(value)) {
            return "不能包含非法字符：< > \" ' \\\ |"
          }
        },
      }).then(({value}) => {
        resetUserPwd(row.userId, value).then(response => {
          this.$modal.msgSuccess("修改成功，新密码是：" + value);
        });
      }).catch(() => {
      });
    },
    /** 分配角色操作 */
    handleAuthRole: function (row) {
      const userId = row.userId;
      this.$router.push("/system/user-auth/role/" + userId);
    },
    /** 提交按钮 */
    submitForm: function () {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.userId != undefined) {
            updateUser(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addUser(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const userIds = row.userId || this.ids;
      this.$modal.confirm('是否确认删除用户编号为"' + userIds + '"的数据项？').then(function () {
        return delUser(userIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/user/export', {
        ...this.queryParams
      }, `user_${new Date().getTime()}.xlsx`)
    },
    /** 导入按钮操作 */
    handleImport() {
      this.upload.title = "用户导入";
      this.upload.open = true;
    },
    /** 下载模板操作 */
    importTemplate() {
      this.download('system/user/importTemplate', {}, `user_template_${new Date().getTime()}.xlsx`)
    },
    // 文件上传中处理
    handleFileUploadProgress(event, file, fileList) {
      this.upload.isUploading = true;
    },
    // 文件上传成功处理
    handleFileSuccess(response, file, fileList) {
      this.upload.open = false;
      this.upload.isUploading = false;
      this.$refs.upload.clearFiles();
      this.$alert("<div style='overflow: auto;overflow-x: hidden;max-height: 70vh;padding: 10px 20px 0;'>" + response.msg + "</div>", "导入结果", {dangerouslyUseHTMLString: true});
      this.getList();
    },
    // 提交上传文件
    submitFileForm() {
      this.$refs.upload.submit();
    }
  }
};
</script>
