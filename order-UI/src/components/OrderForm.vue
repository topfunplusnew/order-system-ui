<!--订单表组件-->

<script>
import OrderItem from "@/components/OrderItem.vue";
import {mapGetters} from "vuex";
import SearchOption from "./SearchOption.vue";
import {listCompany} from "../api/system/company";
import {listBankAccount} from "../api/system/bankAccount";
import {listCars} from "../api/system/cars";
import {listFleet} from "../api/system/fleet";
import {parseTime} from "../utils/ruoyi";
import {addGoodsOrder} from "../api/system/goodsOrder";

export default {
  name: "OrderForm",
  components: {SearchOption, OrderItem},
  props: {},
  data() {
    return {
      // 订单信息
      orderInfo: {},
      //订单信息中的items
      goodsOrderList: [],
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
      //客户信息
      companyInfo: [],
      //陆运车牌信息
      landInfo: [],
      //车队信息
      fleetInfo: [],
      //海运车牌信息
      seaInfo: [],
      //客户信息弹窗的搜索客户名
      customerName: '',
      //车队搜索
      fleetName: '',
      // 客户搜索
      queryCompanyName: '',
      // 车牌银行卡
      queryLandCar: '',
      // 车队
      queryFleet: '',
      // 海运车牌
      querySeaCars: ''
    }
  },
  //计算属性 目的是为了避免无法输入修改父组件
  computed: {
    //获取订单列表
    ...mapGetters(['orderItemList'])
  },
  methods: {
    listFleet,
    listCars,
    listBankAccount,
    listCompany,
    // 信息重置
    resetOrderInfo() {
      this.orderInfo = {
        orderID: '',
        orderNo: '',
        customerID: '',
        customer: '',
        saleManager: '',
        orderDetailList: [],
        orderState: '',
        orderDate: '',
        orderType: '',
        landCarID: '',
        landCarNo: '',
        landDriverName: '',
        landDriverTel: '',
        landBankName: '',
        landBankNo: '',
        seaCarID: '',
        seaCarNo: '',
        seaDriverName: '',
        seaDriverTel: '',
        isSea: '',
        isLand: '',
      }
    },
    // 车队的自动填充
    handleChangeFleet(val) {
      this.queryFleet = val
    },
    handleCommitBackFleet(val) {
      this.orderInfo.fleet = val.fName
    },

    // 客户搜索的自动填充
    handleCommitBackCompany(val) {
      this.orderInfo.customerID = val.id;
      this.orderInfo.customer = val.relationName;
      this.orderInfo.saleManager = val.salesManager;
    },
    handleUpdateCompanyName(val) {
      this.queryCompanyName = val;
    },

    //陆运车牌的自动填充
    handleChangeCar(val) {
      this.queryLandCar = val;
    },
    handleCommitBackCar(val) {
      this.orderInfo.landCarID = val.id;
      //与上面填充客户信息同理
      this.orderInfo.landCarNo = val.carNo;
      this.orderInfo.landDriverName = val.driver;
      this.orderInfo.landDriverTel = val.tel;
      //填充银行信息
      this.orderInfo.landBankName = val.acountsName;
      this.orderInfo.landBankNo = val.bankNo;
      this.orderInfo.landBankName = val.bankName;
      this.orderInfo.landBankNo = val.bankNo
    },
    // 海运车牌的填充
    handleChangeSeaCar(val) {
      this.orderInfo.seaCarID = val.id;
      this.orderInfo.seaCarNo = val.carNo;
      this.orderInfo.seaDriverName = val.driver;
      this.orderInfo.seaDriverTel = val.tel;
      //填充银行信息
      this.orderInfo.seaBankName = val.acountsName;
      this.orderInfo.seaBankNo = val.bankNo;
      this.orderInfo.seaBankName = val.bankName;
      this.orderInfo.seaBankNo = val.bankNo
    },
    handleCommitBackSeaCar(val) {
      this.querySeaCars = val;
    },


    //添加订单vuex
    addOrderItem() {
      this.$store.dispatch('order/addOrderItemList', {})
    },
    handleChangeOrderItemInfo(index, val) {
      //改变vuex中的数据 传递一个对象 这个对象是修改过的item
      this.$store.dispatch('order/changeOrderItem', {...val, index: index})
    },
    //删除订单详情
    handleDeleteOrderDetail(index, event) {
      this.$store.dispatch('order/deleteOrderItem', index)
    },
    // 取消添加订单
    cancelSubmit() {
      this.isSea = false
      this.isLand = false
      this.$store.dispatch('order/clearOrderItemList'); // 清空订单详情填写信息
      this.resetOrderInfo() // 清空订单列表基础信息
      this.$emit('close-dialog'); // 关闭弹窗
    },
    //提交订单
    //订单列表的对象封装一个，订单详情有两个一样的对象 对应供应商发货和仓库发货
    submitOrder() {
      this.orderInfo.orderDetailList = this.orderItemList; //从vuex拿到订单详细列表 加入到订单信息中
      //订单详情添加客户信息
      for (let i = 0; i < this.orderItemList.length; i++) {
        let item = this.orderItemList[i];
        item.customerID = this.orderInfo.customerID;
        item.customer = this.orderInfo.customer;
        //是否含税
        item.isIncludeTaxFactory = item.isIncludeTaxFactory === '是' ? '1' : '0';
        item.isIncludeTaxSale = item.isIncludeTaxSale === '是' ? '1' : '0';
        item.orderDate = parseTime(new Date(), '{y}-{m}-{d}')
      }
      addGoodsOrder({...this.orderInfo, PaymentState: ''}).then(res => {
        this.$message.success('订单提交成功')
        this.resetOrderInfo() // 清空订单列表基础信息
        this.$emit('close-dialog');
        this.isSea = false
        this.isLand = false
        this.getList()
      })
    },
  },
  created() {
    this.resetOrderInfo();
  },
}
</script>

