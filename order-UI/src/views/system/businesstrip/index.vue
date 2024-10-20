<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="出差时间" prop="starttime">
        <el-date-picker
          v-model="queryParams.starttime"
          type="date"
          placeholder="选择日期" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="返回时间" prop="endtime">
        <el-date-picker
          v-model="queryParams.endtime"
          type="date"
          placeholder="选择日期" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="danger"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:businesstrip:add']"
        >新增出差信息
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
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
              v-hasPermi="['system:businesstrip:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table size="mini" border v-horizontal-scroll="'always'" v-loading="loading" :data="BusinessTripList"
              @selection-change="handleSelectionChange" :cell-style="()=>{return {padding:'2px'}}">
      <!--      <el-table-column label="报销人ID" align="center" prop="employeeID"/>-->
      <el-table-column label="报销人" align="center" prop="employee" v-if="columns[0].visible"/>
      <el-table-column label="共同出差人员" align="center" prop="personnel" v-if="columns[1].visible"/>
      <el-table-column label="部门" align="center" prop="deptName" v-if="columns[2].visible"/>
      <el-table-column label="出差时间" align="center" prop="starttime" v-if="columns[3].visible"/>
      <el-table-column label="出差结束时间" align="center" prop="endtime" v-if="columns[4].visible"/>
      <el-table-column label="附件" align="center" prop="attachmentPath" v-if="columns[5].visible">
        <template #default="scope">
          <span v-if="!scope.row.attachmentPath">无</span>
          <span v-else>
            <a style="color: red"
               :href="scope.row.attachmentPath">
            <el-button size="mini" type="success">下载</el-button>
          </a>
         </span>
        </template>
      </el-table-column>
      <el-table-column label="是否已报销" align="center" prop="isReimburse" v-if="columns[6].visible">
        <template slot-scope="scope">
          {{ scope.row.isReimburse === 0 ? '否' : '是' }}
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[7].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="260px" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            @click="applyForPayment(scope.row)"
          >发起付款申请
          </el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:businesstrip:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:businesstrip:remove']"
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

    <!-- 添加或修改出差对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px">
      <StepsForm :active="active" title-one="基本信息登记" title-two="报销信息" title-info="请按照步骤填写出差信息">
        <!--         第一步骤 填写出差基本信息 保存出差基本信息-->
        <template #step-one>
          <el-form ref="form" :model="form" :rules="rules" label-width="120px">
            <el-col :span="12">
              <el-form-item label="报销人" prop="employee">
                <el-input v-model="form.employee" disabled placeholder="请输入报销人"/>
              </el-form-item>
              <el-form-item label="部门" prop="deptName">
                <el-input v-model="form.deptName" placeholder="请输入部门"/>
              </el-form-item>
              <el-form-item label="共同出差人员" prop="personnel">
                <el-input v-model="form.personnel" placeholder="请输入共同出差人员"/>
              </el-form-item>
              <el-form-item label="出差时间" prop="starttime">
                <el-date-picker
                  v-model="form.starttime"
                  type="date"
                  placeholder="选择出差时间"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="出差结束时间" prop="endtime">
                <el-date-picker
                  v-model="form.endtime"
                  type="date"
                  placeholder="选择出差结束时间"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="附件地址" prop="attachmentPath">
                <file-upload @input="handleCommitUpload"/>
              </el-form-item>
              <el-form-item label="备注" prop="comments">
                <el-input v-model="form.comments" type="textarea" placeholder="请输入内容"/>
              </el-form-item>
            </el-col>
          </el-form>
        </template>
        <!--        第二步骤 开始填写车辆使用信息-->
        <template #step-two>
          <el-row>
            <el-col :span="5">
                <span style="font-weight: bolder">
                  是否使用车辆
                </span>
            </el-col>
            <el-col :span="5">
              <el-radio v-model="useCar" label="是">是</el-radio>
              <el-radio v-model="useCar" label="否">否</el-radio>
            </el-col>
          </el-row>
          <el-row style="margin: 20px 0" v-if="useCar ==='是'">
            <el-card class="box-card">
              <div slot="header" class="clearfix">
                <span>车辆信息</span>
                <!--索引车辆使用信息-->
                <el-button style="float: right; padding: 3px 0;color: #409EFF;" size="mini" type="text"
                           @click="indexCarApplyInfo">
                  引用车辆使用信息
                </el-button>
              </div>
              <div style="text-align: center;color: #999" v-if="!hasCarApplyInfo">
                暂无车辆信息
              </div>
              <div v-else>
                <el-descriptions>
                  <el-descriptions-item label="申请时间">{{ carApplyInformation.applyDate }}</el-descriptions-item>
                  <el-descriptions-item label="申请人">{{ carApplyInformation.applyUser }}</el-descriptions-item>
                  <el-descriptions-item label="部门">{{ carApplyInformation.department }}</el-descriptions-item>
                  <el-descriptions-item label="车牌">
                    {{ carApplyInformation.carNo }}
                  </el-descriptions-item>
                  <el-descriptions-item label="用车时间">
                    {{ carApplyInformation.startTime }}
                  </el-descriptions-item>
                  <el-descriptions-item label="还车时间">
                    {{ carApplyInformation.endTime }}
                  </el-descriptions-item>
                  <el-descriptions-item label="用车事由">
                    {{ carApplyInformation.ApplyPurpose }}
                  </el-descriptions-item>
                </el-descriptions>
              </div>
            </el-card>
          </el-row>
          <hr/>
          <el-row :gutter="10" class="mb8">
            <el-col :span="5">
              <span style="font-weight: bolder">填写报销项</span>
            </el-col>
            <el-col :span="3">
              <el-button type="primary" size="mini" @click="handleAddTripReimbursement">添加报销项
              </el-button>
            </el-col>
            <el-col :span="3">
              <el-button type="danger" size="mini" @click="handleDeleteTripReimbursement">
                删除报销项
              </el-button>
            </el-col>
          </el-row>
          <el-table :data="tripReimbursementList" :row-class-name="rowTripReimbursementIndex"
                    @selection-change="handleTripReimbursementSelectionChange" ref="tripReimbursement">
            <el-table-column type="selection" width="100" align="center"/>
            <el-table-column label="序号" align="center" prop="index" width="150px"/>
            <el-table-column label="报销项" prop="item" width="350px">
              <template slot-scope="scope">
                <el-row>
                  <el-col :span="20">
                    <el-input v-model="scope.row.item" placeholder="请输入报销项" :disabled="scope.row.isDisabled"/>
                  </el-col>
                  <el-col :span="4">
                    <SubjectOption @update:type="(value)=>handleType(value,scope)"/>
                  </el-col>
                </el-row>
              </template>
            </el-table-column>
            <el-table-column label="费用" prop="itemCost">
              <template slot-scope="scope">
                <el-input v-model="scope.row.itemCost" type="number" placeholder="请输入费用"
                          :disabled="scope.row.isDisabled"/>
              </template>
            </el-table-column>
          </el-table>
        </template>
        <template #step-three>
          <el-result icon="success" title="申请提交成功">
            <template slot="extra">
              <el-button type="primary" size="medium" @click="closeAll">关闭</el-button>
            </template>
          </el-result>
        </template>
      </StepsForm>
      <div slot="footer" class="dialog-footer" v-if="active !== 2">
        <el-button type="warning" @click="before" v-if="active !== 0">上一步</el-button>
        <el-button type="warning" @click="next" v-if="active !== 1">下一步</el-button>
        <el-button type="success" @click="nextAndSubmit" v-if="active === 1">完成提交</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!--    车辆索引-->
    <InfoDialog :visible="indexCarApplyVisible" title="引用车辆使用信息" @close="indexCarApplyVisible = false">
      <template #info>
        <el-row>
          <el-table border v-loading="loading" :data="carApplyList" @selection-change="handleSelectionChange"
                    id="printBox"
                    v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'2px'}}">
            <el-table-column label="申请时间" align="center" prop="applyDate" show-overflow-tooltip/>
            <el-table-column label="申请人" align="center" prop="applyUser" show-overflow-tooltip/>
            <el-table-column label="部门" align="center" prop="department" show-overflow-tooltip/>
            <el-table-column label="车牌" align="center" prop="carNo" show-overflow-tooltip/>
            <el-table-column label="是否携带油卡" align="center" prop="isUseOilCard" show-overflow-tooltip>
              <template slot-scope="scope">
                {{ scope.row.isUseOilCard == 1 ? '是' : '否' }}
              </template>
            </el-table-column>
            <el-table-column label="随同乘车人员" align="center" prop="peers" show-overflow-tooltip/>
            <el-table-column label="用车时间" align="center" prop="startTime" show-overflow-tooltip/>
            <el-table-column label="还车时间" align="center" prop="endTime" show-overflow-tooltip/>
            <el-table-column label="用车事由" align="center" prop="applyPurpose" show-overflow-tooltip/>
            <el-table-column label="出车前里程" align="center" prop="startMile" show-overflow-tooltip/>
            <el-table-column label="出车前车况" align="center" prop="startCarState" show-overflow-tooltip/>
            <el-table-column label="回来后里程" align="center" prop="endMile" show-overflow-tooltip/>
            <el-table-column label="回来后车况" align="center" prop="endCarState" show-overflow-tooltip/>
            <el-table-column label="用车里程数" align="center" prop="miles" show-overflow-tooltip/>
            <el-table-column label="回程停靠位置" align="center" prop="backStopPlace" show-overflow-tooltip/>
            <el-table-column label="行程中违法次数" align="center" prop="violationsCount" show-overflow-tooltip/>
            <el-table-column label="违章罚款金额" align="center" prop="fine" show-overflow-tooltip/>
            <el-table-column label="行程中是否维修/保养" align="center" prop="isMaintenance" show-overflow-tooltip/>
            <el-table-column label="保养金额" align="center" prop="maintenanceMoney" show-overflow-tooltip/>
            <el-table-column label="行程中使用加油卡加油次数" align="center" prop="refuelingFrequency"
                             show-overflow-tooltip/>
            <el-table-column label="派车人" align="center" prop="dispatchPerson" show-overflow-tooltip/>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="success"
                  @click="indexThisCarApplyInfo(scope.row)"
                >引用
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-row>
      </template>
    </InfoDialog>
    <!--    付款申请弹窗-->
    <el-dialog :close-on-click-modal="false" :show-close="false"
               title="提示"
               :visible.sync="applyForPaymentDialogVisible"
               width="60%">
      <keep-alive>
        <ApplyPayment :table-name="TableName.BUSINESS_TRIP"
                      @changeupdateOrderItemVisible="changePaymentApplyInfoVisible"
                      :t-i-d="tID" :need-info="{}" :need-money="needMoney"/>
      </keep-alive>
    </el-dialog>

  </div>
