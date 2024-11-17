<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="出库日期">
        <el-date-picker
          v-model="daterangeOutDate"
          style="width: 240px"
          value-format="yyyy-MM-dd HH:mm:ss"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="经办人" prop="handler">
        <el-input
          v-model="queryParams.handler"
          placeholder="请输入经办人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="客户" prop="companyName">
        <el-input
          v-model="queryParams.companyName"
          placeholder="请输入客户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="礼品来源" prop="giftSource">
        <el-tooltip class="item" effect="dark" content="礼品来源可在字典中进行修改" placement="top">
          <el-select v-model="queryParams.giftSource" placeholder="请选择礼品来源" clearable>
            <el-option
              v-for="dict in dict.type.order_gift_source"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            />
          </el-select>
        </el-tooltip>
      </el-form-item>
      <el-form-item label="出库方式" prop="outMethod">
        <el-tooltip class="item" effect="dark" content="出库方式可在字典中进行修改" placement="top">
          <el-select v-model="queryParams.outMethod" placeholder="请选择出库方式" clearable>
            <el-option
              v-for="dict in dict.type.order_gift_out_method"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            />
          </el-select>
        </el-tooltip>
      </el-form-item>
      <el-form-item label="对方收礼人员" prop="recipientReceiver">
        <el-input
          v-model="queryParams.recipientReceiver"
          placeholder="请输入对方收礼人员"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="物品名称" prop="itemName">
        <el-input
          v-model="queryParams.itemName"
          placeholder="请输入物品名称"
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
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:giftOut:add']"
        >新增
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:giftOut:remove']"
        >删除
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:giftOut:export']"
        >导出
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
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:adjustOrders:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="giftOutList" @selection-change="handleSelectionChange"
              border v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'1px'}}">
      <el-table-column type="selection" width="55" align="center"/>

      <el-table-column label="ID" align="center" prop="id" v-if="columns[0].visible"/>

      <el-table-column label="出库日期" align="center" prop="outDate" width="180" v-if="columns[1].visible">
        <template #default="scope">
          <span>{{ parseTime(scope.row.outDate, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>

      <el-table-column label="礼品来源" align="center" prop="giftSource" v-if="columns[2].visible">
        <template #default="scope">
          <dict-tag :options="dict.type.order_gift_source" :value="scope.row.giftSource"/>
        </template>
      </el-table-column>

      <el-table-column label="出库方式" align="center" prop="outMethod" v-if="columns[3].visible">
        <template #default="scope">
          <dict-tag :options="dict.type.order_gift_out_method" :value="scope.row.outMethod"/>
        </template>
      </el-table-column>

      <el-table-column label="公司名称" align="center" prop="companyName" v-if="columns[4].visible"/>

      <el-table-column label="对方收礼人员" align="center" prop="recipientReceiver" v-if="columns[5].visible"/>

      <el-table-column label="物品名称" align="center" prop="itemName" v-if="columns[6].visible"/>

      <el-table-column label="数量" align="center" prop="quantity" v-if="columns[7].visible"/>

      <el-table-column label="预估价值/购买金额" align="center" prop="estimatedValue" v-if="columns[8].visible"/>

      <el-table-column label="经办人" align="center" prop="handler" v-if="columns[9].visible"/>

      <el-table-column label="备注" align="center" prop="remark" v-if="columns[10].visible"/>

      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" v-if="columns[11].visible">
        <template #default="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:giftOut:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:giftOut:remove']"
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

    <!-- 添加或修改礼品出库信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="出库日期" prop="outDate">
          <el-date-picker clearable
                          v-model="form.outDate"
                          type="datetime"
                          value-format="yyyy-MM-dd HH:mm:ss"
                          placeholder="请选择出库日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="礼品来源" prop="giftSource">
          <el-select v-model="form.giftSource" placeholder="请选择礼品来源">
            <el-option
              v-for="dict in dict.type.order_gift_source"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="出库方式" prop="outMethod">
          <el-select v-model="form.outMethod" placeholder="请选择出库方式">
            <el-option
              v-for="dict in dict.type.order_gift_out_method"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="对方类型">
          <el-select v-model="companyType" placeholder="请选择">
            <el-option
              v-for="item in OTHER_TYPE()"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="对方信息" prop="recipientInfo">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.companyName" placeholder="请输入对方信息"/>
            </el-col>
            <el-col :span="2">
              <SearchOption :limit-info="{companyType:companyType}" :get-data="listCompany" query-info="companyName"
                            query-label="公司名称" :query-name="companyName"
                            @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                <template #table-columns>
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
        <el-form-item label="对方收礼人员" prop="recipientReceiver">
          <el-input v-model="form.recipientReceiver" placeholder="请输入送礼-对方收礼人员"/>
        </el-form-item>
        <el-form-item label="物品名称" prop="itemName">
          <el-input v-model="form.itemName" placeholder="请输入物品名称"/>
        </el-form-item>
        <el-form-item label="数量" prop="quantity">
          <el-input v-model="form.quantity" placeholder="请输入数量"/>
        </el-form-item>
        <el-form-item label="预估价值/购买金额" prop="estimatedValue">
          <el-input v-model="form.estimatedValue" placeholder="请输入预估价值/购买金额"/>
        </el-form-item>
        <el-form-item label="经办人" prop="handler">
          <el-input v-model="form.handler" placeholder="请输入经办人"/>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容"/>
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
import {listGiftOut, getGiftOut, delGiftOut, addGiftOut, updateGiftOut} from "@/api/system/giftOut";
import {parseTime} from "../../../utils/ruoyi";
import {mixin_printHTML} from "../../dashboard/mixins/print";
import SearchOption from "../../../components/SearchOption.vue";
import {listCompany} from "../../../api/system/company";
import {mixin_gift_out_fill} from "./giftOut_fill";
import {OTHER_TYPE} from "../../../utils/order";

export default {
  name: "GiftOut",
  components: {SearchOption},
  dicts: ['orderorder_gift_out_method', 'order_gift_source'],
  mixins: [mixin_printHTML, mixin_gift_out_fill],
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
      // 礼品出库信息表格数据
      giftOutList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 备注时间范围
      daterangeOutDate: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        outDate: null,
        giftSource: null,
        outMethod: null,
        recipientInfo: null,
        recipientType: null,
        recipientReceiver: null,
        itemName: null,
        quantity: null,
        estimatedValue: null,
        handler: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `ID`, visible: true},
        {key: 1, label: `出库日期`, visible: true},
        {key: 2, label: `礼品来源`, visible: true},
        {key: 3, label: `出库方式`, visible: true},
        {key: 4, label: `公司名称`, visible: true},
        {key: 5, label: `对方收礼人员`, visible: true},
        {key: 6, label: `物品名称`, visible: true},
        {key: 7, label: `数量`, visible: true},
        {key: 8, label: `预估价值/购买金额`, visible: true},
        {key: 9, label: `经办人`, visible: true},
        {key: 10, label: `备注`, visible: true},
        {key: 11, label: `操作`, visible: true}
      ],
      companyType: '',
    };
  },
  created() {
    this.getList();
  },
  methods: {
    OTHER_TYPE() {
      return OTHER_TYPE
    },
    listCompany,
    parseTime,
    /** 查询礼品出库信息列表 */
    getList() {
      this.loading = true;
      this.queryParams.params = {};
      if (null != this.daterangeOutDate && '' != this.daterangeOutDate) {
        this.queryParams.params["beginOutDate"] = this.daterangeOutDate[0];
        this.queryParams.params["endOutDate"] = this.daterangeOutDate[1];
      }
      listGiftOut(this.queryParams).then(response => {
        this.giftOutList = response.rows;
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
        outDate: null,
        giftSource: null,
        outMethod: null,
        recipientInfo: null,
        recipientType: null,
        companyName: null,
        recipientReceiver: null,
        itemName: null,
        quantity: null,
        estimatedValue: null,
        handler: null,
        updateTime: null,
        updateBy: null,
        createTime: null,
        createBy: null,
        remark: null
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
      this.daterangeOutDate = [];
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
      this.title = "添加礼品出库信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getGiftOut(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改礼品出库信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateGiftOut(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addGiftOut(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除礼品出库信息编号为"' + ids + '"的数据项？').then(function () {
        return delGiftOut(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/giftOut/export', {
        ...this.queryParams
      }, `giftOut_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
