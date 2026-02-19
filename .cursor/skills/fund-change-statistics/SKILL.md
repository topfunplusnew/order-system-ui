---
name: fund-change-statistics
description: 生成资金变动统计功能的模板组件和调用逻辑。当用户需要创建资金变动统计、数据对比弹窗、修改前后差异展示，或询问资金变动统计相关需求时使用。
---

# 资金变动统计功能开发指南

本 Skill 用于生成资金变动统计功能，包括多个模板组件的创建和调用。

## 功能概述

资金变动统计功能用于展示系统中各个模块的数据修改记录，通过"修改前"、"修改后"、"差额"三行对比，清晰展示数据变化。

接口的详情定义在 docs\资金变动统计相关接口\资金变动统计.openapi.json 中（这些接口如果还没有实现，需要先实现）

1、先调一个接口 拿总逻辑：
接口地址 /system/backuplog/v3/calculateAmounts 
响应结构（此结构为一个三层KEY的结构）：
```json
{
    "msg": "操作成功",
    "code": 200,
    "data": {
        "supplierTotalBalance": {
            "inventory_main": {
                "default": 0
            },
            "goodsorder": {
                "default": 74681.41
            },
            "allinvoice": {
                "default": 0
            }
        },
        "companyTotalBalance": {
            "goodsorder": {
                "default": 75980.48
            },
            "receivemoney": {
                "default": -230937
            }
        },
        "remainingInventoryAmount": {
            "inventory_main": {
                "default": 0
            },
            "goodsorder": {
                "default": 0
            }
        },
        "selfCompanyTotalFunds": {
            "payment": {
                "default": -1045.08
            },
            "receivemoney": {
                "default": 231027
            }
        },
        "driverUnpaidAmount": {
            "inventory_main": {
                "default": 0
            },
            "goodsorder": {
                "default": 2708.3
            }
        }
    }
}
```

通过上述接口返回的数据中，任意的一个对象组成的三级key（比如对于driverUnpaidAmount，三级key的三级分别为 driverUnpaidAmount、inventory_main、default 和 driverUnpaidAmount、goodsorder、default这两种）

然后将三级结构，通过特定传递方式给/system/backuplog/v3/filterIdsByCategory接口传递：
```sh
curl --location --request GET 'http://60.205.5.253:60036/system/backuplog/v3/filterIdsByCategory?outputKey=supplierTotalBalance&tableName=inventory_main&category=default&backupDate=2026-02-05&firstTargetDate=2026-02-05&secondTargetDate=2026-02-09' \
--header 'OSR;' \
--header 'Authorization: Bearer dev-mode-admin-token-2025'
```

接口会返回若干id：
```json
{
    "msg": "操作成功",
    "code": 200,
    "data": [
        146911
    ]
}
```