</template>

<script>
import {
  delBusinessTrip,
  getBusinessTrip,
  listBusinessTrip,
} from "@/api/system/BusinessTrip";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import SearchOption from "@/components/SearchOption.vue";
import {listData} from "@/api/system/dict/data";
import {mapGetters} from "vuex";
import PaymentApply from "@/views/system/paymentApply/index.vue";
import ApplyPayment from "@/views/dashboard/components/common/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import {checkOilCard, listOilCard} from "@/api/system/oilCard";
import {listBankAccount} from "@/api/system/bankAccount";
import {addOilRecharge} from "@/api/system/oilRecharge";
import {parseTime} from "@/utils/ruoyi";
import {addOilCardConsume} from "@/api/system/OilCardConsume";
import {mixin_car_apply} from "../../dashboard/mixins/bussiness/index_car_apply";
import InfoDialog from "../../../components/InfoDialog.vue";
import {mixin_business_trip_add} from "../../dashboard/mixins/bussiness/business_trip_add";
import StepsForm from "../../dashboard/components/businessTrip/StepsForm.vue";
import {mixin_common_upload} from "../../dashboard/mixins/common/common_upload";
import {mixin_business_trip_update} from "../../dashboard/mixins/bussiness/business_trip_update";
import {mixin_business_trip_car_apply} from "../../dashboard/mixins/bussiness/bussiness_trip_car_apply";
import {mixin_business_trip_oil_card} from "../../dashboard/mixins/bussiness/bussiness_trip_oil_card";
import SubjectOption from "../../../components/SubjectOption.vue";

