<script>
export default {
  name: "INVENTORY",
  props: {
    needToShowInfo: {
      type: Object,
      default: () => {
      }
    }
  }
}
</script>

<template>
  <div>
    <el-card>
      <el-descriptions title="库存信息">
        <el-descriptions-item label="供应商">
          {{ needToShowInfo.supplier }}
        </el-descriptions-item>
        <el-descriptions-item label="存储日期">
          {{
            new Date(needToShowInfo.storeDate).toLocaleDateString()
          }}
        </el-descriptions-item>
        <el-descriptions-item label="库存数量">
          {{ needToShowInfo.stockNumber }} 片
        </el-descriptions-item>
        <el-descriptions-item label="产品规格">
          {{ needToShowInfo.levelName }} - {{
            needToShowInfo.countingUnit
          }}
        </el-descriptions-item>
        <el-descriptions-item label="单片尺寸">
          {{ needToShowInfo.height }} × {{ needToShowInfo.length }} ×
          {{ needToShowInfo.width }} cm
        </el-descriptions-item>
        <el-descriptions-item label="每包数量">
          {{ needToShowInfo.piecesPerPack }}
        </el-descriptions-item>
        <el-descriptions-item label="包装总数">
          {{ needToShowInfo.packs }}
        </el-descriptions-item>
        <el-descriptions-item label="单价">
          {{ needToShowInfo.price }} 元
        </el-descriptions-item>
        <el-descriptions-item label="含税出厂价">
          {{ needToShowInfo.isIncludeTaxFactory ? needToShowInfo.paymentFactory : '不含税' }}
        </el-descriptions-item>
        <el-descriptions-item label="含税销售价">
          {{
            needToShowInfo.isIncludeTaxSale ? needToShowInfo.payments : '不含税'
          }}
        </el-descriptions-item>
        <el-descriptions-item label="其他费用">
          {{ needToShowInfo.sundryCost }} 元
        </el-descriptions-item>
        <el-descriptions-item label="运费">
          {{ needToShowInfo.freight }} 元
        </el-descriptions-item>
        <el-descriptions-item label="实际数量">
          {{ needToShowInfo.actualPieces }} 片
        </el-descriptions-item>
        <el-descriptions-item label="附加费用">
          {{ needToShowInfo.additionalFees }} 元
        </el-descriptions-item>
        <el-descriptions-item label="利润">
          {{ needToShowInfo.profit }} 元
        </el-descriptions-item>
        <el-descriptions-item label="利润（不含税）">
          {{ needToShowInfo.profitNoTax }} 元
        </el-descriptions-item>
        <el-descriptions-item label="备注">
          <el-tag size="small">
            {{ needToShowInfo.comments || '无' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="运输车辆信息">
          <div>陆运车牌号: {{ needToShowInfo.landCarNo }}</div>
          <div>司机姓名: {{ needToShowInfo.landDriverName }}</div>
          <div>司机电话: {{ needToShowInfo.landDriverTel }}</div>
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<style scoped lang="scss">

</style>
