# Element-UI 表格固定列修复工具使用说明

## 功能说明

这个JS工具可以解决Element-UI表格中因横向滚动条高度变化导致的固定列与非固定列错行问题。

## 核心特性

1. **自动检测与调整**: 自动监听DOM变化，发现新的表格时自动调整
2. **响应式调整**: 监听窗口大小变化，自动重新调整表格
3. **滚动同步**: 监听表格滚动事件，确保固定列与主表格保持同步
4. **兼容原有接口**: 保持与原有`elementFixedTableAdjustment`函数的兼容性

## 使用方法

### 方法1: 自动调整（推荐）
```javascript
// 引入工具类
import './utils/tableFixedColumnAdjustment.js'

// 工具会自动监听DOM变化并调整所有表格，无需手动调用
```

### 方法2: 手动调用（兼容原有接口）
```javascript
// 调整所有表格，使用默认滚动条高度15px
elementFixedTableAdjustment()

// 调整所有表格，指定滚动条高度为20px
elementFixedTableAdjustment(20)

// 调整指定选择器的表格
elementFixedTableAdjustment('.my-table')

// 调整指定元素
const tableElement = document.querySelector('.el-table')
elementFixedTableAdjustment(tableElement)
```

### 方法3: 使用类实例
```javascript
import { TableFixedColumnAdjustment, tableAdjustment } from './utils/tableFixedColumnAdjustment.js'

// 使用全局实例
tableAdjustment.adjustAllTables()

// 创建新实例
const myTableAdjustment = new TableFixedColumnAdjustment()

// 销毁监听器（如果需要）
myTableAdjustment.destroy()
```

## 在项目中集成

### 1. 在main.js中引入
```javascript
// main.js
import Vue from 'vue'
import App from './App.vue'

// 引入表格修复工具（会自动初始化）
import './utils/tableFixedColumnAdjustment.js'

new Vue({
  render: h => h(App)
}).$mount('#app')
```

### 2. 在具体组件中使用
```vue
<template>
  <div>
    <el-table :data="tableData" style="width: 100%">
      <el-table-column fixed prop="date" label="日期" width="150"></el-table-column>
      <el-table-column prop="name" label="姓名" width="120"></el-table-column>
      <!-- 更多列... -->
    </el-table>
  </div>
</template>

<script>
export default {
  mounted() {
    // 如果需要手动调整（可选）
    this.$nextTick(() => {
      elementFixedTableAdjustment()
    })
  }
}
</script>
```

## 配置选项

### 滚动条高度配置
根据你在CSS中设置的滚动条高度，调整JS中的默认值：

```javascript
// 如果你的滚动条高度是20px
elementFixedTableAdjustment(20)

// 或者修改全局默认值
import { tableAdjustment } from './utils/tableFixedColumnAdjustment.js'
tableAdjustment.scrollbarHeight = 20
```

## 注意事项

1. **CSS配合**: 确保element-ui.scss中设置了正确的滚动条高度
2. **性能优化**: 工具使用了WeakSet来避免重复处理同一个表格
3. **兼容性**: 支持现代浏览器，使用了MutationObserver和ResizeObserver
4. **内存管理**: 提供了destroy方法来清理监听器，避免内存泄漏

## 原理说明

1. **检测滚动条**: 检测表格是否有横向滚动条
2. **高度补偿**: 为固定列添加底部padding来补偿滚动条高度
3. **同步调整**: 确保固定列和主表格的高度保持一致
4. **事件监听**: 监听滚动、窗口大小变化、DOM变化等事件

这个工具比纯CSS方案更灵活，可以根据实际情况动态调整，避免了固定值可能导致的问题。