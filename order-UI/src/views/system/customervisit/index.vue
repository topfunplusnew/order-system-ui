<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="客户" prop="customer">
        <el-input
          v-model="queryParams.customer"
          placeholder="请输入客户姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="区域" prop="region">
        <el-input
          v-model="queryParams.region"
          placeholder="请输入区域"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="日期" prop="submittime">
        <el-input
          v-model="queryParams.submittime"
          placeholder="请输入日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="姓名" prop="personnel">
        <el-input
          v-model="queryParams.personnel"
          placeholder="请输入姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>

      <!--      <el-form-item>-->
      <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>-->
      <!--      </el-form-item>-->
    </el-form>

    <el-row :gutter="10" class="mb8">
      <!-- 刷新按钮-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:customervisit:add']"
        >新增走访记录
        </el-button>
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
              v-hasPermi="['system:customervisit:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="CustomerVisitList" @selection-change="handleSelectionChange"
              id="printBox"
              v-horizontal-scroll="'always'">
      <!--      <el-table-column type="selection" width="55" align="center" />-->
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="是否审核" align="center" prop="isCheckState" v-if="columns[0].visible"/>
      <el-table-column label="人员" align="center" prop="personnel" v-if="columns[1].visible"/>
      <el-table-column label="区域" align="center" prop="region" v-if="columns[2].visible"/>
      <el-table-column label="客户名称" align="center" prop="customer" v-if="columns[3].visible"/>
      <el-table-column label="负责人姓名" align="center" prop="leaderName" v-if="columns[4].visible"/>
      <el-table-column label="负责人电话" align="center" prop="LeaderTel" v-if="columns[5].visible"/>
      <el-table-column label="厂房设备" align="center" prop="equipment" v-if="columns[6].visible"/>
      <el-table-column label="竞争对手" align="center" prop="competitor" v-if="columns[7].visible"/>
      <el-table-column label="当地经销商" align="center" prop="localDealer" v-if="columns[8].visible"/>
      <el-table-column label="月用货量" align="center" prop="monthlyConsumption" v-if="columns[9].visible"/>
      <el-table-column label="白玻用货习惯及厂家" align="center" prop="whiteGlassFactory" v-if="columns[10].visible"/>
      <el-table-column label="lowe玻璃用货厂家及用量" align="center" prop="loweGlassConsumption"
                       v-if="columns[11].visible"/>
      <el-table-column label="色玻、过度色玻璃用货厂家及用量" align="center" prop="colorGlassConsumption"
                       v-if="columns[12].visible"/>
      <el-table-column label="特色厚度、特殊尺寸、协议品用货厂家及用量" align="center" prop="specialGlassConsumption"
                       v-if="columns[13].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[14].visible"/>
      <el-table-column label="提交时间" align="center" prop="submittime" v-if="columns[15].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:customervisit:edit']"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:customervisit:remove']"
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

    <!-- 添加或修改走访记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="70%" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-col :span="8">
          <el-form-item label="是否审核" prop="isCheckState">
            <el-input v-model="form.checkState" placeholder="请输入审核标志"/>
          </el-form-item>
          <el-form-item label="人员" prop="personnel">
            <el-input v-model="form.county" placeholder="请输入人员"/>
          </el-form-item>
          <el-form-item label="区域" prop="region">
            <el-input v-model="form.customer" type="textarea" placeholder="请输入区域"/>
          </el-form-item>
          <el-form-item label="客户名称" prop="customer">
            <el-input v-model="form.city" placeholder="请输入客户名称"/>
          </el-form-item>
          <el-form-item label="负责人" prop="leaderName">
            <el-input v-model="form.leaderName" type="textarea" placeholder="请输入内容"/>
          </el-form-item>
          <el-form-item label="负责人电话" prop="LeaderTel">
            <el-input v-model="form.LeaderTel" type="textarea" placeholder="请输入内容"/>
          </el-form-item>
          <el-form-item label="厂房设备" prop="equipment">
            <el-input v-model="form.equipment" placeholder="请输入厂房设备"/>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="竞争对手" prop="competitor">
            <el-input v-model="form.competitor" placeholder="请输入竞争对手"/>
          </el-form-item>
          <el-form-item label="当地经销商" prop="localDealer">
            <el-input v-model="form.localDealer" placeholder="请输入当地经销商"/>
          </el-form-item>
          <el-form-item label="月用货量" prop="monthlyConsumption">
            <el-input v-model="form.monthlyConsumption" placeholder="请输入月用货量"/>
          </el-form-item>
          <el-form-item label="白玻用货习惯及厂家" prop="whiteGlassFactory">
            <el-input v-model="form.whiteGlassFactory" placeholder="请输入白玻用货习惯及厂家"/>
          </el-form-item>
          <el-form-item label="lowe玻璃用货厂家及用量" prop="loweGlassConsumption">
            <el-input v-model="form.loweGlassConsumption" placeholder="请输入lowe玻璃用货厂家及用量"/>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="色玻、过度色玻璃用货厂家及用量" prop="colorGlassConsumption">
            <el-input v-model="form.colorGlassConsumption" placeholder="请输入色玻、过度色玻璃用货厂家及用量"/>
          </el-form-item>
          <el-form-item label="特色厚度、特殊尺寸、协议品用货厂家及用量" prop="specialGlassConsumption">
            <el-input v-model="form.specialGlassConsumption"
                      placeholder="请输入特色厚度、特殊尺寸、协议品用货厂家及用量"/>
          </el-form-item>
          <el-form-item label="备注" prop="comments">
            <el-input v-model="form.comments" placeholder="请输入备注"/>
          </el-form-item>
          <el-form-item label="提交时间" prop="submittime">
            <el-input v-model="form.submittime" placeholder="请输入添加时间"/>
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
  listCustomerVisit,
  getCustomerVisit,
  delCustomerVisit,
  addCustomerVisit,
  updateCustomerVisit
} from "@/api/system/CustomerVisit";
import {excludeParams} from "@/api/tool/exclude";

