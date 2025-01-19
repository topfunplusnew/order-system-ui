<template>
	<div class="app-container">
		<el-form
			:model="queryParams"
			ref="queryForm"
			size="small"
			:inline="true"
			v-show="showSearch"
			label-width="100px"
		>
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
			<el-form-item label="海运司机姓名" prop="seaDriverName">
				<el-input
					v-model="queryParams.seaDriverName"
					placeholder="请输入海运司机姓名"
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
					>搜索
				</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
					>重置
				</el-button>
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
			<el-table-column label="ID" align="center" prop="id" />
			<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
			<el-table-column label="入库日期" align="center" prop="storeDate" />
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
		<el-dialog
			:title="title"
			:visible.sync="open"
			width="1100px"
			append-to-body
		>
			<el-form
				ref="form"
				:model="form"
				:rules="rules"
				label-width="80px"
				:inline="true"
			>
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-col :span="16">
						<el-input
							size="mini"
							v-model="form.storeHouseName"
							placeholder="请输入仓库名称"
						/>
					</el-col>
					<el-col :span="8">
						<SearchOption
							:get-data="listStoreHouse"
							icon="el-icon-s-home"
							:limit-info="{}"
							query-label="仓库名称"
							query-info="storeHouseName"
							:query-name="queryStore"
							@commitBack="value => handleCommitBackInventory(value)"
							@update:queryName="handleUpdateQueryNameStore"
						>
							<template #table-columns>
								<el-table-column
									label="仓库名称"
									align="center"
									prop="storeHouseName"
								/>
								<el-table-column label="地址" align="center" prop="address" />
							</template>
						</SearchOption>
					</el-col>
				</el-form-item>
				<el-form-item label="入库日期" prop="storeDate">
					<el-date-picker
						v-model="form.storeDate"
						size="mini"
						type="datetime"
						placeholder="选择入库日期"
						value-format="yyyy-MM-dd HH:mm:ss"
						style="width: 120px"
					/>
				</el-form-item>
				<el-form-item label="货物来源" prop="goodsCompany">
					<el-input
						size="mini"
						v-model="form.goodsCompany"
						placeholder="请输入货物来源公司(本部或者海盛)"
					/>
				</el-form-item>
				<el-form-item label="运输方式">
					<el-checkbox v-model="isLand"> 陆运</el-checkbox>
					<el-checkbox v-model="isSea"> 海运</el-checkbox>
				</el-form-item>
				<el-row v-if="isLand" style="margin: 20px 0">
					<el-form-item label="车牌">
						<el-row>
							<el-col :span="20">
								<el-input
									v-model="form.landCarNo"
									type="text"
									size="mini"
									placeholder="请输入陆运车牌"
									style="width: 120px"
								/>
							</el-col>
							<el-col :span="4">
								<!--搜索银行卡信息-->
								<SearchOption
									:limit-info="{ carType: '陆运' }"
									:get-data="listCars"
									query-label="车牌搜索"
									query-info="carNo"
									:query-name="queryLandCar"
									@commitBack="handleCommitBackCar"
									@update:queryName="handleChangeCar"
								>
									<template #table-columns>
										<el-table-column label="车牌" align="center" prop="carNo" />
										<el-table-column
											label="司机"
											align="center"
											prop="driver"
										/>
										<el-table-column
											label="司机电话"
											align="center"
											prop="tel"
										/>
										<el-table-column
											label="开户名"
											align="center"
											prop="acountsName"
										/>
										<el-table-column
											label="账号"
											align="center"
											prop="bankNo"
										/>
										<el-table-column
											label="开户行"
											align="center"
											prop="bankName"
										/>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="司机">
						<el-input
							v-model="form.landDriverName"
							type="text"
							size="mini"
							placeholder="请输入陆运司机姓名"
							style="width: 130px"
						/>
					</el-form-item>
					<el-form-item label="电话">
						<el-input
							v-model="form.landDriverTel"
							type="text"
							size="mini"
							placeholder="请输入陆运司机电话"
							style="width: 120px"
						/>
					</el-form-item>
				</el-row>
				<!--      海运-->
				<el-row v-if="isSea" style="margin: 10px 0">
					<!--   车牌修改为柜号 且自己输入 不提供自动填充 -->
					<el-form-item label="柜号">
						<el-row>
							<el-col :span="20">
								<el-input
									v-model="form.seaCarNo"
									type="text"
									size="mini"
									placeholder="请输入柜号"
									style="width: 120px"
								/>
							</el-col>
							<el-col :span="4">
								<SearchOption
									:limit-info="{ carType: '海运' }"
									:get-data="listCars"
									query-label="车牌"
									query-info="carNo"
									:query-name="querySeaCars"
									@commitBack="handleCommitBackSeaCar"
									@update:queryName="handleChangeSeaCar"
								>
									<template #table-columns>
										<el-table-column label="车牌" align="center" prop="carNo" />
										<el-table-column
											label="司机"
											align="center"
											prop="driver"
										/>
										<el-table-column
											label="司机电话"
											align="center"
											prop="tel"
										/>
										<el-table-column
											label="开户名"
											align="center"
											prop="acountsName"
										/>
										<el-table-column
											label="账号"
											align="center"
											prop="bankNo"
										/>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<!--          todo 原为海运司机 现改为海运公司-->
					<el-form-item label="海运公司">
						<el-input
							v-model="form.seaDriverName"
							type="text"
							size="mini"
							placeholder="请输入海运公司"
							style="width: 130px"
						/>
					</el-form-item>
					<el-form-item label="电话">
						<el-input
							v-model="form.seaDriverTel"
							type="text"
							size="mini"
							placeholder="请输入电话"
							style="width: 120px"
						/>
					</el-form-item>
				</el-row>
				<br />

				<el-divider content-position="center">货物信息</el-divider>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button
							type="primary"
							icon="el-icon-plus"
							size="mini"
							@click="handleAddInventoryDetail"
							>添加
						</el-button>
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

				<!--        与订单一致-->
				<el-table
					size="mini"
					:data="inventoryDetailList"
					show-summary
					:summary-method="getSummary"
					:row-class-name="rowInventoryDetailIndex"
					@selection-change="handleInventoryDetailSelectionChange"
					ref="inventoryDetail"
				>
					<el-table-column type="selection" width="90" align="center" />
					<el-table-column
						label="序号"
						align="center"
						prop="index"
						width="50"
					/>
					<el-table-column label="供应商" width="200">
						<template #default="scope">
							<el-row>
								<!-- 动态绑定的 Input -->
								<el-col :span="18">
									<el-input
										size="mini"
										v-model="scope.row.supplier"
										placeholder="请输入供应商"
									/>
								</el-col>

								<!-- 供应商按钮 -->
								<el-col :span="6">
									<SearchOption
										:get-data="listCompany"
										icon="el-icon-user"
										query-label="供应商名称"
										query-info="companyName"
										:query-name="querySupplier"
										:limit-info="{ companyType: '供应商' }"
										@commitBack="
											value => handleCommitBackSupplier(scope, value)
										"
										@update:queryName="handleUpdateQuerySupplier"
										@click="setCurrentType(scope.row, 'supplier')"
									>
										<template #table-columns>
											<el-table-column
												label="供应商名称"
												align="center"
												prop="companyName"
											/>
											<el-table-column
												label="联系人"
												align="center"
												prop="relationName"
											/>
											<el-table-column
												label="电话"
												align="center"
												prop="relationTel"
											/>
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</template>
					</el-table-column>

					<el-table-column label="级别名称" prop="levelName" width="150">
						<template #default="scope">
							<el-col :span="16">
								<el-input
									size="mini"
									v-model="scope.row.levelName"
									placeholder="请输入级别名称"
								/>
							</el-col>
							<el-col :span="8">
								<SearchOption
									:get-data="listProductLevel"
									icon="el-icon-search"
									:limit-info="{}"
									query-label="级别名称"
									query-info="levelName"
									:query-name="queryLevel"
									@update:queryName="handleUpdateQueryNameLevel"
									@commitBack="
										value => handleCommitBackProductLevel(scope, value)
									"
									:query-items="queryItemsOrder"
								>
									<template #table-columns>
										<el-table-column
											label="级别编码"
											align="center"
											prop="levelNo"
										/>
										<el-table-column
											label="级别名称"
											align="center"
											prop="levelName"
										/>
										<el-table-column
											label="分类编号"
											align="center"
											prop="categoryNo"
										/>
										<el-table-column
											label="分类名称"
											align="center"
											prop="categoryName"
										/>
										<el-table-column
											label="厚度"
											align="center"
											prop="height"
										/>
										<el-table-column
											label="长度"
											align="center"
											prop="length"
										/>
										<el-table-column label="宽度" align="center" prop="width" />
										<el-table-column
											label="误差"
											align="center"
											prop="tonnage"
										/>
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
							<el-input
								size="mini"
								v-model="scope.row.height"
								placeholder="请选择产品级别"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="长度" prop="length" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.length"
								placeholder="请选择产品级别"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="宽度" prop="width" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.width"
								placeholder="请选择产品级别"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="库存量" prop="stockNumber" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.stockNumber"
								@change="() => (scope.row.actualPieces = scope.row.stockNumber)"
								placeholder="入库时片数"
							/>
						</template>
					</el-table-column>
					<el-table-column label="每包片数" prop="piecesPerPack" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								type="number"
								v-model="scope.row.piecesPerPack"
								@input="
									() => (scope.row.packs > 0 ? calculatePacks(scope) : '')
								"
								placeholder="请输入每包片数"
							/>
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								type="number"
								@input="() => calculatePacks(scope)"
								v-model.lazy="scope.row.packs"
								:placeholder="
									scope.row.piecesPerPack <= 0
										? '请先输入每包片数'
										: '请输入包数'
								"
								:disabled="scope.row.piecesPerPack <= 0"
							/>
						</template>
					</el-table-column>

					<el-table-column label="出厂片数" prop="pieces" width="150">
						<template #default="scope">
							<el-input
								type="number"
								size="mini"
								v-model="scope.row.pieces"
								placeholder="请输入出厂片数"
								disabled
							/>
						</template>
					</el-table-column>

					<el-table-column label="出厂单价" prop="price" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								type="number"
								v-model="scope.row.price"
								@input="scope.row.sundryCost > 0 ? calculatePrice(scope) : ''"
								:placeholder="
									scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'
								"
								:disabled="scope.row.pieces <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="出厂是否含税"
						prop="isIncludeTaxFactory"
						width="150"
					>
						<template #default="scope">
							<el-radio-group
								v-model="scope.row.isIncludeTaxFactory"
								size="mini"
								@change="() => recalculateFactory(scope)"
							>
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								type="number"
								v-model.lazy="scope.row.sundryCost"
								@input="() => calculatePrice(scope)"
								:placeholder="
									scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'
								"
								:disabled="scope.row.price <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								type="number"
								v-model="scope.row.paymentFactory"
								placeholder="请输入出厂货款"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="实际片数" prop="actualPieces" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.actualPieces"
								placeholder="仓库还剩余片数"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="卸货价" prop="paymentUnload" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								type="number"
								v-model.lazy="scope.row.paymentUnload"
								placeholder="请输入卸货价"
								@input="
									scope.row.paymentsWithSundry > 0
										? calculatePayment(scope)
										: ''
								"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="销售是否含税"
						prop="isIncludeTaxSale"
						width="150"
					>
						<template #default="scope">
							<el-radio-group
								v-model="scope.row.isIncludeTaxSale"
								size="mini"
								@change="() => recalculateSale(scope)"
							>
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>

					<el-table-column
						label="总货款杂费"
						prop="paymentsWithSundry"
						width="150"
					>
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.paymentsWithSundry"
								@input="() => calculatePayment(scope)"
								:disabled="scope.row.paymentUnload <= 0"
								:placeholder="
									scope.row.paymentUnload <= 0
										? '请先完善卸货价'
										: '请输入总货款杂费'
								"
							/>
						</template>
					</el-table-column>
					<el-table-column label="总货款" prop="payments" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								type="number"
								v-model="scope.row.payments"
								placeholder="请输入总货款"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="误差" prop="erro" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.erro"
								placeholder="请输入误差"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.tonnage"
								placeholder="请输入吨位"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="陆运费单价"
						prop="landFreightPrice"
						width="150"
						v-if="isLand"
					>
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.landFreightPrice"
								@input="
									() =>
										scope.row.additionalFees > 0
											? calculateLandFreight(scope)
											: ''
								"
								placeholder="请输入陆运费单价"
							/>
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="() => calculateLandFreight(scope)"
								:placeholder="
									scope.row.landFreightPrice <= 0
										? '请先完善陆运费单价'
										: '请输入加费'
								"
								:disabled="scope.row.landFreightPrice <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="陆运费"
						prop="landFreight"
						width="150"
						v-if="isLand"
						disabled
					>
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.landFreight"
								placeholder="请输入陆运费"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="海运费"
						prop="seaFreight"
						width="150"
						v-if="isSea"
					>
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.seaFreight"
								@input="() => calculateFreight(scope)"
								placeholder="请输入海运费"
							/>
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.freight"
								placeholder="请完善运费信息"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.otherCost"
								placeholder="请输入其他费用"
								@input="() => calculatePrice(scope)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="利润" prop="profit" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.profit"
								placeholder="请输入利润"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="不含税利润" prop="profitNoTax" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.profitNoTax"
								placeholder="请输入不含税利润"
								disabled
							/>
						</template>
					</el-table-column>
					<el-table-column label="物流利润" prop="logisticsProfit" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.logisticsProfit"
								placeholder="请输入物流利润"
							/>
						</template>
					</el-table-column>
					<el-table-column label="佣金" prop="customerCommission" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.customerCommission"
								placeholder="请输入佣金"
							/>
						</template>
					</el-table-column>

					<!--          降价金额-->
					<el-table-column
						label="厂家返利金额"
						prop="customerCommission"
						width="150"
					>
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryRebateAmount"
								placeholder="请输入厂家返利金额"
							/>
						</template>
					</el-table-column>
					<el-table-column
						label="厂家降价金额"
						prop="customerCommission"
						width="150"
					>
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryDiscountAmount"
								placeholder="请输入厂家降价金额"
							/>
						</template>
					</el-table-column>

					<el-table-column label="备注" prop="comments" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.comments"
								placeholder="请输入备注"
							/>
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
import SearchOption from '../../../components/SearchOption.vue';
import { fix } from '../../../api/tool/format';
import { listCompany } from '../../../api/system/company';
import { listProductLevel } from '../../../api/system/productLevel';
import { _fill } from './fill';
import { listFleet } from '../../../api/system/fleet';
import { listCars } from '../../../api/system/cars';
import { listInventory } from '../../../api/system/inventory';
import { listStoreHouse } from '../../../api/system/StoreHouse';