2、然后将id作为一个数组 同时调俩接口
两个接口分别返回差额详情数据：
（1）接口地址 /system/backuplog/v3/getByIds
响应结构定义（下面的originalinfo和changedinfo是基于订单这个模块，其他模块字段可能不同，但都会被封装到originalInfo和changedInfo中）：
```json
{
    "msg": "操作成功",
    "code": 200,
    "data": [
        {
            "createBy": null,
            "createTime": null,
            "updateBy": null,
            "updateTime": null,
            "remark": null,
            "selfBankCardType": null,
            "otherBankCardType": null,
            "id": 146911,
            "tableName": "inventory_main",
            "backupTime": "2026-02-09 14:28:25",
            "originalTargetTime": "2025-11-23 16:33:21",
            "changedTargetTime": "2025-11-23 16:33:21",
            "backupType": "update",
            "backupUserTruename": "刘振龙",
            "backupUserId": 1050,
            "originalInfo": {
                "id": 71,
                "fleet": "客户自提",
                "params": {},
                "remark": null,
                "userId": 1018,
                "addtime": "2025-11-23 16:37:04",
                "delFlag": 0,
                "comments": null,
                "createBy": null,
                "seaCarID": null,
                "seaCarNo": null,
                "showFlag": 0,
                "updateBy": null,
                "userName": "张璐鑫",
                "landCarID": 1659,
                "landCarNo": "冀ER7906",
                "seaBankNo": null,
                "storeDate": "2025-11-23 16:33:21",
                "allTonnage": 7.72,
                "checkState": "未审核",
                "createTime": null,
                "landBankNo": "6228481258976466378",
                "updateTime": "2025-11-26 15:35:53",
                "checkUserId": 1047,
                "seaBankName": null,
                "goodsCompany": null,
                "landBankName": null,
                "seaDriverTel": null,
                "storeHouseid": 52,
                "allSeaFreight": 0.0,
                "landDriverTel": "18703394882",
                "seaDriverName": null,
                "allLandFreight": 3700.0,
                "attachmentList": [
                    {
                        "id": 3456,
                        "flag": "path",
                        "params": {},
                        "remark": null,
                        "delFlag": 0,
                        "createBy": "张蕊",
                        "fileName": "订单单子.png",
                        "filePath": "/profile/upload/2025/11/27/订单单子_20251127145026A033.png",
                        "updateBy": null,
                        "extraInfo": {},
                        "createTime": "2025-11-27 14:50:26",
                        "fileSuffix": "png",
                        "updateTime": null,
                        "selfBankCardType": null,
                        "otherBankCardType": null
                    },
                    {
                        "id": 3457,
                        "flag": "path",
                        "params": {},
                        "remark": null,
                        "delFlag": 0,
                        "createBy": "张蕊",
                        "fileName": "装车费.png",
                        "filePath": "/profile/upload/2025/11/27/装车费_20251127145036A034.png",
                        "updateBy": null,
                        "extraInfo": {},
                        "createTime": "2025-11-27 14:50:36",
                        "fileSuffix": "png",
                        "updateTime": null,
                        "selfBankCardType": null,
                        "otherBankCardType": null
                    }
                ],
                "landDriverName": "黄英涛",
                "storeHouseName": "于双成仓库",
                "allFreightPrice": 0.0,
                "selfBankCardType": null,
                "metaDataTableName": "inventory_main",
                "otherBankCardType": null,
                "inventoryDetailList": [
                    {
                        "id": 185,
                        "erro": 0.2,
                        "index": 1,
                        "packs": 2.0,
                        "price": 16.4,
                        "width": 2440.0,
                        "height": 5.0,
                        "length": 3660.0,
                        "mainId": 71,
                        "params": {},
                        "pieces": 72.0,
                        "profit": 100.0,
                        "remark": null,
                        "addtime": null,
                        "delFlag": 0,
                        "freight": 3700.0,
                        "levelID": 9066,
                        "tonnage": 7.72,
                        "comments": "这到货费50/包 这车货卖给苏豫客户没钱 还剩4包货拉回沙河放在于双成库房 回来的运费总共2500元咱们承担，还有1000元的压车费，还有200的信息费",
                        "createBy": null,
                        "payments": "10545.02",
                        "supplier": "周口项城苏豫",
                        "updateBy": null,
                        "levelName": "北玻Lowe160",
                        "otherCost": null,
                        "storeDate": "2025-11-23 16:33:21",
                        "createTime": null,
                        "seaFreight": null,
                        "sundryCost": -3800.0,
                        "supplierId": 1089,
                        "updateTime": null,
                        "landFreight": 3700.0,
                        "profitNoTax": 100.0,
                        "stockNumber": 72.0,
                        "actualPieces": 0.0,
                        "countingUnit": "片",
                        "mainComments": null,
                        "storeHouseid": null,
                        "exWareHoustId": null,
                        "paymentUnload": 16.4,
                        "piecesPerPack": 36.0,
                        "additionalFees": 3700.0,
                        "paymentFactory": 6745.02,
                        "storeHouseName": null,
                        "logisticsProfit": null,
                        "isIncludeTaxSale": 0,
                        "landFreightPrice": null,
                        "selfBankCardType": null,
                        "factoryCommission": null,
                        "metaDataTableName": "inventory_detail",
                        "otherBankCardType": null,
                        "customerCommission": null,
                        "paymentsWithSundry": null,
                        "factoryRebateAmount": null,
                        "isIncludeTaxFactory": 0,
                        "factoryDiscountAmount": null
                    },
                    {
                        "id": 190,
                        "erro": 0.0,
                        "index": 2,
                        "packs": 1.0,
                        "price": 100.0,
                        "width": 1.0,
                        "height": 1.0,
                        "length": 1.0,
                        "mainId": 71,
                        "params": {},
                        "pieces": 1.0,
                        "profit": -100.0,
                        "remark": null,
                        "addtime": null,
                        "delFlag": 0,
                        "freight": 0.0,
                        "levelID": 15014,
                        "tonnage": 0.0,
                        "createBy": null,
                        "payments": "0.00",
                        "supplier": "于双成",
                        "updateBy": null,
                        "levelName": "装卸费",
                        "otherCost": null,
                        "storeDate": "2025-11-23 16:33:21",
                        "createTime": null,
                        "seaFreight": null,
                        "sundryCost": null,
                        "supplierId": 123,
                        "updateTime": null,
                        "landFreight": 0.0,
                        "profitNoTax": -100.0,
                        "stockNumber": 1.0,
                        "actualPieces": 1.0,
                        "countingUnit": "其他",
                        "mainComments": null,
                        "storeHouseid": null,
                        "exWareHoustId": null,
                        "paymentUnload": null,
                        "piecesPerPack": 1.0,
                        "additionalFees": null,
                        "paymentFactory": 100.0,
                        "storeHouseName": null,
                        "logisticsProfit": null,
                        "isIncludeTaxSale": 0,
                        "landFreightPrice": null,
                        "selfBankCardType": null,
                        "factoryCommission": null,
                        "metaDataTableName": "inventory_detail",
                        "otherBankCardType": null,
                        "customerCommission": null,
                        "paymentsWithSundry": null,
                        "factoryRebateAmount": null,
                        "isIncludeTaxFactory": 0,
                        "factoryDiscountAmount": null
                    }
                ],
                "frontendAttachmentIds": []
            },
            "originalInfoId": "71",
            "changedInfo": {
                "id": 71,
                "fleet": "客户自提",
                "params": {},
                "remark": null,
                "userId": 1018,
                "addtime": "2025-11-23 16:37:04",
                "delFlag": 0,
                "comments": null,
                "createBy": null,
                "seaCarID": null,
                "seaCarNo": null,
                "showFlag": 0,
                "updateBy": null,
                "userName": "张璐鑫",
                "landCarID": 1659,
                "landCarNo": "冀ER7906",
                "seaBankNo": null,
                "storeDate": "2025-11-23 16:33:21",
                "allTonnage": 7.72,
                "checkState": "未审核",
                "createTime": null,
                "landBankNo": "6228481258976466378",
                "updateTime": "2026-02-09 14:28:24",
                "checkUserId": 1047,
                "seaBankName": null,
                "goodsCompany": null,
                "landBankName": null,
                "seaDriverTel": null,
                "storeHouseid": 52,
                "allSeaFreight": 0.0,
                "landDriverTel": "18703394882",
                "seaDriverName": null,
                "allLandFreight": 3700.0,
                "attachmentList": [
                    {
                        "id": 3456,
                        "flag": "path",
                        "params": {},
                        "remark": null,
                        "delFlag": 0,
                        "createBy": "张蕊",
                        "fileName": "订单单子.png",
                        "filePath": "/profile/upload/2025/11/27/订单单子_20251127145026A033.png",
                        "updateBy": null,
                        "extraInfo": {},
                        "createTime": "2025-11-27 14:50:26",
                        "fileSuffix": "png",
                        "updateTime": null,
                        "selfBankCardType": null,
                        "otherBankCardType": null
                    },
                    {
                        "id": 3457,
                        "flag": "path",
                        "params": {},
                        "remark": null,
                        "delFlag": 0,
                        "createBy": "张蕊",
                        "fileName": "装车费.png",
                        "filePath": "/profile/upload/2025/11/27/装车费_20251127145036A034.png",
                        "updateBy": null,
                        "extraInfo": {},
                        "createTime": "2025-11-27 14:50:36",
                        "fileSuffix": "png",
                        "updateTime": null,
                        "selfBankCardType": null,
                        "otherBankCardType": null
                    }
                ],
                "landDriverName": "黄英涛",
                "storeHouseName": "于双成仓库",
                "allFreightPrice": 0.0,
                "selfBankCardType": null,
                "metaDataTableName": "inventory_main",
                "otherBankCardType": null,
                "inventoryDetailList": [
                    {
                        "id": 185,
                        "erro": 0.2,
                        "index": 1,
                        "packs": 2.0,
                        "price": 16.4,
                        "width": 2440.0,
                        "height": 5.0,
                        "length": 3660.0,
                        "mainId": 71,
                        "params": {},
                        "pieces": 72.0,
                        "profit": 100.0,
                        "remark": null,
                        "addtime": null,
                        "delFlag": 0,
                        "freight": 3700.0,
                        "levelID": 9066,
                        "tonnage": 7.72,
                        "comments": "这到货费50/包 这车货卖给苏豫客户没钱 还剩4包货拉回沙河放在于双成库房 回来的运费总共2500元咱们承担，还有1000元的压车费，还有200的信息费",
                        "createBy": null,
                        "payments": "10545.02",
                        "supplier": "周口项城苏豫",
                        "updateBy": null,
                        "levelName": "北玻Lowe160",
                        "otherCost": null,
                        "storeDate": "2025-11-23 16:33:21",
                        "createTime": null,
                        "seaFreight": null,
                        "sundryCost": -3800.0,
                        "supplierId": 1089,
                        "updateTime": null,
                        "landFreight": 3700.0,
                        "profitNoTax": 100.0,
                        "stockNumber": 72.0,
                        "actualPieces": 0.0,
                        "countingUnit": "片",
                        "mainComments": null,
                        "storeHouseid": null,
                        "exWareHoustId": null,
                        "paymentUnload": 16.4,
                        "piecesPerPack": 36.0,
                        "additionalFees": 3700.0,
                        "paymentFactory": 6745.02,
                        "storeHouseName": null,
                        "logisticsProfit": null,
                        "isIncludeTaxSale": 0,
                        "landFreightPrice": null,
                        "selfBankCardType": null,
                        "factoryCommission": null,
                        "metaDataTableName": "inventory_detail",
                        "otherBankCardType": null,
                        "customerCommission": null,
                        "paymentsWithSundry": null,
                        "factoryRebateAmount": null,
                        "isIncludeTaxFactory": 0,
                        "factoryDiscountAmount": null
                    },
                    {
                        "id": 190,
                        "erro": 0.0,
                        "index": 2,
                        "packs": 1.0,
                        "price": 100.0,
                        "width": 1.0,
                        "height": 1.0,
                        "length": 1.0,
                        "mainId": 71,
                        "params": {},
                        "pieces": 1.0,
                        "profit": -100.0,
                        "remark": null,
                        "addtime": null,
                        "delFlag": 0,
                        "freight": 0.0,
                        "levelID": 15014,
                        "tonnage": 0.0,
                        "createBy": null,
                        "payments": "0.00",
                        "supplier": "于双成",
                        "updateBy": null,
                        "levelName": "装卸费",
                        "otherCost": null,
                        "storeDate": "2025-11-23 16:33:21",
                        "createTime": null,
                        "seaFreight": null,
                        "sundryCost": null,
                        "supplierId": 123,
                        "updateTime": null,
                        "landFreight": 0.0,
                        "profitNoTax": -100.0,
                        "stockNumber": 0.0,
                        "actualPieces": 0.0,
                        "countingUnit": "其他",
                        "mainComments": null,
                        "storeHouseid": null,
                        "exWareHoustId": null,
                        "paymentUnload": null,
                        "piecesPerPack": 1.0,
                        "additionalFees": null,
                        "paymentFactory": 100.0,
                        "storeHouseName": null,
                        "logisticsProfit": null,
                        "isIncludeTaxSale": 0,
                        "landFreightPrice": null,
                        "selfBankCardType": null,
                        "factoryCommission": null,
                        "metaDataTableName": "inventory_detail",
                        "otherBankCardType": null,
                        "customerCommission": null,
                        "paymentsWithSundry": null,
                        "factoryRebateAmount": null,
                        "isIncludeTaxFactory": 0,
                        "factoryDiscountAmount": null
                    }
                ],
                "frontendAttachmentIds": []
            },
            "uuid": "6112a1ff-a354-4ba2-a6e2-977ce5dc245e",
            "version": 3
        }
    ]
}
```

