<script>
export default {
  props: {
    value: {
      type: Number,
      default: 0
    },
    title: {
      type: String,
      default: '标题'
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
      <el-col :span="6">
        <div>
          <el-statistic
            group-separator=","
            :precision="2"
            :value="value"
            :title="title"
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
