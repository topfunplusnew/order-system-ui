<script>
import {numToChineseUppercase} from "../../../../api/tool/format";
import {listOrderDetailByOrderNos} from "@/api/system/orderDetail";
import { parseTime } from "../../../../utils/ruoyi";
import {getCustomerSubjectDetailSomeDay} from "@/api/system/statement";
export default {
  name: "ChatForm3",
  props: {
    orderInfo: {
      type: Object,
      default: function () {
        
      }
    },
  },
  data() {
    return {
      currentOrderInfo: this.orderInfo,
      itemList: [],
      moneyAmount: null,
    }
  },
  computed: {
    // 合计欠款
    totalPayments() {
      return Number(this.orderInfo.allPayments) + Number(this.moneyAmount)
    }
  },
  created() {
    // 查询该订单的货物
    let orderNos = this.currentOrderInfo?.smailOrderDetails.map(item => {
      return item.ordersNo
    })
    // 根据ordersNo 批量查询订单货物
    listOrderDetailByOrderNos(orderNos).then(res => {
      this.itemList = res.rows
    })
    // 查询客户余额 指定时间结转 日期为当前时间
    const query = {
      beginTime: parseTime(new Date()),
      companyId: this.currentOrderInfo.customerID
    }
    // 查询客户余额
    getCustomerSubjectDetailSomeDay(query).then(res => {
      this.moneyAmount = res.data.moneyAmount
    })
  },
  mounted() {
    console.log(this.currentOrderInfo)
  },
  methods: {
    numToChineseUppercase,
    printHTML() {
      this.$print({
        printable: 'printBoxs',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
  }
}
</script>

<template>
  <div>
    <el-row>
      <el-button @click="printHTML">
        打印
      </el-button>
    </el-row>
    <div id="printBoxs" class="invoice-container">
      <div class="invoice-title">
        发货单
      </div>

      <div class="invoice-header">
        <div>客户：{{ orderInfo.customer }}</div>
        <div>日期：{{ orderInfo.orderDate }}</div>
        <div>车号：{{ orderInfo.landCarNo }}</div>
        <div>单据编号：{{ orderInfo.ordersNo }}</div>
      </div>

      <table>
        <thead>
          <tr>
            <th>商品名称</th>
            <th>片数</th>
            <th>包数</th>
            <th>单价</th>
            <th>发票</th>
            <th>费用</th>
            <th>金额</th>
          </tr>
        </thead>
        <tbody>
          <template v-if="orderInfo.smailOrderDetails.length > 0">
            <tr v-for="item in itemList" :key="item.ordersNo">
              <td>{{ item.levelName }} - {{ item.height }} x {{ item.length }} x {{ item.width }}</td>
              <td>{{ item.pieces }}</td>
              <td>{{ item.packs }}</td>
              <td>{{ item.price }}</td>
              <td>{{ item.isIncludeTaxFactory === 0 ? '否' : '是' }}</td>
              <td>{{ item.otherCost }}</td>
              <td>{{ item.payments }}</td>
            </tr>
          </template>
          <tr>
            <td style="text-align: left;">
              本次货款
            </td>
            <td colspan="5" style="text-align: left;">
              大写:{{ numToChineseUppercase(orderInfo.allPayments) }}
            </td>
            <td>{{ orderInfo.allPayments || 0 }}</td>
          </tr>
          <tr>
            <td style="text-align: left;">
              欠款
            </td>
            <td colspan="5" style="text-align: left;">
              大写:{{ numToChineseUppercase(moneyAmount || 0) }}
            </td>
            <td>{{ moneyAmount || 0 }}</td>
          </tr>
          <tr>
            <td style="text-align: left;">
              合计欠款
            </td>
            <td colspan="5" style="text-align: left;">
              大写:{{ numToChineseUppercase(totalPayments) }}
            </td>
            <td>{{ totalPayments || 0 }}</td>
          </tr>
          <tr>
            <td colspan="7" style="text-align: left">
              <p>注：</p>
              <p>1. 玻璃为易碎品，请当面验货，出现问题由司当面解决，收货后出现一切质量问题，由客户自负，我公司概不负责。</p>
              <p>2. 此单据等同合同，客户收货后具有法律效力，若发生经济纠纷，由供货方所在地法庭处理。</p>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped lang="scss">
.invoice-container {
  width: 950px;
  margin: 0 auto;
  padding: 20px;
  background: #fff;
}

.invoice-title {
  text-align: center;
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 10px;
}

.invoice-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
  font-size: 14px;
}

.invoice-header div {
  margin-right: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 10px;
}


table, th, td {
  border: 1px solid #000;

  p {
    padding: 2px;
  }
}

th, td {
  text-align: center;
  padding: 4px;
  font-size: 14px;
}

</style>
