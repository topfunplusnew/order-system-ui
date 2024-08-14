<!--订单详情个体-->

<script>
import {listCompany} from "@/api/system/company";
import {listInventory} from "@/api/system/inventory";
import {listStoreHouse} from "@/api/system/StoreHouse";
import {listProductLevel} from "@/api/system/productLevel";
import {fix} from "@/api/tool/format";

export default {
  name: "OrderItem",

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
      //产品级别搜索
      productLevel: {
        //级别
        level: '',
        //宽度
        width: ''
      },

      //供应商信息弹窗
      companyGiveDialogVisible: false,
      //仓库信息弹窗
      storeInfoDialogVisible: false,
      //产品级别弹窗
      productLevelDialogVisible: false,


      //供应商信息
      companyGiveInfo: [],
      //仓库信息
      storeInfo: [],
      //库存信息
      inventoryInfo: [],
      //产品级别信息
      productLevelInfo: [],

      //id:  供应商ID:supplierID  客户ID:customerID 仓库ID:storeHouseID
      // 仓库存储的货物ID:storeID 客户ID:customerID 货运车辆ID:landCarID 海运车辆ID:seaCarID
      supplierID: '',
      storeHouseID: '',
      storeID: '',

      //卸货片数
      outPieces: 0,
      //出库日期
      // exWarehouseDate: ''

      //库存
      currentStockNumber: '',
      //搜索仓库名称
      searchStoreName: ''
    }
  },
  // 思路  先通过计算属性，拿到属性，渲染到页面 因为计算属性是响应式的 在给计算属性赋值时 提醒父组件改变传递的item对象
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
          this.$emit('changeOrderItemInfo', {...this.orderItemInfo, exWarehouseDate: val.getTime()});
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
    tonnage00() {
      //todo 这里会有一个小bug，如果产品规格过小 会导致结果变为0
      return fix((Number(this.height) - Number(this.erro)) * this.length * this.pieces / 1000000 / 20 / 20);
    },
    landFreight00() {
      return fix(this.tonnage * this.landFreightPrice + Number(this.additionalFees));
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
    //出厂是否含税
    isIncludeTaxFactory: {
      handler(val) {
        console.log('isIncludeTaxFactory:', val)
      },
    },
    //销售是否含税
    isIncludeTaxSale: {
      handler(val) {
        console.log('isIncludeTaxSale:', val)
      },
    },
    //组合
    Tax: {
      handler(val) {
        console.log('both:', val)

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
      deep: true
    },
    //出厂片数
    pieces: {
      handler(val) {
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
  },
  methods: {
    //供应商信息
    searchCompanyGiveInfo() {
      this.companyGiveDialogVisible = true;
      //查询供应商信息
      listCompany({companyType: '供应商', companyName: this.companyName}).then(res => {
        this.companyGiveInfo = res.rows;
      })
    }
    ,
    //查询仓库信息
    searchStoreInfo() {
      this.storeInfoDialogVisible = true;
      //搜索库存信息 只查询库存中仓库
      listInventory().then(res => {
        this.inventoryInfo = res.rows.filter(item => {
          return item.stockNumber > 0;
        })
      })
      //搜索仓库信息
      listStoreHouse().then(res => {
        this.storeInfo = res.rows;
      })
    }
    ,
    //弹出的库存信息条件查询
    searchStoreHouseInfo() {
      //查询名称库存信息
      listInventory({storeHouseName: this.searchStoreName}).then(res => {
        this.inventoryInfo = res.rows;
      })
    }
    ,
    //查询产品级别信息
    searchProductLevelInfo() {
      this.productLevelDialogVisible = true;
      //查询产品级别信息
      listProductLevel({width: this.productLevel.width, levelName: this.productLevel.level}).then(res => {
        this.productLevelInfo = res.rows;
      })
    }
    ,

    //供应商信息确认 选择供应商后还要选择产品级别
    commitCompanyGiveInfo(row) {
      console.log(row)
      this.orderItemInfo.supplierId = row.id;   //goodsOrderList->供应商ID
      this.supplier = row.companyName
      this.companyGiveDialogVisible = false;
    }
    ,
    //仓库确认
    commitStoreInfo(row) {
      this.orderItemInfo.storeID = row.id;  //goodsOrderList ->仓库ID
      this.orderItemInfo.storeHouseid = row.id //goodsOrderList ->库存ID
      //自动填充数据
      const computedProperties = this.$options.computed;
      Object.keys(computedProperties).forEach(key => {
        this[key] = row[key];
      })
      if (this.supplier) {
        this.supplier = null;
      }
      this.storeName = row.storeHouseName
      this.length = row.length;
      this.width = row.width;
      this.levelID = row.levelID;

      //出厂片数让用户自己填
      this.pieces = row.stockNumber;
      this.currentStockNumber = row.stockNumber;//暂存
      this.storeInfoDialogVisible = false;
    }
    ,
    //产品级别确认
    commitProductLevelInfo(row) {
      //确定产品级别编码信息
      this.levelID = row.id;
      //如果供应商此时没值
      // if (this.supplier === '' || this.supplier === undefined || this.supplier === null) {
      //   this.searchSupplierInventory(row)
      // } else {
      //   this.searchStoreInventory(row)
      // }
      //填充级别信息
      this.levelName = row.levelName;
      this.height = row.height;
      this.length = row.length;
      this.width = row.width;
      this.levelNo = row.levelNo;
      this.productLevelDialogVisible = false;
    }
    ,

    //查询库存信息
    searchSupplierInventory(row) {
      //填充表格数据
      listInventory({supplier: this.supplier, levelID: this.levelID}).then(res => {
        if (res.rows.length === 0) {
          this.$message.error("没有该库存信息!")
          //自动填写某些字段
        } else {
          this.levelName = row.levelName;
          //数据库查询的筛选后的库存信息
          //todo 如果有多个库存信息 应该如何做
          const info = res.rows[0];
          this.height = info.height;
          this.length = info.length;
          this.width = info.width;
          //添加产品级别编码
          this.levelNo = row.levelNo;
        }
      })
    }
    ,
    searchStoreInventory(row) {
      //填充表格数据
      listInventory({storeHouseName: this.supplier, levelID: this.levelID}).then(res => {
        if (res.rows.length === 0) {
          this.$message.error("没有该库存信息!")
        } else {
          this.levelName = row.levelName;
          const info = res.rows[0];
          this.height = info.height;
          this.length = info.length;
          this.width = info.width;
          this.levelNo = row.levelNo;
        }
      })
    }
    ,
    //todo 测试用 打印所有计算属性的值
    printAllComputers() {
      const computedProperties = this.$options.computed;
      Object.keys(computedProperties).forEach(key => {
        console.log('计算属性+>', key, computedProperties[key])
      })
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
                  v-model="supplier"
                  disabled></el-input>
        <!--        供应商弹窗按钮-->
        <el-button size="mini" type="primary" icon="el-icon-user" circle @click="searchCompanyGiveInfo">
        </el-button>
        <el-button size="mini" icon="el-icon-s-home" circle @click="searchStoreInfo">
        </el-button>
      </div>
      <div class="order-item">
        <span class="text-bold">产品名称</span>
        <hr/>
        <el-input type="text" placeholder="请输入产品名称" v-model="levelName"></el-input>
        <el-button type="primary" size="mini" icon="el-icon-search" circle
                   @click="searchProductLevelInfo"></el-button>
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
        <!--        todo  测试-->
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
        <span class="text-bold">销售是否含税</span>
        <hr/>
        <el-radio v-model="isIncludeTaxSale" label="1">是</el-radio>
        <el-radio v-model="isIncludeTaxSale" label="0">否</el-radio>
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
        <span class="text-bold">实际片数</span>
        <hr/>
        <el-input type="text" placeholder="请输入实际片数" v-model="actualPieces"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">卸货价</span>
        <hr/>
        <el-input type="text" placeholder="请输入卸货价" v-model="paymentUnload"></el-input>
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
        <span class="text-bold">运费单价</span>
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
      <!--      <div class="order-item" v-if="isSea">-->
      <!--        <span class="text-bold">海运费</span>-->
      <!--        <hr/>-->
      <!--        <el-input type="text" placeholder="海运费" v-model="seaFreight"></el-input>-->
      <!--      </div>-->

      <!--      <div class="order-item">-->
      <!--        <span class="text-bold">总运费</span>-->
      <!--        <hr/>-->
      <!--        <el-input type="text" placeholder="总运费" v-model="freight"></el-input>-->
      <!--      </div>-->

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
        <span class="text-bold">备注</span>
        <hr/>
        <el-input type="text" placeholder="备注" v-model="comments"></el-input>
      </div>
    </div>


    <!--    供应商信息弹窗-->
    <el-dialog
      title="供应商信息"
      :visible.sync="companyGiveDialogVisible"
      width="35%" append-to-body>
      <!--      供应商信息搜索-->
      <el-row :gutter="5">
        <el-col :span="4">
          <span style="font-weight: bolder;line-height: 40px">公司名称</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="companyName" placeholder="请输入公司名称"></el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" @click="searchCompanyGiveInfo">搜索</el-button>
        </el-col>
      </el-row>
      <el-table
        :data="companyGiveInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitCompanyGiveInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="companyName"
          label="供应商">
        </el-table-column>
        <el-table-column
          prop="address"
          label="地址">
        </el-table-column>
        <el-table-column
          prop="relationName"
          label="联系人">
        </el-table-column>
        <el-table-column
          prop="bankNo"
          label="银行账号">
        </el-table-column>
        <el-table-column
          prop="acountsName"
          label="户名">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="companyGiveDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="companyGiveDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>

    <!--    产品级别信息弹窗-->
    <el-dialog
      title="产品级别信息"
      :visible.sync="productLevelDialogVisible"
      width="35%" append-to-body>
      <el-row style="margin-bottom: 20px">
        <!--      产品级别-->
        <el-col :span="3">
          <span style="font-weight: bolder;line-height: 40px">产品级别</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="productLevel.level" placeholder="请输入产品级别"></el-input>
        </el-col>
        <!--        宽度-->
        <el-col :span="2">
          <span style="font-weight: bolder;line-height: 40px">宽度</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="productLevel.width" placeholder="请输入产品级别"></el-input>
        </el-col>
        <el-col :span="2">
          <el-button type="primary" @click="searchProductLevelInfo">搜索</el-button>
        </el-col>
      </el-row>
      <el-table
        :data="productLevelInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitProductLevelInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="categoryName"
          label="分类">
        </el-table-column>
        <el-table-column
          prop="levelNo"
          label="产品级别编码">
        </el-table-column>
        <el-table-column
          prop="levelName"
          label="标题">
        </el-table-column>
        <el-table-column
          prop="height"
          label="厚度">
        </el-table-column>
        <el-table-column
          prop="length"
          label="长度">
        </el-table-column>
        <el-table-column
          prop="width"
          label="宽度">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="productLevelDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="productLevelDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
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
