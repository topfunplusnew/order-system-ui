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
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:secondinventory:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
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
			<el-table-column v-if="columns[1].visible" label="出库方向" align="center" prop="outDirection">
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
			<el-table-column v-if="columns[2].visible" label="变动日期(出库)" align="center" prop="outDate">
				<template #default="scope">
					{{ parseTime(scope.row.outDate, '{y}-{m}-{d}') }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="产品级别" align="center" prop="sourceInventoryDetail.levelName" />
			<el-table-column v-if="columns[4].visible" label="厚度" align="center" prop="sourceInventoryDetail.height" />
			<el-table-column v-if="columns[5].visible" label="长度" align="center" prop="sourceInventoryDetail.length" />
			<el-table-column v-if="columns[6].visible" label="宽度" align="center" prop="sourceInventoryDetail.width" />
			<el-table-column v-if="columns[7].visible" label="存货价" align="center" prop="sourceInventoryDetail.paymentUnload" />
			<el-table-column v-if="columns[8].visible" label="出库量" align="center" prop="outAmount" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180" fixed="right">
				<template slot-scope="scope">
					<el-button size="mini" type="text" icon="el-icon-edit" @click="handleModifySecondStorage(scope.row)" v-hasPermi="['system:secondinventory:edit']">修改</el-button>
					<el-dropdown trigger="hover">
						<span class="el-dropdown-link">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</span>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item :disabled="scope.row.targetInventoryDetail && scope.row.targetInventoryDetail.id != null" v-hasPermi="['system:secondinventory:add']" @click.native="secondInventory(scope.row)">二次入库</el-dropdown-item>
							<el-dropdown-item v-hasPermi="['system:secondinventory:remove']" @click.native="handleDelete(scope.row)">删除</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="secondInventoryVisible" width="100%" append-to-body :close-on-click-modal="false">
			<el-form ref="secondForm" :model="secondForm" :rules="secondRules" label-width="100px" :inline="true">
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
					<UploadFilesButton ref="attachmentUploader" :table-name="'secondinventory'" :record-id="secondForm.id" :attachment-type="'附件'" :initial-attachments="(secondForm.params && secondForm.params.attachments) || []" @files-updated="handleAttachmentFilesUpdated" />
				</el-form-item>
				<br />
				<el-form-item label="运输方式" required>
					<el-checkbox v-model="isLand" @change="updateTransportMode">陆运</el-checkbox>
					<el-checkbox v-model="isSea" @change="updateTransportMode">海运</el-checkbox>
					<div v-if="transportError" class="el-form-item__error">请至少选择一种运输方式</div>
				</el-form-item>
				<el-row v-if="isLand" style="margin: 20px 0">
					<el-form-item label="车牌" prop="landCarNo">
						<el-row>
							<el-col :span="20">
								<el-input disabled v-model="secondForm.landCarNo" type="text" size="mini" placeholder="请输入陆运车牌" style="width: 120px" />
							</el-col>
							<el-col :span="4">
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
				</el-row>
				<el-row v-if="isSea" style="margin: 10px 0">
					<el-form-item label="柜号" prop="seaCarNo">
						<el-row>
							<el-col :span="20">
								<el-input v-model="secondForm.seaCarNo" type="text" size="mini" placeholder="请输入柜号" style="width: 120px" />
							</el-col>
							<el-col :span="4">
								<SearchOption :limit-info="{ carType: '海运' }" :get-data="listCars" query-label="车牌" query-info="carNo" :query-name="querySeaCars" @commitBack="handleCommitBackSeaCar" @update:queryName="handleChangeSeaCar">
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
						<el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddInventoryDetail">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteInventoryDetail" :disabled="checkedInventoryDetail.length === 0">删除</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button size="mini" type="warning" @click="toggleEditDetails(true)" :disabled="!hasInventoryDetails || hasEditingRows">编辑子项</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button size="mini" type="success" @click="toggleEditDetails(false)" :disabled="!hasEditingRows">全部保存</el-button>
					</el-col>
				</el-row>

				<el-table border size="mini" :data="visibleInventoryDetailList" :row-class-name="getRowClassName" @selection-change="handleInventoryDetailSelectionChange" ref="inventoryDetail">
					<el-table-column type="selection" width="30" align="center" :selectable="() => true" fixed="left" />
					<el-table-column label="序号" align="center" type="index" width="60" fixed="left" />
					<el-table-column label="行操作" align="center" width="200">
						<template slot-scope="scope">
							<div>
								<el-button v-if="!scope.row.isEditing" size="mini" type="warning" icon="el-icon-edit" @click="handleRowEdit(scope.row)">编辑</el-button>
								<el-button v-else size="mini" type="success" icon="el-icon-check" @click="handleRowSave(scope.row)">保存</el-button>
								<el-button :disabled="scope.row.isEditing" size="mini" type="danger" icon="el-icon-document-copy" @click="handleCopyRow(scope.row)">复制</el-button>
							</div>
						</template>
					</el-table-column>
					<el-table-column label="供应商" width="170">
						<template #default="scope">
							<el-row>
								<el-col :span="14">
									<el-input size="mini" v-model="scope.row.supplier" placeholder="请输入供应商" :disabled="scope.row.shouldDel || !scope.row.isEditing || scope.row.selfButtonDisabled" />
								</el-col>
								<el-col :span="5">
									<el-button
										id="selfButton"
										:type="scope.row.selfButtonDisabled ? 'danger' : 'success'"
										size="mini"
										icon="el-icon-school"
										:disabled="scope.row.shouldDel || !scope.row.isEditing"
										@click="
											() => {
												if (!scope.row.selfButtonDisabled && !scope.row.shouldDel && scope.row.isEditing) {
													scope.row.supplier = PUBLIC_DICT_TYPE.SELF_COMPANY;
													scope.row.supplierId = 0;
													scope.row.selfButtonDisabled = true;
												} else if (scope.row.selfButtonDisabled && !scope.row.shouldDel && scope.row.isEditing) {
													scope.row.supplier = '';
													scope.row.supplierId = '';
													scope.row.selfButtonDisabled = false;
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
										:disable="scope.row.shouldDel || !scope.row.isEditing || scope.row.selfButtonDisabled"
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
								<el-input size="mini" v-model="scope.row.levelName" placeholder="请输入级别名称" :disabled="scope.row.shouldDel || !scope.row.isEditing" />
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
									:disable="scope.row.shouldDel || !scope.row.isEditing"
								>
									<template #table-columns>
										<el-table-column label="级别编码" align="center" prop="levelNo" width="220" />
										<el-table-column label="级别名称" align="center" prop="levelName" width="220" />
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
					<el-table-column label="计量单位" prop="countingUnit" width="92" class-name="counting-unit-column">
						<template #default="scope">
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="scope.row.shouldDel || !scope.row.isEditing" @change="() => recalculateAll(scope)" class="horizontal-radio-group">
								<el-radio label="片" class="horizontal-radio">片数</el-radio>
								<el-radio label="其他" class="horizontal-radio">其他</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="厚度" prop="height" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.height" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="长度" prop="length" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.length" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="宽度" prop="width" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.width" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="每包片数" prop="piecesPerPack" width="80">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.piecesPerPack" @input="val => handlePiecesInput(scope.row, 'piecesPerPack', val, () => recalculateAll(scope))" placeholder="请输入每包片数" :disabled="scope.row.shouldDel || !scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="60">
						<template #default="scope">
							<el-input
								size="mini"
								@input="val => handlePiecesInput(scope.row, 'packs', val, () => recalculateAll(scope))"
								v-model="scope.row.packs"
								:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
								:disabled="scope.row.shouldDel || !scope.row.isEditing || scope.row.piecesPerPack <= 0"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂片数" prop="pieces" width="80">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.pieces" @input="val => handlePiecesInput(scope.row, 'pieces', val, val => handlePiecesChange(scope, val))" placeholder="请输入出厂片数" :disabled="scope.row.shouldDel || !scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="出厂单价" prop="price" width="80">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.price"
								@input="val => handlePriceInput(scope.row, 'price', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'price')"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="scope.row.shouldDel || !scope.row.isEditing || scope.row.pieces <= 0"
								@blur="() => formatPriceInput(scope.row, 'price', 4, false)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="含税" prop="isIncludeTaxFactory" width="80" class-name="tax-column">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateAll(scope)" :disabled="scope.row.shouldDel || !scope.row.isEditing" class="horizontal-tax-radio-group">
								<el-radio :label="1" class="horizontal-tax-radio">是</el-radio>
								<el-radio :label="0" class="horizontal-tax-radio">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="100">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.sundryCost"
								@input="val => handlePriceInput(scope.row, 'sundryCost', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'sundryCost')"
								:placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'"
								:disabled="scope.row.shouldDel || !scope.row.isEditing || scope.row.price <= 0"
								@blur="() => formatPriceInput(scope.row, 'sundryCost', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.paymentFactory" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="二次入库片数" prop="stockNumber" width="90">
						<template #default="scope">
							<el-input size="mini" @input="val => handlePiecesInput(scope.row, 'stockNumber', val, () => recalculateAll(scope))" @change="() => handlePiecesChange(scope)" v-model="scope.row.stockNumber" placeholder="请输入二次入库片数" :disabled="scope.row.shouldDel" />
						</template>
					</el-table-column>
					<el-table-column label="存货价" prop="paymentUnload" width="100">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.paymentUnload"
								placeholder="请输入存货价"
								@input="val => handlePriceInput(scope.row, 'paymentUnload', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'paymentUnload')"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'paymentUnload', 4, false)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="含税" prop="isIncludeTaxSale" width="60" class-name="tax-column">
						<template #default="scope">
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateAll(scope)" :disabled="scope.row.shouldDel || !scope.row.isEditing" class="horizontal-tax-radio-group">
								<el-radio :label="1" class="horizontal-tax-radio">是</el-radio>
								<el-radio :label="0" class="horizontal-tax-radio">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="库存金额" prop="payments" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.payments" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="误差" prop="erro" width="60">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" disabled />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="100">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.tonnage" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="陆运费单价" prop="landFreightPrice" width="150" v-if="isLand">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.landFreightPrice"
								@input="val => handlePriceInput(scope.row, 'landFreightPrice', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'landFreightPrice')"
								placeholder="请输入陆运费单价"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'landFreightPrice', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="60">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="val => handlePriceInput(scope.row, 'additionalFees', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'additionalFees')"
								:placeholder="scope.row.landFreightPrice <= 0 ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'additionalFees', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="100" v-if="isLand">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.landFreight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="100" v-if="isSea">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.seaFreight"
								@input="val => handlePriceInput(scope.row, 'seaFreight', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'seaFreight')"
								placeholder="请输入海运费"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'seaFreight', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="总运费" prop="freight" width="100">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="100">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.otherCost"
								placeholder="请输入其他费用"
								@input="val => handlePriceInput(scope.row, 'otherCost', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'otherCost')"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'otherCost', 2)"
							/>
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
					<el-table-column label="物流利润" prop="logisticsProfit" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.logisticsProfit"
								@input="val => handlePriceInput(scope.row, 'logisticsProfit', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'logisticsProfit')"
								placeholder="请输入物流利润"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'logisticsProfit', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="厂家佣金" prop="factoryCommission" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryCommission"
								@input="val => handlePriceInput(scope.row, 'factoryCommission', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'factoryCommission')"
								placeholder="请输入厂家佣金"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'factoryCommission', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryRebateAmount"
								@input="val => handlePriceInput(scope.row, 'factoryRebateAmount', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'factoryRebateAmount')"
								placeholder="请输入计提厂家返利金额"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'factoryRebateAmount', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryDiscountAmount"
								@input="val => handlePriceInput(scope.row, 'factoryDiscountAmount', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'factoryDiscountAmount')"
								placeholder="请输入计提厂家降价金额"
								:disabled="scope.row.shouldDel || !scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'factoryDiscountAmount', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="备注" prop="comments" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" :disabled="scope.row.shouldDel || !scope.row.isEditing" />
						</template>
					</el-table-column>
				</el-table>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitSecond">确认提交</el-button>
				<el-button @click="cancelSecond">取消</el-button>
			</div>
		</el-dialog>

		<v-tour name="selfButtonTour" :steps="selfButtonTourSteps" :options="tourOptions" :callbacks="tourCallBacks"></v-tour>
	</div>
</template>

<script>
import { addExWarehouse, delExWarehouse, getExWarehouse, listExWarehouse, updateExWarehouse } from '@/api/system/exWarehouse';
import { excludeParams } from '@/api/tool/exclude';
import { getDetail, getInventoryMainByDetailId } from '../../../api/system/detail';
import { listStoreHouse } from '../../../api/system/StoreHouse';
import { listCars } from '../../../api/system/cars';
import { listFleet } from '../../../api/system/fleet';
import { listCompany } from '../../../api/system/company';
import { listProductLevel } from '../../../api/system/productLevel';
import { fix } from '../../../api/tool/format';
import SearchOption from '../../../components/SearchOption.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { _fill } from './fill';
import { updateInventoryMain, addInventoryMain, getInventoryMain } from '../../../api/system/inventoryMain';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
// 导入库存计算工具函数
import { updateInventoryRowCalculations } from '../inventoryMain/inventoryCalculations';
import { parseTime } from '@/utils/ruoyi';
import _ from 'lodash';
import {
	handlePriceInput as utilHandlePriceInput,
	formatPriceInput as utilFormatPriceInput,
	handlePriceFocus as utilHandlePriceFocus,
	parseInputValue,
	formatValueForDisplay,
	getDecimalPlaces,
	handlePiecesInput as utilHandlePiecesInput,
	getRowClassName as utilGetRowClassName,
	initSpecialFieldDecimalPlaces
} from '@/utils/order';

export default {
	name: 'SecondInventory',
	computed: {
		/**
		 * @description: 使 PUBLIC_DICT_TYPE 可以在模板中使用
		 * @return {object} PUBLIC_DICT_TYPE 常量对象
		 */
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		// 添加计算属性检查是否有子项（排除已删除的行）
		hasInventoryDetails() {
			return this.visibleInventoryDetailList && this.visibleInventoryDetailList.length > 0;
		},
		// 检查是否有任何行正在编辑（排除已删除的行）
		hasEditingRows() {
			return this.visibleInventoryDetailList && this.visibleInventoryDetailList.some(row => row.isEditing);
		},
		// 过滤掉已删除的行，用于表格显示
		visibleInventoryDetailList() {
			return this.inventoryDetailList.filter(row => !row.isDeleted);
		},
		// 获取所有已标记删除的行
		deletedInventoryDetailList() {
			return this.inventoryDetailList.filter(row => row.isDeleted === true);
		}
	},
	components: { SearchOption, UploadFilesButton },
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
				pageSize: 20,
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
				{ key: 1, label: `出库方向`, visible: true },
				{ key: 2, label: `出库日期`, visible: true },
				{ key: 3, label: `产品级别`, visible: true },
				{ key: 4, label: `厚度`, visible: true },
				{ key: 5, label: `长度`, visible: true },
				{ key: 6, label: `宽度`, visible: true },
				{ key: 7, label: `存货价`, visible: true },
				{ key: 8, label: `出库量`, visible: true }
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
			isEditingDetails: false,
			isSecondaryStorage: false, // 二次入库模式标识
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
				fleet: [{ validator: validateFleet, trigger: 'change' }],
				landCarNo: [{ validator: validateLandCarNo, trigger: 'change' }],
				seaCarNo: [{ validator: validateSeaCarNo, trigger: 'blur' }],
				seaDriverName: [{ validator: validateSeaDriverName, trigger: 'change' }],
				seaDriverTel: [{ required: true, message: '请输入司机电话', trigger: 'blur' }],
				seaBankNo: [{ required: true, message: '请输入银行卡号', trigger: 'blur' }],
				seaBankName: [{ required: true, message: '请输入开户行', trigger: 'blur' }]
			},
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
		// 附件更新处理
		handleAttachmentFilesUpdated(uploadParams) {
			// uploadParams 结构: { params: { attachmentIds: [1, 2, 3] } }
			if (!this.secondForm.params) {
				this.$set(this.secondForm, 'params', {});
			}

			// 直接设置 attachmentIds
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				this.$set(this.secondForm.params, 'attachmentIds', uploadParams.params.attachmentIds);
			} else {
				this.$set(this.secondForm.params, 'attachmentIds', []);
			}
		},
		/**
		 * @description: 处理文件上传后的回调，更新表单中的收货凭证字段
		 * @param {string} val 上传组件返回的文件信息或路径
		 */
		handleCommitUpload(val) {
			this.secondForm.receiveProof = val;
		},
		/**
		 * @description: 更新运输方式选择状态
		 *              根据 isLand 和 isSea 的状态更新错误状态，用于表单校验
		 *              在下一个 tick 中触发表单字段的校验
		 */
		updateTransportMode() {
			if (this.isLand || this.isSea) {
				this.transportError = false;
			}
			this.$nextTick(() => {
				// 可以在这里触发相关字段的校验
				if (this.$refs.secondForm) {
					this.$refs.secondForm.validateField('fleet');
					this.$refs.secondForm.validateField('landCarNo');
					this.$refs.secondForm.validateField('seaCarNo');
					this.$refs.secondForm.validateField('seaDriverName');
				}
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
						// 添加唯一索引
						index: 1,
						supplier: PUBLIC_DICT_TYPE.SELF_COMPANY,
						supplierId: res.data.supplierId,
						levelName: res.data.levelName,
						levelID: res.data.levelID,
						height: res.data.height,
						length: res.data.length,
						width: res.data.width,
						erro: res.data.erro,
						tonnage: res.data.tonnage,
						price: res.data.paymentUnload,
						pieces: row.outAmount,
						isEditing: true,
						hasError: false,
						countingUnit: '片',
						payments: '',
						manuallyEditedPieces: true, // 标记为已手动设置，避免被自动计算覆盖
						stockNumber: 0,
						piecesPerPack: '',
						packs: '',
						isIncludeTaxFactory: res.data.isIncludeTaxFactory,
						sundryCost: '',
						paymentFactory: '',
						isIncludeTaxSale: res.data.isIncludeTaxSale,
						landFreightPrice: '',
						landFreight: '',
						seaFreight: '',
						freight: '',
						otherCost: '',
						profit: '',
						profitNoTax: '',
						// 二次入库的原货物的二次入库片数为0,存货价为0
						paymentUnload: 0,
						paymentsWithSundry: res.data.paymentsWithSundry,
						additionalFees: '',
						factoryCommission: '',
						factoryRebateAmount: '',
						factoryDiscountAmount: '',
						comments: '',
						// 后续根据这个字段 把这条信息删除 不需要添加到数据库 也可以根据这个字段禁用不让用户输入
						shouldDel: true,
						selfButtonDisabled: true,
						isDeleted: false, // 新添加的行未删除
						isAdd: false // 参考行标记为非新增
					}
				};
				// 初始化特殊字段的小数位数
				initSpecialFieldDecimalPlaces(detailItem.row);
				this.calculatePayment(detailItem);
				this.inventoryDetailList.push(detailItem.row);
				this.title = '二次入库';
				this.secondInventoryVisible = true;
				this.isEditingDetails = true;
			});
		},
		/**
		 * @description: 处理修改按钮操作，用于修改二次入库信息
		 *              根据当前行的targetInventoryDetail中的ID，调用API获取完整的库存信息
		 *              成功后，填充表单并打开弹窗，第一行数据设置为只读状态
		 * @param {object} row - 当前操作的行数据对象
		 */
		handleModifySecondStorage(row) {
			if (!row.targetInventoryDetail || !row.targetInventoryDetail.id) {
				this.$modal.msgError('该记录没有二次入库信息，无法进行修改');
				return;
			}

			// 获取目标库存详情的ID（二次入库后的库存信息）
			const targetDetailId = row.targetInventoryDetail.id;

			// 先获取原始库存信息，再获取二次入库信息
			getDetail(row.storeID)
				.then(originalRes => {
					if (!originalRes.data) {
						this.$message.error('无法获取原始库存信息');
						return;
					}

					const originalData = originalRes.data;

					getInventoryMainByDetailId(targetDetailId)
						.then(response => {
							this.resetSecond();
							this.isSecondaryStorage = true; // 标记为二次入库模式

							const data = response.data;
							// 填充主表单信息
							this.secondForm = { ...data };
							this.secondForm.exWareHoustId = row.id; // 设置出库ID

							// 设置运输方式状态
							this.isSea = data.seaCarNo != null;
							this.isLand = data.landCarNo != null;

							// 处理库存详情列表
							this.inventoryDetailList = [];

							// 第一行：显示原始库存信息作为参考（只读）
							const referenceItem = {
								...row.sourceInventoryDetail,
								index: 1, // 设置唯一索引
								supplier: '己方公司',
								pieces: row.outAmount, // 显示出库数量
								stockNumber: 0,
								isEditing: false,
								hasError: false,
								isReadOnly: true,
								shouldDel: true, // 保存时过滤掉
								selfButtonDisabled: true,
								// 出厂是否含税使用原始库存信息的isIncludeTaxSale字段
								isIncludeTaxFactory: originalData.isIncludeTaxSale,
								// 库存是否含税默认为否
								isIncludeTaxSale: 0,
								isDeleted: false, // 确保 isDeleted 字段存在
								isAdd: false // 从后端加载的数据标记为非新增
							};
							this.inventoryDetailList.push(referenceItem);

							// 后续行：显示实际的二次入库信息（可编辑）
							if (data.inventoryDetailList && data.inventoryDetailList.length > 0) {
								const editableItems = data.inventoryDetailList.map((item, index) => {
									const processedItem = {
										...item,
										index: index + 2, // 设置唯一索引（从2开始，因为第一行是参考行）
										isEditing: false,
										hasError: false,
										isReadOnly: false,
										shouldDel: false,
										isDeleted: item.isDeleted !== undefined ? item.isDeleted : false, // 确保 isDeleted 字段存在
										isAdd: false // 从后端加载的数据标记为非新增
									};
									// 初始化特殊字段的小数位数
									initSpecialFieldDecimalPlaces(processedItem);
									return processedItem;
								});
								this.inventoryDetailList.push(...editableItems);

								// 对可编辑行进行初始计算
								editableItems.forEach(item => {
									this.$nextTick(() => {
										updateInventoryRowCalculations(item, this.isSea, this.isLand, { isSecondInventory: true });
									});
								});
							}

							this.secondInventoryVisible = true;
							this.title = '修改二次入库';
							this.isEditingDetails = false;
						})
						.catch(error => {
							console.error('获取库存详情失败:', error);
							this.$modal.msgError('获取库存详情失败，请重试');
						});
				})
				.catch(error => {
					console.error('获取原始库存信息失败:', error);
					this.$modal.msgError('获取原始库存信息失败，请重试');
				});
		},
		/**
		 * @description: 检查库存明细是否为空（所有业务字段都为空）
		 * @param {Object} inventoryDetail - 库存明细对象
		 * @returns {boolean} - 如果所有业务字段都为空则返回true，否则返回false
		 */
		isInventoryDetailEmpty(inventoryDetail) {
			if (!inventoryDetail) return true;

			// 定义需要检查的核心业务字段（排除有默认值或系统自动填充的字段）
			const businessFields = [
				'supplier',
				'levelName',
				'height',
				'length',
				'width',
				'piecesPerPack',
				'packs',
				'pieces',
				'price',
				'sundryCost',
				'stockNumber',
				'paymentUnload',
				'paymentsWithSundry',
				'erro',
				'landFreightPrice',
				'additionalFees',
				'seaFreight',
				'otherCost',
				'logisticsProfit',
				'factoryCommission',
				'factoryRebateAmount',
				'factoryDiscountAmount',
				'comments'
			];

			// 检查每个业务字段是否都为空
			return businessFields.every(field => {
				const value = inventoryDetail[field];
				// 检查是否为空值：null、undefined、空字符串、或只包含空白字符的字符串
				return value === null || value === undefined || value === '' || (typeof value === 'string' && value.trim() === '') || (typeof value === 'number' && value === 0);
			});
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
			// 对于二次入库的时候 需要特殊处理 含税金额需要再减去一个其他费用，放在额外对象中
			const extraOptions = {
				isSecondInventory: true
			};
			// 调用统一的库存计算函数
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand, extraOptions);
		},
		/**
		 * @description: 计算当前行库存详情的货款等相关数值 (目前与 recalculateAll 功能重复，可考虑合并)
		 * @param {object} scope 当前行的作用域对象
		 */
		calculatePayment(scope) {
			// 对于二次入库的时候 需要特殊处理 含税金额需要再减去一个其他费用，放在额外对象中
			const extraOptions = {
				isSecondInventory: true
			};
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand, extraOptions);
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
			scope.row.stockNumber = '';
			scope.row.paymentsWithSundry = '';
			scope.row.additionalFees = '';
			scope.row.rebate = '';
			scope.row.factoryCommission = '';
			scope.row.comments = '';
			scope.row.exWareHoustId = '';
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
		getRowClassName(param) {
			return utilGetRowClassName(param);
		},
		/** 添加新的库存详情行 */
		handleAddInventoryDetail() {
			const arrMaxItem = _.maxBy(this.orderDetailList, 'index');
			let obj = {
				// 添加唯一索引
				index: arrMaxItem ? arrMaxItem.index + 1 : 1,
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
				paymentsWithSundry: '',
				additionalFees: '',
				factoryCommission: '',
				factoryRebateAmount: '',
				factoryDiscountAmount: '',
				comments: '',
				isEditing: true, // 默认处于编辑状态
				isDeleted: false, // 新添加的行未删除
				isAdd: true, // 标记为新增行
				hasError: false,
				manuallyEditedPieces: false,
				selfButtonDisabled: false
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
		 * 复制指定行数据并在末尾添加
		 * @param {Object} row - 要复制的行数据
		 */
		handleCopyRow(row) {
			// 深拷贝行数据
			const copiedRow = _.cloneDeep(row);
			// 清除 id，因为这是新行
			copiedRow.id = undefined;
			// 设置新的索引
			copiedRow.index = _.maxBy(this.inventoryDetailList, 'index')?.index + 1;
			// 设置为编辑状态
			copiedRow.isEditing = true;
			// 标记为新增行
			copiedRow.isAdd = true;
			// 清除删除标记
			copiedRow.isDeleted = false;
			// 清除错误标记
			copiedRow.hasError = false;
			// 添加到列表末尾
			this.inventoryDetailList.push(copiedRow);
			this.$message.success('已复制该行数据');
			// 滚动到底部显示新添加的行
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
		 * @description: 处理库存详情表格选择项变化事件
		 * @param {Array} selection - 当前选中的行数据数组
		 */
		handleInventoryDetailSelectionChange(selection) {
			console.log(selection);
			// 存储选中行的唯一标识：优先使用 id，如果没有 id 则使用对象引用
			// 注意：id 可能是 0，所以不能用简单的 item.id || item 判断
			this.checkedInventoryDetail = selection.map(item => {
				// 如果 id 存在且不为 null/undefined，使用 id；否则使用对象引用
				return item.id !== undefined && item.id !== null ? item.id : item;
			});
			console.log(`selection identifiers`, this.checkedInventoryDetail);
		},
		/** 删除选中的库存详情行（标记为已删除，不真正删除） */
		handleDeleteInventoryDetail() {
			// 直接从表格获取当前选中的行（这样更准确，避免使用存储的标识可能不一致的问题）
			const tableRef = this.$refs.inventoryDetail;
			if (!tableRef) {
				this.$message.error('表格引用不存在');
				return;
			}

			// 获取表格当前选中的行（这些行来自 visibleInventoryDetailList）
			const selectedRows = tableRef.selection || [];

			if (selectedRows.length === 0) {
				this.$message.error('请先选择要删除的库存详情数据');
				return;
			}

			let deletedCount = 0;
			// 直接遍历选中的行，在 inventoryDetailList 中找到对应的行
			selectedRows.forEach(selectedRow => {
				// 在 inventoryDetailList 中查找匹配的行（通过对象引用或 id）
				const matchedItem = this.inventoryDetailList.find(item => {
					// 对象引用相同（最准确的匹配）
					if (selectedRow === item) {
						return true;
					}
					// 如果对象引用不同，通过 id 匹配（适用于已保存的行）
					if (selectedRow.id !== undefined && selectedRow.id !== null && item.id !== undefined && item.id !== null && selectedRow.id === item.id) {
						return true;
					}
					return false;
				});

				if (matchedItem) {
					// 如果该行已经有id（已保存的数据），标记为删除
					if (matchedItem.id !== undefined && matchedItem.id !== null) {
						this.$set(matchedItem, 'isDeleted', true);
						// 清除编辑状态
						this.$set(matchedItem, 'isEditing', false);
						deletedCount++;
					} else {
						// 如果是新添加但未保存的行，直接删除
						const index = this.inventoryDetailList.indexOf(matchedItem);
						if (index > -1) {
							this.inventoryDetailList.splice(index, 1);
							deletedCount++;
						}
					}
				}
			});

			// 清空选中项
			this.checkedInventoryDetail = [];
			// 清除表格的选中状态
			if (tableRef) {
				tableRef.clearSelection();
			}

			if (deletedCount > 0) {
				this.$message.success(`已标记${deletedCount}条数据为删除状态，保存时将提交删除操作`);
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
			// 强制校验运输方式
			if (!this.isLand && !this.isSea) {
				this.transportError = true;
				this.$message.error('请至少选择一种运输方式（陆运或海运）');
				return;
			}

			this.$refs['secondForm'].validate(valid => {
				if (!valid) {
					this.$message.error('请检查并完善表单中的必填项!');
					return;
				}

				// 强制再次校验运输方式
				if (!this.isLand && !this.isSea) {
					this.transportError = true;
					this.$message.error('请至少选择一种运输方式（陆运或海运）');
					return;
				}

				// 检查是否有未保存的子项（只检查可见行）
				if (this.visibleInventoryDetailList.some(item => item.isEditing)) {
					this.$message.error('当前有未保存的库存信息，请先保存所有编辑中的数据后再提交');
					return;
				}

				// 检查是否有有效的库存详情（排除 shouldDel 和已删除的行）
				const validInventoryItems = this.visibleInventoryDetailList
					.filter(item => !item.shouldDel)
					.map(item => {
						return {
							...item,
							exWareHoustId: this.secondForm.exWareHoustId
						};
					});

				// 如果长度为0 需要提示用户
				if (validInventoryItems.length === 0) {
					this.$message.error('请至少添加一条有效的库存详情信息，不能仅包含默认记录');
					return;
				}

				// 填充已删除的行信息（排除 shouldDel 的项）
				const deletedDetails = this.deletedInventoryDetailList
					.filter(item => !item.shouldDel)
					.map(item => ({
						...item,
						exWareHoustId: this.secondForm.exWareHoustId
					}));

				// 合并正常数据和已删除数据
				this.secondForm.inventoryDetailList = [..._.cloneDeep(validInventoryItems), ...deletedDetails];

				// 计算总陆运费和总海运费（只计算可见行）
				this.secondForm.allLandFreight = this.isLand ? this.visibleInventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight || 0), 0) : 0;
				this.secondForm.allSeaFreight = this.isSea ? this.visibleInventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight || 0), 0) : 0;

				// 根据表单ID判断是新增还是更新
				const apiCall = this.secondForm.id ? updateInventoryMain : addInventoryMain;
				const successMessage = this.secondForm.id ? '二次入库信息修改成功' : '二次入库提交成功';

				// 调用API
				const body = {
					...this.secondForm,
					params: {
						attachmentIds: this.secondForm.params?.attachmentIds || []
					}
				};
				apiCall(body)
					.then(response => {
						this.$modal.msgSuccess(successMessage + '，可继续操作或关闭窗口');
						// 不关闭弹窗，只显示成功消息
						this.getList(); // 刷新列表
						// 如果是新增操作，更新表单ID和明细项数据
						if (!this.secondForm.id && response.data && response.data.id) {
							this.secondForm.id = response.data.id;
							// 直接使用后端返回的明细项数据替换前端有效明细项
							if (response.data.inventoryDetailList && response.data.inventoryDetailList.length > 0) {
								// 保留shouldDel为true的项（默认记录），替换其他有效明细项
								const shouldDelItems = this.inventoryDetailList.filter(item => item.shouldDel);
								// 将后端返回的明细项添加必要的前端状态字段
								const backendDetails = response.data.inventoryDetailList.map((item, index) => {
									const processedItem = {
										...item,
										index: shouldDelItems.length + index + 1, // 设置唯一索引
										isEditing: false,
										hasError: false,
										manuallyEditedPieces: true,
										selfButtonDisabled: item.supplierId === 0,
										isDeleted: false,
										isAdd: false
									};
									// 初始化特殊字段的小数位数
									initSpecialFieldDecimalPlaces(processedItem);
									return processedItem;
								});
								// 合并：保留shouldDel项 + 后端返回的明细项
								this.inventoryDetailList = [...shouldDelItems, ...backendDetails];
							}
						}
					})
					.catch(error => {
						this.$message.error('提交失败: ' + (error.message || '未知错误'));
					});
			});
		},

		/**
		 * @description: 处理库存详情表格中行的编辑操作
		 * @param {Object} row - 当前编辑的行数据
		 */
		handleRowEdit(row) {
			// 设置当前行为可编辑
			this.$set(row, 'isEditing', true);
			// 清除错误状态
			if (row.hasError) {
				this.$set(row, 'hasError', false);
			}
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
			if (isNaN(Number(row.paymentUnload)) || Number(row.paymentUnload) < 0) {
				return { valid: false, message: '存货价必须是有效的非负数字' };
			}
			if (isNaN(Number(row.stockNumber)) || Number(row.stockNumber) < 0) {
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
		 * @description: 处理行保存事件
		 * @param {Object|Array} row - 当前保存的行数据或行数据数组
		 * @param {Function} [resolve=null] - Promise resolve回调
		 * @param {Function} [reject=null] - Promise reject回调
		 */
		handleRowSave(row, resolve = null, reject = null) {
			// 统一处理输入，确保 rows 是数组
			const rows = Array.isArray(row) ? row : [row];

			// 先进行数据校验
			for (const r of rows) {
				if (!r.isEditing || r.isDeleted) continue;
				const validationResult = this.validateInventoryRow(r);
				if (!validationResult.valid) {
					this.$set(r, 'hasError', true);
					this.$message.error(`行 "${r.levelName || '未命名'}" 验证失败: ${validationResult.message}`);
					if (reject) reject(new Error(validationResult.message));
					return;
				}
			}

			// 处理每一行，关闭编辑状态并更新计算
			rows.forEach(r => {
				if (r.isEditing && !r.isDeleted) {
					this.$set(r, 'isEditing', false);
					const extraOptions = { isSecondInventory: true };
					updateInventoryRowCalculations(r, this.isSea, this.isLand, extraOptions);
				}
			});

			// 深拷贝并过滤掉仍在编辑的行和已删除的行（已删除的行单独处理）
			const rowsToSave = rows.filter(item => !item.isEditing && !item.isDeleted);
			let saveDetails = _.cloneDeep(rowsToSave);

			// 过滤掉空白行（所有业务字段都为空的行）
			const originalCount = saveDetails.length;
			saveDetails = saveDetails.filter(detail => !this.isInventoryDetailEmpty(detail));

			// 收集所有已标记删除的行（需要一起发送给后端）
			const deletedDetails = _.cloneDeep(this.deletedInventoryDetailList);

			// 合并正常保存的行和已删除的行
			const allDetails = [...saveDetails, ...deletedDetails];

			// 检查是否至少有一些有效数据（正常数据或已删除数据）
			if (allDetails.length === 0) {
				this.$message.error('请添加有效的库存信息!');
				if (reject) reject(new Error('请添加有效的库存信息'));
				return;
			}

			// 如果过滤掉了一些空白行，给用户提示
			const filteredCount = originalCount - saveDetails.length;
			if (filteredCount > 0) {
				this.$message.info(`已自动过滤掉${filteredCount}条空白明细行`);
			}

			// 如果有已删除的行，提示用户
			if (deletedDetails.length > 0) {
				console.log(`保存时包含${deletedDetails.length}条已标记删除的数据`);
			}

			// 构造新的库存信息（包含正常数据和已删除数据，但排除 shouldDel 为 true 的项）
			const newInventoryInfo = {
				...this.secondForm,
				inventoryDetailList: allDetails.filter(item => !item.shouldDel)
			};
			// 计算总运费等主表信息（只计算可见行）
			newInventoryInfo.allLandFreight = this.isLand ? this.visibleInventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight || 0), 0) : 0;
			newInventoryInfo.allSeaFreight = this.isSea ? this.visibleInventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight || 0), 0) : 0;

			this.saveInventoryDetails(newInventoryInfo, rows, resolve, reject, row);
		},
		/**
		 * @description: 保存库存详情数据到后端
		 * @param {Object} newInventoryInfo - 新的库存信息
		 * @param {Array} rows - 相关的行数据
		 * @param {Function} [resolve=null] - Promise resolve回调
		 * @param {Function} [reject=null] - Promise reject回调
		 */
		saveInventoryDetails(newInventoryInfo, rows, resolve = null, reject = null, row = null) {
			// 保存row的引用，避免在Promise链中丢失
			const currentRows = rows;
			// 检查是否已有ID来决定是新增还是修改
			const apiCall = newInventoryInfo.id ? updateInventoryMain : addInventoryMain;
			const successMessage = newInventoryInfo.id ? '库存详情已修改并保存!' : '库存详情已添加并保存!';

			apiCall(newInventoryInfo)
				.then(res => {
					// 成功后清除可能的错误标记
					currentRows.forEach(row => {
						if (row.hasError) {
							this.$set(row, 'hasError', false);
						}
					});
					const inventoryInfo = _.cloneDeep(res.data);
					if (!inventoryInfo || !inventoryInfo.inventoryDetailList || inventoryInfo.inventoryDetailList.length === 0) {
						this.$message.error('保存失败，保存后未找到相应数据');
						this.isEditingDetails = true;
						reject && reject();
						return;
					}
					// 如果该行是新增行，则从后端返回的数据中找到index等于该行数据的index的id，并赋值给该行 并且将isAdd标记为false
					if (row && row.isAdd) {
						const inventoryRow = inventoryInfo.inventoryDetailList.find(item => item.index === row.index);
						if (!inventoryRow) {
							this.$message.error('保存失败，新增的数据索引并未找到服务器对应索引的数据，请联系管理员!');
							this.isEditingDetails = true;
							reject && reject();
							return;
						}
						row.id = inventoryRow.id;
						row.isAdd = false;
					}
					// 如果是新增，保存返回的ID到表单中，确保后续操作为修改
					if (!newInventoryInfo.id && res.data && res.data.id) {
						this.secondForm.id = res.data.id;
						// 直接使用后端返回的明细项数据替换前端有效明细项
						if (res.data.inventoryDetailList && res.data.inventoryDetailList.length > 0) {
							// 保留shouldDel为true的项（默认记录），替换其他有效明细项
							const shouldDelItems = this.inventoryDetailList.filter(item => item.shouldDel);
							// 将后端返回的明细项添加必要的前端状态字段
							const backendDetails = res.data.inventoryDetailList.map((item, index) => {
								const processedItem = {
									...item,
									index: shouldDelItems.length + index + 1, // 设置唯一索引
									isEditing: false,
									hasError: false,
									manuallyEditedPieces: true,
									selfButtonDisabled: item.supplierId === 0,
									isDeleted: false,
									isAdd: false
								};
								// 初始化特殊字段的小数位数
								initSpecialFieldDecimalPlaces(processedItem);
								return processedItem;
							});
							// 合并：保留shouldDel项 + 后端返回的明细项
							this.inventoryDetailList = [...shouldDelItems, ...backendDetails];
						}
					}
					this.$message.success(successMessage);
					resolve && resolve(res);
				})
				.catch(error => {
					currentRows.forEach(row => {
						// 使用Vue的响应式方法确保UI更新
						this.$set(row, 'isEditing', true);
						this.$set(row, 'hasError', true); // 添加错误标记
					});
					const errorMsg = error.message || '未知错误';
					this.$message.error(`保存失败，请重新编辑: ${errorMsg}`);
					this.isEditingDetails = true;
					reject && reject(error);
				});
		},
		/**
		 * @description: 切换库存详情的批量编辑模式
		 * @param {boolean} editState - true表示进入编辑模式，false表示退出并保存
		 */
		toggleEditDetails(editState) {
			if (editState) {
				// 进入编辑模式，设置所有可见行为可编辑状态
				this.visibleInventoryDetailList.forEach(row => {
					this.$set(row, 'isEditing', true);
					if (row.hasError) {
						this.$set(row, 'hasError', false);
					}
				});
				this.$message.info('已进入批量编辑模式，可以修改所有库存信息');
			} else {
				// 退出编辑模式，保存所有可见行（包括已删除的行会一起发送）
				// 如果有正在编辑的行，全部设置为不可编辑
				if (this.hasEditingRows) {
					this.handleRowSave(this.visibleInventoryDetailList);
				}
			}
		},
		/**
		 * @description: 处理出厂片数输入变化事件，标记为手动编辑并重新计算
		 * @param {object} scope 当前行的作用域对象
		 * @param {string|number} val 输入的出厂片数值
		 */
		handlePiecesChange(scope, val) {
			scope.row.manuallyEditedPieces = true;
			// 对于二次入库的时候 需要特殊处理 含税金额需要再减去一个其他费用，放在额外对象中
			const extraOptions = {
				isSecondInventory: true
			};
			updateInventoryRowCalculations(scope.row, this.isSea, this.isLand, extraOptions);
		},
		/**
		 * @description: 处理片数输入，限制最多两位小数
		 * @param {object} row 当前行数据
		 * @param {string} field 字段名
		 * @param {string} value 输入值
		 * @param {function} callback 回调函数
		 */
		handlePiecesInput(row, field, value, callback) {
			return utilHandlePiecesInput(row, field, value, callback);
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
		 * 处理价格字段输入，保存完整精度值用于计算
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 * @param {String} inputValue - 用户输入的值
		 * @param {Function} callback - 输入后的回调函数（如重新计算）
		 */
		handlePriceInput(row, field, inputValue, callback) {
			return utilHandlePriceInput(row, field, inputValue, callback);
		},
		/**
		 * 规范化价格输入，确保为有效的Number类型，但保持完整精度不截断
		 * 在失去焦点时格式化显示，但保留完整精度值用于计算
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 * @param {Number} precision - 显示精度（2或4位小数）
		 * @param {boolean} isSpecialFieldFlag - 是否强制作为特殊字段处理（false表示根据字段名自动判断）
		 */
		formatPriceInput(row, field, precision, isSpecialFieldFlag = false) {
			return utilFormatPriceInput(row, field, precision, isSpecialFieldFlag);
		},
		/**
		 * 处理价格字段聚焦事件，恢复完整精度显示以便编辑
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 */
		handlePriceFocus(row, field) {
			return utilHandlePriceFocus(row, field);
		}
		// parseInputValue, formatValueForDisplay, getDecimalPlaces 已从 @/utils/order 导入，直接使用
	}
};
</script>

