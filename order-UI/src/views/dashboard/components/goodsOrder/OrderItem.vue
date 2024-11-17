<!--订单详情个体-->

<script>
import SearchOption from "../../../../components/SearchOption.vue";
import {listCompany} from "../../../../api/system/company";
import {listInventory} from "../../../../api/system/inventory";
import {listProductLevel} from "../../../../api/system/productLevel";
import {mixin_item_addItem} from "../../mixins/order/items/item_addItem";
import {mixin_item_compute} from "../../mixins/order/items/item_compute";

export default {
  name: "OrderItem",
  components: {SearchOption},
  mixins: [mixin_item_addItem, mixin_item_compute],
  //父组件传递的订单详情个体
  props: {
    tempOrderInfo: {},
    isSea: Boolean,
    isLand: Boolean,
    index: Number,
    version: 0,
  },
  data() {
    return {
      disabled: false,
      loading: false,
      buttonText: null
    }
  },
  created() {
    this.buttonText = '提交货物'
    this.resetOrderItemInfo();
  },
  watch: {
    'tempOrderInfo': {
      handler(val) {
        console.log('watch:tempOrderInfo:', val)
        this.$nextTick(() => {
          Object.assign(this.orderItemInfo, val)
        })
      },
      deep: true,
      immediate: true // 立即执行一次
    },
    'index': {
      handler(val) {
        console.log('watch:index:', val)
      }
    },
    // 陆运费和海运费 如果传入的是false那么就是不要钱
    isSea: {
      handler(val) {
        if (val === false) {
          this.orderItemInfo.seaFreight = 0;
        }
      }
    },
    isLand: {
      handler(val) {
        if (val === false) {
          this.orderItemInfo.landFreight = 0;
        }
      }
    },
  },
  methods: {
    listProductLevel,
    listInventory,
    listCompany,
    // 筛选无剩余片数的库存
    filterNoStockNumber(data) {
      return new Promise((resolve, reject) => {
        resolve(data.filter(item => item.stockNumber > 0))
      })
    },
  }
}
</script>

