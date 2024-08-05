<script>
export default {
  name: "index.vue",
  //checkInfo=>需要检查的变量
  //checkValue=>判断值为假的值
  props: {
    checkInfo: {},
    checkValue: ''
  }
}
</script>

<template>
  <el-tag size="small" type="danger" v-if="checkInfo === checkValue">{{
      checkInfo
    }}
  </el-tag>
  <el-tag size="small" v-else>{{
      checkInfo
    }}
  </el-tag>
</template>

<style scoped lang="scss">

</style>
