# Keep-Alive弹窗状态管理使用示例

## 如何在组件中使用

```javascript
// 在需要keep-alive弹窗管理的组件中
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import keepAliveDialog from '@/views/dashboard/mixins/keepAliveDialog';

export default {
  name: 'YourComponent',
  mixins: [common_dialog, keepAliveDialog],
  data() {
    return {
      // 普通的弹窗状态（会被keepAliveDialog自动管理）
      open: false,
      dialogVisible: false,
      // 其他数据...
    };
  },
  methods: {
    // 打开动态弹窗的方法
    handleOpenDynamicDialog() {
      // 使用common_dialog的openDialog方法
      this.openDialog(
        'YourDialogComponent', // 组件名或组件对象
        '弹窗标题',
        '800px', // 宽度
        { prop1: 'value1' }, // 传递给子组件的props
        false // 是否隐藏确认按钮
      );
    },
    
    // 打开普通弹窗的方法
    handleOpenNormalDialog() {
      this.open = true; // 这个状态会被keepAliveDialog自动管理
    }
  }
};
```

## 工作原理（已优化状态缓存）

1. **页面激活状态**：
   - 普通弹窗：正常显示
   - 动态弹窗：正常创建和显示，组件状态正常

2. **页面失活时**（切换到其他页面）：
   - 普通弹窗：记录状态并隐藏 (`open: true -> false`)
   - 动态弹窗：**保存组件内部状态**，隐藏弹窗但**不销毁实例**

3. **页面重新激活时**（切换回来）：
   - 普通弹窗：恢复之前的状态 (`false -> true`)
   - 动态弹窗：显示弹窗并**恢复组件内部状态**

## 新增功能：组件状态缓存

### DialogWrapper 组件现在支持：
- 使用 `<keep-alive>` 包裹动态组件
- 自动保存和恢复组件的 `$data` 状态
- 失活时调用 `hideDialog()`，激活时调用 `showDialog()`
- 设置 `:destroy-on-close="false"` 防止组件销毁

### 状态缓存机制：
1. **保存状态**：在失活时自动保存动态组件的所有数据状态
2. **恢复状态**：在激活时自动恢复之前保存的状态
3. **keep-alive 支持**：内部组件被 keep-alive 包裹，确保组件不被销毁

## 注意事项

1. 确保组件同时引入 `common_dialog` 和 `keepAliveDialog` 两个 mixin
2. `keepAliveDialog` 应该放在 `common_dialog` 之后，以确保方法能够正确覆盖
3. 组件必须被 `<keep-alive>` 包裹才能触发 `activated` 和 `deactivated` 钩子
4. 动态弹窗的子组件需要实现 `handleProcess` 和 `handleReject` 方法
5. **新增**：现在弹窗中的表单数据、输入值等都会被自动保存和恢复

## 支持的弹窗状态属性

- 以 `Visible` 结尾的布尔属性（如：`dialogVisible`、`modalVisible`）
- 以 `visible` 结尾的布尔属性（如：`visible`）
- 名为 `open` 的布尔属性

## 示例场景

假设您有一个订单编辑弹窗，用户已经填写了部分表单数据：

1. 用户打开订单编辑弹窗，填写了客户名称、金额等信息
2. 用户切换到其他页面（弹窗自动隐藏，但状态保存）
3. 用户切换回来（弹窗重新显示，之前填写的内容依然存在）

这样就实现了真正的状态保持，用户不会丢失已经输入的数据。
