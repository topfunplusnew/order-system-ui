<script>
export default {
  props: {
    tags: {
      type: Object,
      default: () => {
      }
    }
  },
  computed: {
    // 含税货款
    totalIncludingTax() {
      return this.tags?.totalIncludingTax || 0
    },
    // 不含税货款
    totalExcludingTax() {
      return this.tags?.totalExcludingTax || 0
    },
    // 公户收款
    publicAccountInCome() {
      return this.tags?.publicAccountInCome || 0
    },
    // 私户收款
    noPublicAccountInCome() {
      return this.tags?.noPublicAccountInCome || 0
    },
    // 票点收入
    totalTicketPoints() {
      return this.tags?.totalTicketPoints || 0
    }
  },
  data() {
    return {}
  }
}
</script>

<template>
  <div>
    <el-row :gutter="20">
      <el-col :span="4">
        <div>
          <el-statistic
            group-separator=","
            :precision="2"
            :value="totalIncludingTax"
            title="含税货款"
          ></el-statistic>
        </div>
      </el-col>
      <el-col :span="4">
        <div>
          <el-statistic
            group-separator=","
            :precision="2"
            :value="totalExcludingTax"
            title="不含税货款"
          ></el-statistic>
        </div>
      </el-col>
      <el-col :span="4">
        <div>
          <el-statistic
            group-separator=","
            :precision="2"
            :value="publicAccountInCome"
            title="公户收款"
          ></el-statistic>
        </div>
      </el-col>
      <el-col :span="4">
        <div>
          <el-statistic
            group-separator=","
            :precision="2"
            :value="noPublicAccountInCome"
            title="私户收款"
          ></el-statistic>
        </div>
      </el-col>
      <el-col :span="4">
        <div>
          <el-statistic
            group-separator=","
            :precision="2"
            :value="totalTicketPoints"
            title="票点收入"
          ></el-statistic>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped lang="scss">
.like {
  cursor: pointer;
  font-size: 25px;
  display: inline-block;
}
</style>
