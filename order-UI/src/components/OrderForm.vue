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
  props: {
    //订单信息
    // orderInfo: {},
    orderInfo: {
      type: Object,
      required: true
    },
  },
  data() {
    return {
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
    computedOrderInfo: {
      get() {

      },
      set() {

      }
    },
    // 日期
    orderDate: {
      get() {
        return this.orderInfo.orderDate;
      },
      set(val) {
        this.handleUpdateOrderInfo({...this.orderInfo, orderDate: val})
      }
    },
    //客户
    customer: {
      get() {
        return this.orderInfo.customer;
      },
      set(val) {
        this.handleUpdateOrderInfo({...this.orderInfo, customer: val})
      }
    },
    //销售经理
    saleManager: {
      get() {
        return this.orderInfo.saleManager;
      },
      set(val) {
        //将新输入的值更新到父组件 添加延时操作 避免解构赋空
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, saleManager: val})
        }, 20)
      }
    },
    //备注
    comments: {
      get() {
        return this.orderInfo.comments;
      },
      set(val) {
        //将新输入的值更新到父组件 添加延时操作 避免解构赋空
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, comments: val})
        }, 20)
      }
    },
    //陆运车牌
    landCarNo: {
      get() {
        return this.orderInfo.landCarNo;
      },
      set(val) {
        this.handleUpdateOrderInfo({...this.orderInfo, landCarNo: val})
      }
    },
    //司机名称
    landDriverName: {
      get() {
        return this.orderInfo.landDriverName;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, landDriverName: val})
        }, 20)
      }
    },
    //司机电话
    landDriverTel: {
      get() {
        return this.orderInfo.landDriverTel;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, landDriverTel: val})
        }, 30)
      }
    },
    //司机银行卡信息
    landBankName: {
      get() {
        return this.orderInfo.landBankName;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, landBankName: val})
        }, 40)
      }
    },
    landBankNo: {
      get() {
        return this.orderInfo.landBankNo;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, landBankNo: val})
        }, 50)
      }
    },
    //车队
    fleet: {
      get() {
        return this.orderInfo.fleet;
      },
      set(val) {
        this.handleUpdateOrderInfo({...this.orderInfo, fleet: val})
      }
    },
    //海运车辆信息的计算属性
    seaCarNo: {
      get() {
        return this.orderInfo.seaCarNo;
      },
      set(val) {
        this.handleUpdateOrderInfo({...this.orderInfo, seaCarNo: val})
      }
    },
    seaDriverName: {
      get() {
        return this.orderInfo.seaDriverName;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, seaDriverName: val})
        }, 20)
      }
    },
    seaDriverTel: {
      get() {
        return this.orderInfo.seaDriverTel;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, seaDriverTel: val})
        }, 25)
      }
    },
    //海运司机银行卡信息
    seaBankName: {
      get() {
        return this.orderInfo.seaBankName;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, seaBankName: val})
        }, 30)
      }
    },
    seaBankNo: {
      get() {
        return this.orderInfo.seaBankNo;
      },
      set(val) {
        setTimeout(() => {
          this.handleUpdateOrderInfo({...this.orderInfo, seaBankNo: val})
        }, 40)
      }
    },
    //获取订单列表
    ...mapGetters(['orderItemList'])
  },
  methods: {
    listFleet,
    listCars,
    listBankAccount,
    listCompany,
    //这个方法用来修改父组件的某一个属性
    handleUpdateOrderInfo(newOrderValue) {
      this.$emit('updateOrderInfo', newOrderValue)
    },
    // 车队的自动填充
    handleChangeFleet(val) {
      this.queryFleet = val
    },
    handleCommitBackFleet(val) {
      this.fleet = val.fName
    },

    // 客户搜索的自动填充
    handleCommitBackCompany(val) {
      this.orderInfo.customerID = val.id;
      this.customer = val.relationName;
      this.saleManager = val.salesManager;
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
      this.landCarNo = val.carNo;
      this.landDriverName = val.driver;
      this.landDriverTel = val.tel;
      //填充银行信息
      this.orderInfo.landBankName = val.acountsName;
      this.orderInfo.landBankNo = val.bankNo;
      this.landBankName = val.bankName;
      this.landBankNo = val.bankNo
    },
    // 海运车牌的填充
    handleChangeSeaCar(val) {
      this.orderInfo.seaCarID = val.id;
      this.seaCarNo = val.carNo;
      this.seaDriverName = val.driver;
      this.seaDriverTel = val.tel;
      //填充银行信息
      this.orderInfo.seaBankName = val.acountsName;
      this.orderInfo.seaBankNo = val.bankNo;
      this.seaBankName = val.bankName;
      this.seaBankNo = val.bankNo
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
      this.$store.dispatch('order/clearOrderItemList'); // 清空订单详情填写信息
      this.orderInfo = {} // 清空订单列表基础信息
      this.addOrderItemVisible = false
    },
    //提交订单
    //订单列表的对象封装一个，订单详情有两个一样的对象 对应供应商发货和仓库发货
    submitOrder() {
      this.addOrderItemVisible = false
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
        this.getList()
      })
    },
  },
  created() {

  },
}
</script>

