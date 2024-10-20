<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="150px">
      <el-form-item label="开票日期" prop="invoiceDate">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="票据单位名称" prop="invoiceCompanyName">
        <el-input
          v-model="queryParams.invoiceCompanyName"
          placeholder="请输入票据单位名称"
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
      <el-col :span="1.5">
        <el-button
          type="danger"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:invoiceother:add']"
        >新增
        </el-button>
      </el-col>
      <!--      <el-col :span="1.5">
              <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
            </el-col>-->
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
              v-hasPermi="['system:invoiceother:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="invoiceOtherList"
              @selection-change="handleSelectionChange" size="mini" :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="开票日期" align="center" prop="invoiceDate" v-if="columns[0].visible"
                       show-overflow-tooltip/>
      <el-table-column label="开票金额" align="center" prop="invoiceAmount" v-if="columns[1].visible"
                       show-overflow-tooltip/>
      <el-table-column label="供应商票点" align="center" prop="supplierTicketPoint" v-if="columns[2].visible"
                       show-overflow-tooltip/>
      <el-table-column label="供应商票点金额" align="center" prop="supplierPointAmount" v-if="columns[3].visible"
                       show-overflow-tooltip/>
      <el-table-column label="供应商公司名称" align="center" prop="Supplier" v-if="columns[4].visible"
                       show-overflow-tooltip/>
      <!--      <el-table-column label="客户公司名称" align="center" prop="customer" v-if="columns[5].visible"-->
      <!--                       show-overflow-tooltip/>-->
      <!--      <el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName" v-if="columns[6].visible"-->
      <!--                       show-overflow-tooltip/>-->
      <!--      <el-table-column label="客户票点" align="center" prop="customerTicketPoint" v-if="columns[7].visible"-->
      <!--                       show-overflow-tooltip/>-->
      <!--      <el-table-column label="票点金额" align="center" prop="customerPointAmount" v-if="columns[8].visible"-->
      <!--                       show-overflow-tooltip/>-->
      <el-table-column label="订单信息" align="center" prop="isOrderTax" width="180" v-if="columns[5].visible"
                       show-overflow-tooltip>
        <template slot-scope="scope">
          <el-row v-if="scope.row.isOrderTax===0">
            <el-tag>否</el-tag>
          </el-row>
          <el-row v-else>
            <el-button size="mini" type="warning" @click="checkOrderInfo(scope.row)">查看订单信息</el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[6].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:invoiceother:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:invoiceother:remove']"
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

    <!-- 添加或修改商家直接给客户开发票对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" append-to-body
               width="800px">
      <el-row>
        <el-form ref="form" :model="form" :rules="rules" label-width="120px">
          <!--        订单编号应该是选择某个订单 然后自动填充-->
          <el-form-item label="订单ID" prop="ordersNo">
            <el-col :span="20">
              <el-input v-model="form.ordersNo" placeholder="请选择关联订单"/>
            </el-col>
            <el-col :span="4">
              <SearchOption :limit-info="{}"
                            :get-data="listGoodsOrder" query-info="customer"
                            query-label="客户名称" :query-name="queryGoodsOrder"
                            @update:queryName="handleUpdateGoodsOrder" @commitBack="handleCommitBackGoodsOrder">
                <template #table-columns>
                  <el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left"/>
                  <el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left"/>
                  <el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left"/>
                  <el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames"
                                   fixed="left"/>
                  <el-table-column label="订单编号" align="center" prop="ordersNo" width="200px"/>
                  <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo"
                  />
                  <el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel"
                                   width="100px"/>
                  <el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName"
                                   width="100px"/>
                  <el-table-column show-overflow-tooltip label="海运车牌" align="center" prop="seaCarNo"
                  >
                    <template #default="scope">
                      {{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
                    </template>
                  </el-table-column>
                  <el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel"
                                   width="100px">
                    <template #default="scope">
                      {{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
                    </template>
                  </el-table-column>
                  <el-table-column show-overflow-tooltip label="海运司机姓名" align="center" prop="seaDriverName"
                                   width="100px">
                    <template #default="scope">
                      {{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
                    </template>
                  </el-table-column>
                  <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager"
                  />
                  <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet"
                  />
                  <el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState"

                                   width="120">
                  </el-table-column>
                  <el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState"
                                   width="120px">
                  </el-table-column>
                  <el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState"
                  >
                    <template slot-scope="scope">
                      <el-tag
                        disable-transitions>{{ scope.row.paymentState }}
                      </el-tag>
                    </template>
                  </el-table-column>
                  <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments"
                  />
                </template>
              </SearchOption>
            </el-col>
          </el-form-item>
          <el-col :span="12">
            <el-form-item label="开票金额" prop="invoiceAmount">
              <el-input v-model="form.invoiceAmount" placeholder="请输入开票金额"/>
            </el-form-item>
            <el-form-item label="供应商票点" prop="supplierTicketPoint">
              <el-input v-model="form.supplierTicketPoint" placeholder="请输入供应商票点"/>
            </el-form-item>
            <el-form-item label="供应商票点金额" prop="supplierPointAmount">
              <el-input v-model="form.supplierPointAmount" placeholder="请输入供应商票点金额"/>
            </el-form-item>
            <el-form-item label="开票日期" prop="invoiceDate">
              <el-date-picker
                v-model="form.invoiceDate"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">

            <el-form-item label="供应商公司名称" prop="Supplier">
              <el-col :span="20">
                <el-input v-model="form.Supplier" placeholder="请输入供应商公司名称"/>
              </el-col>
              <el-col :span="4">
                <SearchOption :limit-info="{companyType:'供应商'}"
                              :get-data="listCompany" query-info="companyName"
                              query-label="公司名称" :query-name="queryCompanyName"
                              @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                  <template #table-columns>
                    <el-table-column label="供应商" align="center"
                                     prop="relationName"/>
                    <el-table-column label="老板姓名" align="center" prop="leader"/>
                    <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                    <el-table-column label="区域" align="center" prop="region"/>
                    <el-table-column label="公司名称" align="center" prop="companyName"/>
                    <el-table-column label="销售经理" align="center" prop="salesManager"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-form-item>
            <el-form-item label="客户公司名称" prop="customer">
              <el-col :span="20">
                <el-input v-model="form.customer" placeholder="请输入客户公司名称"/>
              </el-col>
              <el-col :span="4">
                <SearchOption :limit-info="{companyType:'客户'}"
                              :get-data="listCompany" query-info="companyName"
                              query-label="公司名称" :query-name="queryCompanyCustomerName"
                              @update:queryName="handleUpdateCompanyCustomerName"
                              @commitBack="handleCommitBackCompanyCustomer">
                  <template #table-columns>
                    <el-table-column label="客户" align="center"
                                     prop="relationName"/>
                    <el-table-column label="老板姓名" align="center" prop="leader"/>
                    <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                    <el-table-column label="区域" align="center" prop="region"/>
                    <el-table-column label="公司名称" align="center" prop="companyName"/>
                    <el-table-column label="销售经理" align="center" prop="salesManager"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-form-item>
            <el-form-item label="票据单位名称" prop="invoiceCompanyName">
              <el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称"/>
            </el-form-item>

            <el-form-item label="备注" prop="comments">
              <el-input v-model="form.comments" placeholder="请输入备注"/>
            </el-form-item>
          </el-col>
        </el-form>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
    <el-dialog :close-on-click-modal="false" :show-close="true" title="查看订单信息"
               :visible.sync="checkOrderInfoVisible" width="70%" append-to-body>
      <OrderInfos :order-info="orderInfo"/>
    </el-dialog>
  </div>

</template>

<script>
import {
  listInvoiceOther,
  getInvoiceOther,
  delInvoiceOther,
  addInvoiceOther,
  updateInvoiceOther
} from "@/api/system/invoiceOther";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {addReason} from "@/api/system/user";
import {TableName} from "@/api/tool/enums";
import {getInvoiceOut} from "@/api/system/invoiceOut";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";
import {listGoodsOrder} from "@/api/system/goodsOrder";
import {addDateRange} from "@/utils/ruoyi";
import {getGoodsOrder} from "../../../api/system/goodsOrder";
import OrderInfos from "../../../components/OrderInfos.vue";
import {fix} from "../../../api/tool/format";

export default {
  name: "InvoiceOther",
  components: {OrderInfos, SearchOption},
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
      // 商家直接给客户开发票表格数据
      invoiceOtherList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      dateRange: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        invoiceDate: null,
        invoiceAmount: null,
        supplierTicketPoint: null,
        supplierPointAmount: null,
        Supplier: null,
        SupplierID: null,
        customer: null,
        CustomerID: null,
        invoiceCompanyName: null,
        // 客户不含税
        customerTicketPoint: 0,
        customerPointAmount: 0,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      queryCompanyName: '',
      queryCompanyCustomerName: '',
      queryGoodsOrder: '',
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `开票日期`, visible: true},
        {key: 1, label: `开票金额`, visible: true},
        {key: 2, label: `供应商票点`, visible: true},
        {key: 3, label: `供应商票点金额`, visible: true},
        {key: 4, label: `供应商公司名称`, visible: true},
        // {key: 5, label: `客户公司名称`, visible: true},
        {key: 5, label: `票据单位名称`, visible: true},
        // {key: 7, label: `客户票点`, visible: true},
        // {key: 8, label: `票点金额`, visible: true},
        {key: 6, label: `备注`, visible: true},
      ],
      checkOrderInfoVisible: false,
      orderInfo: {},
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('invoiceother-have-columns') === 'null'
      || !localStorage.getItem('invoiceother-have-columns')) {
      //设置localStorage
      localStorage.setItem("invoiceother-have-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('invoiceother-have-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("invoiceother-have-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    form: {
      handler() {
        this.form.supplierPointAmount = fix(this.form.supplierTicketPoint * this.form.invoiceAmount)
        this.form.customerPointAmount = fix(this.form.customerTicketPoint * this.form.invoiceAmount)
      },
      deep: true,
      immediate: true,
    }
  },
  methods: {
    listGoodsOrder,
    listCompany,
    // 自动填充的方法
    handleUpdateCompanyName(val) {
      this.queryCompanyName = val
    },
    handleCommitBackCompany(val) {
      this.form.Supplier = val.companyName
      this.form.SupplierID = val.id;
    },
    handleCommitBackCompanyCustomer(val) {
      this.form.customer = val.companyName;
      this.form.CustomerID = val.id;
    },
    handleUpdateCompanyCustomerName(val) {
      this.queryCompanyCustomerName = val;
    },
    handleUpdateGoodsOrder(val) {
      this.queryGoodsOrder = val;
    },
    handleCommitBackGoodsOrder(val) {
      this.form.ordersNo = val.ordersNo
    },
    //表格中查看订单信息
    checkOrderInfo(row) {
      //发请求 查看订单信息
      listGoodsOrder({ordersNo: row.ordersNo}).then(res => {
        this.orderInfo = res.rows[0];
        this.checkOrderInfoVisible = true;
      });
    },
    /** 查询商家直接给客户开发票列表 */
    getList() {
      this.loading = true;
      listInvoiceOther(addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.invoiceOtherList = response.rows;
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
        ordersNo: null,
        invoiceDate: null,
        invoiceAmount: null,
        supplierTicketPoint: null,
        supplierPointAmount: null,
        Supplier: null,
        SupplierID: null,
        customer: null,
        CustomerID: null,
        invoiceCompanyName: null,
        customerTicketPoint: null,
        customerPointAmount: null,
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
      this.title = "添加商家直接给客户开发票";
    },

    /** 修改按钮操作 */
    handleUpdate(row) {
      this.$prompt('请输入编辑原因', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(({value}) => {
        addReason({reason: value, tableName: TableName.INVOICE_OTHER, tid: row.id, modifyTime: this.modifyTime})
          .then(res => {
            this.$message.success('提交成功')
            this.reset();
            const id = row.id || this.ids
            getInvoiceOther(id).then(response => {
              this.form = response.data;
              this.open = true;
              this.title = "修改商家直接给客户开发票";
            });
          })
      }).catch(() => {
        this.$message({
          type: 'warning',
          message: '请先输入编辑原因!'
        });
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateInvoiceOther(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addInvoiceOther(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除商家直接给客户开发票编号为"' + ids + '"的数据项？').then(function () {
        return delInvoiceOther(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/invoiceOther/export', {
        ...this.queryParams
      }, `invoiceOther_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