<style scoped lang="scss">
// ============================================
// 表单样式
// ============================================
::v-deep .el-form {
	.el-form-item {
		margin-bottom: 8px !important; // 进一步缩小表单项间距

		// 表单 label 样式 - 字体大小与输入框值一致（16px）
		.el-form-item__label {
			font-size: 16px !important; // 参考输入框值的字体大小
			color: #000000 !important; // 保持黑色
			font-weight: 600 !important; // 保持加粗
			line-height: 24px !important; // 与输入框高度一致
		}

		// 运输方式checkbox样式 - 字体大小与表单label一致（16px）
		.el-checkbox {
			font-size: 16px !important; // 与表单label字体大小一致

			.el-checkbox__label {
				font-size: 16px !important; // 与表单label字体大小一致
				color: #000000 !important; // 保持黑色
				font-weight: normal !important; // 正常字重
				padding-left: 8px !important; // 增加左边距，与checkbox保持适当距离
			}

			.el-checkbox__input {
				.el-checkbox__inner {
					width: 16px !important; // 增大checkbox尺寸
					height: 16px !important; // 增大checkbox尺寸
					border-radius: 2px !important; // 保持圆角

					&:after {
						width: 5px !important; // 增大对勾尺寸
						height: 8px !important; // 增大对勾尺寸
						left: 5px !important; // 调整对勾位置
						top: 1px !important; // 调整对勾位置
					}
				}

				// 选中状态
				&.is-checked {
					.el-checkbox__inner {
						background-color: #409eff !important;
						border-color: #409eff !important;
					}
				}

				// 禁用状态
				&.is-disabled {
					.el-checkbox__inner {
						background-color: #f5f7fa !important;
						border-color: #e4e7ed !important;
					}
				}
			}
		}
	}
}

