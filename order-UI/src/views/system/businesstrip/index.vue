<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
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
          plain
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:BusinessTrip:add']"
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
              v-hasPermi="['system:BusinessTrip:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="BusinessTripList"
              @selection-change="handleSelectionChange">
      <!--      <el-table-column label="报销人ID" align="center" prop="employeeID"/>-->
      <el-table-column label="报销人" align="center" prop="employee" v-if="columns[0].visible"/>
      <el-table-column label="共同出差人员" align="center" prop="personnel" v-if="columns[1].visible"/>
      <el-table-column label="出差时间" align="center" prop="starttime" v-if="columns[2].visible"/>
      <el-table-column label="出差结束时间" align="center" prop="endtime" v-if="columns[3].visible"/>
      <el-table-column label="附件地址" align="center" prop="attachmentPath" v-if="columns[4].visible"/>
      <el-table-column label="是否已报销" align="center" prop="isReimburse" v-if="columns[5].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[6].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:BusinessTrip:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:BusinessTrip:remove']"
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
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <!--      头部流程信息-->
      <el-row>
        <div>
          <el-steps :active="active" finish-status="success">
            <el-step title="基本信息登记">
            </el-step>
            <el-step title="报销信息">
            </el-step>
          </el-steps>
        </div>
      </el-row>
      <!--      提示信息-->
      <br/>
      <el-row>
        <el-alert
          title="各填写信息相互独立！"
          type="info">
        </el-alert>
      </el-row>
      <br/>
      <el-row justify="center">
        <el-col :span="24">
          <el-row v-if="active === 0">
            <el-col :span="24">
              <el-row>
                <el-form ref="form" :model="form" :rules="rules" label-width="80px">
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
                      <!--          <el-input v-model="form.attachmentPath" placeholder="请输入附件地址"/>-->
                      <file-upload @input="handleFileUpload"/>
                      <img v-if="isImg" :src="form.attachmentPath" alt="" style="width: 300px;height: 200px">
                    </el-form-item>
                    <el-form-item label="备注" prop="comments">
                      <el-input v-model="form.comments" type="textarea" placeholder="请输入内容"/>
                    </el-form-item>
                    <el-form-item label="是否使用车辆" prop="useCar">
                      <el-radio v-model="useCar" label="是">是</el-radio>
                      <el-radio v-model="useCar" label="否">否</el-radio>
                    </el-form-item>
                  </el-col>
                </el-form>
              </el-row>
              <div>
                <el-button type="primary" @click="handleWriteCarsInfo" v-if="useCar ==='是'">填写车辆使用信息
                </el-button>
              </div>
            </el-col>
          </el-row>
          <el-row v-if="active === 1">
            <el-row :gutter="10" class="mb8">
              <el-col :span="1.5">
                <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddTripReimbursement">添加
                </el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteTripReimbursement">
                  删除
                </el-button>
              </el-col>
            </el-row>
            <el-table :data="tripReimbursementList" :row-class-name="rowTripReimbursementIndex"
                      @selection-change="handleTripReimbursementSelectionChange" ref="tripReimbursement">
              <el-table-column type="selection" width="50" align="center"/>
              <el-table-column label="序号" align="center" prop="index" width="50"/>
              <el-table-column label="报销项" prop="item" width="150">
                <template slot-scope="scope">
                  <el-input v-model="scope.row.item" placeholder="请输入报销项"/>
                </template>
              </el-table-column>
              <el-table-column label="费用" prop="itemCost">
                <template slot-scope="scope">
                  <el-input v-model="scope.row.itemCost" placeholder="请输入费用"/>
                </template>
              </el-table-column>
            </el-table>
          </el-row>
          <!--          完成提交的页面-->
          <el-row v-if="active === 2">
            <el-result icon="success" title="申请提交成功">
              <template slot="extra">
                <el-button type="primary" size="medium" @click="closeAll">关闭</el-button>
              </template>
            </el-result>
          </el-row>
        </el-col>
      </el-row>
      <div slot="footer" class="dialog-footer" v-if="active !== 2">
        <el-button type="warning" @click="before" v-if="active !== 0">上一步</el-button>
        <el-button type="warning" @click="next" v-if="active !== 1">下一步</el-button>
        <el-button type="success" @click="nextAndSubmit" v-if="active === 1">完成提交</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!--    车辆使用申请-->
    <el-dialog title="车辆使用申请" :visible.sync="carApplyVisible" append-to-body>
      <el-form ref="carApplyForm" :model="carApplyForm" :rules="rules" label-width="80px">
        <!--        自动填充以下字段-->
        <!--          <el-form-item label="申请人" prop="applyUser">-->
        <!--            <el-input v-model="carApplyForm.applyUser" placeholder="请输入申请人"/>-->
        <!--          </el-form-item>-->
        <!--          <el-form-item label="部门" prop="department">-->
        <!--            <el-input v-model="carApplyForm.department" placeholder="请输入部门"/>-->
        <!--          </el-form-item>-->
        <el-col :span="8">
          <el-form-item label="申请时间" prop="applyDate">
            <el-date-picker
              v-model="carApplyForm.applyDate"
              type="date"
              placeholder="选择申请时间"
              value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <!--          车辆信息搜索-->
          <el-form-item label="车牌" prop="carNo">
            <el-input v-model="carApplyForm.carNo" placeholder="请输入车牌"/>
            <SearchOption :limit-info="{dictType:'order_cars'}"
                          :get-data="listData" query-label="车牌搜索"
                          :query-name="queryCars"
                          query-info="dictLabel"
                          @update:queryName="updateQueryCars"
                          @commitBack="handleCommitBackCars">
              <template #table-columns>
                <el-table-column label="车牌" prop="dictLabel"/>
              </template>
            </SearchOption>
          </el-form-item>
          <el-form-item label="是否携带油卡" prop="isUseOilCard">
            <el-radio v-model="carApplyForm.isUseOilCard" label="1">是</el-radio>
            <el-radio v-model="carApplyForm.isUseOilCard" label="0">否</el-radio>
          </el-form-item>
          <el-form-item label="随同乘车人员" prop="peers">
            <el-input v-model="carApplyForm.peers" placeholder="请输入随同乘车人员"/>
          </el-form-item>
          <el-form-item label="用车时间" prop="startTime">
            <el-date-picker
              v-model="carApplyForm.startTime"
              type="date"
              placeholder="选择用车时间"
              value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="还车时间" prop="endTime">
            <el-date-picker
              v-model="carApplyForm.endTime"
              type="date"
              placeholder="选择还车时间"
              value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="回来后里程" prop="endMile">
            <el-input v-model="carApplyForm.endMile" placeholder="请输入回来后里程"/>
          </el-form-item>
          <el-form-item label="回来后车况" prop="endCarState">
            <el-input v-model="carApplyForm.endCarState" placeholder="请输入回来后车况"/>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="用车里程数" prop="miles">
            <el-input v-model="carApplyForm.miles" placeholder="请输入用车里程数"/>
          </el-form-item>
          <el-form-item label="回程停靠位置" prop="backStopPlace">
            <el-input v-model="carApplyForm.backStopPlace" placeholder="请输入回程停靠位置"/>
          </el-form-item>
          <el-form-item label="行程中违法次数" prop="violationsCount">
            <el-input v-model="carApplyForm.violationsCount" placeholder="请输入行程中违法次数"/>
          </el-form-item>
          <el-form-item label="违章罚款金额金额" prop="fine">
            <el-input v-model="carApplyForm.fine" placeholder="请输入违章罚款金额金额"/>
          </el-form-item>
          <el-form-item label="用车事由" prop="ApplyPurpose">
            <el-input v-model="carApplyForm.ApplyPurpose" placeholder="请输入用车事由"/>
          </el-form-item>
          <el-form-item label="出车前里程" prop="startMile">
            <el-input v-model="carApplyForm.startMile" placeholder="请输入出车前里程"/>
          </el-form-item>
          <el-form-item label="出车前车况" prop="startCarState">
            <el-input v-model="carApplyForm.startCarState" placeholder="请输入出车前车况"/>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="行程中是否维修/保养" prop="isMaintenance">
            <el-radio v-model="carApplyForm.isMaintenance" label="是">是</el-radio>
            <el-radio v-model="carApplyForm.isMaintenance" label="否">否</el-radio>
          </el-form-item>
          <el-form-item label="保养金额" prop="maintenanceMoney">
            <el-input v-model="carApplyForm.maintenanceMoney" placeholder="请输入保养金额"/>
          </el-form-item>
          <el-form-item label="行程中使用加油卡加油次数" prop="refuelingFrequency">
            <el-input v-model="carApplyForm.refuelingFrequency" placeholder="请输入行程中使用加油卡加油次数"/>
          </el-form-item>
          <el-form-item label="派车人" prop="dispatchPerson">
            <el-input v-model="carApplyForm.dispatchPerson" placeholder="请输入派车人"/>
          </el-form-item>
          <el-form-item label="备注" prop="comments">
            <el-input v-model="carApplyForm.comments" placeholder="请输入备注"/>
          </el-form-item>
          <el-form-item label="附件" prop="path">
            <file-upload @input="handleFileUploadCarApply"/>
          </el-form-item>
        </el-col>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <!--        车辆信息填写完成后，先保存 后续使用-->
        <el-button type="primary" @click="submitCarApply">保存填写</el-button>
        <el-button type="danger" @click="clearCarApply">清除填写</el-button>
        <el-button @click="carApplyVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listBusinessTrip,
  getBusinessTrip,
  delBusinessTrip,
  addBusinessTrip,
  updateBusinessTrip
} from "@/api/system/BusinessTrip";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {findFileExtension, prefix} from "@/utils/trash/utils";
import {mixin_upload} from "@/views/dashboard/mixins/upload";
import SearchOption from "@/components/SearchOption.vue";
import {listData} from "@/api/system/dict/data";
import Vue from "vue";
import {mapGetters} from "vuex";
import {addCarApply} from "@/api/system/carApply";

