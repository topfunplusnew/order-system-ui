<script>
import {numToChineseUppercase} from "../../../../api/tool/format";

export default {
  name: "ChatForm3",
  props: {
    orderInfo: {},
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
      <el-button @click="printHTML">打印</el-button>
    </el-row>
    <div class="invoice-container" id="printBoxs">
      <div class="invoice-title">发货单</div>

      <div class="invoice-header">
        <div>客户：张柳芳**存</div>
        <div>日期：2024-07-10</div>
        <div>车号：0144</div>
        <div>单据编号：20241121024420</div>
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
        <tr>
          <td>安强lowe1405*3660*2440</td>
          <td>40</td>
          <td>2</td>
          <td>200</td>
          <td>否</td>
          <td>22</td>
          <td>71465</td>
        </tr>
        <tr>
          <td style="text-align: left;">本次货款</td>
          <td colspan="5" style="text-align: left;">大写:{{ numToChineseUppercase(123) }}</td>
          <td>71465</td>
        </tr>
        <tr>
          <td style="text-align: left;">欠款</td>
          <td colspan="5" style="text-align: left;">大写:{{ numToChineseUppercase(123) }}</td>
          <td>-0</td>
        </tr>
        <tr>
          <td style="text-align: left;">合计欠款</td>
          <td colspan="5" style="text-align: left;">大写:{{ numToChineseUppercase(123) }}</td>
          <td>71465</td>
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
  width: 800px;
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
