<template>
	<div class="app-container">
		<el-form id="top-search-form-item" :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="150">
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" class="input-standard" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="入库日期" prop="storeDate">
				<el-date-picker v-model="queryParams.storeDate" type="date" value-format="yyyy-MM-dd" placeholder="选择入库日期" clearable />
			</el-form-item>
			<el-form-item label="陆运车牌" prop="landCarNo">
				<el-input v-model="queryParams.landCarNo" class="input-standard" placeholder="请输入陆运车牌" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="陆运司机电话" prop="landDriverTel">
				<el-input v-model="queryParams.landDriverTel" class="input-standard" placeholder="请输入陆运司机电话" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="陆地司机姓名" prop="landDriverName">
				<el-input v-model="queryParams.landDriverName" class="input-standard" placeholder="请输入陆地司机姓名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="海运公司" prop="seaDriverName">
				<el-input v-model="queryParams.seaDriverName" class="input-standard" placeholder="请输入海运公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #left>
					<el-row :gutter="10">
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
					</el-row>
				</template>
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

		<!-- 使用 DragDiv 组件替换原来的 el-col 布局 -->
		<div style="height: 800px">
			<DragDiv :initial-left-width="300" :min-left-width="200" :min-right-width="400" :divider-width="6" @drag-start="handleDragStart" @dragging="handleDragging" @drag-end="handleDragEnd">
				<!-- 左侧：仓库树 -->
				<template #left>
					<div class="tree-container" style="height: 100%; padding: 10px; background: #fafafa; border: 1px solid #e6e6e6; display: flex; flex-direction: column">
						<div style="margin-bottom: 10px; font-weight: bold; color: #333">仓库列表</div>
						<div style="flex: 1; overflow-y: auto; margin-bottom: 10px">
							<el-tree :data="storeList" :props="defaultProps" @node-click="handleNodeClick" />
						</div>
						<!-- 仓库分页组件 -->
						<div style="padding: 5px 0; border-top: 1px solid #e6e6e6">
							<el-pagination
								small
								background
								layout="total, sizes, prev, pager, next"
								:total="storeTotal"
								:page-size="storePageParams.pageSize"
								:current-page="storePageParams.pageNum"
								:page-sizes="[20, 50, 100]"
								@size-change="handleStoreSizeChange"
								@current-change="handleStoreCurrentChange"
								style="text-align: center"
							/>
						</div>
					</div>
				</template>

				<!-- 右侧：数据表格 -->
				<template #right>
					<div style="height: 100%; display: flex; flex-direction: column">
						<u-table
							border
							id="printBox"
							size="mini"
							v-loading="loading"
							:data="inventoryMainList"
							@selection-change="handleSelectionChange"
							stripe
							style="flex: 1; margin-bottom: 20px"
							:height="'100%'"
							show-summary
							:summary-method="getMainTableSummary"
						>
							<CustomTableColumn type="selection" width="50" align="center" />
							<CustomTableColumn v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" />
							<CustomTableColumn v-if="columns[1].visible" label="仓库名称" align="center" prop="storeHouseName" width="150" />
							<CustomTableColumn v-if="columns[2].visible" label="变动日期(入库)" align="center" prop="storeDate" width="150" />
							<CustomTableColumn v-if="columns[3].visible" label="供应商" align="center" prop="supplier" width="150">
								<template #default="scope">
									<div class="supplier-container">
										<!-- 显示预处理的供应商列表 -->
										<span v-for="supplier in scope.row._uniqueSuppliers" :key="`supplier-${supplier.supplierId}`" class="supplier-name">
											{{ supplier.supplier }}
										</span>
										<!-- 如果没有供应商，显示横线 -->
										<span v-if="scope.row._uniqueSuppliers.length === 0" class="empty-item">-</span>
									</div>
								</template>
							</CustomTableColumn>
							<CustomTableColumn v-if="columns[4].visible" label="货物来源公司" align="center" prop="goodsCompany" width="180" />
							<!-- 修改审核状态列 -->
							<CustomTableColumn v-if="columns[5].visible" label="审核状态" align="center" prop="checkState" width="150">
								<template #default="scope">
									<el-row v-if="scope.row.checkState === '已审核'">
										<!-- 只有具有财务或超级管理员权限的用户可以取消审核 -->
										<StateTag
											:state-title="scope.row.checkState"
											:state-mapper="{ 2: '已审核' }"
											@click.native="hasAuditPermission() && handleReCheck(scope.row)"
											:style="{ cursor: hasAuditPermission() ? 'pointer' : 'default' }"
										/>
									</el-row>
									<el-row v-else>
										<el-row>
											<!-- 只有具有财务或超级管理员权限的用户可以审核 -->
											<el-button v-if="hasAuditPermission()" type="text" size="mini" @click="handleCheck(scope.row)">审核</el-button>
											<!-- 其他用户显示状态文本 -->
											<span v-else style="color: #909399; font-size: 12px">待审核</span>
										</el-row>
									</el-row>
								</template>
							</CustomTableColumn>

							<CustomTableColumn v-if="columns[6].visible" label="陆运车牌" align="center" prop="landCarNo" width="120" />
							<CustomTableColumn v-if="columns[7].visible" label="陆运司机电话" align="center" prop="landDriverTel" width="150" />
							<CustomTableColumn v-if="columns[8].visible" label="陆地司机姓名" align="center" prop="landDriverName" width="120" />
							<CustomTableColumn v-if="columns[9].visible" label="陆运银行卡号" align="center" prop="landBankNo" width="120" />
							<CustomTableColumn v-if="columns[10].visible" label="陆运银行户名" align="center" prop="landBankName" width="120" />
							<CustomTableColumn v-if="columns[11].visible" label="柜号" align="center" prop="seaCarNo" width="120" />
							<CustomTableColumn v-if="columns[12].visible" label="海运司机电话" align="center" prop="seaDriverTel" width="150" />
							<CustomTableColumn v-if="columns[13].visible" label="海运公司" align="center" prop="seaDriverName" width="120" />
							<CustomTableColumn v-if="columns[14].visible" label="海运银行卡号" align="center" prop="seaBankNo" width="120" />
							<CustomTableColumn v-if="columns[15].visible" label="海运银行户名" align="center" prop="seaBankName" width="120" />
							<CustomTableColumn v-if="columns[16].visible" label="子项陆运费之和" align="center" prop="allLandFreight" width="150" />
							<CustomTableColumn v-if="columns[17].visible" label="子项海运费之和" align="center" prop="allSeaFreight" />
							<CustomTableColumn v-if="columns[18].visible" label="录入人员" align="center" prop="userName" width="120" />
							<CustomTableColumn v-if="columns[19].visible" label="附件" align="center" prop="path" width="150" fixed="right">
								<template #default="scope">
									<div v-if="Array.isArray(scope.row.attachmentList)">
										<CheckFiles
											:attachmentList="scope.row.attachmentList"
											:flag="'path'"
											@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInventoryMain, updateInventoryMain)"
										/>
									</div>
									<div v-else>
										<el-tag type="danger">加载错误</el-tag>
									</div>
								</template>
							</CustomTableColumn>
							<CustomTableColumn v-if="columns[20].visible" label="收到条附件" align="center" prop="receiveProof" width="150" fixed="right">
								<template #default="scope">
									<div v-if="Array.isArray(scope.row.attachmentList)">
										<CheckFiles
											:attachmentList="scope.row.attachmentList"
											:flag="'receiveProof'"
											@needToUpdate="value => handleUpdateFilePath(value, scope.row, getInventoryMain, updateInventoryMain)"
										/>
									</div>
									<div v-else>
										<el-tag type="danger">加载错误</el-tag>
									</div>
								</template>
							</CustomTableColumn>
							<CustomTableColumn v-if="columns[21].visible" label="操作" align="center" width="250" fixed="right">
								<template slot-scope="scope">
									<el-button size="mini" type="text" icon="el-icon-edit" @click="handleCheckInventory(scope.row)">查看</el-button>
									<el-tooltip effect="light" v-if="isInventoryDisabledModify(scope.row)" placement="top">
										<template #content>
											<div>该货物为二次入库货物，请在存货二次加工管理处修改</div>
										</template>
										<el-button :disabled="true" size="mini" type="text" icon="el-icon-edit" v-hasPermi="['system:inventoryMain:edit']">修改</el-button>
									</el-tooltip>
									<el-button
										v-else
										:disabled="isInventoryDisabledModify(scope.row)"
										size="mini"
										type="text"
										icon="el-icon-edit"
										@click="handleUpdate(scope.row)"
										v-hasPermi="['system:inventoryMain:edit']"
									>
										修改
									</el-button>
									<el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['system:inventoryMain:remove']">删除</el-button>
								</template>
							</CustomTableColumn>
						</u-table>
						<pagination
							v-show="total > 0"
							:total="total"
							:page.sync="queryParams.pageNum"
							:limit.sync="queryParams.pageSize"
							@pagination="getList"
							style="margin-top: 10px; text-align: right"
						/>
					</div>
				</template>
			</DragDiv>
		</div>

		<!-- 添加或修改库存库存主表对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="1600px" append-to-body :close-on-click-modal="false">
			<el-form ref="form" :model="form" :rules="rules" label-width="100px" :inline="true">
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
								<CustomTableColumn label="仓库名称" align="center" prop="storeHouseName" />
								<CustomTableColumn label="地址" align="center" prop="address" />
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
				<!-- <el-form-item label="录入人员" prop="userName">
					<el-input size="mini" v-model="form.userName" placeholder="请输入录入人员" />
				</el-form-item> -->
				<el-form-item label="附件">
					<UploadFilesButton
						ref="attachmentsUploader"
						flag="path"
						:extra-info="{ moduleType: 'inventoryMain', formId: form.id }"
						:initial-attachments="filteredPathAttachments"
						@files-updated="handleAttachmentsFilesUpdated"
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
										<CustomTableColumn label="车牌" align="center" prop="carNo" />
										<CustomTableColumn label="司机" align="center" prop="driver" />
										<CustomTableColumn label="司机电话" align="center" prop="tel" />
										<CustomTableColumn label="开户名" align="center" prop="acountsName" />
										<CustomTableColumn label="账号" align="center" prop="bankNo" />
										<CustomTableColumn label="开户行" align="center" prop="bankName" />
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
										<CustomTableColumn label="车队名称" align="center" prop="fname" />
										<CustomTableColumn label="车队经理" align="center" prop="fleader" />
										<CustomTableColumn label="车队经理电话" align="center" prop="tel" />
										<CustomTableColumn label="地址" align="center" prop="address" />
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
										<CustomTableColumn label="车牌" align="center" prop="carNo" />
										<CustomTableColumn label="司机" align="center" prop="driver" />
										<CustomTableColumn label="司机电话" align="center" prop="tel" />
										<CustomTableColumn label="开户名" align="center" prop="acountsName" />
										<CustomTableColumn label="账号" align="center" prop="bankNo" />
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
					border
					size="mini"
					:data="inventoryDetailList"
					show-summary
					:summary-method="getSummary"
					:row-class-name="getRowClassName"
					@selection-change="handleInventoryDetailSelectionChange"
					ref="inventoryDetail"
				>
					<el-table-column type="selection" width="50" align="center" :selectable="() => true" />
					<el-table-column label="序号" align="center" prop="id" width="50" />
					<el-table-column label="行操作" align="center" width="100">
						<template slot-scope="scope">
							<el-button v-if="!scope.row.isEditing" :disabled="!isEditingDetails" size="mini" type="warning" icon="el-icon-edit" @click="handleRowEdit(scope.row)">编辑</el-button>
							<el-button v-else size="mini" type="success" icon="el-icon-check" @click="handleRowSave(scope.row)">保存</el-button>
						</template>
					</el-table-column>
					<el-table-column label="供应商" width="220" align="center">
						<template #default="scope">
							<el-row>
								<el-col :span="12">
									<el-input disabled size="mini" v-model="scope.row.supplier" placeholder="请选择" />
								</el-col>
								<el-col :span="4">
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
											<CustomTableColumn label="公司名称" align="center" prop="companyName" />
											<CustomTableColumn label="销售经理" align="center" prop="salesManager" />
											<CustomTableColumn label="联系人" align="center" prop="relationName" />
											<CustomTableColumn label="电话" align="center" prop="relationTel" />
											<CustomTableColumn label="地址" align="center" prop="address" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</template>
					</el-table-column>

					<el-table-column label="级别名称" prop="levelName" width="150">
						<template #default="scope">
							<el-col :span="12">
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
										<CustomTableColumn label="级别编码" align="center" prop="levelNo" />
										<CustomTableColumn label="级别名称" align="center" prop="levelName" />
										<CustomTableColumn label="分类编号" align="center" prop="categoryNo" />
										<CustomTableColumn label="分类名称" align="center" prop="categoryName" />
										<CustomTableColumn label="厚度" align="center" prop="height" />
										<CustomTableColumn label="长度" align="center" prop="length" />
										<CustomTableColumn label="宽度" align="center" prop="width" />
										<CustomTableColumn label="误差" align="center" prop="tonnage" />
									</template>
								</SearchOption>
							</el-col>
						</template>
					</el-table-column>
					<el-table-column label="计量单位" prop="countingUnit" width="60" class-name="counting-unit-column">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!scope.row.isEditing" @change="() => recalculateAll(scope)" class="vertical-radio-group">
								<el-radio label="片" class="vertical-radio">片数</el-radio>
								<el-radio label="其他" class="vertical-radio">其他</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="厚度" prop="height" width="60">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.height" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="长度" prop="length" width="60">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.length" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="宽度" prop="width" width="60">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.width" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="每包片数" prop="piecesPerPack" width="90">
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
					<el-table-column label="包数" prop="packs" width="90">
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

					<el-table-column label="出厂片数" prop="pieces" width="90">
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

					<el-table-column label="出厂单价" prop="price" width="90">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.price"
								@input="val => handlePriceInput(scope.row, 'price', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'price')"
								@blur="() => formatPriceInput(scope.row, 'price', 2, false)"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="!scope.row.isEditing || !scope.row.pieces"
							/>
						</template>
					</el-table-column>
					<el-table-column label="是否含税" prop="isIncludeTaxFactory" width="60" class-name="tax-column">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" class="vertical-tax-radio-group">
								<el-radio :label="1" class="vertical-tax-radio">是</el-radio>
								<el-radio :label="0" class="vertical-tax-radio">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="杂费" prop="sundryCost" width="60">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.sundryCost"
								@input="val => handlePriceInput(scope.row, 'sundryCost', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'sundryCost')"
								@blur="() => formatPriceInput(scope.row, 'sundryCost', 2)"
								:placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'"
								:disabled="!scope.row.isEditing || !scope.row.price"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="70">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.paymentFactory" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="入库量" prop="stockNumber" width="70">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.stockNumber" placeholder="入库时片数" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="存货价" prop="paymentUnload" width="70">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.paymentUnload"
								@input="val => handlePriceInput(scope.row, 'paymentUnload', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'paymentUnload')"
								@blur="() => formatPriceInput(scope.row, 'paymentUnload', 2, false)"
								placeholder="请输入存货价"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="是否含税" prop="isIncludeTaxSale" width="60" class-name="tax-column">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" class="vertical-tax-radio-group">
								<el-radio :label="1" class="vertical-tax-radio">是</el-radio>
								<el-radio :label="0" class="vertical-tax-radio">否</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>

					<el-table-column label="库存金额" prop="payments" width="70">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.payments" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="误差" prop="erro" width="70">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" disabled />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="70">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.tonnage" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="陆运费单价" prop="landFreightPrice" width="90" v-if="isLand">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.landFreightPrice"
								@input="val => handlePriceInput(scope.row, 'landFreightPrice', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'landFreightPrice')"
								@blur="() => formatPriceInput(scope.row, 'landFreightPrice', 2)"
								placeholder="请输入陆运费单价"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="70">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="val => handlePriceInput(scope.row, 'additionalFees', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'additionalFees')"
								@blur="() => formatPriceInput(scope.row, 'additionalFees', 2)"
								:placeholder="!scope.row.landFreightPrice ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="70" v-if="isLand">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.landFreight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="海运费" prop="seaFreight" width="70" v-if="isSea">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.seaFreight"
								@input="val => handlePriceInput(scope.row, 'seaFreight', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'seaFreight')"
								@blur="() => formatPriceInput(scope.row, 'seaFreight', 2)"
								placeholder="请输入海运费"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="70">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="80">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.otherCost"
								@input="val => handlePriceInput(scope.row, 'otherCost', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'otherCost')"
								@blur="() => formatPriceInput(scope.row, 'otherCost', 2)"
								placeholder="请输入其他费用"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="利润" prop="profit" width="70">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profit" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="不含税利润" prop="profitNoTax" width="90">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.profitNoTax" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="物流利润" prop="logisticsProfit" width="80">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.logisticsProfit"
								@input="val => handlePriceInput(scope.row, 'logisticsProfit', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'logisticsProfit')"
								@blur="() => formatPriceInput(scope.row, 'logisticsProfit', 2)"
								placeholder="请输入物流利润"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="厂家佣金" prop="factoryCommission" width="80">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryCommission"
								@input="val => handlePriceInput(scope.row, 'factoryCommission', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'factoryCommission')"
								@blur="() => formatPriceInput(scope.row, 'factoryCommission', 2)"
								placeholder="请输入厂家佣金"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="120">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryRebateAmount"
								@input="val => handlePriceInput(scope.row, 'factoryRebateAmount', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'factoryRebateAmount')"
								@blur="() => formatPriceInput(scope.row, 'factoryRebateAmount', 2)"
								placeholder="请输入计提厂家返利金额"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="120">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.factoryDiscountAmount"
								@input="val => handlePriceInput(scope.row, 'factoryDiscountAmount', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'factoryDiscountAmount')"
								@blur="() => formatPriceInput(scope.row, 'factoryDiscountAmount', 2)"
								placeholder="请输入计提厂家降价金额"
								:disabled="!scope.row.isEditing"
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
import { fix, fix_2 } from '../../../api/tool/format';
import SearchOption from '../../../components/SearchOption.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { _fill } from './fill';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import CheckFiles from '../../../components/CheckFiles.vue';
import { auditInventory } from '../../../api/system/inventoryMain';
import StateTag from '../../dashboard/components/common/StateTag.vue';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import { parseTime } from '@/utils/ruoyi';
import _ from 'lodash'; // 引入 lodash
import { updateInventoryRowCalculations } from './inventoryCalculations'; // 确保导入
import DragDiv from '@/components/DragDiv/index.vue';

