<template>
	<div class="app-container">
		<el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="入库日期" prop="storeDate">
				<el-date-picker v-model="queryParams.storeDate" type="date" value-format="yyyy-MM-dd" placeholder="选择入库日期" clearable />
			</el-form-item>
			<el-form-item label="陆运车牌" prop="landCarNo">
				<el-input v-model="queryParams.landCarNo" placeholder="请输入陆运车牌" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="陆运司机电话" prop="landDriverTel">
				<el-input v-model="queryParams.landDriverTel" placeholder="请输入陆运司机电话" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="陆地司机姓名" prop="landDriverName">
				<el-input v-model="queryParams.landDriverName" placeholder="请输入陆地司机姓名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="海运公司" prop="seaDriverName">
				<el-input v-model="queryParams.seaDriverName" placeholder="请输入海运公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['system:inventoryMain:add']">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['system:inventoryMain:edit']">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['system:inventoryMain:remove']">删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:inventoryMain:export']">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
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
			<el-table id="printBox" size="mini" v-loading="loading" :data="inventoryMainList" @selection-change="handleSelectionChange" stripe style="width: 100%; margin-bottom: 20px">
				<el-table-column type="selection" width="50" align="center" />

				<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" />

				<el-table-column v-if="columns[1].visible" label="仓库名称" align="center" prop="storeHouseName" width="150" />

				<el-table-column v-if="columns[2].visible" label="变动日期(入库)" align="center" prop="storeDate" width="150" />

				<el-table-column v-if="columns[3].visible" label="货物来源公司" align="center" prop="goodsCompany" width="180" />

				<el-table-column v-if="columns[4].visible" label="审核状态" align="center" prop="checkState" width="150">
					<template #default="scope">
						<el-row v-if="scope.row.checkState === '已审核'">
							<StateTag :state-title="scope.row.checkState" :state-mapper="{ 2: '已审核' }" @click.native="handleReCheck(scope.row)" style="cursor: pointer" />
						</el-row>
						<el-row v-else>
							<el-row>
								<el-button v-hasPermi="['system:inventoryMain:audit']" type="text" size="mini" @click="handleCheck(scope.row)">审核</el-button>
							</el-row>
						</el-row>
					</template>
				</el-table-column>

				<el-table-column v-if="columns[5].visible" label="陆运车牌" align="center" prop="landCarNo" width="120" />

				<el-table-column v-if="columns[6].visible" label="陆运司机电话" align="center" prop="landDriverTel" width="150" />

				<el-table-column v-if="columns[7].visible" label="陆地司机姓名" align="center" prop="landDriverName" width="120" />

				<el-table-column v-if="columns[8].visible" label="陆运银行卡号" align="center" prop="landBankNo" width="120" />

				<el-table-column v-if="columns[9].visible" label="陆运银行户名" align="center" prop="landBankName" width="120" />

				<el-table-column v-if="columns[10].visible" label="柜号" align="center" prop="seaCarNo" width="120" />

				<el-table-column v-if="columns[11].visible" label="海运司机电话" align="center" prop="seaDriverTel" width="150" />

				<el-table-column v-if="columns[12].visible" label="海运公司" align="center" prop="seaDriverName" width="120" />

				<el-table-column v-if="columns[13].visible" label="海运银行卡号" align="center" prop="seaBankNo" width="120" />

				<el-table-column v-if="columns[14].visible" label="海运银行户名" align="center" prop="seaBankName" width="120" />

				<el-table-column v-if="columns[15].visible" label="子项陆运费之和" align="center" prop="allLandFreight" width="150" />

				<el-table-column v-if="columns[16].visible" label="子项海运费之和" align="center" prop="allSeaFreight" width="150" />

				<el-table-column v-if="columns[17].visible" label="收到条附件" align="center" prop="attachmentList" width="150" fixed="right">
					<template slot-scope="scope">
						<CheckFiles
							:attachmentList="scope.row.attachmentList"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInventoryMain, updateInventoryMain)"
							flag="attachmentList"
						/>
					</template>
				</el-table-column>

				<el-table-column v-if="columns[18].visible" label="操作" align="center" width="180" fixed="right">
					<template slot-scope="scope">
						<el-button size="mini" type="text" icon="el-icon-edit" @click="handleCheckInventory(scope.row)">查看</el-button>
						<el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:inventoryMain:edit']">修改</el-button>
						<el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['system:inventoryMain:remove']">删除</el-button>
					</template>
				</el-table-column>
			</el-table>

			<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
		</el-col>

		<!-- 添加或修改库存库存主表对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="1200px" append-to-body :close-on-click-modal="false">
			<el-form ref="form" :model="form" :rules="rules" label-width="80px" :inline="true">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-col :span="16">
						<el-input disabled size="mini" v-model="form.storeHouseName" placeholder="请输入仓库名称" />
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
					<el-date-picker v-model="form.storeDate" size="mini" type="datetime" placeholder="选择入库日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 120px" />
				</el-form-item>
				<el-form-item label="货物来源" prop="goodsCompany">
					<el-input size="mini" v-model="form.goodsCompany" placeholder="请输入货物来源公司(本部或者海盛)" />
				</el-form-item>
				<el-form-item label="附件">
					<UploadFilesButton
						ref="attachmentUploader"
						flag="attachmentList"
						:extra-info="{ moduleType: 'inventoryMain', formId: form.id }"
						:initial-attachments="form.attachmentList || []"
						@files-updated="handleAttachmentFilesUpdated"
					/>
				</el-form-item>
				<br />
				<el-form-item label="运输方式" prop="transportMode" required>
					<el-checkbox v-model="isLand" @change="updateTransportMode">陆运</el-checkbox>
					<el-checkbox v-model="isSea" @change="updateTransportMode">海运</el-checkbox>
					<!-- <span v-if="!isLand && !isSea" class="transport-error">请至少选择一种运输方式</span> -->
				</el-form-item>
				<el-row v-if="isLand" style="margin: 3px 0">
					<el-form-item label="车牌" prop="landCarNo">
						<el-row>
							<el-col :span="20">
								<el-input disabled v-model="form.landCarNo" type="text" size="mini" placeholder="请选择" style="width: 120px" />
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
						<el-input disabled v-model="form.landDriverName" type="text" size="mini" placeholder="请选择" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input disabled v-model="form.landDriverTel" type="text" size="mini" placeholder="请选择" style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号">
						<el-input disabled v-model="form.landBankNo" type="text" size="mini" placeholder="请选择" style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行">
						<el-input disabled v-model="form.landBankName" type="text" size="mini" placeholder="请选择" style="width: 120px" />
					</el-form-item>
					<!-- 添加车队 -->
					<el-form-item label="车队" prop="fleet">
						<el-row>
							<el-col :span="12">
								<el-input v-model="form.fleet" type="text" size="mini" placeholder="请选择车队" />
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
					<!-- 添加附件上传 -->
				</el-row>
				<!--      海运-->
				<el-row v-if="isSea" style="margin: 3px 0">
					<el-form-item label="柜号" prop="seaCarNo">
						<el-row>
							<el-col :span="20">
								<el-input v-model="form.seaCarNo" type="text" size="mini" placeholder="请输入柜号" style="width: 120px" />
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
					<el-form-item label="海运公司" prop="seaDriverName">
						<el-input v-model="form.seaDriverName" type="text" size="mini" placeholder="请输入海运公司" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话" prop="seaDriverTel">
						<el-input v-model="form.seaDriverTel" type="text" size="mini" placeholder="请输入电话" style="width: 120px" />
					</el-form-item>
					<el-form-item label="银行卡号" prop="seaBankNo">
						<el-input v-model="form.seaBankNo" type="text" size="mini" placeholder="请输入海运银行卡号" style="width: 120px" />
					</el-form-item>
					<el-form-item label="开户行" prop="seaBankName">
						<el-input v-model="form.seaBankName" type="text" size="mini" placeholder="请输入海运开户行" style="width: 120px" />
					</el-form-item>
				</el-row>
				<br />

				<el-divider content-position="center">货物信息</el-divider>
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<!-- 添加按钮：始终可用 -->
						<el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddInventoryDetail">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<!-- 删除按钮：仅在选中项时可用 -->
						<el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteInventoryDetail" :disabled="checkedInventoryDetail.length === 0">删除</el-button>
					</el-col>
					<!-- 编辑子项按钮：有子项且没有行处于编辑状态时可用 -->
					<el-col :span="1.5">
						<el-button size="mini" type="warning" @click="toggleEditDetails(true)" :disabled="!hasInventoryDetails || hasEditingRows">编辑子项</el-button>
					</el-col>
					<!-- 全部保存按钮：有行处于编辑状态时可用 -->
					<el-col :span="1.5">
						<el-button size="mini" type="success" @click="toggleEditDetails(false)" :disabled="!hasEditingRows">全部保存</el-button>
					</el-col>
				</el-row>

				<!--        与订单一致 -->
				<el-table
					size="mini"
					:data="inventoryDetailList"
					show-summary
					:summary-method="getSummary"
					:row-class-name="getRowClassName"
					@selection-change="handleInventoryDetailSelectionChange"
					ref="inventoryDetail"
				>
					<!-- 选择列：始终可选 -->
					<el-table-column type="selection" width="50" align="center" :selectable="() => true" />
					<el-table-column label="序号" align="center" type="index" width="50" />

					<!-- 新增：行操作列 -->
					<el-table-column label="行操作" align="center" width="100" fixed="left">
						<template slot-scope="scope">
							<el-button v-if="!scope.row.isEditing" :disabled="!isEditingDetails" size="mini" type="warning" icon="el-icon-edit" @click="handleRowEdit(scope.row)">编辑</el-button>
							<el-button v-else size="mini" type="success" icon="el-icon-check" @click="handleRowSave(scope.row)">保存</el-button>
						</template>
					</el-table-column>

					<el-table-column label="供应商" width="200">
						<template #default="scope">
							<el-row>
								<!-- 动态绑定的 Input -->
								<el-col :span="18">
									<!-- 添加 disabled 属性 -->
									<el-input disabled size="mini" v-model="scope.row.supplier" placeholder="请选择" />
								</el-col>

								<!-- 供应商按钮 -->
								<el-col :span="6">
									<SearchOption
										title="供应商信息"
										:get-data="listCompany"
										icon="el-icon-user"
										query-label="公司名称"
										query-info="companyName"
										:query-name="querySupplier"
										:limit-info="{ companyType: '供应商' }"
										@commitBack="value => handleCommitBackSupplier(scope, value)"
										@update:queryName="handleUpdateQuerySupplier"
										@click="setCurrentType(scope.row, 'supplier')"
										:query-items="queryItemsSupplier"
										:disable="!scope.row.isEditing"
									>
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
								<!-- 添加 disabled 属性 -->
								<el-input disabled size="mini" v-model="scope.row.levelName" placeholder="请选择" />
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
							<!-- 添加 disabled 属性 -->
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!scope.row.isEditing" @change="() => recalculateAll(scope)">
								<el-radio label="片">片数</el-radio>
								<el-radio label="其他">其他</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="厚度" prop="height" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.height" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="长度" prop="length" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.length" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="宽度" prop="width" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.width" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="每包片数" prop="piecesPerPack" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.piecesPerPack"
								placeholder="请输入每包片数"
								:disabled="!scope.row.isEditing"
								@input="val => handlePiecesInput(scope.row, 'piecesPerPack', val, () => calculatePieces(scope.row))"
							/>
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.packs"
								:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
								:disabled="!scope.row.isEditing || scope.row.piecesPerPack <= 0"
								@input="val => handlePiecesInput(scope.row, 'packs', val, () => calculatePieces(scope.row))"
							/>
						</template>
					</el-table-column>

					<el-table-column label="出厂片数" prop="pieces" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.pieces"
								placeholder="请输入出厂片数"
								@input="val => handlePiecesInput(scope.row, 'pieces', val, () => recalculateAll(scope))"
								@change="() => handlePiecesChange(scope)"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>

					<el-table-column label="出厂单价" prop="price" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.price"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="!scope.row.isEditing || !scope.row.pieces"
								@blur="() => formatPriceInput(scope.row, 'price', 4, false)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂是否含税" prop="isIncludeTaxFactory" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
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
								:disabled="!scope.row.isEditing || !scope.row.price"
								@blur="() => formatPriceInput(scope.row, 'sundryCost', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.paymentFactory" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="入库量" prop="stockNumber" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.stockNumber" placeholder="入库时片数" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="存货价" prop="paymentUnload" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.paymentUnload"
								placeholder="请输入存货价"
								@input="() => recalculateAll(scope)"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'paymentUnload', 4, false)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="库存是否含税" prop="isIncludeTaxSale" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
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
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" disabled />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.tonnage" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="陆运费单价" prop="landFreightPrice" width="150" v-if="isLand">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.landFreightPrice"
								@input="() => recalculateAll(scope)"
								placeholder="请输入陆运费单价"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'landFreightPrice', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="() => recalculateAll(scope)"
								:placeholder="!scope.row.landFreightPrice ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'additionalFees', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="150" v-if="isLand">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.landFreight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="150" v-if="isSea">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.seaFreight"
								@input="() => recalculateAll(scope)"
								placeholder="请输入海运费"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'seaFreight', 2)"
							/>
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.otherCost"
								placeholder="请输入其他费用"
								@input="() => recalculateAll(scope)"
								:disabled="!scope.row.isEditing"
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
					<el-table-column label="物流利润" prop="logisticsProfit" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.logisticsProfit"
								placeholder="请输入物流利润"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'logisticsProfit', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="厂家佣金" prop="factoryCommission" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryCommission"
								placeholder="请输入厂家佣金"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'factoryCommission', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryRebateAmount"
								placeholder="请输入计提厂家返利金额"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'factoryRebateAmount', 2)"
							/>
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryDiscountAmount"
								placeholder="请输入计提厂家降价金额"
								:disabled="!scope.row.isEditing"
								@blur="() => formatPriceInput(scope.row, 'factoryDiscountAmount', 2)"
							/>
						</template>
					</el-table-column>

					<el-table-column label="备注" prop="comments" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
				</el-table>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
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
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { _fill } from './fill';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import CheckFiles from '../../../components/CheckFiles.vue';
import { auditInventory } from '../../../api/system/inventoryMain';
import StateTag from '../../dashboard/components/common/StateTag.vue';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import { parseTime } from '@/utils/ruoyi';
import _ from 'lodash'; // 引入 lodash
import { updateInventoryRowCalculations } from './inventoryCalculations'; // 确保导入

