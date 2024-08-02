<template>
  <div class="app-container">
    <el-form :model="timesQuery" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-input
          v-model="timesQuery.beginTime"
          placeholder="请输入开始时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-input
          v-model="timesQuery.endTime"
          placeholder="请输入结束时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对象类型" prop="objectType">
        <el-select v-model="timesQuery.objectType" placeholder="请选择对象类型">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
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
              v-hasPermi="['system:company:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="fixedAssetsList"
              @selection-change="handleSelectionChange" id="printBox">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="购入日期" align="center" prop="buyDate"/>
      <el-table-column label="资产编号" align="center" prop="assetNo"/>
      <el-table-column label="资产名称" align="center" prop="assetName"/>
      <el-table-column label="规格型号" align="center" prop=" specification"/>
      <el-table-column label="数量" align="center" prop="number"/>
      <el-table-column label="计量单位" align="center" prop="measurementUnit "/>
      <el-table-column label="含税金额" align="center" prop="amountIncludeTax"/>
      <el-table-column label="不含税金额" align="center" prop="amountNoTax"/>
      <el-table-column label="户名名称" align="center" prop="account"/>
      <el-table-column label="使用部门" align="center" prop="department"/>
      <el-table-column label="固定资产清理时间" align="center" prop="scrapDate"/>
      <el-table-column label="清理/变卖价值" align="center" prop="saleAmount"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <!--      <el-table-column label="添加时间" align="center" prop="addtime"/>-->
      <!--      <el-table-column label="操作人员ID" align="center" prop="userId"/>-->
      <!--      <el-table-column label="操作人员姓名" align="center" prop="UserName"/>-->
      <!--      <el-table-column label="删除标记" align="center" prop="delFlag"/>-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:fixedAssets:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:fixedAssets:remove']"
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

    <!-- 添加或修改固定资产对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="购入日期" prop="buyDate">
          <el-input v-model="form.buyDate" placeholder="请输入购入日期"/>
        </el-form-item>
        <el-form-item label="资产编号" prop="assetNo">
          <el-input v-model="form.assetNo" placeholder="请输入资产编号"/>
        </el-form-item>
        <el-form-item label="资产名称" prop="assetName">
          <el-input v-model="form.assetName" placeholder="请输入资产名称"/>
        </el-form-item>
        <el-form-item label="规格型号" prop=" specification">
          <el-input v-model="form. specification" placeholder="请输入规格型号"/>
        </el-form-item>
        <el-form-item label="数量" prop="number">
          <el-input v-model="form.number" placeholder="请输入数量"/>
        </el-form-item>
        <el-form-item label="计量单位" prop="measurementUnit ">
          <el-input v-model="form.measurementUnit " placeholder="请输入计量单位"/>
        </el-form-item>
        <el-form-item label="含税金额" prop="amountIncludeTax">
          <el-input v-model="form.amountIncludeTax" placeholder="请输入含税金额"/>
        </el-form-item>
        <el-form-item label="不含税金额" prop="amountNoTax">
          <el-input v-model="form.amountNoTax" placeholder="请输入不含税金额"/>
        </el-form-item>
        <el-form-item label="户名名称" prop="account">
          <el-input v-model="form.account" placeholder="请输入户名名称"/>
        </el-form-item>
        <el-form-item label="使用部门" prop="department">
          <el-input v-model="form.department" placeholder="请输入使用部门"/>
        </el-form-item>
        <el-form-item label="固定资产清理时间" prop="scrapDate">
          <el-input v-model="form.scrapDate" placeholder="请输入固定资产清理时间"/>
        </el-form-item>
        <el-form-item label="清理/变卖价值" prop="saleAmount">
          <el-input v-model="form.saleAmount" placeholder="请输入清理/变卖价值"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
        <!--        <el-form-item label="添加时间" prop="addtime">-->
        <!--          <el-input v-model="form.addtime" placeholder="请输入添加时间"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="操作人员ID" prop="userId">-->
        <!--          <el-input v-model="form.userId" placeholder="请输入操作人员ID"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="操作人员姓名" prop="UserName">-->
        <!--          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="删除标记" prop="delFlag">-->
        <!--          <el-input v-model="form.delFlag" placeholder="请输入删除标记"/>-->
        <!--        </el-form-item>-->
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
  listFixedAssets,
  getFixedAssets,
  delFixedAssets,
  addFixedAssets,
  updateFixedAssets
} from "@/api/system/fixedAssets";

export default {
  name: "FixedAssets",
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
      // 固定资产表格数据
      fixedAssetsList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        buyDate: null,
        assetNo: null,
        assetName: null,
        specification: null,
        number: null,
        measurementUnit: null,
        amountIncludeTax: null,
        amountNoTax: null,
        account: null,
        department: null,
        scrapDate: null,
        saleAmount: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `客户`, visible: true},
        {key: 1, label: `老板姓名`, visible: true},
        {key: 2, label: `公司名称`, visible: true},
        {key: 3, label: `老板电话`, visible: true},
        {key: 4, label: `电话`, visible: true},
        {key: 5, label: `地址`, visible: true},
        {key: 6, label: `区域`, visible: true},
        {key: 7, label: `销售经理`, visible: true},
        {key: 8, label: `备注`, visible: true},
      ],
      //开始时间
      timesQuery: {
        beginTime: '',
        endTime: '',
        objectType: ''
      },
      options: [
        {
          label: 'test',
          value: 'test'
        }
      ]
    };
  },
  created() {
    //获取信息
    // this.getList();
    this.loading = false
  },
  methods: {
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询固定资产列表 */
    getList() {
      this.loading = true;
      listFixedAssets(this.queryParams).then(response => {
        this.fixedAssetsList = response.rows;
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
        buyDate: null,
        assetNo: null,
        assetName: null,
        specification: null,
        number: null,
        measurementUnit: null,
        amountIncludeTax: null,
        amountNoTax: null,
        account: null,
        department: null,
        scrapDate: null,
        saleAmount: null,
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
      this.title = "添加固定资产";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getFixedAssets(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改固定资产";
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
            updateFixedAssets(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            addFixedAssets(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除固定资产编号为"' + ids + '"的数据项？').then(function () {
        return delFixedAssets(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/fixedAssets/export', {
        ...this.queryParams
      }, `fixedAssets_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
