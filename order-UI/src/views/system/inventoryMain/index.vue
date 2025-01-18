<template>
	<div class="app-container">
		<el-form
			:model="queryParams"
			ref="queryForm"
			size="small"
			:inline="true"
			v-show="showSearch"
			label-width="68px"
		>
			<el-form-item label="仓库ID" prop="storeHouseid">
				<el-input
					v-model="queryParams.storeHouseid"
					placeholder="请输入仓库ID"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input
					v-model="queryParams.storeHouseName"
					placeholder="请输入仓库名称"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="入库日期" prop="storeDate">
				<el-input
					v-model="queryParams.storeDate"
					placeholder="请输入入库日期"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="陆运车辆ID" prop="landCarID">
				<el-input
					v-model="queryParams.landCarID"
					placeholder="请输入陆运车辆ID"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="陆运车牌" prop="landCarNo">
				<el-input
					v-model="queryParams.landCarNo"
					placeholder="请输入陆运车牌"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="陆运司机电话" prop="landDriverTel">
				<el-input
					v-model="queryParams.landDriverTel"
					placeholder="请输入陆运司机电话"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="陆地司机姓名" prop="landDriverName">
				<el-input
					v-model="queryParams.landDriverName"
					placeholder="请输入陆地司机姓名"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="海运车辆ID" prop="seaCarID">
				<el-input
					v-model="queryParams.seaCarID"
					placeholder="请输入海运车辆ID"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="海运司机姓名" prop="seaDriverName">
				<el-input
					v-model="queryParams.seaDriverName"
					placeholder="请输入海运司机姓名"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="添加时间" prop="addtime">
				<el-input
					v-model="queryParams.addtime"
					placeholder="请输入添加时间"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="操作人员ID" prop="userId">
				<el-input
					v-model="queryParams.userId"
					placeholder="请输入操作人员ID"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="操作人员姓名" prop="UserName">
				<el-input
					v-model="queryParams.UserName"
					placeholder="请输入操作人员姓名"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="删除标记" prop="delFlag">
				<el-input
					v-model="queryParams.delFlag"
					placeholder="请输入删除标记"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="订单仓库选择时是否显示" prop="showFlag">
				<el-input
					v-model="queryParams.showFlag"
					placeholder="请输入订单仓库选择时是否显示"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="二次入库对应的出库id" prop="exWareHoustId">
				<el-input
					v-model="queryParams.exWareHoustId"
					placeholder="请输入二次入库对应的出库id"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="货物来源公司(本部或者海盛)" prop="goodsCompany">
				<el-input
					v-model="queryParams.goodsCompany"
					placeholder="请输入货物来源公司(本部或者海盛)"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="子项陆运费之和" prop="allLandFreight">
				<el-input
					v-model="queryParams.allLandFreight"
					placeholder="请输入子项陆运费之和"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="子项海运费之和" prop="allSeaFreight">
				<el-input
					v-model="queryParams.allSeaFreight"
					placeholder="请输入子项海运费之和"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
					>搜索</el-button
				>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
					>重置</el-button
				>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button
					type="primary"
					plain
					icon="el-icon-plus"
					size="mini"
					@click="handleAdd"
					v-hasPermi="['system:inventoryMain:add']"
					>新增
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					type="success"
					plain
					icon="el-icon-edit"
					size="mini"
					:disabled="single"
					@click="handleUpdate"
					v-hasPermi="['system:inventoryMain:edit']"
					>修改
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					type="danger"
					plain
					icon="el-icon-delete"
					size="mini"
					:disabled="multiple"
					@click="handleDelete"
					v-hasPermi="['system:inventoryMain:remove']"
					>删除
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					type="warning"
					plain
					icon="el-icon-download"
					size="mini"
					@click="handleExport"
					v-hasPermi="['system:inventoryMain:export']"
					>导出
				</el-button>
			</el-col>
			<right-toolbar
				:showSearch.sync="showSearch"
				@queryTable="getList"
			></right-toolbar>
		</el-row>

		<el-table
			v-loading="loading"
			:data="inventoryMainList"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column label="主键ID" align="center" prop="id" />
			<el-table-column label="仓库ID" align="center" prop="storeHouseid" />
			<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
			<el-table-column label="入库日期" align="center" prop="storeDate" />
			<el-table-column label="陆运车辆ID" align="center" prop="landCarID" />
			<el-table-column label="陆运车牌" align="center" prop="landCarNo" />
			<el-table-column
				label="陆运司机电话"
				align="center"
				prop="landDriverTel"
			/>
			<el-table-column
				label="陆地司机姓名"
				align="center"
				prop="landDriverName"
			/>
			<el-table-column label="海运车辆ID" align="center" prop="seaCarID" />
			<el-table-column label="海运车牌" align="center" prop="seaCarNo" />
			<el-table-column
				label="海运司机电话"
				align="center"
				prop="seaDriverTel"
			/>
			<el-table-column
				label="海运司机姓名"
				align="center"
				prop="seaDriverName"
			/>
			<el-table-column label="添加时间" align="center" prop="addtime" />
			<el-table-column label="操作人员ID" align="center" prop="userId" />
			<el-table-column label="操作人员姓名" align="center" prop="UserName" />
			<el-table-column label="删除标记" align="center" prop="delFlag" />
			<el-table-column
				label="订单仓库选择时是否显示"
				align="center"
				prop="showFlag"
			/>
			<el-table-column
				label="二次入库对应的出库id"
				align="center"
				prop="exWareHoustId"
			/>
			<el-table-column
				label="货物来源公司(本部或者海盛)"
				align="center"
				prop="goodsCompany"
			/>
			<el-table-column
				label="子项陆运费之和"
				align="center"
				prop="allLandFreight"
			/>
			<el-table-column
				label="子项海运费之和"
				align="center"
				prop="allSeaFreight"
			/>
			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
			>
				<template slot-scope="scope">
					<el-button
						size="mini"
						type="text"
						icon="el-icon-edit"
						@click="handleUpdate(scope.row)"
						v-hasPermi="['system:inventoryMain:edit']"
						>修改
					</el-button>
					<el-button
						size="mini"
						type="text"
						icon="el-icon-delete"
						@click="handleDelete(scope.row)"
						v-hasPermi="['system:inventoryMain:remove']"
						>删除
					</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>

		<!-- 添加或修改库存库存主表对话框 -->
		<el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="仓库ID" prop="storeHouseid">
					<el-input v-model="form.storeHouseid" placeholder="请输入仓库ID" />
				</el-form-item>
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-input
						v-model="form.storeHouseName"
						placeholder="请输入仓库名称"
					/>
				</el-form-item>
				<el-form-item label="入库日期" prop="storeDate">
					<el-input v-model="form.storeDate" placeholder="请输入入库日期" />
				</el-form-item>
				<el-form-item label="陆运车辆ID" prop="landCarID">
					<el-input v-model="form.landCarID" placeholder="请输入陆运车辆ID" />
				</el-form-item>
				<el-form-item label="陆运车牌" prop="landCarNo">
					<el-input v-model="form.landCarNo" placeholder="请输入陆运车牌" />
				</el-form-item>
				<el-form-item label="陆运司机电话" prop="landDriverTel">
					<el-input
						v-model="form.landDriverTel"
						placeholder="请输入陆运司机电话"
					/>
				</el-form-item>
				<el-form-item label="陆地司机姓名" prop="landDriverName">
					<el-input
						v-model="form.landDriverName"
						placeholder="请输入陆地司机姓名"
					/>
				</el-form-item>
				<el-form-item label="海运车辆ID" prop="seaCarID">
					<el-input v-model="form.seaCarID" placeholder="请输入海运车辆ID" />
				</el-form-item>
				<el-form-item label="海运车牌" prop="seaCarNo">
					<el-input
						v-model="form.seaCarNo"
						type="textarea"
						placeholder="请输入内容"
					/>
				</el-form-item>
				<el-form-item label="海运司机电话" prop="seaDriverTel">
					<el-input
						v-model="form.seaDriverTel"
						type="textarea"
						placeholder="请输入内容"
					/>
				</el-form-item>
				<el-form-item label="海运司机姓名" prop="seaDriverName">
					<el-input
						v-model="form.seaDriverName"
						placeholder="请输入海运司机姓名"
					/>
				</el-form-item>
				<el-form-item label="添加时间" prop="addtime">
					<el-input v-model="form.addtime" placeholder="请输入添加时间" />
				</el-form-item>
				<el-form-item label="操作人员ID" prop="userId">
					<el-input v-model="form.userId" placeholder="请输入操作人员ID" />
				</el-form-item>
				<el-form-item label="操作人员姓名" prop="UserName">
					<el-input v-model="form.UserName" placeholder="请输入操作人员姓名" />
				</el-form-item>
				<el-form-item label="删除标记" prop="delFlag">
					<el-input v-model="form.delFlag" placeholder="请输入删除标记" />
				</el-form-item>
				<el-form-item label="订单仓库选择时是否显示" prop="showFlag">
					<el-input
						v-model="form.showFlag"
						placeholder="请输入订单仓库选择时是否显示"
					/>
				</el-form-item>
				<el-form-item label="二次入库对应的出库id" prop="exWareHoustId">
					<el-input
						v-model="form.exWareHoustId"
						placeholder="请输入二次入库对应的出库id"
					/>
				</el-form-item>
				<el-form-item label="货物来源公司(本部或者海盛)" prop="goodsCompany">
					<el-input
						v-model="form.goodsCompany"
						placeholder="请输入货物来源公司(本部或者海盛)"
					/>
				</el-form-item>
				<el-form-item label="子项陆运费之和" prop="allLandFreight">
					<el-input
						v-model="form.allLandFreight"
						placeholder="请输入子项陆运费之和"
					/>
				</el-form-item>
				<el-form-item label="子项海运费之和" prop="allSeaFreight">
					<el-input
						v-model="form.allSeaFreight"
						placeholder="请输入子项海运费之和"
					/>
				</el-form-item>
				<el-divider content-position="center">库存子信息</el-divider>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button
							type="primary"
							icon="el-icon-plus"
							size="mini"
							@click="handleAddInventoryDetail"
							>添加</el-button
						>
					</el-col>
					<el-col :span="1.5">
						<el-button
							type="danger"
							icon="el-icon-delete"
							size="mini"
							@click="handleDeleteInventoryDetail"
							>删除
						</el-button>
					</el-col>
				</el-row>
				<el-table
					:data="inventoryDetailList"
					:row-class-name="rowInventoryDetailIndex"
					@selection-change="handleInventoryDetailSelectionChange"
					ref="inventoryDetail"
				>
					<el-table-column type="selection" width="50" align="center" />
					<el-table-column
						label="序号"
						align="center"
						prop="index"
						width="50"
					/>
					<el-table-column
						label="库存量(片数)(用来记录入库时的个数)"
						prop="stockNumber"
						width="150"
					>
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.stockNumber"
								placeholder="请输入库存量(片数)(用来记录入库时的个数)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="供应商" prop="supplier" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.supplier"
								placeholder="请输入供应商"
							/>
						</template>
					</el-table-column>
					<el-table-column label="供应商ID" prop="supplierId" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.supplierId"
								placeholder="请输入供应商ID"
							/>
						</template>
					</el-table-column>
					<el-table-column label="级别编码" prop="levelID" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.levelID"
								placeholder="请输入级别编码"
							/>
						</template>
					</el-table-column>
					<el-table-column label="级别名称" prop="levelName" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.levelName"
								placeholder="请输入级别名称"
							/>
						</template>
					</el-table-column>
					<el-table-column label="计量单位" prop="countingUnit" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.countingUnit"
								placeholder="请输入计量单位"
							/>
						</template>
					</el-table-column>
					<el-table-column label="厚度" prop="height" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.height" placeholder="请输入厚度" />
						</template>
					</el-table-column>
					<el-table-column label="长度" prop="length" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.length" placeholder="请输入长度" />
						</template>
					</el-table-column>
					<el-table-column label="宽度" prop="width" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.width" placeholder="请输入宽度" />
						</template>
					</el-table-column>
					<el-table-column label="出厂片数" prop="pieces" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.pieces"
								placeholder="请输入出厂片数"
							/>
						</template>
					</el-table-column>
					<el-table-column label="每包片数" prop="piecesPerPack" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.piecesPerPack"
								placeholder="请输入每包片数"
							/>
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.packs" placeholder="请输入包数" />
						</template>
					</el-table-column>
					<el-table-column label="出厂单价" prop="price" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.price"
								placeholder="请输入出厂单价"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="出厂是否含税"
						prop="isIncludeTaxFactory"
						width="150"
					>
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.isIncludeTaxFactory"
								placeholder="请输入出厂是否含税"
							/>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.sundryCost"
								placeholder="请输入杂费"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.paymentFactory"
								placeholder="请输入出厂货款"
							/>
						</template>
					</el-table-column>
					<el-table-column label="卸货价" prop="paymentUnload" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.paymentUnload"
								placeholder="请输入卸货价"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="销售是否含税"
						prop="isIncludeTaxSale"
						width="150"
					>
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.isIncludeTaxSale"
								placeholder="请输入销售是否含税"
							/>
						</template>
					</el-table-column>
					<el-table-column label="总货款" prop="payments" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.payments"
								placeholder="请输入总货款"
							/>
						</template>
					</el-table-column>
					<el-table-column label="误差" prop="erro" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.erro" placeholder="请输入误差" />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.tonnage" placeholder="请输入吨位" />
						</template>
					</el-table-column>
					<el-table-column
						label="陆运费单价"
						prop="landFreightPrice"
						width="150"
					>
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.landFreightPrice"
								placeholder="请输入陆运费单价"
							/>
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.landFreight"
								placeholder="请输入陆运费"
							/>
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.seaFreight"
								placeholder="请输入海运费"
							/>
						</template>
					</el-table-column>
					<el-table-column label="运费" prop="freight" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.freight" placeholder="请输入运费" />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.otherCost"
								placeholder="请输入其他费用"
							/>
						</template>
					</el-table-column>
					<el-table-column label="利润" prop="profit" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.profit" placeholder="请输入利润" />
						</template>
					</el-table-column>
					<el-table-column label="不含税利润" prop="profitNoTax" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.profitNoTax"
								placeholder="请输入不含税利润"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="实际片数(用来记录仓库还剩余的个数)"
						prop="actualPieces"
						width="150"
					>
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.actualPieces"
								placeholder="请输入实际片数(用来记录仓库还剩余的个数)"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="总货款杂费"
						prop="paymentsWithSundry"
						width="150"
					>
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.paymentsWithSundry"
								placeholder="请输入总货款杂费"
							/>
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.additionalFees"
								placeholder="请输入加费"
							/>
						</template>
					</el-table-column>
					<el-table-column label="返利金额" prop="rebate" width="150">
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.rebate"
								placeholder="请输入返利金额"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="客户佣金"
						prop="customerCommission"
						width="150"
					>
						<template slot-scope="scope">
							<el-input
								v-model="scope.row.customerCommission"
								placeholder="请输入客户佣金"
							/>
						</template>
					</el-table-column>
					<el-table-column label="备注" prop="comments" width="150">
						<template slot-scope="scope">
							<el-input v-model="scope.row.comments" placeholder="请输入备注" />
						</template>
					</el-table-column>
				</el-table>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import {
	listInventoryMain,
	getInventoryMain,
	delInventoryMain,
	addInventoryMain,
	updateInventoryMain
} from '@/api/system/inventoryMain';

