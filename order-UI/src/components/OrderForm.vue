<script>
import {listCompany} from "@/api/system/company";
import {listCars} from "@/api/system/cars";
import {listFleet} from "@/api/system/fleet";
import {listStoreHouse} from "@/api/system/StoreHouse";
import {listProductLevel} from "@/api/system/productLevel";
import {listInventory} from "@/api/system/inventory";

export default {
  name: "OrderForm",
  props: {
    //订单信息
    orderInfo: {},
  },
  data() {
    return {
      //订单信息中的items
      goodsOrderList: [{}, {}],
      //海运还是陆运
      isLand: false,
      isSea: false,
      //客户信息弹窗
      customerInfoDialogVisible: false,
      //陆运车牌信息弹窗
      landInfoDialogVisible: false,
      //车队信息弹窗
      fleetInfoDialogVisible: false,
      //海运车牌信息弹窗
      seaInfoDialogVisible: false,
      //供应商信息弹窗
      companyGiveDialogVisible: false,
      //仓库信息弹窗
      storeInfoDialogVisible: false,
      //产品级别弹窗
      productLevelDialogVisible: false,
      //客户信息
      companyInfo: [],
      //陆运车牌信息
      landInfo: [],
      //车队信息
      fleetInfo: [],
      //海运车牌信息
      seaInfo: [],
      //供应商信息
      companyGiveInfo: [],
      //仓库信息
      storeInfo: [],
      //库存信息
      inventoryInfo: [],
      //产品级别信息
      productLevelInfo: [],
      //客户信息弹窗的搜索客户名
      customerName: '',
      //车队搜索
      fleetName: '',
      //公司(供应商)名称搜索
      companyName: '',
      //仓库名称搜索
      storeName: '',
      //产品级别搜索
      productLevel: {
        //级别
        level: '',
        //宽度
        width: ''
      },

      //id:  供应商ID:supplierID  客户ID:customerID 仓库ID:storeHouseID
      // 仓库存储的货物ID:storeID 客户ID:customerID 货运车辆ID:landCarID 海运车辆ID:seaCarID
      supplierID: '',
      customerID: '',
      storeHouseID: '',
      storeID: '',
      landCarID: '',
      seaCarID: '',


    }
  },
  methods: {
    //客户供应商信息
    searchCustomerInfo() {
      this.customerInfoDialogVisible = true
      listCompany({relationName: this.customerName}).then(res => {
        console.log('客户供应商信息', res)
        this.companyInfo = res.rows;
      })
    },
    //陆运车牌信息
    searchLandInfo() {
      this.landInfoDialogVisible = true
      //搜索车队信息
      listCars().then(res => {
        this.landInfo = res.rows;
        console.log('车辆信息', res.rows)
      })
    },
    //车队信息
    searchFleetInfo() {
      this.fleetInfoDialogVisible = true
      listFleet({fName: this.fleetName}).then(res => {
        this.fleetInfo = res.rows;
        console.log('车队信息', res.rows)
      })
    },
    //todo 海运车牌信息
    searchSeaInfo() {
      this.seaInfoDialogVisible = true
      //查询海运车牌信息

    },
    //供应商信息
    searchCompanyGiveInfo() {
      this.companyGiveDialogVisible = true;
      //查询供应商信息
      listCompany({companyType: '供应商', companyName: this.companyName}).then(res => {
        this.companyGiveInfo = res.rows;
        console.log('供应商信息', res.rows)
      })
    },
    //查询仓库信息
    searchStoreInfo() {
      this.storeInfoDialogVisible = true;
      //搜索库存信息
      listInventory().then(res => {
        console.log('库存信息', res.rows)
        this.inventoryInfo = res.rows.filter(item => {
          return item.stockNumber > 0;
        })
      })
      //搜索仓库信息
      listStoreHouse().then(res => {
        this.storeInfo = res.rows;
        console.log('仓库信息', res.rows)
      })
    },
    //查询产品级别信息
    searchProductLevelInfo() {
      this.productLevelDialogVisible = true;
      //查询产品级别信息
      listProductLevel({width: this.productLevel.width, levelName: this.productLevel.level}).then(res => {
        this.productLevelInfo = res.rows;
        console.log('产品级别信息', res.rows)
      })
    },


    //todo 确认中初始化所有的id
    //客户信息中的搜索确认
    commitCustomerInfo(row) {
      this.customerID = row.id;  //orderInfo
      //填充客户和销售经理信息
      this.orderInfo.customer = row.relationName;
      this.orderInfo.saleManager = row.salesManager;
      this.customerInfoDialogVisible = false
    },
    //查询车牌信息的确认
    commitCarsInfo(row) {
      this.landCarID = row.id;   //orderInfo
      this.orderInfo.landCarNo = row.carNo;
      this.orderInfo.landDriverName = row.driver;
      this.orderInfo.landDriverTel = row.tel;
      this.landInfoDialogVisible = false;
    },
    //车队信息的确认
    commitFleetInfo(row) {
      console.log('车队信息row', row)
      this.orderInfo.fleet = row.fName;
      this.fleetInfoDialogVisible = false;
    },
    //海运信息的确认
    commitSeaInfo(row) {

    },

    //以下信息保存在goodsOrderList中
    //供应商信息确认
    commitCompanyGiveInfo(row) {
      console.log('供应商信息row', row)
      this.supplierID = row.id;   //goodsOrderList
      this.goodsOrderList[0].supplier = row.companyName
      this.companyGiveDialogVisible = false;
    },
    //仓库确认
    commitStoreInfo(row) {
      console.log('仓库信息row', row)
      this.storeID = row.id;
      this.goodsOrderList[0].storeHouseName = row.storeHouseName
      this.storeInfoDialogVisible = false;
    },
    //产品级别确认
    commitProductLevelInfo(row) {
      console.log('产品级别信息row', row)
      //填充表格数据
      this.goodsOrderList[0].levelName = row.levelName;
      this.goodsOrderList[0].height = row.height;
      this.goodsOrderList[0].length = row.length;
      this.goodsOrderList[0].width = row.width;
      this.productLevelDialogVisible = false;
    },

    //提交订单 添加订单信息
    submitOrderItems() {
      this.$emit('changeOrderInfo', this.goodsOrderList)
    },
  },
  created() {

  },
  mounted() {

  }
}
</script>

