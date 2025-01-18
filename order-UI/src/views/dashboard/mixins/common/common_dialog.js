/**
 * 通用的弹窗组件 配合弹窗组件的混入 放在弹窗组件所在的父组件当中
 * @type {{data(): {currentComponent: null, dialogVisible: boolean, dialogTitle: null, dialogWidth: null, dialogProps: {}, closeConfirm: boolean}, methods: {handleCloseDialog(*): void, handleDialogConfirm(*, string=): void, checkDialog(*): void, clearStatus(): void, openDialog(*, *, string=, *): void}}}
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
			// 是否关闭确认按钮
			closeConfirm: false,
			// 传递给弹窗的属性
			dialogProps: null
		};
	},
	methods: {
		// 打开弹窗的函数 嵌入到别的混入中使用
		openDialog(component, title, width = '50%', props, closeConfirm = false) {
			this.currentComponent = component;
			this.dialogTitle = title;
			this.dialogWidth = width;
			this.dialogProps = props;
			this.closeConfirm = closeConfirm;
			this.dialogVisible = true;
		},
		handleCloseDialog(callback) {
			this.checkDialog(callback);
			callback(this);
		},
		// 弹窗点击确认 只有回调成功才关闭弹窗
		handleDialogConfirm(callback) {
			this.checkDialog(callback);
			callback(this);
		},
		// 弹窗相关校验
		checkDialog(callback) {
			if (!(callback instanceof Function)) {
				throw new Error('回调函数未定义');
			}
		},
		// 清除状态
		clearStatus() {
			// 清除组件 防止下次导致污染渲染
			this.currentComponent = null;
			try {
				this?.getList();
			} catch (err) {
				console.log('抓取数据 getList 发生错误:', err);
			}
		}
	}
};