// ============================================
// 表格样式
// ============================================
::v-deep .el-table {
	// 表格表头样式 - 字体大小与表单label一致（16px）
	.el-table__header-wrapper {
		.el-table__header {
			th {
				.cell {
					font-size: 16px !important; // 与表单label字体大小一致
					color: #000000 !important; // 保持黑色
					font-weight: bold !important; // 保持加粗
				}
			}
		}
	}

	// 固定列表头样式 - 与主表格表头保持一致
	.el-table__fixed {
		.el-table__fixed-header-wrapper {
			.el-table__header {
				th {
					.cell {
						font-size: 16px !important; // 与表单label字体大小一致
						color: #000000 !important; // 保持黑色
						font-weight: bold !important; // 保持加粗
					}
				}
			}
		}
	}

	// 右侧固定列表头样式
	.el-table__fixed-right {
		.el-table__fixed-header-wrapper {
			.el-table__header {
				th {
					.cell {
						font-size: 16px !important; // 与表单label字体大小一致
						color: #000000 !important; // 保持黑色
						font-weight: bold !important; // 保持加粗
					}
				}
			}
		}
	}
}

// 编辑行样式
::v-deep .editing-row {
	td:first-child {
		border-left: 9px solid #63f697 !important;
	}
}

// 错误行样式
::v-deep .error-row {
	td:first-child {
		border-left: 9px solid #f56c6c !important;
	}

	td {
		animation: errorPulse 2s infinite;
	}

	&:hover td {
		animation: none;
	}
}

