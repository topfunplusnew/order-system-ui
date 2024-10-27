<!--订单表组件-->

<script>
import OrderItem from "@/views/dashboard/components/goodsOrder/OrderItem.vue";
import SearchOption from "../../../../components/SearchOption.vue";
import {listCompany} from "../../../../api/system/company";
import {listBankAccount} from "../../../../api/system/bankAccount";
import {listCars} from "../../../../api/system/cars";
import {listFleet} from "../../../../api/system/fleet";
import {parseTime} from "../../../../utils/ruoyi";
import {addGoodsOrder, getGoodsOrder, updateGoodsOrder} from "../../../../api/system/goodsOrder";
import {excludeParams} from "../../../../api/tool/exclude";
import {mapGetters} from "vuex";
import {mixin_form_fillInfo} from "@/views/dashboard/mixins/order/form/form_fillInfo";

export default {
  name: "OrderForm",
  components: {SearchOption, OrderItem},
  props: {
    // 父组件传递的订单id，主要用于当修改订单信息时 抓取服务器数据 然后自动填充到表单中
    orderId: '',
    // 确认按钮字样
    submitInfo: '',
  },
  mixins: [mixin_form_fillInfo],
  data() {
    return {
      // 单个订单基本信息 由此组件维护 而订单中的货物的信息 由vuex中的订单货物列表orderItemList维护
      orderInfo: {},
      //海运还是陆运
      isLand: false,
      isSea: false,
      orderNums: 0,
    }
  },
  computed: {
    // 拿到vuex中维护的订单列表
    ...mapGetters(['orderItemList'])
  },
  watch: {
    // 监听父组件传递过来的订单id的变化
    'orderId': {
      handler(val) {
        // 刷新订单表单的数据是无论如何都要执行的 所以先执行
        this.resetOrderInfo();
        this.orderId && this.getGoodsOrderInfo(val);
      },
      immediate: true
    },
    // 监听海运和陆运 如果不选 那么就要清空海运和陆运的相关信息
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
    // 组件初始化的时候清空状态
    this.resetOrderInfo()
    // 只有传递的订单id合法才会去抓取数据 当主动添加订单的时候订单id是空 不会执行
    this.orderId && this.getGoodsOrderInfo(this.orderId);
  },
  methods: {
    listFleet,
    listCars,
    listBankAccount,
    listCompany,
    // 获取订单信息的方法 这个方法会根据父组件传递过来的id (props.orderId)的变化 来查询对应的订单信息
    getGoodsOrderInfo(id) {
      getGoodsOrder(id).then(response => {
        // 拿到服务器给的订单数据
        this.orderInfo = response.data;
        // 如果海运费或者陆运费大于0
        this.isLand = response.data.landFreight > 0;
        this.isSea = response.data.seaFreight > 0;
        //将数据库拿到的订单列表装入vuex 这里维护的主要是索引，因为索引可以确定某个货物的状态
        const list = response.data.orderDetailList.map((item, index) => ({
          ...item,
          orderIndex: index
        }));
        // 将数据装入vuex维护的订单列表中
        this.$store.dispatch("order/setOrderItemListAsync", list)
        // orderNums 是当前已经装填到vuex中的货物数量
        this.orderNums = response.data.orderDetailList.length;
        // 填充订单货物列表中的信息
        const formatTax = value => (value === '是' ? '1' : '0'); // 可以将1和0转换为是和否
        // 遍历 填充属性
        this.orderInfo.orderDetailList.forEach(item => {
          Object.assign(item, {
            customerID: this.orderInfo.customerID,
            customer: this.orderInfo.customer,
            isIncludeTaxFactory: formatTax(item.isIncludeTaxFactory),
            isIncludeTaxSale: formatTax(item.isIncludeTaxSale)
          });
        });

      });
    },
    // 点击添加货物
    addOrderItem() {
      // 需要添加的货物的信息 后续可能会加入更多
      const temp = {
        orderIndex: this.orderNums
      }
      console.log('每个订单货物都会添加如下信息>', temp)
      this.$store.commit('order/addsOrderItem', temp)
      this.orderNums++;
    },
    //删除订单详情
    handleDeleteOrderDetail(index, event) {
      // 删除orderItemList中索引为index的元素
      this.$store.commit('order/removeOrderItem', index)
      this.orderNums--;
    },
    //提交订单
    //订单列表的对象封装一个，订单详情有两个一样的对象 对应供应商发货和仓库发货
    submitOrder() {
      if (!this.orderId) {
        //从vuex拿到订单详细列表 加入到订单信息中
        this.orderInfo.orderDetailList = this.orderItemList;
        // 对每一个订单添加客户信息和时间
        const updateOrderItem = (item) => {
          item.customerID = this.orderInfo.customerID;
          item.customer = this.orderInfo.customer;
          item.orderDate = parseTime(new Date(), '{y}-{m}-{d}');
        }
        // 对订单货物列表的每一个货物都执行这个操作
        this.orderItemList.forEach(item => updateOrderItem(item));
        // 添加订单信息
        addGoodsOrder({...this.orderInfo, PaymentState: ''}).then(res => {
          this.$message.success('订单提交成功')
          // 清空订单列表基础信息
          this.resetOrderInfo()
          // 清除状态
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
        const formatOrderItem = item => ({
          customerID: this.orderInfo.customerID,
          customer: this.orderInfo.customer,
          isIncludeTaxFactory: item.isIncludeTaxFactory === '是' ? '1' : '0',
          isIncludeTaxSale: item.isIncludeTaxSale === '是' ? '1' : '0',
          orderDate: parseTime(new Date(), '{y}-{m}-{d}')
        });
        // 对每一个货物都添加
        this.orderItemList.forEach(item => Object.assign(item, formatOrderItem(item)));
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
    // 取消添加订单
    cancelSubmit() {
      this.orderNums = 0
      this.isSea = false
      this.isLand = false
      this.$store.commit('order/clearOrderItemList'); // 清空订单详情填写信息
      this.resetOrderInfo() // 清空订单列表基础信息
      this.$emit('close-dialog'); // 关闭弹窗

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
        fleet: '',
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
                    <el-table-column label="开户行" align="center" prop="bankName"/>
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
          <!--          todo 车牌修改为柜号 且自己输入 不提供自动填充 -->
          <el-form-item label="柜号">
            <el-row>
              <el-col :span="20">
                <el-input type="text" v-model="orderInfo.seaCarNo" size="mini"
                          placeholder="请输入柜号" style="width: 120px"></el-input>
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
          <!--          todo 原为海运司机 现改为海运公司-->
          <el-form-item label="海运公司">
            <el-input type="text" v-model="orderInfo.seaDriverName" size="mini"
                      placeholder="请输入海运公司" style="width: 130px"></el-input>
          </el-form-item>
          <el-form-item label="电话">
            <el-input type="text" v-model="orderInfo.seaDriverTel" size="mini"
                      placeholder="请输入电话" style="width: 120px"></el-input>
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
      <!--      如果有订单信息  orderItemList是存储的货物列表 -->
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
        <el-col style="text-align: center">
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
