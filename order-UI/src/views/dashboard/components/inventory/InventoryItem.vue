<!--订单详情个体-->

<script>
import {fix} from "@/api/tool/format";
import SearchOption from "../../../../components/SearchOption.vue";
import {listCompany} from "../../../../api/system/company";
import {listProductLevel} from "../../../../api/system/productLevel";
import {addInventory} from "../../../../api/system/inventory";

export default {
  name: "OrderItem",
  components: {SearchOption},

  //父组件传递的订单详情个体
  props: {
    inventoryInfo: {
      type: Object,
      required: true,
    },
    index: Number
  },
  data() {
    return {
      orderItemInfo: {},
      //公司(供应商)名称搜索
      querySupplier: '',
      //仓库名称搜索
      queryStore: '',
      //产品级别搜索
      productLevel: {
        //级别
        level: '',
        //宽度
        width: ''
      },
    }
  },
  // 思路  先通过计算属性，拿到属性，渲染到页面 因为计算属性是响应式的 在给计算属性赋值时 提醒父组件改变传递的item对象
  computed: {
    //销售是否含税和出厂是否含税的组合
    Tax: {
      set() {

      },
      get() {
        return this.isIncludeTaxFactory + this.isIncludeTaxSale;
      }
    },
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
      return fix((Number(this.orderItemInfo.height) - Number(this.orderItemInfo.erro)) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20);
    },
    landFreight00() {
      return fix(Number(this.orderItemInfo.tonnage) * Number(this.orderItemInfo.landFreightPrice) + Number(this.orderItemInfo.additionalFees));
    },
    profit00() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight);
    },
    profitNoTax00() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight - this.orderItemInfo.otherCost);
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
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight)
    },
    profitNoTax10() {
      return fix(this.orderItemInfo.payments - (this.orderItemInfo.paymentFactory / 1.075) - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight - this.orderItemInfo.otherCost)
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
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight)
    },
    profitNoTax01() {
      return fix((this.orderItemInfo.payments / 1.075) - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight - this.orderItemInfo.otherCost)
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
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight)
    },
    profitNoTax11() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - (this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight * 1.075)
        - (this.orderItemInfo.height * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 * 0.5) - this.orderItemInfo.otherCost)
    },
  },
  created() {
    this.resetInventory();
  },
  watch: {
    orderItemInfo: {
      handler() {
        //如果不是仓库发货
        //是否含税 厂家否 客户否
        if (this.Tax === '00') {
          this.orderItemInfo.erro = 0.8;
          this.orderItemInfo.paymentFactory = this.paymentFactory00;
          this.orderItemInfo.payments = this.payments00;
          this.orderItemInfo.tonnage = this.tonnage00
          this.orderItemInfo.landFreight = this.landFreight00
          this.orderItemInfo.profit = this.profit00
          this.orderItemInfo.profitNoTax = this.profitNoTax00
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
          this.orderItemInfo.freight = Number(this.orderItemInfo.landFreight);
        } else {
          this.orderItemInfo.freight = Number(this.orderItemInfo.landFreight) + Number(this.orderItemInfo.seaFreight);
        }
      },
      deep: true,
      immediate: true,
    },
    //出厂片数
    pieces: {
      handler(val) {
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
  },
  methods: {
    listProductLevel,
    listCompany,
    //供应商信息
    handleCommitBackCompany(val) {
      console.log(val)
      this.orderItemInfo.supplierId = val.id;   //goodsOrderList->供应商ID
      this.orderItemInfo.supplier = val.companyName
    },
    handleUpdateQueryName(val) {
      this.querySupplier = val;
    },
    //查询产品级别信息
    handleCommitBackProductLevel(val) {
      this.orderItemInfo.levelID = val.id;
      this.orderItemInfo.levelName = val.levelName;
      this.orderItemInfo.height = val.height;
      this.orderItemInfo.length = val.length;
      this.orderItemInfo.width = val.width;
      this.orderItemInfo.levelNo = val.levelNo;
    },
    handleUpdateQueryNameStore(val) {
      this.queryStore = val;
    },
    //添加入库
    submitInvoiceIn() {
      addInventory({...this.orderItemInfo, ...this.inventoryInfo}).then(res => {
        this.$message.success('入库成功')
        this.getList()
        this.$emit('close')
      })
    },
    close() {
      this.$emit('close')
    },
    resetInventory() {
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
    <div class="order font-size-12">
      <div class="order-item">
        <span class="text-bold">供应商</span>
        <hr/>
        <el-input placeholder="请输入供应商"
                  v-model="orderItemInfo.supplier"
                  disabled></el-input>
        <SearchOption :get-data="listCompany" icon="el-icon-user" @commitBack="handleCommitBackCompany"
                      :limit-info="{companyType:'供应商'}" @update:queryName="handleUpdateQueryName"
                      query-info="companyName" query-label="供应商名称" :query-name="querySupplier">
          <template #table-columns>
            <el-table-column label="供应商名称" align="center" prop="companyName"/>
            <el-table-column label="联系人" align="center" prop="relationName"/>
            <el-table-column label="电话" align="center" prop="relationTel"/>
          </template>
        </SearchOption>
      </div>
      <div class="order-item">
        <span class="text-bold">产品名称</span>
        <hr/>
        <el-input type="text" placeholder="请输入产品名称" v-model="orderItemInfo.levelName"></el-input>
        <SearchOption :get-data="listProductLevel" icon="el-icon-search" @commitBack="handleCommitBackProductLevel"
                      @update:queryName="handleUpdateQueryNameStore"
                      :limit-info="{}" query-info="levelName" query-label="产品级别名称" :query-name="queryStore">
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
        <span class="text-bold">库存量</span>
        <hr/>
        <el-input type="text" placeholder="请输入出厂片数" v-model="orderItemInfo.stockNumber"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">实际片数</span>
        <hr/>
        <el-input type="text" placeholder="请输入实际片数" v-model="orderItemInfo.actualPieces"></el-input>
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
        <span class="text-bold">备注</span>
        <hr/>
        <el-input type="text" placeholder="备注" v-model="orderItemInfo.comments"></el-input>
      </div>
    </div>
    <el-row style="text-align: center">
      <el-button type="primary" @click="submitInvoiceIn">添 加</el-button>
      <el-button @click="close">取 消</el-button>
    </el-row>
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
