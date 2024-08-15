<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:auditflow:add']"
        >新增审核流程
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
    </el-row>
    <br/>
    <br/>
    <br/>
    <el-row>
      <el-steps :active="auditflowList.length" align-center>
        <el-step v-for="(item,index) in auditflowList" :key="index" :title="item.flowname">
          <template #description>
            <el-row>
              <span>允许审核的人员ID:{{ item.auditauthority }}</span>
            </el-row>
          </template>
        </el-step>
      </el-steps>
    </el-row>

    <!-- 添加或修改审核流程对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="40%" append-to-body>
      <el-steps :active="stepLength" align-center direction="vertical">
        <!--        第一个审核-->
        <el-step>
          <template #icon>
            <span>{{ stepInfo.step = 1 }}</span>
          </template>
          <template #title>
            <!-- 审核步骤-->
            <el-input type="text" placeholder="请输入允许审核的人员id,用逗号分隔"
                      v-model="stepInfo.auditauthority"></el-input>
          </template>
          <template #description>
            <!--  审核名称-->
            <el-input type="text" placeholder="请输入审核名称" v-model="stepInfo.flowname"></el-input>
          </template>
        </el-step>

        <!--        额外的 需要添加的-->
        <div v-if="checkStepList.length !==0">
          <el-step v-for="(item,index) in checkStepList" :key="index">
            <template #icon>
              <span>{{ item.step = index + 2 }}</span>
            </template>
            <template #title>
              <el-input type="text" placeholder="请输入允许审核的人员id" v-model="item.auditauthority"></el-input>
            </template>
            <template #description>
              <el-input type="text" placeholder="请输入审核名称" v-model="item.flowname"></el-input>
            </template>
          </el-step>
        </div>
      </el-steps>
      <div slot="footer" class="dialog-footer">
        <el-button icon="el-icon-circle-plus-outline" @click="addCheckStateStep" type="success">添加审核步骤</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listAuditflow, getAuditflow, delAuditflow, addAuditflow, updateAuditflow} from "@/api/system/auditflow";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {mapGetters} from "vuex";

export default {
  name: "Auditflow",
  mixins: [mixin_printHTML],
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
      // 审核流程表格数据
      auditflowList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        flowname: null,
        stepnum: null,
        step: null,
        auditauthority: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `账户类型`, visible: true},
        {key: 1, label: `开户名称`, visible: true},
        {key: 2, label: `账号(银行卡号)`, visible: true},
        {key: 3, label: `开户行`, visible: true},
        {key: 4, label: `公司名称`, visible: true}
      ],

      //审核信息
      stepInfo: {
        id: 1,
        flowname: '',
        stepnum: null,
        step: null,
        auditauthority: null,
      }
    };
  },
  created() {
    this.getList();
  },
  computed: {
    stepLength() {
      console.log(this.checkStepList)
      return this.checkStepList.length;
    },
    ...mapGetters(['checkStepList'])
  },
  methods: {
    //添加审核流程
    addCheckStateStep() {
      //推入一个空对象
      this.$store.dispatch('paymentApply/addCheckStep', {
        flowname: '',
        stepnum: null,
        step: null,
        auditauthority: null,
      })
    },
    /** 查询审核流程列表 */
    getList() {
      this.loading = true;
      listAuditflow(this.queryParams).then(response => {
        this.auditflowList = response.rows;
        console.log(this.auditflowList)
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.$store.dispatch('paymentApply/clearCheckStepList')
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        flowname: null,
        stepnum: null,
        step: null,
        auditauthority: null
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
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加审核流程";
    },
    //修改审核步骤
    handleUpdate(row) {

    },
    //添加审核步骤
    submitForm() {
      this.stepInfo.stepnum = this.checkStepList.length + 1
      this.$store.dispatch('paymentApply/updateStepNum', this.checkStepList.length + 1)
      //按照step的大小排序
      let info = [...this.checkStepList, this.stepInfo]
      //对info数组按照step的大小排序
      info.sort((a, b) => {
        return a.step - b.step
      })
      this.$wait()
      updateAuditflow(info).then(res => {
        this.$message.success('添加审核流程成功')
        this.$close()
      }).catch(err => {
        this.$close()
      })
      this.open = false
      setTimeout(() => {
        //清空状态
        this.$store.dispatch('paymentApply/clearCheckStepList')
        this.stepInfo = {}
        this.getList()
      }, 20)
    },
    //删除审核步骤 就是传null
    handleDelete(row) {

    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/auditflow/export', {
        ...this.queryParams
      }, `auditflow_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
