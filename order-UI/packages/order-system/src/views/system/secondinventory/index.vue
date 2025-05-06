<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
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
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!-- 后端说导出不要了 -->
				<!-- <template #export>
          <el-col :span="1.5">
            <el-button
              v-hasPermi="['system:secondinventory:export']"
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
            ></el-button>
          </el-col>
        </template> -->
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-horizontal-scroll="'always'" v-loading="loading" border :data="exWarehouseList" size="mini" @selection-change="handleSelectionChange">
			<el-table-column v-if="columns[0].visible" label="仓库名称" align="center" prop="storeHouseName" />
			<el-table-column v-if="columns[1].visible" label="出库日期" align="center" prop="outDate" />
			<el-table-column v-if="columns[2].visible" label="产品级别" align="center" prop="inventoryDetail.levelName" />
			<el-table-column v-if="columns[3].visible" label="厚度" align="center" prop="inventoryDetail.height" />
			<el-table-column v-if="columns[4].visible" label="长度" align="center" prop="inventoryDetail.length" />
			<el-table-column v-if="columns[5].visible" label="宽度" align="center" prop="inventoryDetail.width" />
			<el-table-column v-if="columns[6].visible" label="存货价" align="center" prop="inventoryDetail.paymentUnload" />
			<el-table-column v-if="columns[7].visible" label="出库量" align="center" prop="outAmount" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="80">
				<template slot-scope="scope">
					<el-dropdown trigger="hover">
						<span class="el-dropdown-link">
							操作<i class="el-icon-arrow-down el-icon--right"></i>
						</span>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item v-hasPermi="['system:secondinventory:add']" @click.native="secondInventory(scope.row)">二次入库</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:secondinventory:list']" @click.native="checkInvoInfo(scope.row)">查看库存信息</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:secondinventory:edit']" @click.native="handleUpdate(scope.row)">修改</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:secondinventory:remove']" @click.native="handleDelete(scope.row)">删除</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改出库对话框 -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<!--        <el-form-item label="订单编号" prop="ordersNo">-->
				<!--          <el-input v-model="form.ordersNo" placeholder="请输入订单编号"/>-->
				<!--        </el-form-item>-->
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-input v-model="form.storeHouseName" placeholder="请输入仓库名称" />
				</el-form-item>
				<!--        <el-form-item label="仓库存储的货物ID" prop="storeID">-->
				<!--          <el-input v-model="form.storeID" placeholder="请输入仓库存储的货物ID"/>-->
				<!--        </el-form-item>-->
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

		<!--    二次入库的弹窗-->
		<el-dialog :title="title" :visible.sync="secondInventoryVisible" width="1200px" append-to-body :close-on-click-modal="false">
			<el-form ref="secondForm" :model="secondForm" :rules="secondRules" label-width="80px" :inline="true">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-col :span="16">
						<el-input size="mini" v-model="secondForm.storeHouseName" placeholder="请输入仓库名称" />
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
							:is-page="false"
						>
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
				<el-form-item label="运输方式" required>
					<el-checkbox v-model="isLand">陆运</el-checkbox>
					<el-checkbox v-model="isSea">海运</el-checkbox>
					<div v-if="transportError" class="el-form-item__error">请至少选择一种运输方式</div>
				</el-form-item>
				<el-row v-if="isLand" style="margin: 20px 0">
					<el-form-item label="车牌" prop="landCarNo">
						<el-row>
							<el-col :span="20">
								<el-input disabled v-model="secondForm.landCarNo" type="text" size="mini" placeholder="请输入陆运车牌" style="width: 120px" />
							</el-col>
							<el-col :span="4">
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
						<el-input disabled v-model="secondForm.landDriverName" type="text" size="mini" placeholder="请输入陆运司机姓名" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input disabled v-model="secondForm.landDriverTel" type="text" size="mini" placeholder="请输入陆运司机电话" style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号">
						<el-input disabled v-model="secondForm.landBankNo" type="text" size="mini" placeholder="请输入陆运银行卡号" style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行">
						<el-input disabled v-model="secondForm.landBankName" type="text" size="mini" placeholder="请输入陆运开户行" style="width: 120px" />
					</el-form-item>
					<el-form-item label="车队" prop="fleet">
						<el-row>
							<el-col :span="12">
								<el-input disabled v-model="secondForm.fleet" type="text" size="mini" placeholder="请输入车队" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:limit-info="{}"
									:get-data="listFleet"
									query-label="车队名称"
									query-info="fname"
									:query-name="queryFleet"
									@commitBack="handleCommitBackFleet"
									@update:queryName="handleChangeFleet"
								>
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
				</el-row>
				<el-row v-if="isSea" style="margin: 10px 0">
					<el-form-item label="柜号" prop="seaCarNo">
						<el-row>
							<el-col :span="20">
								<el-input v-model="secondForm.seaCarNo" type="text" size="mini" placeholder="请输入柜号" style="width: 120px" />
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
										<el-table-column label="柜号" align="center" prop="carNo" />
										<el-table-column label="海运公司" align="center" prop="driver" />
										<el-table-column label="电话" align="center" prop="tel" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="海运公司" prop="seaDriverName">
						<el-input disabled v-model="secondForm.seaDriverName" type="text" size="mini" placeholder="请输入海运公司" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input disabled v-model="secondForm.seaDriverTel" type="text" size="mini" placeholder="请输入电话" style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号">
						<el-input disabled v-model="secondForm.seaBankNo" type="text" size="mini" placeholder="请输入海运银行卡号" style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行">
						<el-input disabled v-model="secondForm.seaBankName" type="text" size="mini" placeholder="请输入海运开户行" style="width: 120px" />
					</el-form-item>
				</el-row>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddInventoryDetail" :disabled="!isEditingDetails">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteInventoryDetail" :disabled="!isEditingDetails || checkedInventoryDetail.length === 0">
							删除
						</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button size="mini" type="warning" @click="toggleEditDetails(true)" :disabled="isEditingDetails">编辑子项</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button size="mini" type="success" @click="toggleEditDetails(false)" :disabled="!isEditingDetails">全部保存</el-button>
					</el-col>
				</el-row>

				<el-table
					size="mini"
					:data="inventoryDetailList"
					show-summary
					:summary-method="getSummary"
					:row-class-name="getRowClassName"
					@selection-change="handleInventoryDetailSelectionChange"
					ref="inventoryDetail"
				>
					<el-table-column type="selection" width="50" align="center" :selectable="() => isEditingDetails" />
					<el-table-column label="序号" align="center" type="index" width="50" />
					<el-table-column label="行操作" align="center" width="100" fixed="left">
						<template slot-scope="scope">
							<el-button v-if="!scope.row.isEditing" :disabled="!isEditingDetails" size="mini" type="warning" icon="el-icon-edit" @click="handleRowEdit(scope.row)">编辑</el-button>
							<el-button v-else size="mini" type="success" icon="el-icon-check" @click="handleRowSave(scope.row)">保存</el-button>
						</template>
					</el-table-column>
					<el-table-column label="供应商" width="220">
						<template #default="scope">
							<el-row>
								<el-col :span="14">
									<el-input size="mini" v-model="scope.row.supplier" placeholder="请输入供应商" :disabled="!scope.row.isEditing || selfButtonDisabled" />
								</el-col>
								<el-col :span="5">
									<el-button
										id="selfButton"
										:type="selfButtonDisabled ? 'danger' : 'success'"
										size="mini"
										icon="el-icon-school"
										@click="
											() => {
												if (!selfButtonDisabled) {
													scope.row.supplier = PUBLIC_DICT_TYPE.SELF_COMPANY;
													scope.row.supplierId = 0;
													selfButtonDisabled = true;
												} else {
													scope.row.supplier = '';
													scope.row.supplierId = '';
													selfButtonDisabled = false;
												}
											}
										"
									></el-button>
								</el-col>
								<el-col :span="5">
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
										:disable="!scope.row.isEditing || selfButtonDisabled"
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
								<el-input size="mini" v-model="scope.row.levelName" placeholder="请输入级别名称" :disabled="!scope.row.isEditing" />
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
									:disable="!scope.row.isEditing"
								>
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
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!scope.row.isEditing">
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
					<el-table-column label="每包片数" prop="piecesPerPack" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.piecesPerPack" @input="() => recalculateAll(scope)" placeholder="请输入每包片数" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								@input="() => recalculateAll(scope)"
								v-model.lazy="scope.row.packs"
								:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
								:disabled="!scope.row.isEditing || scope.row.piecesPerPack <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂片数" prop="pieces" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.pieces" @input="val => handlePiecesChange(scope, val)" placeholder="请输入出厂片数" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="出厂单价" prop="price" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.price"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="!scope.row.isEditing || scope.row.pieces <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂是否含税" prop="isIncludeTaxFactory" width="150">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.sundryCost"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'"
								:disabled="!scope.row.isEditing || scope.row.price <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.paymentFactory" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="二次入库片数" prop="actualPieces" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.actualPieces" placeholder="请输入二次入库片数" disabled />
						</template>
					</el-table-column>
					<el-table-column label="存货价" prop="paymentUnload" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.paymentUnload" placeholder="请输入存货价" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="库存是否含税" prop="isIncludeTaxSale" width="150">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing">
								<el-radio :label="1">是</el-radio>
								<el-radio :label="0">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="库存金额" prop="payments" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.payments" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="误差" prop="erro" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" disabled />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.tonnage" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="陆运费单价" prop="landFreightPrice" width="150" v-if="isLand">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.landFreightPrice" @input="() => recalculateAll(scope)" placeholder="请输入陆运费单价" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.landFreightPrice <= 0 ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="150" v-if="isLand">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.landFreight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="150" v-if="isSea">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.seaFreight" @input="() => recalculateAll(scope)" placeholder="请输入海运费" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="总运费" prop="freight" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="150">
						<template #default="scope">
							<el-input size="mini" v-model.lazy="scope.row.otherCost" placeholder="请输入其他费用" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="利润" prop="profit" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profit" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="不含税利润" prop="profitNoTax" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profitNoTax" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="物流利润" prop="logisticsProfit" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.logisticsProfit" placeholder="请输入物流利润" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="厂家佣金" prop="factoryCommission" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryCommission" placeholder="请输入厂家佣金" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryRebateAmount" placeholder="请输入计提厂家返利金额" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.factoryDiscountAmount" placeholder="请输入计提厂家降价金额" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="备注" prop="comments" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
				</el-table>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitSecond">确 定</el-button>
				<el-button @click="cancelSecond">取 消</el-button>
			</div>
		</el-dialog>

		<el-dialog :close-on-click-modal="false" :show-close="true" title="库存信息" :visible.sync="inventoryInfoVisible" width="900px" append-to-body>
			<el-descriptions title="库存详情" border size="mini">
				<el-descriptions-item label="陆地车号">
					{{ inventoryInfo.landCarNo }}
				</el-descriptions-item>
				<el-descriptions-item label="陆地司机姓名">
					{{ inventoryInfo.landDriverName }}
				</el-descriptions-item>
				<el-descriptions-item label="陆地司机电话">
					{{ inventoryInfo.landDriverTel }}
				</el-descriptions-item>
				<el-descriptions-item label="陆地运费">
					{{ inventoryInfo.landFreight }}
				</el-descriptions-item>
				<el-descriptions-item label="陆地运费单价">
					{{ inventoryInfo.landFreightPrice }}
				</el-descriptions-item>
				<el-descriptions-item label="长度">
					{{ inventoryInfo.length }}
				</el-descriptions-item>
				<el-descriptions-item label="宽度">
					{{ inventoryInfo.width }}
				</el-descriptions-item>
				<el-descriptions-item label="厚度">
					{{ inventoryInfo.height }}
				</el-descriptions-item>
				<el-descriptions-item label="吨位">
					{{ inventoryInfo.freight }}
				</el-descriptions-item>
				<el-descriptions-item label="单位">
					{{ inventoryInfo.countingUnit }}
				</el-descriptions-item>
				<el-descriptions-item label="误差">
					{{ inventoryInfo.erro }}
				</el-descriptions-item>
				<el-descriptions-item label="等级名称">
					{{ inventoryInfo.levelName }}
				</el-descriptions-item>
				<el-descriptions-item label="其他费用">
					{{ inventoryInfo.otherCost }}
				</el-descriptions-item>
				<el-descriptions-item label="包数">
					{{ inventoryInfo.packs }}
				</el-descriptions-item>
				<el-descriptions-item label="出厂货款">
					{{ inventoryInfo.paymentFactory }}
				</el-descriptions-item>
				<el-descriptions-item label="卸货付款">
					{{ inventoryInfo.paymentUnload }}
				</el-descriptions-item>
				<el-descriptions-item label="总货款">
					{{ inventoryInfo.payments }}
				</el-descriptions-item>
				<el-descriptions-item label="产品级别">
					{{ inventoryInfo.levelName }}
				</el-descriptions-item>
				<el-descriptions-item label="产品级别">
					{{ inventoryInfo.levelName }}
				</el-descriptions-item>
				<el-descriptions-item label="剩余库存量">
					{{ inventoryInfo.stockNumber }}
				</el-descriptions-item>
				<el-descriptions-item label="供应商">
					{{ inventoryInfo.supplier }}
				</el-descriptions-item>
				<el-descriptions-item label="重量">
					{{ inventoryInfo.tonnage }}
				</el-descriptions-item>
				<el-descriptions-item label="库存编号">
					{{ inventoryInfo.stockNumber }}
				</el-descriptions-item>
				<el-descriptions-item label="存储日期">
					{{ inventoryInfo.storeDate }}
				</el-descriptions-item>
				<el-descriptions-item label="仓库名称">
					{{ inventoryInfo.storeHouseName }}
				</el-descriptions-item>
				<el-descriptions-item label="杂费">
					{{ inventoryInfo.sundryCost }}
				</el-descriptions-item>
			</el-descriptions>
		</el-dialog>

		<v-tour name="selfButtonTour" :steps="selfButtonTourSteps" :options="tourOptions" :callbacks="tourCallBacks"></v-tour>
	</div>
