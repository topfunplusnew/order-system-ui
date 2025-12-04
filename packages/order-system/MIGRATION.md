# 迁移指南

## 概述

项目已重构为 Monorepo 结构，但**所有业务代码和 views 目录保持不变**。

## 重要说明

✅ **views 目录完全不变**
- `src/views/` 目录结构保持不变
- 所有视图组件、路由、mixins 都保持原样
- 不需要修改任何视图相关的代码

✅ **业务逻辑不变**
- API 调用逻辑不变
- Store 模块不变
- 组件内部逻辑不变

## 如何使用新的共享包

### 1. 使用共享工具函数

**之前：**
```javascript
import { getToken } from '@/utils/auth';
```

**现在（可选，两种方式都可以）：**
```javascript
// 方式1：使用 workspace 包
import { getToken } from '@order-system/shared/utils/auth';

// 方式2：使用别名
import { getToken } from '@shared/utils/auth';

// 方式3：继续使用原有路径（仍然有效）
import { getToken } from '@/utils/auth';
```

### 2. 使用共享组件

**之前：**
```javascript
import Pagination from '@/components/Pagination';
```

**现在（可选）：**
```javascript
// 方式1：使用 workspace 包
import { Pagination } from '@order-system/ui-components';

// 方式2：使用别名
import { Pagination } from '@ui-components';

// 方式3：继续使用原有路径（仍然有效）
import Pagination from '@/components/Pagination';
```

### 3. 使用共享常量

```javascript
import { API_BASE_URL, HTTP_STATUS } from '@order-system/shared/constants';
```

## 配置变更

### ESLint 配置
- 现在使用共享的 ESLint 配置
- 配置在 `packages/config/eslint-config/` 中统一管理

### Babel 配置
- 现在使用共享的 Babel 配置
- 配置在 `packages/config/babel-config/` 中统一管理

## 下一步操作

1. **安装依赖**
   ```bash
   yarn install
   ```

2. **验证项目**
   ```bash
   yarn order
   ```

3. **逐步迁移（可选）**
   - 可以将通用组件迁移到 `ui-components`
   - 可以将通用工具函数迁移到 `shared`
   - 这些迁移都是可选的，不影响现有功能

## 常见问题

### Q: 我需要修改 views 目录下的代码吗？
A: **不需要**。views 目录结构完全不变，所有代码都可以继续正常工作。

### Q: 原有的引用路径还能用吗？
A: **可以**。所有原有的路径（如 `@/views/`、`@/components/`）都保持不变。

### Q: 如何开始使用新的共享包？
A: 这是**可选的**。你可以继续使用原有路径，也可以逐步迁移到新的共享包。

### Q: 如果遇到依赖问题怎么办？
A: 运行 `yarn install` 重新安装依赖，确保 workspace 包正确链接。

