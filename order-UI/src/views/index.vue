<template>
  <div>
    <el-row style="margin-top: 200px">
      <el-col :span="12" :offset="8">
        <LoadingWarning/>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import LoadingWarning from "@/components/LoadingWarning.vue";

export default {
  name: "Index",
  components: {LoadingWarning},
  data() {
    return {};
  },
  methods: {}
};
</script>

<style scoped lang="scss">

</style>

