<!--<template>-->
<!--	<div class="app-container">-->
<!--		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">-->
<!--			<el-form-item label="级别名称" prop="levelName">-->
<!--				<el-input v-model="queryParams.levelName" placeholder="请输入级别名称" clearable @keyup.enter.native="handleQuery" />-->
<!--			</el-form-item>-->
<!--			<el-form-item>-->
<!--				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>-->
<!--			</el-form-item>-->
<!--		</el-form>-->
<!--		<el-row :gutter="10" class="mb8">-->
<!--			&lt;!&ndash; 刷新按钮&ndash;&gt;-->
<!--			<el-col :span="1.5">-->
<!--				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>-->
<!--			</el-col>-->
<!--			<el-col :span="1.5">-->
<!--				<el-button v-hasPermi="['system:inventory:add']" type="danger" size="mini" @click="addNewInventory">新增货物</el-button>-->
<!--			</el-col>-->
<!--			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">-->
<!--				<template #print>-->
<!--					<el-col :span="1.5">-->
<!--						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />-->
<!--					</el-col>-->
<!--				</template>-->
<!--				&lt;!&ndash;        导出&ndash;&gt;-->
<!--				<template #export>-->
<!--					<el-col :span="1.5">-->
<!--						<el-button v-hasPermi="['system:inventory:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />-->
<!--					</el-col>-->
<!--				</template>-->
<!--			</right-toolbar>-->
<!--		</el-row>-->