// 只读行样式
::v-deep .readonly-row {
	td:first-child {
		border-left: 9px solid #909399 !important;
	}

	td {
		background-color: #f5f7fa !important;
		color: #909399 !important;
	}

	&:hover td {
		background-color: #e9ecef !important;
	}
}

// 滚动条样式
::v-deep .el-table__body-wrapper {
	&::-webkit-scrollbar {
		width: 14px;
		height: 14px;
	}

	&::-webkit-scrollbar-thumb {
		border-radius: 2px;
		background-color: rgba(0, 0, 0, 0.5);
	}

	&::-webkit-scrollbar-track {
		border-radius: 2px;
		background-color: rgba(0, 0, 0, 0.1);
	}
}

/* 计量单位列水平布局样式 */
::v-deep .counting-unit-column {
	.cell {
		padding: 2px 4px !important; // 减少内边距
		line-height: 1.2 !important;
		white-space: nowrap !important; // 不换行，保持水平布局
		overflow: visible !important; // 显示溢出内容
		height: auto !important; // 自动高度适应内容
		text-align: center !important; // 居中对齐
	}
}

// 计量单位单选框组水平布局（左边片数，右边其他）
::v-deep .horizontal-radio-group {
	display: flex !important;
	flex-direction: row !important; // 水平排列
	align-items: center !important;
	justify-content: center !important;
	gap: 4px !important; // 选项间距
	width: 100% !important;
	margin: 0 !important;

	.horizontal-radio {
		margin-right: 0 !important;
		margin-bottom: 0 !important;
		white-space: nowrap !important;

		.el-radio__label {
			font-size: 14px !important; // 字体大小
			padding-left: 2px !important;
		}

		.el-radio__input {
			.el-radio__inner {
				width: 14px !important; // 增大单选框尺寸
				height: 14px !important; // 增大单选框尺寸

				&:after {
					width: 4px !important; // 增大内部圆点尺寸
					height: 4px !important; // 增大内部圆点尺寸
					left: 5px !important; // 调整圆点位置以居中
					top: 5px !important; // 调整圆点位置以居中
				}
			}
		}
	}
}

