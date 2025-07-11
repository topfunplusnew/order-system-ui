// mixin: 缓存 keep-alive 下模态框状态
export default {
    data() {
        return {
            // 记录主弹窗状态
            _keepAliveOpen: false,
            // 记录变动流水弹窗状态
            _keepAliveChangeOpen: false
        };
    },
    // keep-alive 失活时，记录并隐藏弹窗状态
    deactivated() {
        if (this.hasOwnProperty('open')) {
            this._keepAliveOpen = this.open;
            this.open = false;
        }
        if (this.hasOwnProperty('bankChangeDialogVisible')) {
            this._keepAliveChangeOpen = this.bankChangeDialogVisible;
            this.bankChangeDialogVisible = false;
        }
    },
    // keep-alive 激活时，恢复弹窗状态
    activated() {
        if (this._keepAliveOpen && this.hasOwnProperty('open')) {
            this.open = this._keepAliveOpen;
        }
        if (this._keepAliveChangeOpen && this.hasOwnProperty('bankChangeDialogVisible')) {
            this.bankChangeDialogVisible = this._keepAliveChangeOpen;
        }
    }
};
