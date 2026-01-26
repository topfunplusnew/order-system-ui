---
name: vue2-page-development
description: 生成符合订单管理系统规范的 Vue2 CRUD 页面。当用户需要创建新页面、新功能、表格页面、表单弹窗，或询问项目代码规范时使用。
---

# Vue2 页面开发指南

本项目基于 Vue2 + Element UI + Yarn Workspaces Monorepo 架构。

## 项目结构

```
packages/
├── order-system/          # 主应用
│   └── src/
│       ├── api/           # API 接口封装
│       ├── components/    # 业务组件
│       ├── mixins/        # Vue mixins
│       ├── store/         # Vuex 状态管理
│       ├── utils/         # 工具函数
│       └── views/         # 页面组件
├── shared/                # 共享库 @order-system/shared
│   ├── mixins/            # 通用 mixins
│   ├── managers/          # ConfigManager, DialogManager
│   └── utils/             # 通用工具函数
└── ui-components/         # UI组件库 @order-system/ui-components
```

## 技术栈约束

- **必须**: Vue2 + Options API + JavaScript
- **禁止**: TypeScript、Vue3 Composition API、class-style 语法
- **数学计算**: 必须使用 mathjs 库

## 创建新页面步骤

### 1. API 接口封装

在 `packages/order-system/src/api/` 下创建接口文件：

```javascript
import request from '@/utils/request';

// 查询列表
export function listXxx(query) {
  return request({
    url: '/system/xxx/list',
    method: 'get',
    params: query
  });
}

// 查询详情
export function getXxx(id) {
  return request({ url: '/system/xxx/' + id, method: 'get' });
}

// 新增
export function addXxx(data) {
  return request({ url: '/system/xxx', method: 'post', data });
}

// 修改
export function updateXxx(data) {
  return request({ url: '/system/xxx', method: 'put', data });
}

// 删除
export function delXxx(id) {
  return request({ url: '/system/xxx/' + id, method: 'delete' });
}
```

### 2. 页面组件结构

详见 [page-template.md](page-template.md)

## 表单处理规范

### 初始化表单（必须遵守）

```javascript
// 正确：使用函数返回新对象
getInitForm() {
  return {
    id: undefined,
    name: '',
    status: '0'
  };
}

// data 中初始化
data() {
  return {
    form: this.getInitForm()
  };
}
```

### 新增操作

```javascript
handleAdd() {
  this.reset();
  this.open = true;
  this.title = '新增XXX';
}

reset() {
  this.form = this.getInitForm();
  this.$nextTick(() => {
    this.$refs.form?.resetFields();
  });
}
```

### 编辑操作

```javascript
handleUpdate(row) {
  this.reset();
  const id = row.id || this.ids[0];
  getXxx(id).then(res => {
    // 必须深拷贝，禁止直接引用
    this.form = JSON.parse(JSON.stringify(res.data));
    this.open = true;
    this.title = '修改XXX';
  });
}
```

### 关闭弹窗

```javascript
cancel() {
  this.open = false;
  this.$nextTick(() => {
    this.form = this.getInitForm();
    this.$refs.form?.resetFields();
  });
}
```

## 常用 Mixins

从 `@order-system/shared` 导入：

```javascript
import { tableColumnMixin, columnVisibilityMixin, dialogRouteMixin } from '@order-system/shared';

export default {
  mixins: [tableColumnMixin, columnVisibilityMixin],
  // ...
};
```

- `tableColumnMixin`: 表格列宽拖拽、排序
- `columnVisibilityMixin`: 列显隐控制
- `dialogRouteMixin`: 弹窗路由集成

## UI 组件使用

从 `@order-system/ui-components` 导入：

```javascript
import { Pagination, RightToolbar, DictTag } from '@order-system/ui-components';
```

| 组件 | 用途 |
|------|------|
| `Pagination` | 分页 |
| `RightToolbar` | 右侧工具栏（列设置、刷新） |
| `DictTag` | 字典标签 |
| `FileUpload` | 文件上传 |
| `ImageUpload` | 图片上传 |
| `Editor` | 富文本编辑器 |

## 权限控制

使用 `v-hasPermi` 指令：

```html
<el-button v-hasPermi="['system:xxx:add']">新增</el-button>
<el-button v-hasPermi="['system:xxx:edit']">修改</el-button>
<el-button v-hasPermi="['system:xxx:remove']">删除</el-button>
<el-button v-hasPermi="['system:xxx:export']">导出</el-button>
```

## 代码规范

1. 单文件不超过 500 行，复杂逻辑拆分到独立 `.js` 文件
2. 简单判断用三元表达式
3. 接口返回值使用可选链 `res?.data?.list`
4. 数组防空：`list || []`
5. CSS 精简，不写多余样式
6. 不添加不必要的 DOM 层级

## 模板文件

- [page-template.md](page-template.md) - 完整页面模板
- [dialog-form.md](dialog-form.md) - 弹窗表单模板