/* 含税列水平布局样式 */
::v-deep .tax-column {
	.cell {
		padding: 2px 4px !important; // 减少内边距
		line-height: 1.2 !important;
		white-space: nowrap !important; // 不换行，保持水平布局
		overflow: visible !important; // 显示溢出内容
		height: auto !important; // 自动高度适应内容
		text-align: center !important; // 居中对齐
	}
}

// 含税单选框组水平布局（左是右否）
::v-deep .horizontal-tax-radio-group {
	display: flex !important;
	flex-direction: row !important; // 水平排列
	align-items: center !important;
	justify-content: center !important;
	gap: 4px !important; // 选项间距
	width: 100% !important;
	margin: 0 !important;

	.horizontal-tax-radio {
		margin-right: 0 !important;
		margin-bottom: 0 !important;
		white-space: nowrap !important;

		.el-radio__label {
			font-size: 14px !important; // 字体大小
			padding-left: 2px !important;
		}

		.el-radio__input {
			.el-radio__inner {
				width: 14px !important; // 增大单选框尺寸
				height: 14px !important; // 增大单选框尺寸

				&:after {
					width: 4px !important; // 增大内部圆点尺寸
					height: 4px !important; // 增大内部圆点尺寸
					left: 5px !important; // 调整圆点位置以居中
					top: 5px !important; // 调整圆点位置以居中
				}
			}
		}
	}
}
</style>
