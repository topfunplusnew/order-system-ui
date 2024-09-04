<!--订单表组件-->

<script>
import {listCompany} from "@/api/system/company";
import {listCars} from "@/api/system/cars";
import {listFleet} from "@/api/system/fleet";
import OrderItem from "@/components/OrderItem.vue";
import {mapGetters} from "vuex";

export default {
  name: "OrderForm",
  components: {OrderItem},
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
    }
  },
  //计算属性 目的是为了避免无法输入修改父组件
  computed: {
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
  //监视属性 用来测试
  watch: {
    customer: {
      handler(val) {
      },
    },
  },

  methods: {
    //这个方法用来修改父组件的某一个属性
    handleUpdateOrderInfo(newOrderValue) {
      this.$emit('updateOrderInfo', newOrderValue)
    },
    //客户供应商信息
    searchCustomerInfo() {
      this.customerInfoDialogVisible = true
      listCompany({relationName: this.customerName}).then(res => {
        this.companyInfo = res.rows;
      })
    },
    //陆运车牌信息
    searchLandInfo() {
      this.landInfoDialogVisible = true
      listCars({carType: '陆运'}).then(res => {
        this.landInfo = res.rows;
      })
    },
    //车队信息
    searchFleetInfo() {
      this.fleetInfoDialogVisible = true
      listFleet({fName: this.fleetName}).then(res => {
        this.fleetInfo = res.rows;
      })
    },
    //海运信息 查询carType为海运的车辆信息
    searchSeaInfo() {
      this.seaInfoDialogVisible = true
      //查询海运车牌信息
      listCars({carType: '海运'}).then(res => {
        this.seaInfo = res.rows;
      })
    },

    //todo 确认中初始化所有的id 给出银行信息
    //客户信息中的搜索确认
    commitCustomerInfo(row) {
      this.orderInfo.customerID = row.id;  //orderInfo->客户ID
      //填充客户和销售经理信息 这里有改动 直接改计算属性 计算属性会更改父组件属性
      this.customer = row.relationName;
      this.saleManager = row.salesManager;
      this.customerInfoDialogVisible = false
    },
    //查询车牌信息的确认
    commitCarsInfo(row) {
      this.orderInfo.landCarID = row.id;   //orderInfo->陆运车ID
      //与上面填充客户信息同理
      this.landCarNo = row.carNo;
      this.landDriverName = row.driver;
      this.landDriverTel = row.tel;
      //填充银行信息
      this.orderInfo.landBankName = row.acountsName;
      this.orderInfo.landBankNo = row.bankNo;
      this.landBankName = row.bankName;
      this.landBankNo = row.bankNo
      this.landInfoDialogVisible = false;
    },
    //车队信息的确认
    commitFleetInfo(row) {
      this.fleet = row.fName;
      this.fleetInfoDialogVisible = false;
    },
    //海运信息的确认
    commitSeaInfo(row) {
      console.log(row)
      this.orderInfo.seaCarID = row.id;   //orderInfo->陆运车ID
      //与上面填充客户信息同理
      this.seaCarNo = row.carNo;
      this.seaDriverName = row.driver;
      this.seaDriverTel = row.tel;
      //填充银行信息
      this.orderInfo.seaBankName = row.acountsName;
      this.orderInfo.seaBankNo = row.bankNo;
      this.seaBankName = row.bankName;
      this.seaBankNo = row.bankNo
      this.seaInfoDialogVisible = false
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
  },
  created() {

  },
}
</script>

<template>
  <div>
    <!--    订单上面-->
    <div class="order-header">
      <div class="header-item">
        <span style="font-weight: bolder">日期:</span>
        <el-date-picker
          v-model="orderDate"
          type="date"
          placeholder="选择日期"
          value-format="yyyy-MM-dd"
          style="width: 70%">
        </el-date-picker>
      </div>
      <div class="header-item">
        <span style="font-weight: bolder">客户:</span>
        <el-input type="text" v-model="customer" style="width: 50%"
                  placeholder="请输入客户名称"></el-input>
        <!--        查询客户列表-->
        <el-button type="primary" size="mini" icon="el-icon-search" @click="searchCustomerInfo"></el-button>
      </div>
      <div class="header-item">
        <span style="font-weight: bolder">销售经理:</span>
        <el-input type="text" v-model="saleManager" style="width: 60%"
                  placeholder="请输入销售经理名称"></el-input>
      </div>
      <div class="header-item">
        <span style="font-weight: bolder">备注:</span>
        <el-input type="text" v-model="comments" style="width: 60%"
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
        <div style="font-weight: bolder;margin-bottom: 10px">陆运信息</div>
        <div style="display: flex;">
          <div>
            <span class="text-bold">陆运车牌</span>
            <el-input type="text" v-model="landCarNo" style="width: 50%"
                      placeholder="请输入陆运车牌"></el-input>
            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchLandInfo"></el-button>
          </div>
          <div>
            <span class="text-bold">陆运司机姓名</span>
            <el-input type="text" v-model="landDriverName" style="width: 60%"
                      placeholder="请输入陆运司机姓名"></el-input>
          </div>
          <div>
            <span class="text-bold">陆运司机电话</span>
            <el-input type="text" v-model="landDriverTel" style="width: 60%"
                      placeholder="请输入陆运司机电话"></el-input>
          </div>
          <div>
            <span class="text-bold">车队</span>
            <el-input type="text" v-model="fleet" style="width: 50%" placeholder="请输入车队"></el-input>
            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchFleetInfo"></el-button>
          </div>
        </div>
      </div>

      <!--      海运-->
      <div style="margin:10px 0;" v-if="isSea || orderInfo.seaFreight > 0">
        <div style="font-weight: bolder;margin-bottom: 10px">海运信息</div>
        <div style="display: flex;">
          <div>
            <span class="text-bold">海运车牌</span>
            <el-input type="text" v-model="seaCarNo" style="width: 50%" placeholder="请输入车牌"></el-input>
            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchSeaInfo"></el-button>
          </div>
          <div>
            <span class="text-bold">海运司机姓名</span>
            <el-input type="text" v-model="seaDriverName" style="width: 60%"
                      placeholder="请输入司机姓名"></el-input>
          </div>
          <div>
            <span class="text-bold">海运司机电话</span>
            <el-input type="text" v-model="seaDriverTel" style="width: 60%"
                      placeholder="请输入司机电话"></el-input>
          </div>
        </div>
      </div>
    </div>
    <br/>
    <!--    订单主体-->
    <div v-if="orderItemList.length!==0">
      <!--      从vuex中拿到订单详细列表-->
      <div v-for="(item,index) in orderItemList" :key="index">
        <!--        订单个体 传递给子组件订单详情个体   -->
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
    <div v-else>
      <el-row>
        <el-col>
          <el-button type="primary" @click="addOrderItem" icon="el-icon-plus">添加订单详情信息</el-button>
        </el-col>
      </el-row>
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

      <!--      客户信息-->
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
  width: 30%;
  margin-top: 10px;
}


</style>
