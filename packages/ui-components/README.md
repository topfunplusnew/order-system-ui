# @order-system/ui-components

共享 UI 组件库，基于 Vue 2 + Element UI。

## 安装

```bash
yarn add @order-system/ui-components
```

## 使用

### 全局注册

```javascript
import Vue from 'vue';
import UiComponents from '@order-system/ui-components';

Vue.use(UiComponents);
```

### 按需导入

```javascript
import { Pagination, RightToolbar, DictTag } from '@order-system/ui-components';

export default {
  components: {
    Pagination,
    RightToolbar,
    DictTag
  }
};
```

## 组件列表

### 基础组件

| 组件 | 描述 |
|------|------|
| `Pagination` | 分页组件 |
| `RightToolbar` | 右侧工具栏（列显隐、刷新等） |
| `DictTag` | 字典标签显示 |
| `SvgIcon` | SVG 图标组件 |
| `ShowLabel` | 标签显示组件 |

### 布局组件

| 组件 | 描述 |
|------|------|
| `Breadcrumb` | 面包屑导航 |
| `Hamburger` | 汉堡菜单按钮 |
| `Screenfull` | 全屏切换组件 |

### 上传组件

| 组件 | 描述 |
|------|------|
| `ImageUpload` | 图片上传 |
| `FileUpload` | 文件上传 |
| `ImagePreview` | 图片预览 |

### 编辑器

| 组件 | 描述 |
|------|------|
| `Editor` | 富文本编辑器（基于 Quill） |

## 目录结构

```
ui-components/
├── index.js              # 入口文件
├── components/
│   ├── Pagination/
│   ├── RightToolbar/
│   ├── DictTag/
│   ├── SvgIcon/
│   ├── ImageUpload/
│   ├── FileUpload/
│   ├── ImagePreview/
│   ├── Editor/
│   ├── Breadcrumb/
│   ├── Hamburger/
│   ├── Screenfull/
│   └── ShowLabel/
└── package.json
```

## 依赖

- `vue`: ^2.6.12
- `element-ui`: ^2.15.14
- `@order-system/shared`: *
- `screenfull`: 5.0.2
