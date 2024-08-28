<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="仓库名称" prop="storeHouseName">
        <el-input
          v-model="queryParams.storeHouseName"
          placeholder="请输入仓库名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="出库日期" prop="outDate">
        <el-input
          v-model="queryParams.outDate"
          placeholder="请输入出库日期"
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
              v-hasPermi="['system:breakout:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="exWarehouseList"
              @selection-change="handleSelectionChange" id="printBox">
      <el-table-column label="id" align="center" prop="id" v-if="columns[0].visible"/>
      <el-table-column label="仓库名称" align="center" prop="storeHouseName" v-if="columns[1].visible"/>
      <el-table-column label="出库日期" align="center" prop="outDate" v-if="columns[2].visible"/>
      <el-table-column label="出库量" align="center" prop="outAmount" v-if="columns[3].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="danger"
            @click="checkInvoInfo(scope.row)"
          >查看库存信息
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

    <!-- 添加或修改出库对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="订单编号" prop="ordersNo">
          <el-input v-model="form.ordersNo" placeholder="请输入订单编号"/>
        </el-form-item>
        <el-form-item label="仓库名称" prop="storeHouseName">
          <el-input v-model="form.storeHouseName" placeholder="请输入仓库名称"/>
        </el-form-item>
        <el-form-item label="仓库存储的货物ID" prop="storeID">
          <el-input v-model="form.storeID" placeholder="请输入仓库存储的货物ID"/>
        </el-form-item>
        <el-form-item label="出库日期" prop="outDate">
          <el-input v-model="form.outDate" placeholder="请输入出库日期"/>
        </el-form-item>
        <el-form-item label="出库量" prop="outAmount">
          <el-input v-model="form.outAmount" placeholder="请输入出库量"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <el-dialog title="库存信息" :visible.sync="inventoryInfoVisible" width="500px" append-to-body>
      <el-descriptions title="库存详情" border>
        <el-descriptions-item label="陆地车号">
          {{ inventoryInfo.landCarNo }}
        </el-descriptions-item>
        <el-descriptions-item label="陆地司机姓名">
          {{ inventoryInfo.landDriverName }}
        </el-descriptions-item>
        <el-descriptions-item label="陆地司机电话">
          {{ inventoryInfo.landDriverTel }}
        </el-descriptions-item>
        <el-descriptions-item label="陆地运费">
          {{ inventoryInfo.landFreight }}
        </el-descriptions-item>
        <el-descriptions-item label="陆地运费单价">
          {{ inventoryInfo.landFreightPrice }}
        </el-descriptions-item>
        <el-descriptions-item label="长度">
          {{ inventoryInfo.length }}
        </el-descriptions-item>
        <el-descriptions-item label="宽度">
          {{ inventoryInfo.width }}
        </el-descriptions-item>
        <el-descriptions-item label="厚度">
          {{ inventoryInfo.height }}
        </el-descriptions-item>
        <el-descriptions-item label="吨位">
          {{ inventoryInfo.freight }}
        </el-descriptions-item>
        <el-descriptions-item label="单位">
          {{ inventoryInfo.countingUnit }}
        </el-descriptions-item>
        <el-descriptions-item label="误差">
          {{ inventoryInfo.erro }}
        </el-descriptions-item>
        <el-descriptions-item label="等级名称">
          {{ inventoryInfo.levelName }}
        </el-descriptions-item>
        <el-descriptions-item label="其他费用">
          {{ inventoryInfo.otherCost }}
        </el-descriptions-item>
        <el-descriptions-item label="包数">
          {{ inventoryInfo.packs }}
        </el-descriptions-item>
        <el-descriptions-item label="出厂货款">
          {{ inventoryInfo.paymentFactory }}
        </el-descriptions-item>
        <el-descriptions-item label="卸货付款">
          {{ inventoryInfo.paymentUnload }}
        </el-descriptions-item>
        <el-descriptions-item label="总货款">
          {{ inventoryInfo.payments }}
        </el-descriptions-item>
        <el-descriptions-item label="产品级别">
          {{ inventoryInfo.levelName }}
        </el-descriptions-item>
        <el-descriptions-item label="产品级别">
          {{ inventoryInfo.levelName }}
        </el-descriptions-item>
        <el-descriptions-item label="剩余库存量">
          {{ inventoryInfo.stockNumber }}
        </el-descriptions-item>
        <el-descriptions-item label="供应商">
          {{ inventoryInfo.supplier }}
        </el-descriptions-item>
        <el-descriptions-item label="重量">
          {{ inventoryInfo.tonnage }}
        </el-descriptions-item>
        <el-descriptions-item label="库存编号">
          {{ inventoryInfo.stockNumber }}
        </el-descriptions-item>
        <el-descriptions-item label="存储日期">
          {{ inventoryInfo.storeDate }}
        </el-descriptions-item>
        <el-descriptions-item label="仓库名称">
          {{ inventoryInfo.storeHouseName }}
        </el-descriptions-item>
        <el-descriptions-item label="杂费">
          {{ inventoryInfo.sundryCost }}
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
import {
  listExWarehouse,
  getExWarehouse,
  delExWarehouse,
  addExWarehouse,
  updateExWarehouse
} from "@/api/system/exWarehouse";
import {listGoodsOrder} from "@/api/system/goodsOrder";
import TagsItem from "@/components/TagsItem/index.vue";
import {getInventory, listInventory} from "@/api/system/inventory";

export default {
  name: "ExWarehouse",
  components: {TagsItem},
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      exWarehouseList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ordersNo: '货物破损',
        storeHouseid: null,
        storeHouseName: null,
        storeID: null,
        outDate: null,
        outAmount: null,
        delFlag: null,
        addtime: null,
        userId: null,
        UserName: null,
      },
      form: {},
      rules: {},
      columns: [
        {key: 0, label: `id`, visible: true},
        {key: 1, label: `仓库名称`, visible: true},
        {key: 2, label: `出库日期`, visible: true},
        {key: 3, label: `出库量`, visible: true},
      ],
      checkOrderVisible: false,
      orderDetailInfo: {},
      inventoryInfo: {},
      inventoryInfoVisible: false
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('breakout-columns') === 'null'
      || !localStorage.getItem('breakout-columns')) {
      //设置localStorage
      localStorage.setItem("breakout-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('breakout-columns'));
    }
  },
  //显示与隐藏
  watch:{
    columns: {
      handler: (newVal) => {
        localStorage.setItem("breakout-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    checkOrderInfo(row) {
      this.checkOrderVisible = true;
      //查询订单详情
      listGoodsOrder({ordersNo: row.ordersNo}).then(res => {
        this.orderDetailInfo = res.rows[0]
      })
    },
    //查看库存信息 查询当前行的库存信息
    checkInvoInfo(row) {
      getInventory(row.storeID).then(res => {
        this.inventoryInfo = res.data
        this.inventoryInfoVisible = true;
      })
    },
    isOrNot(val) {
      return val === 1 ? "是" : "否";
    },

    /** 查询出库列表 */
    getList() {
      this.loading = true;
      listExWarehouse(this.queryParams).then(response => {
        this.exWarehouseList = response.rows;
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
        storeHouseid: null,
        storeHouseName: null,
        storeID: null,
        outDate: null,
        outAmount: null,
        delFlag: null,
        updateTime: null,
        addtime: null,
        userId: null,
        UserName: null
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
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加出库";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getExWarehouse(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改出库";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateExWarehouse(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addExWarehouse(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除出库编号为"' + ids + '"的数据项？').then(function () {
        return delExWarehouse(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/exWarehouse/export', {
        ...this.queryParams
      }, `exWarehouse_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
