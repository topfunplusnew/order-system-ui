# @order-system/config

共享配置文件包，包含 ESLint、Babel、Prettier 等工具的配置。

## 使用方式

### ESLint 配置

在 `.eslintrc.js` 中：

```javascript
module.exports = {
	extends: ['@order-system/config/eslint-config']
};
```

### Babel 配置

在 `babel.config.js` 中：

```javascript
module.exports = require('@order-system/config/babel-config');
```

### Prettier 配置

在 `.prettierrc.js` 中：

```javascript
module.exports = require('@order-system/config/prettier-config');
```

## 目录结构

```
config/
├── eslint-config/    # ESLint 配置
├── babel-config/     # Babel 配置
├── prettier-config/  # Prettier 配置
└── index.js          # 入口文件
```

