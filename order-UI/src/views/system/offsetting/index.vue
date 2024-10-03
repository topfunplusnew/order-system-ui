<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="操作时间" prop="operateDate">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="公司" prop="companyName">
        <el-input
          v-model="queryParams.companyName"
          placeholder="请输入公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="备注" prop="comments">
        <el-input
          v-model="queryParams.comments"
          placeholder="请输入备注"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="danger"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:offsetting:add']"
        >新增冲抵货款信息
        </el-button>
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

    <el-table v-loading="loading" :data="OffsettingList" @selection-change="handleSelectionChange" size="mini"
              v-horizontal-scroll="'always'" :cell-style="()=>{return {padding:'.5px'}}" border>
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="冲抵编号" align="center" prop="pffsetNO" v-if="columns[0].visible" show-overflow-tooltip/>
      <el-table-column label="操作时间" align="center" prop="operateDate" v-if="columns[1].visible"
                       show-overflow-tooltip/>
      <el-table-column label="冲抵类型" align="center" prop="operateType" v-if="columns[2].visible"
                       show-overflow-tooltip/>
      <el-table-column label="金额" align="center" prop="moneyAmount" v-if="columns[3].visible" show-overflow-tooltip/>
      <el-table-column label="公司" align="center" prop="companyName" v-if="columns[4].visible" show-overflow-tooltip/>
      <el-table-column label="公司类型" align="center" prop="companyType" v-if="columns[5].visible"
                       show-overflow-tooltip>
        <template #default="scope">
          <el-tag v-if="scope.row.companyType==='1'">客户</el-tag>
          <el-tag v-else>供应商</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[6].visible" show-overflow-tooltip/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:offsetting:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:offsetting:remove']"
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

    <!-- 添加或修改对冲账信息对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        todo 暂时传递一个随机的uuid -->
        <!--        <el-form-item label="冲抵编号" prop="OffsetNO">-->
        <!--          <el-input v-model="form.OffsetNO" placeholder="请输入冲抵编号"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="操作时间" prop="operateDate">
          <el-date-picker
            v-model="form.operateDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd"
            style="width: 70%">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="冲抵类型" prop="operateType">
          <el-radio v-model="form.operateType" label="收入">收入</el-radio>
          <el-radio v-model="form.operateType" label="支出">支出</el-radio>
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="公司类型" prop="companyType">
          <el-radio v-model="form.companyType" label="1">客户</el-radio>
          <el-radio v-model="form.companyType" label="2">供应商</el-radio>
        </el-form-item>
        <el-form-item label="公司" prop="companyName">
          <el-row>
            <el-col :span="20">
              <el-input v-model="form.companyName" placeholder="请输入公司"/>
            </el-col>
            <el-col :span="4">
              <SearchOption :limit-info="form.companyType === '1'?{companyType:'客户'}:{companyType:'供应商'}"
                            :get-data="listCompany"
                            query-info="companyName"
                            query-label="公司名称" :query-name="companyName"
                            @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                <template #table-columns>
                  <el-table-column :label="form.companyType === '1'?'客户':'供应商'" align="center"
                                   prop="relationName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="区域" align="center" prop="region"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="销售经理" align="center" prop="salesManager"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <!--        <el-form-item label="公司ID" prop="companyId">-->
        <!--          <el-input v-model="form.companyId" placeholder="请输入公司ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
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
import {listOffsetting, getOffsetting, delOffsetting, addOffsetting, updateOffsetting} from "@/api/system/Offsetting";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";
import {excludeParams} from "@/api/tool/exclude";
import {getUuid} from "@/utils/trash/utils";
import {addDateRange} from "@/utils/ruoyi";

export default {
  name: "Offsetting",
  components: {SearchOption},
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
      // 对冲账信息表格数据
      OffsettingList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      dateRange: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        OffsetNO: null,
        operateDate: null,
        operateType: null,
        moneyAmount: null,
        companyName: null,
        companyId: null,
        companyType: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        OffsetNO: [
          {required: true, message: "对冲账编号不能为空", trigger: "blur"}],
        operateDate: [
          {required: true, message: "对冲账日期不能为空", trigger: "blur"}],
        operateType: [
          {required: true, message: "对冲账类型不能为空", trigger: "blur"}],
        moneyAmount: [
          {required: true, message: "对冲账金额不能为空", trigger: "blur"}],
        companyName: [
          {required: true, message: "公司名称不能为空", trigger: "blur"}],
        companyType: [
          {required: true, message: "公司类型不能为空", trigger: "change"}],
      },
      columns: [
        {key: 0, label: `冲抵编号`, visible: true},
        {key: 1, label: `操作时间`, visible: true},
        {key: 2, label: `冲抵类型`, visible: true},
        {key: 3, label: `金额`, visible: true},
        {key: 4, label: `公司`, visible: true},
        {key: 5, label: `公司类型`, visible: true},
        {key: 6, label: `备注`, visible: true}
      ],
      companyName: ''
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('offseting-columns') === 'null'
      || !localStorage.getItem('offseting-columns')) {
      localStorage.setItem("offseting-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('offseting-columns'));
    }
  },
  methods: {
    listCompany,
    handleCommitBackCompany(val) {
      this.form.companyName = val.companyName;
      this.form.companyId = val.id;
    },
    handleUpdateCompanyName(val) {
      this.companyName = val;
    },
    printJSON() {
      const exclude = ['userId', 'createBy', 'createTime', 'updateBy', 'updateTime', 'addtime', 'delFlag', 'userName', 'remark',]
      this.$print({
        maxWidth: 3000,
        printable: this.OffsettingList,
        properties: Object.keys(this.OffsettingList[0]).filter(item => !exclude.includes(item)),
        type: 'json'
      })
    },
    /** 查询对冲账信息列表 */
    getList() {
      this.loading = true;
      listOffsetting(addDateRange(this.queryParams, this.dateRange, 'operate')).then(response => {
        this.OffsettingList = response.rows;
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
        OffsetNO: null,
        operateDate: null,
        operateType: null,
        moneyAmount: null,
        companyName: null,
        companyId: null,
        companyType: null,
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
      this.title = "添加对冲账信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getOffsetting(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改对冲账信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form = excludeParams(this.form, this.$exclude)
            updateOffsetting(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form = excludeParams(this.form, this.$exclude)
            // todo 冲抵编号随机给
            this.form.OffsetNO = getUuid()
            addOffsetting(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除对冲账信息编号为"' + ids + '"的数据项？').then(function () {
        return delOffsetting(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/Offsetting/export', {
        ...this.queryParams
      }, `Offsetting_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