</template>

<script>
import { addExWarehouse, delExWarehouse, getExWarehouse, listExWarehouse, updateExWarehouse } from '@/api/system/exWarehouse';
import { excludeParams } from '@/api/tool/exclude';
import { getDetail } from '../../../api/system/detail';
import { listStoreHouse } from '../../../api/system/StoreHouse';
import { listCars } from '../../../api/system/cars';
import { listFleet } from '../../../api/system/fleet';
import { listCompany } from '../../../api/system/company';
import { listProductLevel } from '../../../api/system/productLevel';
import { fix } from '../../../api/tool/format';
import SearchOption from '../../../components/SearchOption.vue';
import { _fill } from './fill';
import { updateInventoryMain, addInventoryMain } from '../../../api/system/inventoryMain';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
// 导入库存计算工具函数
import { updateInventoryRowCalculations } from '../inventoryMain/inventoryCalculations';
import { parseTime } from '@/utils/ruoyi';

export default {
	name: 'SecondInventory',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	components: { SearchOption },
	mixins: [_fill],
	data() {
		// 自定义校验器：仓库名称必填
		const validateStoreHouseName = (rule, value, callback) => {
			if (!value) {
				callback(new Error('请选择仓库名称'));
			} else {
				callback();
			}
		};

		// 自定义校验器：入库日期必填
		const validateStoreDate = (rule, value, callback) => {
			if (!value) {
				callback(new Error('请选择入库日期'));
			} else {
				callback();
			}
		};

		// 自定义校验器：货物来源必填
		const validateGoodsCompany = (rule, value, callback) => {
			if (!value) {
				callback(new Error('请输入货物来源公司'));
			} else {
				callback();
			}
		};

		// 自定义校验器：当选择陆运时，车队必填
		const validateFleet = (rule, value, callback) => {
			if (this.isLand && !this.secondForm.fleet) {
				callback(new Error('选择陆运时，请选择车队'));
			} else {
				callback();
			}
		};

		// 自定义校验器：当选择陆运时，必须选择车牌信息
		const validateLandCarNo = (rule, value, callback) => {
			if (this.isLand && !this.secondForm.landCarNo) {
				callback(new Error('选择陆运时，请选择车牌信息'));
			} else {
				callback();
			}
		};

		// 自定义校验器：当选择海运时，柜号必填
		const validateSeaCarNo = (rule, value, callback) => {
			if (this.isSea && !value) {
				callback(new Error('选择海运时，柜号不能为空'));
			} else {
				callback();
			}
		};

		// 自定义校验器：当选择海运时，海运公司必填
		const validateSeaDriverName = (rule, value, callback) => {
			if (this.isSea && !this.secondForm.seaDriverName) {
				callback(new Error('选择海运时，请选择海运公司信息'));
			} else {
				callback();
			}
		};

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
				pageSize: 10,
				ordersNo: '二次加工',
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
				{ key: 1, label: `出库日期`, visible: true },
				{ key: 2, label: `产品级别`, visible: true },
				{ key: 3, label: `厚度`, visible: true },
				{ key: 4, label: `长度`, visible: true },
				{ key: 5, label: `宽度`, visible: true },
				{ key: 6, label: `存货价`, visible: true },
				{ key: 7, label: `出库量`, visible: true }
			],
			inventoryInfoVisible: false,
			isLand: false,
			isSea: false,
			inventoryDetailList: [],
			inventoryInfo: {},
			secondInventoryVisible: false,
			queryStore: '',
			queryLandCar: '',
			querySeaCars: '',
			queryFleet: '',
			querySupplier: '',
			queryLevel: '',
			isEditingDetails: false,
			checkedInventoryDetail: [],
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
				storeHouseName: [{ required: true, validator: validateStoreHouseName, trigger: 'blur' }],
				storeDate: [{ required: true, validator: validateStoreDate, trigger: 'blur' }],
				goodsCompany: [{ required: true, validator: validateGoodsCompany, trigger: 'blur' }],
				fleet: [{ validator: validateFleet, trigger: 'change' }],
				landCarNo: [{ validator: validateLandCarNo, trigger: 'change' }],
				seaCarNo: [{ validator: validateSeaCarNo, trigger: 'blur' }],
				seaDriverName: [{ validator: validateSeaDriverName, trigger: 'change' }],
				seaDriverTel: [{ required: true, message: '请输入司机电话', trigger: 'blur' }],
				seaBankNo: [{ required: true, message: '请输入银行卡号', trigger: 'blur' }],
				seaBankName: [{ required: true, message: '请输入开户行', trigger: 'blur' }]
			},
			selfButtonDisabled: false,
			selfButtonTourSteps: [
				{
					target: '#selfButton',
					content: '点击此按钮可以快速选择本公司作为供应商。再次点击可以取消选择。'
				}
			],
			tourCallBacks: {
				onFinish: () => {
					localStorage.setItem('second-inventory-tour', 'true');
				}
			},
			tourOptions: {
				labels: {
					buttonSkip: '跳过教程',
					buttonPrevious: '上一步',
					buttonNext: '下一步',
					buttonStop: '完成'
				}
			},
			transportError: false
		};
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('secondinventory-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		isLand(val) {
			if (val && this.transportError) {
				this.transportError = false;
			}
		},
		isSea(val) {
			if (val && this.transportError) {
				this.transportError = false;
			}
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('secondinventory-columns') === 'null' || !localStorage.getItem('secondinventory-columns')) {
			localStorage.setItem('secondinventory-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('secondinventory-columns'));
		}
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
		checkInvoInfo(row) {
			getDetail(row.storeID).then(res => {
				if (!res.data) {
					this.$message.error('该货物没有库存信息');
					return;
				}
				this.inventoryInfo = res.data;
				this.inventoryInfoVisible = true;
			});
		},
		secondInventory(row) {
			this.inventoryDetailList = [];
			this.resetSecond();
			// 填充仓库
			this.secondForm.storeHouseName = row.storeHouseName;
			getDetail(row.storeID).then(res => {
				if (!res.data) {
					this.$message.error('该货物没有库存信息');
					return;
				}
				const detailItem = {
					row: {
						supplier: res.data.supplier,
						supplierId: res.data.supplierId,
						levelName: res.data.levelName,
						levelID: res.data.levelID,
						height: res.data.height,
						length: res.data.length,
						width: res.data.width,
						erro: res.data.erro,
						tonnage: res.data.tonnage,
						price: row.inventoryDetail.price,
						pieces: row.outAmount,
						isEditing: true,
						hasError: false,
						countingUnit: '片',
						payments: '',
						manuallyEditedPieces: true, // 标记为已手动设置，避免被自动计算覆盖

						stockNumber: '',
						piecesPerPack: '',
						packs: '',
						isIncludeTaxFactory: res.data.isIncludeTaxFactory,
						sundryCost: '',
						paymentFactory: '',
						paymentUnload: res.data.paymentUnload,
						isIncludeTaxSale: res.data.isIncludeTaxSale,
						landFreightPrice: '',
						landFreight: '',
						seaFreight: '',
						freight: '',
						otherCost: '',
						profit: '',
						profitNoTax: '',
						actualPieces: res.data.actualPieces,
						paymentsWithSundry: res.data.paymentsWithSundry,
						additionalFees: '',
						factoryCommission: '',
						factoryRebateAmount: '',
						factoryDiscountAmount: '',
						comments: ''
					}
				};
				this.calculatePayment(detailItem);
				this.inventoryDetailList.push(detailItem.row);
				this.title = '二次入库';
				this.secondInventoryVisible = true;
				this.isEditingDetails = true;
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
		handleUpdateQuerySupplier(value) {
			this.querySupplier = value;
		},
		handleUpdateQueryNameLevel(value) {
			this.queryLevel = value;
		},
		handleCommitBackSupplier(scope, val) {
			this.clearDetail(scope);
			scope.row.supplier = val.companyName;
			scope.row.supplierId = val.id;
		},
		handleCommitBackProductLevel(scope, val) {
			scope.row.erro = val.tonnage;
			scope.row.levelID = val.id;
			scope.row.levelName = val.levelName;
			scope.row.height = val.height;
			scope.row.length = val.length;
			scope.row.width = val.width;
			scope.row.levelNo = val.levelNo;
		},
		recalculateAll(scope) {
			// 调用统一的库存计算函数
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		calculatePacks(scope) {
			// 计算出厂片数并更新
			scope.row.actualPieces = scope.row.pieces = scope.row.packs * scope.row.piecesPerPack;
			// 更新所有计算值
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		calculatePaymentFactory(scope) {
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		calculatePrice(scope) {
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		calculatePayment(scope) {
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		calculateLandFreight(scope) {
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		calculateFreight(scope) {
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		handleCommitBackFleet(val) {
			this.form.fleet = val.fname;
		},
		handleChangeFleet(val) {
			this.queryFleet = val;
		},
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
			scope.row.factoryCommission = '';
			scope.row.comments = '';
			scope.row.manuallyEditedPieces = false;
		},
		resetSeaCarInfo() {
			this.form.seaCarID = '';
			this.form.seaCarNo = '';
			this.form.seaDriverName = '';
			this.form.seaDriverTel = '';
		},
		resetLandCarInfo() {
			this.form.landCarID = '';
			this.form.landCarNo = '';
			this.form.landDriverName = '';
			this.form.landDriverTel = '';
		},
		rowInventoryDetailIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		handleAddInventoryDetail() {
			let obj = {
				stockNumber: '',
				supplier: '',
				supplierId: '',
				levelID: '',
				levelName: '',
				countingUnit: '片',
				height: '',
				length: '',
				width: '',
				pieces: '',
				piecesPerPack: '',
				packs: '',
				price: '',
				isIncludeTaxFactory: 0,
				sundryCost: '',
				paymentFactory: '',
				paymentUnload: '',
				isIncludeTaxSale: 0,
				payments: '',
				erro: '',
				tonnage: '',
				landFreightPrice: '',
				landFreight: '',
				seaFreight: '',
				freight: '',
				otherCost: '',
				profit: '',
				profitNoTax: '',
				actualPieces: '',
				paymentsWithSundry: '',
				additionalFees: '',
				factoryCommission: '',
				factoryRebateAmount: '',
				factoryDiscountAmount: '',
				comments: '',
				isEditing: true,
				hasError: false,
				manuallyEditedPieces: false
			};
			this.inventoryDetailList.push(obj);
			this.$nextTick(() => {
				if (this.$refs.inventoryDetail) {
					const bodyWrapper = this.$refs.inventoryDetail.$el.querySelector('.el-table__body-wrapper');
					if (bodyWrapper) {
						bodyWrapper.scrollTop = bodyWrapper.scrollHeight;
					}
				}
			});
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
			// 检查是否至少选择了一种运输方式
			if (!this.isLand && !this.isSea) {
				this.transportError = true;
				this.$message.error('请至少选择一种运输方式');
				return;
			}

			this.$refs['secondForm'].validate(valid => {
				if (valid) {
					if (this.inventoryDetailList.some(item => item.isEditing)) {
						this.$modal
							.confirm('有未保存的库存项，是否继续提交?')
							.then(() => {
								this.doSubmitSecond();
							})
							.catch(() => {});
					} else {
						this.doSubmitSecond();
					}
				} else {
					this.$message.error('请检查表单必填项!');
					return false;
				}
			});
		},
		doSubmitSecond() {
			this.secondForm.inventoryDetailList = JSON.parse(JSON.stringify(this.inventoryDetailList));
			this.secondForm.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight || 0), 0) : 0;
			this.secondForm.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight || 0), 0) : 0;
			const apiCall = this.secondForm.id ? updateInventoryMain : addInventoryMain;
			const successMessage = this.secondForm.id ? '修改成功' : '新增成功';
			apiCall(this.secondForm)
				.then(() => {
					this.$modal.msgSuccess(successMessage);
					this.secondInventoryVisible = false;
					this.getList();
					this.resetSecond();
				})
				.catch(error => {
					this.$message.error('提交失败: ' + (error.message || '未知错误'));
				});
		},
		resetSecond() {
			this.isSea = false;
			this.isLand = false;
			this.transportError = false; // 重置错误状态
			this.secondForm = {
				id: null,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: parseTime(new Date()),
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
			this.isEditingDetails = false;
			if (this.$refs.secondForm) {
				this.$refs.secondForm.resetFields();
			}
		},
		toggleEditDetails(editState) {
			this.isEditingDetails = editState;
			if (editState) {
				this.inventoryDetailList.forEach(row => {
					if (row.hasError) {
						this.$set(row, 'hasError', false);
					}
				});
				this.$message.info('已进入批量编辑模式，可以修改所有库存信息');
			} else {
				const rowsToSave = this.inventoryDetailList.filter(row => row.isEditing);
				if (rowsToSave.length > 0) {
					this.handleRowSave(rowsToSave);
				} else {
					this.$message.info('没有需要保存的更改。');
				}
			}
		},
		getRowClassName({ row }) {
			if (row.hasError) {
				return 'error-row';
			} else if (row.isEditing) {
				return 'editing-row';
			}
			return '';
		},
		handleRowEdit(row) {
			this.$set(row, 'isEditing', true);
			if (row.hasError) {
				this.$set(row, 'hasError', false);
			}
			this.$message.info('正在编辑该条记录');
		},
		handleRowSave(row) {
			const rows = Array.isArray(row) ? row : [row];
			rows.forEach(r => {
				if (r.isEditing) {
					this.recalculateAll({ row: r });
				}
			});
			const newInventoryInfo = {
				...this.secondForm,
				inventoryDetailList: JSON.parse(JSON.stringify(this.inventoryDetailList))
			};
			newInventoryInfo.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight || 0), 0) : 0;
			newInventoryInfo.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight || 0), 0) : 0;
			this.saveInventoryDetails(newInventoryInfo, rows);
		},
		saveInventoryDetails(newInventoryInfo, rows) {
			const currentRows = rows;
			const apiCall = newInventoryInfo.id ? updateInventoryMain : addInventoryMain;
			const successMessage = newInventoryInfo.id ? '库存详情已修改并保存!' : '库存详情已添加并保存!';
			const errorMessage = '保存失败，请重新编辑: ';
			apiCall(newInventoryInfo)
				.then(res => {
					currentRows.forEach(row => {
						this.$set(row, 'isEditing', false);
						if (row.hasError) {
							this.$set(row, 'hasError', false);
						}
					});
					this.$message.success(successMessage);
					if (!newInventoryInfo.id && res.data && res.data.id) {
						this.secondForm.id = res.data.id;
					}
				})
				.catch(error => {
					currentRows.forEach(row => {
						this.$set(row, 'isEditing', true);
						this.$set(row, 'hasError', true);
					});
					this.$message.error(errorMessage + (error.message || '未知错误'));
				});
		},
		updateActualPieces(scope) {
			scope.row.actualPieces = scope.row.stockNumber;
			this.recalculateAll(scope);
		},
		handlePiecesChange(scope, val) {
			scope.row.manuallyEditedPieces = true;
			// 使用统一计算函数
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		getList() {
			this.loading = true;
			listExWarehouse(this.queryParams).then(response => {
				this.exWarehouseList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		cancel() {
			this.open = false;
			this.reset();
		},
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
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*']
			});
		},
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加出库';
		},
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getExWarehouse(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改出库';
			});
		},
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
		handleExport() {
			this.download(
				'system/exWarehouse/export',
				{
					...this.queryParams
				},
				`exWarehouse_${new Date().getTime()}.xlsx`
			);
		},
		handleSelfButtonTour() {
			if (!localStorage.getItem('second-inventory-tour')) {
				this.$tours['selfButtonTour'].start();
			}
		}
	}
};
</script>

<style scoped>
::v-deep .editing-row {
	background-color: rgba(121, 246, 164, 0.1) !important;
}

::v-deep .editing-row td:first-child {
	border-left: 4px solid #63f697 !important;
}

::v-deep .editing-row:hover > td {
	background-color: rgba(121, 246, 164, 0.15) !important;
}

::v-deep .error-row {
	background-color: rgba(245, 108, 108, 0.1) !important;
}

::v-deep .error-row td:first-child {
	border-left: 4px solid #f56c6c !important;
}

::v-deep .error-row:hover > td {
	background-color: rgba(245, 108, 108, 0.15) !important;
}

@keyframes errorPulse {
	0% {
		background-color: rgba(245, 108, 108, 0.1);
	}
	50% {
		background-color: rgba(245, 108, 108, 0.2);
	}
	100% {
		background-color: rgba(245, 108, 108, 0.1);
	}
}

::v-deep .error-row td {
	animation: errorPulse 2s infinite;
}

::v-deep .error-row:hover td {
	animation: none;
	background-color: rgba(245, 108, 108, 0.15) !important;
}
</style>
