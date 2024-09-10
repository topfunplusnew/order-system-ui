<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="部门" prop="depName">
        <el-input
          v-model="queryParams.depName"
          placeholder="请输入部门"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="姓名" prop="employeeName">
        <el-input
          v-model="queryParams.employeeName"
          placeholder="请输入姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="人员编号" prop="employeeID">
        <el-input
          v-model="queryParams.employeeID"
          placeholder="请输入人员编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" icon="el-icon-refresh" size="mini" @click="addSocial">新增社保基金信息</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-printer"
              size="mini"
              @click="printJSON"
            >
            </el-button>
          </el-col>
        </template>
        <!--        导出-->
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:socialinsurance:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="socialInsuranceList" @selection-change="handleSelectionChange"
              id="printBox" v-horizontal-scroll="'always'">
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="社保缴纳基数" align="center" prop="basicSocialInsurance" v-if="columns[0].visible"/>
      <el-table-column label="公积金基数" align="center" prop="basicHousingFund" v-if="columns[1].visible"/>
      <el-table-column label="部门" align="center" prop="depName" v-if="columns[2].visible"/>
      <el-table-column label="姓名" align="center" prop="employeeName" v-if="columns[3].visible"/>
      <el-table-column label="人员编号" align="center" prop="employeeID" v-if="columns[4].visible"/>
      <el-table-column label="缴费时间" align="center" prop="insuranceDate" v-if="columns[5].visible"/>
      <el-table-column label="是否增员" align="center" prop="isRecruiting" v-if="columns[6].visible"/>
      <el-table-column label="是否减员" align="center" prop="isDepletion" v-if="columns[7].visible"/>
      <el-table-column label="基本医疗保险-个人" align="center" prop="healthySecuritySelf" v-if="columns[8].visible"/>
      <el-table-column label="基本医疗保险-公司" align="center" prop="healthySecurityCompany"
                       v-if="columns[9].visible"/>
      <el-table-column label="工伤保险" align="center" prop="injuryInsurance" v-if="columns[10].visible"/>
      <el-table-column label="失业保险-个人" align="center" prop="unemploymentSecuritySelf"
                       v-if="columns[11].visible"/>
      <el-table-column label="失业保险-公司" align="center" prop="unemploymentSecurityCompany"
                       v-if="columns[12].visible"/>
      <el-table-column label="养老保险-个人" align="center" prop="retirementSecuritySelf" v-if="columns[13].visible"/>
      <el-table-column label="养老保险-公司" align="center" prop="retirementSecurityCompany"
                       v-if="columns[14].visible"/>
      <el-table-column label="大额医保-个人" align="center" prop="largeMedicalSecuritySelf"
                       v-if="columns[15].visible"/>
      <el-table-column label="大额医保-公司" align="center" prop="largeMedicalSecurityCompany"
                       v-if="columns[16].visible"/>
      <el-table-column label="公积金-个人" align="center" prop="housingFundSelf" v-if="columns[17].visible"/>
      <el-table-column label="公积金-公司" align="center" prop="housingFundCompany" v-if="columns[18].visible"/>
      <el-table-column label="个人缴费总额" align="center" prop="sumSelf" v-if="columns[19].visible"/>
      <el-table-column label="公司缴费总额" align="center" prop="sumCompany" v-if="columns[20].visible"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:socialinsurance:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:socialinsurance:remove']"
          >删除
          </el-button>
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

    <!-- 添加或修改社保基金对话框 -->
    <el-dialog :title="title" :visible.sync="open" fullscreen append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-col :span="6">
          <el-form-item label="社保缴纳基数" prop="basicSocialInsurance">
            <el-input v-model="form.basicSocialInsurance" placeholder="请输入社保缴纳基数"/>
          </el-form-item>
          <el-form-item label="公积金基数" prop="basicHousingFund">
            <el-input v-model="form.basicHousingFund" placeholder="请输入公积金基数"/>
          </el-form-item>
          <el-form-item label="部门" prop="depName">
            <el-input v-model="form.depName" placeholder="请输入部门"/>
          </el-form-item>
          <el-form-item label="姓名" prop="employeeName">
            <el-input v-model="form.employeeName" placeholder="请输入姓名"/>
          </el-form-item>
          <el-form-item label="人员编号" prop="employeeID">
            <el-input v-model="form.employeeID" placeholder="请输入人员编号"/>
          </el-form-item>
          <el-form-item label="缴费时间" prop="insuranceDate">
            <el-input v-model="form.insuranceDate" placeholder="请输入缴费时间"/>
          </el-form-item>
          <el-form-item label="是否增员" prop="isRecruiting">
            <el-radio v-model="form.isRecruiting" label="是">是</el-radio>
            <el-radio v-model="form.isRecruiting" label="否">否</el-radio>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否减员" prop="isDepletion">
            <el-radio v-model="form.isDepletion" label="是">是</el-radio>
            <el-radio v-model="form.isDepletion" label="否">否</el-radio>
          </el-form-item>
          <el-form-item label="基本医疗保险-个人" prop="healthySecuritySelf">
            <el-input v-model="form.healthySecuritySelf" placeholder="请输入基本医疗保险-个人"/>
          </el-form-item>
          <el-form-item label="基本医疗保险-公司" prop="healthySecurityCompany">
            <el-input v-model="form.healthySecurityCompany" placeholder="请输入基本医疗保险-公司"/>
          </el-form-item>
          <el-form-item label="工伤保险" prop="injuryInsurance">
            <el-input v-model="form.injuryInsurance" placeholder="请输入工伤保险"/>
          </el-form-item>
          <el-form-item label="失业保险-个人" prop="unemploymentSecuritySelf">
            <el-input v-model="form.unemploymentSecuritySelf" placeholder="请输入失业保险-个人"/>
          </el-form-item>
          <el-form-item label="失业保险-公司" prop="unemploymentSecurityCompany">
            <el-input v-model="form.unemploymentSecurityCompany" placeholder="请输入失业保险-公司"/>
          </el-form-item>
          <el-form-item label="养老保险-个人" prop="retirementSecuritySelf">
            <el-input v-model="form.retirementSecuritySelf" placeholder="请输入养老保险-个人"/>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="养老保险-公司" prop="retirementSecurityCompany">
            <el-input v-model="form.retirementSecurityCompany" placeholder="请输入养老保险-公司"/>
          </el-form-item>
          <el-form-item label="大额医保-个人" prop="largeMedicalSecuritySelf">
            <el-input v-model="form.largeMedicalSecuritySelf" placeholder="请输入大额医保-个人"/>
          </el-form-item>
          <el-form-item label="大额医保-公司" prop="largeMedicalSecurityCompany">
            <el-input v-model="form.largeMedicalSecurityCompany" placeholder="请输入大额医保-公司"/>
          </el-form-item>
          <el-form-item label="公积金-个人" prop="housingFundSelf">
            <el-input v-model="form.housingFundSelf" placeholder="请输入公积金-个人"/>
          </el-form-item>
          <el-form-item label="公积金-公司" prop="housingFundCompany">
            <el-input v-model="form.housingFundCompany" placeholder="请输入公积金-公司"/>
          </el-form-item>
          <el-form-item label="个人缴费总额" prop="sumSelf">
            <el-input v-model="form.sumSelf" placeholder="请输入个人缴费总额"/>
          </el-form-item>

        </el-col>
        <el-col :span="6">
          <el-form-item label="公司缴费总额" prop="sumCompany">
            <el-input v-model="form.sumCompany" placeholder="请输入公司缴费总额"/>
          </el-form-item>
          <el-form-item label="备注" prop="comments">
            <el-input v-model="form.comments" placeholder="请输入备注"/>
          </el-form-item>
        </el-col>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listSocialInsurance,
  getSocialInsurance,
  delSocialInsurance,
  addSocialInsurance,
  updateSocialInsurance
} from "@/api/system/socialInsurance";
import {excludeParams} from "@/api/tool/exclude";