export default {
  name: "BusinessTrip",
  components: {SubjectOption, StepsForm, InfoDialog, ApplyPayment, PaymentApply, SearchOption},
  mixins: [mixin_printHTML, mixin_common_upload, mixin_car_apply, mixin_business_trip_add,
    mixin_business_trip_update, mixin_business_trip_car_apply, mixin_business_trip_oil_card
  ],
  data() {
    return {
      loading: true,
      ids: [],
      checkedTripReimbursement: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      BusinessTripList: [],
      tripReimbursementList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        employeeID: null,
        employee: null,
        personnel: null,
        starttime: null,
        endtime: null,
        attachmentPath: null,
        isReimburse: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      form: {
        employee: ''
      },
      rules: {
        employee: [{required: true, message: "请输入出差人员", trigger: "blur"}],
        personnel: [{required: true, message: "请输入出差人员", trigger: "blur"}],
        starttime: [{required: true, message: "请输入出差开始时间", trigger: "blur"}],
        endtime: [{required: true, message: "请输入出差结束时间", trigger: "blur"}],
      },
      columns: [
        {key: 0, label: `报销人`, visible: true},
        {key: 1, label: `共同出差人员`, visible: true},
        {key: 2, label: `部门`, visible: true},
        {key: 3, label: `出差时间`, visible: true},
        {key: 4, label: `出差结束时间`, visible: true},
        {key: 5, label: `附件地址`, visible: true},
        {key: 6, label: `是否已报销`, visible: true},
        {key: 7, label: `备注`, visible: true},
      ],
      // 当前步骤
      active: 0,

      //发起付款申请的
      applyForPaymentDialogVisible: false,
      tID: '',
      needMoney: 0,
      isRecharge: '',
      oilCardConsumeInfo: {
        oilCardNo: '',
        carNo: '',
        //附件路径
        attachmentOiladd: '',
        //充值金额 默认为0
        rechargeMoney: '0'
      },
      // 文件上传
      baseUrl: process.env.VUE_APP_BASE_API,
      uploadFileUrl: process.env.VUE_APP_BASE_API + "/common/upload", // 上传文件服务器地址

      options: [{
        value: '现金',
        label: '现金'
      }, {
        value: '银行卡',
        label: '银行卡'
      }],
      queryBankAcount: '',
      // 互斥变量UUID
      UUID: ''
    };
  }
  ,
  created() {
    this.getList();
    this.resetCarApplyForm()
    if (localStorage.getItem('BusinessTrip-columns') === 'null'
      || !localStorage.getItem('BusinessTrip-columns')) {
      //设置localStorage
      localStorage.setItem("BusinessTrip-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('BusinessTrip-columns'));
    }
  }
  ,
//展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("BusinessTrip-columns", JSON.stringify(newVal))
      },
      deep:
        true,
    },
    //监听是否携带了油卡 如果携带，那么要打开填写加油卡消费记录的弹窗
    'carApplyForm.isUseOilCard':
      {
        handler: (newVal) => {
          console.log(newVal)
        }
      }
  }
  ,
  computed: {
    TableName() {
      return TableName
    },
    ...mapGetters(['trueName']),
    ...mapGetters(['deptName'])
  },
  methods: {
    listBankAccount,
    listOilCard,
    listData,
    //发起付款申请
    applyForPayment(row) {
      getBusinessTrip(row.id).then(res => {
        // 出差费用包含 报销项 车辆使用申请的保养金额 加油金额 初期金额
        if (res.data.tripReimbursementList !== null && res.data.tripReimbursementList !== undefined) {
          if (res.data.tripReimbursementList.length > 0) {
            res.data.tripReimbursementList.forEach(item => {
              this.needMoney += item.itemCost
            })
          } else {
            this.needMoney = 0
          }
        } else {
          this.needMoney = 0
        }
        this.tID = row.id;
        this.applyForPaymentDialogVisible = true
      })
    },
    // 自动填写报销项
    handleType(value, scope) {
      scope.row.item = value;
    },

    // 文件上传
    handleFileSuccess(response, file, fileList) {
      if (response.code === 200) {
        this.oilCardConsumeInfo.attachmentOiladd = response.url
        this.$message.success('上传成功')
      } else {
        this.$message.error('上传失败')
      }
      fileList.pop();
    }
    ,
    // 查看附件
    checkPath(path) {
      window.open(path)
    },

    /** 查询出差列表 */
    getList() {
      this.loading = true;
      listBusinessTrip(this.queryParams).then(response => {
        this.BusinessTripList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.active = 0;
      this.reset();
      this.resetCarApplyInformation()
      // 设置索引为false
      this.isIndexCarInfo = false
    }
    ,
    // 出差信息表单重置
    reset() {
      this.form = {
        id: null,
        employeeID: null,
        employee: null,
        personnel: null,
        starttime: null,
        endtime: null,
        attachmentPath: null,
        isReimburse: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
      };
      this.tripReimbursementList = [];
      this.resetForm("form");
    }
    ,
    // 重置车辆申请的状态
    resetCarApplyForm() {
      this.carApplyForm = {
        applyDate: parseTime(new Date(), '{y}-{m}-{d}'),
        applyUser: this.trueName,
        department: this.deptName, // 从vuex中拿到
        carNo: '',
        isUseOilCard: '0',
        refuelingFrequency: '',
        applyPurpose: '',
        startTime: '',
        endTime: '',
        miles: '',
        endMile: '',
        startMile: '',
        startCarState: '',
        endCarState: '',
        backStopPlace: '',
        violationsCount: '',
        fine: '',
        isMaintenance: '否',
        maintenanceMoney: '',
        dispatchPerson: '',
        peers: '',
        comments: '',
        path: ''
      };
    },
    // 重置车辆申请信息
    resetCarApplyInformation() {
      this.hasCarApplyInfo = false
      this.carApplyInformation = {
        applyDate: parseTime(new Date(), '{y}-{m}-{d}'),
        applyUser: this.trueName,
        department: this.deptName, // 从vuex中拿到
        carNo: '',
        isUseOilCard: '0',
        refuelingFrequency: '',
        applyPurpose: '',
        startTime: '',
        endTime: '',
        miles: '',
        endMile: '',
        startMile: '',
        startCarState: '',
        endCarState: '',
        backStopPlace: '',
        violationsCount: '',
        fine: '',
        isMaintenance: '否',
        maintenanceMoney: '',
        dispatchPerson: '',
        peers: '',
        comments: '',
        path: ''
      };
    }
    ,
    // 重置加油卡重置信息的表单
    resetOilCardRechargeInfo() {
      this.moneyInfo = {
        oilCardNo: '',
        rechargeType: '',
        rechargeMoney: '',
        rechargeDate: parseTime(new Date(), '{y}-{m}-{d}'),
        rechargeName: "",
        acountsName: "",
        bankNo: "",
        attachment: '',
        comments: ''
      }
    }
    ,
    // 充值加油卡消费信息的表单
    resetOilCardConsumeInfo() {
      this.oilCardConsumeInfo = {
        oilCardNo: '',           // 加油卡卡号
        useDate: '',             // 使用加油卡时间
        carNo: '',               // 车辆车牌号
        startCardSurplus: '',    // 期初余额
        rechargeMoney: '',       // 充值金额
        refuelingNumber: '',     // 加油量
        unitPrice: '',           // 单价
        refuelingMoney: '',      // 加油金额
        attachmentOiladd: '',    // 加油小票附件路径
        comments: '',            // 备注
      };
    }
    ,
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    }
    ,
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    }
    ,
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    }
    ,

    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除出差编号为"' + ids + '"的数据项？').then(function () {
        return delBusinessTrip(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    }
    ,
    /** 出差报销序号 */
    rowTripReimbursementIndex({row, rowIndex}) {
      row.index = rowIndex + 1;
    }
    ,
    /** 出差报销添加按钮操作 */
    handleAddTripReimbursement() {
      let obj = {};
      obj.item = "";
      obj.itemCost = "";
      obj.comments = "";
      obj.addtime = "";
      obj.userId = "";
      obj.UserName = "";
      obj.delFlag = "";
      this.tripReimbursementList.push(obj);
    }
    ,
    /** 出差报销删除按钮操作 */
    handleDeleteTripReimbursement() {
      if (this.checkedTripReimbursement.length == 0) {
        this.$modal.msgError("请先选择要删除的出差报销数据");
      } else {
        const tripReimbursementList = this.tripReimbursementList;
        const checkedTripReimbursement = this.checkedTripReimbursement;
        this.tripReimbursementList = tripReimbursementList.filter(function (item) {
          return checkedTripReimbursement.indexOf(item.index) == -1
        });
      }
    }
    ,
    /** 复选框选中数据 */
    handleTripReimbursementSelectionChange(selection) {
      this.checkedTripReimbursement = selection.map(item => item.index)
    }
    ,
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/BusinessTrip/export', {
        ...this.queryParams
      }, `BusinessTrip_${new Date().getTime()}.xlsx`)
    }
  }
}
;
</script>
