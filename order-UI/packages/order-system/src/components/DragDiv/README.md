# DragDiv 组件使用说明

## 功能介绍

DragDiv 是一个可拖拽调整两个区域宽度的分割组件。它提供了两个插槽（left 和 right），中间有一条可拖拽的分割线，用户可以通过拖拽分割线来调整左右两个区域的宽度。

## 使用示例

```vue
<template>
  <div style="height: 500px;">
    <DragDiv
      :initial-left-width="300"
      :min-left-width="150"
      :min-right-width="200"
      :divider-width="6"
      @drag-start="handleDragStart"
      @dragging="handleDragging"
      @drag-end="handleDragEnd"
    >
      <!-- 左侧内容 -->
      <template #left>
        <div style="padding: 20px; background: #f0f0f0; height: 100%;">
          <h3>左侧面板</h3>
          <p>这里是左侧的内容区域</p>
          <ul>
            <li>项目 1</li>
            <li>项目 2</li>
            <li>项目 3</li>
          </ul>
        </div>
      </template>
      
      <!-- 右侧内容 -->
      <template #right>
        <div style="padding: 20px; background: #e8f4fd; height: 100%;">
          <h3>右侧面板</h3>
          <p>这里是右侧的内容区域</p>
          <p>当前宽度: {{ rightWidth }}px</p>
        </div>
      </template>
    </DragDiv>
  </div>
</template>

<script>
import DragDiv from '@/components/DragDiv'

export default {
  components: {
    DragDiv
  },
  data() {
    return {
      leftWidth: 300,
      rightWidth: 0
    }
  },
  methods: {
    handleDragStart(sizes) {
      console.log('开始拖拽:', sizes)
    },
    handleDragging(sizes) {
      this.leftWidth = sizes.leftWidth
      this.rightWidth = sizes.rightWidth
    },
    handleDragEnd(sizes) {
      console.log('拖拽结束:', sizes)
      // 可以在这里保存用户的布局偏好
      localStorage.setItem('dragDivLayout', JSON.stringify(sizes))
    }
  }
}
</script>
```

## Props 参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| initialLeftWidth | Number | 300 | 初始左侧宽度（像素） |
| minLeftWidth | Number | 100 | 左侧最小宽度（像素） |
| minRightWidth | Number | 100 | 右侧最小宽度（像素） |
| dividerWidth | Number | 6 | 分割线宽度（像素） |

## 事件

| 事件名 | 参数 | 说明 |
|--------|------|------|
| drag-start | { leftWidth, rightWidth } | 开始拖拽时触发 |
| dragging | { leftWidth, rightWidth } | 拖拽过程中触发 |
| drag-end | { leftWidth, rightWidth } | 拖拽结束时触发 |

## 插槽

| 插槽名 | 说明 |
|--------|------|
| left | 左侧面板内容 |
| right | 右侧面板内容 |

## 方法

通过 ref 可以调用以下方法：

```javascript
// 重置为初始宽度
this.$refs.dragDiv.resetWidth()

// 设置左侧宽度
this.$refs.dragDiv.setLeftWidth(250)
```

## 特性

1. **响应式设计**: 支持窗口大小变化时自动调整
2. **最小宽度限制**: 防止面板被拖拽得过小
3. **拖拽反馈**: 提供视觉反馈和鼠标样式变化
4. **事件回调**: 提供完整的拖拽生命周期事件
5. **移动端友好**: 支持触摸设备（可扩展）
