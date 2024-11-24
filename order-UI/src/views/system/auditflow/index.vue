<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          v-hasPermi="['system:auditflow:edit']"
          type="danger"
          size="mini"
          @click="handleAdd"
        >更改审核流程
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
    </el-row>
    <el-row style="margin-top: 60px">
      <el-steps :active="auditflowList.length" align-center>
        <el-step v-for="(item,index) in auditflowList" :key="index" :title="item.flowname">
          <template #description>
            审核人员编号:{{ item.auditauthority }}
          </template>
        </el-step>
      </el-steps>
    </el-row>
    <!-- 添加或修改审核流程对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-row>
        <el-steps :active="stepLength" align-center direction="vertical">
          <el-step v-for="(item,index) in checkStepList" :key="index">
            <template #icon>
              <span>{{ index + 1 }}</span>
            </template>
            <template #title>
              <el-button v-if="item.auditauthority.length === 0" icon="el-icon-circle-plus-outline" type="success"
                         @click="selectAuditFlowPersons(index)">选择审核人员
              </el-button>
              <el-button v-else icon="el-icon-circle-plus-outline" type="success"
                         @click="selectAuditFlowPersons(index)">已选择用户编号为{{ item.auditauthority }}的用户
              </el-button>
            </template>
            <template #description>
              <el-input v-model="item.flowname" type="text" placeholder="请输入审核名称"></el-input>
            </template>
          </el-step>
        </el-steps>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button icon="el-icon-circle-plus-outline" type="success" @click="addCheckStateStep">添加审核步骤</el-button>
        <el-button v-if="checkStepList.length !== 0" type="danger" @click="deleteCheckStateStep">删除审核步骤
        </el-button>
        <el-button type="primary" @click="submitForm">提交审核步骤</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    把我刚刚创建的那个文件用上-->
    <auditFlowInfo ref="auflowAddForm" :visible.sync="auditFlowPersonsVisible"
                   @changeSelectedList="changeSelectListAudit" @deleteSelectedList="deleteSelectList" />

  </div>
</template>

<script>
  import { listAuditflow, updateAuditflow } from '@/api/system/auditflow';
  import { mixin_printHTML } from '@/views/dashboard/mixins/print';
  import { mapGetters } from 'vuex';
  import AuditFlowInfo from './auditFlowInfo.vue';

  export default {
    name: 'Auditflow',
    components: { AuditFlowInfo },
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
        title: '',
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
        // 审核信息
        stepInfo: {
          id: 1,
          flowname: '',
          stepnum: null,
          step: null,
          auditauthority: [],
        },
        auditFlowPersonsVisible: false,
        currentId: ''
      };
    },
    created() {
      this.getList();

    },
    computed: {
      stepLength() {
        return this.checkStepList.length;
      },
      ...mapGetters(['checkStepList'])
    },
    methods: {
      // 添加审核流程
      addCheckStateStep() {
        this.checkStepList.push({
          flowname: '',
          stepnum: null,
          step: null,
          auditauthority: [],
        })
      },
      // 删除
      deleteCheckStateStep() {
        this.checkStepList.pop();
      },
      // 选择审核人员
      selectAuditFlowPersons(index) {
        this.auditFlowPersonsVisible = true;
        this.currentId = index
      },
      // 选择后自动填充
      changeSelectListAudit(id) {
        if (typeof id === 'object') {
          id.forEach(item => {
            this.checkStepList[this.currentId].auditauthority.push(item)
          })
          this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)]
          this.checkStepList[this.currentId].step = this.currentId + 1
        } else {
          this.checkStepList[this.currentId].auditauthority.push(id)
          this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)]
          this.checkStepList[this.currentId].step = this.currentId + 1
        }
      },
      // 删除审核人员
      deleteSelectList(id) {
        if (typeof id === 'object') {
          this.checkStepList[this.currentId].auditauthority =
            this.checkStepList[this.currentId].auditauthority.filter(item => {
              return !id.includes(item)
            })
          this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)]
        } else {
          this.checkStepList[this.currentId].auditauthority = this.checkStepList[this.currentId].auditauthority.filter(item => {
            return item !== id
          })
          this.checkStepList[this.currentId].auditauthority = [...new Set(this.checkStepList[this.currentId].auditauthority)]
        }
      },
      /** 查询审核流程列表 */
      getList() {
        this.loading = true;
        listAuditflow(this.queryParams).then(response => {
          this.auditflowList = response.rows;
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
        this.stepInfo = {
          id: 1,
          flowname: '',
          stepnum: null,
          step: null,
          auditauthority: [],
        }
        this.resetForm('form');
      },
      /** 搜索按钮操作 */
      handleQuery() {
        this.queryParams.pageNum = 1;
        this.getList();
      },
      /** 重置按钮操作 */
      resetQuery() {
        this.resetForm('queryForm');
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
        this.title = '更改审核流程';
        this.open = true;
      },
      // 添加审核步骤
      submitForm() {
        this.checkStepList.forEach(item => {
          item.stepnum = this.checkStepList.length;
          item.auditauthority = item.auditauthority.join(',')
        })
        updateAuditflow(this.checkStepList).then(res => {
          this.$message.success('添加审核流程成功')
          this.$store.dispatch('paymentApply/clearCheckStepList')
          this.getList()
          this.open = false
        })
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