export default {
	name: 'InventoryMain',
	components: { DialogWrapper, SearchOption, CheckFiles, UploadFilesButton, StateTag },
	mixins: [_fill, mixin_checkfile, mixin_printHTML, common_dialog],
	data() {
		// 自定义校验器：当选择陆运时，车队必填
		const validateFleet = (rule, value, callback) => {
			if (this.isLand && !value) {
				// 修改提示信息以反映需要选择
				callback(new Error('选择陆运时，请选择车队'));
			} else {
				callback();
			}
		};
		// 自定义校验器：当选择陆运时，必须选择车牌信息
		const validateLandCar = (rule, value, callback) => {
			if (this.isLand && !value) {
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
			if (this.isSea && !value) {
				callback(new Error('选择海运时，海运公司不能为空'));
			} else {
				callback();
			}
		};
		// 自定义校验器：当选择海运时，电话必填
		const validateSeaDriverTel = (rule, value, callback) => {
			if (this.isSea && !value) {
				callback(new Error('选择海运时，电话不能为空'));
			} else {
				callback();
			}
		};
		// 自定义校验器：当选择海运时，银行卡号必填
		const validateSeaBankNo = (rule, value, callback) => {
			if (this.isSea && !value) {
				callback(new Error('选择海运时，银行卡号不能为空'));
			} else {
				callback();
			}
		};
		// 自定义校验器：当选择海运时，开户行必填
		const validateSeaBankName = (rule, value, callback) => {
			if (this.isSea && !value) {
				callback(new Error('选择海运时，开户行不能为空'));
			} else {
				callback();
			}
		};

		// 自定义校验器：确保至少选择一种运输方式
		const validateTransportMode = (rule, value, callback) => {
			if (!this.isLand && !this.isSea) {
				callback(new Error('请至少选择一种运输方式'));
			} else {
				callback();
			}
		};

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
			inventoryDetailList: [], // 库存子表格数据
			isEditingDetails: false, // 新增：全局编辑状态
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
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
			rules: {
				storeHouseName: [{ required: true, message: '仓库名称不能为空', trigger: 'blur' }],
				storeDate: [{ required: true, message: '入库日期不能为空', trigger: 'change' }],
				fleet: [{ validator: validateFleet, trigger: 'blur' }],
				landCarNo: [{ validator: validateLandCar, trigger: 'change' }],
				// 添加海运相关校验规则
				seaCarNo: [{ validator: validateSeaCarNo, trigger: 'blur' }],
				seaDriverName: [{ validator: validateSeaDriverName, trigger: 'blur' }],
				seaDriverTel: [{ validator: validateSeaDriverTel, trigger: 'blur' }],
				seaBankNo: [{ validator: validateSeaBankNo, trigger: 'blur' }],
				seaBankName: [{ validator: validateSeaBankName, trigger: 'blur' }],
				// 添加运输方式校验规则
				transportMode: [{ validator: validateTransportMode, trigger: 'change' }]
			},
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
			open: false,
			title: null,

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
	computed: {
		/**
		 * @description: 计算属性，检查库存详情列表是否有子项。
		 * @returns {boolean} 如果 inventoryDetailList 存在且长度大于0，则返回 true，否则返回 false。
		 */
		hasInventoryDetails() {
			return this.inventoryDetailList && this.inventoryDetailList.length > 0;
		},
		/**
		 * @description: 计算属性，检查库存详情列表中是否有任何行正在编辑。
		 * @returns {boolean} 如果 inventoryDetailList 中有任何行的 isEditing 为 true，则返回 true，否则返回 false。
		 */
		hasEditingRows() {
			return this.inventoryDetailList && this.inventoryDetailList.some(row => row.isEditing);
		}
	},
	/**
	 * @description: Vue 组件创建时的钩子函数。
	 *              调用 getList 方法获取库存主列表数据。
	 *              调用 listStoreHouse API 获取仓库列表，并格式化为树形结构数据。
	 */
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
	methods: {
		listStoreHouse,
		listInventory,
		listCars,
		listFleet,
		listProductLevel,
		listCompany,
		getInventoryMain, // 确保已引入
		updateInventoryMain, // 确保已引入
		// 附件更新处理
		handleAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 直接使用上传组件返回的统一附件ID数组
				this.form.params.attachmentIds = uploadParams.params.attachmentIds;
			}
		},
		/**
		 * @description: 处理文件上传组件的回调，将上传的文件路径赋值给表单的 receiveProof 字段。
		 * @param {string} val - 上传组件返回的文件路径或信息。
		 */
		handleCommitUpload(val) {
			this.form.receiveProof = val;
		},
		/**
		 * @description: 更新运输方式选择状态。
		 *              根据 isLand 和 isSea 的状态更新 form.transportMode，用于表单校验。
		 *              在下一个 tick 中触发表单字段的校验。
		 */
		updateTransportMode() {
			this.form.transportMode = this.isLand || this.isSea ? 'selected' : '';
			this.$nextTick(() => {
				if (this.$refs.form) {
					this.$refs.form.validateField('transportMode');
				}
			});
		},
		/**
		 * @description: 处理库存详情表格中行的编辑操作。
		 *              将指定行设置为编辑状态 (isEditing = true)。
		 *              如果行存在错误标记 (hasError = true)，则清除错误标记。
		 *              显示提示信息。
		 * @param {object} row - 当前操作的行数据对象。
		 */
		handleRowEdit(row) {
			// 设置当前行为可编辑
			this.$set(row, 'isEditing', true);
			// 清除错误状态
			if (row.hasError) {
				this.$set(row, 'hasError', false);
			}
			this.$message.info('正在编辑该条记录');
		},
		/**
		 * @description: 保存库存详情表格中正在编辑的行数据。
		 *              将编辑状态的行设置为非编辑状态。
		 *              调用 updateInventoryRowCalculations 重新计算相关数值。
		 *              构造包含主表单信息和所有子项的 newInventoryInfo 对象。
		 *              计算总运费等主表信息。
		 *              调用 addOrUpdateInventoryDetail 方法将数据持久化到后端。
		 * @param {object|Array<object>} row - 当前操作的行数据对象或行数据对象数组。
		 */
		handleRowSave(row) {
			// 统一处理输入，确保 rows 是数组
			const rows = Array.isArray(row) ? row : [row];
			// 处理每一行，关闭编辑状态并更新计算
			rows.forEach(r => {
				if (r.isEditing) {
					this.$set(r, 'isEditing', false); // 使用 $set 确保响应式更新
					updateInventoryRowCalculations(r, this.isSea, this.isLand);
				}
			});
			const newInventoryInfo = {
				...this.form, // 使用当前表单的主信息
				inventoryDetailList: _.cloneDeep(this.inventoryDetailList) // 包含所有子项
			};
			// 计算总运费等主表信息
			newInventoryInfo.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.landFreight || 0), 0) : 0;
			newInventoryInfo.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => Number(prev) + Number(curr.seaFreight || 0), 0) : 0;

			this.addOrUpdateInventoryDetail(newInventoryInfo, rows); // 传入原始rows用于状态更新
		},
		/**
		 * @description: 添加或更新库存详情数据到后端。
		 *              根据主表单是否存在 id 判断是新增还是更新操作。
		 *              调用相应的 API (addInventoryMain 或 updateInventoryMain)。
		 *              成功后，更新行的编辑状态和错误状态，显示成功消息，如果是新增則更新主表 ID，并刷新列表。
		 *              失败后，保持行的编辑状态並標記錯誤，顯示錯誤消息。
		 * @param {object} newInventoryInfo - 包含主表单和库存详情列表的对象。
		 * @param {Array<object>} rows - 当前操作的行对象数组。
		 */
		addOrUpdateInventoryDetail(newInventoryInfo, rows) {
			const currentRows = rows; // 保存引用
			const apiCall = this.form.id ? updateInventoryMain : addInventoryMain;
			const successMessage = this.form.id ? '该行库存详情信息已修改并保存!' : '该行库存详情信息已添加并保存!';
			const errorMessage = '保存失败，请重新编辑: ';

			apiCall(newInventoryInfo)
				.then(res => {
					currentRows.forEach(row => {
						this.$set(row, 'isEditing', false); // 确认保存成功，关闭编辑状态
						if (row.hasError) {
							this.$set(row, 'hasError', false);
						}
					});
					this.$message.success(successMessage);
					// 如果是新增，更新主表ID和数据
					if (!this.form.id && res.data && res.data.id) {
						this.form.id = res.data.id;
					}
					this.getList(); // 刷新列表
				})
				.catch(error => {
					currentRows.forEach(row => {
						this.$set(row, 'isEditing', true); // 保存失败，保持编辑状态
						this.$set(row, 'hasError', true); // 添加错误标记
					});
					this.$message.error(errorMessage + (error.message || '未知错误'));
				});
		},
		/**
		 * @description: 切换库存详情的批量编辑状态。
		 *              如果 editState 为 true，则进入批量编辑模式，将所有子项设置为可编辑状态，并清除错误标记。
		 *              如果 editState 为 false，则退出批量编辑模式，保存所有正在编辑的行。
		 * @param {boolean} editState - true 表示进入编辑模式，false 表示保存并退出编辑模式。
		 */
		toggleEditDetails(editState) {
			this.isEditingDetails = editState;
			if (editState) {
				// 进入编辑模式，设置所有行为可编辑状态
				this.inventoryDetailList.forEach(row => {
					this.$set(row, 'isEditing', true);
					if (row.hasError) {
						this.$set(row, 'hasError', false);
					}
				});
				this.$message.info('已进入批量编辑模式，可以修改所有库存信息');
			} else {
				// 退出编辑模式，保存所有正在编辑的行
				if (this.hasEditingRows) {
					this.handleRowSave(this.inventoryDetailList.filter(row => row.isEditing));
				} else {
					this.$message.info('没有需要保存的更改');
				}
			}
		},
		/**
		 * @description: 获取表格行的类名，用于标记错误行或编辑中的行。
		 * @param {object} param - Element UI 表格传递的参数，包含当前行数据 { row }。
		 * @returns {string} 行的 CSS 类名 ('error-row', 'editing-row', 或空字符串)。
		 */
		getRowClassName({ row }) {
			if (row.hasError) {
				return 'error-row';
			} else if (row.isEditing) {
				return 'editing-row';
			}
			return '';
		},
		/**
		 * @description: 处理出厂片数输入变化事件。
		 *              将出厂片数 (pieces) 的值赋给实际入库片数 (stockNumber)。
		 *              调用 recalculateAll 方法重新计算相关数值。
		 * @param {object} scope - 当前行的作用域对象。
		 */
		handlePiecesChange(scope) {
			// 将出厂片数的值赋给实际片数
			scope.row.stockNumber = scope.row.pieces;
			// 触发重新计算
			this.recalculateAll(scope);
		},
		/**
		 * @description: 格式化片数值，最多保留两位小数
		 * @param {number} value 需要格式化的数值
		 * @returns {string} 格式化后的字符串
		 */
		formatPiecesValue(value) {
			if (value === null || value === undefined || value === '') {
				return '';
			}

			const num = Number(value);
			if (isNaN(num)) {
				return '';
			}

			// 如果是整数，直接返回整数字符串
			if (num % 1 === 0) {
				return num.toString();
			}

			// 否则最多保留两位小数，去掉末尾的0
			return parseFloat(num.toFixed(2)).toString();
		},
		/**
		 * @description: 根据每包片数和包数计算总出厂片数和入库量。
		 *              如果每包片数和包数都大于0，则计算 pieces = piecesPerPack * packs。
		 *              设置 stockNumber 等于计算出的 pieces。
		 *              调用 recalculateAll 方法重新计算相关数值。
		 * @param {object} row - 当前操作的行数据对象。
		 */
		calculatePieces(row) {
			if (row.piecesPerPack > 0 && row.packs > 0) {
				// 计算出厂片数
				const result = row.piecesPerPack * row.packs;
				// 格式化为最多两位小数
				row.pieces = this.formatPiecesValue(result);
				// 设置入库量等于出厂片数
				row.stockNumber = row.pieces;
				// 触发重新计算
				this.recalculateAll({ row });
			}
		},
		/**
		 * @description: 处理库存主记录的审核操作。
		 *              弹出确认框，用户确认后调用 auditInventory API 将记录标记为已审核。
		 *              成功后刷新列表，失败则提示错误。
		 * @param {object} row - 当前操作的行数据对象。
		 */
		handleCheck(row) {
			this.$antdconfirm({
				title: '提示',
				content: '是否审核该信息?',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						await auditInventory({ id: row.id, isaudit: true });
						this.$message.success('操作成功~!');
						this.getList();
					} catch {
						this.$message.error('审核失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消审核操作');
				}
			});
		},
		/**
		 * @description: 处理库存主记录的取消审核操作。
		 *              弹出确认框，用户确认后调用 auditInventory API 将记录标记为未审核。
		 *              成功后刷新列表。
		 * @param {object} row - 当前操作的行数据对象。
		 */
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
		/**
		 * @description: 计算表格的合计行数据。
		 *              针对指定的列 (paymentFactory, payments, tonnage, landFreight, seaFreight, freight, profit, profitNoTax) 进行合计。
		 *              使用 fix 方法格式化合计结果。
		 * @param {object} param - Element UI 表格传递的参数，包含列配置 { columns } 和数据 { data }。
		 * @returns {Array<string|number>} 计算得到的合计行数据数组。
		 */
		getSummary(param) {
			const { columns, data } = param;
			const sums = [];
			const summaryColumns = ['paymentFactory', 'payments', 'tonnage', 'landFreight', 'seaFreight', 'freight', 'profit', 'profitNoTax'];

			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				if (summaryColumns.includes(column.property)) {
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
						sums[index] += column.property === 'tonnage' ? ' 吨' : ' 元';
					} else {
						sums[index] = 'N/A';
					}
				}
			});

			return sums;
		},
		/**
		 * @description: 更新供应商搜索组件的查询关键字。
		 * @param {string} value - 新的查询关键字。
		 */
		handleUpdateQuerySupplier(value) {
			this.querySupplier = value;
		},
		/**
		 * @description: 更新产品级别搜索组件的查询关键字。
		 * @param {string} value - 新的查询关键字。
		 */
		handleUpdateQueryNameLevel(value) {
			this.queryLevel = value;
		},
		/**
		 * @description: 处理供应商选择后的回调，更新行数据中的供应商信息。
		 *              调用 clearDetail 清空相关字段。
		 *              设置 scope.row.supplier 和 scope.row.supplierId。
		 * @param {object} scope - 当前行的作用域对象。
		 * @param {object} val - SearchOption 组件返回的选中供应商对象。
		 */
		handleCommitBackSupplier(scope, val) {
			console.log(val);
			this.clearDetail(scope);
			scope.row.supplier = val.companyName;
			scope.row.supplierId = val.id;
		},
		/**
		 * @description: 处理产品级别选择后的回调，更新行数据中的产品级别相关信息。
		 *              设置 scope.row 中的 erro, levelID, levelName, height, length, width, levelNo。
		 *              调用 recalculateAll 重新计算相关数值。
		 * @param {object} scope - 当前行的作用域对象。
		 * @param {object} val - SearchOption 组件返回的选中产品级别对象。
		 */
		handleCommitBackProductLevel(scope, val) {
			scope.row.erro = val.tonnage;
			scope.row.levelID = val.id;
			scope.row.levelName = val.levelName;
			scope.row.height = val.height;
			scope.row.length = val.length;
			scope.row.width = val.width;
			scope.row.levelNo = val.levelNo;

			// 填充后重新计算
			this.recalculateAll(scope); // 确保调用 recalculateAll
		},
		/**
		 * @description: 重新计算当前行库存详情的所有相关数值。
		 *              在 Vue 的 nextTick 中执行 updateInventoryRowCalculations，以确保数据绑定更新后再计算。
		 * @param {object} scope - 当前行的作用域对象。
		 */
		recalculateAll(scope) {
			// 确保在 nextTick 中执行，以允许 Vue 更新 DOM/数据绑定
			this.$nextTick(() => {
				updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
			});
		},
		/**
		 * @description: 处理车队选择后的回调，更新表单中的车队名称。
		 *              设置 this.form.fleet。
		 *              手动触发表单字段 'fleet' 的校验。
		 * @param {object} val - SearchOption 组件返回的选中车队对象。
		 */
		handleCommitBackFleet(val) {
			this.form.fleet = val.fname;
			// 手动触发 fleet 字段的校验
			this.$refs.form.validateField('fleet');
		},
		handleChangeFleet(val) {
			this.queryFleet = val;
		},
		/**
		 * @description: 处理陆运车辆选择后的回调，更新表单中的陆运车辆相关信息。
		 *              设置 this.form 中的 landCarID, landCarNo, landDriverName, landDriverTel, landBankNo, landBankName。
		 *              在 Vue 的 nextTick 中手动触发表单字段 'landCarNo' 的校验。
		 * @param {object} val - SearchOption 组件返回的选中车辆对象。
		 */
		handleCommitBackCar(val) {
			this.form.landCarID = val.id;
			this.form.landCarNo = val.carNo;
			this.form.landDriverName = val.driver;
			this.form.landDriverTel = val.tel;
			this.form.landBankNo = val.bankNo;
			this.form.landBankName = val.bankName;
			// 手动触发 landCarNo 字段的校验
			this.$nextTick(() => {
				this.$refs.form.validateField('landCarNo');
			});
		},
		/**
		 * @description: 处理左侧仓库树节点的点击事件。
		 *              根据点击的仓库名称 (data.label) 筛选并显示对应的库存主列表数据。
		 * @param {object} data - 被点击的树节点数据对象。
		 */
		handleNodeClick(data) {
			this.loading = true;
			listInventoryMain({ storeHouseName: data.label }).then(res => {
				this.inventoryMainList = res.rows;
				this.loading = false;
			});
		},
		/**
		 * @description: 获取库存主列表数据。
		 *              设置 loading 状态为 true。
		 *              调用 listInventoryMain API，并传入 queryParams。
		 *              成功后更新 inventoryMainList 和 total，设置 loading 状态为 false。
		 */
		getList() {
			this.loading = true;
			listInventoryMain(this.queryParams).then(response => {
				this.inventoryMainList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		/**
		 * @description: 取消添加或修改库存操作。
		 *              关闭弹窗 (this.open = false)。
		 *              调用 reset 方法重置表单。
		 *              重置全局编辑状态 (this.isEditingDetails = false)。
		 */
		cancel() {
			// 清空附件上传组件
			if (this.$refs.attachmentUploader) {
				this.$refs.attachmentUploader.clearUploadedFiles();
			}
			this.open = false;
			this.reset();
			this.isEditingDetails = false; // 重置编辑状态
		},
		/**
		 * @description: 重置表单数据到初始状态。
		 *              重置 isSea, isLand 状态。
		 *              重置 this.form 对象中的各个字段。
		 *              清空 inventoryDetailList。
		 *              重置 isEditingDetails 状态。
		 *              如果表单引用存在，则调用其 resetFields 和 clearValidate 方法。
		 */
		reset() {
			this.isSea = false;
			this.isLand = false;
			this.form = {
				id: null,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: parseTime(new Date()),
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				landBankNo: null,
				landBankName: null,
				fleet: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				seaBankNo: null,
				seaBankName: null,
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
				transportMode: '', // 重置运输方式校验字段
				params: {
					attachmentIds: []
				}
			};
			this.inventoryDetailList = [];
			this.isEditingDetails = false; // 重置编辑状态
			// 清空附件上传组件
			if (this.$refs.attachmentUploader) {
				this.$refs.attachmentUploader.clearUploadedFiles();
			}
			if (this.$refs.form) {
				this.$refs.form.resetFields();
				this.$refs.form.clearValidate();
			}
		},
		/**
		 * @description: 清空指定行库存详情的各项数据。
		 *              (目前主要在 handleCommitBackSupplier/ProductLevel 中直接设置，此方法可用于特定场景)
		 *              重置行内字段，并调用 recalculateAll 重新计算。
		 * @param {object} scope - 当前行的作用域对象。
		 */
		clearDetail(scope) {
			// 可以保留此方法用于特定场景，或者在 handleCommitBackSupplier/ProductLevel 中直接设置
			// 注意：清除时可能需要重置 isEditing 和 hasError 状态
			const defaultRow = {
				// ... 默认值 ...
				isEditing: scope.row.isEditing, // 保留编辑状态？或设为true？
				hasError: false
			};
			Object.assign(scope.row, defaultRow);
			this.recalculateAll(scope); // 清除后重新计算
		},
		/**
		 * @description: 设置当前操作的类型 (例如：'supplier', 'warehouse')，用于 SearchOption 组件的上下文。
		 * @param {object} row - 当前行的数据对象。
		 * @param {string} type - 操作类型。
		 */
		setCurrentType(row, type) {
			this.$set(row, 'currentType', type);
		},
		/**
		 * @description: 处理搜索按钮操作。
		 *              设置 queryParams.pageNum 为 1。
		 *              调用 getList 方法重新获取列表数据。
		 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/**
		 * @description: 处理重置搜索按钮操作。
		 *              调用 resetForm 方法重置搜索表单。
		 *              调用 handleQuery 方法重新获取列表数据。
		 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		/**
		 * @description: 处理主列表表格选择项变化事件。
		 *              更新 ids 数组，以及 single 和 multiple 状态。
		 * @param {Array<object>} selection - 当前选中的行对象数组。
		 */
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/**
		 * @description: 处理新增库存按钮操作。
		 *              调用 reset 方法重置表单。
		 *              打开弹窗 (this.open = true)。
		 *              设置弹窗 标题为 '添加库存'。
		 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加库存';
		},
		/**
		 * @description: 处理查看库存详情按钮操作。
		 *              如果行 ID 不存在，则提示错误。
		 *              调用 getInventoryMain API 获取完整的库存信息。
		 *              成功后，使用 common_dialog mixin 中的 openDialog 方法打开库存详情弹窗。
		 * @param {object} row - 当前操作的行数据对象。
		 */
		handleCheckInventory(row) {
			if (!row.id) {
				this.$message.error('该行信息有误!');
				return;
			}
			getInventoryMain(row.id).then(response => {
				this.openDialog(
					INVENTORY,
					'库存信息',
					'1300px',
					{
						needToShowInfo: response.data
					},
					false
				);
			});
		},
		/**
		 * @description: 处理修改库存按钮操作。
		 *              调用 reset 方法重置表单。
		 *              获取要修改的记录 ID (来自行数据或多选)。
		 *              调用 getInventoryMain API 获取库存主表及其子项数据。
		 *              成功后，填充 this.form，并根据返回数据设置 isSea 和 isLand 状态。
		 *              初始化 inventoryDetailList，并为每个子项设置 isEditing 和 hasError 状态。
		 *              对加载的子项数据进行一次初始计算。
		 *              打开弹窗，设置标题，并重置全局编辑状态。
		 * @param {object} row - 当前操作的行数据对象。
		 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getInventoryMain(id).then(response => {
				this.form = {
					...response.data,
					params: {
						...response.data.params,
						attachmentIds: response.data.attachmentList ? response.data.attachmentList.map(item => item.id) : []
					}
				};
				this.isSea = !!response.data.seaCarNo; // 使用主表信息判断
				this.isLand = !!response.data.landCarNo; // 使用主表信息判断

				// 确保设置 transportMode 字段以通过校验
				this.form.transportMode = this.isLand || this.isSea ? 'selected' : '';

				// 初始化子项的编辑状态
				this.inventoryDetailList = response.data.inventoryDetailList.map(item => ({
					...item,
					isEditing: false, // 初始为非编辑状态
					hasError: false // 初始无错误
				}));
				// 对加载的数据进行计算
				this.inventoryDetailList.forEach(detailRow => {
					this.$nextTick(() => {
						updateInventoryRowCalculations(detailRow, this.isSea, this.isLand);
					});
				});

				this.open = true;
				this.title = '修改库存';
				this.isEditingDetails = false; // 初始不进入全局编辑模式
			});
		},
		/**
		 * @description: 提交添加或修改库存表单。
		 *              强制校验运输方式。
		 *              触发表单校验 (this.$refs['form'].validate)。
		 *              校验通过后，再次确认运输方式已选择。
		 *              检查是否有未保存的子项或子项列表为空。
		 *              深拷贝 inventoryDetailList 到 this.form.inventoryDetailList。
		 *              计算总陆运费和总海运费。
		 *              根据 this.form.id 判断是新增还是更新，调用相应的 API。
		 *              成功后显示成功消息，关闭弹窗，刷新列表，重置编辑状态。
		 *              失败则显示错误消息。
		 */
		submitForm() {
			// 强制再次校验运输方式
			if (!this.isLand && !this.isSea) {
				this.form.transportMode = ''; // 确保值为空触发校验
				this.$refs.form.validateField('transportMode');
				return; // 阻止继续提交
			}

			this.$refs['form'].validate(valid => {
				if (valid) {
					// 再次确认运输方式已选择
					if (!this.isLand && !this.isSea) {
						this.$message.error('请至少选择一种运输方式');
						return;
					}

					// 检查是否有未保存的子项
					if (this.inventoryDetailList.some(item => item.isEditing)) {
						this.$message.error('当前库存信息中有未保存的项,请先保存或取消编辑后再提交!');
						return;
					}
					if (this.inventoryDetailList.length === 0) {
						this.$message.error('请添加库存明细');
						return;
					}
					this.form.inventoryDetailList = _.cloneDeep(this.inventoryDetailList);
					this.form.allLandFreight = this.isLand ? this.inventoryDetailList.reduce((prev, curr) => fix(Number(prev) + Number(curr.landFreight || 0)), 0) : 0;
					this.form.allSeaFreight = this.isSea ? this.inventoryDetailList.reduce((prev, curr) => fix(Number(prev) + Number(curr.seaFreight || 0)), 0) : 0;
					const apiCall = this.form.id ? updateInventoryMain : addInventoryMain;
					const successMessage = this.form.id ? '修改成功' : '新增成功';
					apiCall({
						...this.form,
						params: {
							attachmentIds: this.form.params?.attachmentIds || []
						}
					})
						.then(() => {
							this.$modal.msgSuccess(successMessage);
							this.open = false;
							this.getList();
							this.isEditingDetails = false; // 关闭弹窗时重置编辑状态
							// 清空附件上传组件
							if (this.$refs.attachmentUploader) {
								this.$refs.attachmentUploader.clearUploadedFiles();
							}
						})
						.catch(error => {
							this.$message.error('提交失败: ' + (error.message || '未知错误'));
						});
				} else {
					this.$message.error('请检查表单必填项!');
				}
			});
		},
		/**
		 * @description: 处理删除库存主表记录按钮操作。
		 *              获取要删除的记录 ID (来自行数据或多选)。
		 *              弹出确认框，用户确认后调用 delInventoryMain API 删除数据。
		 *              成功后刷新列表并显示成功消息。
		 * @param {object} row - 当前操作的行数据对象。
		 */
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
		/**
		 * @description: 为库存子表行提供序号。
		 * @param {object} param - Element UI 表格传递的参数，包含当前行数据 { row } 和行索引 { rowIndex }。
		 */
		rowInventoryDetailIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		/**
		 * @description: 处理添加库存子项按钮操作。
		 *              创建一个包含默认值的子项对象 obj，并设置 isEditing 为 true。
		 *              将 obj添加到 inventoryDetailList。
		 *              在 Vue 的 nextTick 中，如果子表引用存在，则滚动到表格底部。
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
				paymentsWithSundry: '',
				additionalFees: '',
				factoryCommission: '', // 添加厂家佣金
				factoryRebateAmount: '', // 添加返利金额
				factoryDiscountAmount: '', // 添加降价金额
				comments: '',
				isEditing: true, // 新增：默认处于编辑状态
				hasError: false // 新增：默认无错误
			};
			this.inventoryDetailList.push(obj);
			// 可能需要滚动到底部或新行
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
		 * @description: 处理删除库存子项按钮操作。
		 *              如果 checkedInventoryDetail 为空，则提示用户先选择。
		 *              否则，根据 checkedInventoryDetail 中的索引过滤 inventoryDetailList，移除选中的行。
		 *              清空 checkedInventoryDetail，并清除表格的选中状态。
		 *              显示删除成功消息。
		 */
		handleDeleteInventoryDetail() {
			if (this.checkedInventoryDetail.length == 0) {
				this.$modal.msgError('请先选择要删除的库存子数据');
			} else {
				// 获取选中的行的实际对象，而不是索引
				const selectedRows = this.inventoryDetailList.filter((item, index) => this.checkedInventoryDetail.includes(index + 1)); // index从1开始

				// 从 inventoryDetailList 中移除这些选中的行
				this.inventoryDetailList = this.inventoryDetailList.filter((item, index) => !this.checkedInventoryDetail.includes(index + 1));

				// 清空选中项
				this.checkedInventoryDetail = [];
				if (this.$refs.inventoryDetail) {
					this.$refs.inventoryDetail.clearSelection();
				}
				this.$message.success('删除成功');
				// 注意：如果需要立即持久化删除，需要调用API更新主表
			}
		},
		/**
		 * @description: 处理库存子表选择项变化事件。
		 *              更新 checkedInventoryDetail 数组，存储选中行的索引 (从1开始)。
		 * @param {Array<object>} selection - 当前选中的行对象数组。
		 */
		handleInventoryDetailSelectionChange(selection) {
			// 更新选中的行的索引列表 (注意 index 是从1开始的)
			this.checkedInventoryDetail = selection.map(item => this.inventoryDetailList.findIndex(listItem => listItem === item) + 1);
		},
		/**
		 * @description: 处理导出库存主列表数据按钮操作。
		 *              调用 download 方法，请求 'system/inventoryMain/export' 接口导出数据。
		 */
		handleExport() {
			this.download(
				'system/inventoryMain/export',
				{
					...this.queryParams
				},
				`inventoryMain_${new Date().getTime()}.xlsx`
			);
		},
		/**
		 * @description: 格式化价格输入，控制小数位数
		 * @param {object} row - 当前行数据
		 * @param {string} field - 字段名
		 * @param {number} precision - 小数位数
		 * @param {boolean} control - 是否控制输入
		 */
		formatPriceInput(row, field, precision, control = true) {
			if (control) {
				if (row[field] && !isNaN(row[field])) {
					row[field] = Number(row[field]).toFixed(precision);
				}
			} else {
				// 如果小数位不超过四位 那么不做处理 如果超过四位 需要精确到四位
				if (this.getDecimalPlaces(row[field]) > 4) {
					row[field] = parseFloat(row[field]).toFixed(4);
				}
			}
		},
		/**
		 * @description: 获取数字的小数位数
		 * @param {number|string} num 数字
		 * @returns {number} 小数位数
		 */
		getDecimalPlaces(num) {
			if (!num || isNaN(num)) return 0;
			const str = String(num);
			if (str.indexOf('.') === -1) return 0;
			return str.split('.')[1].length;
		},
		/**
		 * @description: 处理片数输入，限制最多两位小数
		 * @param {object} row 当前行数据
		 * @param {string} field 字段名
		 * @param {string} value 输入值
		 * @param {function} callback 回调函数
		 */
		handlePiecesInput(row, field, value, callback) {
			// 允许输入数字和小数点
			let sanitizedValue = value.replace(/[^\d.]/g, '');

			// 只允许一个小数点
			const parts = sanitizedValue.split('.');
			if (parts.length > 2) {
				sanitizedValue = parts[0] + '.' + parts.slice(1).join('');
			}

			// 限制小数点后最多2位
			if (parts.length === 2 && parts[1].length > 2) {
				sanitizedValue = parts[0] + '.' + parts[1].slice(0, 2);
			}

			// 更新行数据
			row[field] = sanitizedValue;

			// 执行回调函数
			if (callback) {
				callback();
			}
		}
	}
};
</script>

<style scoped>
.el-table {
	.el-button {
		margin: 0 5px;
	}
}

::v-deep .editing-row {
	td:first-child {
		border-left: 9px solid #63f697 !important;
	}
}

::v-deep .error-row {
	td:first-child {
		border-left: 9px solid #f56c6c !important;
	}

	td {
		animation: errorPulse 2s infinite;
	}
}

.transport-error {
	color: #f56c6c;
	margin-left: 10px;
	font-size: 12px;
}

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
</style>
