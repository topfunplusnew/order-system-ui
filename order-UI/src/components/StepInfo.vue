<script>
export default {
  name: "StepInfo",
  props: {
    processInfo: {
      type: Array,
      required: true
    }
  },
  computed: {
    //当前审核进度
    currentStep() {
      //找到step最大的
      return Math.max.apply(null, this.processInfo.map(item => item.step));
    }
  },
}
</script>

<template>
  <div>
    <el-row>
      <el-col :span="4">
        <span style="font-weight: bolder; font-size: 16px;line-height: 100px">
          审核进度:
        </span>
      </el-col>
      <el-col :span="18">
        <el-steps :active="currentStep" finish-status="success" style="margin-top: 20px">
          <!--      循环-->
          <el-step v-for="(item,index) in processInfo" :status="item.checkState==='通过'?'success':'error'"
                   :key="index">
            <template #title>
          <span style="font-weight: bolder">
            {{ item.flowname }}
          </span>
            </template>
            <template #description>
          <span style="font-weight: bolder">
            审核意见:{{ item.auditcomment === null ? '无' : item.auditcomment }}
          </span>
            </template>
          </el-step>
        </el-steps>
      </el-col>
    </el-row>
    <br/>
    <br/>
    <el-row>
      <el-col :span="4">
        <span style="font-weight: bolder; font-size: 16px;line-height: 100px">
          审核进度:
        </span>
      </el-col>
      <el-col :span="18">
        <el-timeline>
          <el-timeline-item v-for="(item,index) in processInfo" :key="index" timestamp="2018/4/12" placement="top">
            <el-card>
              <h4>更新 Github 模板</h4>
              <p>王小虎 提交于 2018/4/12 20:46</p>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </el-col>

    </el-row>
  </div>
</template>

<style scoped lang="scss">

</style>
