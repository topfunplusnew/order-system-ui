<!--查看差异信息的通用组件-->

<script>
// 导入jsondiffpatch
import {create} from 'jsondiffpatch'
import {format} from "jsondiffpatch/lib/formatters/html";
import 'jsondiffpatch/lib/formatters/styles/html.css'

export default {
  name: "CheckDiff",
  inheritAttrs: false,
  props: {
    title: String,
    // 比较的差异对象
    diffObjectA: {
      required: true,
    },
    diffObjectB: {
      required: true,
    },
    switchOn: false,
  },
  data() {
    return {
      diffPatcher: {},
    }
  },
  methods: {
    onOpen() {
      // 可以在这里添加打开弹窗时的初始化操作
    },
    close() {
      this.$emit('update:visible', false);
    },
    confirm() {
      // 可以在这里添加确认操作
    },
  },
  created() {
    // 初始化比较对象
    this.diffPatcher = create()
  },
  mounted() {
    console.log(this.diffPatcher)
    console.log(this.diffObjectA)
  },
  watch: {
    'switchOn': {
      handler(newValue, oldValue) {
        const diff = this.diffPatcher.diff(this.diffObjectA, this.diffObjectB)
        this.$nextTick(() => {
          this.$refs.compare.innerHTML = format(diff, this.diffObjectB);
        })
      },
    },
    'diffObjectA': {
      handler(newValue, oldValue) {
        const diff = this.diffPatcher.diff(this.diffObjectA, this.diffObjectB)
        this.$nextTick(() => {
          this.$refs.compare.innerHTML = format(diff, this.diffObjectB);
        })
      },
    }
  }
}
</script>

<template>
  <div>
    <el-dialog v-bind="$attrs" v-on="$listeners" @open="onOpen" :title="title" width="500px">
      <el-card class="box-card">
        <div ref="compare" style="width: 100%;height: 100%">
        </div>
      </el-card>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
