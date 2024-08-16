<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="级别名称" prop="levelName">
        <el-input
            v-model="queryParams.levelName"
            placeholder="请输入级别名称"
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
        <el-button
            type="danger"
            plain
            size="mini"
            @click="addNewInventory"
            v-hasPermi="['system:inventory:add']"
        >新增货物
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
                v-hasPermi="['system:company:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="inventoryList"
              @selection-change="handleSelectionChange">
      <el-table-column label="id" align="center" prop="id"/>
      <!--      <el-table-column label="仓库ID" align="center" prop="storeHouseid"/>-->
      <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
      <el-table-column label="入库日期" align="center" prop="storeDate"/>
      <el-table-column label="库存量" align="center" prop="stockNumber"/>
      <el-table-column label="供应商" align="center" prop="supplier"/>
      <!--      <el-table-column label="供应商ID" align="center" prop="supplierId"/>-->
      <el-table-column label="级别编码" align="center" prop="levelID"/>
      <el-table-column label="级别名称" align="center" prop="levelName"/>
      <el-table-column label="计量单位" align="center" prop="countingUnit"/>
      <el-table-column label="厚度" align="center" prop="height"/>
      <el-table-column label="长度" align="center" prop="length"/>
      <el-table-column label="宽度" align="center" prop="width"/>
      <el-table-column label="出厂片数" align="center" prop="pieces"/>
      <el-table-column label="每包片数" align="center" prop="piecesPerPack"/>
      <el-table-column label="包数" align="center" prop="packs"/>
      <el-table-column label="出厂单价" align="center" prop="price"/>
      <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory"/>
      <el-table-column label="杂费" align="center" prop="sundryCost"/>
      <el-table-column label="出厂货款" align="center" prop="paymentFactory"/>
      <el-table-column label="卸货价" align="center" prop="paymentUnload"/>
      <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale"/>
      <el-table-column label="总货款" align="center" prop="payments"/>
      <!--      <el-table-column label="陆运车辆ID" align="center" prop="landCarID"/>-->
      <el-table-column label="陆运车牌" align="center" prop="landCarNo"/>
      <el-table-column label="陆运司机电话" align="center" prop="landDriverTel"/>
      <el-table-column label="陆地司机姓名" align="center" prop="landDriverName"/>
      <!--      <el-table-column label="海运车辆ID" align="center" prop="seaCarID"/>-->
      <!--      <el-table-column label="海运车牌" align="center" prop="seaCarNo"/>-->
      <!--      <el-table-column label="海运司机电话" align="center" prop="seaDriverTel"/>-->
      <!--      <el-table-column label="海运司机姓名" align="center" prop="seaDriverName"/>-->
      <el-table-column label="误差" align="center" prop="erro"/>
      <el-table-column label="吨位" align="center" prop="tonnage"/>
      <el-table-column label="陆运费单价" align="center" prop="landFreightPrice"/>
      <el-table-column label="陆运费" align="center" prop="landFreight"/>
      <!--      <el-table-column label="海运费" align="center" prop="seaFreight"/>-->
      <!--      <el-table-column label="运费" align="center" prop="freight"/>-->
      <el-table-column label="其他费用" align="center" prop="otherCost"/>
      <el-table-column label="利润" align="center" prop="profit"/>
      <el-table-column label="不含税利润" align="center" prop="profitNoTax"/>
      <el-table-column label="实际片数" align="center" prop="actualPieces"/>
      <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry"/>
      <el-table-column label="加费" align="center" prop="additionalFees"/>
      <el-table-column label="返利金额" align="center" prop="rebate"/>
      <el-table-column label="客户佣金" align="center" prop="customerCommission"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="170px" fixed="right">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="warning"
              @click="secondryInventoryOut(scope.row)"
              v-hasPermi="['system:inventory:edit']"
          >出库
          </el-button>
          <el-button
              size="mini"
              type="primary"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['system:inventory:edit']"
          >修改
          </el-button>
          <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row)"
              v-hasPermi="['system:inventory:remove']"
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


    <!-- 添加或修改库存对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        根据仓库名称自动查询-->
        <!--        <el-form-item label="仓库ID" prop="storeHouseid">-->
        <!--          <el-input v-model="form.storeHouseid" placeholder="请输入仓库ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="仓库名称" prop="storeHouseName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.storeHouseName" placeholder="请输入仓库名称"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listStoreHouse" @commitBack="handleCommitBackStoreHouse">
                <template #table-columns>
                  <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
                  <el-table-column label="地址" align="center" prop="address"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="入库日期" prop="storeDate">
          <el-date-picker
              v-model="form.storeDate"
              type="date"
              placeholder="入库日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="库存量" prop="stockNumber">
          <el-input v-model="form.stockNumber" placeholder="请输入库存量"/>
        </el-form-item>
        <!--        todo-->
        <el-form-item label="供应商" prop="supplier">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.supplier" placeholder="请输入供应商"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listCompany" @commitBack="handleCommitBackCompany"
                            :limit-info="{companyType:'供应商'}">
                <template #table-columns>
                  <el-table-column label="供应商名称" align="center" prop="companyName"/>
                  <el-table-column label="联系人" align="center" prop="relationName"/>
                  <el-table-column label="电话" align="center" prop="relationTel"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <!--        <el-form-item label="供应商ID" prop="supplierId">-->
        <!--          <el-input v-model="form.supplierId" placeholder="请输入供应商ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="级别编码" prop="levelID">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.levelID" placeholder="请输入级别编码"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listProductLevel" @commitBack="handleCommitBackProductLevel">
                <template #table-columns>
                  <el-table-column label="级别编码" align="center" prop="levelNo"/>
                  <el-table-column label="级别名称" align="center" prop="levelName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="级别名称" prop="levelName">
          <el-input v-model="form.levelName" placeholder="请输入级别名称"/>
        </el-form-item>
        <!--        基本信息-->
        <el-form-item label="计量单位" prop="countingUnit">
          <el-input v-model="form.countingUnit" placeholder="请输入计量单位"/>
        </el-form-item>
        <el-form-item label="厚度" prop="height">
          <el-input v-model="form.height" placeholder="请输入厚度"/>
        </el-form-item>
        <el-form-item label="长度" prop="length">
          <el-input v-model="form.length" placeholder="请输入长度"/>
        </el-form-item>
        <el-form-item label="宽度" prop="width">
          <el-input v-model="form.width" placeholder="请输入宽度"/>
        </el-form-item>
        <el-form-item label="出厂片数" prop="pieces">
          <el-input v-model="form.pieces" placeholder="请输入出厂片数"/>
        </el-form-item>
        <el-form-item label="每包片数" prop="piecesPerPack">
          <el-input v-model="form.piecesPerPack" placeholder="请输入每包片数"/>
        </el-form-item>
        <el-form-item label="包数" prop="packs">
          <el-input v-model="form.packs" placeholder="请输入包数"/>
        </el-form-item>
        <el-form-item label="出厂单价" prop="price">
          <el-input v-model="form.price" placeholder="请输入出厂单价"/>
        </el-form-item>
        <!--        单选框-->
        <el-form-item label="出厂是否含税" prop="isIncludeTaxFactory">
          <el-radio v-model="form.isIncludeTaxFactory" label="1">是</el-radio>
          <el-radio v-model="form.isIncludeTaxFactory" label="2">否</el-radio>
        </el-form-item>
        <el-form-item label="杂费" prop="sundryCost">
          <el-input v-model="form.sundryCost" placeholder="请输入杂费"/>
        </el-form-item>
        <el-form-item label="出厂货款" prop="paymentFactory">
          <el-input v-model="form.paymentFactory" placeholder="请输入出厂货款"/>
        </el-form-item>
        <el-form-item label="卸货价" prop="paymentUnload">
          <el-input v-model="form.paymentUnload" placeholder="请输入卸货价"/>
        </el-form-item>
        <el-form-item label="销售是否含税" prop="isIncludeTaxSale">
          <el-radio v-model="form.isIncludeTaxSale" label="1">是</el-radio>
          <el-radio v-model="form.isIncludeTaxSale" label="2">否</el-radio>
        </el-form-item>
        <el-form-item label="总货款" prop="payments">
          <el-input v-model="form.payments" placeholder="请输入总货款"/>
        </el-form-item>

        <!--        车牌-->
        <!--        <el-form-item label="陆运车辆ID" prop="landCarID">-->
        <!--          <el-input v-model="form.landCarID" placeholder="请输入陆运车辆ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="陆运车牌" prop="landCarNo">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.landCarNo" placeholder="请输入陆运车牌"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listCars" @commitBack="handleCommitBackCars"
                            :limit-info="{carType:'陆运'}">
                <template #table-columns>
                  <el-table-column label="车牌" align="center" prop="carNo"/>
                  <el-table-column label="司机" align="center" prop="driver"/>
                  <el-table-column label="司机电话" align="center" prop="tel"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="陆运司机电话" prop="landDriverTel">
          <el-input v-model="form.landDriverTel" placeholder="请输入陆运司机电话"/>
        </el-form-item>
        <el-form-item label="陆地司机姓名" prop="landDriverName">
          <el-input v-model="form.landDriverName" placeholder="请输入陆地司机姓名"/>
        </el-form-item>
        <!--        <el-form-item label="海运车辆ID" prop="seaCarID">-->
        <!--          <el-input v-model="form.seaCarID" placeholder="请输入海运车辆ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="海运车牌" prop="seaCarNo">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.seaCarNo" placeholder="请输入陆运车牌"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listCars" @commitBack="handleCommitBackSea"
                            :limit-info="{carType:'海运'}">
                <template #table-columns>
                  <el-table-column label="车牌" align="center" prop="carNo"/>
                  <el-table-column label="司机" align="center" prop="driver"/>
                  <el-table-column label="司机电话" align="center" prop="tel"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="海运司机电话" prop="seaDriverTel">
          <el-input v-model="form.seaDriverTel" type="textarea" placeholder="请输入内容"/>
        </el-form-item>
        <el-form-item label="海运司机姓名" prop="seaDriverName">
          <el-input v-model="form.seaDriverName" placeholder="请输入海运司机姓名"/>
        </el-form-item>
        <el-form-item label="误差" prop="erro">
          <el-input v-model="form.erro" placeholder="请输入误差"/>
        </el-form-item>
        <el-form-item label="吨位" prop="tonnage">
          <el-input v-model="form.tonnage" placeholder="请输入吨位"/>
        </el-form-item>
        <el-form-item label="陆运费单价" prop="landFreightPrice">
          <el-input v-model="form.landFreightPrice" placeholder="请输入陆运费单价"/>
        </el-form-item>
        <el-form-item label="陆运费" prop="landFreight">
          <el-input v-model="form.landFreight" placeholder="请输入陆运费"/>
        </el-form-item>
        <el-form-item label="海运费" prop="seaFreight">
          <el-input v-model="form.seaFreight" placeholder="请输入海运费"/>
        </el-form-item>
        <el-form-item label="运费" prop="freight">
          <el-input v-model="form.freight" placeholder="请输入运费"/>
        </el-form-item>
        <el-form-item label="其他费用" prop="otherCost">
          <el-input v-model="form.otherCost" placeholder="请输入其他费用"/>
        </el-form-item>
        <el-form-item label="利润" prop="profit">
          <el-input v-model="form.profit" placeholder="请输入利润"/>
        </el-form-item>
        <el-form-item label="不含税利润" prop="profitNoTax">
          <el-input v-model="form.profitNoTax" placeholder="请输入不含税利润"/>
        </el-form-item>
        <el-form-item label="实际片数" prop="actualPieces">
          <el-input v-model="form.actualPieces" placeholder="请输入实际片数"/>
        </el-form-item>
        <el-form-item label="总货款杂费" prop="paymentsWithSundry">
          <el-input v-model="form.paymentsWithSundry" placeholder="请输入总货款杂费"/>
        </el-form-item>
        <el-form-item label="加费" prop="additionalFees">
          <el-input v-model="form.additionalFees" placeholder="请输入加费"/>
        </el-form-item>
        <el-form-item label="返利金额" prop="rebate">
          <el-input v-model="form.rebate" placeholder="请输入返利金额"/>
        </el-form-item>
        <el-form-item label="客户佣金" prop="customerCommission">
          <el-input v-model="form.customerCommission" placeholder="请输入客户佣金"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!--    添加入库信息 与订单结构类似-->
    <el-dialog title="货物入库" :visible.sync="invoiceInVisible" width="80%" append-to-body>
      <InventoryForm :inventory-info="inventoryInfo" @changeInventoryInfo="handleChangeInventoryInfo"/>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitInvoiceIn">确 定</el-button>
        <el-button @click="invoiceInVisible= false">取 消</el-button>
      </div>
    </el-dialog>


    <!--    二次出库-->
    <el-dialog title="二次出库" :visible.sync="secondInvoiceInVisible" width="80%" append-to-body>
      <InventoryForm :inventory-info="secondInvoiceIn" @changeInventoryInfo="handleChangeSecondInvoiceIn"/>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitSecondInvoiceIn">确 定</el-button>
        <el-button @click="secondInvoiceInVisible= false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listInventory, getInventory, delInventory, addInventory, updateInventory} from "@/api/system/inventory";
