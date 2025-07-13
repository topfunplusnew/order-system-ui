# UploadFilesButton 组件

一个支持多文件上传和管理的 Vue 组件，提供紧凑的 UI 界面和完整的文件管理功能。

## 🎨 UI 设计

组件采用紧凑的盒子布局，宽度约 120px，包含：
- **主按钮**: "上传附件" 按钮，带上传图标和加载状态
- **查看按钮**: 右侧显示已上传文件数量，点击查看文件列表
- **统一容器**: 两个按钮在同一个带边框的容器中，flex布局

## 功能特性

- ✅ 多文件上传支持
- ✅ 文件类型和大小限制
- ✅ 已上传文件列表查看
- ✅ 图片预览功能
- ✅ 文件下载和删除
- ✅ 状态管理和清除功能
- ✅ 紧凑的一体化布局
- ✅ 自定义样式和配置

## 基本使用

```vue
<template>
  <UploadFilesButton 
    @files-updated="handleFilesUpdated"
    ref="uploadButton"
  />
</template>

<script>
import UploadFilesButton from '@/components/UploadFilesButton';

export default {
  components: {
    UploadFilesButton
  },
  methods: {
    handleFilesUpdated(params) {
      console.log('上传的文件参数:', params);
      // params 结构:
      // {
      //   params: {
      //     attachmentIds: [1, 2, 3]
      //   }
      // }
    }
  }
};
</script>
```

## Props 配置

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| acceptTypes | String | '*' | 接受的文件类型，如 'image/*,.pdf,.doc' |
| maxFiles | Number | 10 | 最大文件数量限制 |
| maxFileSize | Number | 10 | 单个文件大小限制（MB） |
| flag | String | 'uploadButton' | 上传标识，用于区分不同模块的上传 |
| extraInfo | Object | {} | 上传时的额外信息 |

## 事件

| 事件名 | 说明 | 参数 |
|--------|------|------|
| files-updated | 文件列表更新时触发 | params: { params: { attachmentIds: [] } } |

## 方法

通过 ref 调用组件方法：

| 方法名 | 说明 | 返回值 |
|--------|------|--------|
| clearUploadedFiles() | 清除所有已上传文件的状态 | - |
| getUploadParams() | 获取当前上传参数 | { params: { attachmentIds: [] } } |

## 完整示例

```vue
<template>
  <div>
    <!-- 自定义配置的上传组件 -->
    <UploadFilesButton 
      :max-files="5"
      :max-file-size="20"
      accept-types="image/*,.pdf,.doc,.docx"
      flag="paymentAttachment"
      :extra-info="{ moduleId: 123, type: 'payment' }"
      @files-updated="handleFilesUpdated"
      ref="uploadButton"
    />

    <!-- 操作按钮 -->
    <el-button @click="getCurrentParams">获取当前参数</el-button>
    <el-button @click="clearFiles">清空文件</el-button>
  </div>
</template>

<script>
import UploadFilesButton from '@/components/UploadFilesButton';

export default {
  components: {
    UploadFilesButton
  },
  methods: {
    handleFilesUpdated(params) {
      console.log('文件参数更新:', params);
      // 这里可以将 params 保存到表单数据中
      this.formData = { ...this.formData, ...params };
    },

    getCurrentParams() {
      const params = this.$refs.uploadButton.getUploadParams();
      console.log('当前参数:', params);
    },

    // 在表单关闭或重置时调用
    clearFiles() {
      this.$refs.uploadButton.clearUploadedFiles();
    }
  }
};
</script>
```

## 使用场景

1. **表单附件上传**: 在各种表单中添加附件上传功能
2. **文档管理**: 管理和查看已上传的文档文件
3. **图片上传**: 支持图片预览的上传功能
4. **批量文件处理**: 支持多文件同时上传和管理

## 样式定制

组件提供了 SCSS 样式，可以通过 CSS 变量或覆盖样式类来自定义外观：

```scss
// 自定义按钮样式
.upload-files-button {
  .el-button {
    border-radius: 6px;
    // 其他自定义样式...
  }
}

// 自定义对话框样式
.upload-files-dialog {
  // 自定义对话框样式...
}
```

## 注意事项

1. 确保项目中已正确配置 `addAttachments` API
2. 在表单关闭时记得调用 `clearUploadedFiles()` 方法清除状态
3. 文件上传大小和类型限制可根据后端接口要求调整
4. 组件依赖 Element UI，确保项目中已正确引入
