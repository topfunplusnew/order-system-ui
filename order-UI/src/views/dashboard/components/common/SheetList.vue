<script>
import SheetItem from "@/views/dashboard/components/common/SheetItem.vue";
import SelectGoods from "@/views/dashboard/components/common/SelectGoods.vue";
import {mixin_excel_server} from "@/views/dashboard/components/common/utils/excelServer";

export default {
  name: "SheetList",
  components: {SelectGoods, SheetItem},
  mixins: [mixin_excel_server],
  // 接收文件读取到的sheetList 渲染出来给用户看 并且可以选择看哪一个
  props: {
    // sheet列表
    sheetList: {
      type: Array,
      default: []
    }
  },
  data() {
    return {
      // 订单选择弹窗
      invoiceAllVisible: false,
      // 供应商价税合计表
      invoiceSupplierList: []
    }
  },
  methods: {
    // 点击某一个 打开订单的列表
    handleInvoiceAll(item, index) {
      const excelInfo = this.handleReadExcel()
      // 购买方统计
      const purchaseMap = new Map()
      const purchaseHandler = (item, purchaseMap) => {
        // 对供应商进行分类统计
        if (purchaseMap.has(item.purchaseId)) {
          purchaseMap.set(item.purchaseId, item.total + purchaseMap.get(item.purchaseId))
        }
        purchaseMap.set(item.purchaseId, item.total)
      }
      // 先把需要的列拿出来
      excelInfo[index].map(item => {
        return {
          sellerId: item['销方ID'],
          sellerName: item['销方名称'],
          purchaseId: item['购买方ID'],
          purchaseType: item['购买方类型'],
          purchaseName: item['购买方名称'],
          total: item['价税合计']
        }
      }).forEach((item) => purchaseHandler(item, purchaseMap))
      console.log('map', sellerMap)
      this.invoiceAllVisible = true
    }
  }
}
</script>

<template>
  <div>
    <div class="sheet-container">
      <!--      点击某一个sheet-->
      <SheetItem v-for="(item,index) in sheetList" :key="item" :title="item"
                 @click.native="handleInvoiceAll(item,index)"/>
    </div>

    <div>
      <el-dialog
        title="批量开票"
        fullscreen
        :visible.sync="invoiceAllVisible"
        append-to-body>
        <!--        展示某个公司有多少钱可以开-->
        <el-card class="box-card">

        </el-card>
        <!-- 展示读取的excel基本信息-->
        <el-card class="box-card">
          <!--          订单选择模块-->
          <SelectGoods/>
        </el-card>
        <span slot="footer" class="dialog-footer">
        <el-button @click="invoiceAllVisible = false">取 消</el-button>
        <el-button type="primary" @click="invoiceAllVisible = false">确 定</el-button>
       </span>
      </el-dialog>
    </div>
  </div>
</template>

<style scoped lang="scss">
.sheet-container {
  display: flex;
}
</style>