<template>
  <div>
    <!--    订单基本信息-->
    <el-form :inline="true" :model="orderInfo" label-width="68px">
      <el-card class="box-card" shadow="hover">
        <div slot="header" class="clearfix">
          <el-button type="text" style="color: #156fb2" icon="el-icon-notebook-2">订单基本信息</el-button>
        </div>
        <el-form-item label="订单日期" prop="orderDate">
          <el-date-picker
              v-model="orderInfo.orderDate"
              size="mini"
              type="date"
              placeholder="选择日期"
              value-format="yyyy-MM-dd" style="width: 120px">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="客户" prop="customer">
          <el-row>
            <el-col :span="14">
              <el-input type="text" v-model="orderInfo.customer" size="mini"
                        placeholder="请输入客户名称"></el-input>
            </el-col>
            <el-col :span="4">
              <SearchOption :limit-info="{companyType:'客户'}"
                            :get-data="listCompany" query-info="companyName"
                            query-label="公司名称" :query-name="queryCompanyName"
                            @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
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
          </el-row>
        </el-form-item>
        <el-form-item label="销售经理" prop="saleManager">
          <el-input type="text" v-model="orderInfo.saleManager" size="mini"
                    placeholder="请输入销售经理名称" style="width: 110px"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input type="text" v-model="orderInfo.comments" size="mini"
                    placeholder="请输入备注"></el-input>
        </el-form-item>
        <el-form-item label="运输方式">
          <el-checkbox v-model="isLand">陆运</el-checkbox>
          <el-checkbox v-model="isSea">海运</el-checkbox>
        </el-form-item>

        <!--      陆运-->
        <el-row style="margin:20px 0;" v-if="isLand || orderInfo.landFreight > 0">
          <el-form-item label="车牌">
            <el-row>
              <el-col :span="20">
                <el-input type="text" v-model="orderInfo.landCarNo" size="mini"
                          placeholder="请输入陆运车牌" style="width: 120px"></el-input>
              </el-col>
              <el-col :span="4">
                <!--搜索银行卡信息-->
                <SearchOption :limit-info="{companyType:'司机'}"
                              :get-data="listCars"
                              query-label="车牌搜索" query-info="carNo" :query-name="queryLandCar"
                              @commitBack="handleCommitBackCar" @update:queryName="handleChangeCar">
                  <template #table-columns>
                    <el-table-column label="车牌" align="center" prop="carNo"/>
                    <el-table-column label="司机" align="center" prop="driver"/>
                    <el-table-column label="司机电话" align="center" prop="tel"/>
                    <el-table-column label="开户名" align="center" prop="acountsName"/>
                    <el-table-column label="账号" align="center" prop="bankNo"/>
                    <el-table-column label="余额" align="center" prop="surplusMoney"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="司机">
            <el-input type="text" v-model="orderInfo.landDriverName" size="mini"
                      placeholder="请输入陆运司机姓名" style="width: 130px"></el-input>
          </el-form-item>
          <el-form-item label="电话">
            <el-input type="text" v-model="orderInfo.landDriverTel" size="mini"
                      placeholder="请输入陆运司机电话" style="width: 120px"></el-input>
          </el-form-item>
          <el-form-item label="车队">
            <el-row>
              <el-col :span="12">
                <el-input type="text" v-model="orderInfo.fleet" size="mini"
                          placeholder="请输入车队"></el-input>
              </el-col>
              <el-col :span="4">
                <SearchOption :limit-info="{}"
                              :get-data="listFleet"
                              query-label="车队名称" query-info="fName" :query-name="queryFleet"
                              @commitBack="handleCommitBackFleet" @update:queryName="handleChangeFleet">
                  <template #table-columns>
                    <el-table-column label="开户行" align="center" prop="bankName"/>
                    <el-table-column label="开户名" align="center" prop="acountsName"/>
                    <el-table-column label="账号" align="center" prop="bankNo"/>
                    <el-table-column label="余额" align="center" prop="surplusMoney"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
        </el-row>
        <!--      海运-->
        <el-row style="margin:10px 0;" v-if="isSea || orderInfo.seaFreight > 0">
          <el-form-item label="车牌">
            <el-row>
              <el-col :span="20">
                <el-input type="text" v-model="orderInfo.seaCarNo" size="mini"
                          placeholder="请输入海运车牌" style="width: 120px"></el-input>
              </el-col>
              <el-col :span="4">
                <SearchOption :limit-info="{carType:'海运'}"
                              :get-data="listCars"
                              query-label="车牌" query-info="carNo" :query-name="querySeaCars"
                              @commitBack="handleCommitBackSeaCar" @update:queryName="handleChangeSeaCar">
                  <template #table-columns>
                    <el-table-column label="开户行" align="center" prop="bankName"/>
                    <el-table-column label="开户名" align="center" prop="acountsName"/>
                    <el-table-column label="账号" align="center" prop="bankNo"/>
                    <el-table-column label="余额" align="center" prop="surplusMoney"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="司机">
            <el-input type="text" v-model="orderInfo.seaDriverName" size="mini"
                      placeholder="请输入海运司机姓名" style="width: 130px"></el-input>
          </el-form-item>
          <el-form-item label="电话">
            <el-input type="text" v-model="orderInfo.seaDriverTel" size="mini"
                      placeholder="请输入海运司机电话" style="width: 120px"></el-input>
          </el-form-item>
        </el-row>
        <br/>
      </el-card>
    </el-form>
    <br/>

    <!--    货物信息 可以添加多个货物信息-->
    <el-card class="box-card" shadow="hover">
      <div slot="header" class="clearfix">
        <el-button type="text" style="color: #156fb2" icon="el-icon-shopping-cart-2">订单货物信息</el-button>
      </div>
      <!--      如果有-->
      <div v-if="orderItemList.length!==0">
        <div v-for="(item,index) in orderItemList" :key="index">
          <transition name="fade">
            <OrderItem :order-item-info="item" :isLand="isLand" :isSea="isSea" :index="index"
                       @changeOrderItemInfo="handleChangeOrderItemInfo(index,$event)">
              <template #action>
                <el-button style="float: right; padding: 3px 0;color: red" type="text"
                           @click="handleDeleteOrderDetail(index,$event)">删除
                </el-button>
              </template>
            </OrderItem>
          </transition>
        </div>
        <div class="option">
          <el-row>
            <el-col :span="6" :offset="10">
              <el-button type="primary" @click="addOrderItem" icon="el-icon-plus">继续添加订单详情</el-button>
            </el-col>
          </el-row>
        </div>
      </div>
      <!--      如果没有订单信息-->
      <div v-else>
        <el-row>
          <el-col>
            <el-button type="primary" @click="addOrderItem" icon="el-icon-plus">添加订单货物信息</el-button>
          </el-col>
        </el-row>
      </div>
    </el-card>
    <br/>
    <el-card class="box-card" shadow="hover">
      <el-row style="text-align: right">
        <el-button @click="cancelSubmit">取 消</el-button>
        <el-button type="primary" @click="submitOrder">添加订单</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<style scoped>
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
  width: 20%;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 2.2s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