export default {
	name: 'InventoryMain',
	components: { SearchOption, CheckFiles, UploadFilesButton, StateTag, DragDiv },
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
				{ key: 3, label: '供应商', visible: true },
				{ key: 4, label: '货物来源公司', visible: true },
				{ key: 5, label: '审核状态', visible: true },
				{ key: 6, label: '陆运车牌', visible: true },
				{ key: 7, label: '陆运司机电话', visible: true },
				{ key: 8, label: '陆地司机姓名', visible: true },
				{ key: 9, label: '陆运银行卡号', visible: true },
				{ key: 10, label: '陆运银行户名', visible: true },
				{ key: 11, label: '柜号', visible: true },
				{ key: 12, label: '海运司机电话', visible: true },
				{ key: 13, label: '海运公司', visible: true },
				{ key: 14, label: '海运银行卡号', visible: true },
				{ key: 15, label: '海运银行户名', visible: true },
				{ key: 16, label: '子项陆运费之和', visible: true },
				{ key: 17, label: '子项海运费之和', visible: true },
				{ key: 18, label: '录入人员', visible: true },
				{ key: 19, label: '附件', visible: true },
				{ key: 20, label: '收到条附件', visible: true },
				{ key: 21, label: '操作', visible: true }
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
			// 仓库分页相关数据
			storePageParams: {
				pageNum: 1,
				pageSize: 50
			},
			storeTotal: 0,
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
		},
		/**
		 * @description: 过滤出收到条附件列表
		 * @returns {Array} 收到条附件列表
		 */
		filteredReceiveProofAttachments() {
			if (!Array.isArray(this.form.attachmentList)) return [];
			return this.form.attachmentList.filter(item => item && item.flag === 'receiveProof');
		},
		/**
		 * @description: 过滤出附件列表
		 * @returns {Array} 附件列表
		 */
		filteredPathAttachments() {
			if (!Array.isArray(this.form.attachmentList)) return [];
			return this.form.attachmentList.filter(item => item && item.flag === 'path');
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
		this.getStoreList();
	},
	methods: {
		hasAuditPermission() {
			// 使用系统权限检查方法
			return this.$store.getters.permissions.some(permission => permission === 'system:inventoryMain:audit');
		},
		// DragDiv 事件处理方法
		handleDragStart() {
			// 拖拽开始时的处理逻辑
		},
		handleDragging(leftWidth, rightWidth) {
			// 拖拽过程中的处理逻辑
			// console.log('拖拽中:', leftWidth, rightWidth);
		},
		handleDragEnd(leftWidth, rightWidth) {
			// 拖拽结束时的处理逻辑
			// console.log('拖拽结束:', leftWidth, rightWidth);
		},
		// 是否禁用修改（如果是二次入库的入库信息 需要禁用修改）
		isInventoryDisabledModify(row) {
			console.log(row);
			if (!row.inventoryDetailList) {
				return false;
			}
			return row.inventoryDetailList.every(item => {
				return item.exWareHoustId != null;
			});
		},
		/**
		 * @description: 获取仓库列表数据（支持分页）
		 */
		getStoreList() {
			const params = {
				pageNum: this.storePageParams.pageNum,
				pageSize: this.storePageParams.pageSize
			};
			listStoreHouse(params).then(res => {
				this.storeList = res.rows.map(item => {
					return {
						label: item.storeHouseName,
						children: []
					};
				});
				this.storeTotal = res.total;
			});
		},

		/**
		 * @description: 仓库分页大小改变事件
		 * @param {number} size 新的分页大小
		 */
		handleStoreSizeChange(size) {
			this.storePageParams.pageSize = size;
			this.storePageParams.pageNum = 1;
			this.getStoreList();
		},

		/**
		 * @description: 仓库当前页改变事件
		 * @param {number} page 新的页码
		 */
		handleStoreCurrentChange(page) {
			this.storePageParams.pageNum = page;
			this.getStoreList();
		},

		/**
		 * @description: 预处理库存主表数据，为供应商信息去重并优化渲染性能
		 * @param {Array} inventoryMainList - 原始库存主表列表
		 * @returns {Array} 处理后的库存主表列表
		 */
		preprocessInventoryData(inventoryMainList) {
			if (!Array.isArray(inventoryMainList)) {
				return [];
			}

			return inventoryMainList.map(inventory => {
				// 深拷贝库存数据，避免修改原始数据
				const processedInventory = { ...inventory };

				// 预处理供应商信息
				if (inventory.inventoryDetailList && Array.isArray(inventory.inventoryDetailList)) {
					// 获取去重的供应商列表
					processedInventory._uniqueSuppliers = this.getUniqueSuppliers(inventory.inventoryDetailList);
				} else {
					processedInventory._uniqueSuppliers = [];
				}

				return processedInventory;
			});
		},

		/**
		 * @description: 获取去重的供应商列表
		 * @param {Array} inventoryDetailList - 库存详情数组
		 * @returns {Array} 去重后的供应商列表
		 */
		getUniqueSuppliers(inventoryDetailList) {
			// 边界条件处理
			if (!Array.isArray(inventoryDetailList) || inventoryDetailList.length === 0) {
				return [];
			}

			// 使用 Map 进行去重，以 supplierId 为键
			const supplierMap = new Map();

			inventoryDetailList.forEach(item => {
				// 只处理有效的供应商数据：supplierId 不为 null 且 supplier 不为空
				if (item.supplierId && item.supplier && item.supplier.trim()) {
					if (!supplierMap.has(item.supplierId)) {
						// 创建不可变的供应商对象
						supplierMap.set(item.supplierId, {
							supplier: item.supplier.trim(),
							supplierId: item.supplierId
						});
					}
				}
			});

			// 返回去重后的数组
			return Array.from(supplierMap.values());
		},

		listStoreHouse,
		listInventory,
		listCars,
		listFleet,
		listProductLevel,
		listCompany,
		getInventoryMain, // 确保已引入
		updateInventoryMain, // 确保已引入
		// 附件更新处理（收到条附件）
		handleAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 存储收到条附件的ID列表
				this.form.params.attachmentIds = uploadParams.params.attachmentIds;
			}
		},
		// 附件更新处理（附件）
		handleAttachmentsFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 存储附件的ID列表
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
		 * @description: 规范化片数值，确保为有效的Number类型，保持完整精度
		 * 注意：此方法只做数值规范化，不格式化显示（不截断小数位）
		 * 格式化显示由输入框的 formatter 或显示层处理
		 * @param {number} value 需要规范化的数值
		 * @returns {number|string} 规范化后的数值（Number类型）或空字符串
		 */
		formatPiecesValue(value) {
			if (value === null || value === undefined || value === '') {
				return '';
			}

			const num = Number(value);
			if (isNaN(num)) {
				return '';
			}

			// 返回Number类型，保持完整精度，不截断小数位
			// 这样计算时可以使用完整数值，保证计算精度
			return num;
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
			console.log(columns);
			columns.forEach((column, index) => {
				// 第一列显示"合计"文字
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				// 如果列有property且在summaryColumns中，计算合计
				if (column.property && summaryColumns.includes(column.property)) {
					const values = data.map(item => Number(item[column.property]) || 0);
					if (!values.every(value => isNaN(value))) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr) || 0;
							if (!isNaN(value)) {
								return prev + value;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = fix_2(sums[index]);
						sums[index] += column.property === 'tonnage' ? ' 吨' : ' 元';
					} else {
						sums[index] = 'N/A';
					}
				} else {
					// 对于不需要合计的列，设置为空字符串
					sums[index] = '';
				}
			});

			console.log(`sums`, sums);

			return sums;
		},
		/**
		 * @description: 计算主表格的合计行数据。
		 *              针对指定的列 (allLandFreight, allSeaFreight) 进行合计。
		 *              使用 fix 方法格式化合计结果。
		 * @param {object} param - Element UI 表格传递的参数，包含列配置 { columns } 和数据 { data }。
		 * @returns {Array<string|number>} 计算得到的合计行数据数组。
		 */
		getMainTableSummary(param) {
			const { columns, data } = param;
			const sums = [];
			const summaryColumns = ['allLandFreight', 'allSeaFreight'];
			columns.forEach((column, index) => {
				// 第一列显示"合计"文字
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				// 如果列有property且在summaryColumns中，计算合计
				if (column.property && summaryColumns.includes(column.property)) {
					const values = data.map(item => Number(item[column.property]) || 0);
					if (!values.every(value => isNaN(value))) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr) || 0;
							if (!isNaN(value)) {
								return prev + value;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = fix_2(sums[index]);
						sums[index] += ' 元';
					} else {
						sums[index] = 'N/A';
					}
				} else {
					// 对于不需要合计的列，设置为空字符串
					sums[index] = '';
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
				this.inventoryMainList = this.preprocessInventoryData(res.rows);
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
				this.inventoryMainList = this.preprocessInventoryData(response.rows);
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
			if (this.$refs.attachmentsUploader) {
				this.$refs.attachmentsUploader.clearUploadedFiles();
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
			if (this.$refs.attachmentsUploader) {
				this.$refs.attachmentsUploader.clearUploadedFiles();
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
					false,
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
							...this.form.params,
							attachmentIds: this.form.params?.attachmentIds || []
						}
					})
						.then(() => {
							this.$modal.msgSuccess(successMessage);
							this.open = false;
							this.getList();
							this.isEditingDetails = false; // 关闭弹窗时重置编辑状态
							// 清空附件上传组件
							if (this.$refs.attachmentsUploader) {
								this.$refs.attachmentsUploader.clearUploadedFiles();
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
		 * 处理价格字段输入，保存完整精度值用于计算
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 * @param {String} inputValue - 用户输入的值
		 * @param {Function} callback - 输入后的回调函数（如重新计算）
		 */
		handlePriceInput(row, field, inputValue, callback) {
			// 解析输入值，保持完整精度存储
			const parsedValue = this.parseInputValue(inputValue);
			// 存储完整精度的原始值（用于计算）
			row[`_${field}_raw`] = parsedValue;
			// 同时更新显示值（允许用户继续编辑）
			row[field] = inputValue;
			// 如果有回调，执行回调（通常是重新计算）
			if (callback) {
				callback();
			}
		},
		/**
		 * 规范化价格输入，确保为有效的Number类型，但保持完整精度不截断
		 * 在失去焦点时格式化显示，但保留完整精度值用于计算
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 * @param {Number} precision - 显示精度（2或4位小数）
		 * @param {boolean} control - 是否严格控制（暂保留兼容性，实际不截断）
		 */
		formatPriceInput(row, field, precision, control = true) {
			// 获取完整精度的原始值（优先使用_raw字段）
			const rawValue = row[`_${field}_raw`] !== undefined ? row[`_${field}_raw`] : row[field];

			// 只做数值规范化，转换为Number类型，保持完整精度不截断
			if (rawValue !== null && rawValue !== undefined && rawValue !== '') {
				const numValue = Number(rawValue);
				if (!isNaN(numValue)) {
					// 存储完整精度的原始值（用于计算）
					row[`_${field}_raw`] = numValue;
					// 显示时格式化为指定精度（仅用于显示，不影响计算）
					row[field] = this.formatValueForDisplay(numValue, precision);
				} else {
					// 无效数值时清空
					row[field] = '';
					row[`_${field}_raw`] = '';
				}
			}
		},
		/**
		 * 处理价格字段聚焦事件，恢复完整精度显示以便编辑
		 * @param {Object} row - 当前行数据
		 * @param {String} field - 字段名
		 */
		handlePriceFocus(row, field) {
			// 如果存在原始值，恢复显示原始完整精度
			if (row[`_${field}_raw`] !== undefined && row[`_${field}_raw`] !== null && row[`_${field}_raw`] !== '') {
				row[field] = row[`_${field}_raw`].toString();
			} else if (row[field] !== null && row[field] !== undefined && row[field] !== '') {
				// 如果没有原始值，保存当前值为原始值
				const numValue = Number(row[field]);
				if (!isNaN(numValue)) {
					row[`_${field}_raw`] = numValue;
					row[field] = numValue.toString();
				}
			}
		},
		/**
		 * 格式化数值用于输入框显示（仅用于显示，不影响实际存储值）
		 * @param {number|string} value - 需要格式化的值
		 * @param {number} precision - 小数位数（用于显示，如2或4）
		 * @returns {string} 格式化后的字符串（仅用于显示）
		 */
		formatValueForInput(value, precision = 2) {
			if (value === null || value === undefined || value === '') {
				return '';
			}
			const num = Number(value);
			if (isNaN(num)) {
				return '';
			}
			// 格式化为指定小数位数显示，但实际存储值不变
			return num.toFixed(precision);
		},
		/**
		 * 解析用户输入值，转换为Number类型并保持完整精度
		 * @param {string} inputValue - 用户输入的字符串值
		 * @returns {number|string} 解析后的数值（Number类型，保持完整精度）或空字符串
		 */
		parseInputValue(inputValue) {
			if (inputValue === null || inputValue === undefined || inputValue === '') {
				return '';
			}
			// 移除所有非数字和小数点的字符（保留负号如果需要）
			const cleanValue = String(inputValue).replace(/[^\d.]/g, '');
			if (cleanValue === '' || cleanValue === '.') {
				return '';
			}
			const num = Number(cleanValue);
			if (isNaN(num)) {
				return '';
			}
			// 返回Number类型，保持用户输入的完整精度（不截断）
			return num;
		},

		// 获取数字的小数位数
		getDecimalPlaces(num) {
			// 将数字转换为字符串
			const strNum = num.toString();
			// 查找小数点的位置
			const dotIndex = strNum.indexOf('.');
			// 如果没有小数点，返回 0
			if (dotIndex === -1) {
				return 0;
			}
			// 返回小数点后的字符长度
			return strNum.length - dotIndex - 1;
		},
		/**
		 * 格式化数值用于显示，但不影响存储值
		 * @param {number|string} value - 需要格式化的值
		 * @param {number} precision - 小数位数（用于显示）
		 * @returns {string} 格式化后的字符串（仅用于显示）
		 */
		formatValueForDisplay(value, precision = 2) {
			if (value === null || value === undefined || value === '') {
				return '';
			}
			const num = Number(value);
			if (isNaN(num)) {
				return '';
			}
			// 仅用于显示，不修改原始值
			return num.toFixed(precision);
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

<style scoped lang="scss">
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

/* 供应商的容器 */
.supplier-container {
	display: flex;
	align-items: center;
	justify-content: center;
	flex-wrap: nowrap;
	gap: 4px;
	line-height: 1.4;
}

.supplier-name {
	color: #409eff; /* 蓝色表示供应商 */
	cursor: pointer;
	margin-right: 4px;
	white-space: nowrap;
	font-weight: 500;
}

.supplier-name:hover {
	color: #df6565;
	font-weight: bold;
}

.supplier-name:not(:last-of-type)::after {
	content: ',';
	margin-right: 4px;
	color: #909399;
}

.empty-item {
	color: #909399; /* 灰色表示空项 */
	display: inline-block;
	font-style: italic;
}

/* 计量单位列垂直布局样式 */
::v-deep .counting-unit-column {
	.cell {
		padding: 2px 4px !important;
		line-height: 1.1 !important;
		white-space: normal !important;
		overflow: visible !important;
		height: auto !important;
	}
}

::v-deep .vertical-radio-group {
	display: flex !important;
	flex-direction: column !important;
	align-items: flex-start !important;
	gap: 1px !important;
	width: 100% !important;
	margin: 0 !important;

	.vertical-radio {
		margin-right: 0 !important;
		margin-bottom: 1px !important;
		white-space: nowrap !important;
		width: 100% !important;

		.el-radio__label {
			font-size: 11px !important;
			padding-left: 4px !important;
		}

		.el-radio__input {
			margin-right: 2px !important;
		}

		&:last-child {
			margin-bottom: 0 !important;
		}
	}
}

/* 含税列垂直布局样式 */
::v-deep .tax-column {
	.cell {
		padding: 2px 4px !important;
		line-height: 1.1 !important;
		white-space: normal !important;
		overflow: visible !important;
		height: auto !important;
	}
}

::v-deep .vertical-tax-radio-group {
	display: flex !important;
	flex-direction: column !important;
	align-items: flex-start !important;
	gap: 1px !important;
	width: 100% !important;
	margin: 0 !important;

	.vertical-tax-radio {
		margin-right: 0 !important;
		margin-bottom: 1px !important;
		white-space: nowrap !important;
		width: 100% !important;

		.el-radio__label {
			font-size: 11px !important;
			padding-left: 4px !important;
		}

		.el-radio__input {
			margin-right: 2px !important;
		}

		&:last-child {
			margin-bottom: 0 !important;
		}
	}
}
</style>