export default {
  name: "SocialInsurance",
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
      // 社保基金表格数据
      socialInsuranceList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        basicSocialInsurance: null,
        basicHousingFund: null,
        depName: null,
        employeeName: null,
        employeeID: null,
        insuranceDate: null,
        isRecruiting: null,
        isDepletion: null,
        healthySecuritySelf: null,
        healthySecurityCompany: null,
        injuryInsurance: null,
        unemploymentSecuritySelf: null,
        unemploymentSecurityCompany: null,
        retirementSecuritySelf: null,
        retirementSecurityCompany: null,
        largeMedicalSecuritySelf: null,
        largeMedicalSecurityCompany: null,
        housingFundSelf: null,
        housingFundCompany: null,
        sumSelf: null,
        sumCompany: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      columns: [
        {key: 0, label: `社保缴纳基数`, visible: true},
        {key: 1, label: `公积金基数`, visible: true},
        {key: 2, label: `部门`, visible: true},
        {key: 3, label: `姓名`, visible: true},
        {key: 4, label: `人员编号`, visible: true},
        {key: 5, label: `缴费时间`, visible: true},
        {key: 6, label: `是否增员`, visible: true},
        {key: 7, label: `是否减员`, visible: true},
        {key: 8, label: `基本医疗保险-个人`, visible: true},
        {key: 9, label: `基本医疗保险-公司`, visible: true},
        {key: 10, label: `工伤保险`, visible: true},
        {key: 11, label: `失业保险-个人`, visible: true},
        {key: 12, label: `失业保险-公司`, visible: true},
        {key: 13, label: `养老保险-个人`, visible: true},
        {key: 14, label: `养老保险-公司`, visible: true},
        {key: 15, label: `大额医保-个人`, visible: true},
        {key: 16, label: `大额医保-公司`, visible: true},
        {key: 17, label: `公积金-个人`, visible: true},
        {key: 18, label: `公积金-公司`, visible: true},
        {key: 19, label: `个人缴费总额`, visible: true},
        {key: 20, label: `公司缴费总额`, visible: true},
      ],
      // 表单参数
      form: {},
      // 表单校验
      rules: {}
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('socialinsurance-columns') === 'null'
      || !localStorage.getItem('socialinsurance-columns')) {
      //设置localStorage
      localStorage.setItem("socialinsurance-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('socialinsurance-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("socialinsurance-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    addSocial() {
      this.open = true;
      this.reset()
    },
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    printJSON() {
      const exclude = ['userId', 'createBy', 'createTime', 'updateBy', 'updateTime', 'addtime', 'delFlag', 'userName', 'remark',]
      this.$print({
        maxWidth: 3000,
        printable: this.socialInsuranceList,
        properties: Object.keys(this.socialInsuranceList[0]).filter(item => !exclude.includes(item)),
        type: 'json'
      })
    },
    /** 查询社保基金列表 */
    getList() {
      this.loading = true;
      listSocialInsurance(this.queryParams).then(response => {
        this.socialInsuranceList = response.rows;
        this.total = response.total;
        this.loading = false;
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
        id: null,
        basicSocialInsurance: null,
        basicHousingFund: null,
        depName: null,
        employeeName: null,
        employeeID: null,
        insuranceDate: null,
        isRecruiting: null,
        isDepletion: null,
        healthySecuritySelf: null,
        healthySecurityCompany: null,
        injuryInsurance: null,
        unemploymentSecuritySelf: null,
        unemploymentSecurityCompany: null,
        retirementSecuritySelf: null,
        retirementSecurityCompany: null,
        largeMedicalSecuritySelf: null,
        largeMedicalSecurityCompany: null,
        housingFundSelf: null,
        housingFundCompany: null,
        sumSelf: null,
        sumCompany: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
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
      this.title = "添加社保基金";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getSocialInsurance(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改社保基金";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form = excludeParams(this.form, this.$exclude)
            updateSocialInsurance(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form = excludeParams(this.form, this.$exclude)
            addSocialInsurance(this.form).then(response => {
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
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除社保基金编号为"' + ids + '"的数据项？').then(function () {
        return delSocialInsurance(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/socialInsurance/export', {
        ...this.queryParams
      }, `socialInsurance_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

