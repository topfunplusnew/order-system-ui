<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车牌" prop="carNo">
        <el-input
          v-model="queryParams.carNo"
          placeholder="请输入车牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="用车时间" prop="startTime">
        <el-input
          v-model="queryParams.startTime"
          placeholder="请输入用车时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="还车时间" prop="endTime">
        <el-input
          v-model="queryParams.endTime"
          placeholder="请输入还车时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="派车人" prop="dispatchPerson">
        <el-input
          v-model="queryParams.dispatchPerson"
          placeholder="请输入派车人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
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
              v-hasPermi="['system:carapply:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="carApplyList" @selection-change="handleSelectionChange" id="printBox"
              v-horizontal-scroll="'always'">
      <el-table-column label="申请时间" align="center" prop="applyDate" v-if="columns[0].visible"/>
      <el-table-column label="申请人" align="center" prop="applyUser" v-if="columns[1].visible"/>
      <el-table-column label="部门" align="center" prop="department" v-if="columns[2].visible"/>
      <el-table-column label="车牌" align="center" prop="carNo" v-if="columns[3].visible"/>
      <el-table-column label="是否携带油卡" align="center" prop="isUseOilCard" v-if="columns[4].visible"/>
      <el-table-column label="随同乘车人员" align="center" prop="peers" v-if="columns[5].visible"/>
      <el-table-column label="用车时间" align="center" prop="startTime" v-if="columns[6].visible"/>
      <el-table-column label="还车时间" align="center" prop="endTime" v-if="columns[7].visible"/>
      <el-table-column label="用车事由" align="center" prop="ApplyPurpose" v-if="columns[8].visible"/>
      <el-table-column label="出车前里程" align="center" prop="startMile" v-if="columns[9].visible"/>
      <el-table-column label="出车前车况" align="center" prop="startCarState" v-if="columns[10].visible"/>
      <el-table-column label="回来后里程" align="center" prop="endMile" v-if="columns[11].visible"/>
      <el-table-column label="回来后车况" align="center" prop="endCarState" v-if="columns[12].visible"/>
      <el-table-column label="用车里程数" align="center" prop="miles" v-if="columns[13].visible"/>
      <el-table-column label="回程停靠位置" align="center" prop="backStopPlace" v-if="columns[14].visible"/>
      <el-table-column label="行程中违法次数" align="center" prop="violationsCount" v-if="columns[15].visible"/>
      <el-table-column label="违章罚款金额" align="center" prop="fine" v-if="columns[16].visible"/>
      <el-table-column label="行程中是否维修/保养" align="center" prop="isMaintenance" v-if="columns[17].visible"/>
      <el-table-column label="保养金额" align="center" prop="maintenanceMoney" v-if="columns[18].visible"/>
      <el-table-column label="行程中使用加油卡加油次数" align="center" prop="refuelingFrequency"
                       v-if="columns[19].visible"/>
      <el-table-column label="派车人" align="center" prop="dispatchPerson" v-if="columns[20].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[21].visible"/>
      <el-table-column label="附件路径" align="center" prop="path" v-if="columns[22].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:carapply:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:carapply:remove']"
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

    <!-- 添加或修改车辆使用申请对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        <el-form-item label="出差编号UUID" prop="bTripId">-->
        <!--          <el-input v-model="form.bTripId" placeholder="请输入出差编号UUID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="申请时间" prop="applyDate">
          <el-input v-model="form.applyDate" placeholder="请输入申请时间"/>
        </el-form-item>
        <el-form-item label="申请人" prop="applyUser">
          <el-input v-model="form.applyUser" placeholder="请输入申请人"/>
        </el-form-item>
        <el-form-item label="部门" prop="department">
          <el-input v-model="form.department" placeholder="请输入部门"/>
        </el-form-item>
        <el-form-item label="车牌" prop="carNo">
          <el-input v-model="form.carNo" placeholder="请输入车牌"/>
        </el-form-item>
        <el-form-item label="是否携带油卡" prop="isUseOilCard">
          <el-input v-model="form.isUseOilCard" placeholder="请输入是否携带油卡"/>
        </el-form-item>
        <el-form-item label="随同乘车人员" prop="peers">
          <el-input v-model="form.peers" placeholder="请输入随同乘车人员"/>
        </el-form-item>
        <el-form-item label="用车时间" prop="startTime">
          <el-input v-model="form.startTime" placeholder="请输入用车时间"/>
        </el-form-item>
        <el-form-item label="还车时间" prop="endTime">
          <el-input v-model="form.endTime" placeholder="请输入还车时间"/>
        </el-form-item>
        <el-form-item label="用车事由" prop="ApplyPurpose">
          <el-input v-model="form.ApplyPurpose" placeholder="请输入用车事由"/>
        </el-form-item>
        <el-form-item label="出车前里程" prop="startMile">
          <el-input v-model="form.startMile" placeholder="请输入出车前里程"/>
        </el-form-item>
        <el-form-item label="出车前车况" prop="startCarState">
          <el-input v-model="form.startCarState" placeholder="请输入出车前车况"/>
        </el-form-item>
        <el-form-item label="回来后里程" prop="endMile">
          <el-input v-model="form.endMile" placeholder="请输入回来后里程"/>
        </el-form-item>
        <el-form-item label="回来后车况" prop="endCarState">
          <el-input v-model="form.endCarState" placeholder="请输入回来后车况"/>
        </el-form-item>
        <el-form-item label="用车里程数" prop="miles">
          <el-input v-model="form.miles" placeholder="请输入用车里程数"/>
        </el-form-item>
        <el-form-item label="回程停靠位置" prop="backStopPlace">
          <el-input v-model="form.backStopPlace" placeholder="请输入回程停靠位置"/>
        </el-form-item>
        <el-form-item label="行程中违法次数" prop="violationsCount">
          <el-input v-model="form.violationsCount" placeholder="请输入行程中违法次数"/>
        </el-form-item>
        <el-form-item label="违章罚款金额金额" prop="fine">
          <el-input v-model="form.fine" placeholder="请输入违章罚款金额金额"/>
        </el-form-item>
        <el-form-item label="行程中是否维修/保养" prop="isMaintenance">
          <el-input v-model="form.isMaintenance" placeholder="请输入行程中是否维修/保养"/>
        </el-form-item>
        <el-form-item label="保养金额" prop="maintenanceMoney">
          <el-input v-model="form.maintenanceMoney" placeholder="请输入保养金额"/>
        </el-form-item>
        <el-form-item label="行程中使用加油卡加油次数" prop="refuelingFrequency">
          <el-input v-model="form.refuelingFrequency" placeholder="请输入行程中使用加油卡加油次数"/>
        </el-form-item>
        <el-form-item label="派车人" prop="dispatchPerson">
          <el-input v-model="form.dispatchPerson" placeholder="请输入派车人"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
        <el-form-item label="附件路径" prop="path">
          <el-input v-model="form.path" placeholder="请输入附件路径"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listCarApply, getCarApply, delCarApply, addCarApply, updateCarApply} from "@/api/system/carApply";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";

