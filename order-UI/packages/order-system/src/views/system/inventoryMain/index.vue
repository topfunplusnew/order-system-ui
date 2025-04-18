<template>
	<div class="app-container">
		<el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch"
			label-width="100px">
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable
					@keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="入库日期" prop="storeDate">
				<el-date-picker v-model="queryParams.storeDate" type="date" value-format="yyyy-MM-dd"
					placeholder="选择入库日期" clearable />
			</el-form-item>
			<el-form-item label="陆运车牌" prop="landCarNo">
				<el-input v-model="queryParams.landCarNo" placeholder="请输入陆运车牌" clearable
					@keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="陆运司机电话" prop="landDriverTel">
				<el-input v-model="queryParams.landDriverTel" placeholder="请输入陆运司机电话" clearable
					@keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="陆地司机姓名" prop="landDriverName">
				<el-input v-model="queryParams.landDriverName" placeholder="请输入陆地司机姓名" clearable
					@keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="海运公司" prop="seaDriverName">
				<el-input v-model="queryParams.seaDriverName" placeholder="请输入海运公司" clearable
					@keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
					v-hasPermi="['system:inventoryMain:add']">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate"
					v-hasPermi="['system:inventoryMain:edit']">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple"
					@click="handleDelete" v-hasPermi="['system:inventoryMain:remove']">删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport"
					v-hasPermi="['system:inventoryMain:export']">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened"
							size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-col :span="4">
			<div class="tree-container" style="max-height: 400px; overflow-y: auto">
				<el-tree :data="storeList" :props="defaultProps" @node-click="handleNodeClick" />
			</div>
		</el-col>
		<el-col :span="20">
			<el-table id="printBox" size="mini" v-loading="loading" :data="inventoryMainList"
				@selection-change="handleSelectionChange" stripe style="width: 100%; margin-bottom: 20px">
				<el-table-column type="selection" width="50" align="center" />

				<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" />

				<el-table-column v-if="columns[1].visible" label="仓库名称" align="center" prop="storeHouseName"
					width="150" />

				<el-table-column v-if="columns[2].visible" label="入库日期" align="center" prop="storeDate" width="150" />

				<el-table-column v-if="columns[3].visible" label="货物来源公司" align="center" prop="goodsCompany"
					width="180" />

				<el-table-column v-if="columns[4].visible" label="审核状态" align="center" prop="checkState" width="150">
					<template #default="scope">
						<el-row v-if="scope.row.checkState === '已审核'">
							<StateTag :state-title="scope.row.checkState" :state-mapper="{ 2: '已审核' }"
								@click.native="handleReCheck(scope.row)" style="cursor: pointer" />
						</el-row>
						<el-row v-else>
							<el-row>
								<el-button v-hasPermi="['system:inventoryMain:audit']" type="text" size="mini"
									@click="handleCheck(scope.row)">审核</el-button>
							</el-row>
						</el-row>
					</template>
				</el-table-column>

				<el-table-column v-if="columns[5].visible" label="陆运车牌" align="center" prop="landCarNo" width="120" />

				<el-table-column v-if="columns[6].visible" label="陆运司机电话" align="center" prop="landDriverTel"
					width="150" />

				<el-table-column v-if="columns[7].visible" label="陆地司机姓名" align="center" prop="landDriverName"
					width="120" />

				<el-table-column v-if="columns[8].visible" label="陆运银行卡号" align="center" prop="landBankNo"
					width="120" />

				<el-table-column v-if="columns[9].visible" label="陆运银行户名" align="center" prop="landBankName"
					width="120" />

				<el-table-column v-if="columns[10].visible" label="柜号" align="center" prop="seaCarNo" width="120" />

				<el-table-column v-if="columns[11].visible" label="海运司机电话" align="center" prop="seaDriverTel"
					width="150" />

				<el-table-column v-if="columns[12].visible" label="海运公司" align="center" prop="seaDriverName"
					width="120" />

				<el-table-column v-if="columns[13].visible" label="海运银行卡号" align="center" prop="seaBankNo"
					width="120" />

				<el-table-column v-if="columns[14].visible" label="海运银行户名" align="center" prop="seaBankName"
					width="120" />

				<el-table-column v-if="columns[15].visible" label="子项陆运费之和" align="center" prop="allLandFreight"
					width="150" />

				<el-table-column v-if="columns[16].visible" label="子项海运费之和" align="center" prop="allSeaFreight"
					width="150" />

				<el-table-column v-if="columns[17].visible" label="收到条附件路径" align="center" prop="allSeaFreight"
					width="150" fixed="right">
					<template slot-scope="scope">
						<check-files :path="scope.row.receiveProof"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, 'receiveProof', getInventoryMain, updateInventoryMain)" />
					</template>
				</el-table-column>

				<el-table-column v-if="columns[18].visible" label="操作" align="center" width="150" fixed="right">
					<template slot-scope="scope">
						<el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)"
							v-hasPermi="['system:inventoryMain:edit']">修改</el-button>
						<el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
							v-hasPermi="['system:inventoryMain:remove']">删除</el-button>
					</template>
				</el-table-column>
			</el-table>

			<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum"
				:limit.sync="queryParams.pageSize" @pagination="getList" />
		</el-col>

		<!-- 添加或修改库存库存主表对话框 -->
		<el-dialog :title="title" :visible.sync="open" width="1200px" append-to-body :close-on-click-modal="false">
			<el-form ref="form" :model="form" :rules="rules" label-width="80px" :inline="true">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-col :span="16">
						<el-input disabled size="mini" v-model="form.storeHouseName" placeholder="请输入仓库名称" />
					</el-col>
					<el-col :span="8">
						<SearchOption :get-data="listStoreHouse" icon="el-icon-s-home" :limit-info="{}"
							query-label="仓库名称" query-info="storeHouseName" :query-name="queryStore"
							@commitBack="value => handleCommitBackInventory(value)"
							@update:queryName="handleUpdateQueryNameStore" :is-page="false">
							<template #table-columns>
								<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
								<el-table-column label="地址" align="center" prop="address" />
							</template>
						</SearchOption>
					</el-col>
				</el-form-item>
				<el-form-item label="入库日期" prop="storeDate">
					<el-date-picker v-model="form.storeDate" size="mini" type="datetime" placeholder="选择入库日期"
						value-format="yyyy-MM-dd HH:mm:ss" style="width: 120px" />
				</el-form-item>
				<el-form-item label="货物来源" prop="goodsCompany">
					<el-input size="mini" v-model="form.goodsCompany" placeholder="请输入货物来源公司(本部或者海盛)" />
				</el-form-item>
				<el-form-item label="附件">
					<file-upload @input="handleCommitUpload" />
				</el-form-item>
				<br />
				<el-form-item label="运输方式">
					<el-checkbox v-model="isLand">陆运</el-checkbox>
					<el-checkbox v-model="isSea">海运</el-checkbox>
				</el-form-item>
				<el-row v-if="isLand" style="margin: 3px 0">
					<el-form-item label="车牌">
						<el-row>
							<el-col :span="20">
								<el-input disabled v-model="form.landCarNo" type="text" size="mini" placeholder="请选择"
									style="width: 120px" />
							</el-col>
							<el-col :span="4">
								<!--搜索银行卡信息-->
								<SearchOption :limit-info="{ carType: '陆运' }" :get-data="listCars" query-label="车牌搜索"
									query-info="carNo" :query-name="queryLandCar" @commitBack="handleCommitBackCar"
									@update:queryName="handleChangeCar">
									<template #table-columns>
										<el-table-column label="车牌" align="center" prop="carNo" />
										<el-table-column label="司机" align="center" prop="driver" />
										<el-table-column label="司机电话" align="center" prop="tel" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
										<el-table-column label="开户行" align="center" prop="bankName" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="司机">
						<el-input disabled v-model="form.landDriverName" type="text" size="mini" placeholder="请选择"
							style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input disabled v-model="form.landDriverTel" type="text" size="mini" placeholder="请选择"
							style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号">
						<el-input disabled v-model="form.landBankNo" type="text" size="mini" placeholder="请选择"
							style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行">
						<el-input disabled v-model="form.landBankName" type="text" size="mini" placeholder="请选择"
							style="width: 120px" />
					</el-form-item>
					<!-- 添加车队 -->
					<el-form-item label="车队">
						<el-row>
							<el-col :span="12">
								<el-input disabled v-model="form.fleet" type="text" size="mini" placeholder="请输入车队" />
							</el-col>
							<el-col :span="4">
								<SearchOption :limit-info="{}" :get-data="listFleet" query-label="车队名称"
									query-info="fname" :query-name="queryFleet" @commitBack="handleCommitBackFleet"
									@update:queryName="handleChangeFleet">
									<template #table-columns>
										<el-table-column label="车队名称" align="center" prop="fname" />
										<el-table-column label="车队经理" align="center" prop="fleader" />
										<el-table-column label="车队经理电话" align="center" prop="tel" />
										<el-table-column label="地址" align="center" prop="address" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<!-- 添加附件上传 -->
				</el-row>
				<!--      海运-->
				<el-row v-if="isSea" style="margin: 3px 0">
					<!--   车牌修改为柜号 且自己输入 不提供自动填充 -->
					<el-form-item label="柜号">
						<el-row>
							<el-col :span="20">
								<el-input v-model="form.seaCarNo" type="text" size="mini" placeholder="请输入柜号"
									style="width: 120px" />
							</el-col>
							<el-col :span="4">
								<SearchOption :limit-info="{ carType: '海运' }" :get-data="listCars" query-label="车牌"
									query-info="carNo" :query-name="querySeaCars" @commitBack="handleCommitBackSeaCar"
									@update:queryName="handleChangeSeaCar">
									<template #table-columns>
										<el-table-column label="车牌" align="center" prop="carNo" />
										<el-table-column label="司机" align="center" prop="driver" />
										<el-table-column label="司机电话" align="center" prop="tel" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<!--          todo 原为海运司机 现改为海运公司-->
					<el-form-item label="海运公司">
						<el-input v-model="form.seaDriverName" type="text" size="mini" placeholder="请输入海运公司"
							style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input v-model="form.seaDriverTel" type="text" size="mini" placeholder="请输入电话"
							style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号">
						<el-input v-model="form.seaBankNo" type="text" size="mini" placeholder="请输入海运银行卡号"
							style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行">
						<el-input v-model="form.seaBankName" type="text" size="mini" placeholder="请输入海运开户行"
							style="width: 120px" />
					</el-form-item>
				</el-row>
				<br />

				<el-divider content-position="center">货物信息</el-divider>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button type="primary" icon="el-icon-plus" size="mini"
							@click="handleAddInventoryDetail">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button type="danger" icon="el-icon-delete" size="mini"
							@click="handleDeleteInventoryDetail">删除</el-button>
					</el-col>
				</el-row>

				<!--        与订单一致-->
				<el-table size="mini" :data="inventoryDetailList" show-summary :summary-method="getSummary"
					:row-class-name="rowInventoryDetailIndex" @selection-change="handleInventoryDetailSelectionChange"
					ref="inventoryDetail">
					<el-table-column type="selection" width="90" align="center" />
					<el-table-column label="序号" align="center" prop="index" width="50" />
					<el-table-column label="供应商" width="200">
						<template #default="scope">
							<el-row>
								<!-- 动态绑定的 Input -->
								<el-col :span="18">
									<el-input disabled size="mini" v-model="scope.row.supplier" placeholder="请选择" />
								</el-col>

								<!-- 供应商按钮 -->
								<el-col :span="6">
									<SearchOption title="供应商信息" :get-data="listCompany" icon="el-icon-user"
										query-label="公司名称" query-info="companyName" :query-name="querySupplier"
										:limit-info="{ companyType: '供应商' }"
										@commitBack="value => handleCommitBackSupplier(scope, value)"
										@update:queryName="handleUpdateQuerySupplier"
										@click="setCurrentType(scope.row, 'supplier')"
										:query-items="queryItemsSupplier">
										<template #table-columns>
											<el-table-column label="公司名称" align="center" prop="companyName" />
											<el-table-column label="销售经理" align="center" prop="salesManager" />
											<el-table-column label="联系人" align="center" prop="relationName" />
											<el-table-column label="电话" align="center" prop="relationTel" />
											<el-table-column label="地址" align="center" prop="address" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</template>
					</el-table-column>

					<el-table-column label="级别名称" prop="levelName" width="150">
						<template #default="scope">
							<el-col :span="16">
								<el-input disabled size="mini" v-model="scope.row.levelName" placeholder="请选择" />
							</el-col>
							<el-col :span="8">
								<SearchOption :get-data="listProductLevel" icon="el-icon-search" :limit-info="{}"
									query-label="级别名称" query-info="levelName" :query-name="queryLevel"
									@update:queryName="handleUpdateQueryNameLevel"
									@commitBack="value => handleCommitBackProductLevel(scope, value)"
									:query-items="queryItemsOrder">
									<template #table-columns>
										<el-table-column label="级别编码" align="center" prop="levelNo" />
										<el-table-column label="级别名称" align="center" prop="levelName" />
										<el-table-column label="分类编号" align="center" prop="categoryNo" />
										<el-table-column label="分类名称" align="center" prop="categoryName" />
										<el-table-column label="厚度" align="center" prop="height" />
										<el-table-column label="长度" align="center" prop="length" />
										<el-table-column label="宽度" align="center" prop="width" />
										<el-table-column label="误差" align="center" prop="tonnage" />
									</template>
								</SearchOption>
							</el-col>
						</template>
					</el-table-column>
					<el-table-column label="计量单位" prop="countingUnit" width="150">
						<template #default="scope">
							<el-radio-group v-model="scope.row.countingUnit" size="mini">
								<el-radio label="片">片数</el-radio>
								<el-radio label="其他">其他</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="厚度" prop="height" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.height" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="长度" prop="length" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.length" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="宽度" prop="width" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.width" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<!-- <el-table-column label="库存量" prop="stockNumber" width="150">
						<template #default="scope">
						<el-input
							size="mini"
							v-model.lazy="scope.row.stockNumber"
							@change="() => (scope.row.actualPieces = scope.row.stockNumber)"
							placeholder="入库时片数"
						/>
						</template>
					</el-table-column> -->
					<el-table-column label="每包片数" prop="piecesPerPack" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.piecesPerPack"
								@input="() => (scope.row.packs >= 0 ? calculatePacks(scope) : '')"
								placeholder="请输入每包片数" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" @input="() => calculatePacks(scope)"
								v-model.lazy="scope.row.packs"
								:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
								:disabled="scope.row.piecesPerPack <= 0" />
						</template>
					</el-table-column>

					<el-table-column label="出厂片数" prop="pieces" width="150">
						<template #default="scope">
							<el-input type="number" size="mini" v-model="scope.row.pieces" placeholder="请输入出厂片数"
								@input="() => calculatePacks(scope)" />
						</template>
					</el-table-column>

					<el-table-column label="出厂单价" prop="price" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.price"
								@input="scope.row.sundryCost >= 0 ? calculatePrice(scope) : ''"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="scope.row.pieces <= 0" />
						</template>
					</el-table-column>
					<el-table-column label="出厂是否含税" prop="isIncludeTaxFactory" width="150">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini"
								@change="() => recalculateFactory(scope)">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model.lazy="scope.row.sundryCost"
								@input="() => calculatePrice(scope)"
								:placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'"
								:disabled="scope.row.price <= 0" />
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.paymentFactory" placeholder="请输入出厂货款"
								disabled />
						</template>
					</el-table-column>

					<!-- 后端跟我说这个放在后面，实际片数不展示  -->
					<el-table-column label="库存量" prop="stockNumber" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.stockNumber" placeholder="入库时片数" />
						</template>
					</el-table-column>
					<el-table-column label="存货价" prop="paymentUnload" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model.lazy="scope.row.paymentUnload"
								placeholder="请输入存货价"
								@input="scope.row.paymentsWithSundry >= 0 ? calculatePayment(scope) : ''" />
						</template>
					</el-table-column>
					<el-table-column label="库存是否含税" prop="isIncludeTaxSale" width="150">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini"
								@change="() => recalculateSale(scope)">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>

					<el-table-column label="库存杂费" prop="paymentsWithSundry" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.paymentsWithSundry"
								@input="() => calculatePayment(scope)" :disabled="scope.row.paymentUnload <= 0"
								:placeholder="scope.row.paymentUnload <= 0 ? '请先完善存货价' : '请输入库存杂费'" />
						</template>
					</el-table-column>
					<el-table-column label="库存金额" prop="payments" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.payments" placeholder="请输入库存金额"
								disabled />
						</template>
					</el-table-column>
					<el-table-column label="误差" prop="erro" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" disabled />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.tonnage" placeholder="请输入吨位" disabled />
						</template>
					</el-table-column>
					<el-table-column label="陆运费单价" prop="landFreightPrice" width="150" v-if="isLand">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.landFreightPrice"
								@input="() => (scope.row.additionalFees >= 0 ? calculateLandFreight(scope) : '')"
								placeholder="请输入陆运费单价" />
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.additionalFees"
								@input="() => calculateLandFreight(scope)"
								:placeholder="scope.row.landFreightPrice <= 0 ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="scope.row.landFreightPrice <= 0" />
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="150" v-if="isLand" disabled>
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.landFreight" placeholder="请输入陆运费" />
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="150" v-if="isSea">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.seaFreight"
								@input="() => calculateFreight(scope)" placeholder="请输入海运费" />
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.freight" placeholder="请完善运费信息" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.otherCost" placeholder="请输入其他费用"
								@input="() => calculatePrice(scope)" />
						</template>
					</el-table-column>
					<el-table-column label="利润" prop="profit" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profit" placeholder="请输入利润" disabled />
						</template>
					</el-table-column>
					<el-table-column label="不含税利润" prop="profitNoTax" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profitNoTax" placeholder="请输入不含税利润" disabled />
						</template>
					</el-table-column>
					<el-table-column label="物流利润" prop="logisticsProfit" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.logisticsProfit" placeholder="请输入物流利润" />
						</template>
					</el-table-column>
					<!--          库存没有客户佣金-->
					<!--					<el-table-column label="客户佣金" prop="customerCommission" width="150">-->
					<!--						<template #default="scope">-->
					<!--							<el-input size="mini" v-model="scope.row.customerCommission" placeholder="请输入客户佣金" />-->
					<!--						</template>-->
					<!--					</el-table-column>-->
					<!--          添加厂家佣金 -->
					<el-table-column label="厂家佣金" prop="factoryCommission" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryCommission" placeholder="请输入厂家佣金" />
						</template>
					</el-table-column>
					<!--          降价金额-->
					<el-table-column label="计提厂家返利金额" prop="customerCommission" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryRebateAmount" placeholder="请输入计提厂家返利金额" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="customerCommission" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryDiscountAmount" placeholder="请输入计提厂家降价金额" />
						</template>
					</el-table-column>

					<el-table-column label="备注" prop="comments" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" />
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
import { addInventoryMain, delInventoryMain, getInventoryMain, listInventoryMain, updateInventoryMain } from '../../../api/system/inventoryMain';
import { listCars } from '../../../api/system/cars';
import { listCompany } from '../../../api/system/company';
import { listFleet } from '../../../api/system/fleet';
import { listInventory } from '../../../api/system/inventory';
import { listProductLevel } from '../../../api/system/productLevel';
import { listStoreHouse } from '../../../api/system/StoreHouse';
import { fix } from '../../../api/tool/format';
import SearchOption from '../../../components/SearchOption.vue';
import { _fill } from './fill';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import CheckFiles from '../../../components/CheckFiles.vue';
import { auditInventory } from '../../../api/system/inventoryMain';
import StateTag from '../../dashboard/components/common/StateTag.vue';
import { mixin_printHTML } from '../../dashboard/mixins/print';

