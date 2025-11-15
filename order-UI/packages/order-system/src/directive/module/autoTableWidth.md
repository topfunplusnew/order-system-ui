# v-auto-table-width 表格内容宽度自适应指令

## 功能说明

`v-auto-table-width` 是一个 Vue 指令，用于自动根据表格内容调整列宽，使表格列宽适应内容，提升表格的可读性和美观度。

## 特性

- ✅ 自动计算每列内容的最大宽度
- ✅ 支持最小宽度和最大宽度限制
- ✅ 自动排除已设置固定宽度的列
- ✅ 支持排除指定列索引
- ✅ 响应数据变化自动重新计算
- ✅ 响应窗口大小变化
- ✅ 防抖处理，性能优化

## 使用方法

### 基础用法

在 `el-table` 组件上添加 `v-auto-table-width` 指令即可：

```vue
<template>
  <el-table
    v-auto-table-width
    :data="tableData"
    border
  >
    <el-table-column prop="name" label="姓名" />
    <el-table-column prop="age" label="年龄" />
    <el-table-column prop="address" label="地址" />
  </el-table>
</template>
```

### 带参数用法

可以通过指令参数自定义配置：

```vue
<template>
  <el-table
    v-auto-table-width="{
      minWidth: 100,        // 最小列宽，默认 80
      maxWidth: 300,        // 最大列宽，默认 500
      padding: 20,          // 列宽额外padding，默认 20
      excludeColumns: [0],  // 排除的列索引数组，默认 []
      delay: 100            // 延迟执行时间（毫秒），默认 100
    }"
    :data="tableData"
    border
  >
    <el-table-column type="selection" width="50" />
    <el-table-column prop="name" label="姓名" />
    <el-table-column prop="age" label="年龄" />
    <el-table-column prop="address" label="地址" />
  </el-table>
</template>
```

### 配置参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| minWidth | Number | 80 | 列的最小宽度（像素） |
| maxWidth | Number | 500 | 列的最大宽度（像素） |
| padding | Number | 20 | 列宽的额外内边距（像素） |
| excludeColumns | Array | [] | 排除的列索引数组，这些列不参与自适应 |
| delay | Number | 100 | 延迟执行时间（毫秒），用于防抖 |

### 注意事项

1. **固定宽度列**：如果列已经设置了 `width` 属性，该列将不会参与自适应计算
2. **排除列**：可以通过 `excludeColumns` 参数排除不需要自适应的列（如操作列、选择列等）
3. **性能优化**：指令内部使用了防抖处理，避免频繁计算影响性能
4. **数据更新**：当表格数据更新时，指令会自动重新计算列宽

## 使用示例

### 示例 1：基础表格

```vue
<template>
  <el-table
    v-auto-table-width
    :data="userList"
    border
  >
    <el-table-column prop="userName" label="用户名称" />
    <el-table-column prop="nickName" label="用户昵称" />
    <el-table-column prop="phonenumber" label="手机号码" />
    <el-table-column prop="email" label="邮箱" />
  </el-table>
</template>
```

### 示例 2：排除操作列

```vue
<template>
  <el-table
    v-auto-table-width="{
      excludeColumns: [0, 1]  // 排除选择列和操作列
    }"
    :data="userList"
    border
  >
    <el-table-column type="selection" width="50" />
    <el-table-column label="操作" width="200">
      <template slot-scope="scope">
        <el-button size="mini" @click="handleEdit(scope.row)">编辑</el-button>
        <el-button size="mini" @click="handleDelete(scope.row)">删除</el-button>
      </template>
    </el-table-column>
    <el-table-column prop="userName" label="用户名称" />
    <el-table-column prop="nickName" label="用户昵称" />
  </el-table>
</template>
```

### 示例 3：自定义宽度范围

```vue
<template>
  <el-table
    v-auto-table-width="{
      minWidth: 120,
      maxWidth: 400,
      padding: 30
    }"
    :data="orderList"
    border
  >
    <el-table-column prop="orderNo" label="订单号" />
    <el-table-column prop="customerName" label="客户名称" />
    <el-table-column prop="amount" label="金额" />
  </el-table>
</template>
```

## 实现原理

1. **内容测量**：通过创建临时 DOM 元素测量每列内容的实际宽度
2. **宽度计算**：比较表头和数据行中每列的最大宽度
3. **宽度应用**：将计算出的宽度应用到列组件和 DOM 元素
4. **响应更新**：监听 DOM 变化和窗口大小变化，自动重新计算

## 兼容性

- Vue 2.x
- Element UI 2.x
- 现代浏览器（Chrome、Firefox、Safari、Edge）

## 注意事项

- 指令会在 DOM 插入后自动执行，无需手动调用
- 如果表格数据是异步加载的，指令会在数据更新后自动重新计算
- 建议在表格数据量较大时，适当调整 `delay` 参数以优化性能
