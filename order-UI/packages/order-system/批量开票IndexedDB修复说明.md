# 批量开票 IndexedDB 重构说明

## 问题分析

原始问题：在 `executeBatchInvoice` 函数中，虽然能获取到 `selectedRecordId` 和 `maybeKey`，但是 IndexedDB 中的 `operated` 字段没有被成功更新，导致页面中 `CompanysList.vue` 的"已操作"列没有变化。

## 根本原因

1. **数据结构过于复杂**：
   - 原始设计存储了完整的模板对象，包含大量冗余数据
   - 使用自增主键和复杂的版本管理，增加了查找和更新的复杂度
   - 数据关联方式复杂，通过 `uniqueKey` 和版本号进行关联

2. **ID 概念混淆**：
   - `CompanysList.vue` 中存储的 `row.id` 是公司列表中的行ID（业务层面的公司聚合ID）
   - IndexedDB 中存储的是自增主键，两者不匹配
   - 需要通过复杂的 `uniqueKey` 进行关联查找

## 重构方案

### 1. 简化 IndexedDB 结构

**新的数据库设计**：
- 数据库版本：从 1 升级到 2
- 存储表名：从 `excel_templates` 改为 `company_operated`
- 主键：直接使用公司ID（`companyId`）
- 数据结构：只存储 `{ companyId: number, operated: boolean }`

**新的操作函数**：
```javascript
// 导入模板公司数据，提取公司ID并初始化已操作状态
export async function importTemplateCompanies(templateList)

// 根据公司ID标记为已操作
export async function markCompanyOperated(companyId)

// 根据公司ID数组批量标记为已操作
export async function markCompaniesOperated(companyIds)

// 获取所有已操作状态映射（以公司ID为键）
export async function getOperatedMap()

// 清空所有已操作记录
export async function clearAllOperatedRecords()

// 调试函数：查看所有已操作记录
export async function debugGetAllOperatedRecords()
```

### 2. 修改 CompanysList.vue

**修改前**：
```javascript
// 唯一键：与模板侧保持一致（id::name）
makeKey(row) {
    return `${row.id || 0}::${row.name || ''}`;
}
// 存储uniqueKey
sessionStorage.setItem('companyList_selected_unique_key', uniqueKey);
```

**修改后**：
```javascript
// 获取公司ID（直接使用row.id作为公司ID）
getCompanyId(row) {
    return Number(row.id) || null;
}
// 存储公司ID
sessionStorage.setItem('companyList_selected_company_id', companyId);
```

### 3. 修改 InvoiceBody.vue

**修改前**：
```javascript
const selectedUniqueKey = sessionStorage.getItem('companyList_selected_unique_key');
await markOperatedByUniqueKey(version, selectedUniqueKey);
```

**修改后**：
```javascript
const selectedCompanyId = sessionStorage.getItem('companyList_selected_company_id');
await markCompanyOperated(Number(selectedCompanyId));
```

### 4. 修改 SheetList.vue

**修改前**：
```javascript
await upsertTemplates(this.currentVersion, templates);
this.templateOperatedMap = await getOperatedMap(this.currentVersion);
```

**修改后**：
```javascript
await importTemplateCompanies(templates);
this.templateOperatedMap = await getOperatedMap();
```

## 数据流程

1. **Excel导入阶段**：
   - 用户上传Excel文件，系统解析模板数据
   - 调用 `importTemplateCompanies(templates)` 清空旧数据并导入新数据
   - 从模板中提取公司ID，在IndexedDB中创建 `{ companyId, operated: false }` 记录

2. **公司选择阶段**：
   - 用户在 `CompanysList.vue` 中点击"检索"按钮
   - 系统调用 `handleFilterOrders(row)` 方法
   - 获取 `companyId = getCompanyId(row)` (直接使用 `row.id`)
   - 存储到 `sessionStorage.setItem('companyList_selected_company_id', companyId)`

3. **开票执行阶段**：
   - 用户在 `InvoiceBody.vue` 中点击"开具发票"按钮
   - 系统调用 `executeBatchInvoice` 方法
   - 从 `sessionStorage` 获取 `selectedCompanyId`
   - 调用 `markCompanyOperated(companyId)` 直接更新 IndexedDB
   - 发送 `excel:operated-updated` 事件通知 UI 更新

4. **UI 更新阶段**：
   - `SheetList.vue` 监听 `excel:operated-updated` 事件
   - 重新从 IndexedDB 获取 `operatedMap`
   - 更新 `CompanysList.vue` 中的"已操作"状态显示

## 测试验证

重构后，可以通过以下方式验证：

1. 打开浏览器开发者工具的控制台
2. 执行完整的开票流程
3. 观察控制台输出：
   - `selectedCompanyId` 的值
   - `markCompanyOperated: 开始标记公司为已操作` 日志
   - `markCompanyOperated: 更新现有记录` 或 `markCompanyOperated: 创建新记录` 日志
   - `debugGetAllOperatedRecords` 的输出，确认 `operated` 字段已更新为 `true`

## 重构优势

1. **简化数据结构**：
   - 只存储必要的 `operated` 状态，减少存储空间
   - 使用公司ID作为主键，直接定位，无需复杂查找

2. **提高性能**：
   - 直接通过主键查找，无需遍历和索引
   - 减少数据传输量，提高操作速度

3. **降低复杂度**：
   - 移除版本管理，简化数据关联
   - 统一使用公司ID，避免ID概念混淆

4. **增强可靠性**：
   - 每次导入前清空旧数据，避免数据污染
   - 主键重复时自动更新，确保数据一致性

## 注意事项

1. **数据库升级**：版本号从1升级到2，会自动删除旧表并创建新表
2. **数据迁移**：旧数据会被清空，这是预期行为
3. **调试功能**：生产环境可以移除 `debugGetAllOperatedRecords` 等调试函数
4. **错误处理**：所有操作都有完善的错误处理和日志输出

## 相关文件

- `packages/order-system/src/api/excelTemplateStore.js` - IndexedDB 操作函数
- `packages/order-system/src/views/dashboard/components/common/CompanysList.vue` - 公司列表组件
- `packages/order-system/src/views/dashboard/components/common/InvoiceBody.vue` - 开票处理组件
- `packages/order-system/src/views/dashboard/components/common/SheetList.vue` - 主控制器组件
