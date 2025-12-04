<!--<template>-->
<!--	<div class="app-container">-->
<!--		&lt;!&ndash;    查询组&ndash;&gt;-->
<!--		<el-form v-show="showSearch" ref="queryForm" :model="queryOrderInfo" size="mini" :inline="true" label-width="100px"></el-form>-->
<!--		&lt;!&ndash;       表格上方操作栏&ndash;&gt;-->

<!--		<el-row :gutter="10" class="mb8">-->
<!--			&lt;!&ndash;      左侧操作栏&ndash;&gt;-->
<!--			<el-col :span="1.5">-->
<!--				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>-->
<!--			</el-col>-->
<!--			<el-col :span="1.5">-->
<!--				<el-button v-hasPermi="['system:orderdetail:export']" type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出订单数据</el-button>-->
<!--			</el-col>-->
<!--			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">-->
<!--				<template #print>-->
<!--					<el-col :span="1.5">-->
<!--						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>-->
<!--					</el-col>-->
<!--				</template>-->
<!--				&lt;!&ndash;        导出&ndash;&gt;-->
<!--				<template #export>-->
<!--					<el-col :span="1.5">-->
<!--						<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>-->
<!--					</el-col>-->
<!--				</template>-->
<!--			</right-toolbar>-->
<!--		</el-row>-->
<!--		<el-table-->
<!--			id="printBox"-->
<!--			v-horizontal-scroll="'always'"-->
<!--			v-loading="loading"-->
<!--			border-->
<!--			:data="orderDetailList"-->
<!--			:row-class-name="tableRowClassName"-->
<!--			show-summary-->
<!--			:summary-method="getSummaries"-->
<!--			max-height="700"-->
<!--			@selection-change="handleSelectionChange"-->
<!--		>-->
<!--			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="170px" fixed="left">-->
<!--				<template slot-scope="scope">-->
<!--					<el-button size="mini" @click="checkOrderItemInfo(scope.row)">查看</el-button>-->
<!--					<el-button v-hasPermi="['system:orderdetail:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>-->
<!--				</template>-->
<!--			</el-table-column>-->
<!--			&lt;!&ndash;      固定列&ndash;&gt;-->
<!--			<el-table-column label="id" align="center" prop="id" fixed="left" />-->
<!--			<el-table-column label="订单日期" align="center" prop="orderDate" fixed="left" />-->
<!--			<el-table-column label="订单编号" align="center" prop="ordersNo" fixed="left" />-->
<!--			<el-table-column label="客户" align="center" prop="customer" fixed="left" />-->
<!--			<el-table-column label="供应商" align="center" prop="supplier" fixed="left" />-->
<!--			&lt;!&ndash;      滚动列&ndash;&gt;-->
<!--			<el-table-column v-if="columns[36].visible" label="供应商ID" align="center" prop="supplierID" />-->
<!--			<el-table-column v-if="columns[0].visible" label="客户ID" align="center" prop="customerID" />-->
<!--			<el-table-column v-if="columns[1].visible" label="级别编码" align="center" prop="levelID" />-->
<!--			<el-table-column v-if="columns[2].visible" label="级别名称" align="center" prop="levelName" />-->
<!--			<el-table-column v-if="columns[3].visible" label="计量单位" align="center" prop="countingUnit" />-->
<!--			<el-table-column v-if="columns[4].visible" label="厚度" align="center" prop="height" />-->
<!--			<el-table-column v-if="columns[5].visible" label="长度" align="center" prop="length" />-->
<!--			<el-table-column v-if="columns[6].visible" label="宽度" align="center" prop="width" />-->
<!--			<el-table-column v-if="columns[7].visible" label="出厂片数" align="center" prop="pieces" />-->
<!--			<el-table-column v-if="columns[8].visible" label="每包片数" align="center" prop="piecesPerPack" />-->
<!--			<el-table-column v-if="columns[9].visible" label="包数" align="center" prop="packs" />-->
<!--			<el-table-column v-if="columns[10].visible" label="出厂单价" align="center" prop="price" />-->
<!--			&lt;!&ndash;      <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory"/>&ndash;&gt;-->
<!--			&lt;!&ndash;      是与否&ndash;&gt;-->
<!--			<el-table-column v-if="columns[11].visible" label="出厂是否含税" align="center" prop="isIncludeTaxFactory">-->
<!--				<template slot-scope="scope">-->
<!--					<el-tag :type="scope.row.isIncludeTaxFactory === '否' ? 'danger' : 'success'" disable-transitions>{{ scope.row.isIncludeTaxFactory }}</el-tag>-->
<!--				</template>-->
<!--			</el-table-column>-->
<!--			<el-table-column v-if="columns[12].visible" label="杂费" align="center" prop="sundryCost" />-->
<!--			<el-table-column v-if="columns[13].visible" label="出厂货款" align="center" prop="paymentFactory" />-->
<!--			<el-table-column v-if="columns[14].visible" label="卸货价" align="center" prop="paymentUnload" />-->
<!--			&lt;!&ndash;      <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale"/>&ndash;&gt;-->
<!--			&lt;!&ndash;      是与否&ndash;&gt;-->
<!--			<el-table-column v-if="columns[15].visible" label="销售是否含税" align="center" prop="isIncludeTaxSale">-->
<!--				<template slot-scope="scope">-->
<!--					<el-tag :type="scope.row.isIncludeTaxSale === '否' ? 'danger' : 'success'" disable-transitions>{{ scope.row.isIncludeTaxSale }}</el-tag>-->
<!--				</template>-->
<!--			</el-table-column>-->
<!--			<el-table-column v-if="columns[16].visible" label="总货款" align="center" prop="payments" />-->
<!--			<el-table-column v-if="columns[17].visible" label="误差" align="center" prop="erro" />-->
<!--			<el-table-column v-if="columns[18].visible" label="吨位" align="center" prop="tonnage" />-->
<!--			<el-table-column v-if="columns[19].visible" label="陆运费单价" align="center" prop="landFreightPrice" />-->
<!--			<el-table-column v-if="columns[20].visible" label="陆运费" align="center" prop="landFreight" />-->
<!--			<el-table-column v-if="columns[21].visible" label="海运费" align="center" prop="seaFreight" />-->
<!--			<el-table-column v-if="columns[22].visible" label="总运费" align="center" prop="freight" />-->
<!--			<el-table-column v-if="columns[23].visible" label="其他费用" align="center" prop="otherCost" />-->
<!--			<el-table-column v-if="columns[24].visible" label="利润" align="center" prop="profit" />-->
<!--			<el-table-column v-if="columns[25].visible" label="不含税利润" align="center" prop="profitNoTax" />-->
<!--			<el-table-column v-if="columns[26].visible" label="实际片数" align="center" prop="actualPieces" />-->
<!--			<el-table-column v-if="columns[27].visible" label="总货款杂费" align="center" prop="paymentsWithSundry" />-->
<!--			<el-table-column v-if="columns[28].visible" label="加费" align="center" prop="additionalFees" />-->
<!--			<el-table-column v-if="columns[29].visible" label="仓库ID" align="center" prop="storeHouseID" />-->
<!--			<el-table-column v-if="columns[30].visible" label="仓库名称" align="center" prop="storeHouseName" />-->
<!--			<el-table-column v-if="columns[31].visible" label="仓库存储的货物ID" align="center" prop="storeID" />-->
<!--			<el-table-column v-if="columns[32].visible" label="物流利润" align="center" prop="logisticsProfit" />-->
<!--			<el-table-column v-if="columns[33].visible" label="客户佣金" align="center" prop="customerCommission" />-->
<!--			&lt;!&ndash;      <el-table-column label="是否被调整单" align="center" prop="isAdjusted"/>&ndash;&gt;-->