<!--		<el-row>-->
<!--			<el-col :span="4">-->
<!--				<div class="tree-container">-->
<!--					<el-tree :data="storeList" :props="defaultProps" @node-click="handleNodeClick" />-->
<!--				</div>-->
<!--			</el-col>-->
<!--			<el-col :span="20">-->
<!--				<el-table-->
<!--					v-horizontal-scroll="'always'"-->
<!--					v-loading="loading"-->
<!--					border-->
<!--					:data="inventoryList"-->
<!--					:cell-style="-->
<!--						() => {-->
<!--							return { padding: '2px' };-->
<!--						}-->
<!--					"-->
<!--					size="mini"-->
<!--					@selection-change="handleSelectionChange"-->
<!--				>-->
<!--					<el-table-column v-if="columns[0].visible" label="仓库名称" align="center" prop="storeHouseName" width="150" />-->
<!--					<el-table-column v-if="columns[1].visible" label="入库日期" align="center" prop="storeDate" width="150" />-->
<!--					<el-table-column v-if="columns[2].visible" label="库存量" align="center" prop="stockNumber" width="150" />-->
<!--					<el-table-column label="剩余量" align="center" prop="actualPieces" width="150" />-->
<!--					<el-table-column v-if="columns[3].visible" label="供应商" align="center" prop="supplier" width="150" />-->
<!--					<el-table-column v-if="columns[4].visible" label="级别编码" align="center" prop="levelID" width="150" />-->
<!--					<el-table-column v-if="columns[5].visible" label="级别名称" align="center" prop="levelName" width="150" />-->
<!--					<el-table-column v-if="columns[6].visible" label="计量单位" align="center" prop="countingUnit" width="150" />-->
<!--					<el-table-column v-if="columns[7].visible" label="厚度" align="center" prop="height" width="150" />-->
<!--					<el-table-column v-if="columns[8].visible" label="长度" align="center" prop="length" width="150" />-->
<!--					<el-table-column v-if="columns[9].visible" label="宽度" align="center" prop="width" width="150" />-->
<!--					<el-table-column v-if="columns[10].visible" label="出厂片数" align="center" prop="pieces" width="150" />-->
<!--					<el-table-column v-if="columns[11].visible" label="每包片数" align="center" prop="piecesPerPack" width="150" />-->
<!--					<el-table-column v-if="columns[12].visible" label="包数" align="center" prop="packs" width="150" />-->
<!--					<el-table-column v-if="columns[13].visible" label="出厂单价" align="center" prop="price" width="150" />-->
<!--					<el-table-column v-if="columns[14].visible" label="出厂是否含税" align="center" prop="isIncludeTaxFactory" width="150">-->
<!--						<template slot-scope="scope">-->
<!--							{{ scope.row.isIncludeTaxFactory === 0 ? '否' : '是' }}-->
<!--						</template>-->
<!--					</el-table-column>-->
<!--					<el-table-column v-if="columns[16].visible" label="出厂货款" align="center" prop="paymentFactory" width="150" />-->
<!--					<el-table-column v-if="columns[17].visible" label="卸货价" align="center" prop="paymentUnload" width="150" />-->
<!--					<el-table-column v-if="columns[18].visible" label="销售是否含税" align="center" prop="isIncludeTaxSale" width="150">-->
<!--						<template slot-scope="scope">-->
<!--							{{ scope.row.isIncludeTaxSale === 0 ? '否' : '是' }}-->
<!--						</template>-->
<!--					</el-table-column>-->
<!--					<el-table-column v-if="columns[19].visible" label="总货款" align="center" prop="payments" width="150" />-->
<!--					<el-table-column v-if="columns[20].visible" label="陆运车牌" align="center" prop="landCarNo" width="150" />-->
<!--					<el-table-column v-if="columns[21].visible" label="陆运司机电话" align="center" prop="landDriverTel" width="150" />-->
<!--					<el-table-column v-if="columns[22].visible" label="陆地司机姓名" align="center" prop="landDriverName" width="150" />-->
<!--					<el-table-column v-if="columns[23].visible" label="误差" align="center" prop="erro" width="150" />-->
<!--					<el-table-column v-if="columns[24].visible" label="吨位" align="center" prop="tonnage" width="150" />-->
<!--					<el-table-column label="柜号" align="center" prop="seaCarNo" width="150" />-->
<!--					<el-table-column label="海运司机电话" align="center" prop="seaDriverTel" width="150" />-->
<!--					<el-table-column label="海运公司" align="center" prop="seaDriverName" width="150" />-->
<!--					<el-table-column v-if="columns[26].visible" label="陆运费" align="center" prop="landFreight" width="150" />-->
<!--					<el-table-column v-if="columns[26].visible" label="海运费" align="center" prop="seaFreight" width="150" />-->
<!--					<el-table-column v-if="columns[27].visible" label="其他费用" align="center" prop="otherCost" width="150" />-->
<!--					<el-table-column v-if="columns[28].visible" label="利润" align="center" prop="profit" width="150" />-->
<!--					<el-table-column v-if="columns[29].visible" label="不含税利润" align="center" prop="profitNoTax" width="150" />-->
<!--					<el-table-column v-if="columns[30].visible" label="实际片数" align="center" prop="actualPieces" width="150" />-->
<!--					<el-table-column v-if="columns[31].visible" label="总货款杂费" align="center" prop="paymentsWithSundry" width="150" />-->
<!--					<el-table-column v-if="columns[32].visible" label="加费" align="center" prop="additionalFees" width="150" />-->
<!--					<el-table-column v-if="columns[33].visible" label="返利金额" align="center" prop="rebate" width="150" />-->
<!--					<el-table-column v-if="columns[34].visible" label="厂家佣金" align="center" prop="customerCommission" width="150" />-->
<!--					<el-table-column v-if="columns[35].visible" label="备注" align="center" prop="comments" width="150" />-->
<!--					<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="280" fixed="right">-->
<!--						<template slot-scope="scope">-->
<!--							&lt;!&ndash;  付运费 要指定类型 为 goodsorder inventory&ndash;&gt;-->
<!--							<el-button size="mini" type="text" @click="handlePayment(scope.row)">付款</el-button>-->
<!--							<el-button size="mini" type="text" @click="secondryInventoryOut(scope.row)">加工后出库</el-button>-->
<!--							<el-button size="mini" type="text" @click="afterbreakInventoryOut(scope.row)">破损后出库</el-button>-->
<!--							<el-button size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>-->
<!--							<el-button v-hasPermi="['system:inventory:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>-->
<!--						</template>-->
<!--					</el-table-column>-->
<!--				</el-table>-->
<!--			</el-col>-->
<!--		</el-row>-->

<!--		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />-->

