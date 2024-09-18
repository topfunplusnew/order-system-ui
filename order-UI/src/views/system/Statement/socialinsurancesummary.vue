<template>
  <div class="app-container">
    <el-row style="background-color:#e6e6e6;">
      <el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
    </el-row>
    <hr color="#e6e6e6"/>
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="queryParams.beginTime"
          type="date"
          placeholder="选择时间"
          value-format="yyyy-MM-dd"
          size="mini"
          style="width: 100px;">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="queryParams.endTime"
          type="date"
          placeholder="选择时间"
          value-format="yyyy-MM-dd"
          size="mini"
          style="width: 100px;">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>
    <hr color="#e6e6e6"/>
    <el-row style="font-weight: bold;font-size: 20px;margin: 0 30px">
      社保和公积金缴纳登记台账
    </el-row>
    <el-row :gutter="10" class="mb8">
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-printer"
              size="mini"
              @click="printHTML"
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

    <el-table border v-loading="loading" :data="socialInsuranceList"
              id="printBox" v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="部门" align="center" prop="depName" v-if="columns[2].visible"/>
      <el-table-column label="姓名" align="center" prop="employeeName" v-if="columns[3].visible"/>
      <el-table-column label="社保缴纳基数" align="center" prop="basicSocialInsurance" v-if="columns[0].visible"
                       width="110"/>
      <el-table-column label="公积金基数" align="center" prop="basicHousingFund" v-if="columns[1].visible" width="110"/>
      <el-table-column label="缴费时间" align="center" prop="insuranceDate" v-if="columns[5].visible" width="120"/>
      <el-table-column label="社保增减员情况" align="center">
        <el-table-column label="是否增员" align="center" prop="isRecruiting" v-if="columns[6].visible"/>
        <el-table-column label="是否减员" align="center" prop="isDepletion" v-if="columns[7].visible"/>
      </el-table-column>
      <el-table-column label="基本医疗保险" align="center">
        <el-table-column label="个人缴纳" align="center" prop="healthySecuritySelf" v-if="columns[8].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="healthySecurityCompany"
                         v-if="columns[9].visible"/>
      </el-table-column>
      <el-table-column label="工伤保险" align="center" prop="injuryInsurance" v-if="columns[10].visible"/>

      <el-table-column label="失业保险" align="center">
        <el-table-column label="个人缴纳" align="center" prop="unemploymentSecuritySelf"
                         v-if="columns[11].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="unemploymentSecurityCompany"
                         v-if="columns[12].visible"/>
      </el-table-column>
      <el-table-column label="养老保险" align="center">
        <el-table-column label="个人缴纳" align="center" prop="retirementSecuritySelf" v-if="columns[13].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="retirementSecurityCompany"
                         v-if="columns[14].visible"/>
      </el-table-column>
      <el-table-column label="大额医保" align="center">
        <el-table-column label="个人缴纳" align="center" prop="largeMedicalSecuritySelf"
                         v-if="columns[15].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="largeMedicalSecurityCompany"
                         v-if="columns[16].visible"/>
      </el-table-column>
      <el-table-column label="公积金缴纳" align="center">
        <el-table-column label="个人缴纳" align="center" prop="housingFundSelf" v-if="columns[17].visible"/>
        <el-table-column label="公司缴纳" align="center" prop="housingFundCompany" v-if="columns[18].visible"/>
      </el-table-column>
      <el-table-column label="个人缴费总额" align="center" prop="sumSelf" v-if="columns[19].visible" width="120"/>
      <el-table-column label="公司缴费总额" align="center" prop="sumCompany" v-if="columns[20].visible" width="120"/>
      <el-table-column label="备注" align="center" prop="comments"/>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
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
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getSocialInsuranceSummary} from "@/api/system/statement";

export default {
  name: "socialinsurancesummary",
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
    }
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
      getSocialInsuranceSummary(this.queryParams).then(response => {
        this.socialInsuranceList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    refresh() {
      this.getList()
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('statistics/export/SocialInsuranceSummary', {
        ...this.queryParams
      }, `socialInsurance_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

