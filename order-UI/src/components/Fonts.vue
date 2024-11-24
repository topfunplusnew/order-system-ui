<!-- 统一文本组件 -->
<script>
  export default {
    name: 'Fonts',
    props: {
      content: {
        type: String,
        default: '请输入文本'
      }
    }
  }
</script>

<template>
  <div>
    <span class="fonts">{{ content }}</span>
  </div>
</template>

<style scoped lang="scss">
.fonts {
  font-weight: bold;
  font-size: 18px;
  line-height: 52px;
}
</style>
