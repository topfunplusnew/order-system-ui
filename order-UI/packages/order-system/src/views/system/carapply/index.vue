<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="车牌" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入车牌" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="用车时间" prop="startTime">
				<el-date-picker v-model="queryParams.startTime" type="datetime" placeholder="选择用车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="还车时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="datetime" placeholder="选择还车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>

			<el-form-item label="派车人" prop="dispatchPerson">
				<el-input v-model="queryParams.dispatchPerson" placeholder="请输入派车人" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="danger" size="mini" @click="handleAdd">添加车辆派出信息</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:carapply:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="carApplyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="申请时间" align="center" prop="applyDate" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="申请人" align="center" prop="applyUser" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="部门" align="center" prop="department" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="车牌" align="center" prop="carNo" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="是否携带油卡" align="center" prop="isUseOilCard" show-overflow-tooltip>
				<template slot-scope="scope">
					<el-tag :type="scope.row.isUseOilCard === 1 ? 'success' : 'danger'" disable-transitions>
						{{ scope.row.isUseOilCard === 1 ? '是' : '否' }}
					</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[5].visible" label="油卡号" align="center" prop="oilCard" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="随同乘车人员" align="center" prop="peers" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="用车时间" align="center" prop="startTime" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="还车时间" align="center" prop="endTime" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="用车事由" align="center" prop="applyPurpose" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="出车前里程" align="center" prop="startMile" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="出车前车况" align="center" prop="startCarState" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="回来后里程" align="center" prop="endMile" show-overflow-tooltip />
			<el-table-column v-if="columns[13].visible" label="回来后车况" align="center" prop="endCarState" show-overflow-tooltip />
			<el-table-column v-if="columns[14].visible" label="用车里程数" align="center" prop="miles" show-overflow-tooltip />
			<el-table-column v-if="columns[15].visible" label="回程停靠位置" align="center" prop="backStopPlace" show-overflow-tooltip />
			<el-table-column v-if="columns[16].visible" label="行程中违法次数" align="center" prop="violationsCount" show-overflow-tooltip />
			<el-table-column v-if="columns[17].visible" label="违章罚款金额" align="center" prop="fine" show-overflow-tooltip />
			<el-table-column v-if="columns[18].visible" label="行程中是否维修/保养" align="center" prop="isMaintenance" show-overflow-tooltip />
			<el-table-column v-if="columns[19].visible" label="保养金额" align="center" prop="maintenanceMoney" show-overflow-tooltip />
			<el-table-column v-if="columns[20].visible" label="维修金额" align="center" prop="repairMoney" show-overflow-tooltip />
			<el-table-column v-if="columns[21].visible" label="行程中使用加油卡加油次数" align="center" prop="refuelingFrequency" show-overflow-tooltip />
			<el-table-column v-if="columns[22].visible" label="加油金额" align="center" prop="refuelingMoney" show-overflow-tooltip />
			<el-table-column v-if="columns[23].visible" label="现金加油次数" align="center" prop="cashRefuelingFrequency" show-overflow-tooltip />
			<el-table-column v-if="columns[24].visible" label="加油卡余额" align="center" prop="oilCardBalance" show-overflow-tooltip />
			<el-table-column v-if="columns[25].visible" label="加油小票是否交回公司" align="center" prop="isTicketReturned" show-overflow-tooltip />
			<el-table-column v-if="columns[26].visible" label="现金加油金额" align="center" prop="cashRefueling" show-overflow-tooltip />
			<el-table-column v-if="columns[27].visible" label="派车人" align="center" prop="dispatchPerson" show-overflow-tooltip />
			<el-table-column v-if="columns[28].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column v-if="columns[29].visible" label="附件路径" align="center" prop="path">
				<template slot-scope="scope">
					<CheckFiles :path="scope.row.path" @needToUpdate="value => handleUpdateFilePath(value, scope.row, 'path', getCarApply(), updateCarApply())" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[30].visible" label="审核状态" align="center" prop="auditState" width="120px">
				<template slot-scope="scope">
					<el-tag :type="scope.row.auditState === '审核通过' ? 'success' : scope.row.auditState === '审核不通过' ? 'danger' : 'info'">
						{{ scope.row.auditState || '待审核' }}
					</el-tag>
				</template>
			</el-table-column>

			<!--      TODO-->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180px">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:carapply:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:carapply:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
					<el-button v-hasPermi="['system:carapply:audit']" size="mini" type="warning" @click="handleAudit(scope.row)" v-if="scope.row.auditState === null">派车审核</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改车辆使用申请对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1500px" append-to-body>
			<div>
				<el-form ref="form" :model="form" :rules="rules" label-width="160px">
					<el-row>
						<el-col :span="8">
							<el-form-item label="申请时间" prop="applyDate">
								<el-date-picker v-model="form.applyDate" type="datetime" placeholder="选择申请时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="申请人" prop="applyUser">
								<el-input v-model="form.applyUser" placeholder="请输入申请人" />
							</el-form-item>
							<el-form-item label="部门" prop="department">
								<treeselect v-model="form.department" :options="deptOptions" :normalizer="normalizer" placeholder="请选择部门" />
							</el-form-item>
							<el-form-item label="车牌" prop="carNo">
								<el-row>
									<el-col :span="20">
										<el-input v-model="form.carNo" placeholder="请输入车牌" />
									</el-col>
									<el-col :span="4">
										<SearchOption
											:limit-info="{}"
											:get-data="listVehicles"
											query-label="车牌搜索"
											:query-name="queryCars"
											query-info="licensePlate"
											@update:queryName="updateQueryCars"
											@commitBack="handleCommitBackCars"
										>
											<template #table-columns>
												<el-table-column label="车牌" prop="licensePlate" />
												<el-table-column label="车辆型号" prop="model" />
												<el-table-column label="购买时间" prop="purchaseDate" />
												<el-table-column label="行驶里程" prop="mileage" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<el-form-item label="随同乘车人员" prop="peers">
								<el-input v-model="form.peers" placeholder="请输入随同乘车人员" />
							</el-form-item>
							<el-form-item label="用车时间" prop="startTime">
								<el-date-picker v-model="form.startTime" type="datetime" placeholder="选择用车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="还车时间" prop="endTime">
								<el-date-picker v-model="form.endTime" type="datetime" placeholder="选择还车时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
							<el-form-item label="用车事由" prop="applyPurpose">
								<el-input v-model="form.applyPurpose" placeholder="请输入用车事由" />
							</el-form-item>
							<el-form-item label="出车前里程" prop="startMile">
								<el-input v-model="form.startMile" placeholder="请输入出车前里程" />
							</el-form-item>
						</el-col>
						<el-col :span="8">
							<el-form-item label="出车前车况" prop="startCarState">
								<el-input v-model="form.startCarState" placeholder="外观是否有划痕、磕碰、掉漆、内部是否清洁" />
							</el-form-item>
							<el-form-item label="回来后里程" prop="endMile">
								<el-input v-model="form.endMile" placeholder="请输入回来后里程" />
							</el-form-item>
							<el-form-item label="回来后车况" prop="endCarState">
								<el-input v-model="form.endCarState" placeholder="是否洗车、内部是否清洁" />
							</el-form-item>
							<el-form-item label="用车里程数" prop="miles">
								<el-input v-model="form.miles" placeholder="请输入用车里程数" />
							</el-form-item>
							<el-form-item label="回程停靠位置" prop="backStopPlace">
								<el-input v-model="form.backStopPlace" placeholder="请输入回程停靠位置" />
							</el-form-item>
							<el-form-item label="行程中违法次数" prop="violationsCount">
								<el-input type="number" v-model="form.violationsCount" placeholder="请输入行程中违法次数" />
							</el-form-item>
							<el-form-item label="违章罚款金额金额" prop="fine">
								<el-input type="number" v-model="form.fine" placeholder="请输入违章罚款金额金额" />
							</el-form-item>
							<el-form-item label="行程中是否维修/保养" prop="isMaintenance">
								<el-radio v-model="form.isMaintenance" label="是">是</el-radio>
								<el-radio v-model="form.isMaintenance" label="否">否</el-radio>
							</el-form-item>
							<el-form-item v-if="form.isMaintenance === '是'" label="保养金额" prop="maintenanceMoney">
								<el-input v-model="form.maintenanceMoney" placeholder="请输入保养金额" />
							</el-form-item>
							<el-form-item v-if="form.isMaintenance === '是'" label="维修金额" prop="repairMoney ">
								<el-input v-model="form.repairMoney" placeholder="请输入维修金额" />
							</el-form-item>
							<el-form-item label="行程中使用加油卡加油次数" prop="refuelingFrequency">
								<el-input type="number" v-model="form.refuelingFrequency" placeholder="请输入行程中使用加油卡加油次数" />
							</el-form-item>
						</el-col>
						<el-col :span="8">
							<el-form-item label="现金加油次数" prop="cashRefuelingFrequency">
								<el-input type="number" v-model="form.cashRefuelingFrequency" placeholder="现金加油次数" />
							</el-form-item>
							<!--              在行程中使用加油卡的加油次数和派车人之间加入4列，“加油金额、加油卡余额、加油小票是否交回公司、现金加油”。-->
							<el-form-item label="加油金额" prop="refuelingMoney">
								<el-input type="number" v-model="form.refuelingMoney" placeholder="请输入加油金额" />
							</el-form-item>
							<el-form-item label="加油卡余额" prop="oilCardBalance">
								<el-input type="number" v-model="form.oilCardBalance" placeholder="请输入加油卡余额" />
							</el-form-item>
							<el-form-item label="加油小票是否交回公司" prop="isTicketReturned">
								<el-radio v-model="form.isTicketReturned" label="是">是</el-radio>
								<el-radio v-model="form.isTicketReturned" label="否">否</el-radio>
							</el-form-item>
							<el-form-item label="现金加油" prop="cashRefueling">
								<el-input type="number" v-model="form.cashRefueling" placeholder="请输入行程中使用加油卡加油次数" />
							</el-form-item>

							<el-form-item label="派车人" prop="dispatchPerson">
								<el-input v-model="form.dispatchPerson" placeholder="请输入派车人" />
							</el-form-item>
							<el-form-item label="备注" prop="comments">
								<el-input v-model="form.comments" placeholder="请输入备注" />
							</el-form-item>
							<el-form-item label="附件" prop="attachmentList">
								<CheckFiles :attachmentList.sync="form.attachmentList" @needToUpdate="handleFormAttachmentUpdate" />
							</el-form-item>
						</el-col>
					</el-row>
					<!--					<div style="padding: 30px">-->
					<!--						<el-row :gutter="10" class="mb8">-->
					<!--							<el-col :span="1.5">-->
					<!--								<el-button size="mini" type="primary" @click="handleAddOildetail">添加</el-button>-->
					<!--							</el-col>-->
					<!--							<el-col :span="1.5">-->
					<!--								<el-button size="mini" type="danger" @click="handleDeleteOildetail">删除</el-button>-->
					<!--							</el-col>-->
					<!--						</el-row>-->

					<!--						&lt;!&ndash;            油卡消费记录&ndash;&gt;-->
					<!--						<el-table size="mini" :data="oilCardConsumeList" :row-class-name="rowOilCardIndex" @selection-change="handleOilCardSelectionChange" ref="oilCardTable">-->
					<!--							<template #empty>-->
					<!--								<span>当前无油卡消费记录,若有,请添加油卡消费记录</span>-->
					<!--							</template>-->
					<!--							&lt;!&ndash; 多选 &ndash;&gt;-->
					<!--							<el-table-column type="selection" width="90" align="center" />-->
					<!--							&lt;!&ndash; 序号 &ndash;&gt;-->
					<!--							<el-table-column label="序号" align="center" prop="index" width="50" />-->

					<!--							&lt;!&ndash; 加油卡卡号 &ndash;&gt;-->
					<!--							<el-table-column label="加油卡卡号" prop="oilCardNo" width="200">-->
					<!--								<template #default="scope">-->
					<!--									<el-row>-->
					<!--										<el-col :span="20">-->
					<!--											<el-input disabled size="mini" v-model="scope.row.oilCardNo" placeholder="请选择" />-->
					<!--										</el-col>-->
					<!--										<el-col :span="4">-->
					<!--											<SearchOption-->
					<!--												:get-data="listOilCard"-->
					<!--												query-info="oilCardNo"-->
					<!--												:query-name="queryOilCard"-->
					<!--												query-label="油卡账号查询"-->
					<!--												:limit-info="{-->
					<!--													oilType: '主卡'-->
					<!--												}"-->
					<!--												@commitBack="value => handleCommitBackOilCard(value, scope.row)"-->
					<!--												@update:queryName="handleCommitBackQueryOilCard"-->
					<!--												:query-items="queryItemsOilCard"-->
					<!--											>-->
					<!--												<template #table-columns>-->
					<!--													<el-table-column label="加油卡卡号" align="center" prop="oilCardNo" />-->
					<!--													<el-table-column label="当前金额" align="center" prop="moneyAmount" />-->
					<!--												</template>-->
					<!--											</SearchOption>-->
					<!--										</el-col>-->
					<!--									</el-row>-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 使用加油卡时间 &ndash;&gt;-->
					<!--							<el-table-column label="使用加油卡时间" prop="useDate" width="200">-->
					<!--								<template #default="scope">-->
					<!--									<el-date-picker size="mini" v-model="scope.row.useDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 使用加油卡车辆车牌号 &ndash;&gt;-->
					<!--							<el-table-column label="车辆车牌号" prop="carNo" width="200">-->
					<!--								<template #default="scope">-->
					<!--									<el-row>-->
					<!--										<el-col :span="20">-->
					<!--											<el-input disabled size="mini" v-model="scope.row.carNo" placeholder="请选择" />-->
					<!--										</el-col>-->
					<!--										<el-col :span="4">-->
					<!--											<SearchOption-->
					<!--												:get-data="listVehicles"-->
					<!--												query-info="licensePlate"-->
					<!--												:query-name="queryCarNumber"-->
					<!--												query-label="车牌号查询"-->
					<!--												:limit-info="{}"-->
					<!--												@commitBack="value => handleCommitCarNumber(value, scope.row)"-->
					<!--												@update:queryName="handleCommitBackQueryCarNumber"-->
					<!--											>-->
					<!--												<template #table-columns>-->
					<!--													<el-table-column label="车牌号" align="center" prop="licensePlate" />-->
					<!--													<el-table-column label="购买时间" align="center" prop="purchaseDate" width="180">-->
					<!--														<template slot-scope="scope">-->
					<!--															<span>{{ parseTime(scope.row.purchaseDate, '{y}-{m}-{d}') }}</span>-->
					<!--														</template>-->
					<!--													</el-table-column>-->
					<!--													<el-table-column label="行驶里程" align="center" prop="mileage" />-->
					<!--													<el-table-column label="保养金额" align="center" prop="maintenanceCost" />-->
					<!--													<el-table-column label="保养日期" align="center" prop="maintenanceDate" width="180">-->
					<!--														<template slot-scope="scope">-->
					<!--															<span>{{ parseTime(scope.row.maintenanceDate, '{y}-{m}-{d}') }}</span>-->
					<!--														</template>-->
					<!--													</el-table-column>-->
					<!--												</template>-->
					<!--											</SearchOption>-->
					<!--										</el-col>-->
					<!--									</el-row>-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 期初余额 &ndash;&gt;-->
					<!--							<el-table-column label="期初余额" prop="startCardSurplus" width="150">-->
					<!--								<template #default="scope">-->
					<!--									<el-input size="mini" v-model="scope.row.startCardSurplus" placeholder="请输入期初余额" />-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 充值金额 &ndash;&gt;-->
					<!--							<el-table-column label="充值金额" prop="rechargeMoney" width="200">-->
					<!--								<template #default="scope">-->
					<!--									<el-input size="mini" v-model="scope.row.rechargeMoney" placeholder="请输入充值金额" />-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 加油量 &ndash;&gt;-->
					<!--							<el-table-column label="加油量" prop="refuelingNumber" width="150">-->
					<!--								<template #default="scope">-->
					<!--									<el-input size="mini" v-model="scope.row.refuelingNumber" placeholder="请输入加油量" />-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 单价 &ndash;&gt;-->
					<!--							<el-table-column label="单价" prop="unitPrice" width="150">-->
					<!--								<template #default="scope">-->
					<!--									<el-input size="mini" v-model="scope.row.unitPrice" placeholder="请输入单价" />-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 加油金额 &ndash;&gt;-->
					<!--							<el-table-column label="加油金额(元)" prop="refuelingMoney" width="150">-->
					<!--								<template #default="scope">-->
					<!--									<el-input size="mini" v-model="scope.row.refuelingMoney" placeholder="请输入加油金额" />-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 加油小票附件 &ndash;&gt;-->
					<!--							<el-table-column label="小票附件" prop="attachmentOiladd" width="300">-->
					<!--								<template #default="scope">-->
					<!--									<el-row>-->
					<!--										<el-col :span="12">-->
					<!--											<el-input size="mini" v-model="scope.row.attachmentOiladd" placeholder="附件路径" disabled />-->
					<!--										</el-col>-->
					<!--										<el-col :span="6">-->
					<!--											<file-upload @input="value => handleUpload(value, scope)" :is-show-name="false" />-->
					<!--										</el-col>-->
					<!--										<el-col v-if="scope.row.attachmentOiladd !== null && scope.row.attachmentOiladd !== ''" :span="6">-->
					<!--											<el-button size="mini" @click="checkPath(scope.row.attachmentOiladd)">查看附件</el-button>-->
					<!--										</el-col>-->
					<!--									</el-row>-->
					<!--								</template>-->
					<!--							</el-table-column>-->

					<!--							&lt;!&ndash; 备注 &ndash;&gt;-->
					<!--							<el-table-column label="备注" prop="comments" width="200">-->
					<!--								<template #default="scope">-->
					<!--									<el-input size="mini" v-model="scope.row.comments" placeholder="请输入备注" />-->
					<!--								</template>-->
					<!--							</el-table-column>-->
					<!--						</el-table>-->
					<!--					</div>-->
				</el-form>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    通用的弹窗组件-->
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
import { listCarApply, delCarApply, addCarApply, auditCarApply } from '@/api/system/carApply';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { mixin_businesstrip_car_apply } from '../../dashboard/mixins/bussiness/businesstrip_car_apply';
import { listData } from '../../../api/system/dict/data';
import SearchOption from '../../../components/SearchOption.vue';
import { listOilCard } from '../../../api/system/oilCard';
import Treeselect from '@riophae/vue-treeselect';
import { listDept } from '@/api/system/dept';
import '@riophae/vue-treeselect/dist/vue-treeselect.css';
import CheckFiles from '../../../components/CheckFiles.vue';
import { getCarApply, updateCarApply } from '../../../api/system/carApply';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { listVehicles } from '../../../api/system/vehicles';
import { excludeParams } from '../../../api/tool/exclude';
import { parseTime } from 'order-system/src/utils/ruoyi';

