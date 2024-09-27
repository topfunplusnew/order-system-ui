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
    orderItemInfo: {},
    isSea: Boolean,
    isLand: Boolean,
    index: Number
  },
  data() {
    return {
      //公司(供应商)名称搜索
      companyName: '',
      //仓库名称搜索
      storeName: '',
      //库存信息
      inventoryInfo: [],
      //产品级别信息
      productLevelInfo: [],
      supplierID: '',
      storeHouseID: '',
      storeID: '',
      //卸货片数
      outPieces: 0,
      //库存
      currentStockNumber: '',
    }
  },
  computed: {
    //厚度信息
    height: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, height: val})
      },
      get() {
        return this.orderItemInfo.height;
      }
    },
    //供应商和仓库信息
    supplier: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, supplier: val})
      },
      get() {
        return this.orderItemInfo.supplier;
      }
    },
    storeHouseName: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, storeHouseName: val})
      },
      get() {
        return this.orderItemInfo.storeHouseName;
      }
    },
    //levelName级别名称
    levelName: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, levelName: val})
      },
      get() {
        return this.orderItemInfo.levelName;
      }
    },
    //countingUnit计量单位
    countingUnit: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, countingUnit: val})
      },
      get() {
        return this.orderItemInfo.countingUnit;
      }
    },
    //length长度和宽度信息
    length: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, length: val})
      },
      get() {
        return this.orderItemInfo.length;
      }
    },
    width: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, width: val})
      },
      get() {
        return this.orderItemInfo.width;
      }
    },
    //包数 每包片数 出厂片数 出厂单价
    piecesPerPack: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, piecesPerPack: val})
      },
      get() {
        return this.orderItemInfo.piecesPerPack;
      }
    },
    //包数
    packs: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, packs: val})
      },
      get() {
        return this.orderItemInfo.packs;
      }
    },
    pieces: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, pieces: val})
      },
      get() {
        return this.orderItemInfo.pieces;
      }
    },
    price: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, price: val})
      },
      get() {
        return this.orderItemInfo.price;
      }
    },
    //出厂是否含税
    isIncludeTaxFactory: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, isIncludeTaxFactory: val})
      },
      get() {
        return this.orderItemInfo.isIncludeTaxFactory + '';
      }
    },
    sundryCost: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, sundryCost: val})
      },
      get() {
        return this.orderItemInfo.sundryCost;
      }
    },
    //出厂贷款 = 长度 * 宽度 * 出厂片数 / 1000000 * 出厂单价 + 杂费
    paymentFactory: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, paymentFactory: val})
      },
      get() {
        return this.orderItemInfo.paymentFactory;
      }
    },
    //卸货价
    paymentUnload: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, paymentUnload: val})
      },
      get() {
        return this.orderItemInfo.paymentUnload;
      }
    },

    //销售是否含税
    isIncludeTaxSale: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, isIncludeTaxSale: val});
      },
      get() {
        return this.orderItemInfo.isIncludeTaxSale + '';
      }
    },
    payments: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, payments: val});
      },
      get() {
        return this.orderItemInfo.payments;
      }
    },
    erro: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, erro: val});
      },
      get() {
        return this.orderItemInfo.erro;
      }
    },
    tonnage: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, tonnage: val});
      },
      get() {
        return this.orderItemInfo.tonnage;
      }
    },
    landFreightPrice: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, landFreightPrice: val});
      },
      get() {
        return this.orderItemInfo.landFreightPrice;
      }
    },
    landFreight: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, landFreight: val});
      },
      get() {
        return this.orderItemInfo.landFreight;
      }
    },
    seaFreight: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, seaFreight: val});
      },
      get() {
        return this.orderItemInfo.seaFreight;
      }
    },


    //总运费 逻辑是 没有海运费 就是陆运费 如果有则二者之和
    freight: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, freight: val});
      },
      get() {
        return this.orderItemInfo.freight;
      }
    },
    additionalFees: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, additionalFees: val});
      },
      get() {
        return this.orderItemInfo.additionalFees;
      }
    },
    otherCost: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, otherCost: val});
      },
      get() {
        return this.orderItemInfo.otherCost;
      }
    },
    profit: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, profit: val});
      },
      get() {
        return this.orderItemInfo.profit;
      }
    },
    profitNoTax: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, profitNoTax: val});
      },
      get() {
        return this.orderItemInfo.profitNoTax;
      }
    },
    actualPieces: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, actualPieces: val});
      },
      get() {
        return this.orderItemInfo.actualPieces;
      }
    },
    paymentsWithSundry: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, paymentsWithSundry: val});
      },
      get() {
        return this.orderItemInfo.paymentsWithSundry;
      }
    },
    customerCommission: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, customerCommission: val});
      },
      get() {
        return this.orderItemInfo.customerCommission;
      }
    },
    comments: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, comments: val});
      },
      get() {
        return this.orderItemInfo.comments;
      }
    },
    //级别编码levelNo
    levelID: {
      set(val) {
        this.$emit('changeOrderItemInfo', {...this.orderItemInfo, levelID: val});
      },
      get() {
        return this.orderItemInfo.levelID;
      }
    },
    //销售是否含税和出厂是否含税的组合
    Tax: {
      set() {

      },
      get() {
        return this.isIncludeTaxFactory + this.isIncludeTaxSale;
      }
    },
    //出库日期
    exWarehouseDate: {
      set(val) {
        if (val) {
          this.$emit('changeOrderItemInfo', {...this.orderItemInfo, exWarehouseDate: val});
        }
      },
      get() {
        return this.orderItemInfo.exWarehouseDate;
      }
    },

    //公式计算相关的计算属性
    //是否含税 厂家否 客户否
    paymentFactory00() {
      return fix(this.length * this.width * this.pieces / 1000000 * this.price + Number(this.sundryCost))
    },
    payments00() {
      return fix(this.length * this.width * this.outPieces / 1000000 * this.paymentUnload + Number(this.paymentsWithSundry));
    },
    // todo  长度宽度高度过低 会计算吨位为0
    tonnage00() {
      return fix((Number(this.height) - Number(this.erro)) * this.length * this.pieces / 1000000 / 20 / 20);
    },
    landFreight00() {
      return fix(Number(this.tonnage) * Number(this.landFreightPrice) + Number(this.additionalFees));
    },
    profit00() {
      return fix(this.payments - this.paymentFactory - this.landFreight);
    },
    profitNoTax00() {
      return fix(this.payments - this.paymentFactory - this.landFreight - this.otherCost);
    },
    //是否含税10
    paymentFactory10() {
      return fix(this.length * this.width * this.pieces * this.price / 1000000 + Number(this.sundryCost));
    },
    payments10() {
      return fix(this.length * this.width * this.outPieces * this.paymentUnload / 1000000 + Number(this.paymentsWithSundry));
    },
    tonnage10() {
      return fix((this.height - this.erro) * this.length * this.width * this.pieces / 1000000 / 20 / 20)
    },
    landFreight10() {
      return fix(this.tonnage * this.landFreightPrice + Number(this.additionalFees))
    },
    profit10() {
      return fix(this.payments - this.paymentFactory - this.landFreight)
    },
    profitNoTax10() {
      return fix(this.payments - this.paymentFactory / 1.075 - this.landFreight - this.otherCost)
    },
    //是否含税01
    paymentFactory01() {
      return fix(this.length * this.width * this.pieces / 1000000 * this.price + Number(this.sundryCost));
    },
    payments01() {
      return fix(this.length * this.width * this.outPieces * this.paymentUnload / 1000000 + Number(this.paymentsWithSundry));
    },
    tonnage01() {
      return fix((this.height - this.erro) * this.length * this.width * this.pieces / 1000000 / 20 / 20)
    },
    landFreight01() {
      console.log(this.tonnage, this.landFreightPrice, this.additionalFees)
      return fix(Number(this.tonnage * this.landFreightPrice) + Number(this.additionalFees))
    },
    profit01() {
      return fix(this.payments - this.paymentFactory - this.landFreight)
    },
    profitNoTax01() {
      return fix((this.payments / 1.075) - this.paymentFactory - this.landFreight - this.otherCost)
    },
    //是否含税11
    paymentFactory11() {
      return fix(this.length * this.width * this.pieces * this.price / 1000000 + Number(this.sundryCost));
    },
    payments11() {
      return fix(this.length * this.width * this.outPieces * this.paymentUnload / 1000000 + Number(this.paymentsWithSundry));
    },
    tonnage11() {
      return fix((this.height - this.erro) * this.length * this.width * this.pieces / 1000000 / 20 / 20)
    },
    landFreight11() {
      return fix(this.tonnage * this.landFreightPrice + Number(this.additionalFees))
    },
    profit11() {
      return fix(this.payments - this.paymentFactory - this.landFreight)
    },
    profitNoTax11() {
      return fix(this.payments - this.paymentFactory - (this.landFreight * 1.075) - (this.height * this.length * this.width * this.pieces / 1000000 / 20 * 0.5))
    },
  },
  watch: {
    // 陆运费和海运费 如果传入的是false那么就是不要钱
    isSea: {
      handler(val) {
        if (val === false) {
          this.seaFreight = 0;
        }
      }
    },
    isLand: {
      handler(val) {
        if (val === false) {
          this.landFreight = 0;
        }
      }
    },
    //监听的是整个对象
    orderItemInfo: {
      handler() {
        //如果不是仓库发货
        if (this.storeHouseName === undefined) {
          //是否含税 厂家否 客户否
          if (this.Tax === '00') {
            //误差为0.8
            this.erro = 0.8;
            //出厂贷款
            this.paymentFactory = this.paymentFactory00;
            //总贷款
            this.payments = this.payments00;
            //吨位
            this.tonnage = this.tonnage00
            //运费
            this.landFreight = this.landFreight00
            //利润
            this.profit = this.profit00
            //不含税利润
            this.profitNoTax = this.profitNoTax00
            //出厂含税客户不含税
          } else if (this.Tax === '10') {
            //误差为0
            this.erro = 0;
            this.paymentFactory = this.paymentFactory10;
            this.payments = this.payments10
            this.tonnage = this.tonnage10
            this.landFreight = this.landFreight10
            this.profit = this.profit10
            this.profitNoTax = this.profitNoTax10
          } else if (this.Tax === '01') {
            //误差为0
            this.erro = 0;
            this.paymentFactory = this.paymentFactory01;
            this.payments = this.payments01
            this.tonnage = this.tonnage01
            this.landFreight = this.landFreight01
            this.profit = this.profit01
            this.profitNoTax = this.profitNoTax01
          } else {
            //误差为0
            this.erro = 0;
            this.paymentFactory = this.paymentFactory11;
            this.payments = this.payments11
            this.tonnage = this.tonnage11
            this.landFreight = this.landFreight11
            this.profit = this.profit11
            this.profitNoTax = this.profitNoTax11
          }
        }
        //运费自动填充
        if (this.seaFreight === undefined) {
          this.freight = Number(this.landFreight);
        } else {
          this.freight = Number(this.landFreight) + Number(this.seaFreight);
        }
      },
      deep: true,
      immediate: true,
    },
    //出厂片数
    pieces: {
      handler(val) {
        //如果选择的是仓库发货
        if (this.storeName !== '') {
          if (val > this.currentStockNumber) {
            this.$message.error("出厂片数不能大于库存量!");
            this.pieces = this.currentStockNumber;
          } else {
            //修改片数自动计算
            if (this.Tax === '00') {
              this.paymentFactory = this.paymentFactory00;
              this.payments = this.payments00;
              this.tonnage = this.tonnage00
              this.landFreight = this.landFreight00
              this.profit = this.profit00
              this.profitNoTax = this.profitNoTax00
            } else if (this.Tax === '10') {
              this.paymentFactory = this.paymentFactory10;
              this.payments = this.payments10
              this.tonnage = this.tonnage10
              this.landFreight = this.landFreight10
              this.profit = this.profit10
              this.profitNoTax = this.profitNoTax10
            } else if (this.Tax === '01') {
              this.paymentFactory = this.paymentFactory01;
              this.payments = this.payments01
              this.tonnage = this.tonnage01
              this.landFreight = this.landFreight01
              this.profit = this.profit01
              this.profitNoTax = this.profitNoTax01
            } else {
              this.paymentFactory = this.paymentFactory11;
              this.payments = this.payments11
              this.tonnage = this.tonnage11
              this.landFreight = this.landFreight11
              this.profit = this.profit11
              this.profitNoTax = this.profitNoTax11
            }
          }
        }
      }
    },
  }
  ,
  methods: {
    listProductLevel,
    listInventory,
    listCompany,

    //供应商信息
    handleCommitBackCompany(val) {
      this.orderItemInfo.supplierID = val.id;   //goodsOrderList->供应商ID
      this.supplier = val.companyName
    },

    // 仓库信息
    handleCommitBackInventory(val) {
      this.orderItemInfo.storeID = val.id;  //goodsOrderList ->仓库ID
      this.orderItemInfo.storeHouseID = val.id //goodsOrderList ->库存ID
      //自动填充数据
      const computedProperties = this.$options.computed;
      Object.keys(computedProperties).forEach(key => {
        this[key] = val[key];
      })
      if (this.supplier) {
        this.supplier = null;
      }
      this.storeName = val.storeHouseName
      this.length = val.length;
      this.width = val.width;
      this.levelID = val.levelID;
      //出厂片数让用户自己填
      this.pieces = val.stockNumber;
      this.currentStockNumber = val.stockNumber;//暂存
    },

    // 产品级别自动填充
    handleCommitBackProductLevel(val) {
      this.levelID = val.id;
      this.levelName = val.levelName;
      this.height = val.height;
      this.length = val.length;
      this.width = val.width;
      this.levelNo = val.levelNo;
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
                    v-model="supplier===undefined||supplier===null?storeName:supplier"
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
                  <el-table-column label="库存量" align="center" prop="stockNumber"/>
                  <el-table-column label="供应商" align="center" prop="supplier"/>
                  <el-table-column label="级别编码" align="center" prop="levelID"/>
                  <el-table-column label="级别名称" align="center" prop="levelName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
          <!--        <el-button size="mini"  circle @click="searchStoreInfo">-->
          <!--        </el-button>-->
        </div>
        <div class="order-item">
          <span class="text-bold">产品级别</span>
          <hr/>
          <el-input type="text" placeholder="请输入产品级别" v-model="levelName"></el-input>
          <!--        <el-button type="primary" size="mini" icon="el-icon-search" circle-->
          <!--                   @click="searchProductLevelInfo"></el-button>-->

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
        <div class="order-item" v-if="storeName">
          <span class="text-bold">出库日期</span>
          <hr/>
          <el-date-picker
              v-model="exWarehouseDate"
              type="date"
              placeholder="选择日期"
              value-format="timestamp">
          </el-date-picker>
        </div>
        <div class="order-item">
          <span class="text-bold">计量单位</span>
          <hr/>
          <el-radio v-model="countingUnit" label="片">片数</el-radio>
          <el-radio v-model="countingUnit" label="其他">其他</el-radio>
        </div>
        <div class="order-item">
          <span class="text-bold">厚度</span>
          <hr/>
          <el-input type="text" placeholder="请输入厚度" v-model="height"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">长度</span>
          <hr/>
          <el-input type="text" placeholder="请输入长度" v-model="length"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">宽度</span>
          <hr/>
          <el-input type="text" placeholder="请输入宽度" v-model="width"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">每包片数</span>
          <hr/>
          <el-input type="text" placeholder="请输入每包片数"
                    v-model="piecesPerPack"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">包数</span>
          <hr/>
          <el-input type="text" placeholder="请输入包数" v-model="packs"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂片数</span>
          <hr/>
          <el-input type="text" placeholder="请输入出厂片数" v-model="pieces"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂单价</span>
          <hr/>
          <el-input type="text" placeholder="请输入出厂单价" v-model="price"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂是否含税</span>
          <hr/>
          <el-radio v-model="isIncludeTaxFactory" label="1">是</el-radio>
          <el-radio v-model="isIncludeTaxFactory" label="0">否</el-radio>
        </div>
        <div class="order-item">
          <span class="text-bold">杂费</span>
          <hr/>
          <el-input type="text" placeholder="请输入杂费" v-model="sundryCost"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">出厂货款</span>
          <hr/>
          <el-input type="text" placeholder="请输入出厂贷款"
                    v-model="paymentFactory"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">卸货片数</span>
          <hr/>
          <el-input type="text" placeholder="请输入卸货片数" v-model="outPieces"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">卸货价</span>
          <hr/>
          <el-input type="text" placeholder="请输入卸货价" v-model="paymentUnload"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">销售是否含税</span>
          <hr/>
          <el-radio v-model="isIncludeTaxSale" label="1">是</el-radio>
          <el-radio v-model="isIncludeTaxSale" label="0">否</el-radio>
        </div>
        <div class="order-item">
          <span class="text-bold">总货款杂费</span>
          <hr/>
          <el-input type="text" placeholder="总货款杂费"
                    v-model="paymentsWithSundry"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">总货款</span>
          <hr/>
          <el-input type="text" placeholder="请输入总货款" v-model="payments"></el-input>
        </div>

        <div class="order-item">
          <span class="text-bold">误差</span>
          <hr/>
          <el-input type="text" placeholder="请输入误差" v-model="erro" disabled></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">吨位</span>
          <hr/>
          <el-input type="text" placeholder="请输入吨位" v-model="tonnage"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">陆运费单价</span>
          <hr/>
          <el-input type="text" placeholder="请输入陆运费单价"
                    v-model="landFreightPrice"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">加费</span>
          <hr/>
          <el-input type="text" placeholder="加费" v-model="additionalFees"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">陆运费</span>
          <hr/>
          <el-input type="text" placeholder="陆运费" v-model="landFreight"></el-input>
        </div>
        <div class="order-item" v-if="isSea">
          <span class="text-bold">海运费</span>
          <hr/>
          <el-input type="text" placeholder="海运费" v-model="seaFreight"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">总运费</span>
          <hr/>
          <el-input type="text" placeholder="总运费" v-model="freight"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">其他费用</span>
          <hr/>
          <el-input type="text" placeholder="其他费用" v-model="otherCost"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">利润</span>
          <hr/>
          <el-input type="text" placeholder="利润" v-model="profit"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">不含税利润</span>
          <hr/>
          <el-input type="text" placeholder="不含税利润" v-model="profitNoTax"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">实际片数</span>
          <hr/>
          <el-input type="text" placeholder="实际片数" v-model="actualPieces"></el-input>
        </div>
        <div class="order-item">
          <span class="text-bold">备注</span>
          <hr/>
          <el-input type="text" placeholder="备注" v-model="comments"></el-input>
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
                    v-model="customerCommission"></el-input>
        </div>
      </div>
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