（2）通过调用/system/backuplog/v3/calculateByIds接口可以获取到底部小表格
响应结构：
```json
{
    "msg": "操作成功",
    "code": 200,
    "data": {
        "supplierTotalBalance": {
            "inventory_main": {
                "default": 0
            }
        },
        "remainingInventoryAmount": {
            "inventory_main": {
                "default": 0
            }
        },
        "driverUnpaidAmount": {
            "inventory_main": {
                "default": 0
            }
        }
    }
}

```

差额详情数据，就是本SKILL中，这些模板所使用的对比数据。**模板组件接收的 `compareData` 即 getByIds 接口返回的 `data` 数组**。

**单条备份记录（backup log record）结构**：

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | number | 备份日志主键 |
| `tableName` | string | 业务表名（inventory_main、goodsorder、receivemoney、payment 等） |
| `backupTime` | string | 备份操作时间 |
| `originalTargetTime` | string | 修改前目标时间 |
| `changedTargetTime` | string | 修改后目标时间 |
| `backupType` | string | 备份类型：update、insert 等 |
| `backupUserTruename` | string | 备份操作人姓名 |
| `backupUserId` | number | 备份操作人 ID |
| `originalInfo` | Object | **修改前的完整业务数据** |
| `changedInfo` | Object | **修改后的完整业务数据** |
| `originalInfoId` | string | 原业务记录 ID (可以通过业务表明+此id 联查到对应信息，本项目中有相关的函数) |
| `uuid` | string | 记录唯一标识 |
| `version` | number | 版本号 |