<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span style="font-weight: bold;color: #1ab394">货物信息({{ index + 1 }})</span>
        <slot name="action"/>
      </div>
      <div class="order font-size-12">
        <div class="order-item">
          <span class="text-bold">供应商/仓库</span>
          <hr/>
          <el-input placeholder="请输入供应商/仓库"
                    v-model="orderItemInfo.supplier===undefined||orderItemInfo.supplier===null?orderItemInfo.storeName:orderItemInfo.supplier"
                    disabled></el-input>
          <el-row>
            <el-col :span="12">
              <!--              供应商的查找-->
              <SearchOption :get-data="listCompany" icon="el-icon-user" @commitBack="handleCommitBackCompany"
                            :limit-info="{companyType:'供应商'}">
                <template #table-columns>
                  <el-table-column label="供应商名称" align="center" prop="companyName"/>
                  <el-table-column label="联系人" align="center" prop="relationName"/>
                  <el-table-column label="电话" align="center" prop="relationTel"/>
                </template>
              </SearchOption>
            </el-col>
            <el-col :span="12">
              <!--              仓库的查找  -->
              <SearchOption :get-data="listInventory" icon="el-icon-s-home" @commitBack="handleCommitBackInventory"
                            :limit-info="{}" :additional-limit-info="(tableData)=>filterNoStockNumber(tableData)">
                <template v-slot:table-columns="{ tableData }">
                  <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
                  <el-table-column label="入库日期" align="center" prop="storeDate"/>
                  <el-table-column label="库存量" align="center" prop="stockNumber">
                    <template #default="scope">
                      {{ scope.row.stockNumber }}
                    </template>
                  </el-table-column>
                  <el-table-column label="供应商" align="center" prop="supplier"/>
                  <el-table-column label="级别编码" align="center" prop="levelID"/>
                  <el-table-column label="级别名称" align="center" prop="levelName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </div>
        <div class="order-item">
          <span class="text-bold">产品级别</span>
          <hr/>
          <el-input type="text" placeholder="请输入产品级别" v-model="orderItemInfo.levelName"></el-input>
          <SearchOption :get-data="listProductLevel" icon="el-icon-search" @commitBack="handleCommitBackProductLevel"
                        :limit-info="{}">
            <template #table-columns>
              <el-table-column label="级别编码" align="center" prop="levelNo"/>
              <el-table-column label="级别名称" align="center" prop="levelName"/>
              <el-table-column label="分类编号" align="center" prop="categoryNo"/>
              <el-table-column label="分类名称" align="center" prop="categoryName"/>
              <el-table-column label="厚度" align="center" prop="height"/>
              <el-table-column label="长度" align="center" prop="length"/>
              <el-table-column label="宽度" align="center" prop="width"/>
              <el-table-column label="吨位" align="center" prop="tonnage"/>
            </template>
          </SearchOption>
        </div>
        <div class="order-item" v-if="orderItemInfo.storeName">
          <span class="text-bold">出库日期</span>
          <hr/>
          <el-date-picker
            v-model="orderItemInfo.exWarehouseDate"
            type="datetime"
            placeholder="选择日期"
            value-format="timestamp">
          </el-date-picker>
        </div>
        <div class="order-item">
          <span class="text-bold">计量单位</span>
          <hr/>
          <el-radio v-model="orderItemInfo.countingUnit" label="片">片数</el-radio>
          <el-radio v-model="orderItemInfo.countingUnit" label="其他">其他</el-radio>
        </div>
        <div class="order-item">
          <span class="text-bold">厚度</span>
          <hr/>
          <el-input type="text" placeholder="请输入厚度" v-model="orderItemInfo.height"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">长度</span>
          <hr/>
          <el-input type="text" placeholder="请输入长度" v-model="orderItemInfo.length"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">宽度</span>
          <hr/>
          <el-input type="text" placeholder="请输入宽度" v-model="orderItemInfo.width"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">每包片数</span>
          <hr/>
          <el-input type="text" placeholder="请输入每包片数"
                    v-model="orderItemInfo.piecesPerPack"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">包数</span>
          <hr/>
          <el-input type="text" placeholder="请输入包数" v-model="orderItemInfo.packs"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂片数</span>
          <hr/>
          <el-input type="text" placeholder="请输入出厂片数" v-model="orderItemInfo.pieces"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂单价</span>
          <hr/>
          <el-input type="text" placeholder="请输入出厂单价" v-model="orderItemInfo.price"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂是否含税</span>
          <hr/>
          <el-radio v-model="orderItemInfo.isIncludeTaxFactory" label="1">是</el-radio>
          <el-radio v-model="orderItemInfo.isIncludeTaxFactory" label="0">否</el-radio>
        </div>
        <div class="order-item">
          <span class="text-bold">杂费</span>
          <hr/>
          <el-input type="text" placeholder="请输入杂费" v-model="orderItemInfo.sundryCost"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂货款</span>
          <hr/>
          <el-input type="text" placeholder="请输入出厂贷款"
                    v-model="orderItemInfo.paymentFactory"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">卸货片数</span>
          <hr/>
          <el-input type="text" placeholder="请输入卸货片数" v-model="orderItemInfo.outPieces"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">卸货价</span>
          <hr/>
          <el-input type="text" placeholder="请输入卸货价" v-model="orderItemInfo.paymentUnload"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">销售是否含税</span>
          <hr/>
          <el-radio v-model="orderItemInfo.isIncludeTaxSale" label="1">是</el-radio>
          <el-radio v-model="orderItemInfo.isIncludeTaxSale" label="0">否</el-radio>
        </div>
        <div class="order-item">
          <span class="text-bold">总货款杂费</span>
          <hr/>
          <el-input type="text" placeholder="总货款杂费"
                    v-model="orderItemInfo.paymentsWithSundry"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">总货款</span>
          <hr/>
          <el-input type="text" placeholder="请输入总货款" v-model="orderItemInfo.payments"></el-input>
        </div>

        <div class="order-item">
          <span class="text-bold">误差</span>
          <hr/>
          <el-input type="text" placeholder="请输入误差" v-model="orderItemInfo.erro" disabled></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">吨位</span>
          <hr/>
          <el-input type="text" placeholder="请输入吨位" v-model="orderItemInfo.tonnage"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">陆运费单价</span>
          <hr/>
          <el-input type="text" placeholder="请输入陆运费单价"
                    v-model="orderItemInfo.landFreightPrice"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">加费</span>
          <hr/>
          <el-input type="text" placeholder="加费" v-model="orderItemInfo.additionalFees"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">陆运费</span>
          <hr/>
          <el-input type="text" placeholder="陆运费" v-model="orderItemInfo.landFreight"></el-input>
        </div>
        <div class="order-item" v-if="isSea">
          <span class="text-bold">海运费</span>
          <hr/>
          <el-input type="text" placeholder="海运费" v-model="orderItemInfo.seaFreight"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">总运费</span>
          <hr/>
          <el-input type="text" placeholder="总运费" v-model="orderItemInfo.freight"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">其他费用</span>
          <hr/>
          <el-input type="text" placeholder="其他费用" v-model="orderItemInfo.otherCost"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">利润</span>
          <hr/>
          <el-input type="text" placeholder="利润" v-model="orderItemInfo.profit"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">不含税利润</span>
          <hr/>
          <el-input type="text" placeholder="不含税利润" v-model="orderItemInfo.profitNoTax"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">实际片数</span>
          <hr/>
          <el-input type="text" placeholder="实际片数" v-model="orderItemInfo.actualPieces"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">备注</span>
          <hr/>
          <el-input type="text" placeholder="备注" v-model="orderItemInfo.comments"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">物流利润</span>
          <hr/>
          <el-input type="text" placeholder="物流利润" v-model="orderItemInfo.logisticsProfit"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">客户佣金</span>
          <hr/>
          <el-input type="text" placeholder="客户佣金"
                    v-model="orderItemInfo.customerCommission"></el-input>
        </div>
      </div>
      <el-row>
        <el-col :span="6" :offset="11">
          <el-button type="success" @click="addOrderItem" icon="el-icon-plus" size="mini" :disabled="disabled"
                     :loading="loading">{{ buttonText }}
          </el-button>
        </el-col>
      </el-row>
    </el-card>
    <br/>
  </div>
</template>

<style scoped lang="scss">
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