<!--			&lt;!&ndash;      是与否&ndash;&gt;-->
<!--			<el-table-column v-if="columns[34].visible" label="是否被调整单" align="center" prop="isAdjusted">-->
<!--				<template slot-scope="scope">-->
<!--					<el-tag :type="scope.row.isAdjusted === 0 ? 'danger' : 'success'" disable-transitions>{{ scope.row.isAdjusted }}</el-tag>-->
<!--				</template>-->
<!--			</el-table-column>-->
<!--			<el-table-column v-if="columns[35].visible" label="调整日期" align="center" prop="adjustDate" />-->
<!--		</el-table>-->

<!--		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />-->

<!--		&lt;!&ndash; 添加或修改订单详情对话框 &ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>-->
<!--			<el-form ref="form" :model="form" :rules="rules" label-width="80px">-->
<!--				<el-form-item label="订单编号" prop="ordersNo">-->
<!--					<el-input v-model="form.ordersNo" placeholder="请输入订单编号" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="订单日期" prop="orderDate">-->
<!--					<el-input v-model="form.orderDate" placeholder="请输入订单日期" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="供应商" prop="supplier">-->
<!--					<el-input v-model="form.supplier" placeholder="请输入供应商" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="供应商ID" prop="supplierID">-->
<!--					<el-input v-model="form.supplierID" placeholder="请输入供应商ID" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="客户" prop="customer">-->
<!--					<el-input v-model="form.customer" placeholder="请输入客户" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="客户ID" prop="customerID">-->
<!--					<el-input v-model="form.customerID" placeholder="请输入客户ID" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="级别编码" prop="levelID">-->
<!--					<el-input v-model="form.levelID" placeholder="请输入级别编码" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="级别名称" prop="levelName">-->
<!--					<el-input v-model="form.levelName" placeholder="请输入级别名称" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="计量单位" prop="countingUnit">-->
<!--					<el-input v-model="form.countingUnit" placeholder="请输入计量单位" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="厚度" prop="height">-->
<!--					<el-input v-model="form.height" placeholder="请输入厚度" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="长度" prop="length">-->
<!--					<el-input v-model="form.length" placeholder="请输入长度" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="宽度" prop="width">-->
<!--					<el-input v-model="form.width" placeholder="请输入宽度" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="出厂片数" prop="pieces">-->
<!--					<el-input v-model="form.pieces" placeholder="请输入出厂片数" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="每包片数" prop="piecesPerPack">-->
<!--					<el-input v-model="form.piecesPerPack" placeholder="请输入每包片数" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="包数" prop="packs">-->
<!--					<el-input v-model="form.packs" placeholder="请输入包数" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="出厂单价" prop="price">-->
<!--					<el-input v-model="form.price" placeholder="请输入出厂单价" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="出厂是否含税" prop="isIncludeTaxFactory">-->
<!--					<el-input v-model="form.isIncludeTaxFactory" placeholder="请输入出厂是否含税" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="杂费" prop="sundryCost">-->
<!--					<el-input v-model="form.sundryCost" placeholder="请输入杂费" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="出厂货款" prop="paymentFactory">-->
<!--					<el-input v-model="form.paymentFactory" placeholder="请输入出厂货款" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="卸货价" prop="paymentUnload">-->
<!--					<el-input v-model="form.paymentUnload" placeholder="请输入卸货价" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="销售是否含税" prop="isIncludeTaxSale">-->
<!--					<el-input v-model="form.isIncludeTaxSale" placeholder="请输入销售是否含税" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="总货款" prop="payments">-->
<!--					<el-input v-model="form.payments" placeholder="请输入总货款" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="误差" prop="erro">-->
<!--					<el-input v-model="form.erro" placeholder="请输入误差" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="吨位" prop="tonnage">-->
<!--					<el-input v-model="form.tonnage" placeholder="请输入吨位" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="陆运费单价" prop="landFreightPrice">-->
<!--					<el-input v-model="form.landFreightPrice" placeholder="请输入陆运费单价" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="陆运费" prop="landFreight">-->
<!--					<el-input v-model="form.landFreight" placeholder="请输入陆运费" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="海运费" prop="seaFreight">-->
<!--					<el-input v-model="form.seaFreight" placeholder="请输入海运费" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="总运费" prop="freight">-->
<!--					<el-input v-model="form.freight" placeholder="请输入总运费" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="其他费用" prop="otherCost">-->
<!--					<el-input v-model="form.otherCost" placeholder="请输入其他费用" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="利润" prop="profit">-->
<!--					<el-input v-model="form.profit" placeholder="请输入利润" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="不含税利润" prop="profitNoTax">-->
<!--					<el-input v-model="form.profitNoTax" placeholder="请输入不含税利润" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="实际片数" prop="actualPieces">-->
<!--					<el-input v-model="form.actualPieces" placeholder="请输入实际片数" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="总货款杂费" prop="paymentsWithSundry">-->
<!--					<el-input v-model="form.paymentsWithSundry" placeholder="请输入总货款杂费" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="加费" prop="additionalFees">-->
<!--					<el-input v-model="form.additionalFees" placeholder="请输入加费" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="仓库ID" prop="storeHouseID">-->
<!--					<el-input v-model="form.storeHouseID" placeholder="请输入仓库ID" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="仓库名称" prop="storeHouseName">-->
<!--					<el-input v-model="form.storeHouseName" placeholder="请输入仓库名称" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="仓库存储的货物ID" prop="storeID">-->
<!--					<el-input v-model="form.storeID" placeholder="请输入仓库存储的货物ID" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="物流利润" prop="logisticsProfit">-->
<!--					<el-input v-model="form.logisticsProfit" placeholder="请输入物流利润" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="客户佣金" prop="customerCommission">-->
<!--					<el-input v-model="form.customerCommission" placeholder="请输入客户佣金" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="是否被调整单" prop="isAdjusted">-->
<!--					<el-input v-model="form.isAdjusted" placeholder="请输入是否被调整单" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="调整日期" prop="adjustDate">-->
<!--					<el-input v-model="form.adjustDate" placeholder="请输入调整日期" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="作废标记" prop="cancelFlag">-->
<!--					<el-input v-model="form.cancelFlag" placeholder="请输入作废标记" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="备注" prop="comments">-->
<!--					<el-input v-model="form.comments" placeholder="请输入备注" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="添加时间" prop="addtime">-->
<!--					<el-input v-model="form.addtime" placeholder="请输入添加时间" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="操作人员ID" prop="userId">-->
<!--					<el-input v-model="form.userId" placeholder="请输入操作人员ID" />-->
<!--				</el-form-item>-->
<!--				<el-form-item label="操作人员姓名" prop="UserName">-->
<!--					<el-input v-model="form.UserName" placeholder="请输入操作人员姓名" />-->
<!--				</el-form-item>-->
<!--			</el-form>-->
<!--			<div slot="footer" class="dialog-footer">-->
<!--				<el-button type="primary" @click="submitForm">确 定</el-button>-->
<!--				<el-button @click="cancel">取 消</el-button>-->
<!--			</div>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    点击查看某个订单的弹窗   &ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="查看订单信息" :visible.sync="checkOrderVisible" width="30%">-->
<!--			<el-descriptions title="订单信息" :column="1" border>-->
<!--				<el-descriptions-item label="id">{{ orderDetailInfo.id }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="日期">{{ orderDetailInfo.orderDate }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="订单编号">{{ orderDetailInfo.ordersNo }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="客户">{{ orderDetailInfo.customer }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="级别编码">{{ orderDetailInfo.levelID }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="级别名称">{{ orderDetailInfo.levelName }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="计量单位">{{ orderDetailInfo.countingUnit }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="厚度">{{ orderDetailInfo.height }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="长度">{{ orderDetailInfo.length }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="宽度">{{ orderDetailInfo.width }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="出厂片数">{{ orderDetailInfo.pieces }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="每包片数">{{ orderDetailInfo.piecesPerPack }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="包数">{{ orderDetailInfo.packs }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="出厂单价">{{ orderDetailInfo.price }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="出厂是否含税">-->
<!--					<TagsItem :check-info="orderDetailInfo.isIncludeTaxFactory" check-value="否" />-->
<!--				</el-descriptions-item>-->
<!--				<el-descriptions-item label="杂费">{{ orderDetailInfo.sundryCost }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="出厂货款">{{ orderDetailInfo.paymentFactory }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="卸货价">{{ orderDetailInfo.paymentUnload }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="销售是否含税">-->
<!--					<TagsItem :check-info="orderDetailInfo.isIncludeTaxSale" check-value="否" />-->
<!--				</el-descriptions-item>-->
<!--				<el-descriptions-item label="总货款">{{ orderDetailInfo.payments }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="误差">{{ orderDetailInfo.erro }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="吨位">{{ orderDetailInfo.tonnage }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="陆运费单价">{{ orderDetailInfo.landFreightPrice }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="陆运费">{{ orderDetailInfo.landFreight }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="海运费">{{ orderDetailInfo.seaFreight }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="总运费">{{ orderDetailInfo.freight }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="其他费用">{{ orderDetailInfo.otherCost }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="利润">{{ orderDetailInfo.profit }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="不含税利润">{{ orderDetailInfo.profitNoTax }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="实际片数">{{ orderDetailInfo.actualPieces }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="总运费">{{ orderDetailInfo.freight }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="总货款杂费">{{ orderDetailInfo.paymentsWithSundry }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="加费">{{ orderDetailInfo.additionalFees }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="仓库名称">{{ orderDetailInfo.storeHouseName }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="物流利润">{{ orderDetailInfo.logisticsProfit }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="客户佣金">{{ orderDetailInfo.customerCommission }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="计提厂家返利金额">{{ orderDetailInfo.factoryRebateAmount }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="计提厂家降价金额">{{ orderDetailInfo.factoryDiscountAmount }}</el-descriptions-item>-->
<!--				<el-descriptions-item label="是否被调整单">-->
<!--					<TagsItem :check-info="orderDetailInfo.isAdjusted" check-value="否" />-->
<!--				</el-descriptions-item>-->
<!--				<el-descriptions-item label="调整日期">{{ orderDetailInfo.adjustDate }}</el-descriptions-item>-->
<!--			</el-descriptions>-->

<!--			<span slot="footer" class="dialog-footer">-->
<!--				<el-button @click="checkOrderVisible = false">取 消</el-button>-->
<!--				<el-button type="primary" @click="checkOrderVisible = false">确 定</el-button>-->
<!--			</span>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    点击调整单的弹窗&ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="handleOrderVisible" width="30%">-->
<!--			<span>点击调整单的弹窗</span>-->
<!--			<span slot="footer" class="dialog-footer">-->
<!--				<el-button @click="handleOrderVisible = false">取 消</el-button>-->
<!--				<el-button type="primary" @click="handleOrderVisible = false">确 定</el-button>-->
<!--			</span>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    点击发货单1的弹窗&ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="Order1Visible" width="30%">-->
<!--			<span>点击发货单1的弹窗</span>-->
<!--			<span slot="footer" class="dialog-footer">-->
<!--				<el-button @click="Order1Visible = false">取 消</el-button>-->
<!--				<el-button type="primary" @click="Order1Visible = false">确 定</el-button>-->
<!--			</span>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    点击发货单2的弹窗&ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="Order2Visible" width="30%">-->
<!--			<span>点击发货单2的弹窗</span>-->
<!--			<span slot="footer" class="dialog-footer">-->
<!--				<el-button @click="Order2Visible = false">取 消</el-button>-->
<!--				<el-button type="primary" @click="Order2Visible = false">确 定</el-button>-->
<!--			</span>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    点击发货单3的弹窗&ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="Order3Visible" width="30%">-->
<!--			<span>点击发货单3的弹窗</span>-->
<!--			<span slot="footer" class="dialog-footer">-->
<!--				<el-button @click="Order3Visible = false">取 消</el-button>-->
<!--				<el-button type="primary" @click="Order3Visible = false">确 定</el-button>-->
<!--			</span>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    上传附件的弹窗&ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="handleUploadVisible" width="30%">-->
<!--			<span>上传附件的弹窗</span>-->
<!--			<span slot="footer" class="dialog-footer">-->
<!--				<el-button @click="handleUploadVisible = false">取 消</el-button>-->
<!--				<el-button type="primary" @click="handleUploadVisible = false">确 定</el-button>-->
<!--			</span>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    上传收到条的弹窗&ndash;&gt;-->
<!--		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="提示" :visible.sync="handleCommitVisible" width="30%">-->
<!--			<span>上传收到条的弹窗</span>-->
<!--			<span slot="footer" class="dialog-footer">-->
<!--				<el-button @click="handleCommitVisible = false">取 消</el-button>-->
<!--				<el-button type="primary" @click="handleCommitVisible = false">确 定</el-button>-->
<!--			</span>-->
<!--		</el-dialog>-->
<!--	</div>-->
<!--</template>-->

<!--<script>-->
<!--import { listOrderDetail, getOrderDetail, delOrderDetail, addOrderDetail, updateOrderDetail } from '@/api/system/orderDetail';-->
<!--import TagsItem from '@/components/TagsItem/index.vue';-->
<!--import { addGoodsOrder, adjustGoodsOrder, getGoodsOrder } from '@/api/system/goodsOrder';-->

<!--export default {-->
<!--	name: 'OrderDetail',-->
<!--	components: { TagsItem },-->
<!--	data() {-->
<!--		return {-->
<!--			// 遮罩层-->
<!--			loading: true,-->
<!--			// 选中数组-->
<!--			ids: [],-->
<!--			// 非单个禁用-->
<!--			single: true,-->
<!--			// 非多个禁用-->
<!--			multiple: true,-->
<!--			// 显示搜索条件-->
<!--			showSearch: true,-->
<!--			// 总条数-->
<!--			total: 0,-->
<!--			// 订单详情表格数据-->
<!--			orderDetailList: [],-->
<!--			// 弹出层标题-->
<!--			title: '',-->
<!--			// 是否显示弹出层-->
<!--			open: false,-->
<!--			// 查询参数-->
<!--			queryParams: {-->
<!--				pageNum: 1,-->
<!--				pageSize: 20,-->
<!--				ordersNo: null,-->
<!--				orderDate: null,-->
<!--				supplier: null,-->
<!--				supplierID: null,-->
<!--				customer: null,-->
<!--				customerID: null,-->
<!--				levelID: null,-->
<!--				levelName: null,-->
<!--				countingUnit: null,-->
<!--				height: null,-->
<!--				length: null,-->
<!--				width: null,-->
<!--				pieces: null,-->
<!--				piecesPerPack: null,-->
<!--				packs: null,-->
<!--				price: null,-->
<!--				isIncludeTaxFactory: null,-->
<!--				sundryCost: null,-->
<!--				paymentFactory: null,-->
<!--				paymentUnload: null,-->
<!--				isIncludeTaxSale: null,-->
<!--				payments: null,-->
<!--				erro: null,-->
<!--				tonnage: null,-->
<!--				landFreightPrice: null,-->
<!--				landFreight: null,-->
<!--				seaFreight: null,-->
<!--				freight: null,-->
<!--				otherCost: null,-->
<!--				profit: null,-->
<!--				profitNoTax: null,-->
<!--				actualPieces: null,-->
<!--				paymentsWithSundry: null,-->
<!--				additionalFees: null,-->
<!--				storeHouseID: null,-->
<!--				storeHouseName: null,-->
<!--				storeID: null,-->
<!--				logisticsProfit: null,-->
<!--				customerCommission: null,-->
<!--				isAdjusted: null,-->
<!--				adjustDate: null,-->
<!--				cancelFlag: null,-->
<!--				comments: null,-->
<!--				addtime: null,-->
<!--				userId: null,-->
<!--				UserName: null-->
<!--			},-->

<!--			// 表单参数-->
<!--			form: {},-->
<!--			// 表单校验-->
<!--			rules: {},-->
<!--			// 隐藏列-->
<!--			columns: [-->
<!--				// {key: 50, label: ` 供应商ID`, visible: true},-->
<!--				{ key: 0, label: ` 客户ID`, visible: true },-->
<!--				{ key: 1, label: `级别编码`, visible: true },-->
<!--				{ key: 2, label: `级别名称`, visible: true },-->
<!--				{ key: 3, label: `计量单位`, visible: true },-->
<!--				{ key: 4, label: `厚度`, visible: true },-->
<!--				{ key: 5, label: `长度`, visible: true },-->
<!--				{ key: 6, label: `宽度`, visible: true },-->
<!--				{ key: 7, label: `出厂片数`, visible: true },-->
<!--				{ key: 8, label: `每包片数`, visible: true },-->
<!--				{ key: 9, label: `包数`, visible: true },-->
<!--				{ key: 10, label: `出厂单价`, visible: true },-->
<!--				{ key: 11, label: `出厂是否含税`, visible: true },-->
<!--				{ key: 12, label: `杂费`, visible: true },-->
<!--				{ key: 13, label: `出厂货款`, visible: true },-->
<!--				{ key: 14, label: `卸货价`, visible: true },-->
<!--				{ key: 15, label: `销售是否含税`, visible: true },-->
<!--				{ key: 16, label: `总货款`, visible: true },-->
<!--				{ key: 17, label: `误差`, visible: true },-->
<!--				{ key: 18, label: `吨位`, visible: true },-->
<!--				{ key: 19, label: `陆运费单价`, visible: true },-->
<!--				{ key: 20, label: `陆运费`, visible: true },-->
<!--				{ key: 21, label: `海运费`, visible: true },-->
<!--				{ key: 22, label: `总运费`, visible: true },-->
<!--				{ key: 23, label: `其他费用`, visible: true },-->
<!--				{ key: 24, label: `利润`, visible: true },-->
<!--				{ key: 25, label: `不含税利润`, visible: true },-->
<!--				{ key: 26, label: `卸货片数`, visible: true },-->
<!--				{ key: 27, label: `总货款杂费`, visible: true },-->
<!--				{ key: 28, label: `加费`, visible: true },-->
<!--				{ key: 29, label: `仓库ID`, visible: true },-->
<!--				{ key: 30, label: `仓库名称`, visible: true },-->
<!--				{ key: 31, label: `仓库存储的货物ID`, visible: true },-->
<!--				{ key: 32, label: `物流利润`, visible: true },-->
<!--				{ key: 33, label: `客户佣金`, visible: true },-->
<!--				{ key: 34, label: `是否被调整单`, visible: true },-->
<!--				{ key: 35, label: `调整日期`, visible: true },-->
<!--				{ key: 36, label: `供应商ID`, visible: true }-->
<!--			],-->
<!--			// 顶部条件搜索-->
<!--			queryOrderInfo: {},-->
<!--			// 点击查看的弹窗-->
<!--			checkOrderVisible: false,-->
<!--			// 调整单的弹窗-->
<!--			handleOrderVisible: false,-->
<!--			// 订单弹窗-->
<!--			Order1Visible: false,-->
<!--			Order2Visible: false,-->
<!--			Order3Visible: false,-->
<!--			// 上传和收到条-->
<!--			handleUploadVisible: false,-->
<!--			handleCommitVisible: false,-->
<!--			// 添加新订单的弹窗-->
<!--			addOrderItemVisible: false,-->
<!--			// 查看订单中的列表-->
<!--			orderDetailInfo: {},-->
<!--			// 添加订单详情-->
<!--			addOrderItem: {},-->
<!--			// 调整单的id-->
<!--			tempId: '',-->
<!--			// 订单输入详情信息-->
<!--			orderInfo: {}-->
<!--		};-->
<!--	},-->
<!--	created() {-->
<!--		this.getList();-->
<!--	},-->
<!--	methods: {-->
<!--		// 子组件提醒父组件修改orderInfo信息-->
<!--		handleChangeOrderInfo(val) {-->
<!--			this.orderInfo = val;-->
<!--		},-->

<!--		// 提交订单信息-->
<!--		onOrderSubmit() {},-->
<!--		// 是或者否-->
<!--		isOrNot(val) {-->
<!--			return val === 1 ? '是' : '否';-->
<!--		},-->
<!--		// 点击查看-->
<!--		checkOrderItemInfo(row) {-->
<!--			this.checkOrderVisible = true;-->
<!--			const id = row.id;-->
<!--			getOrderDetail(id).then(res => {-->
<!--				this.orderDetailInfo = res.data;-->
<!--			});-->
<!--		},-->

<!--		// 订单-->
<!--		handleOrder1() {-->
<!--			this.Order1Visible = true;-->
<!--		},-->
<!--		// 上传和收到条-->
<!--		handleUpload() {-->
<!--			this.handleUploadVisible = true;-->
<!--		},-->
<!--		handleCommit() {-->
<!--			this.handleCommitVisible = true;-->
<!--		},-->
<!--		submitChangeOrder() {-->
<!--			const id = this.tempId;-->
<!--			// 查询该id的订单详细信息-->
<!--			getOrderDetail(id).then(res => {-->
<!--				// 调整单 调用调整订单接口 传入数据-->
<!--				// todo 将ordersNo赋值为空-->
<!--				const orderInfo = res.data;-->
<!--				for (let i = 0; i < orderInfo.orderDetailList.length; i++) {-->
<!--					orderInfo.orderDetailList[i].ordersNo = '';-->
<!--				}-->
<!--				// 去除字段-->
<!--				orderInfo.delFlag = null;-->
<!--				orderInfo.addtime = null;-->
<!--				orderInfo.updateTime = null;-->
<!--				orderInfo.userId = null;-->
<!--				orderInfo.cancelFlag = null;-->
<!--			});-->
<!--		},-->
<!--		// 表格中的列自定义样式信息 渲染的时候每一个列都会执行这个函数-->
<!--		tableRowClassName({ row, rowIndex }) {},-->
<!--		// 提交订单-->
<!--		// 订单列表的对象封装一个，订单详情有两个一样的对象 对应供应商发货和仓库发货-->
<!--		// submitOrder() {-->
<!--		//   this.addOrderItemVisible = false-->
<!--		//   this.orderInfo.orderDetailList = this.orderItemList; //从vuex拿到订单详细列表 加入到订单信息中-->
<!--		//   //订单详情添加客户信息-->
<!--		//   for (let i = 0; i < this.orderItemList.length; i++) {-->
<!--		//     let item = this.orderItemList[i];-->
<!--		//     item.customerID = this.orderInfo.customerID;-->
<!--		//     item.customer = this.orderInfo.customer;-->
<!--		//   }-->
<!--		//   //添加订单 转化时间戳-->
<!--		//   const date = this.orderInfo.orderDate.getTime();-->
<!--		//   addGoodsOrder({...this.orderInfo, orderDate: date}).then(res => {-->
<!--		//     this.$message.success('订单提交成功')-->
<!--		//   }).catch(err => {-->
<!--		//     this.$message.error('订单提交失败' + err.msg)-->
<!--		//   })-->
<!--		// },-->

<!--		// 表格统计-->
<!--		// 自定义列统计总函数-->
<!--		getSummaries(param) {-->
<!--			const { columns, data } = param;-->
<!--			const sums = [];-->
<!--			columns.forEach((column, index) => {-->
<!--				if (index === 0) {-->
<!--					sums[index] = '统计';-->
<!--					return;-->
<!--				}-->
<!--				const values = data.map(item => {-->
<!--					return Number(item[column.property]);-->
<!--				});-->
<!--				if (!values.every(value => isNaN(value))) {-->
<!--					// 对指定列进行计算-->
<!--					// if(index)-->
<!--					// 需要进行统计的索引列-->
<!--					const out_list = [9, 10, 11];-->
<!--					// index !== 9 && index !== 1 && index !== 16 && index !== 2-->
<!--					if (out_list.includes(index)) {-->
<!--						sums[index] = values.reduce((prev, curr) => {-->
<!--							const value = Number(curr);-->
<!--							if (!isNaN(value)) {-->
<!--								return prev + curr;-->
<!--							} else {-->
<!--								return prev;-->
<!--							}-->
<!--						}, 0);-->
<!--						sums[index] += ' ';-->
<!--					}-->
<!--				} else {-->
<!--					sums[index] = '';-->
<!--				}-->
<!--			});-->
<!--			return sums;-->
<!--		},-->

<!--		// //点击查看-->
<!--		// checkOrderItemInfo(row) {-->
<!--		//   this.checkOrderVisible = true;-->
<!--		// },-->
<!--		// //点击调整单的弹窗-->
<!--		// handleOrderItemInfo(row) {-->
<!--		//   this.handleOrderVisible = true-->
<!--		// },-->
<!--		// //订单-->
<!--		// handleOrder1(row) {-->
<!--		//   this.Order1Visible = true-->
<!--		// },-->
<!--		// handleOrder2(row) {-->
<!--		//   this.Order2Visible = true-->
<!--		// },-->
<!--		// handleOrder3(row) {-->
<!--		//   this.Order3Visible = true-->
<!--		// },-->
<!--		// //上传和收到条-->
<!--		// handleUpload(row) {-->
<!--		//   this.handleUploadVisible = true-->
<!--		// },-->
<!--		// handleCommit(row) {-->
<!--		//   this.handleCommitVisible = true-->
<!--		// },-->
<!--		// 表格统计-->
<!--		// 自定义列统计总函数-->
<!--		// getSummaries(param) {-->
<!--		//   const {columns, data} = param;-->
<!--		//   const sums = [];-->
<!--		//   columns.forEach((column, index) => {-->
<!--		//     if (index === 0) {-->
<!--		//       sums[index] = '统计';-->
<!--		//       return;-->
<!--		//     }-->
<!--		//     const values = data.map(item => {-->
<!--		//       return Number(item[column.property])-->
<!--		//     });-->
<!--		//     if (!values.every(value => isNaN(value))) {-->
<!--		//       //对指定列进行计算-->
<!--		//       // if(index)-->
<!--		//       //需要进行统计的索引列-->
<!--		//       const out_list = [9, 10, 11]-->
<!--		//       //index !== 9 && index !== 1 && index !== 16 && index !== 2-->
<!--		//       if (out_list.includes(index)) {-->
<!--		//         sums[index] = values.reduce((prev, curr) => {-->
<!--		//           const value = Number(curr);-->
<!--		//           if (!isNaN(value)) {-->
<!--		//             return prev + curr;-->
<!--		//           } else {-->
<!--		//             return prev;-->
<!--		//           }-->
<!--		//         }, 0);-->
<!--		//         sums[index] += ' ';-->
<!--		//       }-->
<!--		//     } else {-->
<!--		//       sums[index] = '';-->
<!--		//     }-->
<!--		//   });-->
<!--		//   return sums;-->
<!--		// },-->
<!--		// 打印-->
<!--		printHTML() {-->
<!--			this.$print({-->
<!--				printable: 'printBox',-->
<!--				type: 'html',-->
<!--				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果-->
<!--			});-->
<!--		},-->
<!--		/** 查询订单详情列表 */-->
<!--		getList() {-->
<!--			this.loading = true;-->
<!--			listOrderDetail(this.queryParams).then(response => {-->
<!--				this.orderDetailList = response.rows;-->
<!--				this.total = response.total;-->
<!--				this.loading = false;-->
<!--			});-->
<!--		},-->
<!--		// 取消按钮-->
<!--		cancel() {-->
<!--			this.open = false;-->
<!--			this.reset();-->
<!--		},-->
<!--		// 表单重置-->
<!--		reset() {-->
<!--			this.form = {-->
<!--				id: null,-->
<!--				ordersNo: null,-->
<!--				orderDate: null,-->
<!--				supplier: null,-->
<!--				supplierID: null,-->
<!--				customer: null,-->
<!--				customerID: null,-->
<!--				levelID: null,-->
<!--				levelName: null,-->
<!--				countingUnit: null,-->
<!--				height: null,-->
<!--				length: null,-->
<!--				width: null,-->
<!--				pieces: null,-->
<!--				piecesPerPack: null,-->
<!--				packs: null,-->
<!--				price: null,-->
<!--				isIncludeTaxFactory: null,-->
<!--				sundryCost: null,-->
<!--				paymentFactory: null,-->
<!--				paymentUnload: null,-->
<!--				isIncludeTaxSale: null,-->
<!--				payments: null,-->
<!--				erro: null,-->
<!--				tonnage: null,-->
<!--				landFreightPrice: null,-->
<!--				landFreight: null,-->
<!--				seaFreight: null,-->
<!--				freight: null,-->
<!--				otherCost: null,-->
<!--				profit: null,-->
<!--				profitNoTax: null,-->
<!--				actualPieces: null,-->
<!--				paymentsWithSundry: null,-->
<!--				additionalFees: null,-->
<!--				storeHouseID: null,-->
<!--				storeHouseName: null,-->
<!--				storeID: null,-->
<!--				logisticsProfit: null,-->
<!--				customerCommission: null,-->
<!--				isAdjusted: null,-->
<!--				adjustDate: null,-->
<!--				cancelFlag: null,-->
<!--				comments: null,-->
<!--				addtime: null,-->
<!--				userId: null,-->
<!--				UserName: null,-->
<!--				updateTime: null-->
<!--			};-->
<!--			this.resetForm('form');-->
<!--		},-->
<!--		/** 搜索按钮操作 */-->
<!--		handleQuery() {-->
<!--			this.queryParams.pageNum = 1;-->
<!--			this.getList();-->
<!--		},-->
<!--		/** 重置按钮操作 */-->
<!--		resetQuery() {-->
<!--			this.resetForm('queryForm');-->
<!--			this.handleQuery();-->
<!--		},-->
<!--		// 多选框选中数据-->
<!--		handleSelectionChange(selection) {-->
<!--			this.ids = selection.map(item => item.id);-->
<!--			this.single = selection.length !== 1;-->
<!--			this.multiple = !selection.length;-->
<!--		},-->
<!--		/** 新增按钮操作 */-->
<!--		handleAdd() {-->
<!--			this.reset();-->
<!--			this.open = true;-->
<!--			this.title = '添加订单详情';-->
<!--		},-->
<!--		/** 修改按钮操作 */-->
<!--		handleUpdate(row) {-->
<!--			this.reset();-->
<!--			const id = row.id || this.ids;-->
<!--			getOrderDetail(id).then(response => {-->
<!--				this.form = response.data;-->
<!--				this.open = true;-->
<!--				this.title = '修改订单详情';-->
<!--			});-->
<!--		},-->
<!--		/** 提交按钮 */-->
<!--		submitForm() {-->
<!--			this.$refs['form'].validate(valid => {-->
<!--				if (valid) {-->
<!--					if (this.form.id != null) {-->
<!--						updateOrderDetail(this.form).then(response => {-->
<!--							this.$modal.msgSuccess('修改成功');-->
<!--							this.open = false;-->
<!--							this.getList();-->
<!--						});-->
<!--					} else {-->
<!--						addOrderDetail(this.form).then(response => {-->
<!--							this.$modal.msgSuccess('新增成功');-->
<!--							this.open = false;-->
<!--							this.getList();-->
<!--						});-->
<!--					}-->
<!--				}-->
<!--			});-->
<!--		},-->
<!--		/** 删除按钮操作 */-->
<!--		handleDelete(row) {-->
<!--			const ids = row.id || this.ids;-->
<!--			this.$modal-->
<!--				.confirm('是否确认删除订单详情编号为"' + ids + '"的数据项？')-->
<!--				.then(function () {-->
<!--					return delOrderDetail(ids);-->
<!--				})-->
<!--				.then(() => {-->
<!--					this.getList();-->
<!--					this.$modal.msgSuccess('删除成功');-->
<!--				})-->
<!--				.catch(() => {});-->
<!--		},-->
<!--		/** 导出按钮操作 */-->
<!--		handleExport() {-->
<!--			this.download(-->
<!--				'system/orderDetail/export',-->
<!--				{-->
<!--					...this.queryParams-->
<!--				},-->
<!--				`订单详情_${new Date().getTime()}.xlsx`-->
<!--			);-->
<!--		}-->
<!--	}-->
<!--};-->
<!--</script>-->
<!--<style></style>-->