`originalInfo` / `changedInfo` 的结构随 `tableName` 不同而不同，各模板需通过 `mapBeforeRow`、`mapAfterRow`、`buildDiffFields` 按业务表字段进行映射。

底部小表格 就是在详情组件中，底部的统计信息

### 涉及模块

根据 `@docs/apifox-docs/系统修改变动统计表.xlsx`，包含以下模块：

1. **⓪库存金额变动**: 入库管理、二次出库、订单调整单
2. **①客户欠款变动**: 订单调整单、票点、收款、付款、冲抵款、平账
3. **②所有银行卡资金变动**: 收款、付款、借入款、从我司借款、期货保证金、厂家保证金、收取保证金
4. **③欠厂家货款变动**: 入库管理、订单调整单、票点、收款、付款、冲抵款、平账
5. **④未支付运费变动**: 入库、订单、付款
6. **⑤其他应收**: 从我司借款
7. **⑥期货保证金变动**
8. **⑦厂家保证金变动**
9. **⑧收取保证金变动**
10. **⑨公司从外面借款变动**

## 开发步骤

### 步骤 1: 创建模板组件目录结构

在 `packages\ui-components\components` 下创建：

```
components/
├── FundChangeTemplates/
│   ├── InventoryChangeTemplate.vue      # 入库管理模板
│   ├── SecondOutboundTemplate.vue       # 二次出库模板
│   ├── OrderAdjustmentTemplate.vue      # 订单调整单模板
│   ├── TicketPointTemplate.vue          # 票点模板
│   ├── ReceiveMoneyTemplate.vue         # 收款模板
│   ├── PaymentTemplate.vue              # 付款模板
│   ├── OffsetPaymentTemplate.vue        # 冲抵款模板
│   ├── BalanceAccountTemplate.vue       # 平账模板
│   ├── BorrowInTemplate.vue             # 借入款管理模板
│   ├── BorrowFromCompanyTemplate.vue    # 员工或公司从我司借款模板
│   ├── FuturesDepositTemplate.vue       # 期货保证金模板
│   ├── SupplierDepositTemplate.vue      # 厂家保证金模板
│   └── ReceiveDepositTemplate.vue       # 收取保证金模板
```

