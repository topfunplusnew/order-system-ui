<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="出库日期" prop="outDate">
				<el-date-picker v-model="queryParams.outDate" type="datetime" placeholder="选择时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" tableName="secondinventory-columns">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:breakout:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-horizontal-scroll="'always'" v-loading="loading" border :data="exWarehouseList" size="mini" @selection-change="handleSelectionChange">
			<el-table-column v-if="columns[0].visible" label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="出库方向" align="center" prop="outDirection" show-overflow-tooltip>
				<template slot-scope="scope">
					<span v-if="scope.row.outDirection && scope.row.outDirection !== '二次加工' && scope.row.outDirection !== '货物破损'">
						<el-tooltip content="该出库方向为客户名称" placement="top">
							<span style="color: #f56c6c; font-weight: bold">{{ scope.row.outDirection }}[客户]</span>
						</el-tooltip>
					</span>
					<span v-else-if="scope.row.outDirection && scope.row.outDirection === '二次加工'">二次入库出库</span>
					<span v-else>存货毁损</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="变动日期(出库)" align="center" prop="outDate" show-overflow-tooltip>
				<template #default="scope">
					{{ parseTime(scope.row.outDate, '{y}-{m}-{d}') }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="产品级别" align="center" prop="sourceInventoryDetail.levelName" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="厚度" align="center" prop="sourceInventoryDetail.height" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="长度" align="center" prop="sourceInventoryDetail.length" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="宽度" align="center" prop="sourceInventoryDetail.width" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="存货价" align="center" prop="sourceInventoryDetail.paymentUnload" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="出库量" align="center" prop="outAmount" show-overflow-tooltip />
			<!-- 新增毁损金额列 -->
			<el-table-column v-if="columns[9].visible" label="毁损金额" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ ((scope.row.sourceInventoryDetail.length || 0) * (scope.row.sourceInventoryDetail.width || 0) * (scope.row.sourceInventoryDetail.paymentUnload || 0) * (scope.row.outAmount || 0) * 0.000001).toFixed(2) }}
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="80">
				<template slot-scope="scope">
					<el-dropdown trigger="hover">
						<span class="el-dropdown-link">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</span>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item v-hasPermi="['system:secondinventory:list']" @click.native="checkInvoInfo(scope.row)">查看库存信息</el-dropdown-item>
							<!--							<el-dropdown-item v-hasPermi="['system:secondinventory:edit']" @click.native="handleUpdate(scope.row)">修改</el-dropdown-item>-->
							<el-dropdown-item v-hasPermi="['system:secondinventory:remove']" @click.native="handleDelete(scope.row)">删除</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改出库对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-input v-model="form.storeHouseName" placeholder="请输入仓库名称" />
				</el-form-item>
				<el-form-item label="出库日期" prop="outDate">
					<el-date-picker v-model="form.outDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="出库量" prop="outAmount">
					<el-input v-model="form.outAmount" placeholder="请输入出库量" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    破损后入库的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="secondInventoryVisible" width="1200px" append-to-body>
			<el-form ref="secondForm" :model="secondForm" :rules="secondRules" label-width="80px" :inline="true">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-col :span="16">
						<el-input size="mini" v-model="secondForm.storeHouseName" placeholder="请输入仓库名称" />
					</el-col>
					<el-col :span="8">
						<SearchOption :get-data="listStoreHouse" icon="el-icon-s-home" :limit-info="{}" query-label="仓库名称" query-info="storeHouseName" :query-name="queryStore" @commitBack="value => handleCommitBackInventory(value)" @update:queryName="handleUpdateQueryNameStore" :is-page="false">
							<template #table-columns>
								<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
								<el-table-column label="地址" align="center" prop="address" />
							</template>
						</SearchOption>
					</el-col>
				</el-form-item>
				<el-form-item label="入库日期" prop="storeDate">
					<el-date-picker v-model="secondForm.storeDate" size="mini" type="datetime" placeholder="选择入库日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 120px" />
				</el-form-item>
				<el-form-item label="货物来源" prop="goodsCompany">
					<el-input size="mini" v-model="secondForm.goodsCompany" placeholder="请输入货物来源公司(本部或者海盛)" />
				</el-form-item>
				<el-form-item label="附件">
					<file-upload @input="handleCommitUpload" />
				</el-form-item>
				<br />
				<el-form-item label="运输方式">
					<el-checkbox v-model="isLand">陆运</el-checkbox>
					<el-checkbox v-model="isSea">海运</el-checkbox>
				</el-form-item>
				<el-row v-if="isLand" style="margin: 20px 0">
					<el-form-item label="车牌">
						<el-row>
							<el-col :span="20">
								<el-input v-model="secondForm.landCarNo" type="text" size="mini" placeholder="请输入陆运车牌" style="width: 120px" />
							</el-col>
							<el-col :span="4">
								<!--搜索银行卡信息-->
								<SearchOption :limit-info="{ carType: '陆运' }" :get-data="listCars" query-label="车牌搜索" query-info="carNo" :query-name="queryLandCar" @commitBack="handleCommitBackCar" @update:queryName="handleChangeCar">
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
						<el-input v-model="secondForm.landDriverName" type="text" size="mini" placeholder="请输入陆运司机姓名" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input v-model="secondForm.landDriverTel" type="text" size="mini" placeholder="请输入陆运司机电话" style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号">
						<el-input v-model="secondForm.landBankNo" type="text" size="mini" placeholder="请输入陆运银行卡号" style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行">
						<el-input v-model="secondForm.landBankName" type="text" size="mini" placeholder="请输入陆运开户行" style="width: 120px" />
					</el-form-item>
					<!-- 添加车队 -->
					<el-form-item label="车队">
						<el-row>
							<el-col :span="12">
								<el-input v-model="secondForm.fleet" type="text" size="mini" placeholder="请输入车队" />
							</el-col>
							<el-col :span="4">
								<SearchOption :limit-info="{}" :get-data="listFleet" query-label="车队名称" query-info="fname" :query-name="queryFleet" @commitBack="handleCommitBackFleet" @update:queryName="handleChangeFleet">
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
				<el-row v-if="isSea" style="margin: 10px 0">
					<!--   车牌修改为柜号 且自己输入 不提供自动填充 -->
					<el-form-item label="柜号">
						<el-row>
							<el-col :span="20">
								<el-input v-model="secondForm.seaCarNo" type="text" size="mini" placeholder="请输入柜号" style="width: 120px" />
							</el-col>
							<el-col :span="4">
								<SearchOption :limit-info="{ carType: '海运' }" :get-data="listCars" query-label="车牌" query-info="carNo" :query-name="querySeaCars" @commitBack="handleCommitBackSeaCar" @update:queryName="handleChangeSeaCar">
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
					<el-form-item label="海运公司">
						<el-input v-model="secondForm.seaDriverName" type="text" size="mini" placeholder="请输入海运公司" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input v-model="secondForm.seaDriverTel" type="text" size="mini" placeholder="请输入电话" style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号">
						<el-input v-model="secondForm.seaBankNo" type="text" size="mini" placeholder="请输入海运银行卡号" style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行">
						<el-input v-model="secondForm.seaBankName" type="text" size="mini" placeholder="请输入海运开户行" style="width: 120px" />
					</el-form-item>
				</el-row>
				<br />

				<el-divider content-position="center">货物信息</el-divider>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddInventoryDetail">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteInventoryDetail">删除</el-button>
					</el-col>
				</el-row>

				<!--        与订单一致-->
				<el-table size="mini" :data="inventoryDetailList" show-summary :summary-method="getSummary" :row-class-name="rowInventoryDetailIndex" @selection-change="handleInventoryDetailSelectionChange" ref="inventoryDetail">
					<el-table-column type="selection" width="90" align="center" />
					<el-table-column label="序号" align="center" prop="index" width="50" />
					<el-table-column label="供应商" width="200">
						<template #default="scope">
							<el-row>
								<!-- 动态绑定的 Input -->
								<el-col :span="18">
									<el-input size="mini" v-model="scope.row.supplier" placeholder="请输入供应商" />
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
										@commitBack="value => handleCommitBackSupplier(scope, value)"
										@update:queryName="handleUpdateQuerySupplier"
										@click="setCurrentType(scope.row, 'supplier')"
									>
										<template #table-columns>
											<el-table-column label="供应商名称" align="center" prop="companyName" />
											<el-table-column label="联系人" align="center" prop="relationName" />
											<el-table-column label="电话" align="center" prop="relationTel" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</template>
					</el-table-column>

					<el-table-column label="级别名称" prop="levelName" width="150">
						<template #default="scope">
							<el-col :span="16">
								<el-input size="mini" v-model="scope.row.levelName" placeholder="请输入级别名称" />
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
									@commitBack="value => handleCommitBackProductLevel(scope, value)"
									:query-items="queryItemsOrder"
								>
									<template #table-columns>
										<el-table-column label="级别编码" align="center" prop="levelNo" />
										<el-table-column label="级别名称" align="center" prop="levelName" min-width="140" />
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
								<el-radio label="片数">片数</el-radio>
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
					<el-table-column label="库存量" prop="stockNumber" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.stockNumber" @change="() => (scope.row.actualPieces = scope.row.stockNumber)" placeholder="入库时片数" />
						</template>
					</el-table-column>
					<el-table-column label="每包片数" prop="piecesPerPack" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.piecesPerPack" @input="() => (scope.row.packs > 0 ? calculatePacks(scope) : '')" placeholder="请输入每包片数" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" @input="() => calculatePacks(scope)" v-model.lazy="scope.row.packs" :placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'" :disabled="scope.row.piecesPerPack <= 0" />
						</template>
					</el-table-column>

					<el-table-column label="出厂片数" prop="pieces" width="150">
						<template #default="scope">
							<el-input type="number" size="mini" v-model="scope.row.pieces" placeholder="请输入出厂片数" disabled />
						</template>
					</el-table-column>

					<el-table-column label="出厂单价" prop="price" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.price" @input="scope.row.sundryCost > 0 ? calculatePrice(scope) : ''" :placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'" :disabled="scope.row.pieces <= 0" />
						</template>
					</el-table-column>
					<el-table-column label="出厂是否含税" prop="isIncludeTaxFactory" width="150">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateFactory(scope)">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model.lazy="scope.row.sundryCost" @input="() => calculatePrice(scope)" :placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'" :disabled="scope.row.price <= 0" />
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.paymentFactory" placeholder="请输入出厂货款" disabled />
						</template>
					</el-table-column>
					<!--					<el-table-column label="实际片数" prop="actualPieces" width="150">-->
					<!--						<template #default="scope">-->
					<!--							<el-input size="mini" v-model="scope.row.actualPieces" placeholder="仓库还剩余片数" disabled />-->
					<!--						</template>-->
					<!--					</el-table-column>-->
					<el-table-column label="存货价" prop="paymentUnload" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model.lazy="scope.row.paymentUnload" placeholder="请输入存货价" @input="scope.row.paymentsWithSundry > 0 ? calculatePayment(scope) : ''" />
						</template>
					</el-table-column>
					<el-table-column label="库存是否含税" prop="isIncludeTaxSale" width="150">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateSale(scope)">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>

					<el-table-column label="总货款" prop="payments" width="150">
						<template #default="scope">
							<el-input size="mini" type="number" v-model="scope.row.payments" placeholder="请输入总货款" disabled />
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
							<el-input size="mini" v-model.lazy="scope.row.landFreightPrice" @input="() => (scope.row.additionalFees > 0 ? calculateLandFreight(scope) : '')" placeholder="请输入陆运费单价" />
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.additionalFees" @input="() => calculateLandFreight(scope)" :placeholder="scope.row.landFreightPrice <= 0 ? '请先完善陆运费单价' : '请输入加费'" :disabled="scope.row.landFreightPrice <= 0" />
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="150" v-if="isLand" disabled>
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.landFreight" placeholder="请输入陆运费" />
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="150" v-if="isSea">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.seaFreight" @input="() => calculateFreight(scope)" placeholder="请输入海运费" />
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.freight" placeholder="请完善运费信息" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.otherCost" placeholder="请输入其他费用" @input="() => calculatePrice(scope)" />
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
					<el-table-column label="厂家佣金" prop="factoryCommission" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryCommission" placeholder="请输入厂家佣金" />
						</template>
					</el-table-column>

					<!--          降价金额-->
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryRebateAmount" placeholder="请输入计提厂家返利金额" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="150">
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
				<el-button type="primary" @click="submitSecond">确 定</el-button>
				<el-button @click="cancelSecond">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addExWarehouse, delExWarehouse, getExWarehouse, listExWarehouse, updateExWarehouse } from '@/api/system/exWarehouse';