import SearchOption from "@/components/SearchOption.vue";
import {listStoreHouse} from "@/api/system/StoreHouse";
import {listCompany} from "@/api/system/company";
import {listProductLevel} from "@/api/system/productLevel";
import {listCars} from "@/api/system/cars";
import {excludeParams} from "@/api/tool/exclude";
import InventoryForm from "@/components/InventoryForm.vue";
import {mapGetters} from "vuex";

export default {
  name: "Inventory",
  components: {InventoryForm, SearchOption},
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
      // 库存表格数据
      inventoryList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        storeHouseid: null,
        storeHouseName: null,
        storeDate: null,
        stockNumber: null,
        supplier: null,
        supplierId: null,
        levelID: null,
        levelName: null,
        countingUnit: null,
        height: null,
        length: null,
        width: null,
        pieces: null,
        piecesPerPack: null,
        packs: null,
        price: null,
        isIncludeTaxFactory: null,
        sundryCost: null,
        paymentFactory: null,
        paymentUnload: null,
        isIncludeTaxSale: null,
        payments: null,
        landCarID: null,
        landCarNo: null,
        landDriverTel: null,
        landDriverName: null,
        seaCarID: null,
        seaCarNo: null,
        seaDriverTel: null,
        seaDriverName: null,
        erro: null,
        tonnage: null,
        landFreightPrice: null,
        landFreight: null,
        seaFreight: null,
        freight: null,
        otherCost: null,
        profit: null,
        profitNoTax: null,
        actualPieces: null,
        paymentsWithSundry: null,
        additionalFees: null,
        rebate: null,
        customerCommission: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null,
        showFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        // {key: 50, label: ` 供应商ID`, visible: true},
        {key: 0, label: ` 客户ID`, visible: true},
        {key: 1, label: `级别编码`, visible: true},
        {key: 2, label: `级别名称`, visible: true},
        {key: 3, label: `计量单位`, visible: true},
        {key: 4, label: `厚度`, visible: true},
        {key: 5, label: `长度`, visible: true},
        {key: 6, label: `宽度`, visible: true},
        {key: 7, label: `出厂片数`, visible: true},
        {key: 8, label: `每包片数`, visible: true},
        {key: 9, label: `包数`, visible: true},
        {key: 10, label: `出厂单价`, visible: true},
        {key: 11, label: `出厂是否含税`, visible: true},
      ],

      //货物入库
      invoiceInVisible: false,
      //库存信息
      inventoryInfo: {
        storeDate: '',
        storeHouseName: '',
        carNo: '',
        tel: ''
      },

      //二次出库
      secondInvoiceIn: {},
      secondInvoiceInVisible: false,

    };
  },
  computed: {
    //拿到完整的货物信息
    ...mapGetters(['inventoryInfoAll'])
  },
  created() {
    this.getList();
  },
  methods: {
    listCars,
    listProductLevel,
    listCompany,
    listStoreHouse,
    //选中仓库点击确定的回调
    handleCommitBackStoreHouse(val) {
      this.form.storeHouseName = val.storeHouseName;
      this.form.storeHouseid = val.id;
    },
    //选中供应商确定
    handleCommitBackCompany(val) {
      this.form.supplier = val.companyName;
      this.form.supplierId = val.id;
    },
    //选中级别编码的回调
    handleCommitBackProductLevel(val) {
      this.form.levelID = val.id;//todo levelNo?
      this.form.levelName = val.levelName
    },
    handleCommitBackCars(val) {
      this.form.landCarNo = val.carNo;
      this.form.landDriverTel = val.tel;
      this.form.landDriverName = val.driver;
      this.form.landCarID = val.id;
    },
    handleCommitBackSea(val) {
      this.form.seaCarNo = val.carNo;
      this.form.seaDriverTel = val.tel;
      this.form.seaDriverName = val.driver;
      this.form.seaCarID = val.id;
    },

    //添加货物
    addNewInventory() {
      this.resetInventoryInfo()
      this.invoiceInVisible = true
    },
    //充值仓库信息
    resetInventoryInfo() {
      this.inventoryInfo = {
        storeDate: '',
        storeHouseName: '',
        carNo: '',
        tel: ''
      }
    },
    //获取入库
    submitInvoiceIn() {
      //调用货物入库接口
      this.$wait();
      addInventory(this.inventoryInfoAll).then(res => {
        this.$message.success('入库成功')
        this.$close();
      }).catch(err => {
        this.$close()
      })
      this.getList()
      this.invoiceInVisible = false
    },
    //子组件改变库存状态
    handleChangeInventoryInfo(val) {
      console.log('--', val)
      this.inventoryInfo = val;
    },
    //二次出库
    secondryInventoryOut(row) {
      console.log(row)
      this.secondInvoiceInVisible = true;
    },
    handleChangeSecondInvoiceIn(val) {
      console.log(val)
    },
    submitSecondInvoiceIn() {
      this.secondInvoiceInVisible = false
    },
    /** 查询库存列表 */
    getList() {
      this.loading = true;
      listInventory(this.queryParams).then(response => {
        this.inventoryList = response.rows;
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
        storeHouseid: null,
        storeHouseName: null,
        storeDate: null,
        stockNumber: null,
        supplier: null,
        supplierId: null,
        levelID: null,
        levelName: null,
        countingUnit: null,
        height: null,
        length: null,
        width: null,
        pieces: null,
        piecesPerPack: null,
        packs: null,
        price: null,
        isIncludeTaxFactory: null,
        sundryCost: null,
        paymentFactory: null,
        paymentUnload: null,
        isIncludeTaxSale: null,
        payments: null,
        landCarID: null,
        landCarNo: null,
        landDriverTel: null,
        landDriverName: null,
        seaCarID: null,
        seaCarNo: null,
        seaDriverTel: null,
        seaDriverName: null,
        erro: null,
        tonnage: null,
        landFreightPrice: null,
        landFreight: null,
        seaFreight: null,
        freight: null,
        otherCost: null,
        profit: null,
        profitNoTax: null,
        actualPieces: null,
        paymentsWithSundry: null,
        additionalFees: null,
        rebate: null,
        customerCommission: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null,
        showFlag: null
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
    //打印
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
      this.title = "添加库存";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getInventory(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改库存";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form = excludeParams(this.form, this.$exclude)
            this.form.isIncludeTaxFactory = this.form.isIncludeTaxFactory === '是' ? '1' : '0'
            this.form.isIncludeTaxSale = this.form.isIncludeTaxSale === '是' ? '1' : '0'
            updateInventory(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form = excludeParams(this.form, this.$exclude)
            this.form.isIncludeTaxFactory = this.form.isIncludeTaxFactory === '是' ? '1' : '0'
            this.form.isIncludeTaxSale = this.form.isIncludeTaxSale === '是' ? '1' : '0'
            addInventory(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除库存编号为"' + ids + '"的数据项？').then(function () {
        return delInventory(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/inventory/export', {
        ...this.queryParams
      }, `inventory_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
