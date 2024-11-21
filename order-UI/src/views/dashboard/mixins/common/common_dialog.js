/**
 * 通用的弹窗组件 配合弹窗组件的混入 放在弹窗组件所在的父组件当中
 * @type {{data(): {currentComponent: null, dialogVisible: boolean, dialogTitle: null, dialogWidth: null, dialogProps: {}}, methods: {handleCloseDialog(*): void, handleDialogConfirm(*, string=): void, checkDialog(*): void, clearStatus(): void, openDialog(*, *, string=, *): void}}}
 */
export var common_dialog = {
  data() {
    return {
      // 弹窗的标题 默认为无标题
      dialogTitle: '无标题',
      // 弹窗的宽度
      dialogWidth: null,
      // 弹窗的显示与隐藏
      dialogVisible: false,
      // 要渲染的功能组件
      currentComponent: null,
      // 传递给弹窗的属性
      dialogProps: null
    }
  },
  methods: {
    // 打开弹窗的函数 嵌入到别的混入中使用
    openDialog(component, title, width = '50%', props) {
      this.currentComponent = component;
      this.dialogTitle = title;
      this.dialogWidth = width;
      this.dialogProps = props;
      this.dialogVisible = true;
    },
    // 弹窗点击关闭 这里可以执行一些取消清理工作
    handleCloseDialog(callback) {
      // 校验
      this.checkDialog(callback)
      // 执行回调函数
      callback();
      this.clearStatus()
    },
    // 弹窗点击确认 todo 这个方法可以整合到对应混入中
    handleDialogConfirm(callback, message = '操作成功') {
      this.checkDialog(callback)
      callback();
      this.$message.success(message)
      this.clearStatus()
    },
    // 弹窗相关校验
    checkDialog(callback) {
      if (!callback instanceof Function) {
        throw new Error('回调函数未定义')
      }
      // todo 其他逻辑
    },
    // 清除状态
    clearStatus() {
      // 清除组件 防止下次导致污染渲染
      this.currentComponent = null
      // 关闭弹窗
      this.dialogVisible = false
      // 清除状态后重新拉取一下数据
      this?.getList()
    },
  }
}