import { excludeParams } from '@/api/tool/exclude';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { getDetail, getInventoryMainByDetailId } from '../../../api/system/detail';
import { listStoreHouse } from '../../../api/system/StoreHouse';
import { listCars } from '../../../api/system/cars';
import { listFleet } from '../../../api/system/fleet';
import { listCompany } from '../../../api/system/company';
import { listProductLevel } from '../../../api/system/productLevel';
import { fix } from '../../../api/tool/format';
import SearchOption from '../../../components/SearchOption.vue';
import { _fill } from './fill';
import { updateInventoryMain, addInventoryMain } from '../../../api/system/inventoryMain';
import { parseTime } from '@/utils/ruoyi';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';

export default {
	name: 'BreakOut',
	components: { SearchOption },
	mixins: [_fill, common_dialog],
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			exWarehouseList: [],
			title: '',
			open: false,
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				ordersNo: '货物破损',
				storeHouseid: null,
				storeHouseName: null,
				storeID: null,
				outDate: null,
				outAmount: null,
				delFlag: null,
				addtime: null,
				userId: null,
				UserName: null
			},
			form: {},
			rules: {},
			columns: [
				{ key: 0, label: `仓库名称`, visible: true },
				{ key: 1, label: `出库方向`, visible: true },
				{ key: 2, label: `出库日期`, visible: true },
				{ key: 3, label: `产品级别`, visible: true },
				{ key: 4, label: `厚度`, visible: true },
				{ key: 5, label: `长度`, visible: true },
				{ key: 6, label: `宽度`, visible: true },
				{ key: 7, label: `存货价`, visible: true },
				{ key: 8, label: `出库量`, visible: true },
				{ key: 9, label: `毁损金额`, visible: true } // 新增
			],
			isLand: false,
			isSea: false,
			inventoryDetailList: [],
			secondInventoryVisible: false,
			queryStore: '',
			queryLandCar: '',
			querySeaCars: '',
			queryFleet: '',
			querySupplier: '',
			queryLevel: '',
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
			},
			secondForm: {},
			secondRules: {
				seaCarNo: [{ required: true, message: '请输入柜号', trigger: 'blur' }],
				seaDriverName: [
					{
						required: true,
						message: '请输入司机姓名',
						trigger: 'blur'
					}
				],
				seaDriverTel: [
					{
						required: true,
						message: '请输入司机电话',
						trigger: 'blur'
					}
				],
				seaBankNo: [
					{
						required: true,
						message: '请输入银行卡号',
						trigger: 'blur'
					}
				],
				seaBankName: [{ required: true, message: '请输入开户行', trigger: 'blur' }]
			}
		};
	},
	// 展示与隐藏
	created() {
		this.getList();
	},

	methods: {
		listStoreHouse,
		listCars,
		listFleet,
		listCompany,
		listProductLevel,
		handleCommitUpload(val) {
			this.form.receiveProof = val;
		},
		// 查看库存信息 查询当前行的库存信息
		checkInvoInfo(row) {
			if (!row.storeID) {
				this.$message.warning('查看库存时发生错误，改行数据没有storeID');
				return;
			}

			getInventoryMainByDetailId(row.storeID).then(res => {
				this.openDialog(INVENTORY, '查看库存信息', '100%', { needToShowInfo: res.data || {} }, false, false);
			});
		},
		// 破损后入库 应该出来一个破损后入库的页面 和货物入库一样
		secondInventory(row) {
			// 查询该行的货物信息
			getDetail(row.storeID).then(res => {
				this.inventoryDetailList.push({
					supplier: res.data.supplier,
					supplierId: res.data.supplierId,
					levelName: res.data.levelName,
					levelID: res.data.levelID,
					height: res.data.height,
					length: res.data.length,
					width: res.data.width
				});
				this.secondInventoryVisible = true;
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
			scope.row.tonnage = fix(((Number(scope.row.height) - Number(scope.row.erro)) * scope.row.length * scope.row.width * scope.row.pieces) / 1000000 / 20 / 20);
			if (scope.row.paymentFactory > 0) {
				this.calculatePaymentFactory(scope);
			}
		},
		calculatePaymentFactory(scope) {
			scope.row.paymentFactory =
				scope.row.isIncludeTaxFactory === 0 ? fix((scope.row.length * scope.row.width * scope.row.pieces) / (1000000 * scope.row.price) + Number(scope.row.sundryCost)) : fix((scope.row.length * scope.row.width * scope.row.pieces * scope.row.price) / (1000000 + scope.row.sundryCost));
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
					return fix(scope.row.payments - scope.row.paymentFactory - scope.row.landFreight * 1.075 - scope.row.seaFreight - ((scope.row.height * scope.row.length * scope.row.width * scope.row.pieces) / 1000000 / 20) * 0.5 - scope.row.otherCost);
				}
			}

			scope.row.profitNoTax = calculateProfitNoTax();
		},
		calculatePayment(scope) {
			function calcu() {
				if (scope.row.isIncludeTaxFactory === 1 && scope.row.isIncludeTaxSale === 0) {
					scope.row.payments = fix((scope.row.length * scope.row.width * scope.row.actualPieces) / (1000000 * scope.row.paymentUnload) + Number(scope.row.paymentsWithSundry));
				} else {
					scope.row.payments = fix((scope.row.length * scope.row.width * scope.row.actualPieces * scope.row.paymentUnload) / 1000000 + Number(scope.row.paymentsWithSundry));
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
			scope.row.countingUnit = '片数';
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
			scope.row.factoryCommission = '';
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
			obj.countingUnit = '片数';
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
			obj.factoryCommission = '';
			obj.comments = '';
			this.inventoryDetailList.push(obj);
		},
		handleInventoryDetailSelectionChange(selection) {
			this.checkedInventoryDetail = selection.map(item => item.index);
		},
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
		cancelSecond() {
			this.secondInventoryVisible = false;
			this.resetSecond();
		},
		submitSecond() {
			this.$refs['secondForm'].validate(valid => {
				if (valid) {
					this.secondForm.inventoryDetailList = this.inventoryDetailList.map(d => ({
						...d,
						countingUnit: d.countingUnit === '片' ? '片数' : d.countingUnit || '片数'
					}));
					// 计算陆运费
					this.secondForm.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => prev + curr.landFreight, 0) : 0;
					// 计算海运费
					this.secondForm.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => prev + curr.seaFreight, 0) : 0;
					if (this.secondForm.id != null) {
						updateInventoryMain(this.secondForm).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.secondInventoryVisible = false;
							this.getList();
						});
					} else {
						addInventoryMain(this.secondForm).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.secondInventoryVisible = false;
							this.getList();
						});
					}
				}
			});
		},
		resetSecond() {
			this.isSea = false;
			this.isLand = false;
			this.secondForm = {
				id: null,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: null,
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
			this.resetForm('secondForm');
		},
		/** 查询出库列表 */
		getList() {
			this.loading = true;
			listExWarehouse(this.queryParams).then(response => {
				this.exWarehouseList = response.rows;
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
				ordersNo: null,
				storeHouseid: null,
				storeHouseName: null,
				storeID: null,
				outDate: null,
				outAmount: null,
				delFlag: null,
				updateTime: null,
				addtime: null,
				userId: null,
				UserName: null
			};
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
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加出库';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getExWarehouse(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改出库';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateExWarehouse(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addExWarehouse(this.form).then(() => {
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
				.confirm('是否确认删除出库编号为"' + ids + '"的数据项？')
				.then(function () {
					return delExWarehouse(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/exWarehouse/export',
				{
					...this.queryParams
				},
				`出库拆分_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