### 步骤 2: 模板组件通用结构

每个模板组件遵循以下结构，**核心特性**：通过 `columns` 配置为每一列指定聚合公式（默认求和），实现摘要区的统一计算。

#### 2.1 列配置与聚合器

列配置 `columns` 中每个元素支持：

| 字段 | 类型 | 说明 |
|------|------|------|
| `prop` | string | 对应行数据的字段名 |
| `label` | string | 表头标题 |
| `width` | number/string | 列宽（可选） |
| `fixed` | boolean | 是否固定列（可选） |
| `aggregator` | string \| Function | 聚合方式，见下表 |
| `summaryLabel` | string | 摘要区展示的标签，不填则用 `label` |
| `showSummary` | boolean | 是否参与摘要计算，默认 `true`（非数值列通常为 `false`） |

**聚合器（aggregator）**：

| 值 | 说明 | 适用场景 |
|----|------|----------|
| `'sum'` | 求和（默认） | 金额类差额 |
| `'absSum'` | 绝对值求和 | 需忽略正负的汇总 |
| `'avg'` | 平均值 | 单价、比例等 |
| `'max'` / `'min'` | 最大/最小值 | 极值统计 |
| `'count'` | 计数（非空项） | 条数统计 |
| `'none'` | 不参与聚合 | 仅展示列 |
| `Function(values, context)` | 自定义函数 | 复杂公式 |

**自定义聚合函数签名**：

```javascript
/**
 * @param {number[]} values - 差额行该列的值（已转 number）
 * @param {Object} context - { diffRows, precision }
 * @returns {string} 格式化后的结果
 */
(values, context) => string
```

#### 2.2 内置聚合器工具

在 `utils/fundChangeAggregators.js` 中维护，供各模板复用：

