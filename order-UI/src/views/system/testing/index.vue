<script>

import {getGoodsOrder} from "../../../api/system/goodsOrder";

export default {
  computed: {},
  data() {
    // console.log('data this=>', this)
    return {
      order: {},
      tableData: [
        {name: '张三', age: 28},
        {name: '李四', age: 32},
        {name: '王五', age: 24},
      ],
      nameFilters: [
        {text: '张三', value: '张三'},
        {text: '李四', value: '李四'},
        {text: '王五', value: '王五'},
      ],
      ageFilters: [
        {text: '28', value: 28},
        {text: '32', value: 32},
        {text: '24', value: 24},
      ],
    }
  },
  created() {
    /**
     * 在 Vue 2 中，$children 不保证顺序，且在 created 钩子执行时可能尚未初始化完成。
     * Item 组件在此例中作为直接子组件，但在 created 钩子时可能还未被添加到 $children 数组中。
     * 因此，在 created 钩子中调用 this.$children.pop() 可能会得到 undefined。建议在 mounted 钩子中访问 $children。
     */
    getGoodsOrder(50).then(res => {
      this.order = res.data;
    })
  },
  methods: {
    reset(obj) {
      Object.keys(obj).forEach(item => {
        Object.assign(obj, {
          [item]: null
        })
      })
      return obj
    },
    handleReset() {
      this.order = this.reset(this.order)
    },
    print() {
      console.log('order的值为', this.order)
    },

    // 筛选方法
    filterName(value, row) {
      return row.name === value;
    },
    filterAge(value, row) {
      return row.age === value;
    },
  }
}
</script>

<template>
  <div>
    <div class="contain">
      <h1>Vue 2</h1>
      {{ order.customer }}
      <el-button @click="handleReset">点击重置对象</el-button>
      <el-button @click="print">输出对象的值</el-button>
    </div>
    <div>
      <el-table :data="tableData">
        <el-table-column
          prop="name"
          label="姓名"
          :filters="nameFilters"
          :filter-method="filterName"
          filter-placement="bottom"
          filterable
        >
        </el-table-column>
        <el-table-column
          prop="age"
          label="年龄"
          :filters="ageFilters"
          :filter-method="filterAge"
          filter-placement="bottom"
          filterable
        >
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<style scoped lang="scss">
.contain {
  text-align: center;
}
</style>
