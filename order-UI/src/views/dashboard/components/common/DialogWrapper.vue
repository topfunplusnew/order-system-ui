<template>
  <el-dialog
    :title="dialogTitle"
    :visible.sync="dialogVisible"
    :width="dialogWidth"
    append-to-body
    :close-on-click-modal="false"
    :close-on-press-escape="false"
    :destroy-on-close="true"
    @close="handleClose"
  >
    <!-- 动态渲染内容 -->
    <component :is="currentComponent" ref="dynamicComponent" v-bind="dialogProps" />

    <!-- 底部操作按钮 -->
    <template #footer>
      <el-button @click="handleClose">
        关闭
      </el-button>
      <el-button type="primary" @click="handleConfirm">
        确认
      </el-button>
    </template>
  </el-dialog>
</template>

<script>
  export default {
    props: {
      // 弹窗是否可见
      dialogVisible: {
        type: Boolean,
        required: true,
      },
      // 弹窗标题
      dialogTitle: {
        type: String,
        default: '',
      },
      // 动态内容组件名称或对象
      currentComponent: {
        type: [String, Object], // 动态内容组件名称或对象
        required: true,
      },
      // 传递给内容组件的属性
      dialogProps: {
        type: Object, // 传递给内容组件的属性
        default: () => ({}),
      },
      // 弹窗的宽度
      dialogWidth: {
        type: String,
        default: '50%',
      },
    },
    // 监听事件
    emits: ['update:dialogVisible', 'confirm', 'close'],
    methods: {
      // 关闭弹窗
      handleClose() {
        // 执行函数 这个函数 要求每一个业务组件都要实现
        const callback = this.$refs.dynamicComponent.handleReject
        this.$emit('update:dialogVisible', false);
        this.$emit('close', callback);
      },
      // 确认按钮 提醒父组件执行相关的逻辑
      handleConfirm() {
        // 执行函数 这个函数 要求每一个业务组件都要实现
        const callback = this.$refs.dynamicComponent.handleProcess
        this.$emit('confirm', callback, '操作成功~');
      },
    },
  };
</script>