export default {
  name: "CustomerVisit",
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
      // 走访记录表格数据
      CustomerVisitList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        province: null,
        city: null,
        county: null,
        customer: null,
        leaderName: null,
        LeaderTel: null,
        equipment: null,
        competitor: null,
        localDealer: null,
        monthlyConsumption: null,
        whiteGlassFactory: null,
        loweGlassConsumption: null,
        colorGlassConsumption: null,
        specialGlassConsumption: null,
        comments: null,
        submittime: null,
        userId: null,
        UserName: null,
        visitDate: null,
        checkState: null,
        checkUserID: null,
        checkUserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `是否审核`, visible: true},
        {key: 1, label: `人员`, visible: true},
        {key: 2, label: `区域`, visible: true},
        {key: 3, label: `客户名称`, visible: true},
        {key: 4, label: `负责人姓名`, visible: true},
        {key: 5, label: `负责人电话`, visible: true},
        {key: 6, label: `厂房设备`, visible: true},
        {key: 7, label: `竞争对手`, visible: true},
        {key: 8, label: `当地经销商`, visible: true},
        {key: 9, label: `月用货量`, visible: true},
        {key: 10, label: `白玻用货习惯及厂家`, visible: true},
        {key: 11, label: `lowe玻璃用货厂家及用量`, visible: true},
        {key: 12, label: `色玻、过度色玻璃用货厂家及用量`, visible: true},
        {key: 13, label: `特色厚度、特殊尺寸、协议品用货厂家及用量`, visible: true},
        {key: 14, label: `备注`, visible: true},
        {key: 15, label: `提交时间`, visible: true},
      ],
    };
  },

  created() {
    this.getList();
    if (localStorage.getItem('customervisit-columns') === 'null'
      || !localStorage.getItem('customervisit-columns')) {
      //设置localStorage
      localStorage.setItem("customervisit-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('customervisit-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("customervisit-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    /** 查询走访记录列表 */
    getList() {
      this.loading = true;
      listCustomerVisit(this.queryParams).then(response => {
        this.CustomerVisitList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 打印按钮操作
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        province: null,
        city: null,
        county: null,
        customer: null,
        leaderName: null,
        LeaderTel: null,
        equipment: null,
        competitor: null,
        localDealer: null,
        monthlyConsumption: null,
        whiteGlassFactory: null,
        loweGlassConsumption: null,
        colorGlassConsumption: null,
        specialGlassConsumption: null,
        comments: null,
        submittime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        visitDate: null,
        checkState: null,
        checkUserID: null,
        checkUserName: null,
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
      this.title = "添加走访记录";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getCustomerVisit(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改走访记录";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form = excludeParams(this.form, this.$exclude)
            updateCustomerVisit(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form = excludeParams(this.form, this.$exclude)
            addCustomerVisit(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除走访记录编号为"' + ids + '"的数据项？').then(function () {
        return delCustomerVisit(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/CustomerVisit/export', {
        ...this.queryParams
      }, `CustomerVisit_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