<template>
  <div>
    <!--    订单基本信息-->
    <el-card class="box-card" shadow="hover">
      <div slot="header" class="clearfix">
        <span>订单基本信息</span>
      </div>
      <div class="order-header">
        <div class="header-item">
          <el-row>
            <el-col :span="3">
              <span style="font-weight: bolder">日期</span>
            </el-col>
            <el-col :span="21">
              <el-date-picker
                  v-model="orderDate"
                  size="mini"
                  type="date"
                  placeholder="选择日期"
                  value-format="yyyy-MM-dd"
                  style="width: 80%">
              </el-date-picker>
            </el-col>
          </el-row>
        </div>
        <div class="header-item">
          <el-row>
            <el-col style="font-weight: bolder;" :span="3">客户</el-col>
            <el-col :span="10">
              <el-input type="text" v-model="customer" size="mini"
                        placeholder="请输入客户名称"></el-input>
            </el-col>
            <el-col :span="2">
              <SearchOption :limit-info="{companyType:'客户'}"
                            :get-data="listCompany" query-info="companyName"
                            query-label="公司名称" :query-name="queryCompanyName"
                            @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                <template #table-columns>
                  <el-table-column label="客户" align="center"
                                   prop="relationName"/>
                  1
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="区域" align="center" prop="region"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="销售经理" align="center" prop="salesManager"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </div>
        <div class="header-item">
          <span style="font-weight: bolder">销售经理</span>
          <el-input type="text" v-model="saleManager" size="mini" style="width: 60%"
                    placeholder="请输入销售经理名称"></el-input>
        </div>
        <div class="header-item">
          <span style="font-weight: bolder">备注</span>
          <el-input type="text" v-model="comments" size="mini" style="width: 60%"
                    placeholder="请输入备注"></el-input>
        </div>

        <!--      多选框-->
        <div class="header-item">
          <span style="font-weight: bolder;">交通运输方式: </span>
          <el-checkbox v-model="isLand">陆运</el-checkbox>
          <el-checkbox v-model="isSea">海运</el-checkbox>
        </div>

        <!--      陆运-->
        <div style="margin:20px 0;" v-if="isLand || orderInfo.landFreight > 0">
          <div style="display: flex;">
            <div>
              <!--            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchLandInfo"></el-button>-->
              <el-row>
                <el-col :span="5">
                  <span style="font-weight: bold">陆运车牌</span>
                </el-col>
                <el-col :span="10">
                  <el-input type="text" v-model="landCarNo" size="mini"
                            placeholder="请输入陆运车牌"></el-input>
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
            </div>
            <div>
              <span style="font-weight: bold">陆运司机姓名</span>
              <el-input type="text" v-model="landDriverName" size="mini" style="width: 60%"
                        placeholder="请输入陆运司机姓名"></el-input>
            </div>
            <div>
              <span style="font-weight: bold">陆运司机电话</span>
              <el-input type="text" v-model="landDriverTel" size="mini" style="width: 60%"
                        placeholder="请输入陆运司机电话"></el-input>
            </div>
            <div>
              <!--              <el-button type="primary" size="mini" icon="el-icon-search" @click="searchFleetInfo"></el-button>-->
              <el-row>
                <el-col :span="5">
                  <span style="font-weight: bold">车队</span>
                </el-col>
                <el-col :span="10">
                  <el-input type="text" v-model="fleet" size="mini"
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
            </div>
          </div>
        </div>

        <!--      海运-->
        <div style="margin:10px 0;" v-if="isSea || orderInfo.seaFreight > 0">
          <div style="display: flex;">
            <div>
              <el-row>
                <el-col :span="5">
                  <span style="font-weight: bold">海运车牌</span>
                </el-col>
                <el-col :span="10">
                  <el-input type="text" v-model="seaCarNo" size="mini"
                            placeholder="请输入海运车牌"></el-input>
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
            </div>
            <div>
              <span style="font-weight: bold">海运司机姓名</span>
              <el-input type="text" v-model="seaDriverName" size="mini" style="width: 60%"
                        placeholder="请输入司机姓名"></el-input>
            </div>
            <div>
              <span style="font-weight: bold">海运司机电话</span>
              <el-input type="text" v-model="seaDriverTel" size="mini" style="width: 60%"
                        placeholder="请输入司机电话"></el-input>
            </div>
          </div>
        </div>
      </div>
      <br/>
    </el-card>
    <br/>

    <!--    货物信息 可以添加多个货物信息-->
    <el-card class="box-card" shadow="hover">
      <div slot="header" class="clearfix">
        <span>订单货物信息</span>
      </div>
      <!--      如果有-->
      <div v-if="orderItemList.length!==0">
        <div v-for="(item,index) in orderItemList" :key="index">
          <OrderItem :order-item-info="item" :isLand="isLand" :isSea="isSea" :index="index"
                     @changeOrderItemInfo="handleChangeOrderItemInfo(index,$event)"/>
          <el-row>
            <el-button type="danger" @click="handleDeleteOrderDetail(index,$event)">删除该订单详情信息</el-button>
          </el-row>
        </div>
        <div class="option">
          <el-row>
            <el-col style="text-align: center">
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

    <!--    todo 重构-->
    <!--    <el-card class="box-card" shadow="hover">-->
    <!--      <el-button @click="cancelSubmit">取 消</el-button>-->
    <!--      <el-button type="primary" @click="submitOrder">添加订单</el-button>-->
    <!--    </el-card>-->

    <!--    海运车牌信息弹窗-->
    <el-dialog
        title="海运车辆信息"
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
    <el-button @click="seaInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="seaInfoDialogVisible = false">确 定</el-button>
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
  width: 20%;
}


</style>
