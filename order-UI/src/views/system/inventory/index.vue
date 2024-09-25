<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
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
      <!-- 刷新按钮-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="danger"
            size="mini"
            @click="addNewInventory"
            v-hasPermi="['system:inventory:add']"
        >新增货物
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
                v-hasPermi="['system:inventory:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="inventoryList"
              @selection-change="handleSelectionChange" :cell-style="()=>{return {padding:'2px'}}" size="mini">
      <el-table-column label="仓库名称" align="center" prop="storeHouseName" v-if="columns[0].visible" width="150"/>
      <el-table-column label="入库日期" align="center" prop="storeDate" v-if="columns[1].visible" width="150"/>
      <el-table-column label="库存量" align="center" prop="stockNumber" v-if="columns[2].visible" width="150"/>
      <el-table-column label="供应商" align="center" prop="supplier" v-if="columns[3].visible" width="150"/>
      <el-table-column label="级别编码" align="center" prop="levelID" v-if="columns[4].visible" width="150"/>
      <el-table-column label="级别名称" align="center" prop="levelName" v-if="columns[5].visible" width="150"/>
      <el-table-column label="计量单位" align="center" prop="countingUnit" v-if="columns[6].visible" width="150"/>
      <el-table-column label="厚度" align="center" prop="height" v-if="columns[7].visible" width="150"/>
      <el-table-column label="长度" align="center" prop="length" v-if="columns[8].visible" width="150"/>
      <el-table-column label="宽度" align="center" prop="width" v-if="columns[9].visible" width="150"/>
      <el-table-column label="出厂片数" align="center" prop="pieces" v-if="columns[10].visible" width="150"/>
      <el-table-column label="每包片数" align="center" prop="piecesPerPack" v-if="columns[11].visible" width="150"/>
      <el-table-column label="包数" align="center" prop="packs" v-if="columns[12].visible" width="150"/>
      <el-table-column label="出厂单价" align="center" prop="price" v-if="columns[13].visible" width="150"/>
      <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" v-if="columns[14].visible" width="150"/>
      <el-table-column label="杂费" align="center" prop="sundryCost" v-if="columns[15].visible" width="150"/>
      <el-table-column label="出厂货款" align="center" prop="paymentFactory" v-if="columns[16].visible" width="150"/>
      <el-table-column label="卸货价" align="center" prop="paymentUnload" v-if="columns[17].visible" width="150"/>
      <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" v-if="columns[18].visible" width="150"/>
      <el-table-column label="总货款" align="center" prop="payments" v-if="columns[19].visible" width="150"/>
      <el-table-column label="陆运车牌" align="center" prop="landCarNo" v-if="columns[20].visible" width="150"/>
      <el-table-column label="陆运司机电话" align="center" prop="landDriverTel" v-if="columns[21].visible" width="150"/>
      <el-table-column label="陆地司机姓名" align="center" prop="landDriverName" v-if="columns[22].visible" width="150"/>
      <el-table-column label="误差" align="center" prop="erro" v-if="columns[23].visible" width="150"/>
      <el-table-column label="吨位" align="center" prop="tonnage" v-if="columns[24].visible" width="150"/>
      <el-table-column label="陆运费单价" align="center" prop="landFreightPrice" v-if="columns[25].visible" width="150"/>
      <el-table-column label="陆运费" align="center" prop="landFreight" v-if="columns[26].visible" width="150"/>
      <el-table-column label="其他费用" align="center" prop="otherCost" v-if="columns[27].visible" width="150"/>
      <el-table-column label="利润" align="center" prop="profit" v-if="columns[28].visible" width="150"/>
      <el-table-column label="不含税利润" align="center" prop="profitNoTax" v-if="columns[29].visible" width="150"/>
      <el-table-column label="实际片数" align="center" prop="actualPieces" v-if="columns[30].visible" width="150"/>
      <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" v-if="columns[31].visible" width="150"/>
      <el-table-column label="加费" align="center" prop="additionalFees" v-if="columns[32].visible" width="150"/>
      <el-table-column label="返利金额" align="center" prop="rebate" v-if="columns[33].visible" width="150"/>
      <el-table-column label="客户佣金" align="center" prop="customerCommission" v-if="columns[34].visible" width="150"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[35].visible" width="150"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="250px" fixed="right">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="warning"
              @click="secondryInventoryOut(scope.row)"
          >加工后出库
          </el-button>
          <el-button
              size="mini"
              type="warning"
              @click="afterbreakInventoryOut(scope.row)"
          >破损后出库
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
        <el-form-item label="仓库名称" prop="storeHouseName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.storeHouseName" placeholder="请输入仓库名称"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listStoreHouse" @commitBack="handleCommitBackStoreHouse" :limit-info="{}">
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
              placeholder="入库日期"
              value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="库存量" prop="stockNumber">
          <el-input v-model="form.stockNumber" placeholder="请输入库存量"/>
        </el-form-item>
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
        <el-form-item label="级别编码" prop="levelID">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.levelID" placeholder="请输入级别编码"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :limit-info="{}" :get-data="listProductLevel" @commitBack="handleCommitBackProductLevel">
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
    <el-dialog title="二次出库" :visible.sync="secondInvoiceInVisible" width="50%" append-to-body>
      <div slot="footer" class="dialog-footer">
        <el-row :gutter="5">
          <el-col :span="4">
            <span style="font-weight: bolder;line-height: 30px">请输入出库数量</span>
          </el-col>
          <el-col :span="10">
            <el-input v-model="secondNumber" placeholder="请输入出库数量"/>
          </el-col>
        </el-row>
        <el-button type="primary" @click="submitSecondInvoiceIn">确 定</el-button>
        <el-button @click="secondInvoiceInVisible= false">取 消</el-button>
      </div>
    </el-dialog>

    <!--    货物破损出库-->
    <el-dialog title="货物破损出库" :visible.sync="breakInvoiceInVisible" width="50%" append-to-body>
      <div slot="footer" class="dialog-footer">
        <el-row :gutter="5">
          <el-col :span="4">
            <span style="font-weight: bolder;line-height: 30px">请输入出库数量</span>
          </el-col>
          <el-col :span="10">
            <el-input v-model="breakNumber" placeholder="请输入出库数量"/>
          </el-col>
        </el-row>
        <el-button type="primary" @click="submitBreakInvoiceIn">确 定</el-button>
        <el-button @click="breakInvoiceInVisible= false">取 消</el-button>
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
import {addExWarehouse} from "@/api/system/exWarehouse";
import {addReason} from "@/api/system/user";
import {TableName} from "@/api/tool/enums";
import {getInvoiceOther} from "@/api/system/invoiceOther";
import {formatDate} from "@/utils";