export default {
	name: 'InventoryMain',
	components: { SearchOption, CheckFiles, StateTag },
	mixins: [_fill, mixin_checkfile, mixin_printHTML],
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
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '仓库名称', visible: true },
				{ key: 2, label: '入库日期', visible: true },
				{ key: 3, label: '货物来源公司', visible: true },
				{ key: 4, label: '审核状态', visible: true },
				{ key: 5, label: '陆运车牌', visible: true },
				{ key: 6, label: '陆运司机电话', visible: true },
				{ key: 7, label: '陆地司机姓名', visible: true },
				{ key: 8, label: '陆运银行卡号', visible: true },
				{ key: 9, label: '陆运银行户名', visible: true },
				{ key: 10, label: '柜号', visible: true },
				{ key: 11, label: '海运司机电话', visible: true },
				{ key: 12, label: '海运公司', visible: true },
				{ key: 13, label: '海运银行卡号', visible: true },
				{ key: 14, label: '海运银行户名', visible: true },
				{ key: 15, label: '子项陆运费之和', visible: true },
				{ key: 16, label: '子项海运费之和', visible: true },
				{ key: 17, label: '收到条附件路径', visible: true },
				{ key: 18, label: '操作', visible: true }
			],
			// 表单校验
			rules: {},
			storeList: [],
			// 树表的数据结构
			defaultProps: {
				label: 'label'
			},
			// 海运还是陆运
			isLand: false,
			isSea: false,
			querySupplier: null,
			queryLevel: null,
			queryStore: null,
			queryFleet: null,

			// 查询组
			queryItemsSupplier: {
				queryList: [
					{
						id: 1,
						label: '老板姓名',
						prop: 'leader',
						type: 'input',
						value: ''
					},
					{
						id: 2,
						label: '联系人',
						prop: 'relationName',
						type: 'input',
						value: ''
					}
				]
			},
			queryItemsOrder: {
				queryList: [
					{
						id: 1,
						label: '厚度',
						prop: 'height',
						type: 'input',
						value: ''
					},
					{
						id: 2,
						label: '宽度',
						prop: 'width',
						type: 'input',
						value: ''
					},
					{
						id: 3,
						label: '长度',
						prop: 'length',
						type: 'input',
						value: ''
					},
					{
						id: 4,
						label: '分类名称',
						prop: 'levelName',
						type: 'input',
						value: ''
					}
				]
			}
		};
	},
	created() {
		this.getList();
		// 抓取左侧仓库信息
		listStoreHouse().then(res => {
			this.storeList = res.rows.map(item => {
				return {
					label: item.storeHouseName,
					children: []
				};
			});
		});
	},
	isLand: {
		handler(val) {
			if (val === false) {
				this.resetLandCarInfo();
			}
		}
	},
	isSea: {
		handler(val) {
			if (val === false) {
				this.resetSeaCarInfo();
			}
		}
	},
	methods: {
		listStoreHouse,
		listInventory,
		listCars,
		listFleet,
		listProductLevel,
		listCompany,
		getInventoryMain,
		updateInventoryMain,
		handleCommitUpload(val) {
			this.form.receiveProof = val;
		},
		handleNodeClick(data) {
			this.loading = true;
			listInventoryMain({ storeHouseName: data.label }).then(res => {
				this.inventoryMainList = res.rows;
				this.loading = false;
			});
		},
		handleCheck(row) {
			// 弹出确认和取消
			this.$confirm('是否审核该信息?', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				// 修改审核状态
				auditInventory({ id: row.id, isaudit: true }).then(() => {
					this.$message({
						type: 'success',
						message: '操作成功~!'
					});
					this.getList();
				});
			});
		},
		handleReCheck(row) {
			this.$modal.confirm('是否取消审核').then(() => {
				auditInventory({
					id: row.id,
					isaudit: false
				}).then(() => {
					this.$modal.msgSuccess('取消审核成功');
					this.getList();
				});
			});
		},
		getSummary(param) {
			const { columns, data } = param;
			const exclude = [16, 19, 23, 24, 25, 28];
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				if (exclude.includes(index)) {
					const values = data.map(item => Number(item[column.property]));
					if (!values.every(value => isNaN(value))) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = fix(sums[index]);
					} else {
						sums[index] = 'N/A';
					}
				}
			});

			return sums;
		},
		// 更新供应商的查询字段
		handleUpdateQuerySupplier(value) {
			this.querySupplier = value;
		},
		handleUpdateQueryNameLevel(value) {
			this.queryLevel = value;
		},
		// 填充货物信息中的供应商
		handleCommitBackSupplier(scope, val) {
			console.log(val);
			this.clearDetail(scope);
			scope.row.supplier = val.companyName;
			scope.row.supplierId = val.id;
		},
		// 产品级别自动填充
		handleCommitBackProductLevel(scope, val) {
			scope.row.erro = val.tonnage;
			scope.row.levelID = val.id;
			scope.row.levelName = val.levelName;
			scope.row.height = val.height;
			scope.row.length = val.length;
			scope.row.width = val.width;
			scope.row.levelNo = val.levelNo;
		},
		// BEGIN
		// 重新计算库存金额
		recalculateSale(scope) {
			this.calculatePayment(scope);
		},
		recalculateFactory(scope) {
			this.calculatePaymentFactory(scope);
		},
		calculatePacks(scope) {
			// const res = scope.row.packs * scope.row.piecesPerPack;
			// scope.row.actualPieces = scope.row.pieces = res;
			// 计算吨位
			scope.row.tonnage = fix(((Number(scope.row.height) - Number(scope.row.erro)) * scope.row.length * scope.row.width * scope.row.pieces) / 1000000 / 20 / 20);
			if (scope.row.paymentFactory > 0) {
				this.calculatePaymentFactory(scope);
			}
		},
		calculatePaymentFactory(scope) {
			if (scope.row.isIncludeTaxFactory === 0) {
				scope.row.paymentFactory = fix(((scope.row.length * scope.row.width * scope.row.pieces) / 1000000) * scope.row.price + Number(scope.row.sundryCost));
			} else {
				scope.row.paymentFactory = fix((scope.row.length * scope.row.width * scope.row.pieces * scope.row.price) / 1000000 + Number(scope.row.sundryCost));
			}
		},
		calculatePrice(scope) {
			// 计算出厂货款
			this.calculatePaymentFactory(scope);
			// 计算利润
			scope.row.profit = fix(scope.row.payments - scope.row.paymentFactory - scope.row.landFreight - scope.row.seaFreight);

			// 计算不含税利润
			function calculateProfitNoTax() {
				if (scope.row.isIncludeTaxFactory === 0 && scope.row.isIncludeTaxSale === 0) {
					return fix(scope.row.payments - scope.row.paymentFactory - scope.row.landFreight - scope.row.seaFreight - scope.row.otherCost);
				} else if (scope.row.isIncludeTaxFactory === 1 && scope.row.isIncludeTaxSale === 0) {
					return fix(scope.row.payments - scope.row.paymentFactory / 1.075 - scope.row.landFreight - scope.row.seaFreight - scope.row.otherCost);
				} else if (scope.row.isIncludeTaxFactory === 0 && scope.row.isIncludeTaxSale === 1) {
					return fix(scope.row.payments / 1.075 - scope.row.paymentFactory - scope.row.landFreight - scope.row.seaFreight - scope.row.otherCost);
				} else {
					return fix(
						scope.row.payments -
						scope.row.paymentFactory -
						(scope.row.landFreight + scope.row.seaFreight) * 1.075 -
						(((scope.row.height * scope.row.length * scope.row.width * scope.row.pieces) / 1000000 / 20) * 0.5 - scope.row.otherCost)
					);
				}
			}

			scope.row.profitNoTax = calculateProfitNoTax();
		},
		calculatePayment(scope) {
			function calcu() {
				if (scope.row.isIncludeTaxFactory === 0 && scope.row.isIncludeTaxSale === 0) {
					scope.row.payments = fix(((scope.row.length * scope.row.width * scope.row.pieces) / 1000000) * scope.row.paymentUnload + Number(scope.row.paymentsWithSundry));
				} else {
					scope.row.payments = fix((scope.row.length * scope.row.width * scope.row.pieces * scope.row.paymentUnload) / 1000000 + Number(scope.row.paymentsWithSundry));
				}
			}

			if (scope.row.payments > 0) {
				calcu();
				this.calculatePrice(scope);
			} else {
				calcu();
			}
		},
		calculateLandFreight(scope) {
			scope.row.landFreight = fix(Number(scope.row.tonnage) * Number(scope.row.landFreightPrice) + Number(scope.row.additionalFees));
			this.calculateFreight(scope);
		},
		calculateFreight(scope) {
			scope.row.freight = fix(Number(scope.row.landFreight) + (this.isSea ? Number(scope.row.seaFreight) : 0));

			this.calculatePrice(scope);
		},

		// END
		handleCommitBackFleet(val) {
			this.form.fleet = val.fname;
		},
		// 车队的自动填充
		handleChangeFleet(val) {
			this.queryFleet = val;
		},
		// 设置当前绑定类型
		setCurrentType(row, type) {
			row.currentType = type;
		},
		clearDetail(scope) {
			scope.row.stockNumber = '';
			scope.row.supplier = '';
			scope.row.supplierId = '';
			scope.row.levelID = '';
			scope.row.levelName = '';
			scope.row.countingUnit = '片';
			scope.row.height = '';
			scope.row.length = '';
			scope.row.width = '';
			scope.row.pieces = '';
			scope.row.piecesPerPack = '';
			scope.row.packs = '';
			scope.row.price = '';
			scope.row.isIncludeTaxFactory = 0;
			scope.row.sundryCost = '';
			scope.row.paymentFactory = '';
			scope.row.paymentUnload = '';
			scope.row.isIncludeTaxSale = 0;
			scope.row.payments = '';
			scope.row.erro = '';
			scope.row.tonnage = '';
			scope.row.landFreightPrice = '';
			scope.row.landFreight = '';
			scope.row.seaFreight = '';
			scope.row.freight = '';
			scope.row.otherCost = '';
			scope.row.profit = '';
			scope.row.profitNoTax = '';
			// scope.row.actualPieces = '';
			scope.row.paymentsWithSundry = '';
			scope.row.additionalFees = '';
			scope.row.rebate = '';
			scope.row.customerCommission = '';
			scope.row.comments = '';
		},

		// 重置陆运费
		resetSeaCarInfo() {
			this.form.seaCarID = '';
			this.form.seaCarNo = '';
			this.form.seaDriverName = '';
			this.form.seaDriverTel = '';
		},
		// 重置海运费
		resetLandCarInfo() {
			this.form.landCarID = '';
			this.form.landCarNo = '';
			this.form.landDriverName = '';
			this.form.landDriverTel = '';
		},
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
			this.isSea = false;
			this.isLand = false;
			this.form = {
				id: null,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: new Date(),
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				fleet: null,
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
			this.title = '添加库存';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getInventoryMain(id).then(response => {
				this.form = response.data;
				this.isSea = response.data.allSeaFreight > 0;
				this.isLand = response.data.allLandFreight > 0;
				this.inventoryDetailList = response.data.inventoryDetailList;
				this.open = true;
				this.title = '修改库存';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.inventoryDetailList.length === 0) {
						this.$message.error('请添加库存明细');
						return;
					}
					this.form.inventoryDetailList = this.inventoryDetailList;
					// 计算陆运费
					this.form.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight), 0) : 0;
					// 计算海运费
					this.form.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight), 0) : 0;
					if (this.form.id != null) {
						updateInventoryMain(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addInventoryMain(this.form).then(() => {
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
				.catch(() => { });
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
			obj.countingUnit = '片';
			obj.height = '';
			obj.length = '';
			obj.width = '';
			obj.pieces = '';
			obj.piecesPerPack = '';
			obj.packs = '';
			obj.price = '';
			obj.isIncludeTaxFactory = 0;
			obj.sundryCost = '';
			obj.paymentFactory = '';
			obj.paymentUnload = '';
			obj.isIncludeTaxSale = 0;
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
			// obj.actualPieces = '';
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

<style scoped>
.el-table .el-button {
	margin: 0 5px;
}
</style>