export default {
	name: 'CarApply',
	components: { DialogWrapper, CheckFiles, Treeselect, SearchOption },
	mixins: [mixin_printHTML, common_dialog, mixin_businesstrip_car_apply],
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
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 车辆使用申请表格数据
			carApplyList: [],
			deptOptions: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				bTripId: null,
				applyDate: null,
				applyUser: null,
				department: null,
				carNo: null,
				isUseOilCard: null,
				peers: null,
				startTime: null,
				endTime: null,
				ApplyPurpose: null,
				startMile: null,
				startCarState: null,
				endMile: null,
				endCarState: null,
				miles: null,
				backStopPlace: null,
				violationsCount: null,
				fine: null,
				isMaintenance: null,
				maintenanceMoney: null,
				refuelingFrequency: null,
				dispatchPerson: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				path: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				applyDate: [
					{
						required: true,
						message: '请选择申请时间',
						trigger: 'blur'
					}
				],
				applyUser: [{ required: true, message: '请输入申请人', trigger: 'blur' }],
				department: [{ required: true, message: '请选择部门', trigger: 'blur' }],
				carNo: [{ required: true, message: '请输入车牌', trigger: 'blur' }],
				peers: [
					{
						required: true,
						message: '请输入随同乘车人员',
						trigger: 'blur'
					}
				],
				startTime: [
					{
						required: true,
						message: '请选择用车时间',
						trigger: 'blur'
					}
				],
				endTime: [
					{
						required: true,
						message: '请选择还车时间',
						trigger: 'blur'
					}
				],
				applyPurpose: [
					{
						required: true,
						message: '请输入用车事由',
						trigger: 'blur'
					}
				],
				startMile: [
					{
						required: true,
						message: '请输入出车前里程',
						trigger: 'blur'
					}
				],
				startCarState: [
					{
						required: true,
						message: '请输入出车前车况',
						trigger: 'blur'
					}
				],
				endMile: [
					{
						required: true,
						message: '请输入回来后里程',
						trigger: 'blur'
					}
				],
				endCarState: [
					{
						required: true,
						message: '请输入回来后车况',
						trigger: 'blur'
					}
				],
				miles: [
					{
						required: true,
						message: '请输入用车里程数',
						trigger: 'blur'
					}
				],
				backStopPlace: [
					{
						required: true,
						message: '请输入回程停靠位置',
						trigger: 'blur'
					}
				],
				violationsCount: [
					{
						required: true,
						message: '请输入行程中违法次数',
						trigger: 'blur'
					}
				],
				fine: [
					{
						required: true,
						message: '请输入违章罚款金额',
						trigger: 'blur'
					}
				],
				isMaintenance: [
					{
						required: true,
						message: '请选择行程中是否维修/保养',
						trigger: 'blur'
					}
				],
				maintenanceMoney: [
					{
						required: true,
						message: '请输入保养金额',
						trigger: 'blur'
					}
				],
				refuelingFrequency: [
					{
						required: true,
						message: '请输入行程中使用加油卡加油次数',
						trigger: 'blur'
					}
				],
				dispatchPerson: [{ required: true, message: '请输入派车人', trigger: 'blur' }],
				comments: [{ required: true, message: '请输入备注', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: '申请时间', visible: true },
				{ key: 1, label: '申请人', visible: true },
				{ key: 2, label: '部门', visible: true },
				{ key: 3, label: '车牌', visible: true },
				{ key: 4, label: '是否携带油卡', visible: true },
				{ key: 5, label: '油卡号', visible: true },
				{ key: 6, label: '随同乘车人员', visible: true },
				{ key: 7, label: '用车时间', visible: true },
				{ key: 8, label: '还车时间', visible: true },
				{ key: 9, label: '用车事由', visible: true },
				{ key: 10, label: '出车前里程', visible: true },
				{ key: 11, label: '出车前车况', visible: true },
				{ key: 12, label: '回来后里程', visible: true },
				{ key: 13, label: '回来后车况', visible: true },
				{ key: 14, label: '用车里程数', visible: true },
				{ key: 15, label: '回程停靠位置', visible: true },
				{ key: 16, label: '行程中违法次数', visible: true },
				{ key: 17, label: '违章罚款金额', visible: true },
				{ key: 18, label: '行程中是否维修/保养', visible: true },
				{ key: 19, label: '保养金额', visible: true },
				{ key: 20, label: '维修金额', visible: true },
				{ key: 21, label: '行程中使用加油卡加油次数', visible: true },
				{ key: 22, label: '加油金额', visible: true },
				{ key: 23, label: '现金加油次数', visible: true },
				{ key: 24, label: '加油卡余额', visible: true },
				{ key: 25, label: '加油小票是否交回公司', visible: true },
				{ key: 26, label: '现金加油金额', visible: true },
				{ key: 27, label: '派车人', visible: true },
				{ key: 28, label: '备注', visible: true },
				{ key: 29, label: '附件路径', visible: true },
				{ key: 30, label: '审核状态', visible: true }
			],

			queryItemsOilCard: {
				queryList: [
					{
						id: 1,
						label: '加油卡类别',
						prop: 'oilType',
						type: 'select',
						value: '',
						options: [
							{
								label: '主卡',
								value: '主卡'
							},
							{
								label: '副卡',
								value: '副卡'
							}
						]
					}
				]
			},
			oilCardConsumeList: [],
			checkedOildetail: []
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('carapply-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		listDept().then(response => {
			this.deptOptions = this.handleTree(response.data, 'deptId');
		});
		if (localStorage.getItem('carapply-columns') === 'null' || !localStorage.getItem('carapply-columns')) {
			// 设置localStorage
			localStorage.setItem('carapply-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('carapply-columns'));
		}
	},
	methods: {
		parseTime,
		listVehicles,
		/**
		 * 更新表单中的附件列表
		 * @param {Array} newAttachmentList - 最新的附件列表
		 */
		handleAttachmentUpdate(newAttachmentList) {
			this.form.attachmentList = newAttachmentList;
		},
		/**
		 * 处理表格中附件的更新
		 * @param {Array} attachments - 最新的附件对象数组
		 * @param {Object} row - 当前行数据
		 */
		handleUpdateAttachments(attachments, row) {
			const attachmentIds = attachments.map(item => item.id);
			getCarApply(row.id).then(res => {
				const data = {
					...res.data,
					params: {
						...res.data.params,
						attachmentIds: attachmentIds
					}
				};
				updateCarApply(data).then(() => {
					this.$modal.msgSuccess('附件更新成功');
					this.getList();
				});
			});
		},
		listOilCard,
		listData,
		normalizer(node) {
			if (node.children && !node.children.length) {
				delete node.children;
			}
			return {
				id: node.deptName,
				label: node.deptName,
				children: node.children
			};
		},
		rowOilCardIndex({ row, rowIndex }) {
			row.index = rowIndex + 1;
		},
		handleOilCardSelectionChange(selection) {
			this.checkedOildetail = selection.map(item => item.index);
		},
		handleAddOildetail() {
			const newRow = {
				oilCardNo: '', // 加油卡卡号
				useDate: '', // 使用时间
				carNo: '', // 车辆车牌号
				startCardSurplus: '', // 期初余额
				isRecharge: '2', // 是否充值，默认否
				rechargeMoney: '', // 充值金额
				refuelingNumber: '', // 加油量
				unitPrice: '', // 单价
				refuelingMoney: '', // 加油金额
				attachmentOiladd: '', // 附件路径
				comments: '' // 备注
			};
			this.oilCardConsumeList.push(newRow);
		},
		handleDeleteOildetail() {
			if (this.checkedOildetail.length === 0) {
				this.$message.error('请先选择要删除的油卡消费数据');
			} else {
				const oildetails = this.oilCardConsumeList;
				const checkedOildetails = this.checkedOildetail;
				this.oilCardConsumeList = oildetails.filter(function (item) {
					return checkedOildetails.indexOf(item.index) === -1;
				});
			}
		},
		handleUpload(val, scope) {
			scope.row.attachmentOiladd = val;
		},

		/** 查询车辆使用申请列表 */
		getList() {
			this.loading = true;
			listCarApply(this.queryParams).then(response => {
				this.carApplyList = response.rows;
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
				bTripId: null,
				applyDate: null,
				applyUser: null,
				department: null,
				carNo: null,
				isUseOilCard: '0',
				peers: null,
				startTime: null,
				endTime: null,
				applyPurpose: null,
				startMile: null,
				startCarState: null,
				endMile: null,
				endCarState: null,
				miles: null,
				backStopPlace: null,
				violationsCount: null,
				fine: null,
				isMaintenance: '否',
				maintenanceMoney: null,
				// 新增字段 维修金额
				repairMoney: '',
				refuelingFrequency: null,
				// 新增字段
				cashRefuelingFrequency: null,
				dispatchPerson: null,
				comments: null,

				// 新增四个字段
				refuelingMoney: null,
				oilCardBalance: null,
				isTicketReturned: '否',
				cashRefueling: null,

				oilCardConsumes: [],
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				attachmentList: []
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
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加车辆使用申请';
			this.form.applyUser = this.trueName;
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getCarApply(id).then(response => {
				this.form = response.data;
				// 确保 attachmentList 是一个数组
				this.form.attachmentList = response.data.attachmentList || [];
				this.oilCardConsumeList = response.data.oilCardConsumes;
				this.open = true;
				this.title = '修改车辆使用申请';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 将附件ID列表添加到参数中
					const params = {
						attachmentIds: this.form.attachmentList.map(item => item.id)
					};
					const data = { ...this.form, params: params };

					if (this.form.id != null) {
						updateCarApply(excludeParams(data, this.$exclude)).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form.oilCardConsumes = this.oilCardConsumeList;
						addCarApply(excludeParams(data, this.$exclude)).then(() => {
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
				.confirm('是否确认删除车辆使用申请编号为"' + ids + '"的数据项？')
				.then(function () {
					return delCarApply(ids);
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
				'system/carApply/export',
				{
					...this.queryParams
				},
				`carApply_${new Date().getTime()}.xlsx`
			);
		},
		/** 派车审核操作 */
		handleAudit(row) {
			this.$antdconfirm({
				title: '请选择审核结果',
				content: '点击确定按钮后，将执行审核操作',
				okText: '审核通过',
				cancelText: '审核不通过',
				onOk: () => {
					return new Promise((resolve, reject) => {
						auditCarApply(row.id, '审核通过')
							.then(() => {
								this.$modal.msgSuccess('审核通过成功');
								this.getList();
								resolve();
							})
							.catch(() => {
								this.$modal.msgError('审核通过失败');
								reject();
							});
					});
				},
				onCancel: () => {
					return new Promise((resolve, reject) => {
						auditCarApply(row.id, '审核不通过')
							.then(() => {
								this.$modal.msgSuccess('审核不通过成功');
								this.getList();
								resolve();
							})
							.catch(() => {
								this.$modal.msgError('审核不通过失败');
								reject();
							});
					});
				}
			});
		}
	}
};
</script>