```javascript
import { format, add, subtract, abs, divide } from 'mathjs';
import _ from 'lodash';

/** 内置聚合器：求和 */
export const sumAggregator = (values, { precision = 2 } = {}) =>
  _.reduce(values, (acc, v) => format(add(acc, Number(v) || 0), { notation: 'fixed', precision }), 0);

/** 内置聚合器：绝对值求和 */
export const absSumAggregator = (values, { precision = 2 } = {}) =>
  _.reduce(values, (acc, v) => format(add(acc, abs(Number(v) || 0)), { notation: 'fixed', precision }), 0);

/** 内置聚合器：平均值 */
export const avgAggregator = (values, { precision = 2 } = {}) => {
  const arr = _.filter(_.map(values, v => (_.isNumber(v) ? v : Number(v))), v => !_.isNaN(v));
  if (_.isEmpty(arr)) return format(0, { notation: 'fixed', precision });
  const total = _.reduce(arr, (acc, v) => add(acc, v), 0);
  return format(divide(total, arr.length), { notation: 'fixed', precision });
};

/** 聚合器映射，供模板按字符串引用 */
export const AGGREGATOR_MAP = {
  sum: sumAggregator,
  absSum: absSumAggregator,
  avg: avgAggregator,
  max: (values) => format(_.max(_.map(values, v => Number(v) || 0)) || 0, { notation: 'fixed', precision: 2 }),
  min: (values) => format(_.min(_.map(values, v => Number(v) || 0)) || 0, { notation: 'fixed', precision: 2 }),
  count: (values) => String(_.filter(values, v => v != null && v !== '').length),
  none: () => '-'
};
```

#### 2.3 模板组件结构 （可以参考 packages\ui-components\components\OrderAdjustmentChangeTemplate 的目录结构，也就是每一个模板都需要用一个目录表示，目录中存放该模版的相关信息，同时OrderAdjustmentChangeTemplate还需要进行整改，所有的模板文件 如果不是按照以下标准编写，都需要进行重构）

```vue
<script>
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { AGGREGATOR_MAP } from '@/utils/fundChangeAggregators';

export default {
  name: 'XxxTemplate',
  props: {
    /** getByIds 接口返回的 data 数组，每项含 originalInfo、changedInfo */
    compareData: { type: Array, default: () => [] },
    moduleName: { type: String, default: '' }
  },
  data() {
    return { tableData: [] };
  },
  computed: {
    /** 列配置：每列可指定 aggregator，默认 sum */
    columns() {
      return [
        { prop: 'label', label: '类型', width: 100, fixed: true, showSummary: false },
        { prop: 'customerDiff', label: '客户变动差额', aggregator: 'absSum', summaryLabel: '客户变动差额汇总' },
        { prop: 'supplierDiff', label: '供应商变动差额', aggregator: 'absSum', summaryLabel: '供应商变动差额汇总' },
        { prop: 'amount', label: '金额', aggregator: 'sum' }
        // 自定义公式示例：{ prop: 'ratio', label: '占比', aggregator: (values, ctx) => format(divide(_.sum(values), ctx.diffRows.length), { notation: 'fixed', precision: 2 }) }
      ];
    },
    /** 差额行 */
    diffRows() {
      return this.tableData.filter(r => r.rowType === 'diff');
    },
    /** 摘要映射：key 为 prop，value 为计算后的展示值 */
    summaryMap() {
      const map = {};
      this.columns.forEach(col => {
        if (col.showSummary === false) return;
        const values = _.map(this.diffRows, col.prop).map(v => Number(v) || 0);
        const agg = _.isFunction(col.aggregator)
          ? col.aggregator
          : (AGGREGATOR_MAP[col.aggregator] || AGGREGATOR_MAP.sum);
        map[col.prop] = agg(values, { diffRows: this.diffRows, precision: 2 });
      });
      return map;
    }
  },
  created() {
    this.processData();
  },
  methods: {
    /**
     * 处理数据：遍历 compareData（getByIds 的 data），每条记录生成修改前/修改后/差额三行
     * 各模板可重写 mapBeforeRow、mapAfterRow、buildDiffFields 以适配不同 tableName 的 originalInfo/changedInfo 结构
     */
    processData() {
      this.tableData = [];
      (this.compareData || []).forEach((record, index) => {
        const original = record.originalInfo || {};
        const changed = record.changedInfo || {};
        const beforeRow = { ...this.mapBeforeRow(original, record, index), rowType: 'before', label: `记录(${index + 1})`, subLabel: '修改前' };
        const afterRow = { ...this.mapAfterRow(changed, record, index), rowType: 'after', label: '', subLabel: '修改后' };
        const diffRow = { rowType: 'diff', label: '', subLabel: '差额', ...this.buildDiffFields(original, changed, record) };
        this.tableData.push(beforeRow, afterRow, diffRow);
      });
    },
    /** 将 originalInfo 转为表格行，可重写以按业务表字段映射 */
    mapBeforeRow(info, record, index) {
      return info;
    },
    /** 将 changedInfo 转为表格行，可重写以按业务表字段映射 */
    mapAfterRow(info, record, index) {
      return info;
    },
    /** 计算差额行字段，各模板必须按 columns 中 showSummary 的 prop 实现 */
    buildDiffFields(original, changed, record) {
      return {
        customerDiff: this.calculateFieldDiff(changed.customerAmount, original.customerAmount),
        supplierDiff: this.calculateFieldDiff(changed.supplierAmount, original.supplierAmount),
        amount: this.calculateFieldDiff(changed.amount, original.amount)
      };
    },
    /** 计算单字段差额（mathjs 高精度） */
    calculateFieldDiff(afterVal, beforeVal) {
      const after = Number(afterVal || 0);
      const before = Number(beforeVal || 0);
      return format(subtract(after, before), { notation: 'fixed', precision: 2 });
    },
    tableRowClassName({ row }) {
      if (row.rowType === 'before') return 'before-row';
      if (row.rowType === 'after') return 'after-row';
      if (row.rowType === 'diff') return 'diff-row';
      return '';
    },
    handleProcess() { return Promise.resolve(); },
    handleReject() { return Promise.resolve(); }
  }
};
</script>

<template>
  <div class="fund-change-template">
    <el-table :data="tableData" border :row-class-name="tableRowClassName" style="width: 100%">
      <el-table-column
        v-for="col in columns"
        :key="col.prop"
        :prop="col.prop"
        :label="col.label"
        :width="col.width"
        :fixed="col.fixed"
      />
    </el-table>
    <div class="summary-section" v-if="diffRows.length">
      <div class="summary-item" v-for="col in columns.filter(c => c.showSummary !== false)" :key="col.prop">
        <span class="summary-label">{{ col.summaryLabel || col.label }}：</span>
        <span class="summary-value">{{ summaryMap[col.prop] }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.fund-change-template { padding: 20px; }
::v-deep .before-row { background-color: #f0f9ff; }
::v-deep .after-row { background-color: #fff7e6; }
::v-deep .diff-row { background-color: #fff1f0; font-weight: bold; }
.summary-section {
  margin-top: 20px; padding: 10px; background: #f5f5f5; border-radius: 4px;
  display: flex; flex-wrap: wrap; gap: 16px 24px;
}
.summary-item { font-size: 14px; }
.summary-label { color: #606266; }
.summary-value { font-weight: bold; margin-left: 4px; }
</style>
```

