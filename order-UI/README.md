
## 项目技术栈、优化方式、组件使用

#### 技术栈 Vue2 , webpack
```bash
vue-ui || vue-cli
```

#### 缓存webpack编译结果 
```bash
npm install hard-source-webpack-plugin --save-dev
```
应用webpack
```js
const HardSourceWebpackPlugin = require('hard-source-webpack-plugin');

module.exports = {
  configureWebpack: {
    plugins: [
      new HardSourceWebpackPlugin()
    ]
  }
};
```
