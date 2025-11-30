# 网络请求复制器浏览器扩展

这是一个 Chrome 浏览器扩展，用于拦截网络请求并复制请求信息。

## 功能特性

- ✅ 拦截所有 HTTP/HTTPS 网络请求
- ✅ 显示请求列表（方法、URL、状态码）
- ✅ 一键复制请求信息，包括：
  - 请求方法（GET、POST、PUT、DELETE 等）
  - 请求地址（完整 URL）
  - 请求载荷（Request Body）
  - 响应结构（状态码、响应头）

## 安装方法

### 开发模式安装

1. 打开 Chrome 浏览器
2. 访问 `chrome://extensions/`
3. 开启右上角的"开发者模式"
4. 点击"加载已解压的扩展程序"
5. 选择 `packages/network-request-copier` 目录

### 打包安装

1. 在扩展管理页面点击"打包扩展程序"
2. 选择 `packages/network-request-copier` 目录
3. 生成 `.crx` 文件后安装

## 使用方法

### 方法一：使用浮动按钮

1. 访问任意网页
2. 页面右下角会出现一个蓝色圆形按钮（📋）
3. 点击按钮打开请求列表面板
4. 在列表中点击"复制"按钮即可复制该请求的信息

### 方法二：使用扩展图标

1. 点击浏览器工具栏中的扩展图标
2. 在弹出的窗口中查看请求列表
3. 点击"复制"按钮复制请求信息

### 方法三：使用右键菜单

1. 在网页任意位置右键
2. 选择"复制请求信息"
3. 会打开请求列表面板

## 复制的内容格式

复制的数据为 JSON 格式，包含以下字段：

```json
{
  "请求方法": "POST",
  "请求地址": "https://api.example.com/users",
  "请求载荷": {
    "name": "John",
    "email": "john@example.com"
  },
  "响应结构": {
    "状态码": 200,
    "响应头": [
      {
        "name": "Content-Type",
        "value": "application/json"
      }
    ]
  }
}
```

## 注意事项

- 扩展需要访问所有网站的权限才能拦截网络请求
- 最多存储 1000 个请求记录，超出会自动删除最旧的记录
- 只显示已完成的请求（包括成功和失败的请求）
- 请求载荷可能因为格式问题无法完全解析，会显示原始数据

## 技术栈

- Manifest V3
- Chrome Web Request API
- Content Scripts
- Service Worker

## 文件结构

```text
network-request-copier/
├── manifest.json       # 扩展配置文件
├── background.js       # 后台服务脚本（拦截请求）
├── content.js          # 内容脚本（页面交互）
├── popup.html          # 弹出窗口 HTML
├── popup.js            # 弹出窗口脚本
├── icons/              # 扩展图标
│   ├── icon16.png
│   ├── icon48.png
│   └── icon128.png
└── README.md           # 说明文档
```

## 开发说明

### 修改权限

如果需要修改权限，编辑 `manifest.json` 中的 `permissions` 和 `host_permissions` 字段。

### 自定义样式

修改 `content.js` 中的 CSS 样式来自定义浮动按钮和面板的外观。

### 数据格式

修改 `background.js` 中的 `formatRequestData` 函数来自定义复制数据的格式。

## 许可证

MIT
