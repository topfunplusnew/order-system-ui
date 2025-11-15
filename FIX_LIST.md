# el-table-column 默认插槽和 el-tooltip 修复列表

## 参考配置
参考文件：`order-UI/packages/order-system/src/views/dashboard/components/goodsOrder/ElTableOrder.vue`

## 修复模式
为所有 el-table-column 添加默认插槽（`#default`），并将内容包裹在 el-tooltip 中：
```vue
<el-table-column ...>
  <template #default="scope">
    <el-tooltip effect="light" placement="top" enterable :open-delay="1000">
      <div slot="content">{{ scope.row.xxx }}</div>
      <span>{{ scope.row.xxx }}</span>
    </el-tooltip>
  </template>
</el-table-column>
```

## 修复状态

### ✅ 已修复
1. ✅ order-UI/packages/order-system/src/views/system/user/index.vue
2. ✅ order-UI/packages/order-system/src/views/system/detail/index.vue
3. ✅ order-UI/packages/order-system/src/views/system/salesstepincentivedetails/index.vue
4. ✅ order-UI/packages/order-system/src/views/index.vue
5. ✅ order-UI/packages/order-system/src/views/system/record/index.vue
6. ✅ order-UI/packages/order-system/src/views/system/voucher/index.vue
7. ✅ order-UI/packages/order-system/src/views/system/vehicles/index.vue
8. ✅ order-UI/packages/order-system/src/views/system/user/authRole.vue
9. ✅ order-UI/packages/order-system/src/views/system/subject/index.vue
10. ✅ order-UI/packages/order-system/src/views/system/storehouse/index.vue
11. ✅ order-UI/packages/order-system/src/views/system/socialinsurance/index.vue
12. ✅ order-UI/packages/order-system/src/views/system/selfmoney/index.vue
13. ✅ order-UI/packages/order-system/src/views/system/secondinventory/index.vue
14. ✅ order-UI/packages/order-system/src/views/system/salessingorderincentivedetails/index.vue
15. ✅ order-UI/packages/order-system/src/views/system/role/selectUser.vue
16. ✅ order-UI/packages/order-system/src/views/system/role/authUser.vue
17. ✅ order-UI/packages/order-system/src/views/system/repayment/index.vue
18. ✅ order-UI/packages/order-system/src/views/system/recovermoney/index.vue
19. ✅ order-UI/packages/order-system/src/views/system/receiveMoney/index.vue
20. ✅ order-UI/packages/order-system/src/views/system/rebate/index.vue
21. ✅ order-UI/packages/order-system/src/views/system/productlevel/index.vue
22. ✅ order-UI/packages/order-system/src/views/system/post/index.vue