export default {
  name: "CarApply",
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
      // 车辆使用申请表格数据
      carApplyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bTripId: null,
        applyDate: null,
        applyUser: null,
        department: null,
        carNo: null,
        isUseOilCard: null,
        peers: null,
        startTime: null,
        endTime: null,
        ApplyPurpose: null,
        startMile: null,
        startCarState: null,
        endMile: null,
        endCarState: null,
        miles: null,
        backStopPlace: null,
        violationsCount: null,
        fine: null,
        isMaintenance: null,
        maintenanceMoney: null,
        refuelingFrequency: null,
        dispatchPerson: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null,
        path: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `申请时间`, visible: true},
        {key: 1, label: `申请人`, visible: true},
        {key: 2, label: `部门`, visible: true},
        {key: 3, label: `车牌`, visible: true},
        {key: 4, label: `是否携带油卡`, visible: true},
        {key: 5, label: `随同乘车人员`, visible: true},
        {key: 6, label: `用车时间`, visible: true},
        {key: 7, label: `还车时间`, visible: true},
        {key: 8, label: `用车事由`, visible: true},
        {key: 9, label: `出车前里程`, visible: true},
        {key: 10, label: `出车前车况`, visible: true},
        {key: 11, label: `回来后历程`, visible: true},
        {key: 12, label: `回来后车况`, visible: true},
        {key: 13, label: `用车里程数`, visible: true},
        {key: 14, label: `回程停靠位置`, visible: true},
        {key: 15, label: `行程中违法次数`, visible: true},
        {key: 16, label: `违章罚款金额`, visible: true},
        {key: 17, label: `行程中是否维修/保养`, visible: true},
        {key: 18, label: `保养金额`, visible: true},
        {key: 19, label: `行程中使用加油卡加油次数`, visible: true},
        {key: 20, label: `派车人`, visible: true},
        {key: 21, label: `备注`, visible: true},
        {key: 22, label: `附件路径`, visible: true},

      ],
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('carapply-columns') === 'null'
      || !localStorage.getItem('carapply-columns')) {
      //设置localStorage
      localStorage.setItem("carapply-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('carapply-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("carapply-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    /** 查询车辆使用申请列表 */
    getList() {
      this.loading = true;
      listCarApply(this.queryParams).then(response => {
        this.carApplyList = response.rows;
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
        bTripId: null,
        applyDate: null,
        applyUser: null,
        department: null,
        carNo: null,
        isUseOilCard: null,
        peers: null,
        startTime: null,
        endTime: null,
        ApplyPurpose: null,
        startMile: null,
        startCarState: null,
        endMile: null,
        endCarState: null,
        miles: null,
        backStopPlace: null,
        violationsCount: null,
        fine: null,
        isMaintenance: null,
        maintenanceMoney: null,
        refuelingFrequency: null,
        dispatchPerson: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null,
        path: null
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
      this.title = "添加车辆使用申请";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getCarApply(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改车辆使用申请";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateCarApply(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addCarApply(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除车辆使用申请编号为"' + ids + '"的数据项？').then(function () {
        return delCarApply(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/carApply/export', {
        ...this.queryParams
      }, `carApply_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
