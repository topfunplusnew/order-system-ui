# 图标文件说明

请在此目录下放置以下尺寸的图标文件：

- `icon16.png` - 16x16 像素
- `icon48.png` - 48x48 像素  
- `icon128.png` - 128x128 像素

## 图标建议

可以使用以下方式创建图标：

1. **在线工具**：
   - https://www.favicon-generator.org/
   - https://realfavicongenerator.net/

2. **图标设计**：
   - 建议使用剪贴板或网络请求相关的图标
   - 可以使用 📋 或 🔗 等符号作为设计元素

3. **临时方案**：
   - 可以使用纯色图片作为临时图标
   - 或者从其他扩展中借用图标进行测试

## 快速创建临时图标

可以使用 ImageMagick 或在线工具创建简单的纯色图标：

```bash
# 使用 ImageMagick（如果已安装）
convert -size 16x16 xc:#409EFF icon16.png
convert -size 48x48 xc:#409EFF icon48.png
convert -size 128x128 xc:#409EFF icon128.png
```

或者使用在线工具生成：https://www.favicon-generator.org/