#### 2.4 设计要点

1. **列驱动**：表格列与摘要项由同一份 `columns` 配置生成，避免重复定义。
2. **可扩展聚合**：通过 `aggregator` 支持内置类型和自定义函数，满足不同业务公式。
3. **统一精度**：聚合器通过 `precision` 参数控制，保证与 mathjs 一致。
4. **按需摘要**：`showSummary: false` 的列不参与摘要计算、不展示汇总行。

#### 2.5 数据结构与扩展点

`compareData` 即 getByIds 的 `data` 数组。每条记录含 `originalInfo`（修改前）、`changedInfo`（修改后），结构随 `tableName` 变化。

| tableName | 主表字段示例 | 子表/嵌套 |
|-----------|-------------|----------|
| inventory_main | storeDate, storeHouseName, allLandFreight | inventoryDetailList |
| goodsorder | allPayments, ordersNo | - |
| receivemoney | moneyAmount, companyType | - |

各模板需重写以下方法以适配本表结构：

- **mapBeforeRow(info, record, index)**：从 `originalInfo` 提取/聚合成表格行字段。
- **mapAfterRow(info, record, index)**：从 `changedInfo` 提取/聚合成表格行字段。
- **buildDiffFields(original, changed, record)**：计算差额行各列值，返回对象 key 需与 `columns` 中参与摘要的 `prop` 一致。

示例（inventory_main 主表字段直接透传）：

```javascript
mapBeforeRow(info) {
  return { storeDate: info.storeDate, storeHouseName: info.storeHouseName, /* ... */ };
},
buildDiffFields(original, changed) {
  return {
    inventoryDiff: this.calcInventoryDetailDiff(original.inventoryDetailList, changed.inventoryDetailList),
    freightDiff: this.calculateFieldDiff(changed.allLandFreight, original.allLandFreight)
  };
}
```

### 步骤 3: 在主页面中调用模板

在需要展示资金变动统计的页面中（如 `MoneyChangeTotalAmount.vue`），使用 `openDialog` 调用模板：

