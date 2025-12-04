# 系统服务接口汇总表

## Service 层服务类对照表

| 实体类名 | 表名 | Service 层全类名 |
|---------|------|-----------------|
| InventoryMain | inventory_main | org.dzu.system.service.IInventoryMainService |
| PaymentApply | payment_apply | org.dzu.system.service.IPaymentApplyService |
| ReceiveMoney | receive_money | org.dzu.system.service.IReceiveMoneyService |
| Payment | payment | org.dzu.system.service.IPaymentService |
| InvoiceOut | invoice_out | org.dzu.system.service.IInvoiceOutService |
| InvoiceOther | invoice_other | org.dzu.system.service.IInvoiceOtherService |
| InvoiceIn | invoice_in | org.dzu.system.service.IInvoiceInService |
| GoodsOrder | goods_order | org.dzu.system.service.IGoodsOrderService |
| CarApply | car_apply | org.dzu.system.service.ICarApplyService |
| BusinessTrip | business_trip | org.dzu.system.service.IBusinessTripService |

## 服务功能说明

### 财务相关服务
- **PaymentApply**: 付款申请管理
- **ReceiveMoney**: 收款管理
- **Payment**: 支付管理

### 发票相关服务
- **InvoiceOut**: 销项发票管理
- **InvoiceIn**: 进项发票管理
- **InvoiceOther**: 其他发票管理

### 业务相关服务
- **InventoryMain**: 库存主单管理
- **GoodsOrder**: 货物订单管理
- **CarApply**: 用车申请管理
- **BusinessTrip**: 商务出差管理

## 使用说明

这些服务类主要用于系统的业务逻辑处理，每个服务类都对应一个具体的业务实体和数据表。在前端调用相关 API 接口时，后端会通过这些 Service 层来处理具体的业务逻辑。