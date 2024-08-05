<script>
export default {
  name: "OrderForm",
  data() {
    return {
      //订单信息
      orderInfo: {}
    }
  },
  methods: {},
  created() {

  },
  mounted() {

  }
}
</script>

<template>
  <div>
    <!--    订单上面的搜索-->
    <div class="order-header">
      <div class="header-item">
        <span class="text-bold">日期</span>
        <el-date-picker
          v-model="orderInfo.date"
          type="date"
          placeholder="选择日期" style="width: 70%">
        </el-date-picker>
      </div>
      <div class="header-item">
        <span class="text-bold">客户</span>
        <el-input type="text" style="width: 50%" placeholder="请输入客户名称"></el-input>
        <el-button type="primary" size="mini"><i class="el-icon-search"></i></el-button>
      </div>
      <div class="header-item">
        <span class="text-bold">销售经理</span>
        <el-input type="text" style="width: 60%" placeholder="请输入销售经理名称"></el-input>
      </div>
      <div class="header-item">
        <span class="text-bold">车牌</span>
        <el-input type="text" style="width: 50%" placeholder="请输入车牌"></el-input>
        <el-button type="primary" size="mini"><i class="el-icon-search"></i></el-button>
      </div>
      <div class="header-item">
        <span class="text-bold">司机姓名</span>
        <el-input type="text" style="width: 60%" placeholder="请输入司机姓名"></el-input>
      </div>
      <div class="header-item">
        <span class="text-bold">司机电话</span>
        <el-input type="text" style="width: 60%" placeholder="请输入司机电话"></el-input>
      </div>
      <div class="header-item">
        <span class="text-bold">车队</span>
        <el-input type="text" style="width: 50%" placeholder="请输入车队"></el-input>
        <el-button type="primary" size="mini"><i class="el-icon-search"></i></el-button>
      </div>
    </div>

    <!--    订单主体-->
    <div class="order font-size-12">
      <div class="order-item">
        <span class="text-bold">供应商/仓库</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
        <el-button size="mini" type="primary" icon="el-icon-user" circle>
        </el-button>
        <el-button size="mini" icon="el-icon-s-home" circle>
        </el-button>
      </div>
      <div class="order-item">
        <span class="text-bold">产品级别</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
        <el-button type="primary" size="mini" icon="el-icon-search" circle></el-button>
      </div>
      <div class="order-item">
        <span class="text-bold">计量单位</span>
        <hr/>
        <el-radio v-model="orderInfo.countingUnit" label="片数">片数</el-radio>
        <el-radio v-model="orderInfo.countingUnit" label="其他">其他</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">厚度</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">长度</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">宽度</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">每包片数</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">包数</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂片数</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂单价</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">是否含税</span>
        <hr/>
        <el-radio v-model="orderInfo.countingUnit" label="是">是</el-radio>
        <el-radio v-model="orderInfo.countingUnit" label="否">否</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">杂费</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂货款</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">卸货片数</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">卸货价</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">是否含税</span>
        <hr/>
        <el-radio v-model="orderInfo.countingUnit" label="是">是</el-radio>
        <el-radio v-model="orderInfo.countingUnit" label="否">否</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">杂费</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">总货款</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">误差</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">吨位</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">运费单价</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">加费</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">运费</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">其他费用</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">利润</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">不含税利润</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">备注</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">返利金额</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">降价金额</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">物流利润</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">客户佣金</span>
        <hr/>
        <el-input type="text" placeholder="info"></el-input>
      </div>
      <div class="option">
        <el-button type="primary">提交</el-button>
        <el-button>重置</el-button>
      </div>
    </div>
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
  flex-wrap: nowrap;
  border: 1px solid #dddddd;
}

.header-item {
  width: 30%;
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
  flex: 0 0 70px;
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
