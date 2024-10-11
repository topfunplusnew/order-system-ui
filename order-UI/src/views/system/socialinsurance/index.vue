<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
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
        <el-button type="danger" size="mini" @click="addSocial">新增社保基金信息</el-button>
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
              id="printBox" v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="部门" align="center" prop="depName" v-if="columns[0].visible" show-overflow-tooltip/>
      <el-table-column label="姓名" align="center" prop="employeeName" v-if="columns[1].visible" show-overflow-tooltip/>
      <el-table-column label="人员编号" align="center" prop="employeeID" v-if="columns[2].visible"
                       show-overflow-tooltip/>
      <el-table-column label="社保缴纳基数" align="center" prop="basicSocialInsurance" v-if="columns[3].visible"
                       show-overflow-tooltip
                       width="110"/>
      <el-table-column label="公积金基数" align="center" prop="basicHousingFund" v-if="columns[4].visible" width="110"
                       show-overflow-tooltip/>
      <el-table-column label="缴费时间" align="center" prop="insuranceDate" v-if="columns[5].visible" width="120"
                       show-overflow-tooltip/>
      <el-table-column label="社保增减员情况" align="center">
        <el-table-column label="是否增员" align="center" prop="isRecruiting" v-if="columns[6].visible"
                         show-overflow-tooltip/>
        <el-table-column label="是否减员" align="center" prop="isDepletion" v-if="columns[7].visible"
                         show-overflow-tooltip/>
      </el-table-column>
      <el-table-column label="基本医疗保险" align="center">
        <el-table-column label="个人缴纳" align="center" prop="healthySecuritySelf" v-if="columns[8].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="healthySecurityCompany" v-if="columns[9].visible"/>
      </el-table-column>
      <el-table-column label="工伤保险" align="center" prop="injuryInsurance" v-if="columns[10].visible"/>
      <el-table-column label="失业保险" align="center">
        <el-table-column label="个人缴纳" align="center" prop="unemploymentSecuritySelf" v-if="columns[11].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="unemploymentSecurityCompany" v-if="columns[12].visible"/>
      </el-table-column>
      <el-table-column label="养老保险" align="center">
        <el-table-column label="个人缴纳" align="center" prop="retirementSecuritySelf" v-if="columns[13].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="retirementSecurityCompany" v-if="columns[14].visible"/>
      </el-table-column>
      <el-table-column label="大额医保" align="center">
        <el-table-column label="个人缴纳" align="center" prop="largeMedicalSecuritySelf" v-if="columns[15].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="largeMedicalSecurityCompany" v-if="columns[16].visible"/>
      </el-table-column>
      <el-table-column label="公积金缴纳" align="center">
        <el-table-column label="个人缴纳" align="center" prop="housingFundSelf" v-if="columns[17].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="housingFundCompany" v-if="columns[18].visible"/>
      </el-table-column>
      <el-table-column label="个人缴费总额" align="center" prop="sumSelf" v-if="columns[19].visible" width="120"/>
      <el-table-column label="公司缴费总额" align="center" prop="sumCompany" v-if="columns[20].visible" width="120"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[21].visible" width="120"/>
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
    <el-dialog :close-on-click-modal="false" :show-close="false" title="社保基金" :visible.sync="open" append-to-body
               width="80%">
      <el-row>
        <el-col :span="1.5">
          <el-button type="primary" size="mini" @click="addSocialInsure">添加人员社保基金信息</el-button>
        </el-col>
      </el-row>
      <br/>
      <el-table
        :data="socialInsuranceItemsList"
        style="width: 100%" size="mini">
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="danger"
              @click="handleDeleteItem(scope.$index, scope.row)">删除
            </el-button>
          </template>
        </el-table-column>
        <!--        本月缴纳基数-->
        <el-table-column :label="'本月缴纳基数:'+ basicSocialInsurance">
          <el-table-column
            prop="employeeName"
            label="姓名"
            width="120">
          </el-table-column>
          <el-table-column label="社保增减人员情况" prop="name" width="120">
            <el-table-column
              prop="isRecruiting"
              label="是否增员"
              width="120">
            </el-table-column>
          </el-table-column>
          <el-table-column label="基本医疗保险">
            <el-table-column
              prop="healthySecurityCompany"
              label="公司缴纳"
              width="120">
            </el-table-column>
            <el-table-column
              prop="healthySecuritySelf"
              label="个人缴纳"
              width="120">
            </el-table-column>
          </el-table-column>
        </el-table-column>
        <!--            工伤保险-->
        <el-table-column label="工伤保险" prop="injuryInsurance"></el-table-column>
        <!--        本月公积金缴纳基数-->
        <el-table-column :label="'本月公积金缴纳基数:'+ basicHousingFund">
          <!--          缴纳社保和停止社保时间-->
          <el-table-column label="失业保险" prop="name" width="120">
            <el-table-column
              prop="unemploymentSecurityCompany"
              label="公司缴纳"
              width="120">
            </el-table-column>
            <el-table-column
              prop="unemploymentSecuritySelf"
              label="个人缴纳"
              width="120">
            </el-table-column>
          </el-table-column>
          <el-table-column label="基本养老保险">
            <el-table-column
              prop="retirementSecurityCompany"
              label="公司缴纳"
              width="120">
            </el-table-column>
            <el-table-column
              prop="retirementSecuritySelf"
              label="个人缴纳"
              width="120">
            </el-table-column>
          </el-table-column>
          <el-table-column label="大额医疗保险">
            <el-table-column
              prop="largeMedicalSecurityCompany"
              label="公司缴纳"
              width="120">
            </el-table-column>
            <el-table-column
              prop="largeMedicalSecuritySelf"
              label="个人缴纳"
              width="120">
            </el-table-column>
          </el-table-column>
          <el-table-column label="住房公积金">
            <el-table-column
              prop="housingFundCompany"
              label="公司缴纳"
              width="120">
            </el-table-column>
            <el-table-column
              prop="housingFundSelf"
              label="个人缴纳"
              width="120">
            </el-table-column>
          </el-table-column>
          <el-table-column label="个人缴纳总额" prop="sumSelf">
          </el-table-column>
          <el-table-column label="公司缴纳总额" prop="sumCompany">
          </el-table-column>

        </el-table-column>

      </el-table>


      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    添加社保基金人员个体信息-->
    <el-dialog :close-on-click-modal="false" :show-close="false"
               title="社保基金人员个体信息"
               :visible.sync="addSocialDialogVisible"
               width="85%" append-to-body>
      <el-row>
        <el-form ref="form" :model="form" :rules="rules" label-width="140px">
          <el-col :span="8">
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
              <el-date-picker
                v-model="form.insuranceDate"
                type="date"
                placeholder="选择缴费时间"
                value-format="yyyy-MM-dd"
                style="width: 120px">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否增员" prop="isRecruiting">
              <el-radio v-model="form.isRecruiting" label="是">是</el-radio>
              <el-radio v-model="form.isRecruiting" label="否">否</el-radio>
            </el-form-item>
            <el-form-item label="是否减员" prop="isDepletion">
              <el-radio v-model="form.isDepletion" label="是">是</el-radio>
              <el-radio v-model="form.isDepletion" label="否">否</el-radio>
            </el-form-item>
            <el-form-item label="基本医疗保险" prop="healthySecuritySelf">
              <el-col :span="11">
                <el-input v-model="form.healthySecuritySelf" placeholder="个人缴纳金额" style="width: 100%"/>
              </el-col>
              <el-col :span="2" class="line">-</el-col>
              <el-col :span="11">
                <el-input v-model="form.healthySecurityCompany" placeholder="公司缴纳金额" style="width: 100%"/>
              </el-col>
            </el-form-item>
            <!--            <el-form-item label="基本医疗保险-公司" prop="healthySecurityCompany">-->
            <!--            </el-form-item>-->
            <el-form-item label="工伤保险" prop="injuryInsurance">
              <el-input v-model="form.injuryInsurance" placeholder="请输入工伤保险缴纳金额"/>
            </el-form-item>
            <el-form-item label="失业保险" prop="unemploymentSecuritySelf">
              <el-col :span="11">
                <el-input v-model="form.unemploymentSecuritySelf" placeholder="个人缴纳金额"/>
              </el-col>
              <el-col :span="2" class="line">-</el-col>
              <el-col :span="11">
                <el-input v-model="form.unemploymentSecurityCompany" placeholder="公司缴纳金额"/>
              </el-col>
            </el-form-item>
            <!--            <el-form-item label="失业保险-公司" prop="unemploymentSecurityCompany">-->
            <!--            </el-form-item>-->
            <el-form-item label="养老保险" prop="retirementSecuritySelf">
              <el-col :span="11">
                <el-input v-model="form.retirementSecuritySelf" placeholder="个人缴纳金额"/>
              </el-col>
              <el-col :span="2" class="line">-</el-col>
              <el-col :span="11">
                <el-input v-model="form.retirementSecurityCompany" placeholder="公司缴纳金额"/>
              </el-col>
            </el-form-item>
            <!--            <el-form-item label="养老保险-公司" prop="retirementSecurityCompany">-->
            <!--            </el-form-item>-->
          </el-col>
          <el-col :span="8">
            <el-form-item label="大额医保" prop="largeMedicalSecuritySelf">
              <el-col :span="11">
                <el-input v-model="form.largeMedicalSecuritySelf" placeholder="个人缴纳金额"/>
              </el-col>
              <el-col :span="2" class="line">-</el-col>
              <el-col :span="11">
                <el-input v-model="form.largeMedicalSecurityCompany" placeholder="公司缴纳"/>
              </el-col>
            </el-form-item>
            <!--            <el-form-item label="大额医保-公司" prop="largeMedicalSecurityCompany">-->
            <!--            </el-form-item>-->
            <el-form-item label="公积金" prop="housingFundSelf">
              <el-col :span="11">
                <el-input v-model="form.housingFundSelf" placeholder="个人缴纳金额"/>
              </el-col>
              <el-col :span="2" class="line">-</el-col>
              <el-col :span="11">
                <el-input v-model="form.housingFundCompany" placeholder="公司缴纳金额"/>
              </el-col>
            </el-form-item>
            <!--            <el-form-item label="公积金-公司" prop="housingFundCompany">-->
            <!--            </el-form-item>-->
            <!--          <el-form-item label="个人缴费总额" prop="sumSelf">-->
            <!--            <el-input v-model="form.sumSelf" placeholder="请输入个人缴费总额"/>-->
            <!--          </el-form-item>-->
            <!--          <el-form-item label="公司缴费总额" prop="sumCompany">-->
            <!--            <el-input v-model="form.sumCompany" placeholder="请输入公司缴费总额"/>-->
            <!--          </el-form-item>-->
            <el-form-item label="备注" prop="comments">
              <el-input v-model="form.comments" placeholder="请输入备注"/>
            </el-form-item>
          </el-col>
        </el-form>
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="addSocialDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="addSocialInsureItemInfo">确 定</el-button>
  </span>
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
        {key: 0, label: `部门`, visible: true},
        {key: 1, label: `姓名`, visible: true},
        {key: 2, label: `人员编号`, visible: true},
        {key: 3, label: `社保缴纳基数`, visible: true},
        {key: 4, label: `公积金基数`, visible: true},
        {key: 5, label: `缴费时间`, visible: true},
        {key: 6, label: `社保增减员情况-是否增员`, visible: true},
        {key: 7, label: `社保增减员情况-是否减员`, visible: true},
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
        {key: 21, label: `备注`, visible: true}
      ],

      // 表单参数
      form: {},
      // 表单校验
      rules: {
        basicSocialInsurance: [
          {required: true, message: '基本医疗保险不能为空', trigger: 'blur'}],

        basicHousingFund: [
          {required: true, message: '公积金基数不能为空', trigger: 'blur'}],

        depName: [
          {required: true, message: '部门不能为空', trigger: 'blur'}],

        employeeName: [
          {required: true, message: '姓名不能为空', trigger: 'blur'}],

        employeeID: [
          {required: true, message: '人员编号不能为空', trigger: 'blur'}],

        insuranceDate: [
          {required: true, message: '缴费时间不能为空', trigger: 'blur'}],

        isRecruiting: [
          {required: true, message: '是否增员不能为空', trigger: 'change'}],

        isDepletion: [
          {required: true, message: '是否减员不能为空', trigger: 'change'}],


        healthySecuritySelf: [
          {required: true, message: '基本医疗保险不能为空', trigger: 'blur'}],

        healthySecurityCompany: [
          {required: true, message: '公司基本医疗保险不能为空', trigger: 'blur'}],
        injuryInsurance: [
          {required: true, message: '工伤保险不能为空', trigger: 'blur'}
        ],
        unemploymentSecuritySelf: [
          {required: true, message: '失业保险不能为空', trigger: 'blur'}],

        unemploymentSecurityCompany: [
          {required: true, message: '公司失业保险不能为空', trigger: 'blur'}
        ],
        retirementSecuritySelf: [
          {required: true, message: '养老保险不能为空', trigger: 'blur'}
        ],
        retirementSecurityCompany: [
          {required: true, message: '养老保险-公司不能为空', trigger: 'blur'}
        ],
        largeMedicalSecuritySelf: [
          {required: true, message: '大额医保不能为空', trigger: 'blur'}
        ],
        largeMedicalSecurityCompany: [
          {required: true, message: '大额医保-公司不能为空', trigger: 'blur'}
        ],
        housingFundSelf: [
          {required: true, message: '公积金不能为空', trigger: 'blur'}
        ],
        housingFundCompany: [
          {required: true, message: '公积金-公司不能为空', trigger: 'blur'}
        ],
        sumSelf: [
          {required: true, message: '个人缴费总额不能为空', trigger: 'blur'}
        ],
        sumCompany: [
          {required: true, message: '公司缴费总额不能为空', trigger: 'blur'}
        ],

      },
      // 添加社保基金的弹窗
      addSocialDialogVisible: false,
      // 添加社保基金个体列表
      socialInsuranceItemsList: [],
      // 社保缴纳基数
      basicSocialInsurance: '0',
      // 公积金基数
      basicHousingFund: '0',
    };
  },
  computed: {},
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
    addSocialInsure() {
      this.addSocialDialogVisible = true
    },
    // 添加社保基金个体信息
    addSocialInsureItemInfo() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 修改
          if (this.form.id !== null && this.form.id !== undefined && this.form.id !== '') {
            this.form.sumSelf = this.sumSummary(this.form, 'Self');
            this.form.sumCompany = this.sumSummary(this.form, 'Company');
            this.form = excludeParams(this.form, this.$exclude)
            updateSocialInsurance(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.addSocialDialogVisible = false;
              this.getList();
            });
            // 增加逻辑 批量发请求
          } else {
            const {basicSocialInsurance, basicHousingFund} = this.form
            // 添加时 自动赋值基金数
            this.basicHousingFund = basicHousingFund;
            this.basicSocialInsurance = basicSocialInsurance
            // 计算合并列的综合
            this.form.sumSelf = this.sumSummary(this.form, 'Self');
            this.form.sumCompany = this.sumSummary(this.form, 'Company');
            const item = JSON.parse(JSON.stringify(this.form));
            // 往列表中推入一个个体信息
            this.socialInsuranceItemsList.push(item)
            this.reset()
            this.addSocialDialogVisible = false
          }
        }
      })
    },
    // 根据类型计算综合
    sumSummary(form, type) {
      let sum = 0
      for (const prop in form) {
        if (prop.includes(type)) {
          sum += Number(form[prop]);
        }
      }
      return Number(sum).toFixed(2);
    },
    addSocial() {
      this.open = true;
      this.reset()
    },
    handleDeleteItem(index, row) {
      this.socialInsuranceItemsList.splice(index, 1);
      this.$message.success('删除成功')
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
      this.socialInsuranceItemsList = []
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
        this.addSocialDialogVisible = true;
        this.title = "修改社保基金";
      });
    },
    // 休眠函数
    sleep(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    },
    /** 提交按钮 */
    async submitForm() {
      if (this.form.id != null) {
        this.form = excludeParams(this.form, this.$exclude)
        updateSocialInsurance(this.form).then(response => {
          this.$modal.msgSuccess("修改成功");
          this.open = false;
          this.getList();
        });
        // 添加
      } else {
        // 批量添加
        for (let i = 0; i < this.socialInsuranceItemsList.length; i++) {
          const item = this.socialInsuranceItemsList[i];
          try {
            const response = await addSocialInsurance(item);
            this.socialInsuranceItemsList.splice(i, 1);
            i--;
            this.$message.success(`添加成功,剩余${this.socialInsuranceItemsList.length}人员未添加`)
            // 调用 sleep 函数增加间隔时间，例如 1000 毫秒（1 秒）
            await this.sleep(1500);
          } catch (error) {
            console.error(`第${this.socialInsuranceItemsList.indexOf(item) + 1}条信息添加失败:`, error);
          }
        }
        if (this.socialInsuranceItemsList.length === 0) {
          this.$message.success('所有人员社保信息添加成功')
          this.open = false;
          this.getList();
        }
      }
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

