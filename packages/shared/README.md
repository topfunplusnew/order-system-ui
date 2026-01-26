# @order-system/shared

共享工具函数、常量、类型定义、Mixins 和管理器。

## 安装

```bash
yarn add @order-system/shared
```

## 使用

### 工具函数

```javascript
import {
  // 通用工具
  debounce,
  deepClone,
  uniqueArr,
  createUniqueString,
  objectMerge,
  isEmpty,
  
  // URL 处理
  getQueryObject,
  param,
  param2Obj,
  
  // 字符串处理
  titleCase,
  camelCase,
  isNumberStr,
  html2Text,
  byteLength,
  
  // DOM 操作
  hasClass,
  addClass,
  removeClass,
  toggleClass,
  
  // 验证工具
  isEmail,
  isPhone,
  isExternal,
  
  // 日期工具
  formatDate,
  
  // 格式化工具
  formatNumber,
  formatCurrency
} from '@order-system/shared';
```

### Mixins

```javascript
import { 
  tableColumnMixin,
  columnVisibilityMixin,
  dialogRouteMixin 
} from '@order-system/shared';

export default {
  mixins: [tableColumnMixin, columnVisibilityMixin],
  // ...
};
```

### 管理器

```javascript
import { 
  ConfigManager, 
  createConfigManager,
  dialogManager 
} from '@order-system/shared';

// 使用 ConfigManager
const config = createConfigManager({
  tableColumns: [...],
  defaultForm: {...}
});

// 使用 DialogManager
dialogManager.registerDialog(routePath, dialogId, this);
```

## 目录结构

```
shared/
├── index.js           # 入口文件
├── utils/             # 工具函数
│   ├── auth.js        # 认证相关
│   ├── common.js      # 通用工具
│   ├── date.js        # 日期处理
│   ├── format.js      # 格式化
│   ├── scroll-to.js   # 滚动工具
│   ├── validate.js    # 验证工具
│   └── index.js
├── mixins/            # Vue Mixins
│   ├── tableColumnMixin.js
│   ├── columnVisibilityMixin.js
│   ├── dialogRouteMixin.js
│   └── index.js
├── managers/          # 管理器类
│   ├── ConfigManager.js
│   ├── DialogManager.js
│   └── index.js
├── constants/         # 常量定义
│   └── index.js
└── types/             # 类型定义
    └── index.js
```