### ⏳ 待修复
23. ⏳ order-UI/packages/order-system/src/views/system/testing/index.vue (使用原生table，跳过)
24. ✅ order-UI/packages/order-system/src/views/system/paymentApply/index.vue
25. ✅ order-UI/packages/order-system/src/views/system/payment/index.vue
26. ✅ order-UI/packages/order-system/src/views/system/orderfreight/index.vue
27. ⏳ order-UI/packages/order-system/src/views/system/orderdetail/index.vue (template被注释，跳过)
28. ✅ order-UI/packages/order-system/src/views/system/oilcard/index.vue
29. ✅ order-UI/packages/order-system/src/views/system/oilRecharge/index.vue
30. ✅ order-UI/packages/order-system/src/views/system/oilCardFundTransfer/index.vue
31. ✅ order-UI/packages/order-system/src/views/system/offsetting/index.vue
32. ✅ order-UI/packages/order-system/src/views/system/notice/index.vue
33. ✅ order-UI/packages/order-system/src/views/system/noneInvoice/InvoiceOut.vue
34. ✅ order-UI/packages/order-system/src/views/system/noneInvoice/InvoiceIn.vue
35. ✅ order-UI/packages/order-system/src/views/system/lowvalueconsumables/index.vue
36. ✅ order-UI/packages/order-system/src/views/system/lendmoney/index.vue
37. ✅ order-UI/packages/order-system/src/views/system/invoiceOut/index.vue
38. ✅ order-UI/packages/order-system/src/views/system/invoiceOther/invoicehave.vue
39. ✅ order-UI/packages/order-system/src/views/system/invoiceOther/index.vue
40. ✅ order-UI/packages/order-system/src/views/system/invoiceIn/index.vue
41. ✅ order-UI/packages/order-system/src/views/system/inventoryTotal/index.vue
42. ✅ order-UI/packages/order-system/src/views/system/inventoryMain/index.vue
43. ✅ order-UI/packages/order-system/src/views/system/goback/SupplierTotal.vue
44. ✅ order-UI/packages/order-system/src/views/system/goback/SupplierInfo.vue
45. ✅ order-UI/packages/order-system/src/views/system/goback/FreightInfo.vue
46. ✅ order-UI/packages/order-system/src/views/system/goback/CustomerTotal.vue
47. ✅ order-UI/packages/order-system/src/views/system/goback/CustomerInfo.vue
48. ✅ order-UI/packages/order-system/src/views/system/giftOut/index.vue
49. ✅ order-UI/packages/order-system/src/views/system/giftIn/index.vue
50. ✅ order-UI/packages/order-system/src/views/system/fleet/index.vue
51. ✅ order-UI/packages/order-system/src/views/system/fixedassets/index.vue
52. ✅ order-UI/packages/order-system/src/views/system/exwarehouse/index.vue
53. ✅ order-UI/packages/order-system/src/views/system/employeeLendMoney/index.vue
54. ✅ order-UI/packages/order-system/src/views/system/dict/index.vue
55. ✅ order-UI/packages/order-system/src/views/system/dict/data.vue
56. ✅ order-UI/packages/order-system/src/views/system/dept/index.vue
57. ✅ order-UI/packages/order-system/src/views/system/depositMoney/index.vue
58. ⏳ order-UI/packages/order-system/src/views/system/customervisit/index.vue
59. ⏳ order-UI/packages/order-system/src/views/system/credentials/searchcredentials.vue
60. ⏳ order-UI/packages/order-system/src/views/system/credentials/generation.vue
61. ⏳ order-UI/packages/order-system/src/views/system/config/index.vue
62. ⏳ order-UI/packages/order-system/src/views/system/companygive/index.vue
63. ⏳ order-UI/packages/order-system/src/views/system/companycar/index.vue
64. ⏳ order-UI/packages/order-system/src/views/system/company/options/BankSearch.vue
65. ⏳ order-UI/packages/order-system/src/views/system/company/options/BankManage.vue
66. ⏳ order-UI/packages/order-system/src/views/system/company/index.vue
67. ⏳ order-UI/packages/order-system/src/views/system/cashdeposit/index.vue
68. ⏳ order-UI/packages/order-system/src/views/system/cashdeposit/depositself.vue
69. ⏳ order-UI/packages/order-system/src/views/system/cashdeposit/depositAll.vue
70. ⏳ order-UI/packages/order-system/src/views/system/cashdeposit/cashdepositfactory.vue
71. ⏳ order-UI/packages/order-system/src/views/system/cars/index.vue
72. ⏳ order-UI/packages/order-system/src/views/system/carapply/index.vue
73. ⏳ order-UI/packages/order-system/src/views/system/businesstrip/index.vue
74. ⏳ order-UI/packages/order-system/src/views/system/breakout/index.vue
75. ⏳ order-UI/packages/order-system/src/views/system/borrowedmoney/index.vue
76. ⏳ order-UI/packages/order-system/src/views/system/billstatement/index.vue
77. ⏳ order-UI/packages/order-system/src/views/system/bankaccount/index.vue
78. ⏳ order-UI/packages/order-system/src/views/system/bankacceptancegive/index.vue
79. ⏳ order-UI/packages/order-system/src/views/system/bankacceptance/index.vue
80. ⏳ order-UI/packages/order-system/src/views/system/bankacceptance/InnerBankAcception.vue
81. ⏳ order-UI/packages/order-system/src/views/system/balanceaccounts/index.vue
82. ⏳ order-UI/packages/order-system/src/views/system/auditInfo/index.vue
83. ⏳ order-UI/packages/order-system/src/views/system/applyprocess/index.vue
84. ⏳ order-UI/packages/order-system/src/views/system/applyfreight/index.vue
85. ⏳ order-UI/packages/order-system/src/views/system/allinvoice/index.vue
86. ✅ order-UI/packages/order-system/src/views/system/Total/salesManagerTotal.vue
87. ✅ order-UI/packages/order-system/src/views/system/Total/customerTotal.vue
88. ✅ order-UI/packages/order-system/src/views/system/Total/areaTotal.vue
89. ✅ order-UI/packages/order-system/src/views/system/Statement/totalMoneyChange.vue
90. ✅ order-UI/packages/order-system/src/views/system/Statement/systemSupplierChangeSummary.vue
91. ✅ order-UI/packages/order-system/src/views/system/Statement/systemFreightChangeSummary.vue
92. ✅ order-UI/packages/order-system/src/views/system/Statement/systemCustomerChangeSummary.vue
93. ✅ order-UI/packages/order-system/src/views/system/Statement/supplierSummary.vue
94. ✅ order-UI/packages/order-system/src/views/system/Statement/subjectsummary.vue
95. ✅ order-UI/packages/order-system/src/views/system/Statement/socialinsurancesummary.vue
96. ✅ order-UI/packages/order-system/src/views/system/Statement/orderfreightDetailsummary.vue
97. ✅ order-UI/packages/order-system/src/views/system/Statement/lendmoneysummary2.vue
98. ✅ order-UI/packages/order-system/src/views/system/Statement/orderfreight.vue
99. ✅ order-UI/packages/order-system/src/views/system/Statement/lendmoneysummary.vue
100. ✅ order-UI/packages/order-system/src/views/system/Statement/fundFlowDetailList.vue
101. ✅ order-UI/packages/order-system/src/views/system/Statement/fleetfreightsummary.vue
102. ✅ order-UI/packages/order-system/src/views/system/Statement/dailyOrderCount.vue
103. ✅ order-UI/packages/order-system/src/views/system/Statement/customerSummary.vue
104. ✅ order-UI/packages/order-system/src/views/system/Statement/components/SupplierDetail.vue
105. ✅ order-UI/packages/order-system/src/views/system/Statement/components/FreightDetail.vue
106. ✅ order-UI/packages/order-system/src/views/system/Statement/components/CustomerDetail.vue
107. ✅ order-UI/packages/order-system/src/views/system/Statement/companysummarygive.vue
108. ✅ order-UI/packages/order-system/src/views/system/Statement/companysummary.vue
109. ✅ order-UI/packages/order-system/src/views/system/Statement/cashOilRecharge.vue
110. ✅ order-UI/packages/order-system/src/views/system/Statement/borrowedMoneySummary.vue
111. ✅ order-UI/packages/order-system/src/views/system/Statement/bankAcountChangeSummary.vue
112. ✅ order-UI/packages/order-system/src/views/system/Statement/OilCardBalanceDetail.vue
113. ✅ order-UI/packages/order-system/src/views/system/Statement/OilCardDetail.vue
114. ✅ order-UI/packages/order-system/src/views/system/Statement/MoneyChangeTotalAmount.vue
115. ✅ order-UI/packages/order-system/src/views/system/OilCardConsume/index.vue
116. ✅ order-UI/packages/order-system/src/views/system/Commission/SupplierCommission.vue
117. ✅ order-UI/packages/order-system/src/views/system/Commission/CustomerCommission.vue
118. ✅ order-UI/packages/order-system/src/views/monitor/operlog/index.vue
119. ✅ order-UI/packages/order-system/src/views/monitor/online/index.vue
120. ✅ order-UI/packages/order-system/src/views/monitor/logininfor/index.vue
121. ✅ order-UI/packages/order-system/src/views/monitor/job/log.vue
122. ✅ order-UI/packages/order-system/src/views/monitor/job/index.vue
123. ✅ order-UI/packages/order-system/src/views/monitor/cache/list.vue
124. ✅ order-UI/packages/order-system/src/views/inventoryDetailViews/inventoryChange/index.vue
125. ⏳ order-UI/packages/order-system/src/views/dashboard/components/voucher/OrderList.vue
126. ⏳ order-UI/packages/order-system/src/views/dashboard/components/voucher/InvoiceList.vue
127. ⏳ order-UI/packages/order-system/src/views/dashboard/components/voucher/InventoryList.vue
128. ⏳ order-UI/packages/order-system/src/views/dashboard/components/incent/IncentOrders.vue
129. ⏳ order-UI/packages/order-system/src/views/dashboard/components/goodsOrder/OrderTable.vue
130. ⏳ order-UI/packages/order-system/src/views/dashboard/components/goodsOrder/OrderItem.vue
131. ⏳ order-UI/packages/order-system/src/views/dashboard/components/goodsOrder/OrderHistoryList.vue
132. ⏳ order-UI/packages/order-system/src/views/dashboard/components/goodsOrder/OrderForm.vue
133. ⏳ order-UI/packages/order-system/src/views/dashboard/components/goodsOrder/OrderDetailInfo.vue
134. ⏳ order-UI/packages/order-system/src/views/dashboard/components/goodsOrder/Invoice.vue
135. ⏳ order-UI/packages/order-system/src/views/moneyDetail/index.vue
... (还有更多文件)

## 注意事项
1. 操作列（包含按钮、下拉菜单等交互元素）通常不需要添加 tooltip
2. 已有 slot-scope 的列需要改为 #default
3. 注意标签的闭合状态
4. 参考 ElTableOrder.vue 中的配置模式

