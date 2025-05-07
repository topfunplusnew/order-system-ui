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

				<el-table-column v-if="columns[2].visible" label="入库日期" align="center" prop="storeDate" width="150" />

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

				<el-table-column v-if="columns[17].visible" label="收到条附件路径" align="center" prop="allSeaFreight" width="150" fixed="right">
					<template slot-scope="scope">
						<check-files :path="scope.row.receiveProof" @needToUpdate="value => handleUpdateFilePath(value, scope.row, 'receiveProof', getInventoryMain, updateInventoryMain)" />
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
		<el-dialog :title="title" :visible.sync="open" width="1200px" append-to-body :close-on-click-modal="false">
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
					<file-upload @input="handleCommitUpload" />
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
						<!-- 添加按钮：仅在编辑模式下可用 -->
						<el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddInventoryDetail" :disabled="!isEditingDetails">添加</el-button>
					</el-col>
					<el-col :span="1.5">
						<!-- 删除按钮：仅在编辑模式且有选中项时可用 -->
						<el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteInventoryDetail" :disabled="!isEditingDetails || checkedInventoryDetail.length === 0">
							删除
						</el-button>
					</el-col>
					<!-- 新增：编辑子项按钮 -->
					<el-col :span="1.5">
						<el-button size="mini" type="warning" @click="toggleEditDetails(true)" :disabled="isEditingDetails">编辑子项</el-button>
					</el-col>
					<!-- 新增：全部保存按钮 -->
					<el-col :span="1.5">
						<el-button size="mini" type="success" @click="toggleEditDetails(false)" :disabled="!isEditingDetails">全部保存</el-button>
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
					<!-- 选择列：仅在编辑模式下可选 -->
					<el-table-column type="selection" width="50" align="center" :selectable="() => isEditingDetails" />
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
							<el-radio-group v-model="scope.row.countingUnit" size="mini" :disabled="!scope.row.isEditing">
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
							<el-input size="mini" v-model="scope.row.piecesPerPack" placeholder="请输入每包片数" :disabled="!scope.row.isEditing" @input="() => calculatePieces(scope.row)" />
						</template>
					</el-table-column>
					<el-table-column label="包数" prop="packs" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model.lazy="scope.row.packs"
								:placeholder="scope.row.piecesPerPack <= 0 ? '请先输入每包片数' : '请输入包数'"
								:disabled="!scope.row.isEditing || scope.row.piecesPerPack <= 0"
								@input="() => calculatePieces(scope.row)"
							/>
						</template>
					</el-table-column>

					<el-table-column label="出厂片数" prop="pieces" width="150">
						<template #default="scope">
							<el-input
								size="mini"
								v-model="scope.row.pieces"
								placeholder="请输入出厂片数"
								@input="() => recalculateAll(scope)"
								@change="() => handlePiecesChange(scope)"
								:disabled="!scope.row.isEditing"
							/>
						</template>
					</el-table-column>

					<el-table-column label="出厂单价" prop="price" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input
								size="mini"
								v-model="scope.row.price"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.pieces <= 0 ? '请先完善出厂片数' : '请输入出厂单价'"
								:disabled="!scope.row.isEditing || !scope.row.pieces"
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
							<!-- 添加 disabled 属性 -->
							<el-input
								size="mini"
								v-model.lazy="scope.row.sundryCost"
								@input="() => recalculateAll(scope)"
								:placeholder="scope.row.price <= 0 ? '请先完善出厂单价' : '请输入杂费'"
								:disabled="!scope.row.isEditing || !scope.row.price"
							/>
						</template>
					</el-table-column>
					<el-table-column label="出厂货款" prop="paymentFactory" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
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
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model.lazy="scope.row.paymentUnload" placeholder="请输入存货价" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
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

					<!--					<el-table-column label="库存杂费" prop="paymentsWithSundry" width="150">-->
					<!--						<template #default="scope">-->
					<!--							&lt;!&ndash; 添加 disabled 属性 &ndash;&gt;-->
					<!--							<el-input-->
					<!--								size="mini"-->
					<!--								v-model.lazy="scope.row.paymentsWithSundry"-->
					<!--								@input="() => recalculateAll(scope)"-->
					<!--								:disabled="!scope.row.isEditing || !scope.row.paymentUnload"-->
					<!--								:placeholder="scope.row.paymentUnload <= 0 ? '请先完善存货价' : '请输入库存杂费'"-->
					<!--							/>-->
					<!--						</template>-->
					<!--					</el-table-column>-->
					<el-table-column label="库存金额" prop="payments" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
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
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model.lazy="scope.row.landFreightPrice" @input="() => recalculateAll(scope)" placeholder="请输入陆运费单价" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="加费" prop="additionalFees" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input
								size="mini"
								v-model.lazy="scope.row.additionalFees"
								@input="() => recalculateAll(scope)"
								:placeholder="!scope.row.landFreightPrice ? '请先完善陆运费单价' : '请输入加费'"
								:disabled="!scope.row.isEditing"
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
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model.lazy="scope.row.seaFreight" @input="() => recalculateAll(scope)" placeholder="请输入海运费" :disabled="!scope.row.isEditing" />
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
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model.lazy="scope.row.otherCost" placeholder="请输入其他费用" @input="() => recalculateAll(scope)" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="利润" prop="profit" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.profit" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="不含税利润" prop="profitNoTax" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.profitNoTax" placeholder="自动计算" disabled />
						</template>
					</el-table-column>
					<el-table-column label="物流利润" prop="logisticsProfit" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.logisticsProfit" placeholder="请输入物流利润" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="厂家佣金" prop="factoryCommission" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.factoryCommission" placeholder="请输入厂家佣金" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家返利金额" prop="factoryRebateAmount" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.factoryRebateAmount" placeholder="请输入计提厂家返利金额" :disabled="!scope.row.isEditing" />
						</template>
					</el-table-column>
					<el-table-column label="计提厂家降价金额" prop="factoryDiscountAmount" width="150">
						<template #default="scope">
							<!-- 添加 disabled 属性 -->
							<el-input size="mini" v-model="scope.row.factoryDiscountAmount" placeholder="请输入计提厂家降价金额" :disabled="!scope.row.isEditing" />
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
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
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
	components: { DialogWrapper, SearchOption, CheckFiles, StateTag },
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
			rules: {
				storeHouseName: [{ required: true, message: '仓库名称不能为空', trigger: 'blur' }],
				storeDate: [{ required: true, message: '入库日期不能为空', trigger: 'change' }],
				goodsCompany: [{ required: true, message: '货物来源公司不能为空', trigger: 'blur' }],
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
	methods: {
		listStoreHouse,
		listInventory,
		listCars,
		listFleet,
		listProductLevel,
		listCompany,
		getInventoryMain, // 确保已引入
		updateInventoryMain, // 确保已引入
		handleCommitUpload(val) {
			this.form.receiveProof = val;
		},
		updateTransportMode() {
			this.form.transportMode = this.isLand || this.isSea ? 'selected' : '';
			this.$nextTick(() => {
				if (this.$refs.form) {
					this.$refs.form.validateField('transportMode');
				}
			});
		},
		handleRowEdit(row) {
			// 设置当前行为可编辑
			this.$set(row, 'isEditing', true);
			// 清除错误状态
			if (row.hasError) {
				this.$set(row, 'hasError', false);
			}
			this.$message.info('正在编辑该条记录');
		},
		handleRowSave(row) {
			// 统一处理输入，确保 rows 是数组
			const rows = Array.isArray(row) ? row : [row];
			// 处理每一行，关闭编辑状态并更新计算
			rows.forEach(r => {
				if (r.isEditing) {
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
						// TODO  更新主表ID，后续保存变为更新操作
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
					// this.isEditingDetails = true; // 保持全局编辑状态
				});
		},
		toggleEditDetails(editState) {
			this.isEditingDetails = editState;
			if (editState) {
				// 进入编辑模式时清除所有错误标记
				this.inventoryDetailList.forEach(row => {
					if (row.hasError) {
						this.$set(row, 'hasError', false);
					}
				});
				this.$message.info('已进入批量编辑模式，可以修改所有库存信息');
			} else {
				// 退出编辑模式时，保存所有正在编辑的行
				const rowsToSave = this.inventoryDetailList.filter(row => row.isEditing);
				if (rowsToSave.length > 0) {
					this.handleRowSave(rowsToSave); // 调用批量保存
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
		handlePiecesChange(scope) {
			// 将出厂片数的值赋给实际片数
			scope.row.stockNumber = scope.row.pieces;
			// 触发重新计算
			this.recalculateAll(scope);
		},
		calculatePieces(row) {
			if (row.piecesPerPack > 0 && row.packs > 0) {
				// 计算出厂片数
				row.pieces = (row.piecesPerPack * row.packs).toString();
				// 设置入库量等于出厂片数
				row.stockNumber = row.pieces;
				// 触发重新计算
				this.recalculateAll({ row });
			}
		},
		handleCheck(row) {
			this.$confirm({
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

			// 填充后重新计算
			this.recalculateAll(scope); // 确保调用 recalculateAll
		},
		// 使用抽离出的计算函数的工具方法
		recalculateAll(scope) {
			// 确保在 nextTick 中执行，以允许 Vue 更新 DOM/数据绑定
			this.$nextTick(() => {
				updateInventoryRowCalculations(scope.row, this.isSea, this.isLand);
			});
		},
		handleCommitBackFleet(val) {
			this.form.fleet = val.fname;
			// 手动触发 fleet 字段的校验
			this.$refs.form.validateField('fleet');
		},
		// 在 handleCommitBackCar 中手动触发 landCarNo 字段的校验
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
		handleNodeClick(data) {
			this.loading = true;
			listInventoryMain({ storeHouseName: data.label }).then(res => {
				this.inventoryMainList = res.rows;
				this.loading = false;
			});
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
			this.isEditingDetails = false; // 重置编辑状态
		},
		// 表单重置
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
				receiveProof: null,
				transportMode: '' // 重置运输方式校验字段
			};
			this.inventoryDetailList = [];
			this.isEditingDetails = false; // 重置编辑状态
			if (this.$refs.form) {
				this.$refs.form.resetFields();
				this.$refs.form.clearValidate();
			}
		},
		// 清除子项详情 (如果需要)
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
		// 设置当前类型 (用于供应商/仓库切换显示)
		setCurrentType(row, type) {
			this.$set(row, 'currentType', type);
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
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getInventoryMain(id).then(response => {
				this.form = response.data;
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
		/** 提交按钮 */
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
					apiCall(this.form)
						.then(() => {
							this.$modal.msgSuccess(successMessage);
							this.open = false;
							this.getList();
							this.isEditingDetails = false; // 关闭弹窗时重置编辑状态
						})
						.catch(error => {
							this.$message.error('提交失败: ' + (error.message || '未知错误'));
						});
				} else {
					this.$message.error('请检查表单必填项!');
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
		/** 库存子删除按钮操作 */
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
		/** 复选框选中数据 */
		handleInventoryDetailSelectionChange(selection) {
			// 更新选中的行的索引列表 (注意 index 是从1开始的)
			this.checkedInventoryDetail = selection.map(item => this.inventoryDetailList.findIndex(listItem => listItem === item) + 1);
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

/* 新增：编辑行样式 */
::v-deep .editing-row {
	background-color: rgba(121, 246, 164, 0.1) !important; /* 提高优先级 */
}

::v-deep .editing-row td:first-child {
	border-left: 4px solid #63f697 !important;
}

::v-deep .editing-row:hover > td {
	/* 应用到td上避免覆盖 */
	background-color: rgba(121, 246, 164, 0.15) !important; /* 悬停时稍微加深 */
}

/* 新增：错误行样式 */
::v-deep .error-row {
	background-color: rgba(245, 108, 108, 0.1) !important; /* 提高优先级 */
}

::v-deep .error-row td:first-child {
	border-left: 4px solid #f56c6c !important;
}

::v-deep .error-row:hover > td {
	/* 应用到td上避免覆盖 */
	background-color: rgba(245, 108, 108, 0.15) !important; /* 悬停时稍微加深 */
}

/* 新增：为出错行添加闪烁动画效果提高可见性 */
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

/* 应用动画到错误行的td，避免干扰其他样式 */
::v-deep .error-row td {
	animation: errorPulse 2s infinite;
}

/* 确保动画不会覆盖悬停效果 */
::v-deep .error-row:hover td {
	animation: none; /* 悬停时停止动画 */
	background-color: rgba(245, 108, 108, 0.15) !important;
}

/* 添加运输方式错误样式 */
.transport-error {
	color: #f56c6c;
	margin-left: 10px;
	font-size: 12px;
}

/* 滚动条样式 (保留) */
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
