<!--订单表组件-->

<script>
import OrderItem from "@/components/OrderItem.vue";
import SearchOption from "./SearchOption.vue";
import {listCompany} from "../api/system/company";
import {listBankAccount} from "../api/system/bankAccount";
import {listCars} from "../api/system/cars";
import {listFleet} from "../api/system/fleet";
import {parseTime} from "../utils/ruoyi";
import {addGoodsOrder, getGoodsOrder, updateGoodsOrder} from "../api/system/goodsOrder";
import {excludeParams} from "../api/tool/exclude";
import {mapGetters} from "vuex";

export default {
  name: "OrderForm",
  components: {SearchOption, OrderItem},
  props: {
    orderId: '',
    // 确认按钮字样
    submitInfo: '',
  },
  data() {
    return {
      // 订单信息
      orderInfo: {},
      //海运还是陆运
      isLand: false,
      isSea: false,
      // 客户搜索
      queryCompanyName: '',
      // 车牌银行卡
      queryLandCar: '',
      // 车队
      queryFleet: '',
      // 海运车牌
      querySeaCars: '',
      orderNums: 0,
    }
  },

  //计算属性 目的是为了避免无法输入修改父组件
  computed: {
    ...mapGetters(['orderItemList'])
  },
  watch: {
    'orderId': {
      handler(val) {
        if (!this.orderId) {
        } else {
          this.getGoodsOrderInfo(val)
        }
      },
      immediate: true
    },
    // 监听海运和陆运 如果不选 那么就要清空海运和陆运的相关信息 todo
    isLand: {
      handler(val) {
        if (val === false) {
          this.resetLandCarInfo()
        }
      }
    },
    isSea: {
      handler(val) {
        if (val === false) {
          this.resetSeaCarInfo()
        }
      }
    }
  },
  created() {
    this.resetOrderInfo()
    if (!this.orderId) {
      console.log('orderId:传入有误', this.orderId)
    } else {
      this.getGoodsOrderInfo(this.orderId)
    }
  },
  methods: {
    listFleet,
    listCars,
    listBankAccount,
    listCompany,
    // 获取订单信息的方法
    getGoodsOrderInfo(id) {
      getGoodsOrder(id).then(response => {
        this.orderInfo = response.data;
        // 如果海运费或者陆运费大于0
        if (response.data.landFreight > 0) {
          this.isLand = true;
        }
        if (response.data.seaFreight > 0) {
          this.isSea = true;
        }

        //将数据库拿到的订单列表装入vuex 因为订单添加的货物是从vuex获取的数据 对货物的操作也是操作vuex orderIndex
        let i = 0;
        const list = response.data.orderDetailList.map(item => {
          return {
            ...item,
            orderIndex: i++
          }
        })
        this.$store.dispatch("order/setOrderItemListAsync", list)
        this.orderNums = response.data.orderDetailList.length;
        //填充供应商和客户id
        for (let i = 0; i < this.orderInfo.orderDetailList.length; i++) {
          let item = this.orderInfo.orderDetailList[i];
          item.customerID = this.orderInfo.customerID;
          item.customer = this.orderInfo.customer;
          //是否含税
          item.isIncludeTaxFactory = item.isIncludeTaxFactory === '是' ? '1' : '0';
          item.isIncludeTaxSale = item.isIncludeTaxSale === '是' ? '1' : '0';
        }
      });
    },
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
    // 重置陆运费
    resetSeaCarInfo() {
      this.orderInfo.seaCarID = ''
      this.orderInfo.seaCarNo = ''
      this.orderInfo.seaDriverName = ''
      this.orderInfo.seaDriverTel = ''
    },
    // 重置海运费
    resetLandCarInfo() {
      this.orderInfo.landCarID = ''
      this.orderInfo.landCarNo = ''
      this.orderInfo.landDriverName = ''
      this.orderInfo.landDriverTel = ''
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
    },
    // 海运车牌的填充
    handleChangeSeaCar(val) {
      this.querySeaCars = val;
    },
    handleCommitBackSeaCar(val) {
      this.orderInfo.seaCarID = val.id;
      this.orderInfo.seaCarNo = val.carNo;
      this.orderInfo.seaDriverName = val.driver;
      this.orderInfo.seaDriverTel = val.tel;
      //填充银行信息
      this.orderInfo.seaBankName = val.acountsName;
      this.orderInfo.seaBankNo = val.bankNo;
    },
    // 添加货物
    addOrderItem() {
      this.$store.commit('order/addsOrderItem', {...this.orderItemInfo, orderIndex: this.orderNums})
      this.orderNums++;
    },
    //删除订单详情
    handleDeleteOrderDetail(index, event) {
      // 删除orderItemList中索引为index的元素
      this.$store.commit('order/removeOrderItem', index)
      this.orderNums--;
    },
    // // 置空某个货物
    // handleClearOrderDetail(index) {
    //   console.log(index)
    //   this.$store.commit('order/clearOrderItemStatus', index)
    // },
    // 取消添加订单
    cancelSubmit() {
      this.orderNums = 0
      this.isSea = false
      this.isLand = false
      this.$store.commit('order/clearOrderItemList'); // 清空订单详情填写信息
      this.resetOrderInfo() // 清空订单列表基础信息
      this.$emit('close-dialog'); // 关闭弹窗

    },
    //提交订单
    //订单列表的对象封装一个，订单详情有两个一样的对象 对应供应商发货和仓库发货
    submitOrder() {
      if (!this.orderId) {
        this.orderInfo.orderDetailList = this.orderItemList; //从vuex拿到订单详细列表 加入到订单信息中
        //订单详情添加客户信息
        for (let i = 0; i < this.orderItemList.length; i++) {
          let item = this.orderItemList[i];
          item.customerID = this.orderInfo.customerID;
          item.customer = this.orderInfo.customer;
          //是否含税
          item.orderDate = parseTime(new Date(), '{y}-{m}-{d}')
        }
        addGoodsOrder({...this.orderInfo, PaymentState: ''}).then(res => {
          this.$message.success('订单提交成功')
          this.resetOrderInfo() // 清空订单列表基础信息
          this.$store.commit('order/clearOrderItemList');
          this.$emit('close-dialog');
          this.isSea = false
          this.isLand = false
        })
      } else {
        this.handleUpdateGoodsOrder()
      }
    },
    //修改后提交订单信息
    handleUpdateGoodsOrder() {
      if (this.orderId != null) {
        // 先拿到订单货物信息
        this.orderInfo.orderDetailList = this.orderItemList; //从vuex拿到订单详细列表 加入到订单信息中
        //订单详情添加客户信息
        for (let i = 0; i < this.orderItemList.length; i++) {
          let item = this.orderItemList[i];
          item.customerID = this.orderInfo.customerID;
          item.customer = this.orderInfo.customer;
          item.isIncludeTaxFactory = item.isIncludeTaxFactory === '是' ? '1' : '0';
          item.isIncludeTaxSale = item.isIncludeTaxSale === '是' ? '1' : '0';
          item.orderDate = parseTime(new Date(), '{y}-{m}-{d}')
        }
        this.orderInfo = excludeParams(this.orderInfo, this.$exclude)
        // 修改订单
        updateGoodsOrder({
          ...this.orderInfo,
          PaymentState: '',
          remark: sessionStorage.getItem('order-edit-reason')
        }).then(response => {
          this.$modal.msgSuccess("修改成功");
          this.resetOrderInfo() // 清空订单列表基础信息
          this.$store.commit('order/clearOrderItemList');
          sessionStorage.removeItem('order-edit-reason')
          this.isSea = false
          this.isLand = false
          this.$emit('close-dialog');
        });
      }
    },
    close() {
      this.$emit('close')
    },
  }
  ,

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
        <el-row style="margin:20px 0;" v-if="isLand">
          <el-form-item label="车牌">
            <el-row>
              <el-col :span="20">
                <el-input type="text" v-model="orderInfo.landCarNo" size="mini"
                          placeholder="请输入陆运车牌" style="width: 120px"></el-input>
              </el-col>
              <el-col :span="4">
                <!--搜索银行卡信息-->
                <SearchOption :limit-info="{carType:'陆运'}"
                              :get-data="listCars"
                              query-label="车牌搜索" query-info="carNo" :query-name="queryLandCar"
                              @commitBack="handleCommitBackCar" @update:queryName="handleChangeCar">
                  <template #table-columns>
                    <el-table-column label="车牌" align="center" prop="carNo"/>
                    <el-table-column label="司机" align="center" prop="driver"/>
                    <el-table-column label="司机电话" align="center" prop="tel"/>
                    <el-table-column label="开户名" align="center" prop="acountsName"/>
                    <el-table-column label="账号" align="center" prop="bankNo"/>
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
                    <el-table-column label="车队名称" align="center" prop="fName"/>
                    <el-table-column label="车队经理" align="center" prop="fLeader"/>
                    <el-table-column label="车队经理电话" align="center" prop="tel"/>
                    <el-table-column label="地址" align="center" prop="address"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
        </el-row>
        <!--      海运-->
        <el-row style="margin:10px 0;" v-if="isSea">
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
                    <el-table-column label="车牌" align="center" prop="carNo"/>
                    <el-table-column label="司机" align="center" prop="driver"/>
                    <el-table-column label="司机电话" align="center" prop="tel"/>
                    <el-table-column label="开户名" align="center" prop="acountsName"/>
                    <el-table-column label="账号" align="center" prop="bankNo"/>
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
        <el-button type="text" style="color: #156fb2;float: right">
          货物个数:{{ orderNums }}
        </el-button>
      </div>
      <!--      如果有-->
      <div v-if="orderItemList.length!==0">
        <div v-for="(item,index) in orderItemList" :key="index">
          <transition name="fade">
            <OrderItem :tempOrderInfo="item" :isLand="isLand" :isSea="isSea" :index="index">
              <template #action>
                <el-button style="float: right; padding: 3px 0;color: red" type="text"
                           @click="handleDeleteOrderDetail(index,$event)">删除
                </el-button>
              </template>
            </OrderItem>
          </transition>
        </div>
      </div>
      <!--      如果没有订单信息-->
      <el-row>
        <el-col>
          <el-button type="primary" @click="addOrderItem" icon="el-icon-plus">添加订单货物信息</el-button>
        </el-col>
      </el-row>
    </el-card>
    <br/>
    <el-card class="box-card" shadow="hover">
      <el-row style="text-align: right">
        <el-button @click="cancelSubmit">取 消</el-button>
        <el-tooltip class="item" effect="dark" content="添加或修改前请先点击添加货物!" placement="top-start">
          <el-button type="primary" @click="submitOrder">{{ submitInfo }}</el-button>
        </el-tooltip>
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