export default {
	name: 'InventoryMain',
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 子表选中数据
			checkedInventoryDetail: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 库存库存主表表格数据
			inventoryMainList: [],
			// 库存子表格数据
			inventoryDetailList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: null,
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				showFlag: null,
				exWareHoustId: null,
				goodsCompany: null,
				allLandFreight: null,
				allSeaFreight: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询库存库存主表列表 */
		getList() {
			this.loading = true;
			listInventoryMain(this.queryParams).then(response => {
				this.inventoryMainList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: null,
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				showFlag: null,
				exWareHoustId: null,
				goodsCompany: null,
				allLandFreight: null,
				allSeaFreight: null
			};
			this.inventoryDetailList = [];
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加库存库存主表';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getInventoryMain(id).then(response => {
				this.form = response.data;
				this.inventoryDetailList = response.data.inventoryDetailList;
				this.open = true;
				this.title = '修改库存库存主表';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					this.form.inventoryDetailList = this.inventoryDetailList;
					if (this.form.id != null) {
						updateInventoryMain(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addInventoryMain(this.form).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除库存库存主表编号为"' + ids + '"的数据项？')
				.then(function () {
					return delInventoryMain(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 库存子序号 */
		rowInventoryDetailIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		/** 库存子添加按钮操作 */
		handleAddInventoryDetail() {
			let obj = {};
			obj.stockNumber = '';
			obj.supplier = '';
			obj.supplierId = '';
			obj.levelID = '';
			obj.levelName = '';
			obj.countingUnit = '';
			obj.height = '';
			obj.length = '';
			obj.width = '';
			obj.pieces = '';
			obj.piecesPerPack = '';
			obj.packs = '';
			obj.price = '';
			obj.isIncludeTaxFactory = '';
			obj.sundryCost = '';
			obj.paymentFactory = '';
			obj.paymentUnload = '';
			obj.isIncludeTaxSale = '';
			obj.payments = '';
			obj.erro = '';
			obj.tonnage = '';
			obj.landFreightPrice = '';
			obj.landFreight = '';
			obj.seaFreight = '';
			obj.freight = '';
			obj.otherCost = '';
			obj.profit = '';
			obj.profitNoTax = '';
			obj.actualPieces = '';
			obj.paymentsWithSundry = '';
			obj.additionalFees = '';
			obj.rebate = '';
			obj.customerCommission = '';
			obj.comments = '';
			this.inventoryDetailList.push(obj);
		},
		/** 库存子删除按钮操作 */
		handleDeleteInventoryDetail() {
			if (this.checkedInventoryDetail.length == 0) {
				this.$modal.msgError('请先选择要删除的库存子数据');
			} else {
				const inventoryDetailList = this.inventoryDetailList;
				const checkedInventoryDetail = this.checkedInventoryDetail;
				this.inventoryDetailList = inventoryDetailList.filter(function (item) {
					return checkedInventoryDetail.indexOf(item.index) == -1;
				});
			}
		},
		/** 复选框选中数据 */
		handleInventoryDetailSelectionChange(selection) {
			this.checkedInventoryDetail = selection.map(item => item.index);
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/inventoryMain/export',
				{
					...this.queryParams
				},
				`inventoryMain_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
