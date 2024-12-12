const getters = {
	// 特别 垃圾桶信息存放
	currentOrderInfo: state => state.trash.currentOrderInfo,
	sidebar: state => state.app.sidebar,
	size: state => state.app.size,
	device: state => state.app.device,
	dict: state => state.dict.dict,
	visitedViews: state => state.tagsView.visitedViews,
	cachedViews: state => state.tagsView.cachedViews,
	token: state => state.user.token,
	avatar: state => state.user.avatar,
	name: state => state.user.name,
	introduction: state => state.user.introduction,
	trueName: state => state.user.trueName,
	roles: state => state.user.roles,
	permissions: state => state.user.permissions,
	permission_routes: state => state.permission.routes,
	topbarRouters: state => state.permission.topbarRouters,
	defaultRoutes: state => state.permission.defaultRoutes,
	sidebarRouters: state => state.permission.sidebarRouters,
	// 获取借款信息的getter
	tempBorrowedMoneyList: state => state.money.tempBorrowedMoneyList,
	// 还款信息
	tempRepaymentList: state => state.money.tempRepaymentList,
	// 向外借款
	tempLendMoneyList: state => state.money.tempLendMoneyList,
	// 资金收回
	tempRecoverMoneyList: state => state.money.tempRecoverMoneyList,
	// 运费自动填充字段
	freightFree: state => state.money.freightFee,
	// 订单货物列表
	orderItemList: state => state.order.orderItemList,
	// 平账信息
	tempbalanceaccountsList: state => state.balanceaccounts.balanceaccountsList,
	// 固定资产信息
	fixedassetsList: state => state.fixedassets.fixedassetsList,
	// 刷新标记
	checked: state => state.apply.checked,
	// 库存信息
	inventoryInfoAll: state => state.inventory.inventoryInfoAll,
	// 审核流程列表
	checkStepList: state => state.paymentApply.checkStepList,
	// 运费
	freightInfo: state => state.trash.freightInfo,
	// 出差信息中的部门信息
	deptName: state => state.trash.deptName,
	// excel数据
	excelData: state => state.excel.excelData,
	// 公共票点
	ticketPoint: state => state.excel.ticketPoint,
	// 备注
	comment: state => state.excel.comment,
	// 选中的订单的数据
	selectedOrder: state => state.excel.selectedOrders,
	// 对应的开票列表
	selectedInvoiceList: state => state.excel.selectedInvoiceList,
	// 开票的金额
	invoiceAmount: state => state.excel.invoiceAmount,
	// 暂存购买的信息
	purchaseTempInfo: state => state.excel.purchaseTempInfo,
	sellerTempInfo: state => state.excel.sellerTempInfo,
	companyList: state => state.excel.companyList

	// 出差
};
export default getters;