<!--		&lt;!&ndash; 添加或修改库存对话框 &ndash;&gt;-->
<!--		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1300px" append-to-body>-->
<!--			<el-form ref="form" :model="form" :rules="rules" label-width="120px">-->
<!--				<el-row>-->
<!--					<el-col :span="6">-->
<!--						<el-form-item label="仓库名称" prop="storeHouseName">-->
<!--							<el-row>-->
<!--								<el-col :span="10">-->
<!--									<el-input v-model="form.storeHouseName" placeholder="请输入仓库名称" />-->
<!--								</el-col>-->
<!--								<el-col :span="3">-->
<!--									<SearchOption :get-data="listStoreHouse" :limit-info="{}" @commitBack="handleCommitBackStoreHouse">-->
<!--										<template #table-columns>-->
<!--											<el-table-column label="仓库名称" align="center" prop="storeHouseName" />-->
<!--											<el-table-column label="地址" align="center" prop="address" />-->
<!--										</template>-->
<!--									</SearchOption>-->
<!--								</el-col>-->
<!--							</el-row>-->
<!--						</el-form-item>-->
<!--						<el-form-item label="入库日期" prop="storeDate">-->
<!--							<el-date-picker v-model="form.storeDate" type="datetime" placeholder="入库日期" value-format="yyyy-MM-dd HH:mm:ss" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="库存量" prop="stockNumber">-->
<!--							<el-input v-model="form.stockNumber" placeholder="请输入库存量" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="供应商" prop="supplier">-->
<!--							<el-row>-->
<!--								<el-col :span="10">-->
<!--									<el-input v-model="form.supplier" placeholder="请输入供应商" />-->
<!--								</el-col>-->
<!--								<el-col :span="3">-->
<!--									<SearchOption :get-data="listCompany" :limit-info="{ companyType: '供应商' }" @commitBack="handleCommitBackCompany">-->
<!--										<template #table-columns>-->
<!--											<el-table-column label="供应商名称" align="center" prop="companyName" />-->
<!--											<el-table-column label="联系人" align="center" prop="relationName" />-->
<!--											<el-table-column label="电话" align="center" prop="relationTel" />-->
<!--										</template>-->
<!--									</SearchOption>-->
<!--								</el-col>-->
<!--							</el-row>-->
<!--						</el-form-item>-->
<!--						<el-form-item label="级别编码" prop="levelID">-->
<!--							<el-row>-->
<!--								<el-col :span="10">-->
<!--									<el-input v-model="form.levelID" placeholder="请输入级别编码" />-->
<!--								</el-col>-->
<!--								<el-col :span="3">-->
<!--									<SearchOption :limit-info="{}" :get-data="listProductLevel" @commitBack="handleCommitBackProductLevel">-->
<!--										<template #table-columns>-->
<!--											<el-table-column label="级别编码" align="center" prop="levelNo" />-->
<!--											<el-table-column label="级别名称" align="center" prop="levelName" />-->
<!--										</template>-->
<!--									</SearchOption>-->
<!--								</el-col>-->
<!--							</el-row>-->
<!--						</el-form-item>-->
<!--						<el-form-item label="级别名称" prop="levelName">-->
<!--							<el-input v-model="form.levelName" placeholder="请输入级别名称" />-->
<!--						</el-form-item>-->
<!--						&lt;!&ndash;        基本信息&ndash;&gt;-->
<!--						<el-form-item label="计量单位" prop="countingUnit">-->
<!--							<el-input v-model="form.countingUnit" placeholder="请输入计量单位" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="厚度" prop="height">-->
<!--							<el-input v-model="form.height" placeholder="请输入厚度" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="长度" prop="length">-->
<!--							<el-input v-model="form.length" placeholder="请输入长度" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="宽度" prop="width">-->
<!--							<el-input v-model="form.width" placeholder="请输入宽度" />-->
<!--						</el-form-item>-->
<!--					</el-col>-->
<!--					<el-col :span="6">-->
<!--						<el-form-item label="出厂片数" prop="pieces">-->
<!--							<el-input v-model="form.pieces" placeholder="请输入出厂片数" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="每包片数" prop="piecesPerPack">-->
<!--							<el-input v-model="form.piecesPerPack" placeholder="请输入每包片数" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="包数" prop="packs">-->
<!--							<el-input v-model="form.packs" placeholder="请输入包数" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="出厂单价" prop="price">-->
<!--							<el-input v-model="form.price" placeholder="请输入出厂单价" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="出厂是否含税" prop="isIncludeTaxFactory">-->
<!--							<el-radio v-model="form.isIncludeTaxFactory" :label="1">是</el-radio>-->
<!--							<el-radio v-model="form.isIncludeTaxFactory" :label="0">否</el-radio>-->
<!--						</el-form-item>-->
<!--						&lt;!&ndash;						<el-form-item label="杂费" prop="sundryCost">&ndash;&gt;-->
<!--						&lt;!&ndash;							<el-input v-model="form.sundryCost" placeholder="请输入杂费" />&ndash;&gt;-->
<!--						&lt;!&ndash;						</el-form-item>&ndash;&gt;-->
<!--						<el-form-item label="出厂货款" prop="paymentFactory">-->
<!--							<el-input v-model="form.paymentFactory" placeholder="请输入出厂货款" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="卸货价" prop="paymentUnload">-->
<!--							<el-input v-model="form.paymentUnload" placeholder="请输入卸货价" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="销售是否含税" prop="isIncludeTaxSale">-->
<!--							<el-radio v-model="form.isIncludeTaxSale" :label="1">是</el-radio>-->
<!--							<el-radio v-model="form.isIncludeTaxSale" :label="0">否</el-radio>-->
<!--						</el-form-item>-->
<!--						<el-form-item label="总货款" prop="payments">-->
<!--							<el-input v-model="form.payments" placeholder="请输入总货款" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="陆运车牌" prop="landCarNo">-->
<!--							<el-row>-->
<!--								<el-col :span="10">-->
<!--									<el-input v-model="form.landCarNo" placeholder="请输入陆运车牌" />-->
<!--								</el-col>-->
<!--								<el-col :span="3">-->
<!--									<SearchOption :get-data="listCars" :limit-info="{ carType: '陆运' }" @commitBack="handleCommitBackCars">-->
<!--										<template #table-columns>-->
<!--											<el-table-column label="车牌" align="center" prop="carNo" />-->
<!--											<el-table-column label="司机" align="center" prop="driver" />-->
<!--											<el-table-column label="司机电话" align="center" prop="tel" />-->
<!--										</template>-->
<!--									</SearchOption>-->
<!--								</el-col>-->
<!--							</el-row>-->
<!--						</el-form-item>-->
<!--					</el-col>-->
<!--					<el-col :span="6">-->
<!--						<el-form-item label="陆运司机电话" prop="landDriverTel">-->
<!--							<el-input v-model="form.landDriverTel" placeholder="请输入陆运司机电话" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="陆地司机姓名" prop="landDriverName">-->
<!--							<el-input v-model="form.landDriverName" placeholder="请输入陆地司机姓名" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="柜号" prop="seaCarNo">-->
<!--							<el-row>-->
<!--								<el-col :span="10">-->
<!--									<el-input v-model="form.seaCarNo" placeholder="请输入陆运车牌" />-->
<!--								</el-col>-->
<!--								<el-col :span="3">-->
<!--									<SearchOption :get-data="listCars" :limit-info="{ carType: '海运' }" @commitBack="handleCommitBackSea">-->
<!--										<template #table-columns>-->
<!--											<el-table-column label="车牌" align="center" prop="carNo" />-->
<!--											<el-table-column label="司机" align="center" prop="driver" />-->
<!--											<el-table-column label="司机电话" align="center" prop="tel" />-->
<!--										</template>-->
<!--									</SearchOption>-->
<!--								</el-col>-->
<!--							</el-row>-->
<!--						</el-form-item>-->
<!--						<el-form-item label="海运司机电话" prop="seaDriverTel">-->
<!--							<el-input v-model="form.seaDriverTel" placeholder="请输入内容" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="海运公司" prop="seaDriverName">-->
<!--							<el-input v-model="form.seaDriverName" placeholder="请输入海运公司" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="误差" prop="erro">-->
<!--							<el-input v-model="form.erro" placeholder="请输入误差" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="吨位" prop="tonnage">-->
<!--							<el-input v-model="form.tonnage" placeholder="请输入吨位" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="陆运费单价" prop="landFreightPrice">-->
<!--							<el-input v-model="form.landFreightPrice" placeholder="请输入陆运费单价" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="陆运费" prop="landFreight">-->
<!--							<el-input v-model="form.landFreight" placeholder="请输入陆运费" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="海运费" prop="seaFreight">-->
<!--							<el-input v-model="form.seaFreight" placeholder="请输入海运费" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="运费" prop="freight">-->
<!--							<el-input v-model="form.freight" placeholder="请输入运费" />-->
<!--						</el-form-item>-->
<!--					</el-col>-->
<!--					<el-col :span="6">-->
<!--						<el-form-item label="其他费用" prop="otherCost">-->
<!--							<el-input v-model="form.otherCost" placeholder="请输入其他费用" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="利润" prop="profit">-->
<!--							<el-input v-model="form.profit" placeholder="请输入利润" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="不含税利润" prop="profitNoTax">-->
<!--							<el-input v-model="form.profitNoTax" placeholder="请输入不含税利润" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="实际片数" prop="actualPieces">-->
<!--							<el-input v-model="form.actualPieces" placeholder="请输入实际片数" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="总货款杂费" prop="paymentsWithSundry">-->
<!--							<el-input v-model="form.paymentsWithSundry" placeholder="请输入总货款杂费" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="加费" prop="additionalFees">-->
<!--							<el-input v-model="form.additionalFees" placeholder="请输入加费" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="返利金额" prop="rebate">-->
<!--							<el-input v-model="form.rebate" placeholder="请输入返利金额" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="厂家佣金" prop="customerCommission">-->
<!--							<el-input v-model="form.customerCommission" placeholder="请输入厂家佣金" />-->
<!--						</el-form-item>-->
<!--						<el-form-item label="备注" prop="comments">-->
<!--							<el-input v-model="form.comments" placeholder="请输入备注" />-->
<!--						</el-form-item>-->
<!--					</el-col>-->
<!--				</el-row>-->
<!--			</el-form>-->
<!--			<div slot="footer" class="dialog-footer">-->
<!--				<el-button type="primary" @click="submitForm">确 定</el-button>-->
<!--				<el-button @click="cancel">取 消</el-button>-->
<!--			</div>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    通用的弹窗&ndash;&gt;-->
<!--		<div v-if="currentComponent">-->
<!--			&lt;!&ndash;    通用弹窗&ndash;&gt;-->
<!--			<DialogWrapper-->
<!--				:current-component="currentComponent"-->
<!--				:dialog-visible="dialogVisible"-->
<!--				:dialog-props="dialogProps"-->
<!--				:dialog-title="dialogTitle"-->
<!--				:dialog-width="dialogWidth"-->
<!--				@update:dialogVisible="args => (dialogVisible = false)"-->
<!--				@close="handleCloseDialog"-->
<!--				@confirm="handleDialogConfirm"-->
<!--			/>-->
<!--		</div>-->

