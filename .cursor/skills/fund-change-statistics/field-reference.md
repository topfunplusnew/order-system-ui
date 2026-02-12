# 各模块字段参考

根据 `@docs/apifox-docs/系统修改变动统计表.xlsx`，以下是各模块的字段列表。

**与 SKILL 衔接说明**：本文档列出的是**模板表格展示的目标字段**（即 `mapBeforeRow` / `mapAfterRow` 输出、`columns` 的 `prop`）。实际数据来自 getByIds 的 `originalInfo` / `changedInfo`，其字段名可能与下表不同（如 API 的 `storeDate` 映射为展示用的 `inboundTime`），需在 `mapBeforeRow` / `mapAfterRow` 中完成映射。差额字段（`xxxDiff`）在 `buildDiffFields` 中计算，其 key 需与 `columns` 中 `showSummary: true` 的 `prop` 一致。

## 入库管理

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| status | 状态 | String | '已入库' |
| inboundTime | 入库时间 | Date | '2026-01-15' |
| warehouse | 仓库 | String | '刘彦波仓库' |
| truckPlate | 陆运车牌 | String | '鄂A12345' |
| containerNo | 海运柜号 | String | 'ABCD1234567' |
| shippingCompany | 海运公司 | String | '中远海运' |
| supplierName | 供应商 | String | '湖北三峡' |
| gradeName | 级别名称 | String | '湖北三峡欧洲灰原片优等品' |
| unit | 计量单位 | String | '片' |
| thickness | 厚度 | Number | 7.2 |
| length | 长度 | Number | 3660 |
| width | 宽度 | Number | 2250 |
| piecesPerPack | 每包片数 | Number | 52 |
| packCount | 包数 | Number | 10 |
| factoryPieces | 出厂片数 | Number | 520 |
| factoryPrice | 出厂单价 | Number | 20.97 |
| includeTax | 出厂是否含税 | String | '是' |
| miscFee | 杂费 | Number | 100.00 |
| factoryPayment | 出厂货款 | Number | 10904.40 |
| inventoryPieces | 库存量(片数) | Number | 520 |
| unloadPrice | 卸货价 | Number | 21.00 |
| stockPrice | 存货价 | Number | 20.97 |
| originalInventoryAmount | 原库存金额 | Number | 8979.77 |
| originalInventoryAmountTax | 原库存金额(含税) | Number | 10104.40 |
| inventoryDiff | 库存变动差额 | Number | 20.23 |
| supplierDiff | 供应商变动差额 | Number | 100.00 |
| freightDiff | 运费变动差额 | Number | 50.00 |

## 二次出库

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| secondInboundStatus | 二次入库状态 | String | '已入库' |
| warehouse | 仓库名称 | String | '刘彦波仓库' |
| outboundDirection | 出库方向 | String | '二次入库出库' |
| outboundDate | 变动日期(出库) | Date | '2026-01-15' |
| gradeName | 产品级别 | String | '湖北三峡欧洲灰原片优等品' |
| thickness | 厚度 | Number | 7.2 |
| length | 长度 | Number | 3660 |
| width | 宽度 | Number | 2250 |
| outboundQuantity | 出库量 | Number | 52 |
| stockPrice | 存货价 | Number | 20.97 |
| originalInventoryAmount | 原库存金额 | Number | 8979.77 |
| inventoryDiff | 库存变动差额 | Number | -20.23 |

## 订单调整单

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| orderNo | 订单编号 | String | 'ORD20260115001' |
| customerName | 客户名称 | String | '某某公司' |
| supplierName | 供应商名称 | String | '湖北三峡' |
| gradeName | 产品级别 | String | '湖北三峡欧洲灰原片优等品' |
| thickness | 厚度 | Number | 7.2 |
| length | 长度 | Number | 3660 |
| width | 宽度 | Number | 2250 |
| adjustType | 调整类型 | String | '价格调整' |
| adjustQuantity | 调整数量 | Number | 10 |
| adjustPrice | 调整单价 | Number | 1.00 |
| customerDiff | 客户变动差额 | Number | 10.00 |
| supplierDiff | 供应商变动差额 | Number | -10.00 |
| inventoryDiff | 库存变动差额 | Number | 0.00 |
| freightDiff | 运费变动差额 | Number | 0.00 |

## 票点

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| ticketType | 票点类型 | String | '增值税专用发票' |
| customerName | 客户名称 | String | '某某公司' |
| supplierName | 供应商名称 | String | '湖北三峡' |
| ticketAmount | 票点金额 | Number | 1000.00 |
| ticketRate | 票点比例 | Number | 0.03 |
| ticketFee | 票点费用 | Number | 30.00 |
| customerDiff | 客户变动差额 | Number | 30.00 |
| supplierDiff | 供应商变动差额 | Number | -30.00 |

## 收款

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| receiveDate | 收款日期 | Date | '2026-01-15' |
| customerName | 客户名称 | String | '某某公司' |
| supplierName | 供应商名称 | String | '湖北三峡' |
| bankCardNo | 银行卡号 | String | '6222021234567890' |
| bankName | 银行名称 | String | '工商银行' |
| receiveAmount | 收款金额 | Number | 10000.00 |
| receiveType | 收款类型 | String | '客户付款' |
| customerDiff | 客户变动差额 | Number | -10000.00 |
| supplierDiff | 供应商变动差额 | Number | 0.00 |
| bankCardDiff | 银行卡资金变动 | Number | 10000.00 |

