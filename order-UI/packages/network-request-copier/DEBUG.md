# 调试指南

如果扩展一直显示"加载中"，请按照以下步骤排查：

## 1. 检查 Service Worker 状态

1. 打开 Chrome 扩展管理页面：`chrome://extensions/`
2. 找到"网络请求复制器"扩展
3. 点击"service worker"链接（在"检查视图"下方）
4. 查看控制台是否有错误信息

**正常情况应该看到：**
```
Network Request Copier Service Worker started
Request store initialized, current size: 0
```

## 2. 检查扩展权限

1. 在扩展管理页面，确保扩展已启用
2. 点击"详细信息"
3. 检查"网站访问权限"是否已授予
4. 确保"在所有网站上"或"在您访问的网站上"已启用

## 3. 测试消息传递

在 Service Worker 控制台中，手动测试：

```javascript
// 测试获取请求列表
chrome.runtime.sendMessage({ action: 'getAllRequests' }, (response) => {
  console.log('Response:', response);
});
```

如果返回 `undefined`，说明 Service Worker 没有正确响应。

## 4. 检查网络请求拦截

1. 访问任意网页（如 https://www.baidu.com）
2. 在 Service Worker 控制台中查看是否有日志输出
3. 应该能看到类似这样的日志：
```
Request completed: GET https://www.baidu.com 200
```

## 5. 常见问题

### 问题1：Service Worker 未启动

**症状：** 点击扩展图标后一直显示"加载中"

**解决方法：**
1. 在扩展管理页面，点击扩展的"重新加载"按钮
2. 刷新扩展的 popup 窗口
3. 如果还是不行，尝试禁用后重新启用扩展

### 问题2：没有请求数据

**症状：** 显示"暂无请求数据"

**解决方法：**
1. 确保已访问过网页（扩展只能拦截已访问网页的请求）
2. 在网页中执行一些操作（如点击按钮、提交表单）以触发网络请求
3. 点击扩展的"刷新"按钮

### 问题3：权限未授予

**症状：** 控制台显示权限错误

**解决方法：**
1. 在扩展管理页面，点击"详细信息"
2. 确保"网站访问权限"已设置为"在所有网站上"
3. 如果提示需要权限，点击"允许"

### 问题4：消息传递失败

**症状：** popup 显示"连接失败"

**解决方法：**
1. 检查 Service Worker 是否正在运行
2. 在 Service Worker 控制台中查看是否有错误
3. 尝试重新加载扩展

## 6. 手动测试步骤

1. **打开扩展 popup**
   - 点击浏览器工具栏中的扩展图标

2. **打开 Service Worker 控制台**
   - 访问 `chrome://extensions/`
   - 找到扩展，点击"service worker"

3. **访问测试网页**
   - 打开新标签页，访问 https://www.baidu.com
   - 观察 Service Worker 控制台是否有请求日志

4. **刷新扩展 popup**
   - 点击扩展图标
   - 点击"刷新"按钮
   - 应该能看到请求列表

## 7. 重置扩展

如果以上方法都不行，尝试重置：

1. 在扩展管理页面，点击"移除"删除扩展
2. 重新加载扩展目录
3. 确保所有文件都在正确的位置

## 8. 检查文件完整性

确保以下文件存在且内容正确：

- `manifest.json` - 扩展配置
- `background.js` - Service Worker 脚本
- `popup.html` - 弹出窗口 HTML
- `popup.js` - 弹出窗口脚本
- `content.js` - 内容脚本
- `icons/icon16.png` - 图标文件（16x16）
- `icons/icon48.png` - 图标文件（48x48）
- `icons/icon128.png` - 图标文件（128x128）

## 9. 联系支持

如果问题仍然存在，请提供以下信息：

1. Chrome 版本
2. 扩展版本
3. Service Worker 控制台的错误信息
4. 浏览器控制台的错误信息（F12 打开）
5. 操作步骤和预期结果

