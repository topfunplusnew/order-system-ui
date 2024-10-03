<script>

import Item from "./Item.vue";

export default {
  computed: {},
  components: {Item},
  //
  beforeCreate() {
    // console.log('before create =>', this)
  },
  data() {
    // console.log('data this=>', this)
    return {
      name: 'zhangsan'
    }
  },
  created() {
    // console.log('created this=>', this.$el)

    /**
     * 在 Vue 2 中，$children 不保证顺序，且在 created 钩子执行时可能尚未初始化完成。
     * Item 组件在此例中作为直接子组件，但在 created 钩子时可能还未被添加到 $children 数组中。
     * 因此，在 created 钩子中调用 this.$children.pop() 可能会得到 undefined。建议在 mounted 钩子中访问 $children。
     */
    // console.log('created this.children =>', this.$children.pop())
    // this.checkState(this)
  },
  beforeMount() {
    // console.log('before mount this=>', this)
  },
  //Vue 会将组件(虚拟dom)渲染为实际的 HTML ，并将它插入到页面中 对应 的元素 (真实dom)里
  mounted() {
    console.log('mounted this=>', this)
    // console.log('mounted this.children =>', this.$children.pop().$el.innerHTML = 'hello')
  },
  beforeDestroy() {
    // console.log('before destroy this=>', this)
  },
  destroyed() {
    // console.log('destroy this=>', this)
  },
  methods: {
    checkState: (_this) => {
      console.log('checkState this=>', _this)
    },
    changeName() {
      this.name = 'lisi'
    }
  }
}
</script>

<template>
  <div>
    <div class="contain">
      <h1>Vue 2</h1>
      <el-button @click="changeName" type="primary">点击变换名字</el-button>
      <Item v-bind:title="name"/>
    </div>
  </div>
</template>

<style scoped lang="scss">
.contain {
  text-align: center;
}
</style>
