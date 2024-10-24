<!--发货单组件-->
<script>
import {numToChineseUppercase} from "@/api/tool/format";

export default {
  name: "chatForm",
  props: {
    customer: String,
    date: String,
    vehicle: String,
    orderNumber: String,

    //商品名称
    goodsName: String,
    //片数
    pieces: Number,
    //包数
    packs: Number,
    //单价
    price: Number,
    //是否开发票
    isOpenTitle: Boolean,
    //费用
    sundryCost: Number,
    //金额
    payments: Number
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
    <el-button @click="printHTML">打印</el-button>
    <div id="printBoxs">
      <div class="header">
        <h3>发货单</h3>
      </div>

      <table>
        <tr>
          <td>客户：{{ customer }}</td>
          <td>日期：{{ date }}</td>
          <td>车号：{{ vehicle }}</td>
          <td>单据编号：{{ orderNumber }}</td>
        </tr>
      </table>

      <table>
        <tr>
          <th>商品名称</th>
          <th>片数</th>
          <th>包数</th>
          <th>单价</th>
          <th>发票</th>
          <th>费用</th>
          <th>金额</th>
        </tr>
        <tr>
          <td>安强lowe1405*3660*2440</td>
          <td>测试数据</td>
          <td>测试数据</td>
          <td>测试数据</td>
          <td>否</td>
          <td>测试数据</td>
          <td class="amount">测试数据</td>
        </tr>
      </table>

      <table>
        <tr>
          <td>本次欠款</td>
          <td>大写：{{ numToChineseUppercase(71465) }}</td>
          <td class="amount">测试数据</td>
        </tr>
        <tr>
          <td>欠款</td>
          <td>大写：{{ numToChineseUppercase(22) }}</td>
          <td class="amount">测试数据</td>
        </tr>
        <tr>
          <td>合计欠款</td>
          <td>大写：柒万壹仟肆佰陆拾伍元整</td>
          <td class="amount">测试数据</td>
        </tr>
      </table>

      <table class="note">
        <tr>
          <td colspan="2">注：</td>
        </tr>
        <tr>
          <td>1.玻璃为易碎品，请当面验货，出现问题由司机当面解决，收货后出现一切质量问题，由客户自行负责，我公司概不负责。
          </td>
        </tr>
        <tr>
          <td>2.此单据寄向白合同，客户收货后有本样式单，若发生经济纠纷，由供货方所在法院处理。</td>
        </tr>
        <textarea style="width: 100%;resize: vertical">

      </textarea>
      </table>
    </div>
  </div>
</template>

<style scoped lang="scss">
body {
  font-family: Arial, sans-serif;
  margin: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  border: 1px solid black;
  padding: 8px;
  text-align: center;
}

.header {
  font-size: 24px;
  text-align: center;
  margin-bottom: 20px;
}

.footer {
  text-align: left;
  font-size: 12px;
}

.amount {
  font-weight: bold;
}

.note {
  margin-top: 20px;
  border: 1px solid black;
  padding: 8px;
  text-align: left;
}

.note td {
  border: 1px solid black;
}
</style>