export default {
	name: 'InventoryMain',
	components: { SearchOption },
	mixins: [_fill],
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
			rules: {},
			// 海运还是陆运
			isLand: false,
			isSea: false,
			querySupplier: null,
			queryLevel: null,
			queryStore: null,

			// 查询组
			queryItemsCompany: {
				queryList: [
					{
						id: 1,
						label: '老板姓名',
						prop: 'leader',
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
		filterNoStockNumber(data) {
			return new Promise(resolve => {
				resolve(data.filter(item => item.stockNumber > 0));
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
						sums[index] += ' 元';
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
		// 重新计算总货款
		recalculateSale(scope) {
			this.calculatePayment(scope);
		},
		recalculateFactory(scope) {
			this.calculatePaymentFactory(scope);
		},
		calculatePacks(scope) {
			const res = scope.row.packs * scope.row.piecesPerPack;
			scope.row.actualPieces = scope.row.pieces = res;
			// 计算吨位
			scope.row.tonnage = fix(
				((Number(scope.row.height) - Number(scope.row.erro)) *
					scope.row.length *
					scope.row.width *
					scope.row.pieces) /
					1000000 /
					20 /
					20
			);
			if (scope.row.paymentFactory > 0) {
				this.calculatePaymentFactory(scope);
			}
		},
		calculatePaymentFactory(scope) {
			scope.row.paymentFactory =
				scope.row.isIncludeTaxFactory === 0
					? fix(
							(scope.row.length * scope.row.width * scope.row.pieces) /
								(1000000 * scope.row.price) +
								Number(scope.row.sundryCost)
					  )
					: fix(
							(scope.row.length *
								scope.row.width *
								scope.row.pieces *
								scope.row.price) /
								(1000000 + scope.row.sundryCost)
					  );
		},
		calculatePrice(scope) {
			// 计算出厂货款
			this.calculatePaymentFactory(scope);
			// 计算利润
			scope.row.profit = fix(
				scope.row.payments -
					scope.row.paymentFactory -
					scope.row.landFreight -
					scope.row.seaFreight
			);

			// 计算不含税利润
			function calculateProfitNoTax() {
				if (
					scope.row.isIncludeTaxFactory === 0 &&
					scope.row.isIncludeTaxSale === 0
				) {
					return fix(
						scope.row.payments -
							scope.row.paymentFactory -
							scope.row.landFreight -
							scope.row.seaFreight -
							scope.row.otherCost
					);
				} else if (
					scope.row.isIncludeTaxFactory === 1 &&
					scope.row.isIncludeTaxSale === 0
				) {
					return fix(
						scope.row.payments -
							scope.row.paymentFactory / 1.075 -
							scope.row.landFreight -
							scope.row.seaFreight -
							scope.row.otherCost
					);
				} else if (
					scope.row.isIncludeTaxFactory === 0 &&
					scope.row.isIncludeTaxSale === 1
				) {
					return fix(
						scope.row.payments / 1.075 -
							scope.row.paymentFactory -
							scope.row.landFreight -
							scope.row.seaFreight -
							scope.row.otherCost
					);
				} else {
					return fix(
						scope.row.payments -
							scope.row.paymentFactory -
							scope.row.landFreight * 1.075 -
							scope.row.seaFreight -
							((scope.row.height *
								scope.row.length *
								scope.row.width *
								scope.row.pieces) /
								1000000 /
								20) *
								0.5 -
							scope.row.otherCost
					);
				}
			}

			scope.row.profitNoTax = calculateProfitNoTax();
		},
		calculatePayment(scope) {
			function calcu() {
				if (
					scope.row.isIncludeTaxFactory === 1 &&
					scope.row.isIncludeTaxSale === 0
				) {
					scope.row.payments = fix(
						(scope.row.length * scope.row.width * scope.row.actualPieces) /
							(1000000 * scope.row.paymentUnload) +
							Number(scope.row.paymentsWithSundry)
					);
				} else {
					scope.row.payments = fix(
						(scope.row.length *
							scope.row.width *
							scope.row.actualPieces *
							scope.row.paymentUnload) /
							1000000 +
							Number(scope.row.paymentsWithSundry)
					);
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
			scope.row.landFreight = fix(
				Number(scope.row.tonnage) * Number(scope.row.landFreightPrice) +
					Number(scope.row.additionalFees)
			);
			this.calculateFreight(scope);
		},
		calculateFreight(scope) {
			scope.row.freight = fix(
				Number(scope.row.landFreight) +
					(this.isSea ? Number(scope.row.seaFreight) : 0)
			);

			this.calculatePrice(scope);
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
			scope.row.actualPieces = '';
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
			this.title = '添加库存';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getInventoryMain(id).then(response => {
				this.form = response.data;
				this.inventoryDetailList = response.data.inventoryDetailList;
				this.open = true;
				this.title = '修改库存';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					this.form.inventoryDetailList = this.inventoryDetailList;
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