export default {
  name: "BusinessTrip",
  components: {SearchOption},
  mixins: [mixin_printHTML, mixin_upload],
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
      rules: {},
      columns: [
        {key: 0, label: `报销人`, visible: true},
        {key: 1, label: `共同出差人员`, visible: true},
        {key: 2, label: `出差时间`, visible: true},
        {key: 3, label: `出差结束时间`, visible: true},
        {key: 4, label: `附件地址`, visible: true},
        {key: 5, label: `是否已报销`, visible: true},
        {key: 6, label: `备注`, visible: true},
      ],
      active: 0,
      //是否使用车辆
      useCar: false,
      carApplyForm: {
        carNo: '',
        isMaintenance: '',
        isReimburse: '',
      },
      carApplyVisible: false,
      //车辆查询
      queryCars: ''
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('BusinessTrip-columns') === 'null'
      || !localStorage.getItem('BusinessTrip-columns')) {
      //设置localStorage
      localStorage.setItem("BusinessTrip-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('BusinessTrip-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("BusinessTrip-columns", JSON.stringify(newVal))
      },
      deep: true,
    },

  },
  computed: {
    ...mapGetters(['trueName'])
  },
  methods: {
    listData,
    before() {
      if (this.active-- <= 0) this.active = 0;
    },
    next() {
      if (this.active++ > 2) this.active = 0;
    },
    //提交车辆使用申请 保存使用车辆信息
    submitCarApply() {
      sessionStorage.setItem('carApplyForm', JSON.stringify(this.carApplyForm))
      this.$message.success('车辆信息保存成功~')
      //清除状态
      this.carApplyForm = this.$refreshParams(this.carApplyForm)
      this.carApplyVisible = false
    },
    //清除缓存
    clearCarApply() {
      sessionStorage.removeItem('carApplyForm')
      this.carApplyForm = this.$refreshParams(this.carApplyForm)
      this.carApplyVisible = false
    },
    //车辆使用申请的附件
    handleFileUploadCarApply(url) {
      this.carApplyForm.path = url
    },
    closeAll() {
      this.active = 0;
      this.open = false
    },
    updateQueryCars(val) {
      this.queryCars = val;
    },
    handleCommitBackCars(val) {
      this.carApplyForm.carNo = val.dictLabel
    },
    //打开车辆申请信息填写
    handleWriteCarsInfo() {
      const json = sessionStorage.getItem('carApplyForm')
      //如果没有存储对象
      if (JSON.parse(json) === null) {
        this.carApplyVisible = true;
      } else {
        const keys = Object.keys(JSON.parse(json))
        for (let property of keys) {
          //是否包含该属性 包含则给 不包含给空
          this.$set(this.carApplyForm, property, keys.includes(property) ? JSON.parse(json)[property] : '')
        }
        this.carApplyVisible = true;
      }
    },
    //完成提交
    nextAndSubmit() {
      //保存报销信息
      this.form.tripReimbursementList = this.tripReimbursementList;
      //form 是出差申请基本信息 carApplyInfo是车辆使用信息
      let carApplyInfo = JSON.parse(sessionStorage.getItem('carApplyForm'))
      //填充某些字段
      carApplyInfo.applyUser = this.form.employee;
      carApplyInfo.department = this.form.deptName;
      //先提交申请信息 回调函数中添加车辆使用信息
      addBusinessTrip(this.form).then(res => {
        console.log(res)
        this.$message.success('提交成功')
        //添加车辆信息
        setTimeout(() => {
          addCarApply(carApplyInfo).then(res => {
            this.$message.success('车辆信息提交成功')
            this.active++;
          })
        }, 30)
      })
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
      this.reset();
    },
    // 表单重置
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
      //这里重置了form
      this.reset();
      //自动填充填写人
      this.form.employee = this.trueName;
      this.open = true;
      this.title = "添加出差";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBusinessTrip(id).then(response => {
        this.form = response.data;
        this.tripReimbursementList = response.data.tripReimbursementList;
        this.open = true;
        this.title = "修改出差";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.tripReimbursementList = this.tripReimbursementList;
          if (this.form.id != null) {
            updateBusinessTrip(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addBusinessTrip(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除出差编号为"' + ids + '"的数据项？').then(function () {
        return delBusinessTrip(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 出差报销序号 */
    rowTripReimbursementIndex({row, rowIndex}) {
      row.index = rowIndex + 1;
    },
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
    },
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
    },
    /** 复选框选中数据 */
    handleTripReimbursementSelectionChange(selection) {
      this.checkedTripReimbursement = selection.map(item => item.index)
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/BusinessTrip/export', {
        ...this.queryParams
      }, `BusinessTrip_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
