<!--订单详情个体-->

<script>
import {fix} from "@/api/tool/format";
import SearchOption from "./SearchOption.vue";
import {listCompany} from "../api/system/company";
import {listInventory} from "../api/system/inventory";
import {listProductLevel} from "../api/system/productLevel";

export default {
  name: "OrderItem",
  components: {SearchOption},

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
      orderItemInfo: {},
      disabled: false,
      loading: false,
    }
  },
  created() {
    console.log('orderItem created')
    // 重置orderItemInfo中的所有属性
    this.resetOrderItemInfo();
  },
  computed: {
    //公式计算相关的计算属性
    //是否含税 厂家否 客户否
    paymentFactory00() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 * this.orderItemInfo.price + Number(this.orderItemInfo.sundryCost))
    },
    payments00() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces / 1000000 * this.orderItemInfo.paymentUnload + Number(this.orderItemInfo.paymentsWithSundry));
    },
    // todo  长度宽度高度过低 会计算吨位为0
    tonnage00() {
      return fix((Number(this.orderItemInfo.height) - Number(this.orderItemInfo.erro)) * this.orderItemInfo.length * this.orderItemInfo.pieces / 1000000 / 20 / 20);
    },
    landFreight00() {
      return fix(Number(this.orderItemInfo.tonnage) * Number(this.orderItemInfo.landFreightPrice) + Number(this.orderItemInfo.additionalFees));
    },
    profit00() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight);
    },
    profitNoTax00() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.otherCost);
    },
    //是否含税10
    paymentFactory10() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces * this.orderItemInfo.price / 1000000 + Number(this.orderItemInfo.sundryCost));
    },
    payments10() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces * this.orderItemInfo.paymentUnload / 1000000 + Number(this.orderItemInfo.paymentsWithSundry));
    },
    tonnage10() {
      return fix((this.orderItemInfo.height - this.orderItemInfo.erro) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20)
    },
    landFreight10() {
      return fix(this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice + Number(this.orderItemInfo.additionalFees))
    },
    profit10() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight)
    },
    profitNoTax10() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory / 1.075 - this.orderItemInfo.landFreight - this.orderItemInfo.otherCost)
    },
    //是否含税01
    paymentFactory01() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 * this.orderItemInfo.price + Number(this.orderItemInfo.sundryCost));
    },
    payments01() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces * this.orderItemInfo.paymentUnload / 1000000 + Number(this.orderItemInfo.paymentsWithSundry));
    },
    tonnage01() {
      return fix((this.orderItemInfo.height - this.orderItemInfo.erro) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20)
    },
    landFreight01() {
      return fix(Number(this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice) + Number(this.orderItemInfo.additionalFees))
    },
    profit01() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight)
    },
    profitNoTax01() {
      return fix((this.orderItemInfo.payments / 1.075) - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.otherCost)
    },
    //是否含税11
    paymentFactory11() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces * this.orderItemInfo.price / 1000000 + Number(this.orderItemInfo.sundryCost));
    },
    payments11() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces * this.orderItemInfo.paymentUnload / 1000000 + Number(this.orderItemInfo.paymentsWithSundry));
    },
    tonnage11() {
      return fix((this.orderItemInfo.height - this.orderItemInfo.erro) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20)
    },
    landFreight11() {
      return fix(this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice + Number(this.orderItemInfo.additionalFees))
    },
    profit11() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight)
    },
    profitNoTax11() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - (this.orderItemInfo.landFreight * 1.075) - (this.orderItemInfo.height * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 * 0.5))
    },
  },
  beforeDestroy() {
    this.resetOrderItemInfo()
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

    //监听的是整个对象
    'orderItemInfo': {
      handler() {
        //是否含税 厂家否 客户否
        if (this.Tax === '00') {
          //误差为0.8
          this.erro = 0.8;
          //出厂贷款
          this.orderItemInfo.paymentFactory = this.paymentFactory00;
          //总贷款
          this.orderItemInfo.payments = this.payments00;
          //吨位
          this.orderItemInfo.tonnage = this.tonnage00
          //运费
          this.orderItemInfo.landFreight = this.landFreight00
          //利润
          this.orderItemInfo.profit = this.profit00
          //不含税利润
          this.orderItemInfo.profitNoTax = this.profitNoTax00
          //出厂含税客户不含税
        } else if (this.Tax === '10') {
          //误差为0
          this.orderItemInfo.erro = 0;
          this.orderItemInfo.paymentFactory = this.paymentFactory10;
          this.orderItemInfo.payments = this.payments10
          this.orderItemInfo.tonnage = this.tonnage10
          this.orderItemInfo.landFreight = this.landFreight10
          this.orderItemInfo.profit = this.profit10
          this.orderItemInfo.profitNoTax = this.profitNoTax10
        } else if (this.Tax === '01') {
          //误差为0
          this.orderItemInfo.erro = 0;
          this.orderItemInfo.paymentFactory = this.paymentFactory01;
          this.orderItemInfo.payments = this.payments01
          this.orderItemInfo.tonnage = this.tonnage01
          this.orderItemInfo.landFreight = this.landFreight01
          this.orderItemInfo.profit = this.profit01
          this.orderItemInfo.profitNoTax = this.profitNoTax01
        } else {
          //误差为0
          this.orderItemInfo.erro = 0;
          this.orderItemInfo.paymentFactory = this.paymentFactory11;
          this.orderItemInfo.payments = this.payments11
          this.orderItemInfo.tonnage = this.tonnage11
          this.orderItemInfo.landFreight = this.landFreight11
          this.orderItemInfo.profit = this.profit11
          this.orderItemInfo.profitNoTax = this.profitNoTax11
        }
        //运费自动填充
        if (this.seaFreight === undefined) {
          this.freight = Number(this.orderItemInfo.landFreight);
        } else {
          this.freight = Number(this.orderItemInfo.landFreight) + Number(this.orderItemInfo.seaFreight);
        }
      },
      deep: true,
      immediate: true,
    },
    //出厂片数
    pieces: {
      handler(val) {
        //如果选择的是仓库发货
        if (this.orderItemInfo.supplierID === null) {
          if (val > this.currentStockNumber) {
            this.$message.error("出厂片数不能大于库存量!");
            this.orderItemInfo.pieces = this.currentStockNumber;
          } else {
            //修改片数自动计算
            if (this.Tax === '00') {
              this.orderItemInfo.paymentFactory = this.paymentFactory00;
              this.orderItemInfo.payments = this.payments00;
              this.orderItemInfo.tonnage = this.tonnage00
              this.orderItemInfo.landFreight = this.landFreight00
              this.orderItemInfo.profit = this.profit00
              this.orderItemInfo.profitNoTax = this.profitNoTax00
            } else if (this.Tax === '10') {
              this.orderItemInfo.paymentFactory = this.paymentFactory10;
              this.orderItemInfo.payments = this.payments10
              this.orderItemInfo.tonnage = this.tonnage10
              this.orderItemInfo.landFreight = this.landFreight10
              this.orderItemInfo.profit = this.profit10
              this.orderItemInfo.profitNoTax = this.profitNoTax10
            } else if (this.Tax === '01') {
              this.orderItemInfo.paymentFactory = this.paymentFactory01;
              this.orderItemInfo.payments = this.payments01
              this.orderItemInfo.tonnage = this.tonnage01
              this.orderItemInfo.landFreight = this.landFreight01
              this.orderItemInfo.profit = this.profit01
              this.orderItemInfo.profitNoTax = this.profitNoTax01
            } else {
              this.orderItemInfo.paymentFactory = this.paymentFactory11;
              this.orderItemInfo.payments = this.payments11
              this.orderItemInfo.tonnage = this.tonnage11
              this.orderItemInfo.landFreight = this.landFreight11
              this.orderItemInfo.profit = this.profit11
              this.orderItemInfo.profitNoTax = this.profitNoTax11
            }
          }
        }
      }
    },
  },
  methods: {
    listProductLevel,
    listInventory,
    listCompany,
    //添加订单vuex
    addOrderItem() {
      this.loading = true;
      this.$store.commit('order/changeOrderItemStatus', {...this.orderItemInfo, orderIndex: this.index})
      this.$message.success('添加货物成功')
      this.disabled = true;
      this.loading = false
    },
    // 供应商信息 从供应商发货
    handleCommitBackCompany(val) {
      this.resetOrderItemInfo()
      this.orderItemInfo.supplierID = val.id;   //goodsOrderList->供应商ID
      this.orderItemInfo.supplier = val.companyName
    },
    // 仓库信息 从仓库发货
    handleCommitBackInventory(val) {
      this.resetOrderItemInfo()
      this.orderItemInfo.storeID = val.id;  //goodsOrderList ->仓库ID
      this.orderItemInfo.storeHouseID = val.id //goodsOrderList ->库存ID
      if (this.orderItemInfo.supplier) {
        this.orderItemInfo.supplier = null;
      }
      this.orderItemInfo.storeName = val.storeHouseName
      this.orderItemInfo.length = val.length;
      this.orderItemInfo.width = val.width;
      this.orderItemInfo.levelID = val.levelID;
      //出厂片数让用户自己填
      this.orderItemInfo.pieces = val.stockNumber;
      this.currentStockNumber = val.stockNumber;//暂存
      if (this.currentStockNumber == 0) {
        this.$message.error("暂无库存，请先入库!");
        this.resetOrderItemInfo()
      }
      console.log('选择的仓库库存量为:', this.currentStockNumber)
    },
    // 产品级别自动填充
    handleCommitBackProductLevel(val) {
      this.orderItemInfo.levelID = val.id;
      this.orderItemInfo.levelName = val.levelName;
      this.orderItemInfo.height = val.height;
      this.orderItemInfo.length = val.length;
      this.orderItemInfo.width = val.width;
      this.orderItemInfo.levelNo = val.levelNo;
    },
    // 重置订单个体信息
    resetOrderItemInfo() {
      this.orderItemInfo = {
        orderDate: null,
        supplier: null,
        supplierID: null,
        customer: null,
        customerID: null,
        levelID: null,
        levelName: null,
        countingUnit: '片',
        height: null,
        length: null,
        width: null,
        pieces: null,
        piecesPerPack: 0,
        packs: 0,
        price: 0,
        isIncludeTaxFactory: '0',
        sundryCost: 0,
        paymentFactory: 0,
        paymentUnload: 0,
        isIncludeTaxSale: '0',
        payments: 0,
        erro: 0,
        tonnage: 0,
        landFreightPrice: 0,
        landFreight: 0,
        seaFreight: 0,
        freight: 0,
        otherCost: 0,
        profit: 0,
        profitNoTax: 0,
        actualPieces: 0,
        paymentsWithSundry: 0,
        additionalFees: 0,
        storeHouseID: null,
        storeHouseName: null,
        storeID: null,
        logisticsProfit: 0,
        customerCommission: null,
        isAdjusted: null,
        adjustDate: null,
        comments: null,
        addtime: null,
        userId: null,
        exWarehouseDate: null,
        outPieces: 0
      }
    }
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
              <SearchOption :get-data="listInventory" icon="el-icon-s-home" @commitBack="handleCommitBackInventory"
                            :limit-info="{}">
                <template #table-columns>
                  <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
                  <el-table-column label="入库日期" align="center" prop="storeDate"/>
                  <el-table-column label="库存量" align="center" prop="stockNumber">
                    <template #default="scope">
                      {{ scope.row.stockNumber > 0 ? scope.row.stockNumber : '无库存' }}
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
              type="date"
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
                     :loading="loading">添加货物
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
