<template>
  <div>
    <el-dialog v-bind="$attrs" v-on="$listeners" @open="onOpen" title="选择审核人员">
      <el-row>
        <el-col :span="6">
          <Fonts content="请选择部门"/>
          <el-tree
            :data="deptOptions"
            :props="defaultProps"
            :expand-on-click-node="false"
            :filter-node-method="filterNode"
            ref="tree"
            node-key="id"
            default-expand-all
            highlight-current
            @node-click="handleNodeClick"
          />
        </el-col>
        <el-col :span="18">
          <Fonts content="请选择部门人员"/>
          <el-button type="success" size="mini" @click="handleSelectAll" v-if="ids.length !== 0">确认已选择的
          </el-button>
          <el-button type="danger" size="mini" @click="handleDeleteAll" v-if="ids.length !== 0">删除已选择的
          </el-button>
          <el-table border v-loading="loading" :data="userList" size="mini" @selection-change="handleSelectionChange"
                    :cell-style="()=>{return {padding:'2px'}}">
            <el-table-column type="selection" width="50" align="center"/>
            <el-table-column label="用户编号" align="center" key="userId" prop="userId"/>
            <el-table-column label="用户名称" align="center" key="userName" prop="userName"
                             :show-overflow-tooltip="true"/>
            <el-table-column label="用户昵称" align="center" key="nickName" prop="nickName"
                             :show-overflow-tooltip="true"/>
            <el-table-column label="真实姓名" align="center" key="trueName" prop="trueName"
                             :show-overflow-tooltip="true"/>
            <el-table-column label="岗位" align="center" key="deptName" prop="postName" :show-overflow-tooltip="true"/>
            <el-table-column label="手机号码" align="center" key="phonenumber" prop="phonenumber" width="120"/>
            <el-table-column label="就职状态" align="center" key="state" prop="state" width="120"/>
            <el-table-column label="入职时间" align="center" key="startDate" prop="startDate" width="120"/>
            <el-table-column label="身份证号码" align="center" key="iDCard" prop="iDCard" width="120"/>
            <el-table-column label="性别" align="center" key="sex" prop="sex" width="120"/>
            <el-table-column label="出生日期" align="center" key="birthday" prop="birthday" width="120"/>
            <el-table-column label="民族" align="center" key="nation" prop="nation" width="120"/>
            <el-table-column label="操作" align="center" key="status" fixed="right">
              <template slot-scope="scope">
                <el-button type="success" size="mini" @click="handleSelect(scope.row)">选择</el-button>
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
      <div slot="footer">
        <el-button @click="close">取消</el-button>
        <el-button type="primary" @click="handleConfirm">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import {deptTreeSelect, listUser} from "../../../api/system/user";
import Fonts from "../../../components/Fonts.vue";

export default {
  inheritAttrs: false,
  components: {Fonts},
  props: [],
  data() {
    return {
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      loading: false,
      total: 0,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined,
        status: undefined,
        deptId: undefined
      },
      auflowInfo: {
        dept: [],
      },
      rules: {
        dept: [],
      },
      // 根据每一个部门去查询
      defaultProps: {
        children: "children",
        label: "label"
      },
      // 部门树选项
      deptOptions: undefined,
      userList: [],
    }
  },
  computed: {},
  watch: {},
  created() {
    this.getDeptTree();
  },
  mounted() {
  },
  methods: {
    onOpen() {
    },
    close() {
      this.$emit('update:visible', false)
    },
    // 选择某个人员 选择以后 自动填充 然后关闭弹窗
    handleSelect(row) {
      // 自动填充已经选择的
      this.$emit('changeSelectedList', row.userId)
      this.close()
    },
    // 多选
    handleSelectAll() {
      this.$emit('changeSelectedList', this.ids)
      this.close()
    },
    // 多选删除
    handleDeleteAll() {
      this.$emit('deleteSelectedList', this.ids)
      this.close()
    },
    handleConfirm() {
      this.close()
    },
    getList() {
      this.loading = true;
      listUser(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.userList = response.rows;
          this.total = response.total;
          this.loading = false
        }
      );
    },
    // 筛选节点
    filterNode(value, data) {
      if (!value) return true;
      return data.label.indexOf(value) !== -1;
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.userId);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
    },
    // 节点单击事件
    handleNodeClick(data) {
      this.queryParams.deptId = data.id;
      this.handleQuery();
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    getDeptTree() {
      deptTreeSelect().then(response => {
        this.deptOptions = response.data;
      });
    },
  }
}

</script>
<style>
</style>
