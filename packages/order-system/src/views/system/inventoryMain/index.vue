<template>
	<div class="app-container">
		<el-form id="top-search-form-item" :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch && isConfigLoaded" label-width="150">
			<el-form-item v-if="shouldShowField('storeHouseName')" label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" class="input-standard" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item v-if="shouldShowField('storeDateRange')" label="入库日期" prop="storeDateRange">
				<el-date-picker v-model="queryParams.storeDateRange" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" clearable @change="handleDateRangeChange" />
			</el-form-item>
			<!-- 2025-11-1 录入人员不用录入了 -->
			<!-- <el-form-item v-if="shouldShowField('userName')" label="录入人员" prop="userName">
				<el-input v-model="queryParams.userName" class="input-standard" placeholder="录入人员" clearable @keyup.enter.native="handleQuery" @input="val => (queryParams.UserName = val)" />
			</el-form-item> -->
			<el-form-item v-if="shouldShowField('supplier')" label="供应商" prop="supplier">
				<el-input v-model="queryParams.params.detail_supplier" class="input-standard" placeholder="请输入供应商" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<!-- 2026-02-06 删除货物来源公司搜索字段 -->
			<el-form-item v-if="shouldShowField('landCarNo')" label="陆运车牌" prop="landCarNo">
				<el-input v-model="queryParams.landCarNo" class="input-standard" placeholder="请输入陆运车牌" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item v-if="shouldShowField('seaDriverName')" label="海运公司" prop="seaDriverName">
				<el-input v-model="queryParams.seaDriverName" class="input-standard" placeholder="请输入海运公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item v-if="shouldShowField('checkState')" label="审核状态" prop="checkState">
				<el-select v-model="queryParams.checkState" class="input-standard" placeholder="请选择审核状态" clearable @keyup.enter.native="handleQuery">
					<el-option label="全部" value=""></el-option>
					<el-option label="未审核" value="未审核"></el-option>
					<el-option label="已审核" value="已审核"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-setting" size="mini" @click="openFieldSetting">自定义</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 字段设置弹窗 -->
		<el-dialog title="自定义搜索字段" :visible.sync="fieldSettingVisible" width="500px">
			<el-checkbox-group v-model="selectedFields">
				<el-row :gutter="10">
					<el-col v-for="field in allFields" :key="field.value" :span="12" style="margin-bottom: 8px">
						<el-checkbox :label="field.value" style="width: 100%">
							<span style="font-size: 12px">{{ field.label }}</span>
						</el-checkbox>
					</el-col>
				</el-row>
			</el-checkbox-group>
			<span slot="footer" class="dialog-footer">
				<el-button size="mini" @click="resetToDefault">恢复默认</el-button>
				<el-button size="mini" @click="fieldSettingVisible = false">取消</el-button>
				<el-button size="mini" type="primary" @click="saveFieldSettings">确定</el-button>
			</span>
		</el-dialog>

		<el-row>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" table-name="views-system-inventory-main-index-columns">
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
						<!-- <el-col :span="1.5">
              <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:inventoryMain:export']">导出</el-button>
            </el-col> -->
					</el-row>
				</template>
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:inventoryMain:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport">导出库存目录</el-button>
						<el-button v-hasPermi="['system:inventoryMain:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExportNoPage">导出全部库存</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 使用 DragDiv 组件替换原来的 el-col 布局 -->
		<div>
			<DragDiv :initial-left-width="300" :min-left-width="200" :min-right-width="800" :divider-width="6" @drag-start="handleDragStart" @dragging="handleDragging" @drag-end="handleDragEnd">
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
						<virtual-scroll ref="virtualScroll" :data="inventoryMainList" :item-size="30" key-prop="id" @change="inventoryDataAppendChange">
							<template slot-scope="{ headerCellFixedStyle, cellFixedStyle }">
								<el-table
									border
									ref="inventoryTable"
									id="printBox"
									:row-key="row => row.id"
									size="mini"
									v-loading="loading"
									:data="virsualInventoryMainList"
									@selection-change="handleSelectionChange"
									stripe
									height="750"
									tooltip-effect="light"
									:headerCellStyle="headerCellFixedStyle"
									:cellStyle="cellFixedStyle"
									@header-dragend="onHeaderDragend"
								>
									<el-table-column type="selection" width="50" align="center" />
									<el-table-column v-if="columns[0].visible" show-overflow-tooltip label="ID" align="center" prop="id" width="80">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.id }}</div>
												<span>{{ scope.row.id }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[1].visible" show-overflow-tooltip label="仓库名称" align="center" prop="storeHouseName" width="150">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.storeHouseName }}</div>
												<span>{{ scope.row.storeHouseName }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[2].visible" show-overflow-tooltip label="变动日期(入库)" align="center" prop="storeDate" width="150">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ parseTime(scope.row.storeDate, '{y}-{m}-{d}') }}</div>
												<span>{{ parseTime(scope.row.storeDate, '{y}-{m}-{d}') }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[3].visible" show-overflow-tooltip label="供应商" align="center" prop="supplier" width="150">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">
													<div class="supplier-container">
														<span v-for="supplier in scope.row._uniqueSuppliers" :key="`supplier-${supplier.supplierId}`" class="supplier-name">
															{{ supplier.supplier }}
														</span>
														<span v-if="scope.row._uniqueSuppliers.length === 0" class="empty-item">-</span>
													</div>
												</div>
												<div class="supplier-container">
													<span v-for="supplier in scope.row._uniqueSuppliers" :key="`supplier-${supplier.supplierId}`" class="supplier-name">
														{{ supplier.supplier }}
													</span>
													<span v-if="scope.row._uniqueSuppliers.length === 0" class="empty-item">-</span>
												</div>
											</el-tooltip>
										</template>
									</el-table-column>
									<!-- 修改审核状态列 -->
									<el-table-column v-if="columns[4].visible" show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="150">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
												<div slot="content" @click.stop>
													<el-row v-if="scope.row.checkState === '已审核'">
														<StateTag
															:state-title="scope.row.checkState"
															:state-mapper="{ 2: '已审核' }"
															@click.native.stop="hasPermission(['finance', 'admin']) && handleReCheck(scope.row)"
															:style="{ cursor: hasPermission(['finance', 'admin']) ? 'pointer' : 'default' }"
														/>
													</el-row>
													<el-row v-else>
														<el-button v-if="hasPermission(['finance', 'admin'])" type="text" size="mini" @click.stop="handleCheck(scope.row)">审核</el-button>
														<span v-else style="color: #909399; font-size: 12px">未审核</span>
													</el-row>
												</div>
												<el-row v-if="scope.row.checkState === '已审核'">
													<StateTag :state-title="scope.row.checkState" :state-mapper="{ 2: '已审核' }" @click.native="hasPermission(['finance', 'admin']) && handleReCheck(scope.row)" :style="{ cursor: hasPermission(['finance', 'admin']) ? 'pointer' : 'default' }" />
												</el-row>
												<el-row v-else>
													<el-row>
														<el-button v-if="hasPermission(['finance', 'admin'])" type="text" size="mini" @click="handleCheck(scope.row)">审核</el-button>
														<span v-else style="color: #909399; font-size: 12px">未审核</span>
													</el-row>
												</el-row>
											</el-tooltip>
										</template>
									</el-table-column>

									<el-table-column v-if="columns[5].visible" show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" width="120">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.landCarNo }}</div>
												<span>{{ scope.row.landCarNo }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[6].visible" show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="120">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.landDriverName }}</div>
												<span>{{ scope.row.landDriverName }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[7].visible" show-overflow-tooltip label="柜号" align="center" prop="seaCarNo" width="120">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.seaCarNo }}</div>
												<span>{{ scope.row.seaCarNo }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[8].visible" show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="120">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.seaDriverName }}</div>
												<span>{{ scope.row.seaDriverName }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<!-- 含税列 -->
									<el-table-column v-if="columns[9].visible" show-overflow-tooltip label="含税" align="center" prop="isIncludeTaxSale" width="100">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.isIncludeTaxSale === 1 ? '含税' : '不含税' }}</div>
												<span>{{ scope.row.isIncludeTaxSale === 1 ? '含税' : '不含税' }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<!-- 库存金额列 -->
									<el-table-column v-if="columns[10].visible" show-overflow-tooltip label="库存金额" align="center" prop="payments" width="150">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ calculateTotalPayments(scope.row) }}</div>
												<span>{{ calculateTotalPayments(scope.row) }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[11].visible" show-overflow-tooltip label="子项陆运费之和" align="center" prop="allLandFreight" width="150">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.allLandFreight }}</div>
												<span>{{ scope.row.allLandFreight }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[12].visible" show-overflow-tooltip label="子项海运费之和" align="center" prop="allSeaFreight" width="150">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.allSeaFreight }}</div>
												<span>{{ scope.row.allSeaFreight }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[13].visible" show-overflow-tooltip label="录入员" align="center" prop="userName" width="120">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ scope.row.userName }}</div>
												<span>{{ scope.row.userName }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[14].visible" show-overflow-tooltip label="不含税利润" align="center" prop="profitNoTax" width="120">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
												<div slot="content">{{ calculateTotalProfitNoTax(scope.row) }}</div>
												<span>{{ calculateTotalProfitNoTax(scope.row) }}</span>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[15].visible" show-overflow-tooltip label="附件" align="center" prop="path" width="70" fixed="right">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
												<div slot="content" @click.stop>
													<div v-if="Array.isArray(scope.row.attachmentList)">
														<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'path'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInventoryMain, updateInventoryMain)" />
													</div>
													<div v-else>
														<el-tag type="danger">加载错误</el-tag>
													</div>
												</div>
												<div v-if="Array.isArray(scope.row.attachmentList)">
													<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'path'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInventoryMain, updateInventoryMain)" />
												</div>
												<div v-else>
													<el-tag type="danger">加载错误</el-tag>
												</div>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[16].visible" show-overflow-tooltip label="收到条附件" align="center" prop="receiveProof" width="70" fixed="right">
										<template #default="scope">
											<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
												<div slot="content" @click.stop>
													<div v-if="Array.isArray(scope.row.attachmentList)">
														<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'receiveProof'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInventoryMain, updateInventoryMain)" />
													</div>
													<div v-else>
														<el-tag type="danger">加载错误</el-tag>
													</div>
												</div>
												<div v-if="Array.isArray(scope.row.attachmentList)">
													<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'receiveProof'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getInventoryMain, updateInventoryMain)" />
												</div>
												<div v-else>
													<el-tag type="danger">加载错误</el-tag>
												</div>
											</el-tooltip>
										</template>
									</el-table-column>
									<el-table-column v-if="columns[17].visible" show-overflow-tooltip label="审核人员" align="center" prop="checkUserName" width="100" fixed="right" />
									<el-table-column v-if="columns[18].visible" label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="100">
										<template slot-scope="scope">
											<el-dropdown size="mini" trigger="hover" @command="command => handleCommand(command, scope.row)">
												<el-button size="mini" type="text" @click.stop="handleCheckInventory(scope.row)">
													<span v-once>查看</span>
													<i class="el-icon-arrow-down el-icon--right" />
												</el-button>
												<el-dropdown-menu slot="dropdown">
													<!-- 修改 -->
													<el-dropdown-item v-hasPermi="['system:inventoryMain:edit']" command="handleUpdate" :disabled="isInventoryDisabledModify(scope.row)">
														<span :title="isInventoryDisabledModify(scope.row) ? '该货物为二次入库货物，请在存货二次加工管理处修改' : ''">修改</span>
													</el-dropdown-item>
													<!-- 删除 -->
													<el-dropdown-item v-hasPermi="['system:inventoryMain:remove']" command="handleDelete" divided>
														<span>删除</span>
													</el-dropdown-item>
												</el-dropdown-menu>
											</el-dropdown>
										</template>
									</el-table-column>
								</el-table>
							</template>
						</virtual-scroll>
					</div>
				</template>
			</DragDiv>
		</div>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" style="margin-top: 10px; text-align: right" />

		<!-- 添加或修改库存库存主表对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="100%" append-to-body :close-on-click-modal="false">
			<el-form ref="form" :model="form" :rules="rules" label-width="100px" :inline="true">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-col :span="16">
						<el-input disabled size="mini" v-model="form.storeHouseName" placeholder="请输入仓库名称" />
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
					<el-date-picker v-model="form.storeDate" size="mini" type="datetime" placeholder="选择入库日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 120px" />
				</el-form-item>
				<el-form-item label="货物来源" prop="goodsCompany">
					<el-input size="mini" v-model="form.goodsCompany" placeholder="请输入货物来源公司(本部或者海盛)" />
				</el-form-item>
				<!-- <el-form-item label="录入人员" prop="userName">
          <el-input size="mini" v-model="form.userName" placeholder="请输入录入人员" />
        </el-form-item> -->
				<el-form-item label="附件">
					<UploadFilesButton ref="attachmentsUploader" flag="path" :extra-info="{ moduleType: 'inventoryMain', formId: form.id }" :initial-attachments="filteredPathAttachments" @files-updated="handleAttachmentsFilesUpdated" />
				</el-form-item>
				<el-form-item label="其他信息" prop="comments">
					<el-input size="mini" v-model="form.comments" placeholder="请输入其他信息" />
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
						<el-input disabled v-model="form.landDriverName" type="text" size="mini" placeholder="请选择" style="width: 130px" />
					</el-form-item>
					<el-form-item label="电话">
						<el-input disabled v-model="form.landDriverTel" type="text" size="mini" placeholder="请选择" style="width: 120px" />
					</el-form-item>
					<!-- 添加车队 -->
					<el-form-item label="车队" prop="fleet">
						<el-row>
							<el-col :span="12">
								<el-input v-model="form.fleet" type="text" size="mini" placeholder="请选择车队" />
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
				<el-row v-if="isSea" style="margin: 3px 0">
					<el-form-item label="柜号" prop="seaCarNo">
						<el-row>
							<el-input v-model="form.seaCarNo" type="text" size="mini" placeholder="请输入柜号" style="width: 120px" />
						</el-row>
					</el-form-item>
					<!--          todo 原为海运司机 现改为海运公司-->
					<el-form-item label="海运公司" prop="seaDriverName">
						<el-col :span="20">
							<el-input v-model="form.seaDriverName" type="text" size="mini" placeholder="请输入海运公司" style="width: 130px" />
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
					</el-form-item>
					<el-form-item label="电话" prop="seaDriverTel">
						<el-input v-model="form.seaDriverTel" type="text" size="mini" placeholder="请输入电话" style="width: 120px" />
					</el-form-item>
				</el-row>
				<br />

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
				<el-table border size="mini" :data="visibleInventoryDetailList" :row-class-name="getRowClassName" @selection-change="handleInventoryDetailSelectionChange" ref="inventoryDetail" show-summary :summary-method="getInventoryDetailSummary">
					<el-table-column type="selection" width="30" align="center" :selectable="() => true" />
					<el-table-column label="序号" align="center" type="index" width="60" fixed="left" />
					<el-table-column label="行操作" align="center" width="180" fixed="left">
						<template slot-scope="scope">
							<div>
								<el-button v-if="!scope.row.isEditing" size="mini" type="warning" icon="el-icon-edit" @click="handleRowEdit(scope.row)">编辑</el-button>
								<el-button v-else size="mini" type="success" icon="el-icon-check" @click="handleRowSave(scope.row)">保存</el-button>
								<el-button :disabled="scope.row.isEditing" size="mini" type="danger" icon="el-icon-document-copy" @click="handleCopyRow(scope.row)">复制</el-button>
							</div>
						</template>
					</el-table-column>
					<el-table-column label="供应商" width="170" align="center">
						<template #default="scope">
							<el-row>
								<el-col :span="20">
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
							<!-- 添加 disabled 属性 -->
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!scope.row.isEditing" @change="() => recalculateAll(scope)" class="horizontal-radio-group">
								<el-radio label="片数" class="horizontal-radio">片数</el-radio>
								<el-radio label="其他" class="horizontal-radio">其他</el-radio>
							</el-radio-group>
						</template>
					</el-table-column>
					<el-table-column label="厚度" prop="height" width="90">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.height" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="长度" prop="length" width="90">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.length" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="宽度" prop="width" width="90">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.width" placeholder="请选择产品级别" disabled />
						</template>
					</el-table-column>
					<el-table-column label="每包片数" prop="piecesPerPack" width="80">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.piecesPerPack" placeholder="请输入每包片数" :disabled="!scope.row.isEditing" @input="val => handlePiecesInput(scope.row, 'piecesPerPack', val, () => calculatePieces(scope.row))" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="60">
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

					<el-table-column label="出厂片数" prop="pieces" width="80">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.pieces" placeholder="请输入出厂片数" @input="val => handlePiecesInput(scope.row, 'pieces', val, () => recalculateAll(scope))" @change="() => handlePiecesChange(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>

					<el-table-column label="出厂单价" prop="price" width="80">
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
					<el-table-column label="含税" prop="isIncludeTaxFactory" width="80" class-name="tax-column">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-radio-group v-model="scope.row.isIncludeTaxFactory" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" class="horizontal-tax-radio-group">
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
								@blur="() => formatPriceInput(scope.row, 'sundryCost', 2)"
								:placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'"
								:disabled="!scope.row.isEditing || !scope.row.price"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<el-input size="mini" v-model="scope.row.paymentFactory" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="入库量" prop="stockNumber" width="70">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" @input="val => handlePiecesInput(scope.row, 'stockNumber', val, () => recalculateAll(scope))" v-model="scope.row.stockNumber" placeholder="入库时片数" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="存货价" prop="paymentUnload" width="100">
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
					<el-table-column label="含税" prop="isIncludeTaxSale" width="60" class-name="tax-column">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-radio-group v-model="scope.row.isIncludeTaxSale" size="mini" @change="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" class="horizontal-tax-radio-group">
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
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.erro" placeholder="请输入误差" disabled />
						</template>
					</el-table-column>
					<el-table-column label="吨位" prop="tonnage" width="100">
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
								@input="val => handlePriceInput(scope.row, 'landFreightPrice', val, () => recalculateAll(scope))"
								@focus="() => handlePriceFocus(scope.row, 'landFreightPrice')"
								@blur="() => formatPriceInput(scope.row, 'landFreightPrice', 2)"
								placeholder="请输入陆运费单价"
								:disabled="!scope.row.isEditing"
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
								@blur="() => formatPriceInput(scope.row, 'additionalFees', 2)"
								:placeholder="!scope.row.landFreightPrice ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>
					<el-table-column label="陆运费" prop="landFreight" width="100" v-if="isLand">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
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
								@blur="() => formatPriceInput(scope.row, 'seaFreight', 2)"
								placeholder="请输入海运费"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>

					<el-table-column label="总运费" prop="freight" width="100">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.freight" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="其他费用" prop="otherCost" width="100">
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
					<el-table-column label="备注" prop="comments" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" :disabled="!scope.row.isEditing" />
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
					<el-table-column label="客户佣金" prop="customerCommission" width="80">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.customerCommission"
								@input="val => handlePriceInput(scope.row, 'customerCommission', val, () => {})"
								@focus="() => handlePriceFocus(scope.row, 'customerCommission')"
								@blur="() => formatPriceInput(scope.row, 'customerCommission', 2)"
								placeholder="请输入佣金"
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
import { add, round } from 'mathjs'; // 引入 mathjs 用于高精度计算
import DragDiv from '@/components/DragDiv/index.vue';
// 前端Excel导出依赖
import * as XLSX from 'xlsx';
import VirtualScroll from 'el-table-virtual-scroll';
import { requestAnimationFrame } from 'vue-count-to/src/requestAnimationFrame';
import { throttle } from 'lodash';
import { getUserConfig, saveUserConfig } from '@/api/user-config';
import { UserConfigKey } from '@/api/tool/user-config.js';
import {
	handlePriceInput as utilHandlePriceInput,
	formatPriceInput as utilFormatPriceInput,
	handlePriceFocus as utilHandlePriceFocus,
	parseInputValue,
	formatValueForDisplay,
	getDecimalPlaces,
	formatPiecesValue,
	handlePiecesInput as utilHandlePiecesInput,
	getRowClassName as utilGetRowClassName,
	initSpecialFieldDecimalPlaces
} from '@/utils/order';

export default {
	name: 'InventoryMain',
	components: { SearchOption, CheckFiles, UploadFilesButton, StateTag, DragDiv, VirtualScroll },
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
			// 字段自定义相关
			fieldSettingVisible: false,
			isConfigLoaded: false,
			allFields: [
				{ value: 'storeHouseName', label: '仓库名称' },
				{ value: 'storeDateRange', label: '入库日期' },
				{ value: 'userName', label: '入库人员' },
				{ value: 'supplier', label: '供应商' },
				// 2026-02-06 删除货物来源搜索字段
				{ value: 'landCarNo', label: '陆运车牌' },
				{ value: 'seaDriverName', label: '海运公司' },
				{ value: 'checkState', label: '审核状态' }
			],
			selectedFields: [],
			// 总条数
			total: 0,
			// 库存库存主表表格数据
			inventoryMainList: [],
			// 虚拟列表显示的数据
			virsualInventoryMainList: [],
			// 虚拟列表待处理数据
			pendingData: null,
			// 虚拟列表节流标记
			ticking: false,
			// 库存子表格数据
			inventoryDetailList: [], // 库存子表格数据
			isEditingDetails: false, // 新增：全局编辑状态
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: null,
				storeDateRange: null, // 日期范围选择器的值
				landCarID: null,
				landCarNo: null,
				seaCarID: null,
				seaCarNo: null,
				addtime: null,
				userId: null,
				UserName: null,
				userName: null, // 入库人员
				delFlag: null,
				showFlag: null,
				exWareHoustId: null,
				goodsCompany: null,
				allLandFreight: null,
				allSeaFreight: null,
				seaDriverName: null,
				checkState: null, // 审核状态
				params: {
					main_storeDate_startTime: null,
					main_storeDate_endTime: null,
					detail_supplier: null // 供应商
				}
			},
			// 表单参数
			form: {},
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '仓库名称', visible: true },
				{ key: 2, label: '入库日期', visible: true },
				{ key: 3, label: '供应商', visible: true },
				{ key: 5, label: '审核状态', visible: true },
				{ key: 6, label: '陆运车牌', visible: true },
				{ key: 7, label: '陆地司机姓名', visible: true },
				{ key: 8, label: '柜号', visible: true },
				{ key: 9, label: '海运公司', visible: true },
				{ key: 10, label: '含税', visible: true },
				{ key: 11, label: '库存金额', visible: true },
				{ key: 12, label: '子项陆运费之和', visible: true },
				{ key: 13, label: '子项海运费之和', visible: true },
				{ key: 14, label: '录入员', visible: true },
				{ key: 18, label: '不含税利润', visible: true },
				{ key: 15, label: '附件', visible: true },
				{ key: 16, label: '收到条附件', visible: true },
				{ key: 19, label: '审核人员', visible: true },
				{ key: 17, label: '操作', visible: true }
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
						label: '长度',
						prop: 'length',
						type: 'input',
						value: ''
					},
					{
						id: 3,
						label: '宽度',
						prop: 'width',
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
		// 字段显示控制
		shouldShowField() {
			return fieldName => this.isConfigLoaded && Array.isArray(this.selectedFields) && this.selectedFields.includes(fieldName);
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
	async created() {
		await this.loadFieldSettings();
		this.getList();
		// 抓取左侧仓库信息
		this.getStoreList();
	},
	mounted() {
		this.$bus.$on('refreshList', this.getList);
	},
	methods: {
		listStoreHouse,
		listCars,
		listFleet,
		listProductLevel,
		listCompany,
		getInventoryMain, // 确保已引入
		updateInventoryMain, // 确保已引入
		// 虚拟列表数据变化处理
		inventoryDataAppendChange(renderData) {
			this.pendingData = renderData;
			const updateVisibleRows = throttle(renderData => {
				this.virsualInventoryMainList.splice(0, this.virsualInventoryMainList.length, ...renderData);
			}, 16);
			if (!this.ticking) {
				this.ticking = true;
				requestAnimationFrame(() => {
					// 检查 pendingData 是否存在（包括空数组的情况）
					if (this.pendingData !== null && this.pendingData !== undefined) {
						updateVisibleRows(this.pendingData);
						this.pendingData = null;
					}
					this.ticking = false;
				});
			}
		},
		/**
		 * @description: 加载用户搜索字段配置
		 */
		async loadFieldSettings() {
			try {
				const response = await getUserConfig(UserConfigKey.INVENTORY_SEARCH_COLUMNS);
				const configValue = response?.data?.value || response?.data || null;
				if (typeof configValue === 'string') {
					try {
						const parsed = JSON.parse(configValue);
						this.selectedFields = Object.keys(parsed.columns || {}).filter(key => parsed.columns[key]);
					} catch {
						this.selectedFields = this.allFields.map(f => f.value);
					}
				} else if (configValue?.columns) {
					this.selectedFields = Object.keys(configValue.columns).filter(key => configValue.columns[key]);
				} else {
					this.selectedFields = this.allFields.map(f => f.value);
				}
			} catch (err) {
				console.error('加载用户搜索字段配置失败:', err);
				this.selectedFields = this.allFields.map(f => f.value);
			} finally {
				this.isConfigLoaded = true;
			}
		},
		/**
		 * @description: 保存用户搜索字段配置
		 */
		async saveFieldSettings() {
			try {
				const columnsConfig = {};
				this.allFields.forEach(f => {
					columnsConfig[f.value] = this.selectedFields.includes(f.value);
				});
				await saveUserConfig('inventorySearch-columns', { columns: columnsConfig });
				this.$message.success('字段设置已保存');
				this.fieldSettingVisible = false;
			} catch (err) {
				console.error('保存用户搜索字段配置失败:', err);
				this.$message.error('保存失败，请重试');
			}
		},
		/**
		 * @description: 恢复默认字段设置
		 */
		resetToDefault() {
			this.selectedFields = this.allFields.map(f => f.value);
			this.saveFieldSettings();
			this.fieldSettingVisible = false;
		},
		/**
		 * @description: 打开字段设置弹窗
		 */
		openFieldSetting() {
			this.fieldSettingVisible = true;
		},
		// 检查用户是否具有指定权限
		hasPermission(roles) {
			// 从 Vuex store 或其他地方获取当前用户角色
			const userRoles = this.$store.getters.roles || [];
			// 检查是否包含所需角色
			return userRoles.some(role => roles.includes(role));
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
		 * @description: 计算库存金额总和（从子项的 payments 字段求和）
		 * @param {Object} row - 主表行数据
		 * @returns {string} 格式化后的库存金额总和
		 */
		calculateTotalPayments(row) {
			if (!row || !row.inventoryDetailList || !Array.isArray(row.inventoryDetailList) || row.inventoryDetailList.length === 0) {
				return '0.00';
			}
			// 使用 mathjs 进行高精度求和
			const total = row.inventoryDetailList.reduce((sum, item) => {
				const payments = Number(item.payments) || 0;
				return add(sum, payments);
			}, 0);
			// 四舍五入保留两位小数
			return round(total, 2).toString();
		},
		/**
		 * 计算不含税利润总和（从子项 inventoryDetailList 的 profitNoTax 求和）
		 * @param {Object} row - 主表行数据
		 * @returns {string} 格式化后的不含税利润总和
		 */
		calculateTotalProfitNoTax(row) {
			if (!row || !row.inventoryDetailList || !Array.isArray(row.inventoryDetailList) || row.inventoryDetailList.length === 0) {
				return '0.00';
			}
			const total = row.inventoryDetailList.reduce((sum, item) => {
				const val = Number(item.profitNoTax) || 0;
				return add(sum, val);
			}, 0);
			return round(total, 2).toString();
		},
		/**
		 * @description: 高精度汇总库存子项金额字段，避免使用 JS 浮点加法带来的精度误差
		 * @param {string} field - 子项字段名，如 landFreight / seaFreight
		 * @returns {number} 四舍五入到 2 位小数后的数值
		 */
		calculateDetailFreightTotal(field) {
			if (!Array.isArray(this.visibleInventoryDetailList) || this.visibleInventoryDetailList.length === 0) {
				return 0;
			}
			const total = this.visibleInventoryDetailList.reduce((sum, item) => {
				const value = Number(item[field]) || 0;
				return add(sum, value);
			}, 0);
			return Number(round(total, 2));
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
		 *              当取消勾选时，清除对应运输方式的表单项。
		 */
		updateTransportMode() {
			// 如果取消勾选陆运，清除陆运相关字段
			if (!this.isLand) {
				this.form.landCarID = '';
				this.form.landCarNo = '';
				this.form.landDriverName = '';
				this.form.landDriverTel = '';
				this.form.landBankNo = '';
				this.form.landBankName = '';
				this.form.fleet = '';
				// 清除校验状态
				if (this.$refs.form) {
					this.$refs.form.clearValidate(['landCarNo', 'fleet']);
				}
			}
			// 如果取消勾选海运，清除海运相关字段
			if (!this.isSea) {
				this.form.seaCarID = '';
				this.form.seaCarNo = '';
				this.form.seaDriverName = '';
				this.form.seaDriverTel = '';
				this.form.seaBankNo = '';
				this.form.seaBankName = '';
				// 清除校验状态
				if (this.$refs.form) {
					this.$refs.form.clearValidate(['seaCarNo', 'seaDriverName', 'seaDriverTel']);
				}
			}
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
		 * @description: 处理行保存事件
		 * @param {Object|Array} row - 当前保存的行数据或行数据数组
		 * @param {Function} [resolve=null] - Promise resolve回调
		 * @param {Function} [reject=null] - Promise reject回调
		 */
		handleRowSave(row, resolve = null, reject = null) {
			// 统一处理输入，确保 rows 是数组
			const rows = Array.isArray(row) ? row : [row];
			// 处理每一行，关闭编辑状态并更新计算
			rows.forEach(r => {
				if (r.isEditing && !r.isDeleted) {
					this.$set(r, 'isEditing', false);
					updateInventoryRowCalculations(r, this.isSea, this.isLand);
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

			// 构造新的库存信息，发送后端时计量单位统一为片数
			const normalizedDetails = allDetails.map(d => ({
				...d,
				countingUnit: d.countingUnit === '片' ? '片数' : d.countingUnit || '片数'
			}));
			const newInventoryInfo = {
				...this.form,
				inventoryDetailList: normalizedDetails
			};
			// 计算总运费等主表信息
			newInventoryInfo.allLandFreight = this.isLand ? this.calculateDetailFreightTotal('landFreight') : 0;
			newInventoryInfo.allSeaFreight = this.isSea ? this.calculateDetailFreightTotal('seaFreight') : 0;

			this.addOrUpdateInventoryDetail(newInventoryInfo, rows, resolve, reject, row);
		},
		/**
		 * @description: 添加或更新库存详情
		 * @param {Object} newInventoryInfo - 新的库存信息
		 * @param {Array} rows - 相关的行数据
		 * @param {Function} [resolve=null] - Promise resolve回调
		 * @param {Function} [reject=null] - Promise reject回调
		 */
		addOrUpdateInventoryDetail(newInventoryInfo, rows, resolve = null, reject = null, row = null) {
			// 保存row的引用，避免在Promise链中丢失
			const currentRows = rows;
			const apiCall = this.form.id ? updateInventoryMain : addInventoryMain;
			const successMessage = this.form.id ? '该行库存详情信息已修改并保存!' : '该行库存详情信息已添加并保存!';
			const errorMessage = '保存失败，请重新编辑: ';

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
					this.$message.success(successMessage);
					// 如果是新增，更新主表ID和数据
					if (!this.form.id && res.data && res.data.id) {
						this.form.id = res.data.id;
					}
					resolve && resolve();
					this.getList(); // 刷新列表
				})
				.catch(error => {
					currentRows.forEach(row => {
						// 使用Vue的响应式方法确保UI更新
						this.$set(row, 'isEditing', true);
						this.$set(row, 'hasError', true); // 添加错误标记
					});
					this.$message.error(errorMessage + (error.message || '未知错误'));
					this.isEditingDetails = true;
					reject && reject();
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
		 * @description: 获取表格行的类名，用于标记错误行或编辑中的行。
		 * @param {object} param - Element UI 表格传递的参数，包含当前行数据 { row }。
		 * @returns {string} 行的 CSS 类名 ('error-row', 'editing-row', 或空字符串)。
		 */
		getRowClassName(param) {
			return utilGetRowClassName(param);
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
		// formatPiecesValue 已从 @/utils/order 导入，直接使用
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
				row.pieces = formatPiecesValue(result);
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
		 * @description: 处理日期范围变化事件
		 *              将日期范围值赋给 params.main_storeDate_startTime 和 params.main_storeDate_endTime
		 * @param {Array|null} dateRange - 日期范围数组 [startDate, endDate] 或 null
		 */
		handleDateRangeChange(dateRange) {
			if (dateRange && Array.isArray(dateRange) && dateRange.length === 2) {
				// 确保 params 对象存在
				if (!this.queryParams.params) {
					this.$set(this.queryParams, 'params', {});
				}
				this.queryParams.params.main_storeDate_startTime = dateRange[0];
				this.queryParams.params.main_storeDate_endTime = dateRange[1];
			} else {
				// 清空日期范围时，清空 params 中的时间参数
				if (this.queryParams.params) {
					this.queryParams.params.main_storeDate_startTime = null;
					this.queryParams.params.main_storeDate_endTime = null;
				}
			}
			// 确保 params.detail_supplier 存在
			if (!this.queryParams.params.detail_supplier) {
				this.$set(this.queryParams.params, 'detail_supplier', null);
			}
		},
		/**
		 * @description: 处理搜索按钮操作。
		 *              设置 queryParams.pageNum 为 1。
		 *              确保 params 对象和 detail_supplier 字段存在。
		 *              将 userName 同步到 UserName（后端使用 UserName）。
		 *              调用 getList 方法重新获取列表数据。
		 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			// 确保 params 对象存在
			if (!this.queryParams.params) {
				this.$set(this.queryParams, 'params', {});
			}
			// 确保 detail_supplier 字段存在
			if (this.queryParams.params.detail_supplier === undefined) {
				this.$set(this.queryParams.params, 'detail_supplier', null);
			}
			// 确保 userName 字段存在（入库人员），并同步到 UserName（后端使用）
			if (this.queryParams.userName === undefined) {
				this.$set(this.queryParams, 'userName', null);
			}
			// 将 userName 同步到 UserName（后端 API 使用 UserName）
			this.queryParams.UserName = this.queryParams.userName;
			this.getList();
		},
		/**
		 * @description: 处理重置搜索按钮操作。
		 *              调用 resetForm 方法重置搜索表单。
		 *              清理 params 对象中的时间范围参数。
		 *              调用 handleQuery 方法重新获取列表数据。
		 */
		resetQuery() {
			if (this.$refs.queryForm) {
				this.$refs.queryForm.resetFields();
			}
			// 重置查询参数
			Object.assign(this.queryParams, {
				pageNum: 1,
				pageSize: 20,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: null,
				storeDateRange: null,
				landCarID: null,
				landCarNo: null,
				seaCarID: null,
				seaCarNo: null,
				addtime: null,
				userId: null,
				UserName: null,
				userName: null,
				delFlag: null,
				showFlag: null,
				exWareHoustId: null,
				goodsCompany: null,
				allLandFreight: null,
				allSeaFreight: null,
				seaDriverName: null,
				checkState: null
			});
			// 清理 params 对象中的时间范围参数和供应商参数
			if (this.queryParams.params) {
				this.queryParams.params.main_storeDate_startTime = null;
				this.queryParams.params.main_storeDate_endTime = null;
				this.queryParams.params.detail_supplier = null;
			}
			// 同步清空 UserName
			this.queryParams.UserName = null;
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
					'100%',
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
				this.inventoryDetailList = response.data.inventoryDetailList.map((item, index) => {
					const processedItem = {
						...item,
						countingUnit: item.countingUnit === '片' ? '片数' : item.countingUnit || '片数',
						index: index + 1, // 设置唯一索引
						isEditing: false, // 初始为非编辑状态
						isDeleted: item.isDeleted !== undefined ? item.isDeleted : false, // 确保 isDeleted 字段存在
						isAdd: false, // 从后端加载的数据标记为非新增
						hasError: false // 初始无错误
					};
					// 初始化特殊字段的小数位数
					initSpecialFieldDecimalPlaces(processedItem);
					return processedItem;
				});
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

					// 检查是否有未保存的子项（只检查可见行）
					if (this.visibleInventoryDetailList.some(item => item.isEditing)) {
						this.$message.error('当前库存信息中有未保存的项,请先保存或取消编辑后再提交!');
						return;
					}
					if (this.visibleInventoryDetailList.length === 0) {
						this.$message.error('请添加库存明细');
						return;
					}
					// 填充已删除的行信息，发送后端时计量单位统一为片数
					const deletedDetails = _.cloneDeep(this.deletedInventoryDetailList);
					const rawDetails = [..._.cloneDeep(this.visibleInventoryDetailList), ...deletedDetails];
					this.form.inventoryDetailList = rawDetails.map(d => ({
						...d,
						countingUnit: d.countingUnit === '片' ? '片数' : d.countingUnit || '片数'
					}));
					this.form.allLandFreight = this.isLand ? this.calculateDetailFreightTotal('landFreight') : 0;
					this.form.allSeaFreight = this.isSea ? this.calculateDetailFreightTotal('seaFreight') : 0;
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
		 * @description: 处理下拉菜单命令
		 * @param {string} command - 命令名称
		 * @param {object} row - 当前操作的行数据对象
		 */
		handleCommand(command, row) {
			switch (command) {
				case 'handleUpdate':
					this.handleUpdate(row);
					break;
				case 'handleDelete':
					this.handleDelete(row);
					break;
				default:
					break;
			}
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
		/** 添加新的库存详情行 */
		handleAddInventoryDetail() {
			const arrMaxItem = _.maxBy(this.inventoryDetailList, 'index');
			let obj = {
				// 添加唯一索引
				index: arrMaxItem ? arrMaxItem.index + 1 : 1,
				stockNumber: '',
				supplier: '',
				supplierId: '',
				levelID: '',
				levelName: '',
				countingUnit: '片数',
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
				customerCommission: '',
				factoryCommission: '',
				factoryRebateAmount: '',
				factoryDiscountAmount: '',
				comments: '',
				isEditing: true, // 默认处于编辑状态
				isDeleted: false, // 新添加的行未删除
				isAdd: true // 标记为新增行
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
		/**
		 * @description: 处理导出库存主列表数据按钮操作（前端Excel导出）。
		 *              使用 XLSX 库在前端生成 Excel 文件。
		 */
		handleExport() {
			try {
				// 开始导出提示
				this.$message({
					message: '正在生成Excel文件，请稍候...',
					type: 'info'
				});

				// 生成Excel数据
				const excelData = this.generateExcelData();

				// 创建工作簿并下载
				this.downloadExcel(excelData);

				// 成功提示
				this.$message({
					message: 'Excel文件导出成功！',
					type: 'success'
				});
			} catch (error) {
				console.error('Excel导出失败:', error);
				this.$message({
					message: 'Excel导出失败，请重试',
					type: 'error'
				});
			}
		},
		/**
		 * 生成Excel数据
		 * @returns {Object} 包含表头和数据的对象
		 */
		generateExcelData() {
			// 获取可见列配置
			const visibleColumns = this.columns.filter(col => col.visible && col.key !== 17); // 排除操作列

			// 生成表头
			const headers = visibleColumns.map(col => col.label);

			// 生成数据行
			const rows = this.inventoryMainList.map(row => {
				return visibleColumns.map(col => {
					return this.formatCellValue(row, col.key);
				});
			});

			return {
				headers,
				rows
			};
		},
		/**
		 * 格式化单元格值
		 * @param {Object} row - 行数据
		 * @param {number} colKey - 列键值
		 * @returns {string} 格式化后的值
		 */
		formatCellValue(row, colKey) {
			switch (colKey) {
				case 0: // ID
					return row.id || '';
				case 1: // 仓库名称
					return row.storeHouseName || '';
				case 2: // 入库日期
					return row.storeDate ? parseTime(row.storeDate, '{y}-{m}-{d}') : '';
				case 3: // 供应商
					return this.formatSuppliers(row);
				// 2026-02-06 删除货物来源公司
				case 5: // 审核状态
					return row.checkState || '未审核';
				case 6: // 陆运车牌
					return row.landCarNo || '';
				case 7: // 陆地司机姓名
					return row.landDriverName || '';
				case 8: // 柜号
					return row.seaCarNo || '';
				case 9: // 海运公司
					return row.seaDriverName || '';
				case 10: // 含税
					return row.isIncludeTaxSale === 1 ? '含税' : '不含税';
				case 11: {
					// 库存金额
					const raw = this.calculateTotalPayments(row);
					if (raw === null || raw === undefined || raw === '') return '';
					const num = Number(String(raw).replace(/,/g, '').trim());
					return isNaN(num) ? raw : num;
				}
				case 12: // 子项陆运费之和
					if (row.allLandFreight === null || row.allLandFreight === undefined || row.allLandFreight === '') return '';
					{
						const num = Number(String(row.allLandFreight).replace(/,/g, '').trim());
						return isNaN(num) ? row.allLandFreight : num;
					}
				case 13: // 子项海运费之和
					if (row.allSeaFreight === null || row.allSeaFreight === undefined || row.allSeaFreight === '') return '';
					{
						const num = Number(String(row.allSeaFreight).replace(/,/g, '').trim());
						return isNaN(num) ? row.allSeaFreight : num;
					}
				case 14: // 录入员
					return row.userName || '';
				case 18: {
					// 不含税利润
					const raw = this.calculateTotalProfitNoTax(row);
					if (raw === null || raw === undefined || raw === '') return '';
					const num = Number(String(raw).replace(/,/g, '').trim());
					return isNaN(num) ? raw : num;
				}
				case 15: // 附件
					return this.formatAttachments(row.attachmentList, 'path');
				case 16: // 收到条附件
					return this.formatAttachments(row.attachmentList, 'receiveProof');
				case 19: // 审核人员
					return row.checkUserName || '';
				default:
					return '';
			}
		},
		/**
		 * 格式化供应商信息
		 * @param {Object} row - 行数据
		 * @returns {string} 格式化后的字符串
		 */
		formatSuppliers(row) {
			const suppliers = row._uniqueSuppliers || [];
			if (suppliers.length === 0) return '-';
			return suppliers.map(s => s.supplier).join(', ');
		},
		/**
		 * 格式化附件信息
		 * @param {Array} attachmentList - 附件列表
		 * @param {string} type - 附件类型
		 * @returns {string} 格式化后的附件信息
		 */
		formatAttachments(attachmentList, type) {
			if (!Array.isArray(attachmentList)) return '无';

			const filteredAttachments = attachmentList.filter(item => item.flag === type);

			if (filteredAttachments.length === 0) return '无';

			return filteredAttachments.map(item => item.fileName || '附件').join(', ');
		},
		/**
		 * 下载Excel文件
		 * @param {Object} data - Excel数据
		 */
		downloadExcel(data) {
			// 创建工作表数据
			const worksheetData = [data.headers, ...data.rows];

			// 创建工作表
			const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);

			// 设置列宽（可选优化）
			const colWidths = data.headers.map(() => ({ wch: 15 }));
			worksheet['!cols'] = colWidths;

			// 创建工作簿
			const workbook = XLSX.utils.book_new();
			XLSX.utils.book_append_sheet(workbook, worksheet, '库存列表');

			// 生成文件名
			const fileName = `库存_${parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`;

			// 下载文件
			XLSX.writeFile(workbook, fileName);
		},
		/**
		 * @description: 处理导出全部库存主列表数据按钮操作（不分页导出）。
		 *              调用 download 方法，请求 'system/inventoryMain/export' 接口导出全部数据。
		 */
		handleExportNoPage() {
			this.download(
				'system/inventoryMain/export',
				{
					...this.queryParams,
					// 不分页的导出
					noPage: true
				},
				`库存_${new Date().getTime()}.xlsx`
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
		},
		/**
		 * 格式化数值用于输入框显示（仅用于显示，不影响实际存储值）
		 * @param {number|string} value - 需要格式化的值
		 * @param {number} precision - 小数位数（用于显示，如2或4）
		 * @returns {string} 格式化后的字符串（仅用于显示）
		 */
		formatValueForInput(value, precision = 2) {
			return formatValueForDisplay(value, precision);
		},
		// parseInputValue, formatValueForDisplay, getDecimalPlaces 已从 @/utils/order 导入，直接使用
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
				'customerCommission',
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
		 * 表头拖动结束后更新虚拟滚动表头布局
		 */
		onHeaderDragend() {
			// 使用自定义列，改变列宽度后，需要手动更新table头部
			if (this.$refs.virtualScroll) {
				this.$refs.virtualScroll.doHeaderLayout();
			}
		},
		/**
		 * 计算库存明细表格合计行
		 * @param {Object} param - 包含 columns 和 data
		 * @returns {Array} 合计行数据数组
		 */
		getInventoryDetailSummary(param) {
			const { columns } = param;
			const sums = [];
			// 使用可见的库存明细列表进行合计计算
			const data = this.visibleInventoryDetailList || [];
			// 需要合计的数字列（根据 prop 属性判断）
			const summaryColumns = ['paymentFactory', 'payments', 'tonnage', 'profit', 'profitNoTax'];

			columns.forEach((column, index) => {
				// 第一列是选择框，第二列是序号列，在序号列显示"合计"文字
				if (index === 1) {
					sums[index] = '合计';
					return;
				}
				// 第一列（选择框）显示空
				if (index === 0) {
					sums[index] = '';
					return;
				}

				// 判断当前列是否需要合计
				if (summaryColumns.includes(column.property)) {
					// 计算总和（使用 mathjs 高精度加法）
					const sum = data.reduce((prev, item) => {
						const value = Number(item[column.property]) || 0;
						return add(prev, value);
					}, 0);

					// 格式化显示（使用与数据列相同的格式）
					sums[index] = round(sum, 2).toFixed(2);
				} else {
					// 不需要合计的列显示空字符串
					sums[index] = '';
				}
			});

			return sums;
		}
	}
};
</script>

<style scoped lang="scss">
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
</style>
