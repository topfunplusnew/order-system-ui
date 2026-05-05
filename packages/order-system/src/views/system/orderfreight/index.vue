<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="180px">
			<el-form-item label="申请开始日期" prop="applyDate">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期" clearable />
			</el-form-item>
			<el-form-item label="支付时间">
				<el-date-picker v-model="queryParams.paymentDateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" clearable style="width: 240px" />
			</el-form-item>
			<!-- 修改为海运公司 -->
			<el-form-item label="海运公司" prop="driverName">
				<el-input v-model="queryParams.driverName" placeholder="请输入司机名称" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="车牌/柜号" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入车牌/柜号" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="车队名称" prop="fleet">
				<el-input v-model="queryParams.fleet" placeholder="请输入车队名称" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input v-model="queryParams.otherAcountsName" placeholder="请输入车队名称" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="支付状态" prop="paymentState">
				<el-select v-model="queryParams.paymentState" placeholder="请选择" size="mini" clearable @keyup.enter.native="handleQuery">
					<el-option v-for="item in PaymentState()" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh-left" size="mini" @click="resetQuery">重置查询</el-button>
			</el-form-item>
		</el-form>

		<!-- 运费ID过滤提示 -->
		<div v-if="currentFreightId" class="freight-filter-banner">
			<el-alert :title="`当前正在查看运费ID为 ${currentFreightId} 的运费记录`" type="info" :closable="false" show-icon>
				<template slot="title">
					<span>
						当前正在查看运费ID为
						<strong>{{ currentFreightId }}</strong>
						的运费记录
					</span>
				</template>
			</el-alert>
		</div>

		<el-row :gutter="10" class="mb8">
			<!-- 刷新按钮-->
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="success" size="mini" @click="selectUnPayment(orderFreightList)">勾选未支付</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="success" size="mini" :disabled="freightPaymentOnceDisabled" @click="handleFreightPaymentOnce">一键付运费</el-button>
			</el-col>

			<!-- 一键冲抵款按钮 -->
			<el-col :span="1.5">
				<el-button :disabled="offsetSelections.length <= 0" size="mini" type="warning" @click="handleOffsetPayment">一键冲抵款</el-button>
			</el-col>

			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList" tableName="freight-columns">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:orderfreight:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" ref="multipleTable" v-horizontal-scroll="'always'" v-loading="loading" border :data="orderFreightList" max-height="600px" size="mini" :row-class-name="getFreightRowClassName" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column width="80" align="center" label="冲抵选择">
				<template #header>
					<el-checkbox v-model="selectAllOffset" :indeterminate="isOffsetIndeterminate" @change="handleOffsetSelectAll"></el-checkbox>
				</template>
				<template #default="{ row }">
					<el-checkbox :value="isOffsetRowSelected(row)" :disabled="row.paymentState === PAYMENT_STATE.PAID" @input="value => handleOffsetToggle(row, value)"></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column label="ID" align="center" prop="id" width="80" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.id }}</div>
						<span>{{ scope.row.id }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[0].visible" label="支付状态" align="center" prop="paymentState" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.paymentState === PAYMENT_STATE.PAID ? PAYMENT_STATE.PAID : PAYMENT_STATE.UNPAID }}</div>
						<el-tag v-if="scope.row.paymentState === PAYMENT_STATE.PAID" type="success" size="mini">{{ PAYMENT_STATE.PAID }}</el-tag>
						<el-tag v-else type="danger" size="mini">{{ PAYMENT_STATE.UNPAID }}</el-tag>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="付款日期" align="center" prop="payDate" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.payDate }}</div>
						<span>{{ scope.row.payDate }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="运费来源" align="center" prop="sourceType" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="客户" align="center" prop="customer" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.customer }}</div>
						<span>{{ scope.row.customer }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="车牌号/柜号" align="center" prop="carNo" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.carNo }}</div>
						<span>{{ scope.row.carNo }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="运费类型" align="center" prop="freightType" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.freightType }}</div>
						<span>{{ scope.row.freightType }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="车队" align="center" prop="fleet" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.fleet }}</div>
						<span>{{ scope.row.fleet }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[7].visible" label="海运公司" align="center" prop="driverName" width="120" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.driverName }}</div>
						<span>{{ scope.row.driverName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="金额" align="center" prop="moneyAmount" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.moneyAmount }}</div>
						<span>{{ scope.row.moneyAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="对方户名" align="center" prop="otherAcountsName" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.otherAcountsName }}</div>
						<span>{{ scope.row.otherAcountsName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="对方账号" align="center" prop="otherBankNo" width="180" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.otherBankNo }}</div>
						<span>{{ scope.row.otherBankNo }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="我方户名" align="center" prop="selfAcountsName" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.selfAcountsName }}</div>
						<span>{{ scope.row.selfAcountsName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="我方账号" align="center" prop="selfBankNo" width="180" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.selfBankNo }}</div>
						<span>{{ scope.row.selfBankNo }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[13].visible" label="付款人" align="center" prop="payUserName" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.payUserName }}</div>
						<span>{{ scope.row.payUserName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[14].visible" label="申请日期" align="center" prop="applyDate" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.applyDate }}</div>
						<span>{{ scope.row.applyDate }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[15].visible" label="申请人" align="center" prop="applyUserName" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.applyUserName }}</div>
						<span>{{ scope.row.applyUserName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[16].visible" label="备注" align="center" prop="comments" width="100" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.comments }}</div>
						<span>{{ scope.row.comments }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="200">
				<template slot-scope="scope">
					<CheckOrderInfo :row="scope.row" :track-row="trackFreightActionRow" />
					<el-button size="mini" type="warning" :disabled="scope.row.paymentState !== PAYMENT_STATE.PAID" @click="handleFillFreight(scope.row)">修正</el-button>
					<el-button v-if="scope.row.isedit" v-hasPermi="['system:orderfreight:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:orderfreight:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="对方户名" prop="otherAcountsName">
					<el-row>
						<el-col :span="10">
							<el-input v-model="form.otherAcountsName" placeholder="请输入对方户名" :disabled="bankInputDisabled" />
						</el-col>
						<el-col v-if="bankInputDisabled === false" :span="3">
							<SearchOption :get-data="listBankAccount" icon="el-icon-search" :limit-info="{}" query-label="户名查找" query-info="acountsName" :query-name="queryCompany" @commitBack="handleCommitBack" @update:queryName="handleUpdateQueryName">
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName" />
									<el-table-column label="公司类型" align="center" prop="companyType" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="账号" align="center" prop="bankNo" width="180" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方账号" prop="otherBankNo">
					<el-input v-model="form.otherBankNo" placeholder="请输入对方账号" />
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" />
				</el-form-item>
				<el-form-item label="备注">
					<el-input v-model="form.content" placeholder="请输入备注" />
				</el-form-item>
				<el-form-item label="司机姓名" prop="driverName">
					<el-input v-model="form.driverName" placeholder="请输入司机姓名" />
				</el-form-item>
				<el-form-item label="车牌号/柜号" prop="carNo">
					<el-row>
						<el-col :span="20">
							<el-input v-model="form.carNo" placeholder="请输入车牌号" />
						</el-col>
						<el-col :span="4">
							<SearchOption :limit-info="{ dictType: 'order_cars' }" :get-data="listData" query-label="车牌搜索" :query-name="queryCars" query-info="dictLabel" @update:queryName="updateQueryCars" @commitBack="handleCommitBackCars">
								<template #table-columns>
									<el-table-column label="车牌" prop="dictLabel" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="车队" prop="fleet">
					<el-col :span="20">
						<el-input v-model="form.fleet" placeholder="请输入车队" />
					</el-col>
					<el-col :span="4">
						<SearchOption :limit-info="{}" :get-data="listFleet" query-label="车队名称搜索" :query-name="queryFleet" query-info="fname" @update:queryName="updateQueryFleet" @commitBack="handleCommitBackFleet">
							<template #table-columns>
								<el-table-column label="车队名称" prop="fname" />
							</template>
						</SearchOption>
					</el-col>
				</el-form-item>
				<el-form-item label="申请日期" prop="applyDate">
					<el-date-picker v-model="form.applyDate" type="datetime" placeholder="请选择申请日期" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="付款日期" prop="payDate">
					<el-date-picker v-model="form.payDate" type="datetime" placeholder="请选择付款日期" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    一键付运费的弹窗-->
		<InfoDialog :visible="freightOnceVisible" title="一键付运费" @close="freightOnceVisible = false">
			<template #info>
				<div class="order-freight-body">
					<!--          上方：我方付款信息（inline表单）-->
					<div class="order-freight-self-info">
						<el-form ref="freightPaymentOnceForm" :model="freightSelfOnceInfo" :rules="freightSelfOnceInfoRules" :inline="true" label-width="120px">
							<el-form-item label="支付类型" prop="payType">
								<el-cascader v-model="freightSelfOnceInfo.payType" :options="paymentTypeTree" :props="props" />
							</el-form-item>
							<el-form-item label="支付时间" prop="fundsDate">
								<el-date-picker v-model="freightSelfOnceInfo.fundsDate" type="datetime" placeholder="请选择支付时间" value-format="yyyy-MM-dd HH:mm:ss" :clearable="false" />
							</el-form-item>
							<el-form-item label="我方户名" prop="selfAccountsName">
								<el-row>
									<el-col :span="18">
										<el-input v-model="freightSelfOnceInfo.selfAccountsName" placeholder="请输入我方户名" />
									</el-col>
									<!--   自定义组件查找-->
									<el-col :span="6">
										<SearchOption
											:get-data="listBankAccount"
											title="银行卡信息"
											icon="el-icon-search"
											:limit-info="{
												acountsType: '己方公司'
											}"
											:query-name="bankQuery"
											query-info="acountsName"
											query-label="户名查询"
											@commitBack="handleCallBack"
											@update:queryName="handleCommitBackBank"
										>
											<template #table-columns>
												<el-table-column label="账户类型" align="center" prop="acountsType" />
												<el-table-column label="己方公司" align="center" prop="displayName" />
												<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
												<el-table-column label="账号(银行账号)" align="center" prop="bankNo" width="200" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="公司名称" align="center" prop="companyName" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<el-form-item label="我方账号" prop="selfBankNo">
								<el-input v-model="freightSelfOnceInfo.selfBankNo" placeholder="请输入我方账号" />
							</el-form-item>
							<el-form-item label="我方开户行" prop="selfBankName">
								<el-input v-model="freightSelfOnceInfo.selfBankName" placeholder="请输入我方开户行" />
							</el-form-item>
							<el-form-item>
								<el-button type="success" size="medium" @click="submitFreightOnce">一键付运费</el-button>
							</el-form-item>
						</el-form>
					</div>
					<!--          下方：运费信息表格-->
					<div class="order-freight-info">
						<el-table :data="displayFreightList" border size="mini" max-height="400px" style="width: 100%" show-summary :summary-method="getFreightSummary">
							<el-table-column type="index" label="序号" width="80" align="center" />
							<el-table-column label="客户" prop="customer" min-width="150" align="center" show-overflow-tooltip />
							<el-table-column label="车牌号/柜号" prop="carNo" min-width="150" align="center" show-overflow-tooltip />
							<el-table-column label="车队" prop="fleet" min-width="150" align="center" show-overflow-tooltip />
							<el-table-column label="海运公司" prop="driverName" min-width="150" align="center" show-overflow-tooltip />
							<el-table-column label="金额" prop="moneyAmount" min-width="150" align="center" show-overflow-tooltip />
							<el-table-column label="对方户名" prop="otherAcountsName" min-width="180" align="center" show-overflow-tooltip />
							<el-table-column label="对方账号" prop="otherBankNo" min-width="220" align="center" show-overflow-tooltip />
						</el-table>
					</div>
				</div>
			</template>
		</InfoDialog>

		<!--    created第一次传递的props，然后监听后来props的变化-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="运费付款申请" :visible.sync="applyPaymentVisible" width="500px" append-to-body>
			<keep-alive>
				<ApplyPayment :table-name="TableName.ORDER_FREIGHT" :t-i-d="tID" :need-info="needInfo" :need-money="freight" @changeOpen="changeOpen" />
			</keep-alive>
		</el-dialog>

		<!--     运费修正弹窗-->
		<InfoDialog :visible.sync="fillFreightVisible" title="运费修正" :width="'750px'" @close="cancelFillFreight">
			<template #info>
				<el-form ref="fillFreightFormRef" :model="fillFreightForm" :rules="fillFreightRules" label-width="100px">
					<el-form-item label="金额" prop="moneyAmount">
						<el-input v-model="fillFreightForm.moneyAmount" placeholder="请输入金额" @input="onFillFreightMoneyInput" />
					</el-form-item>
					<el-form-item label="车牌号/柜号" prop="carNo">
						<el-row>
							<el-col :span="20">
								<el-input disabled v-model="fillFreightForm.carNo" placeholder="自动填充" />
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="对方户名" prop="otherAcountsName">
						<el-row>
							<el-col :span="16">
								<el-input v-model="fillFreightForm.otherAcountsName" placeholder="请输入对方户名或点击搜索" />
							</el-col>
							<el-col :span="4">
								<SearchOption :get-data="listBankAccount" icon="el-icon-search" :limit-info="{}" query-label="户名查找" query-info="acountsName" :query-name="queryBankAccount" @commitBack="handleCommitBackBankAccount" @update:queryName="updateQueryBankAccount">
									<template #table-columns>
										<el-table-column label="公司名称" align="center" prop="companyName" />
										<el-table-column label="公司类型" align="center" prop="companyType" />
										<el-table-column label="开户行" align="center" prop="bankName" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="对方账号" prop="otherBankNo">
						<el-input v-model="fillFreightForm.otherBankNo" placeholder="请输入对方账号或点击上方搜索自动填充" />
					</el-form-item>
					<el-form-item label="对方开户行">
						<el-input v-model="fillFreightForm.otherBankName" placeholder="请输入对方开户行或点击上方搜索自动填充" />
					</el-form-item>
					<el-form-item label="车队" prop="fleet">
						<el-col :span="20">
							<el-input disabled v-model="fillFreightForm.fleet" placeholder="自动填充" />
						</el-col>
					</el-form-item>
					<el-form-item label="申请日期" prop="applyDate">
						<el-date-picker v-model="fillFreightForm.applyDate" type="datetime" placeholder="请选择申请日期" value-format="yyyy-MM-dd HH:mm:ss" />
					</el-form-item>
					<el-form-item label="备注" prop="comments">
						<el-input v-model="fillFreightForm.comments" placeholder="请输入备注" />
					</el-form-item>
				</el-form>
				<div slot="footer" class="dialog-footer" style="text-align: center">
					<el-button type="primary" @click="submitFillFreightForm">确 定</el-button>
					<el-button @click="cancelFillFreight">取 消</el-button>
				</div>
			</template>
		</InfoDialog>
	</div>
</template>

<script>
import { listOrderFreight, getOrderFreight, delOrderFreight, addOrderFreight, updateOrderFreight } from '@/api/system/orderFreight';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { TableName } from '@/api/tool/enums';
import { addDateRange, parseTime } from '@/utils/ruoyi';
import { listData } from '@/api/system/dict/data';
import { listFleet } from '@/api/system/fleet';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_order_base } from '../../dashboard/mixins/order/order_base';
import { mixin_order_freight_payment } from '../../dashboard/mixins/order/order_freight_payment';
import InfoDialog from '../../../components/InfoDialog.vue';
import { mixin_payment_subject } from '../../dashboard/mixins/payment/payment_subject';
import { PaymentState, PAYMENT_STATE } from '../../../api/tool/enums';
import CheckOrderInfo from '../../dashboard/components/orderfreight/CheckOrderInfo.vue';
import { mixin_order_freight_fill } from './orderFreightFill';
import { FREIGHT_TYPE, mixin_freight_payment } from '@/views/dashboard/mixins/freight/freight_payment';
import { fix_2 } from '../../../api/tool/format';
import { common_dialog } from '../../dashboard/mixins/common/common_dialog';
import { listGoodsOrder } from '@/api/system/goodsOrder';
import { isNull } from '@/main';
import { batchDeleteUserConfig, getUserConfig, saveUserConfig } from '@/api/user-config';
import { UserConfigKey } from '@/api/tool/user-config';

export default {
	name: 'OrderFreight',
	components: {
		CheckOrderInfo,
		InfoDialog,
		ApplyPayment,
		SearchOption
	},
	mixins: [common_dialog, mixin_order_freight_fill, mixin_order_base, mixin_order_freight_payment, /* 引入支付类型的混入*/ mixin_payment_subject, /* 引入支付类型的混入*/ mixin_freight_payment],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			dateRange: [],
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 订单运费表格数据
			orderFreightList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				ordersNo: null,
				freightType: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				content: null,
				paymentState: null,
				driverName: null,
				driverId: null,
				carNo: null,
				fleet: null,
				applyUserId: null,
				applyUserName: null,
				applyDate: null,
				isedit: null,
				payUserId: null,
				payUserName: null,
				payDate: null,
				paymentDateRange: null,
				params: {
					payDateStartTime: null,
					payDateEndTime: null
				}
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {},
			columns: [
				{ key: 0, label: `支付状态`, visible: true },
				{ key: 1, label: `付款日期`, visible: true },
				{ key: 2, label: `运费来源`, visible: true },
				{ key: 3, label: `客户`, visible: true },
				{ key: 4, label: `车牌号/柜号`, visible: true },
				{ key: 5, label: `运费类型`, visible: true },
				{ key: 6, label: `车队`, visible: true },
				{ key: 7, label: `海运公司`, visible: true },
				{ key: 8, label: `金额`, visible: true },
				{ key: 9, label: `对方户名`, visible: true },
				{ key: 10, label: `对方账号`, visible: true },
				{ key: 11, label: `我方户名`, visible: true },
				{ key: 12, label: `我方账号`, visible: true },
				{ key: 13, label: `付款人`, visible: true },
				{ key: 14, label: `申请日期`, visible: true },
				{ key: 15, label: `申请人`, visible: true },
				{ key: 16, label: `备注`, visible: true }
			],
			bankInputDisabled: false,
			tID: null,
			freight: null,
			applyInfo: null,
			applyPaymentVisible: false,
			needInfo: {},
			freightSelfOnceInfo: {
				payType: null,
				fundsDate: '',
				selfAccountsName: '',
				selfBankNo: '',
				selfBankName: '',
				otherBankCardType: null
			},
			freightSelfOnceInfoRules: {
				payType: [
					{
						required: true,
						message: '请选择支付类型',
						trigger: 'change'
					}
				],
				selfAccountsName: [
					{
						required: true,
						message: '请输入我方户名',
						trigger: 'blur'
					}
				],
				selfBankNo: [
					{
						required: true,
						message: '请输入我方账号',
						trigger: 'blur'
					}
				],
				selfBankName: [
					{
						required: true,
						message: '请输入我方开户行',
						trigger: 'blur'
					}
				]
			},
			// 冲抵款相关数据
			offsetSelections: [], // 冲抵选择的数据
			selectAllOffset: false, // 全选状态
			// 运费修正相关数据
			fillFreightVisible: false, // 运费修正弹窗显示状态
			fillFreightForm: {}, // 运费修正表单数据
			fillFreightRules: {
				// 金额校验：必须为数值，最多两位小数，允许负数
				moneyAmount: [
					{ required: true, message: '请输入金额', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (value === null || value === undefined || value === '' || value === '-') {
								return callback(new Error('请输入金额'));
							}
							const str = String(value).trim();
							// 允许负数、小数，最多两位小数
							if (!/^-?\d+(?:\.\d{1,2})?$/.test(str)) {
								return callback(new Error('请输入有效金额，最多两位小数，可输入负数'));
							}
							if (Number(str) === 0) {
								return callback(new Error('金额不能为 0'));
							}
							return callback();
						},
						trigger: 'blur'
					}
				],
				otherAcountsName: [
					{
						required: true,
						message: '请输入对方户名或点击搜索选择',
						trigger: 'blur'
					}
				],
				otherBankNo: [
					{
						required: true,
						message: '请输入对方账号或点击搜索选择',
						trigger: 'blur'
					}
				],
				applyDate: [
					{
						required: true,
						message: '请选择申请日期',
						trigger: 'blur'
					}
				]
			},
			// 运费修正搜索字段
			queryBankAccount: '', // 银行账户搜索字段
			currentFreightId: null, // 当前过滤的运费ID（可能是单个ID或数组）
			currentFreightIds: [], // 当前过滤的运费ID数组
			currentOtherBankNo: null, // 当前过滤的对方银行卡号
			/** 操作列交互后持久化高亮：当前运费行 id（字符串，与用户配置一致） */
			activeFreightActionRowId: null
		};
	},
	computed: {
		FREIGHT_TYPE() {
			return FREIGHT_TYPE;
		},
		TableName() {
			return TableName;
		},
		PAYMENT_STATE() {
			return PAYMENT_STATE;
		},
		// 运费状态自定义样式映射
		freightStatusStyles() {
			return {
				PAID: {
					color: '#67C23A'
				},
				UNPAID: {
					color: '#F56C6C'
				}
			};
		},
		// 冲抵选择相关计算属性
		// 是否半选状态
		isOffsetIndeterminate() {
			const selectedCount = this.offsetSelections.length;
			const unpaidCount = this.orderFreightList.filter(item => item.paymentState !== PAYMENT_STATE.PAID).length;
			return selectedCount > 0 && selectedCount < unpaidCount;
		}
	},
	watch: {
		isOffsetIndeterminate: {
			handler(newVal) {
				this.selectAllOffset = newVal;
			},
			immediate: true
		},
		// 监听路由中的 freightId 参数变化
		'$route.query.freightId': {
			handler(newFreightId, oldFreightId) {
				// 当 freightId 从无到有，或者从一个值变为另一个值时，触发查询
				if (newFreightId && newFreightId !== oldFreightId) {
					this.queryByFreightId(newFreightId);
				} else if (!newFreightId && oldFreightId) {
					// 当 freightId 被清除时，恢复正常查询
					this.currentFreightId = null;
					this.currentFreightIds = [];
					this.getList();
				}
			},
			immediate: false
		},
		// 监听路由中的 otherBankNo 参数变化
		'$route.query.otherBankNo': {
			handler(newOtherBankNo, oldOtherBankNo) {
				// 当 otherBankNo 从无到有，或者从一个值变为另一个值时，触发查询
				if (newOtherBankNo && newOtherBankNo !== oldOtherBankNo) {
					this.queryByOtherBankNo(newOtherBankNo);
				} else if (!newOtherBankNo && oldOtherBankNo) {
					// 当 otherBankNo 被清除时，恢复正常查询
					this.currentOtherBankNo = null;
					this.getList();
				}
			},
			immediate: false
		}
	},
	created() {
		this.initFreightActionRowState();
		// 拿到地址栏中的参数
		const { fundsDate, driver, freightId, otherBankNo } = this.$route.query;
		// 如果存在对方银行卡号
		if (otherBankNo) {
			// 根据对方银行卡号查询对应的运费记录
			this.queryByOtherBankNo(otherBankNo);
		} else if (freightId) {
			// 根据运费ID查询对应的运费记录
			this.queryByFreightId(freightId);
		} else if (fundsDate && driver) {
			// 拿取地址中的参数 查询list
			this.getQueryParams(fundsDate, driver);
		} else {
			// 如果没有 正常查询
			this.getList();
		}
		// 设置本地存储
	},
	mounted() {
		// 只清除 fundsDate 和 driver 参数，保留 freightId 和 otherBankNo 参数
		const { fundsDate, driver, freightId, otherBankNo } = this.$route.query;
		if ((fundsDate || driver) && !freightId && !otherBankNo) {
			// 如果有 fundsDate 或 driver 参数但没有 freightId 和 otherBankNo，清除这些参数
			this.$router.replace({ path: this.$route.path });
		}
		// 如果有 freightId 或 otherBankNo，保留它们，不清除
	},
	methods: {
		/**
		 * 将运费行主键规范为与用户配置一致的字符串，空值返回 null
		 * @param {*} value 行 id
		 * @returns {string|null}
		 */
		normalizeFreightActionRowId(value) {
			if (value === null || value === undefined || value === '') {
				return null;
			}
			return String(value);
		},
		/**
		 * 解析 getUserConfig 返回体中的 value（支持 JSON 字符串）
		 * @param {*} response 接口响应
		 * @returns {*}
		 */
		parseUserConfigValue(response) {
			const configValue = response?.data?.value ?? response?.data ?? null;
			if (typeof configValue !== 'string') {
				return configValue;
			}
			try {
				return JSON.parse(configValue);
			} catch (error) {
				return configValue;
			}
		},
		/**
		 * 从用户配置对象中取出运费行 id（与订单列表 active 行结构一致：{ key: { id } }）
		 * @param {*} configValue 配置值
		 * @returns {string|null}
		 */
		extractFreightActionRowId(configValue) {
			if (!configValue) {
				return null;
			}
			if (typeof configValue === 'object') {
				const nestedConfig = configValue.key;
				if (nestedConfig && typeof nestedConfig === 'object') {
					return this.normalizeFreightActionRowId(nestedConfig.id ?? nestedConfig.rowId ?? null);
				}
				return this.normalizeFreightActionRowId(configValue.id ?? configValue.rowId ?? null);
			}
			return this.normalizeFreightActionRowId(configValue);
		},
		/**
		 * 是否为浏览器整页刷新（刷新时不恢复高亮并清理服务端配置）
		 * @returns {boolean}
		 */
		isPageReload() {
			if (typeof window === 'undefined' || !window.performance) {
				return false;
			}
			if (typeof window.performance.getEntriesByType === 'function') {
				const navigationEntries = window.performance.getEntriesByType('navigation');
				if (Array.isArray(navigationEntries) && navigationEntries.length > 0) {
					return navigationEntries[0].type === 'reload';
				}
			}
			if (window.performance.navigation) {
				return window.performance.navigation.type === 1;
			}
			return false;
		},
		/** 进入页面时恢复或清理运费列表操作行高亮 */
		async initFreightActionRowState() {
			if (this.isPageReload()) {
				await this.clearFreightActionRowState();
				return;
			}
			await this.loadFreightActionRowState();
		},
		/** 从用户配置加载要高亮的运费行 id */
		async loadFreightActionRowState() {
			try {
				const response = await getUserConfig(UserConfigKey.ORDER_FREIGHT_ACTIVE_ACTION_ROW);
				const configValue = this.parseUserConfigValue(response);
				this.activeFreightActionRowId = this.extractFreightActionRowId(configValue);
			} catch (error) {
				void error;
				this.activeFreightActionRowId = null;
			}
		},
		/** 清除本地与服务端保存的运费操作行高亮 */
		async clearFreightActionRowState() {
			this.activeFreightActionRowId = null;
			try {
				await batchDeleteUserConfig([UserConfigKey.ORDER_FREIGHT_ACTIVE_ACTION_ROW]);
			} catch (error) {
				void error;
			}
		},
		/**
		 * 记录当前操作行并异步写入用户配置
		 * @param {Object} row 表格行
		 */
		trackFreightActionRow(row) {
			const rowId = this.normalizeFreightActionRowId(row && row.id);
			if (!rowId) {
				return;
			}
			this.activeFreightActionRowId = rowId;
			saveUserConfig(UserConfigKey.ORDER_FREIGHT_ACTIVE_ACTION_ROW, {
				key: {
					id: rowId
				}
			}).catch(error => {
				void error;
			});
		},
		/**
		 * Element Table 行类名：与 activeFreightActionRowId 匹配的行高亮
		 * @param {{ row: Object }} param0 行参数
		 * @returns {string}
		 */
		getFreightRowClassName({ row }) {
			const currentRowId = this.normalizeFreightActionRowId(row && row.id);
			return currentRowId && currentRowId === this.activeFreightActionRowId ? 'active-freight-action-row' : '';
		},
		fix_2,
		listFleet,
		listData,
		listBankAccount,
		listGoodsOrder,
		isNull,
		// 冲抵选择相关方法
		// 判断行是否被冲抵选中
		isOffsetRowSelected(row) {
			return this.offsetSelections.some(item => item.id === row.id);
		},
		// 处理单行的冲抵选择切换
		handleOffsetToggle(row, value) {
			// 如果是已支付的运费，不允许选择
			if (row.paymentState === PAYMENT_STATE.PAID) {
				return;
			}

			if (value) {
				// 添加到选中数组
				if (!this.isOffsetRowSelected(row)) {
					this.offsetSelections.push(row);
				}
			} else {
				// 从选中数组移除
				const index = this.offsetSelections.findIndex(item => item.id === row.id);
				if (index > -1) {
					this.offsetSelections.splice(index, 1);
				}
			}
		},
		// 处理全选/取消全选
		handleOffsetSelectAll(value) {
			if (value) {
				// 全选：将所有未支付的数据添加到选中数组
				const unpaidFreights = this.orderFreightList.filter(item => item.paymentState !== PAYMENT_STATE.PAID);
				this.offsetSelections = [...unpaidFreights];
			} else {
				// 取消全选：清空选中数组
				this.offsetSelections = [];
			}
		},
		// 处理一键冲抵款按钮点击
		handleOffsetPayment() {
			if (this.offsetSelections.length === 0) {
				this.$modal.msgWarning('请至少选择一条数据进行冲抵');
				return;
			}

			// 使用通用弹窗混入打开冲抵款弹窗
			this.openDialog(
				() => import('./components/OffsetPaymentDialog.vue'),
				'一键冲抵款',
				'1100px',
				{
					selectedFreights: this.offsetSelections
				},
				false,
				true
			);
		},
		// 拿到付款状态
		PaymentState() {
			return PaymentState;
		},
		// 拿取地址中的参数 查询list展示
		getQueryParams(fundsDate, driver) {
			// 当都存在的时候 表名是跳转过来的 要查询一次list
			listOrderFreight({ payDate: fundsDate, driverName: driver }).then(response => {
				this.orderFreightList = response.rows;
				this.total = response.total;
				this.loading = false;
				// 如果查询到了
				if (this.total > 0) {
					this.$message.success('已查询付款时间为' + fundsDate + '司机名称为' + driver + '的' + this.total + '条数据');
				} else {
					this.$message.warning('未查询到付款时间为' + fundsDate + '司机名称为' + driver + '的运费信息');
				}
			});
		},
		/** 根据运费ID查询运费记录 */
		queryByFreightId(freightId) {
			this.loading = true;
			// 将运费ID转换为数组格式（支持单个ID或多个ID）
			let freightIds = [];
			if (Array.isArray(freightId)) {
				freightIds = freightId;
			} else if (typeof freightId === 'string' && freightId.includes(',')) {
				// 如果是逗号分隔的字符串，转换为数组
				freightIds = freightId
					.split(',')
					.map(id => id.trim())
					.filter(id => id);
			} else {
				// 单个ID
				freightIds = [freightId];
			}
			// 保存当前过滤的运费ID
			this.currentFreightId = freightIds.length === 1 ? freightIds[0] : freightIds.join(',');
			this.currentFreightIds = freightIds.map(id => Number(id));
			// 构建查询参数，确保 params[ids] 数组被正确序列化
			// 后端期望格式：params[ids]=998&params[ids]=997&params[ids]=996
			// 使用 params.ids 数组，tansParams 函数会将其序列化为多个相同参数名
			const queryParams = {
				pageNum: 1,
				pageSize: 10000,
				params: {
					ids: this.currentFreightIds
				}
			};
			listOrderFreight(queryParams)
				.then(response => {
					const freights = Array.isArray(response.rows) ? response.rows : [];
					this.orderFreightList = freights;
					this.total = response.total || freights.length;
					this.loading = false;
					// 提示用户
					if (freights.length > 0) {
						const idsStr = freightIds.join(', ');
						this.$message.success(`已查询到运费ID为 ${idsStr} 的 ${freights.length} 条运费记录`);
					} else {
						const idsStr = freightIds.join(', ');
						this.$message.warning(`未查询到运费ID为 ${idsStr} 的运费记录`);
					}
				})
				.catch(error => {
					console.error('查询运费记录失败:', error);
					this.$message.error('查询运费记录失败');
					this.loading = false;
				});
		},
		/** 根据对方银行卡号查询运费记录 */
		queryByOtherBankNo(otherBankNo) {
			this.loading = true;
			// 保存当前过滤的银行卡号
			this.currentOtherBankNo = otherBankNo;
			// 构建查询参数
			const queryParams = {
				pageNum: 1,
				pageSize: 10000,
				otherBankNo: otherBankNo
			};
			listOrderFreight(queryParams)
				.then(response => {
					const freights = Array.isArray(response.rows) ? response.rows : [];
					this.orderFreightList = freights;
					this.total = response.total || freights.length;
					this.loading = false;
					// 提示用户
					if (freights.length > 0) {
						this.$message.success(`已查询到对方银行卡号为 ${otherBankNo} 的 ${freights.length} 条运费记录`);
					} else {
						this.$message.warning(`未查询到对方银行卡号为 ${otherBankNo} 的运费记录`);
					}
				})
				.catch(error => {
					console.error('查询运费记录失败:', error);
					this.$message.error('查询运费记录失败');
					this.loading = false;
				});
		},
		/** 清除运费ID过滤，恢复正常模式（已废弃，使用 resetQuery 代替） */
		clearFreightIdFilter() {
			// 直接调用重置查询方法
			this.resetQuery();
		},
		// 填充我方银行卡账户类型
		handleBankTypeSelf(value) {
			this.freightSelfOnceInfo.selfBankCardType = value;
		},
		// 对方银行账户类型
		handleBankTypeOther(value) {
			this.freightSelfOnceInfo.otherBankCardType = value;
		},
		changeOpen() {
			this.needMoney = 0;
			this.applyPaymentVisible = false;
			this.getList();
		},
		/** 查询订单运费列表 */
		getList() {
			this.loading = true;
			// applyDateStartTime
			listOrderFreight(addDateRange(this.queryParams, this.dateRange, 'orderfreight')).then(response => {
				this.orderFreightList = response.rows;
				this.total = response.total;
				this.loading = false;

				// 清理已支付的运费选择，确保数据一致性
				this.offsetSelections = this.offsetSelections.filter(selected => {
					const current = this.orderFreightList.find(item => item.id === selected.id);
					return current && current.paymentState !== PAYMENT_STATE.PAID;
				});
			});
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
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
				freightType: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				content: null,
				paymentState: null,
				driverName: null,
				driverId: null,
				CarNo: null,
				fleet: null,
				applyUserId: null,
				applyUserName: null,
				applyDate: null,
				isedit: null,
				payUserId: null,
				payUserName: null,
				payDate: null,
				cancelFlag: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				// 对方银行卡类型
				otherBankCardType: null
			};
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			// 处理支付时间范围
			if (this.queryParams.paymentDateRange && Array.isArray(this.queryParams.paymentDateRange) && this.queryParams.paymentDateRange.length === 2) {
				// 时间范围选择器返回的是数组 [startDate, endDate]，直接使用日期字符串，精确到天
				this.queryParams.params.payDateStartTime = this.queryParams.paymentDateRange[0];
				this.queryParams.params.payDateEndTime = this.queryParams.paymentDateRange[1];
			} else {
				// 清空支付时间范围
				this.queryParams.params.payDateStartTime = null;
				this.queryParams.params.payDateEndTime = null;
			}

			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			// 1. 保存当前分页参数
			const currentPageNum = this.queryParams.pageNum;
			const currentPageSize = this.queryParams.pageSize;

			// 2. 清空运费ID和银行卡号过滤状态
			this.currentFreightId = null;
			this.currentFreightIds = [];
			this.currentOtherBankNo = null;

			// 3. 重置表单
			this.resetForm('queryForm');

			// 4. 重置查询参数（保留分页参数）
			this.queryParams = {
				pageNum: currentPageNum,
				pageSize: currentPageSize,
				ordersNo: null,
				freightType: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				content: null,
				paymentState: null,
				driverName: null,
				driverId: null,
				carNo: null,
				fleet: null,
				applyUserId: null,
				applyUserName: null,
				applyDate: null,
				isedit: null,
				payUserId: null,
				payUserName: null,
				payDate: null,
				paymentDateRange: null,
				params: {
					payDateStartTime: null,
					payDateEndTime: null
				}
			};

			// 5. 重置日期范围
			this.dateRange = [];

			// 6. 清除路由中的 freightId 和 otherBankNo 参数
			if (this.$router && (this.$route.query.freightId || this.$route.query.otherBankNo)) {
				const newQuery = { ...this.$route.query };
				delete newQuery.freightId;
				delete newQuery.otherBankNo;
				this.$router.replace({
					path: this.$route.path,
					query: newQuery
				});
			}

			// 7. 重新查询
			this.$nextTick(() => {
				this.getList();
			});
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.selectedList = selection;
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加订单运费申请';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.trackFreightActionRow(row);
			this.reset();
			const id = row.id || this.ids;
			getOrderFreight(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改订单运费';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateOrderFreight(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addOrderFreight(this.form).then(() => {
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
			this.trackFreightActionRow(row);
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除订单运费编号为"' + ids + '"的数据项？')
				.then(function () {
					return delOrderFreight(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			// 构建导出参数
			const exportParams = {
				...this.queryParams
			};

			// 如果当前有运费ID筛选，则传递这些ID进行筛选导出
			if (this.currentFreightIds && this.currentFreightIds.length > 0) {
				// 传递逗号分隔的ID字符串到 params.ids
				if (!exportParams.params) {
					exportParams.params = {};
				}
				exportParams.params.ids = this.currentFreightIds.join(',');

				// 提示用户正在导出筛选后的数据
				this.$message.info(`正在导出运费ID为 ${this.currentFreightId} 的运费记录`);
			}

			this.download('system/orderFreight/export', exportParams, `订单运费_${new Date().getTime()}.xlsx`);
		},
		// 运费修正相关方法
		/**
		 * 打开运费修正弹窗：带出 Row 基础信息，金额留空；申请日期默认为当天。
		 * @param {Record<string, *>} row 当前运费表格行
		 */
		handleFillFreight(row) {
			this.trackFreightActionRow(row);
			this.resetFillFreightForm();
			// 从行数据填充表单信息（除了金额）
			this.fillFreightForm = {
				sourceId: row.sourceId || null,
				source: row.source || null,
				freightType: row.freightType || null,
				moneyAmount: null, // 金额不自动填充
				selfAcountsName: row.selfAcountsName || null,
				selfBankNo: row.selfBankNo || null,
				selfBankName: row.selfBankName || null,
				otherAcountsName: row.otherAcountsName || null,
				otherBankNo: row.otherBankNo || null,
				otherBankName: row.otherBankName || null,
				driverId: row.driverId || null,
				carNo: row.carNo || null,
				fleet: row.fleet || null,
				applyDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				comments: row.comments || null
			};
			this.fillFreightVisible = true;
		},
		/** 重置运费修正表单与校验状态 */
		resetFillFreightForm() {
			this.fillFreightForm = {
				sourceId: null,
				source: null,
				freightType: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				driverId: null,
				carNo: null,
				fleet: null,
				applyDate: null,
				comments: null
			};
			if (this.$refs.fillFreightFormRef) {
				this.$refs.fillFreightFormRef.resetFields();
			}
		},
		// 银行账户搜索回调 - 专门用于对方户名搜索
		handleCommitBackBankAccount(val) {
			this.fillFreightForm.otherBankNo = val.bankNo;
			this.fillFreightForm.otherBankName = val.bankName;
			this.fillFreightForm.otherAcountsName = val.acountsName;
		},
		// 银行账户搜索相关函数
		updateQueryBankAccount(val) {
			this.queryBankAccount = val;
		},
		// 金额输入过滤：保留数字、小数点和负号，且最多两位小数
		onFillFreightMoneyInput(val) {
			if (val === null || val === undefined || val === '') {
				this.fillFreightForm.moneyAmount = '';
				return;
			}
			let s = String(val);
			// 删除非法字符（保留数字、小数点和负号）
			s = s.replace(/[^\d.-]/g, '');
			// 只允许一个负号，且必须在开头
			if (s.includes('-')) {
				const minusCount = (s.match(/-/g) || []).length;
				if (minusCount > 1) {
					// 如果有多个负号，只保留第一个（如果不在开头则移到开头）
					s = s.replace(/-/g, '');
					s = '-' + s;
				} else if (s.indexOf('-') !== 0) {
					// 如果负号不在开头，移到开头
					s = s.replace(/-/g, '');
					s = '-' + s;
				}
			}
			// 只允许一个小数点
			const dotIndex = s.indexOf('.');
			if (dotIndex !== -1) {
				// 保留第一个小数点，删除后续的小数点
				s = s.substring(0, dotIndex + 1) + s.substring(dotIndex + 1).replace(/\./g, '');
			}
			// 限制两位小数
			if (/^-?\d+\.\d{3,}$/.test(s)) {
				s = s.replace(/^(-?\d+\.\d{2}).*$/, '$1');
			}
			// 如果只有负号或只有负号加小数点，保留字符串格式以便继续输入
			if (s === '-' || s === '-.') {
				this.fillFreightForm.moneyAmount = s;
			} else if (s === '') {
				this.fillFreightForm.moneyAmount = '';
			} else {
				// 保持字符串格式，不转换为数字，以便可以正常输入负数和小数
				this.fillFreightForm.moneyAmount = s;
			}
		},
		// 提交运费修正表单
		submitFillFreightForm() {
			this.$refs.fillFreightFormRef.validate(valid => {
				if (valid) {
					const formData = excludeParams(this.fillFreightForm, this.$exclude);
					// 运费修正需要使用字段isOrderFreightFix
					formData.extraInfo = { isOrderFreightFix: true };
					addOrderFreight(formData).then(() => {
						this.$modal.msgSuccess('新增成功');
						this.fillFreightVisible = false;
						this.getList();
					});
				}
			});
		},
		// 取消运费修正
		cancelFillFreight() {
			this.fillFreightVisible = false;
			this.resetFillFreightForm();
		},
		// 表格合计方法
		getFreightSummary(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				if (column.property === 'moneyAmount') {
					// 计算运费总和
					const values = data.map(item => Number(item[column.property]) || 0);
					const sum = values.reduce((prev, curr) => {
						return prev + curr;
					}, 0);
					// ä»»åŠ¡3ï¼šä¸€é”®ä»˜è¿è´¹ - åˆè®¡ä¿ç•™ 2 ä½å°æ•°ï¼ˆfix ä¸º 4 ä½ï¼‰
					sums[index] = this.fix_2(sum);
				} else {
					sums[index] = '';
				}
			});
			return sums;
		}
	}
};
</script>
<style scoped>
/* 运费ID过滤提示横幅 */
.freight-filter-banner {
	margin-bottom: 12px;
}

.freight-filter-banner ::v-deep .el-alert {
	padding: 8px 16px;
}

.freight-filter-banner ::v-deep .el-alert__title {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

/* 一键付运费弹窗布局 - 上下布局 */
.order-freight-body {
	/* 上下布局 */
	display: flex;
	flex-direction: column;
	gap: 16px;
	height: 68vh;
	min-height: 420px;
	overflow: hidden;
}

/* 上方：我方付款信息表单（inline） */
.order-freight-self-info {
	flex-shrink: 0;
	background: #fafafa;
	border: 1px solid #f0f0f0;
	border-radius: 4px;
	padding: 16px;
}

/* 优化inline表单样式 */
.order-freight-self-info ::v-deep .el-form-item__label {
	font-weight: 500;
	color: #606266;
}

.order-freight-self-info ::v-deep .el-form-item {
	margin-bottom: 16px;
	margin-right: 20px;
}

/* 下方：运费信息表格 */
.order-freight-info {
	flex: 1;
	min-height: 0;
	overflow: hidden;
	border: 1px solid #f0f0f0;
	border-radius: 4px;
	padding: 16px;
	background: #fff;
}

.order-freight-info ::v-deep .el-table {
	height: 100%;
}

/* 操作行高亮：背景在 td 上，需覆盖主表体与右固定列 */
#printBox ::v-deep .el-table__body-wrapper tr.active-freight-action-row > td,
#printBox ::v-deep .el-table__fixed-body-wrapper tr.active-freight-action-row > td,
#printBox ::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.active-freight-action-row > td {
	background-color: #fff7e8 !important;
	box-shadow: inset 0 1px 0 #e6a23c, inset 0 -1px 0 #e6a23c;
}
#printBox ::v-deep .el-table__body-wrapper tr.active-freight-action-row > td:first-child,
#printBox ::v-deep .el-table__fixed-body-wrapper tr.active-freight-action-row > td:first-child,
#printBox ::v-deep .el-table__fixed-right .el-table__fixed-body-wrapper tr.active-freight-action-row > td:first-child {
	box-shadow: inset 3px 0 0 #e6a23c, inset 0 1px 0 #e6a23c, inset 0 -1px 0 #e6a23c;
}

/* 表单输入宽度与组件对齐优化 */
.order-freight-self-info ::v-deep .el-input,
.order-freight-self-info ::v-deep .el-cascader,
.order-freight-self-info ::v-deep .el-select {
	width: 100%;
}
</style>
