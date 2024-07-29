<template>
  <div>
    <div style="margin-top: 16px"><input type="text" v-model="text" /></div>
    <div style="margin-top: 16px">value:{{ data }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRequest, useTimeout } from 'vue-hooks-plus'

//获取用户名
function getUsername(): Promise<string> {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(`${String(Date.now())}`)
    }, 300)
  })
}

const text = ref('')

//防抖设置
//input 框中快速输入文本,频繁触发 run，只会在最后一次触发结束后等待 1000ms 执行
const { data, run } = useRequest(() => getUsername(), {
  debounceWait: 1000,
  manual: true,
})

//节流优化
const throttleWait = ref(500)
useTimeout(() => {
  throttleWait.value = 3000
}, 2000)

//监视text的变化 执行run
//c是输入框频繁输入的值
watch(text, (c: any) => {
  console.log('c=>', c)
  run()
})
</script>

<style scoped></style>