```javascript
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import InventoryChangeTemplate from './components/FundChangeTemplates/InventoryChangeTemplate.vue';
import SecondOutboundTemplate from './components/FundChangeTemplates/SecondOutboundTemplate.vue';
// ... 导入其他模板

export default {
  mixins: [common_dialog],
  methods: {
    /**
     * 打开指定模块的变动详情弹窗
     * @param {string} moduleName - 模块名称
     * @param {Array} compareData - 对比数据
     */
    openModuleDetail(moduleName, compareData) {
      const templateMap = {
        'inventory': {
          component: InventoryChangeTemplate,
          title: '入库管理变动详情',
          width: '1500px'
        },
        'secondOutbound': {
          component: SecondOutboundTemplate,
          title: '二次出库变动详情',
          width: '1500px'
        },
        'orderAdjustment': {
          component: OrderAdjustmentTemplate,
          title: '订单调整单变动详情',
          width: '1500px'
        },
        // ... 其他模块映射
      };
      
      const template = templateMap[moduleName];
      if (template) {
        this.openDialog(
          template.component,
          template.title,
          template.width,
          {
            compareData,
            moduleName
          },
          false,
          false
        );
      } else {
        this.$message.warning('未找到对应的模板组件');
      }
    }
  }
};
```

### 步骤 4: 具体模板字段映射

根据 Excel 表格中的字段，为每个模板配置对应的列：

#### 入库管理模板字段

- 状态、入库时间、仓库、陆运车牌、海运柜号、海运公司
- 供应商、级别名称、计量单位
- 厚度、长度、宽度、每包片数、包数、出厂片数
- 出厂单价、出厂是否含税、杂费、出厂货款
- 库存量(片数)、卸货价、存货价、原库存金额、原库存金额(含税)
- 库存变动差额、供应商变动差额、运费变动差额

#### 二次出库模板字段

- 二次入库状态、仓库名称、出库方向、变动日期(出库)
- 产品级别、厚度、长度、宽度、出库量
- 存货价、原库存金额

#### 订单调整单模板字段

- 订单编号、客户名称、供应商名称
- 产品级别、厚度、长度、宽度
- 调整类型、调整数量、调整单价
- 客户变动差额、供应商变动差额、库存变动差额、运费变动差额

## 关键注意事项

### 1. 数学计算必须使用 mathjs

```javascript
import { add, subtract, multiply, divide, format, abs } from 'mathjs';

// 计算差额
const diff = subtract(afterValue, beforeValue);

// 格式化保留2位小数
const formatted = format(diff, { notation: 'fixed', precision: 2 });
```

### 2. 响应式数据处理

```javascript
// 使用 Vue.set 或 this.$set 确保响应式
this.$set(this.tableData, index, newValue);

// 或使用数组方法
this.tableData = [...this.tableData];
```

### 3. 表单初始化

```javascript
// 使用函数返回新对象
getInitForm() {
  return {
    compareData: [],
    moduleName: ''
  };
}

data() {
  return {
    form: this.getInitForm()
  };
}
```

### 4. JSDocs 注释

所有函数必须添加 JSDocs：

```javascript
/**
 * 处理数据：将 compareData 转换为表格展示格式
 * @param {Array} compareData - 对比数据数组
 * @returns {Array} 处理后的表格数据
 */
processData(compareData) {
  // ...
}
```

### 5. 所有的代码，能够从order-system这个包中拆出就拆出，不要全部堆叠到order-system包，因为本项目采用monorepo管理，有shared包和ui-components包，可以将一些公共逻辑拆分到这里来

## 复用现有逻辑

在开发前，检查以下位置是否有可复用的组件和逻辑：

1. **弹窗组件**: `@/views/dashboard/backuplog/ChooseModule.vue`
2. **对比逻辑**: `@/views/dashboard/backuplog/goodsorder/CommonChange.vue`
3. **枚举定义**: `order-system/src/api/tool/enums` 中的 `TableName` 和 `moduleNames`
4. **通用混入**: `common_dialog` mixin

## 开发检查清单

开发完成后，确认以下事项：

- [ ] 所有函数都添加了 JSDocs 注释
- [ ] 所有数学计算都使用了 mathjs
- [ ] 表单初始化使用了函数返回新对象
- [ ] 检查并复用了现有的组件和逻辑
- [ ] 表格数据保持响应式
- [ ] 差额计算准确（修改后 - 修改前）
- [ ] 样式符合项目规范
- [ ] 弹窗宽度合适（建议 1500px）
- [ ] 关闭弹窗时正确清理数据

## 示例：完整的入库管理模板

详见 [InventoryChangeTemplate.md](./templates/InventoryChangeTemplate.md)

## 调试建议

1. 使用 `console.log` 或 `this.$log` 输出中间数据
2. 检查 `compareData` 的数据结构是否正确
3. 验证 mathjs 计算结果的精度
4. 测试多条记录的展示效果
5. 检查差额行的高亮样式



特别注意，已经写好的一个案例 可以参考 packages\ui-components\components\FundChangeTemplates\InventoryChangeTemplate\index.vue 这个组件的模式（包括表格中主子表的展示（若有），和表格下方底部小表格的展示）