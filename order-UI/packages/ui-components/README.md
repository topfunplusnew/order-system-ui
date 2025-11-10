# @order-system/ui-components

共享UI组件库，包含可在多个应用中复用的通用组件。

## 使用方式

### 全局注册

```javascript
import Vue from 'vue';
import UIComponents from '@order-system/ui-components';

Vue.use(UIComponents);
```

### 按需引入

```javascript
import { Pagination, DictTag } from '@order-system/ui-components';

export default {
	components: {
		Pagination,
		DictTag
	}
};
```

## 组件列表

- Pagination - 分页组件
- RightToolbar - 右侧工具栏
- DictTag - 字典标签
- SvgIcon - SVG图标
- ImageUpload - 图片上传
- FileUpload - 文件上传
- ImagePreview - 图片预览
- Editor - 富文本编辑器

## 注意事项

这些组件是从 `order-system/src/components` 中提取的通用组件。
业务相关的组件（如 OrderDisplay, NeedToShow 等）保留在原位置。