<template>
  <div>
    <!--    订单上面-->
    <div class="order-header">
      <div class="header-item">
        <span style="font-weight: bolder">日期:</span>
        <el-date-picker
          v-model="orderInfo.orderDate"
          type="date"
          placeholder="选择日期" style="width: 70%">
        </el-date-picker>
      </div>
      <div class="header-item">
        <span style="font-weight: bolder">客户:</span>
        <el-input type="text" v-model="orderInfo.customer" style="width: 50%" placeholder="请输入客户名称"></el-input>
        <!--        查询客户列表-->
        <el-button type="primary" size="mini" icon="el-icon-search" @click="searchCustomerInfo"></el-button>
      </div>
      <div class="header-item">
        <span style="font-weight: bolder">销售经理:</span>
        <el-input type="text" v-model="orderInfo.saleManager" style="width: 60%"
                  placeholder="请输入销售经理名称"></el-input>
      </div>
      <!--      多选框-->
      <div class="header-item">
        <span style="font-weight: bolder;">交通运输方式: </span>
        <el-checkbox v-model="isLand">陆运</el-checkbox>
        <el-checkbox v-model="isSea">海运</el-checkbox>
      </div>


      <!--      陆运-->
      <div style="margin:20px 0;" v-if="isLand">
        <div style="font-weight: bolder;margin-bottom: 10px">陆运信息</div>
        <div style="display: flex;">
          <div>
            <span class="text-bold">陆运车牌</span>
            <el-input type="text" v-model="orderInfo.landCarNo" style="width: 50%"
                      placeholder="请输入陆运车牌"></el-input>
            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchLandInfo"></el-button>
          </div>
          <div>
            <span class="text-bold">陆运司机姓名</span>
            <el-input type="text" v-model="orderInfo.landDriverName" style="width: 60%"
                      placeholder="请输入陆运司机姓名"></el-input>
          </div>
          <div>
            <span class="text-bold">陆运司机电话</span>
            <el-input type="text" v-model="orderInfo.landDriverTel" style="width: 60%"
                      placeholder="请输入陆运司机电话"></el-input>
          </div>
          <div>
            <span class="text-bold">车队</span>
            <el-input type="text" v-model="orderInfo.fleet" style="width: 50%" placeholder="请输入车队"></el-input>
            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchFleetInfo"></el-button>
          </div>
        </div>
      </div>

      <!--      海运-->
      <div style="margin:10px 0;" v-if="isSea">
        <div style="font-weight: bolder;margin-bottom: 10px">海运信息</div>
        <div style="display: flex;">
          <div>
            <span class="text-bold">海运车牌</span>
            <el-input type="text" v-model="orderInfo.seaCarNo" style="width: 50%" placeholder="请输入车牌"></el-input>
            <!--            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchSeaInfo"></el-button>-->
          </div>
          <div>
            <span class="text-bold">海运司机姓名</span>
            <el-input type="text" v-model="orderInfo.seaDriverName" style="width: 60%"
                      placeholder="请输入司机姓名"></el-input>
          </div>
          <div>
            <span class="text-bold">海运司机电话</span>
            <el-input type="text" v-model="orderInfo.seaDriverTel" style="width: 60%"
                      placeholder="请输入司机电话"></el-input>
          </div>
        </div>
      </div>

    </div>

    <!--    订单主体-->
    <div class="order font-size-12">
      <div class="order-item">
        <span class="text-bold">供应商/仓库</span>
        <hr/>
        <el-input placeholder="请输入供应商/仓库"
                  v-model="goodsOrderList[0].supplier || goodsOrderList[0].storeHouseName"
                  disabled></el-input>
        <!--        供应商弹窗按钮-->
        <el-button size="mini" type="primary" icon="el-icon-user" circle @click="searchCompanyGiveInfo">
        </el-button>
        <el-button size="mini" icon="el-icon-s-home" circle @click="searchStoreInfo">
        </el-button>
      </div>
      <div class="order-item">
        <span class="text-bold">产品级别</span>
        <hr/>
        <el-input type="text" placeholder="请输入产品级别" v-model="goodsOrderList[0].levelName"></el-input>
        <el-button type="primary" size="mini" icon="el-icon-search" circle @click="searchProductLevelInfo"></el-button>
      </div>
      <div class="order-item">
        <span class="text-bold">计量单位</span>
        <hr/>
        <el-radio v-model="goodsOrderList[0].countingUnit" label="片数">片数</el-radio>
        <el-radio v-model="goodsOrderList[0].countingUnit" label="其他">其他</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">厚度</span>
        <hr/>
        <el-input type="text" placeholder="请输入厚度" v-model="goodsOrderList[0].height"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">长度</span>
        <hr/>
        <el-input type="text" placeholder="请输入长度" v-model="goodsOrderList[0].length"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">宽度</span>
        <hr/>
        <el-input type="text" placeholder="请输入宽度" v-model="goodsOrderList[0].width"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">每包片数</span>
        <hr/>
        <el-input type="text" placeholder="请输入每包片数"
                  v-model="goodsOrderList[0].piecesPerPack"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">包数</span>
        <hr/>
        <el-input type="text" placeholder="请输入包数" v-model="goodsOrderList[0].packs"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂片数</span>
        <hr/>
        <el-input type="text" placeholder="请输入出厂片数" v-model="goodsOrderList[0].pieces"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂单价</span>
        <hr/>
        <el-input type="text" placeholder="请输入出厂单价" v-model="goodsOrderList[0].price"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂是否含税</span>
        <hr/>
        <el-radio v-model="goodsOrderList[0].isIncludeTaxFactory" label="是">是</el-radio>
        <el-radio v-model="goodsOrderList[0].isIncludeTaxFactory" label="否">否</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">杂费</span>
        <hr/>
        <el-input type="text" placeholder="请输入杂费" v-model="goodsOrderList[0].sundryCost"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂货款</span>
        <hr/>
        <el-input type="text" placeholder="请输入出厂贷款"
                  v-model="goodsOrderList[0].paymentFactory"></el-input>
      </div>
      <!--      <div class="order-item">-->
      <!--        <span class="text-bold">卸货片数</span>-->
      <!--        <hr/>-->
      <!--        <el-input type="text" placeholder="请输入卸货片数"></el-input>-->
      <!--      </div>-->
      <div class="order-item">
        <span class="text-bold">卸货价</span>
        <hr/>
        <el-input type="text" placeholder="请输入卸货价" v-model="goodsOrderList[0].paymentUnload"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">销售是否含税</span>
        <hr/>
        <el-radio v-model="goodsOrderList[0].isIncludeTaxSale" label="是">是</el-radio>
        <el-radio v-model="goodsOrderList[0].isIncludeTaxSale" label="否">否</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">总货款</span>
        <hr/>
        <el-input type="text" placeholder="请输入总货款" v-model="goodsOrderList[0].payments"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">误差</span>
        <hr/>
        <el-input type="text" placeholder="请输入误差" v-model="goodsOrderList[0].erro"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">吨位</span>
        <hr/>
        <el-input type="text" placeholder="请输入吨位" v-model="goodsOrderList[0].tonnage"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">陆运费单价</span>
        <hr/>
        <el-input type="text" placeholder="请输入陆运费单价"
                  v-model="goodsOrderList[0].landFreightPrice"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">陆运费</span>
        <hr/>
        <el-input type="text" placeholder="陆运费" v-model="goodsOrderList[0].landFreight"></el-input>
      </div>
      <div class="order-item" v-if="isSea">
        <span class="text-bold">海运费</span>
        <hr/>
        <el-input type="text" placeholder="海运费" v-model="goodsOrderList[0].seaFreight"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">总运费</span>
        <hr/>
        <el-input type="text" placeholder="总运费" v-model="goodsOrderList[0].freight"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">加费</span>
        <hr/>
        <el-input type="text" placeholder="加费" v-model="goodsOrderList[0].additionalFees"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">其他费用</span>
        <hr/>
        <el-input type="text" placeholder="其他费用" v-model="goodsOrderList[0].otherCost"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">利润</span>
        <hr/>
        <el-input type="text" placeholder="利润" v-model="goodsOrderList[0].profit"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">不含税利润</span>
        <hr/>
        <el-input type="text" placeholder="不含税利润" v-model="goodsOrderList[0].profitNoTax"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">实际片数</span>
        <hr/>
        <el-input type="text" placeholder="实际片数" v-model="goodsOrderList[0].actualPieces"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">总货款杂费</span>
        <hr/>
        <el-input type="text" placeholder="总货款杂费"
                  v-model="goodsOrderList[0].paymentsWithSundry"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">物流利润</span>
        <hr/>
        <el-input type="text" placeholder="物流利润" v-model="goodsOrderList[0].logisticsProfit"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">客户佣金</span>
        <hr/>
        <el-input type="text" placeholder="客户佣金"
                  v-model="goodsOrderList[0].customerCommission"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">备注</span>
        <hr/>
        <el-input type="text" placeholder="备注" v-model="goodsOrderList[0].comments"></el-input>
      </div>
      <!--      <div class="order-item">-->
      <!--        <span class="text-bold">返利金额</span>-->
      <!--        <hr/>-->
      <!--        <el-input type="text" placeholder="返利金额"></el-input>-->
      <!--      </div>-->
      <!--      <div class="order-item">-->
      <!--        <span class="text-bold">降价金额</span>-->
      <!--        <hr/>-->
      <!--        <el-input type="text" placeholder="降价金额"></el-input>-->
      <!--      </div>-->
      <div class="option">
        <el-button type="primary" @click="submitOrderItems">提交</el-button>
        <el-button>重置</el-button>
      </div>
    </div>

    <!--    客户信息弹窗-->
    <el-dialog
      title="客户信息"
      :visible.sync="customerInfoDialogVisible"
      width="35%" append-to-body>
      <el-row :gutter="5">
        <el-col :span="4">
          <span style="font-weight: bolder;line-height: 40px">客户名称</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="customerName" placeholder="请输入客户名称"></el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" @click="searchCustomerInfo">搜索</el-button>
        </el-col>
      </el-row>

      <el-table
        :data="companyInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitCustomerInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="relationName"
          label="客户">
        </el-table-column>
        <el-table-column
          prop="leader"
          label="老板姓名">
        </el-table-column>
        <el-table-column
          prop="leaderTel"
          label="老板联系方式">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="customerInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="customerInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    陆运车牌信息弹窗-->
    <el-dialog
      title="车牌信息"
      :visible.sync="landInfoDialogVisible"
      width="35%" append-to-body>
      <el-table
        :data="landInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitCarsInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="carNo"
          label="车牌">
        </el-table-column>
        <el-table-column
          prop="driver"
          label="司机姓名">
        </el-table-column>
        <el-table-column
          prop="tel"
          label="司机电话">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="landInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="landInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    车队信息弹窗-->
    <el-dialog
      title="客户信息"
      :visible.sync="fleetInfoDialogVisible"
      width="35%" append-to-body>
      <!--      车队搜索框-->
      <el-row :gutter="5">
        <el-col :span="4">
          <span style="font-weight: bolder;line-height: 40px">车队</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="fleetName" placeholder="请输入车队名称"></el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" @click="searchFleetInfo">搜索</el-button>
        </el-col>
      </el-row>

      <!--      车队信息列表-->
      <el-table
        :data="fleetInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitFleetInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="fName"
          label="车队名称">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="fleetInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="fleetInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    海运车牌信息弹窗-->
    <el-dialog
      title="客户信息"
      :visible.sync="seaInfoDialogVisible"
      width="35%" append-to-body>
      <el-table
        :data="seaInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitSeaInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="relationName"
          label="客户">
        </el-table-column>
        <el-table-column
          prop="leader"
          label="老板姓名">
        </el-table-column>
        <el-table-column
          prop="leaderTel"
          label="老板联系方式">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="seaInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="seaInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>

    <!--    供应商信息弹窗-->
    <el-dialog
      title="供应商信息"
      :visible.sync="companyGiveDialogVisible"
      width="35%" append-to-body>
      <!--      供应商信息搜索-->
      <el-row :gutter="5">
        <el-col :span="4">
          <span style="font-weight: bolder;line-height: 40px">公司名称</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="companyName" placeholder="请输入公司名称"></el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" @click="searchCompanyGiveInfo">搜索</el-button>
        </el-col>
      </el-row>
      <el-table
        :data="companyGiveInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitCompanyGiveInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="companyName"
          label="供应商">
        </el-table-column>
        <el-table-column
          prop="address"
          label="地址">
        </el-table-column>
        <el-table-column
          prop="relationName"
          label="联系人">
        </el-table-column>
        <el-table-column
          prop="bankNo"
          label="银行账号">
        </el-table-column>
        <el-table-column
          prop="acountsName"
          label="户名">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="companyGiveDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="companyGiveDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    仓库信息弹窗-->
    <el-dialog
      title="仓库信息"
      :visible.sync="storeInfoDialogVisible"
      width="60%" append-to-body>
      <!--        <el-table-->
      <!--          :data="storeInfo"-->
      <!--          border>-->
      <!--          &lt;!&ndash;        操作&ndash;&gt;-->
      <!--          <el-table-column-->
      <!--            fixed="left"-->
      <!--            label="操作">-->
      <!--            <template slot-scope="scope">-->
      <!--              <el-button @click="commitStoreInfo(scope.row)" type="danger" size="small">确认</el-button>-->
      <!--            </template>-->
      <!--          </el-table-column>-->
      <!--          <el-table-column-->
      <!--            fixed-->
      <!--            prop="storeHouseName"-->
      <!--            label="仓库名称">-->
      <!--          </el-table-column>-->
      <!--          <el-table-column-->
      <!--            prop="address"-->
      <!--            label="仓库地址">-->
      <!--          </el-table-column>-->
      <!--        </el-table>-->
      <!--      </el-row>-->
      <!--      <br/>-->
      <!--      <hr/>-->
      <el-row>
        <span style="font-weight: bolder">库存信息</span>
      </el-row>
      <!--      搜索库存信息-->
      <el-row>
        <el-col :span="12">
          <el-input type="text"></el-input>
        </el-col>
        <el-col :span="5">
          <el-button type="primary">搜索</el-button>
        </el-col>
      </el-row>
      <br/>
      <!--      库存信息列表-->
      <el-row>
        <el-table
          :data="inventoryInfo"
          border>
          <!--         库存列表-->
          <el-table-column
            fixed="left"
            label="操作">
            <template slot-scope="scope">
              <el-button @click="commitStoreInfo(scope.row)" type="danger" size="small">确认</el-button>
            </template>
          </el-table-column>
          <el-table-column
            prop="storeHouseName"
            label="仓库名称">
          </el-table-column>
          <el-table-column
            prop="storeDate"
            label="入库日期">
          </el-table-column>
          <el-table-column
            prop="stockNumber"
            label="库存量">
          </el-table-column>
          <el-table-column
            prop="supplier"
            label="供应商">
          </el-table-column>
          <el-table-column
            prop="levelName"
            label="级别名称">
          </el-table-column>
          <el-table-column
            prop="countingUnit"
            label="计量单位">
          </el-table-column>
          <el-table-column
            prop="height"
            label="厚度">
          </el-table-column>
          <el-table-column
            prop="length"
            label="长度">
          </el-table-column>
          <el-table-column
            prop="width"
            label="宽度">
          </el-table-column>
          <el-table-column
            prop="pieces"
            label="出厂片数">
          </el-table-column>
          <el-table-column
            prop="piecesPerPack"
            label="每包片数">
          </el-table-column>
          <el-table-column
            prop="packs"
            label="包数">
          </el-table-column>
          <el-table-column
            prop="price"
            label="出厂单价">
          </el-table-column>
          <el-table-column
            prop="isIncludeTaxFactory"
            label="出厂是否含税">
          </el-table-column>
          <el-table-column
            prop="sundryCost"
            label="杂费">
          </el-table-column>
          <el-table-column
            prop="paymentFactory"
            label="出厂贷款">
          </el-table-column>
          <el-table-column
            prop="paymentUnload"
            label="卸货价">
          </el-table-column>
          <el-table-column
            prop="isIncludeTaxSale"
            label="销售是否含税">
          </el-table-column>
          <el-table-column
            prop="payments"
            label="总贷款">
          </el-table-column>
          <el-table-column
            prop="landCarNo"
            label="陆运车牌">
          </el-table-column>
          <el-table-column
            prop="landDriverTel"
            label="陆运司机电话">
          </el-table-column>
          <el-table-column
            prop="landDriverName"
            label="陆地司机姓名">
          </el-table-column>
          <el-table-column
            prop="seaCarNo"
            label="海运车牌">
          </el-table-column>
          <el-table-column
            prop="seaDriverTel"
            label="海运司机电话">
          </el-table-column>
          <el-table-column
            prop="seaDriverName"
            label="海运司机姓名">
          </el-table-column>
          <el-table-column
            prop="erro"
            label="误差">
          </el-table-column>
          <el-table-column
            prop="tonnage"
            label="吨位">
          </el-table-column>
          <el-table-column
            prop="landFreightPrice"
            label="陆运费单价">
          </el-table-column>
          <el-table-column
            prop="landFreight"
            label="陆运费">
          </el-table-column>
          <el-table-column
            prop="seaFreight"
            label="海运费">
          </el-table-column>
          <el-table-column
            prop="freight"
            label="运费（海运费+陆运费）">
          </el-table-column>
          <el-table-column
            prop="otherCost"
            label="其他费用">
          </el-table-column>
          <el-table-column
            prop="profit"
            label="利润">
          </el-table-column>
          <el-table-column
            prop="profitNoTax"
            label="不含税利润">
          </el-table-column>
          <el-table-column
            prop="actualPieces"
            label="实际片数">
          </el-table-column>
          <el-table-column
            prop="paymentsWithSundry"
            label="总货款杂费">
          </el-table-column>
          <el-table-column
            prop="additionalFees"
            label="加费">
          </el-table-column>
          <el-table-column
            prop="rebate"
            label="返利金额">
          </el-table-column>
          <el-table-column
            prop="customerCommission"
            label="客户佣金">
          </el-table-column>
          <el-table-column
            prop="comments"
            label="备注">
          </el-table-column>
        </el-table>
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="storeInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="storeInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    产品级别信息弹窗-->
    <el-dialog
      title="产品级别信息"
      :visible.sync="productLevelDialogVisible"
      width="35%" append-to-body>
      <el-row style="margin-bottom: 20px">
        <!--      产品级别-->
        <el-col :span="3">
          <span style="font-weight: bolder;line-height: 40px">产品级别</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="productLevel.level" placeholder="请输入产品级别"></el-input>
        </el-col>
        <!--        宽度-->
        <el-col :span="2">
          <span style="font-weight: bolder;line-height: 40px">宽度</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="productLevel.width" placeholder="请输入产品级别"></el-input>
        </el-col>
        <el-col :span="2">
          <el-button type="primary" @click="searchProductLevelInfo">搜索</el-button>
        </el-col>
      </el-row>
      <el-table
        :data="productLevelInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitProductLevelInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="categoryName"
          label="分类">
        </el-table-column>
        <el-table-column
          prop="levelNo"
          label="产品级别编码">
        </el-table-column>
        <el-table-column
          prop="levelName"
          label="标题">
        </el-table-column>
        <el-table-column
          prop="height"
          label="厚度">
        </el-table-column>
        <el-table-column
          prop="length"
          label="长度">
        </el-table-column>
        <el-table-column
          prop="width"
          label="宽度">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="productLevelDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="productLevelDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>

  </div>
</template>

<style scoped lang="scss">
* {
  box-sizing: border-box;
}

/*订单头部搜索信息*/
.order-header {
  display: flex;
  align-items: center;
  width: 100%;
  flex-wrap: wrap;
}

.header-item {
  width: 30%;
  margin-top: 10px;
}

/*订单信息*/
.order {
  overflow-x: scroll;
  display: flex;
  width: 100%;
  justify-content: flex-start;
  align-items: center;
  margin: 12px auto;
}

.order-item {
  height: 120px;
  flex: 0 0 100px;
  flex-direction: column;
  flex-wrap: nowrap;
  border: 1px solid #dddddd;
  background-color: #f9f9f9;

  span {
    font-weight: bolder;
  }
}

.option {
  line-height: 100px;
  width: 60%;
  height: 120px;
  flex: 0 0 200px;
}

.font-size-12 {
  font-size: 12px;
}

.width-50px {
  width: 50px;
}
</style>