## 付款

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| paymentDate | 付款日期 | Date | '2026-01-15' |
| customerName | 客户名称 | String | '某某公司' |
| supplierName | 供应商名称 | String | '湖北三峡' |
| bankCardNo | 银行卡号 | String | '6222021234567890' |
| bankName | 银行名称 | String | '工商银行' |
| paymentAmount | 付款金额 | Number | 10000.00 |
| paymentType | 付款类型 | String | '付供应商货款' |
| freightAmount | 运费金额 | Number | 500.00 |
| customerDiff | 客户变动差额 | Number | 0.00 |
| supplierDiff | 供应商变动差额 | Number | -10000.00 |
| bankCardDiff | 银行卡资金变动 | Number | -10000.00 |
| freightDiff | 运费变动差额 | Number | -500.00 |

## 冲抵款

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| offsetDate | 冲抵日期 | Date | '2026-01-15' |
| customerName | 客户名称 | String | '某某公司' |
| supplierName | 供应商名称 | String | '湖北三峡' |
| offsetAmount | 冲抵金额 | Number | 5000.00 |
| offsetType | 冲抵类型 | String | '客户冲供应商' |
| customerDiff | 客户变动差额 | Number | -5000.00 |
| supplierDiff | 供应商变动差额 | Number | -5000.00 |

## 平账

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| balanceDate | 平账日期 | Date | '2026-01-15' |
| customerName | 客户名称 | String | '某某公司' |
| supplierName | 供应商名称 | String | '湖北三峡' |
| balanceAmount | 平账金额 | Number | 1000.00 |
| balanceType | 平账类型 | String | '客户平账' |
| customerDiff | 客户变动差额 | Number | -1000.00 |
| supplierDiff | 供应商变动差额 | Number | 0.00 |

## 借入款管理

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| borrowDate | 借款日期 | Date | '2026-01-15' |
| lenderName | 出借方名称 | String | '张三' |
| borrowAmount | 借款金额 | Number | 50000.00 |
| bankCardNo | 银行卡号 | String | '6222021234567890' |
| bankName | 银行名称 | String | '工商银行' |
| interestRate | 利率 | Number | 0.05 |
| borrowTerm | 借款期限 | String | '12个月' |
| bankCardDiff | 银行卡资金变动 | Number | 50000.00 |

## 员工或公司从我司借款

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| borrowDate | 借款日期 | Date | '2026-01-15' |
| borrowerName | 借款人名称 | String | '李四' |
| borrowAmount | 借款金额 | Number | 10000.00 |
| bankCardNo | 银行卡号 | String | '6222021234567890' |
| bankName | 银行名称 | String | '工商银行' |
| borrowType | 借款类型 | String | '员工借款' |
| bankCardDiff | 银行卡资金变动 | Number | -10000.00 |
| receivableDiff | 其他应收变动 | Number | 10000.00 |

## 期货保证金

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| depositDate | 保证金日期 | Date | '2026-01-15' |
| futuresCompany | 期货公司 | String | '中信期货' |
| depositAmount | 保证金金额 | Number | 100000.00 |
| bankCardNo | 银行卡号 | String | '6222021234567890' |
| bankName | 银行名称 | String | '工商银行' |
| depositType | 操作类型 | String | '入金' |
| bankCardDiff | 银行卡资金变动 | Number | -100000.00 |
| futuresDepositDiff | 期货保证金变动 | Number | 100000.00 |

## 厂家保证金

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| depositDate | 保证金日期 | Date | '2026-01-15' |
| supplierName | 厂家名称 | String | '湖北三峡' |
| depositAmount | 保证金金额 | Number | 50000.00 |
| bankCardNo | 银行卡号 | String | '6222021234567890' |
| bankName | 银行名称 | String | '工商银行' |
| depositType | 操作类型 | String | '支付保证金' |
| bankCardDiff | 银行卡资金变动 | Number | -50000.00 |
| supplierDepositDiff | 厂家保证金变动 | Number | 50000.00 |

## 收取保证金

| 字段名 | 说明 | 类型 | 示例值 |
|-------|------|------|--------|
| depositDate | 保证金日期 | Date | '2026-01-15' |
| customerName | 客户名称 | String | '某某公司' |
| depositAmount | 保证金金额 | Number | 30000.00 |
| bankCardNo | 银行卡号 | String | '6222021234567890' |
| bankName | 银行名称 | String | '工商银行' |
| depositType | 操作类型 | String | '收取保证金' |
| bankCardDiff | 银行卡资金变动 | Number | 30000.00 |
| receiveDepositDiff | 收取保证金变动 | Number | 30000.00 |

## 字段命名规范

### 通用字段

- `xxxDate`: 日期字段，格式 'YYYY-MM-DD'
- `xxxName`: 名称字段，字符串类型
- `xxxAmount`: 金额字段，数字类型，保留2位小数
- `xxxDiff`: 差额字段，数字类型，保留2位小数

### 差额字段命名

- `inventoryDiff`: 库存变动差额
- `customerDiff`: 客户变动差额
- `supplierDiff`: 供应商变动差额
- `bankCardDiff`: 银行卡资金变动
- `freightDiff`: 运费变动差额
- `receivableDiff`: 其他应收变动
- `futuresDepositDiff`: 期货保证金变动
- `supplierDepositDiff`: 厂家保证金变动
- `receiveDepositDiff`: 收取保证金变动

## 使用建议

1. **字段类型转换**: 从 `originalInfo` / `changedInfo` 取值时，数字类型字段使用 `Number()` 转换
2. **日期格式化**: 使用 `dayjs` 或 `moment` 格式化日期
3. **金额计算与显示**: 差额计算使用 mathjs 的 `subtract`、`add` 等保证高精度，`format` 格式化保留 2 位小数（与 SKILL 规范一致）
4. **空值处理**: 使用 `|| 0` 或 `?? 0` 处理可能为空的数值字段
