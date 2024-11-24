<!--查看详情-->

<script>
  import { getCars } from '../../../../api/system/cars';

  export default {
    name: 'CheckDetail',
    props: {
      row: {
        type: Object,
      }
    },
    data() {
      return {}
    },
    methods: {
      handleCheck(row) {
        // 先根据银行卡信息 去 查询司机姓名
        getCars(row.companyId).then(res => {
          // 点击确认后跳转到订单运费界面 携带搜索参数
          this.$confirm(`是否查看司机名称为${res.data.driver}的运费详情?`, '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            // 跳转到订单运费界面 并且传递参数
            this.$router.push({
              path: '/order/order/freight',
              query: {
                fundsDate: row.fundsDate,
                driver: res.data.driver
              }
            })
          })
        })
      }
    }
  }
</script>

<template>
  <div>
    <div v-if="row.companyType === '司机'">
      <el-button
        size="mini"
        type="text"
        @click="handleCheck(row)"
      >查看运费详情
      </el-button>
    </div>
    <div v-else>
      无运费信息
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
