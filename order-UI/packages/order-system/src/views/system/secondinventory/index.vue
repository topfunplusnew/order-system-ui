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
			<el-table-column label="二次入库状态" align="center">
				<template slot-scope="scope">
					<el-tag v-if="scope.row.targetInventoryDetail && scope.row.targetInventoryDetail.id" type="success">已入库</el-tag>
					<el-tag v-else type="info">未入库</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[0].visible" label="仓库名称" align="center" prop="storeHouseName" />
			<!--      outDirection 出库方向 有可能是客户名称 有可能是破损出库 或者 二次加工-->
			<el-table-column v-if="columns[0].visible" label="出库方向" align="center" prop="outDirection" />
			<el-table-column v-if="columns[1].visible" label="出库日期" align="center" prop="outDate" />
			<el-table-column v-if="columns[2].visible" label="产品级别" align="center" prop="sourceInventoryDetail.levelName" />
			<el-table-column v-if="columns[3].visible" label="厚度" align="center" prop="sourceInventoryDetail.height" />
			<el-table-column v-if="columns[4].visible" label="长度" align="center" prop="sourceInventoryDetail.length" />
			<el-table-column v-if="columns[5].visible" label="宽度" align="center" prop="sourceInventoryDetail.width" />
			<el-table-column v-if="columns[6].visible" label="存货价" align="center" prop="sourceInventoryDetail.paymentUnload" />
			<el-table-column v-if="columns[7].visible" label="出库量" align="center" prop="outAmount" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="80">
				<template slot-scope="scope">
					<el-dropdown trigger="hover">
						<span class="el-dropdown-link">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</span>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item
								:disabled="scope.row.targetInventoryDetail && scope.row.targetInventoryDetail.id"
								v-hasPermi="['system:secondinventory:add']"
								@click.native="secondInventory(scope.row)"
							>
								二次入库
							</el-dropdown-item>
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
		<el-dialog :title="title" :visible.sync="secondInventoryVisible" width="1200px" append-to-body :close-on-click-modal="false" v-dialogDrag dialogDragWidth dialogDragHeight>
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
							<el-input size="mini" v-model="scope.row.actualPieces" placeholder="请输入二次入库片数" />
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
import _ from 'lodash';