export default {
  name: "Inventory",
  components: {InventoryForm, SearchOption},
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      inventoryList: [],
      title: "",
      open: false,
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
      form: {},
      rules: {},
      columns: [
      /*  {key: 0, label: `id`, visible: true},*/
        {key: 0, label: `仓库名称`, visible: true},
        {key: 1, label: `入库日期`, visible: true},
        {key: 2, label: `库存量`, visible: true},
        {key: 3, label: `供应商`, visible: true},
        {key: 4, label: `级别编码`, visible: true},
        {key: 5, label: `级别名称`, visible: true},
        {key: 6, label: `计量单位`, visible: true},
        {key: 7, label: `厚度`, visible: true},
        {key: 8, label: `长度`, visible: true},
        {key: 9, label: `宽度`, visible: true},
        {key: 10, label: `出厂片数`, visible: true},
        {key: 11, label: `每包片数`, visible: true},
        {key: 12, label: `包数`, visible: true},
        {key: 13, label: `出厂单价`, visible: true},
        {key: 14, label: `出厂是否含税`, visible: true},
        {key: 15, label: `杂费`, visible: true},
        {key: 16, label: `出厂贷款`, visible: true},
        {key: 17, label: `卸货价`, visible: true},
        {key: 18, label: `销售是否含税`, visible: true},
        {key: 19, label: `总货款`, visible: true},
        {key: 20, label: `陆运车牌`, visible: true},
        {key: 21, label: `陆运司机电话`, visible: true},
        {key: 22, label: `陆运司机姓名`, visible: true},
        {key: 23, label: `误差`, visible: true},
        {key: 24, label: `吨位`, visible: true},
        {key: 25, label: `陆运费单价`, visible: true},
        {key: 26, label: `陆运费`, visible: true},
        {key: 27, label: `其他费用`, visible: true},
        {key: 28, label: `利润`, visible: true},
        {key: 29, label: `不含利润率`, visible: true},
        {key: 30, label: `实际片数`, visible: true},
        {key: 31, label: `总贷款杂费`, visible: true},
        {key: 32, label: `加费`, visible: true},
        {key: 33, label: `返利金额`, visible: true},
        {key: 34, label: `客户佣金`, visible: true},
        {key: 35, label: `备注`, visible: true},
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
      secondNumber: 0,
      secondInvoiceInVisible: false,
      secondInfo: {},
      //货物破损
      breakNumber: 0,
      breakInvoiceInVisible: false,
      breakInfo: {},
    };
  },
  computed: {
    //拿到完整的货物信息
    ...mapGetters(['inventoryInfoAll'])
  },
  created() {
    this.getList();
    if (localStorage.getItem('inventory-columns') === 'null'
        || !localStorage.getItem('inventory-columns')) {
      //设置localStorage
      localStorage.setItem("inventory-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('inventory-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("inventory-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
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
      this.form.levelID = val.id;
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
      console.log('仓库信息', this.inventoryInfoAll)
      addInventory(this.inventoryInfoAll).then(res => {
        this.$message.success('入库成功')
      })
      this.getList()
      this.invoiceInVisible = false
    },
    //子组件改变库存状态
    handleChangeInventoryInfo(val) {
      console.log('11返回', val)
      this.inventoryInfo.storeHouseName = val.storeHouseName
      this.inventoryInfo = val;
    },
    //二次出库
    secondryInventoryOut(row) {
      //组装二次出库需要的信息
      this.secondInfo = {
        ordersNo: '二次加工',
        storeHouseid: row.storeHouseid,
        storeHouseName: row.storeHouseName,
        storeID: row.id,
        outDate: formatDate(new Date())
      };
      this.secondInvoiceInVisible = true
    },
    //提交二次出库信息
    submitSecondInvoiceIn() {
      this.secondInfo.outAmount = this.secondNumber
      addExWarehouse(this.secondInfo).then(res => {
        this.$message.success('加工后出库成功~')
      })
      this.secondInvoiceInVisible = false
    },
    //货物破损出库
    afterbreakInventoryOut(row) {
      this.breakInfo = {
        ordersNo: '货物破损',
        storeHouseid: row.storeHouseid,
        storeHouseName: row.storeHouseName,
        storeID: row.id,
        outDate: formatDate(new Date())
      };
      this.breakInvoiceInVisible = true
    },
    //提交货物破损出库
    submitBreakInvoiceIn() {
      this.breakInfo.outAmount = this.breakNumber
      addExWarehouse(this.breakInfo).then(res => {
        this.$message.success('货物破损出库成功~')
      })
      this.breakInvoiceInVisible = false
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
      this.$prompt('请输入编辑原因', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(({value}) => {
        addReason({reason: value, tableName: TableName.INVENTORY, tid: row.id, modifyTime: this.modifyTime})
            .then(res => {
              this.$message.success('提交成功')
              this.reset();
              const id = row.id || this.ids
              getInventory(id).then(response => {
                this.form = response.data;
                this.open = true;
                this.title = "修改库存";
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