<!--		&lt;!&ndash;    二次出库&ndash;&gt;-->
<!--		<el-dialog :close-on-click-modal="false" :show-close="false" title="二次出库" :visible.sync="secondInvoiceInVisible" width="30%" append-to-body>-->
<!--			<div slot="footer" class="dialog-footer">-->
<!--				<el-row :gutter="5">-->
<!--					<el-col :span="8">-->
<!--						<span style="font-weight: bolder; line-height: 30px">请输入出库数量</span>-->
<!--					</el-col>-->
<!--					<el-col :span="10">-->
<!--						<el-input type="number" v-model="secondNumber" placeholder="请输入出库数量" />-->
<!--					</el-col>-->
<!--				</el-row>-->
<!--				<br />-->
<!--				<el-button type="primary" @click="submitSecondInvoiceIn">确 定</el-button>-->
<!--				<el-button @click="secondInvoiceInVisible = false">取 消</el-button>-->
<!--			</div>-->
<!--		</el-dialog>-->

<!--		&lt;!&ndash;    货物破损出库&ndash;&gt;-->
<!--		<el-dialog :close-on-click-modal="false" :show-close="false" title="货物破损出库" :visible.sync="breakInvoiceInVisible" width="30%" append-to-body>-->
<!--			<div slot="footer" class="dialog-footer">-->
<!--				<el-row :gutter="5">-->
<!--					<el-col :span="8">-->
<!--						<span style="font-weight: bolder; line-height: 30px">请输入出库数量</span>-->
<!--					</el-col>-->
<!--					<el-col :span="10">-->
<!--						<el-input type="number" v-model="breakNumber" placeholder="请输入出库数量" />-->
<!--					</el-col>-->
<!--				</el-row>-->
<!--				<br />-->
<!--				<el-button type="primary" @click="submitBreakInvoiceIn">确 定</el-button>-->
<!--				<el-button @click="breakInvoiceInVisible = false">取 消</el-button>-->
<!--			</div>-->
<!--		</el-dialog>-->
<!--	</div>-->
<!--</template>-->