export default {
	name: 'SecondInventory',
	computed: {
		/**
		 * @description: 使 PUBLIC_DICT_TYPE 可以在模板中使用
		 * @return {object} PUBLIC_DICT_TYPE 常量对象
		 */
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
		/**
		 * @description: 监听列配置的变化，并将其保存到 localStorage
		 * @param {Array} newVal 新的列配置
		 */
		columns: {
			handler: function (newVal) {
				localStorage.setItem('secondinventory-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		/**
		 * @description: 监听陆运选择状态，如果选择陆运且存在运输错误提示，则清除错误提示
		 * @param {boolean} val 陆运是否被选择
		 */
		isLand(val) {
			if (val && this.transportError) {
				this.transportError = false;
			}
		},
		/**
		 * @description: 监听海运选择状态，如果选择海运且存在运输错误提示，则清除错误提示
		 * @param {boolean} val 海运是否被选择
		 */
		isSea(val) {
			if (val && this.transportError) {
				this.transportError = false;
			}
		}
	},
	/**
	 * @description: Vue 组件创建时的钩子函数，用于获取列表数据和初始化列配置
	 */
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
		/**
		 * @description: 处理文件上传后的回调，更新表单中的收货凭证字段
		 * @param {string} val 上传组件返回的文件信息或路径
		 */
		handleCommitUpload(val) {
			this.secondForm.receiveProof = val;
		},
		/**
		 * @description: 查看指定出库记录的库存详细信息
		 * @param {object} row 当前行的数据对象，包含 storeID
		 */
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
		/**
		 * @description: 打开二次入库弹窗并填充初始数据
		 * @param {object} row 当前行的数据对象，包含出库信息和库存详情
		 */
		secondInventory(row) {
			this.inventoryDetailList = [];
			this.resetSecond();
			if (!row.sourceInventoryDetail) {
				this.$message.error('该行数据有误!');
				return;
			}
			// 填充来源仓库为本条出库信息的仓库
			this.secondForm.goodsCompany = row.storeHouseName;
			// 设置主表的出库ID信息
			this.secondForm.exWareHoustId = row.id;
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
						price: row.sourceInventoryDetail.price,
						pieces: row.outAmount,
						isEditing: true,
						hasError: false,
						countingUnit: '片',
						payments: '',
						manuallyEditedPieces: true, // 标记为已手动设置，避免被自动计算覆盖
						exWareHoustId: row.id, // 添加出库id
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
		/**
		 * @description: 计算表格的合计行数据
		 * @param {object} param Element UI 表格传递的参数，包含列配置和数据
		 * @return {Array} 计算得到的合计行数据数组
		 */
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
		/**
		 * @description: 更新供应商查询关键字
		 * @param {string} value 新的查询关键字
		 */
		handleUpdateQuerySupplier(value) {
			this.querySupplier = value;
		},
		/**
		 * @description: 更新产品级别查询关键字
		 * @param {string} value 新的查询关键字
		 */
		handleUpdateQueryNameLevel(value) {
			this.queryLevel = value;
		},
		/**
		 * @description: 处理供应商选择后的回调，更新行数据中的供应商信息
		 * @param {object} scope 当前行的作用域对象
		 * @param {object} val SearchOption 组件返回的选中供应商对象
		 */
		handleCommitBackSupplier(scope, val) {
			this.clearDetail(scope);
			scope.row.supplier = val.companyName;
			scope.row.supplierId = val.id;
		},
		/**
		 * @description: 处理产品级别选择后的回调，更新行数据中的产品级别相关信息
		 * @param {object} scope 当前行的作用域对象
		 * @param {object} val SearchOption 组件返回的选中产品级别对象
		 */
		handleCommitBackProductLevel(scope, val) {
			scope.row.erro = val.tonnage;
			scope.row.levelID = val.id;
			scope.row.levelName = val.levelName;
			scope.row.height = val.height;
			scope.row.length = val.length;
			scope.row.width = val.width;
			scope.row.levelNo = val.levelNo;
		},
		/**
		 * @description: 重新计算当前行库存详情的所有相关数值
		 * @param {object} scope 当前行的作用域对象
		 */
		recalculateAll(scope) {
			// 调用统一的库存计算函数
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		/**
		 * @description: 计算当前行库存详情的货款等相关数值 (目前与 recalculateAll 功能重复，可考虑合并)
		 * @param {object} scope 当前行的作用域对象
		 */
		calculatePayment(scope) {
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		/**
		 * @description: 处理车队选择后的回调，更新表单中的车队名称
		 * @param {object} val SearchOption 组件返回的选中车队对象
		 */
		handleCommitBackFleet(val) {
			this.secondForm.fleet = val.fname;
		},
		/**
		 * @description: 更新车队查询关键字
		 * @param {string} val 新的查询关键字
		 */
		handleChangeFleet(val) {
			this.queryFleet = val;
		},
		/**
		 * @description: 设置当前操作的类型 (例如：'supplier')，用于 SearchOption 组件
		 * @param {object} row 当前行的数据对象
		 * @param {string} type 操作类型
		 */
		setCurrentType(row, type) {
			row.currentType = type;
		},
		/**
		 * @description: 清空指定行库存详情的各项数据
		 * @param {object} scope 当前行的作用域对象
		 */
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
		/**
		 * @description: 重置二次入库表单的各项数据到初始状态
		 */
		// 添加重置二次入库表单的方法
		resetSecond() {
			this.isSea = false;
			this.isLand = false;
			this.transportError = false; // 重置错误状态
			this.selfButtonDisabled = false; // 重置本公司按钮状态
			this.secondForm = {
				id: null,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: parseTime(new Date()),
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				landBankName: null,
				landBankNo: null,
				fleet: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				seaBankName: null,
				seaBankNo: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				showFlag: null,
				exWareHoustId: null,
				goodsCompany: null,
				allLandFreight: null,
				allSeaFreight: null,
				receiveProof: null
			};
			this.inventoryDetailList = [];
			this.isEditingDetails = false;
			this.checkedInventoryDetail = [];
			if (this.$refs.secondForm) {
				this.$refs.secondForm.resetFields();
			}
		},
		/**
		 * @description: 获取表格行的类名，用于标记错误行或编辑中的行
		 * @param {object} param Element UI 表格传递的参数，包含当前行数据
		 * @return {string} 行的类名
		 */
		// 添加获取行类名的方法
		getRowClassName({ row }) {
			if (row.hasError) {
				return 'error-row';
			} else if (row.isEditing) {
				return 'editing-row';
			}
			return '';
		},
		/**
		 * @description: 添加一条新的库存详情记录到列表中
		 */
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
		/**
		 * @description: 处理库存详情表格的选择项变化事件
		 * @param {Array} selection 当前选中的行对象数组
		 */
		handleInventoryDetailSelectionChange(selection) {
			// 直接存储选中的行对象引用，而不是索引
			this.checkedInventoryDetail = selection;
		},
		/**
		 * @description: 删除选中的库存详情记录
		 */
		handleDeleteInventoryDetail() {
			if (this.checkedInventoryDetail.length === 0) {
				this.$modal.msgError('请先选择要删除的库存子数据');
			} else {
				// 使用对象引用进行过滤，保留未被选中的项
				this.inventoryDetailList = this.inventoryDetailList.filter(item => !this.checkedInventoryDetail.includes(item));

				// 清空选中项
				this.checkedInventoryDetail = [];

				// 清除表格的选中状态
				if (this.$refs.inventoryDetail) {
					this.$refs.inventoryDetail.clearSelection();
				}

				this.$message.success('删除成功');
			}
		},
		/**
		 * @description: 取消二次入库操作，关闭弹窗并重置表单
		 */
		cancelSecond() {
			this.secondInventoryVisible = false;
			this.resetSecond();
		},
		/**
		 * @description: 提交二次入库表单，进行数据校验和API调用
		 */
		submitSecond() {
			// 检查是否至少选择了一种运输方式
			if (!this.isLand && !this.isSea) {
				this.transportError = true;
				this.$message.error('请至少选择一种运输方式');
				return;
			}

			// 检查是否有库存详情数据
			if (this.inventoryDetailList.length === 0) {
				this.$message.error('请添加至少一条库存详情');
				return;
			}

			this.$refs['secondForm'].validate(valid => {
				if (valid) {
					// 检查是否有未保存的编辑项
					const hasEditingRows = this.inventoryDetailList.some(item => item.isEditing);
					if (hasEditingRows) {
						this.$modal
							.confirm('有未保存的库存项，是否先保存后再提交?')
							.then(() => {
								// 先保存所有编辑状态的行
								this.$modal.loading('正在保存...');
								this.handleRowSave(this.inventoryDetailList.filter(item => item.isEditing))
									.then(() => {
										this.$modal.closeLoading();
										// 保存成功后提交整个表单
										this.doSubmitSecond();
									})
									.catch(() => {
										this.$modal.closeLoading();
										// 保存失败时不提交表单，让用户修复错误
									});
							})
							.catch(() => {
								// 用户选择不先保存，直接提交
								this.doSubmitSecond();
							});
					} else {
						// 没有编辑状态的行，直接提交
						this.doSubmitSecond();
					}
				} else {
					this.$message.error('请检查表单必填项!');
					return false;
				}
			});
		},
		/**
		 * @description: 执行二次入库表单的实际提交操作
		 */
		doSubmitSecond() {
			// 最终检查所有行的数据有效性
			let hasInvalidRow = false;
			for (const row of this.inventoryDetailList) {
				const validationResult = this.validateInventoryRow(row);
				if (!validationResult.valid) {
					this.$set(row, 'hasError', true);
					this.$message.error(`行 "${row.levelName || '未命名'}" 验证失败: ${validationResult.message}`);
					hasInvalidRow = true;
					// 不立即返回，继续检查所有行以显示所有错误
				}
			}

			if (hasInvalidRow) {
				this.$message.error('请修正表单中的错误后再提交');
				return;
			}

			this.secondForm.inventoryDetailList = JSON.parse(JSON.stringify(this.inventoryDetailList));
			this.secondForm.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight || 0), 0) : 0;
			this.secondForm.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight || 0), 0) : 0;

			this.$modal.loading('正在提交...');
			const apiCall = this.secondForm.id ? updateInventoryMain : addInventoryMain;
			const successMessage = this.secondForm.id ? '修改成功' : '新增成功';

			apiCall(this.secondForm)
				.then(() => {
					this.$modal.closeLoading();
					this.$modal.msgSuccess(successMessage);
					this.secondInventoryVisible = false;
					this.getList();
					this.resetSecond();
				})
				.catch(error => {
					this.$modal.closeLoading();
					this.$message.error('提交失败: ' + (error.message || '未知错误'));
				});
		},
		/**
		 * @description: 处理库存详情表格中行的编辑操作，将行设置为编辑状态
		 * @param {object} row 当前行的数据对象
		 */
		handleRowEdit(row) {
			this.$set(row, 'isEditing', true);
			if (row.hasError) {
				this.$set(row, 'hasError', false);
			}
			this.$message.info('正在编辑该条记录');
		},
		/**
		 * @description: 校验单条库存详情行的数据有效性
		 * @param {object} row 当前行的数据对象
		 * @return {object} 校验结果，包含 valid (boolean) 和 message (string)
		 */
		validateInventoryRow(row) {
			if (!row.supplier) {
				return { valid: false, message: '供应商不能为空' };
			}
			if (!row.levelName) {
				return { valid: false, message: '级别名称不能为空' };
			}
			if (!row.height || !row.length || !row.width) {
				return { valid: false, message: '产品尺寸信息(长/宽/高)不完整，请选择正确的产品级别' };
			}
			if (!row.pieces || isNaN(Number(row.pieces)) || Number(row.pieces) <= 0) {
				return { valid: false, message: '出厂片数必须是有效的正数' };
			}
			if (!row.price || isNaN(Number(row.price)) || Number(row.price) < 0) {
				return { valid: false, message: '出厂单价必须是有效的非负数字' };
			}
			if (!row.paymentUnload || isNaN(Number(row.paymentUnload)) || Number(row.paymentUnload) < 0) {
				return { valid: false, message: '存货价必须是有效的非负数字' };
			}
			if (!row.actualPieces || isNaN(Number(row.actualPieces)) || Number(row.actualPieces) <= 0) {
				return { valid: false, message: '二次入库片数必须是有效的正数' };
			}
			if (this.isLand && row.landFreightPrice) {
				if (isNaN(Number(row.landFreightPrice)) || Number(row.landFreightPrice) < 0) {
					return { valid: false, message: '陆运费单价必须是有效的非负数字' };
				}
			}
			if (this.isSea && row.seaFreight) {
				if (isNaN(Number(row.seaFreight)) || Number(row.seaFreight) < 0) {
					return { valid: false, message: '海运费必须是有效的非负数字' };
				}
			}
			return { valid: true };
		},
		/**
		 * @description: 保存库存详情表格中正在编辑的行数据
		 * @param {object|Array} row 当前行的数据对象或包含多个行对象的数组
		 * @return {Promise} 一个 Promise 对象，在保存成功或失败时 resolve 或 reject
		 */
		handleRowSave(row) {
			return new Promise((resolve, reject) => {
				const rows = Array.isArray(row) ? row : [row];
				for (const r of rows) {
					if (!r.isEditing) continue;
					const validationResult = this.validateInventoryRow(r);
					if (!validationResult.valid) {
						this.$set(r, 'hasError', true);
						this.$message.error(`行 "${r.levelName || '未命名'}" 验证失败: ${validationResult.message}`);
						reject(new Error(validationResult.message));
						return;
					}
				}
				rows.forEach(r => {
					if (r.isEditing) {
						this.recalculateAll({ row: r });
					}
				});
				const newInventoryInfo = {
					...this.secondForm,
					inventoryDetailList: _.cloneDeep(this.inventoryDetailList)
				};
				newInventoryInfo.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight || 0), 0) : 0;
				newInventoryInfo.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight || 0), 0) : 0;
				this.saveInventoryDetails(newInventoryInfo, rows, resolve, reject);
			});
		},
		/**
		 * @description: 保存库存详情数据到后端
		 * @param {object} newInventoryInfo 包含主表单和库存详情列表的对象
		 * @param {Array} rows 当前操作的行对象数组
		 * @param {Function} resolve Promise 的 resolve 函数
		 * @param {Function} reject Promise 的 reject 函数
		 */
		saveInventoryDetails(newInventoryInfo, rows, resolve, reject) {
			const currentRows = rows;
			// 检查是否已有ID来决定是新增还是修改
			const apiCall = newInventoryInfo.id ? updateInventoryMain : addInventoryMain;
			const successMessage = newInventoryInfo.id ? '库存详情已修改并保存!' : '库存详情已添加并保存!';

			this.$modal.loading('正在保存...');
			apiCall(newInventoryInfo)
				.then(res => {
					this.$modal.closeLoading();
					currentRows.forEach(row => {
						this.$set(row, 'isEditing', false);
						if (row.hasError) {
							this.$set(row, 'hasError', false);
						}
					});
					// 如果是新增，保存返回的ID到表单中，确保后续操作为修改
					if (!newInventoryInfo.id && res.data && res.data.id) {
						this.secondForm.id = res.data.id;
						// 更新所有明细项的主表ID关联
						this.inventoryDetailList.forEach(item => {
							item.inventoryId = res.data.id;
						});
						this.$message.success(successMessage);
					}
					resolve && resolve(res);
				})
				.catch(error => {
					this.$modal.closeLoading();
					currentRows.forEach(row => {
						this.$set(row, 'isEditing', true);
						this.$set(row, 'hasError', true);
					});
					const errorMsg = error.message || '未知错误';
					this.$message.error(`保存失败，请重新编辑: ${errorMsg}`);
					reject && reject(error);
				});
		},
		/**
		 * @description: 切换库存详情的批量编辑状态或保存所有编辑中的项
		 * @param {boolean} editState true 表示进入编辑模式，false 表示保存并退出编辑模式
		 */
		toggleEditDetails(editState) {
			if (editState) {
				this.isEditingDetails = true;
				this.inventoryDetailList.forEach(row => {
					if (row.hasError) {
						this.$set(row, 'hasError', false);
					}
				});
				this.$message.info('已进入批量编辑模式，可以修改所有库存信息');
			} else {
				const rowsToSave = this.inventoryDetailList.filter(row => row.isEditing);
				if (rowsToSave.length > 0) {
					this.$modal.loading('正在保存...');
					this.handleRowSave(rowsToSave)
						.then(() => {
							this.$modal.closeLoading();
							this.$message.success('所有修改已保存');
							this.isEditingDetails = false;
						})
						.catch(() => {
							this.$modal.closeLoading();
							this.isEditingDetails = true;
						});
				} else {
					this.isEditingDetails = false;
					this.$message.info('没有需要保存的更改。');
				}
			}
		},
		/**
		 * @description: 更新实际入库片数 (通常由库存编号变化触发，目前未使用)
		 * @param {object} scope 当前行的作用域对象
		 */
		updateActualPieces(scope) {
			scope.row.actualPieces = scope.row.stockNumber;
			this.recalculateAll(scope);
		},
		/**
		 * @description: 处理出厂片数输入变化事件，标记为手动编辑并重新计算
		 * @param {object} scope 当前行的作用域对象
		 * @param {string|number} val 输入的出厂片数值
		 */
		handlePiecesChange(scope, val) {
			scope.row.manuallyEditedPieces = true;
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
		},
		/**
		 * @description: 获取出库列表数据
		 */
		getList() {
			this.loading = true;
			listExWarehouse(this.queryParams).then(response => {
				this.exWarehouseList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		/**
		 * @description: 取消添加或修改出库操作，关闭弹窗并重置表单
		 */
		cancel() {
			this.open = false;
			this.reset();
		},
		/**
		 * @description: 重置添加/修改出库表单的各项数据到初始状态
		 */
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
		/**
		 * @description: 处理搜索操作，重新获取列表数据
		 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/**
		 * @description: 重置搜索表单并重新获取列表数据
		 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		/**
		 * @description: 处理表格选择项变化事件 (主出库列表)
		 * @param {Array} selection 当前选中的行对象数组
		 */
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/**
		 * @description: 打印当前表格内容
		 */
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*']
			});
		},
		/**
		 * @description: 打开添加出库对话框
		 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加出库';
		},
		/**
		 * @description: 打开修改出库对话框并加载数据
		 * @param {object} row 当前行的数据对象
		 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getExWarehouse(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改出库';
			});
		},
		/**
		 * @description: 提交添加或修改出库表单
		 */
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
		/**
		 * @description: 删除指定的出库记录
		 * @param {object} row 当前行的数据对象 (如果从行操作触发)
		 */
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
		/**
		 * @description: 导出出库列表数据为 Excel 文件
		 */
		handleExport() {
			this.download(
				'system/exWarehouse/export',
				{
					...this.queryParams
				},
				`exWarehouse_${new Date().getTime()}.xlsx`
			);
		},
		/**
		 * @description: 处理“本公司”按钮的引导提示
		 */
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

/* 添加滚动条样式 */
::v-deep .el-table__body-wrapper::-webkit-scrollbar {
	width: 14px;
	height: 14px;
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar-thumb {
	border-radius: 2px;
	background-color: rgba(0, 0, 0, 0.5);
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar-track {
	border-radius: 2px;
	background-color: rgba(0, 0, 0, 0.1);
}
</style>
