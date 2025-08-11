---
mode: agent
---
现在，以下文件中，都使用了UploadFilesButton组件：
* packages/order-system/src/views/system/OilCardConsume/index.vue
* packages/order-system/src/views/system/businesstrip/index.vue
* packages/order-system/src/views/system/carapply/index.vue
* packages/order-system/src/views/system/inventoryMain/index.vue
* packages/order-system/src/views/system/invoiceIn/index.vue
* packages/order-system/src/views/system/invoiceOther/index.vue
* packages/order-system/src/views/system/invoiceOther/invoicehave.vue
* packages/order-system/src/views/system/invoiceOut/index.vue
* packages/order-system/src/views/system/noneInvoice/InvoiceIn.vue
* packages/order-system/src/views/system/noneInvoice/InvoiceOut.vue
* packages/order-system/src/views/system/oilRecharge/index.vue
* packages/order-system/src/views/system/oilcard/index.vue
* packages/order-system/src/views/system/payment/index.vue
* packages/order-system/src/views/system/paymentApply/index.vue
* packages/order-system/src/views/system/receiveMoney/index.vue
* packages/order-system/src/views/system/record/index.vue
* packages/order-system/src/views/system/secondinventory/index.vue

payment/index.vue 和 receiveMoney/index.vue可以作为上传文件的示例，这两个文件也使用了UploadFilesButton，他们实现的效果就是，可以实现当在表格中点击修改按钮的时候，将通过请求获取的数据中的attachmentList字段，传递给UploadFilesButton组件，并实现文件的展示，并且，由于UploadFilesButton可以支持上传文件并拿到id，也可以通过重新传递到表单中的params属性的方式重新传递给后端，你需要仔细观察payment/index.vue 和 receiveMoney/index.vue对于UploadFilesButton的使用，并参考进行修改

我有以下要求：
1. 你首先就需要仔细的观察payment/index.vue对于UploadFilesButton的使用，并认真参考。
2. 你需要将这种用法应用到其他需要上传文件的地方，比如receiveMoney/index.vue，确保在表格中点击修改按钮时，能够正确传递attachmentList字段给UploadFilesButton组件。