<!--<script>-->
<!--import { listStoreHouse } from '@/api/system/StoreHouse';-->
<!--import { listCars } from '@/api/system/cars';-->
<!--import { listCompany } from '@/api/system/company';-->
<!--import { addInventory, delInventory, getInventory, listInventory, updateInventory } from '@/api/system/inventory';-->
<!--import { listProductLevel } from '@/api/system/productLevel';-->
<!--import { addReason } from '@/api/system/user';-->
<!--import { TableName } from '@/api/tool/enums';-->
<!--import { excludeParams } from '@/api/tool/exclude';-->
<!--import SearchOption from '@/components/SearchOption.vue';-->
<!--import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';-->
<!--import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';-->
<!--import { mixin_freight_payment } from '@/views/dashboard/mixins/freight/freight_payment';-->
<!--import { mixin_printHTML } from '@/views/dashboard/mixins/print';-->
<!--import { mapGetters } from 'vuex';-->
<!--import { mixin_inventory_add } from '../../dashboard/mixins/inventory/inventory_add';-->
<!--import { mixin_inventory_broken } from '../../dashboard/mixins/inventory/inventory_broken';-->
<!--import { mixin_inventory_second } from '../../dashboard/mixins/inventory/inventory_second';-->

<!--export default {-->
<!--	name: 'Inventory',-->
<!--	components: { DialogWrapper, SearchOption },-->
<!--	mixins: [-->
<!--		// 通用的弹窗组件混入-->
<!--		common_dialog,-->
<!--		mixin_printHTML,-->
<!--		mixin_inventory_second,-->
<!--		mixin_inventory_broken,-->
<!--		mixin_inventory_add,-->
<!--		mixin_freight_payment-->
<!--	],-->
<!--	data() {-->
<!--		return {-->
<!--			loading: true,-->
<!--			ids: [],-->
<!--			single: true,-->
<!--			multiple: true,-->
<!--			showSearch: true,-->
<!--			total: 0,-->
<!--			inventoryList: [],-->
<!--			title: '',-->
<!--			open: false,-->
<!--			queryParams: {-->
<!--				pageNum: 1,-->
<!--				pageSize: 10,-->
<!--				storeHouseid: null,-->
<!--				storeHouseName: null,-->
<!--				storeDate: null,-->
<!--				stockNumber: null,-->
<!--				supplier: null,-->
<!--				supplierId: null,-->
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
<!--				landCarID: null,-->
<!--				landCarNo: null,-->
<!--				landDriverTel: null,-->
<!--				landDriverName: null,-->
<!--				seaCarID: null,-->
<!--				seaCarNo: null,-->
<!--				seaDriverTel: null,-->
<!--				seaDriverName: null,-->
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
<!--				rebate: null,-->
<!--				customerCommission: null,-->
<!--				comments: null,-->
<!--				addtime: null,-->
<!--				userId: null,-->
<!--				UserName: null,-->
<!--				delFlag: null,-->
<!--				showFlag: null-->
<!--			},-->
<!--			form: {},-->
<!--			rules: {},-->
<!--			columns: [-->
<!--				/*  {key: 0, label: `id`, visible: true},*/-->
<!--				{ key: 0, label: `仓库名称`, visible: true },-->
<!--				{ key: 1, label: `入库日期`, visible: true },-->
<!--				{ key: 2, label: `库存量`, visible: true },-->
<!--				{ key: 3, label: `供应商`, visible: true },-->
<!--				{ key: 4, label: `级别编码`, visible: true },-->
<!--				{ key: 5, label: `级别名称`, visible: true },-->
<!--				{ key: 6, label: `计量单位`, visible: true },-->
<!--				{ key: 7, label: `厚度`, visible: true },-->
<!--				{ key: 8, label: `长度`, visible: true },-->
<!--				{ key: 9, label: `宽度`, visible: true },-->
<!--				{ key: 10, label: `出厂片数`, visible: true },-->
<!--				{ key: 11, label: `每包片数`, visible: true },-->
<!--				{ key: 12, label: `包数`, visible: true },-->
<!--				{ key: 13, label: `出厂单价`, visible: true },-->
<!--				{ key: 14, label: `出厂是否含税`, visible: true },-->
<!--				{ key: 15, label: `杂费`, visible: true },-->
<!--				{ key: 16, label: `出厂贷款`, visible: true },-->
<!--				{ key: 17, label: `卸货价`, visible: true },-->
<!--				{ key: 18, label: `销售是否含税`, visible: true },-->
<!--				{ key: 19, label: `总货款`, visible: true },-->
<!--				{ key: 20, label: `陆运车牌`, visible: true },-->
<!--				{ key: 21, label: `陆运司机电话`, visible: true },-->
<!--				{ key: 22, label: `陆运司机姓名`, visible: true },-->
<!--				{ key: 23, label: `误差`, visible: true },-->
<!--				{ key: 24, label: `吨位`, visible: true },-->
<!--				{ key: 25, label: `陆运费单价`, visible: true },-->
<!--				{ key: 26, label: `运费`, visible: true },-->
<!--				{ key: 27, label: `其他费用`, visible: true },-->
<!--				{ key: 28, label: `利润`, visible: true },-->
<!--				{ key: 29, label: `不含利润率`, visible: true },-->
<!--				{ key: 30, label: `实际片数`, visible: true },-->
<!--				{ key: 31, label: `总贷款杂费`, visible: true },-->
<!--				{ key: 32, label: `加费`, visible: true },-->
<!--				{ key: 33, label: `返利金额`, visible: true },-->
<!--				{ key: 34, label: `厂家佣金`, visible: true },-->
<!--				{ key: 35, label: `备注`, visible: true }-->
<!--			],-->

<!--			// 树表的数据结构-->
<!--			defaultProps: {-->
<!--				label: 'label'-->
<!--			}-->
<!--		};-->
<!--	},-->
<!--	computed: {-->
<!--		// 拿到完整的货物信息-->
<!--		...mapGetters(['inventoryInfoAll'])-->
<!--	},-->
<!--	// 展示与隐藏-->
<!--	watch: {-->
<!--		columns: {-->
<!--			handler: function (newVal) {-->
<!--				localStorage.setItem('inventory-columns', JSON.stringify(newVal));-->
<!--			},-->
<!--			deep: true-->
<!--		}-->
<!--	},-->
<!--	created() {-->
<!--		// 获取仓库信息-->
<!--		listStoreHouse().then(res => {-->
<!--			this.storeList = res.rows.map(item => {-->
<!--				return {-->
<!--					label: item.storeHouseName,-->
<!--					children: []-->
<!--				};-->
<!--			});-->
<!--		});-->
<!--		this.getList();-->
<!--		if (localStorage.getItem('inventory-columns') === 'null' || !localStorage.getItem('inventory-columns')) {-->
<!--			// 设置localStorage-->
<!--			localStorage.setItem('inventory-columns', JSON.stringify(this.columns));-->
<!--		} else {-->
<!--			this.columns = JSON.parse(localStorage.getItem('inventory-columns'));-->
<!--		}-->
<!--	},-->
<!--	methods: {-->
<!--		listCars,-->
<!--		listProductLevel,-->
<!--		listCompany,-->
<!--		listStoreHouse,-->
<!--		// 左侧树点击-->
<!--		handleNodeClick(data) {-->
<!--			this.loading = true;-->
<!--			listInventory({ storeHouseName: data.label }).then(res => {-->
<!--				this.inventoryList = res.rows;-->
<!--				this.loading = false;-->
<!--			});-->
<!--		},-->
<!--		// 选中仓库点击确定的回调-->
<!--		handleCommitBackStoreHouse(val) {-->
<!--			this.form.storeHouseName = val.storeHouseName;-->
<!--			this.form.storeHouseid = val.id;-->
<!--		},-->
<!--		// 选中供应商确定-->
<!--		handleCommitBackCompany(val) {-->
<!--			this.form.supplier = val.companyName;-->
<!--			this.form.supplierId = val.id;-->
<!--		},-->
<!--		// 选中级别编码的回调-->
<!--		handleCommitBackProductLevel(val) {-->
<!--			this.form.levelID = val.id;-->
<!--			this.form.levelName = val.levelName;-->
<!--		},-->
<!--		handleCommitBackCars(val) {-->
<!--			this.form.landCarNo = val.carNo;-->
<!--			this.form.landDriverTel = val.tel;-->
<!--			this.form.landDriverName = val.driver;-->
<!--			this.form.landCarID = val.id;-->
<!--		},-->
<!--		handleCommitBackSea(val) {-->
<!--			this.form.seaCarNo = val.carNo;-->
<!--			this.form.seaDriverTel = val.tel;-->
<!--			this.form.seaDriverName = val.driver;-->
<!--			this.form.seaCarID = val.id;-->
<!--		},-->

<!--		/** 查询库存列表 */-->
<!--		getList() {-->
<!--			this.loading = true;-->
<!--			listInventory(this.queryParams).then(response => {-->
<!--				this.inventoryList = response.rows;-->
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
<!--				storeHouseid: null,-->
<!--				storeHouseName: null,-->
<!--				storeDate: null,-->
<!--				stockNumber: null,-->
<!--				supplier: null,-->
<!--				supplierId: null,-->
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
<!--				landCarID: null,-->
<!--				landCarNo: null,-->
<!--				landDriverTel: null,-->
<!--				landDriverName: null,-->
<!--				seaCarID: null,-->
<!--				seaCarNo: null,-->
<!--				seaDriverTel: null,-->
<!--				seaDriverName: null,-->
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
<!--				rebate: null,-->
<!--				customerCommission: null,-->
<!--				comments: null,-->
<!--				addtime: null,-->
<!--				userId: null,-->
<!--				UserName: null,-->
<!--				updateTime: null,-->
<!--				delFlag: null,-->
<!--				showFlag: null-->
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
<!--		/** 修改按钮操作 */-->
<!--		handleUpdate(row) {-->
<!--			// this.$prompt('请输入编辑原因', '提示', {-->
<!--			// 	confirmButtonText: '确定',-->
<!--			// 	cancelButtonText: '取消',-->
<!--			// 	type: 'warning'-->
<!--			// })-->
<!--			// 	.then(({ value }) => {-->
<!--			// 		addReason({-->
<!--			// 			reason: value,-->
<!--			// 			tableName: TableName.INVENTORY,-->
<!--			// 			tid: row.id,-->
<!--			// 			modifyTime: this.modifyTime-->
<!--			// 		}).then(() => {-->
<!--			// 			this.$message.success('提交成功');-->
<!--			// 			this.reset();-->
<!--			// 			const id = row.id || this.ids;-->
<!--			// 			getInventory(id).then(response => {-->
<!--			// 				this.form = response.data;-->
<!--			// 				this.open = true;-->
<!--			// 				this.title = '修改库存';-->
<!--			// 			});-->
<!--			// 		});-->
<!--			// 	})-->
<!--			// 	.catch(() => {-->
<!--			// 		this.$message({-->
<!--			// 			type: 'warning',-->
<!--			// 			message: '请先输入编辑原因!'-->
<!--			// 		});-->
<!--			// 	});-->

<!--			this.reset();-->
<!--			const id = row.id || this.ids;-->
<!--			getInventory(id).then(response => {-->
<!--				this.form = response.data;-->
<!--				this.open = true;-->
<!--				this.title = '修改库存';-->
<!--			});-->
<!--		},-->
<!--		/** 提交按钮 */-->
<!--		submitForm() {-->
<!--			this.$refs['form'].validate(valid => {-->
<!--				if (valid) {-->
<!--					if (this.form.id != null) {-->
<!--						this.form = excludeParams(this.form, this.$exclude);-->
<!--						this.form.isIncludeTaxFactory = this.form.isIncludeTaxFactory === '是' ? '1' : '0';-->
<!--						this.form.isIncludeTaxSale = this.form.isIncludeTaxSale === '是' ? '1' : '0';-->
<!--						updateInventory(this.form).then(() => {-->
<!--							this.$modal.msgSuccess('修改成功');-->
<!--							this.open = false;-->
<!--							this.getList();-->
<!--						});-->
<!--					} else {-->
<!--						this.form = excludeParams(this.form, this.$exclude);-->
<!--						this.form.isIncludeTaxFactory = this.form.isIncludeTaxFactory === '是' ? '1' : '0';-->
<!--						this.form.isIncludeTaxSale = this.form.isIncludeTaxSale === '是' ? '1' : '0';-->
<!--						addInventory(this.form).then(() => {-->
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
<!--				.confirm('是否确认删除库存编号为"' + ids + '"的数据项？')-->
<!--				.then(function () {-->
<!--					return delInventory(ids);-->
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
<!--				'system/inventory/export',-->
<!--				{-->
<!--					...this.queryParams-->
<!--				},-->
<!--				`inventory_${new Date().getTime()}.xlsx`-->
<!--			);-->
<!--		}-->
<!--	}-->
<!--};-->
<!--</script>-->

<!--<style scoped>-->
<!--.tree-container {-->
<!--	max-height: 400px; /* 设置容器的最大高度 */-->
<!--	overflow-y: auto; /* 超出高度时显示垂直滚动条 */-->
<!--	border: 1px solid #ebeef5; /* 添加边框便于视觉分隔 */-->
<!--	padding: 10px; /* 可选，增加内容边距 */-->
<!--}-->
<!--</style>-->
