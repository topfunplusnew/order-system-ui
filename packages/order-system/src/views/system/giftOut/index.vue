<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="出库日期">
				<el-date-picker v-model="daterangeOutDate" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>

			<el-form-item label="出库方式" prop="outMethod">
				<el-tooltip class="item" effect="dark" content="出库方式可在字典中进行修改" placement="top">
					<el-select v-model="queryParams.outMethod" placeholder="请选择出库方式" clearable @keyup.enter.native="handleQuery">
						<el-option v-for="dict in dict.type.order_gift_out_method" :key="dict.value" :label="dict.label" :value="dict.value" />
					</el-select>
				</el-tooltip>
			</el-form-item>
			<el-form-item label="物品名称" prop="itemName">
				<el-input v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="领用人" prop="handler">
				<el-input v-model="queryParams.handler" placeholder="请输入领用人" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:giftOut:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:giftOut:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" table-name="views-system-gift-out-index-columns">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:giftOut:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" v-horizontal-scroll="'always'" :data="giftOutList" border size="mini" :cell-style="cellStyle" @selection-change="handleSelectionChange" :show-summary="true" :summary-method="getSummaries">
			<el-table-column type="selection" width="55" align="center" />

			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="outDate" width="120" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ parseTime(scope.row.outDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[1].visible" label="出库方式" align="center" prop="outMethod" width="100" show-overflow-tooltip>
				<template #default="scope">
					<dict-tag :options="dict.type.order_gift_out_method" :value="scope.row.outMethod" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[2].visible" label="出库地点" align="center" prop="outLocation" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[3].visible" label="领用原因" align="center" prop="getReason" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[4].visible" label="物品名称" align="center" prop="itemName" show-overflow-tooltip />

			<el-table-column v-if="columns[5].visible" label="单位" align="center" prop="unit" width="100" show-overflow-tooltip />

			<el-table-column v-if="columns[6].visible" label="数量" align="center" prop="quantity" width="80" show-overflow-tooltip />

			<el-table-column v-if="columns[7].visible" label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[8].visible" label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.estimatedValue ? Number(scope.row.estimatedValue).toFixed(2) : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[9].visible" label="领用人" align="center" prop="handler" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[10].visible" label="备注" align="center" prop="remark" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="170" fixed="right">
				<template #default="scope">
					<!-- 保留修改和删除按钮 -->
					<el-button v-hasPermi="['system:giftOut:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:giftOut:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>

					<!-- 添加更多按钮 -->
					<el-dropdown trigger="click" style="margin-left: 5px" @visible-change="visible => handleDropdownVisibleChange(scope.row, visible)">
						<span class="el-dropdown-link">
							更多
							<i class="el-icon-arrow-down el-icon--right"></i>
						</span>
						<template #dropdown>
							<el-dropdown-menu>
								<el-dropdown-item @click.native="handleReturn(scope.row)">退回</el-dropdown-item>
								<el-dropdown-item @click.native="handleViewInDetail(scope.row)">查看初始入库信息</el-dropdown-item>
								<el-dropdown-item :disabled="scope.row._checkingReInDetails || scope.row.hasReInDetails === false" @click.native="handleViewReInDetail(scope.row)">查看再入库详情</el-dropdown-item>
							</el-dropdown-menu>
						</template>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<!-- 分页 -->
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改礼品出库信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" :width="dialogWidth" append-to-body @close="handleClose">
			<el-form ref="form" :model="form" :rules="rules" label-width="100px">
				<el-row :gutter="20">
					<el-col :span="24">
						<el-form-item label="出库日期" prop="outDate">
							<el-date-picker v-model="form.outDate" clearable type="date" value-format="yyyy-MM-dd" placeholder="请选择出库日期" style="width: 100%"></el-date-picker>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="出库方式" prop="outMethod">
							<el-select v-model="form.outMethod" placeholder="请选择出库方式" style="width: 100%">
								<el-option v-for="dict in dict.type.order_gift_out_method" :key="dict.value" :label="dict.label" :value="dict.value"></el-option>
							</el-select>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="出库地点" prop="outLocation">
							<el-input v-model="form.outLocation" placeholder="请输入出库地点" maxlength="50" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="领用原因" prop="getReason">
							<el-input v-model="form.getReason" placeholder="请输入领用原因" maxlength="1000" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="物品名称" prop="itemName">
							<el-row :gutter="10">
								<el-col :span="18">
									<el-input v-model="form.itemName" placeholder="从入库记录选择或手动输入" maxlength="255" disabled />
								</el-col>
								<el-col :span="4">
									<SearchOption :limit-info="{}" :get-data="listGiftIn" query-info="itemName" query-label="物品名称" :query-name="itemName" @update:queryName="handleUpdateItemName" @commitBack="handleCommitBackItem">
										<template #table-columns>
											<el-table-column label="入库日期" align="center" prop="inDate" width="110">
												<template #default="scope">
													<span>{{ scope.row.inDate ? parseTime(scope.row.inDate, '{y}-{m}-{d}') : '-' }}</span>
												</template>
											</el-table-column>
											<el-table-column label="存货地点" align="center" prop="inventoryLocation" width="120" show-overflow-tooltip />
											<el-table-column label="物品名称" align="center" prop="itemName" min-width="120" show-overflow-tooltip />
											<el-table-column label="单位" align="center" prop="unit" width="80" />
											<el-table-column label="入库数量" align="center" prop="quantity" width="100" />
											<el-table-column label="剩余量" align="center" prop="remainingQuantity" width="100" />
											<el-table-column label="单价" align="center" prop="unitPrice" width="100">
												<template #default="scope">
													<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
												</template>
											</el-table-column>
											<el-table-column label="金额" align="center" prop="estimatedValue" width="120">
												<template #default="scope">
													<span>{{ scope.row.estimatedValue ? Number(scope.row.estimatedValue).toFixed(2) : '-' }}</span>
												</template>
											</el-table-column>
											<el-table-column label="经办人" align="center" prop="handler" width="100" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="单位" prop="unit">
							<el-input v-model="form.unit" placeholder="从入库记录自动获取或手动输入" maxlength="255" disabled />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="数量" prop="quantity">
							<el-input v-model="form.quantity" placeholder="请输入数量" @input="handleQuantityInput" @blur="handleQuantityBlur" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="单价" prop="unitPrice">
							<el-input v-model="form.unitPrice" placeholder="从入库记录自动获取或手动输入" disabled />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="金额" prop="estimatedValue">
							<el-input v-model="form.estimatedValue" placeholder="自动计算" disabled />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="领用人" prop="handler">
							<el-select v-model="form.handler" placeholder="请选择领用人" style="width: 100%" filterable clearable>
								<el-option v-for="user in userList" :key="user.userId" :label="user.nickName || user.userName" :value="user.nickName || user.userName" />
							</el-select>
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="备注" prop="remark">
							<el-input v-model="form.remark" type="textarea" placeholder="请输入内容" :rows="3" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 退回弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="退回礼品出库信息" :visible.sync="returnOpen" width="600px" append-to-body @close="handleReturnClose">
			<el-form ref="returnForm" :model="returnForm" :rules="returnRules" label-width="120px">
				<el-form-item label="退回日期" prop="localDate">
					<el-date-picker v-model="returnForm.localDate" type="date" placeholder="请选择退回日期" style="width: 100%" value-format="yyyy-MM-dd" clearable />
				</el-form-item>

				<el-form-item label="原本数量">
					<el-input :value="returnForm.originalQuantity || 0" disabled />
				</el-form-item>
				<el-form-item label="退回数量" prop="quantity">
					<el-input v-model="returnForm.quantity" placeholder="请输入退回数量" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitReturnForm">确 定</el-button>
				<el-button @click="returnOpen = false">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 查看详情弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="viewDetailTitle" :visible.sync="viewDetailVisible" width="1000px" append-to-body>
			<!-- 查看初始入库信息表格 -->
			<div v-if="viewDetailTitle === '查看初始入库信息'">
				<el-table v-if="viewDetailData && Array.isArray(viewDetailData) && viewDetailData.length > 0" :data="viewDetailData" border size="mini" max-height="500" v-loading="viewDetailLoading" style="width: 100%">
					<el-table-column label="日期" align="center" prop="inDate" width="120" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ formatInDate(scope.row.inDate) }}</span>
						</template>
					</el-table-column>
					<el-table-column label="入库方式" align="center" prop="inMethod" width="100" show-overflow-tooltip>
						<template #default="scope">
							<dict-tag :options="dict.type.order_gift_in_method" :value="scope.row.inMethod" />
						</template>
					</el-table-column>
					<el-table-column label="存货地点" align="center" prop="inventoryLocation" width="120" show-overflow-tooltip />
					<el-table-column label="对方信息" align="center" prop="fromInfo" width="120" show-overflow-tooltip />
					<el-table-column label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />
					<el-table-column label="单位" align="center" prop="unit" width="80" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ scope.row.unit || '-' }}</span>
						</template>
					</el-table-column>
					<el-table-column label="数量" align="center" prop="quantity" width="100" show-overflow-tooltip />
					<el-table-column label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
						</template>
					</el-table-column>
					<el-table-column label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ formatAmount(scope.row.estimatedValue, scope.row.quantity, scope.row.unitPrice) }}</span>
						</template>
					</el-table-column>
					<el-table-column label="经办人" align="center" prop="handler" width="100" show-overflow-tooltip />
					<el-table-column label="备注" align="center" prop="remark" show-overflow-tooltip />
				</el-table>
				<div v-else-if="!viewDetailLoading && (!viewDetailData || (Array.isArray(viewDetailData) && viewDetailData.length === 0))" style="padding: 20px; text-align: center; color: #909399">暂无数据</div>
			</div>

			<!-- 再入库详情表格 -->
			<div v-else-if="viewDetailTitle === '查看再入库详情'">
				<el-table v-if="viewDetailData && Array.isArray(viewDetailData) && viewDetailData.length > 0" :data="viewDetailData" border size="mini" max-height="500" v-loading="viewDetailLoading">
					<el-table-column label="入库方式" align="center" prop="inMethod" width="100" show-overflow-tooltip>
						<template #default="scope">
							<dict-tag :options="dict.type.order_gift_in_method" :value="scope.row.inMethod" />
						</template>
					</el-table-column>
					<el-table-column label="存货地点" align="center" prop="inventoryLocation" width="120" show-overflow-tooltip />
					<el-table-column label="对方信息" align="center" prop="fromInfo" width="120" show-overflow-tooltip />
					<el-table-column label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />
					<el-table-column label="单位" align="center" prop="unit" width="80" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ scope.row.unit || '-' }}</span>
						</template>
					</el-table-column>
					<el-table-column label="数量" align="center" prop="quantity" width="100" show-overflow-tooltip />
					<el-table-column label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
						</template>
					</el-table-column>
					<el-table-column label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ formatAmount(scope.row.estimatedValue || scope.row.amount || scope.row.value, scope.row.quantity, scope.row.unitPrice) }}</span>
						</template>
					</el-table-column>
					<el-table-column label="经办人" align="center" prop="handler" width="100" show-overflow-tooltip />
					<el-table-column label="备注" align="center" prop="remark" show-overflow-tooltip />

					<!-- 添加删除按钮列 -->
					<el-table-column label="操作" align="center">
						<template #default="scope">
							<el-button size="mini" type="text" icon="el-icon-delete" @click="handleDeleteReInDetail(scope.row)">删除</el-button>
						</template>
					</el-table-column>
				</el-table>
				<div v-else-if="viewDetailData && !Array.isArray(viewDetailData)" style="padding: 20px">
					<el-descriptions :column="2" border>
						<el-descriptions-item v-for="(value, key) in viewDetailData" :key="key" :label="key">{{ value }}</el-descriptions-item>
					</el-descriptions>
				</div>
				<div v-else-if="!viewDetailLoading && (!viewDetailData || (Array.isArray(viewDetailData) && viewDetailData.length === 0))" style="padding: 20px; text-align: center; color: #909399">暂无数据</div>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import request from '@/utils/request';

import { listUser } from '@/api/system/user';
import { listGiftOut, getGiftOut, delGiftOut, addGiftOut, updateGiftOut, returnGiftOut, getGiftOutReInDetail, getGiftOutInDetail, getGiftOutOutDetail } from '@/api/system/giftOut';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import SearchOption from '../../../components/SearchOption.vue';
import { getGiftIn, listGiftIn as listGiftInApi, getGiftInReInDetail } from '@/api/system/giftIn';
import { delGift } from '@/api/system/giftStock';
import { mixin_gift_out_fill } from './giftOut_fill';
import { subtract, round, add, multiply, divide } from 'mathjs';

export default {
	name: 'GiftOut',
	components: { SearchOption },
	dicts: ['order_gift_out_method', 'gift_unit', 'order_gift_in_method'],
	mixins: [mixin_printHTML, mixin_gift_out_fill],
	data() {
		return {
			currentViewRow: null,
			userList: [],
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
			// 礼品出库信息表格数据
			giftOutList: [],
			// 弹出层标题
			title: '',
			itemName: '',
			// 是否显示弹出层
			open: false,
			// 备注时间范围
			daterangeOutDate: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				outDate: null,
				outMethod: null,
				outLocation: null,
				getReason: null,
				itemName: null,
				unit: null,
				quantity: null,
				unitPrice: null,
				estimatedValue: null,
				handler: null
			},
			// 表单参数
			form: {
				id: null,
				inId: null,
				outDate: null,
				outMethod: null,
				outLocation: null,
				getReason: null,
				itemName: null,
				unit: null,
				quantity: null,
				unitPrice: null,
				estimatedValue: null,
				handler: null,
				updateTime: null,
				updateBy: null,
				createTime: null,
				createBy: null,
				remark: null
			},
			// 表单校验
			rules: {
				outDate: [{ required: true, message: '请选择出库日期', trigger: 'blur' }],
				outMethod: [{ required: true, message: '请选择出库方式', trigger: 'blur' }],
				outLocation: [
					{ required: true, message: '请输入出库地点', trigger: 'blur' },
					{ max: 50, message: '出库地点长度不能超过50个字符', trigger: 'blur' }
				],
				getReason: [
					{ required: true, message: '请输入领用原因', trigger: 'blur' },
					{ max: 1000, message: '领用原因长度不能超过1000个字符', trigger: 'blur' }
				],
				itemName: [
					{ required: true, message: '请输入物品名称', trigger: 'blur' },
					{ max: 255, message: '物品名称长度不能超过255个字符', trigger: 'blur' }
				],
				unit: [
					{ required: true, message: '请输入单位', trigger: 'blur' },
					{ max: 255, message: '单位长度不能超过255个字符', trigger: 'blur' }
				],
				quantity: [
					{ required: true, message: '请输入数量', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (!value) {
								callback(new Error('请输入数量'));
								return;
							}
							const num = Number(value);
							if (!Number.isInteger(num) || num < 1) {
								callback(new Error('数量必须为正整数且大于等于1'));
								return;
							}
							callback();
						},
						trigger: 'blur'
					}
				],
				unitPrice: [{ required: true, message: '请输入单价', trigger: 'blur' }],
				handler: [
					{ required: true, message: '请输入领用人', trigger: 'blur' },
					{ max: 20, message: '领用人长度不能超过20个字符', trigger: 'blur' }
				]
			},
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `出库方式`, visible: true },
				{ key: 2, label: `出库地点`, visible: true },
				{ key: 3, label: `领用原因`, visible: true },
				{ key: 4, label: `物品名称`, visible: true },
				{ key: 5, label: `单位`, visible: true },
				{ key: 6, label: `数量`, visible: true },
				{ key: 7, label: `单价`, visible: true },
				{ key: 8, label: `金额`, visible: true },
				{ key: 9, label: `领用人`, visible: true },
				{ key: 10, label: `备注`, visible: true }
			],
			dialogWidth: window.innerWidth > 768 ? '600px' : '95%',
			// 退回相关
			returnOpen: false,
			returnForm: {
				id: null,
				originalQuantity: null,
				quantity: null,
				totalAfterReturn: null,
				inLocation: null,
				remark: null,
				handler: null,
				localDate: null
			},
			returnRules: {
				localDate: [{ required: true, message: '请选择退回日期', trigger: 'change' }],
				quantity: [
					{ required: true, message: '请输入退回数量', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (!value) {
								callback(new Error('请输入退回数量'));
								return;
							}
							const num = Number(value);
							if (!Number.isInteger(num) || num < 1) {
								callback(new Error('退回数量必须为正整数且大于等于1'));
								return;
							}
							const originalQty = Number(this.returnForm.originalQuantity) || 0;
							if (num > originalQty) {
								callback(new Error(`退回数量不能超过原始数量 ${originalQty}`));
								return;
							}
							callback();
						},
						trigger: 'blur'
					}
				]
			},
			// 查看详情相关
			viewDetailVisible: false,
			viewDetailTitle: '',
			viewDetailData: null,
			viewDetailLoading: false
		};
	},
	computed: {
		// 优化：使用计算属性替代函数，避免每次渲染都创建新对象
		cellStyle() {
			return { padding: '1px' };
		}
	},
	created() {
		this.getUsers();
		this.getList();
		this.updateDialogWidth();
		window.addEventListener('resize', this.updateDialogWidth);
	},
	mounted() {
		// 优化：为表格滚动容器添加被动事件监听器，消除 mousewheel 警告
		this.$nextTick(() => {
			this.optimizeTableScroll();
		});
	},
	beforeDestroy() {
		window.removeEventListener('resize', this.updateDialogWidth);
		// 清理滚动优化
		this.cleanupTableScroll();
	},
	methods: {
		/** 优化表格滚动，消除 mousewheel 被动事件警告 */
		optimizeTableScroll() {
			this.$nextTick(() => {
				const tableEl = this.$el?.querySelector('.el-table__body-wrapper');
				if (tableEl) {
					// 添加被动的 wheel 事件监听器，改善滚动性能
					this._tableWheelHandler = e => {
						// 被动监听器，不阻止默认行为
					};
					tableEl.addEventListener('wheel', this._tableWheelHandler, { passive: true });

					// 使用 CSS 优化滚动性能
					tableEl.style.overscrollBehavior = 'contain';
					tableEl.style.scrollBehavior = 'auto';
				}
			});
		},
		/** 清理表格滚动优化 */
		cleanupTableScroll() {
			const tableEl = this.$el?.querySelector('.el-table__body-wrapper');
			if (tableEl && this._tableWheelHandler) {
				tableEl.removeEventListener('wheel', this._tableWheelHandler);
				this._tableWheelHandler = null;
			}
		},
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			// 优化：缓存数据长度，避免重复访问
			const dataLength = data.length;
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
				} else if (column.property === 'quantity') {
					// 优化：使用 for 循环替代 reduce，性能更好
					let total = 0;
					for (let i = 0; i < dataLength; i++) {
						total += Number(data[i].quantity || 0);
					}
					sums[index] = total.toFixed(0); // 整数格式
				} else {
					sums[index] = '';
				}
			});
			return sums;
		},
		// 删除再入库详情记录
		async handleDeleteReInDetail(row) {
			// 验证 row 和 row.id 是否存在
			if (!row || !row.id) {
				this.$modal.msgError('无效的记录数据，无法删除');
				return;
			}

			try {
				// 确认删除操作
				await this.$modal.confirm('确定要删除这条再入库记录吗？');

				// 调用接口删除记录
				await delGift(row.id);

				this.$modal.msgSuccess('删除成功');

				// 刷新当前查看详情的数据
				if (this.currentViewRow) {
					this.handleViewReInDetail(this.currentViewRow);
				}
			} catch (error) {
				// Element UI MessageBox 取消时会 reject，错误通常是 'cancel' 字符串
				if (error === 'cancel' || (error && error.toString && error.toString().includes('cancel'))) {
					// 用户取消删除，不显示错误，静默返回
					return;
				}
				// 其他错误（网络错误、服务器错误等）
				console.error('删除再入库记录失败:', error);
				if (error && error.response && error.response.data) {
					const errorMsg = error.response.data.msg || error.response.data.message || '删除失败';
					this.$modal.msgError(errorMsg);
				} else if (error && error.message) {
					this.$modal.msgError(error.message);
				} else {
					this.$modal.msgError('删除失败，请稍后重试');
				}
			}
		},

		// 包装 listGiftIn 函数，确保参数正确传递（使用 noPage 获取全部数据）
		async listGiftIn(query) {
			const params = { ...query, noPage: true };
			// 移除空值参数，避免后端报错（虽然文档标记为 required，但实际应该是查询条件）
			Object.keys(params).forEach(key => {
				if (params[key] === null || params[key] === undefined || params[key] === '') {
					delete params[key];
				}
			});
			console.log('调用 listGiftIn，参数:', params);
			const response = await listGiftInApi(params);
			console.log('listGiftIn 响应:', response);

			// 确保返回的数据中包含 id 字段（入库记录ID）和金额字段
			if (response && response.rows) {
				response.rows = response.rows.map(item => {
					// 确保每条记录都有 id 字段，用于后续设置 inId
					if (!item.id && item.inId) {
						item.id = item.inId;
					}
					// 如果没有金额字段，则计算：数量 × 单价
					if (!item.estimatedValue && item.quantity && item.unitPrice) {
						item.estimatedValue = Number(multiply(Number(item.quantity) || 0, Number(item.unitPrice) || 0).toFixed(2));
					}
					return item;
				});
			}

			return response;
		},
		getGiftIn,
		parseTime,
		getUsers() {
			// 这里需要根据你系统的用户API进行调整
			// 示例使用 Ruoyi 的用户接口

			listUser({ noPage: true })
				.then(response => {
					this.userList = response.rows || [];
				})
				.catch(error => {
					console.error('获取用户列表失败:', error);
					this.$message.error('获取用户列表失败');
				});
		},
		// 已废弃：listGiftInWithRemaining，改为使用 listGift（规范5：出库选择物品时使用 /system/gift/list）
		async listGiftInWithRemaining(query) {
			try {
				// 1. 获取入库列表
				const inResponse = await listGiftInApi(query);
				let inList = (inResponse && inResponse.rows) || [];

				// 2. 获取出库记录（只查询与当前入库记录相关的）
				let outList = [];
				try {
					const inIds = inList.map(item => item.id).filter(Boolean);
					if (inIds.length > 0) {
						// 尝试按 inId 查询，如果后端不支持则查询全部并在内存中过滤
						try {
							const outResponse = await listGiftOut({
								noPage: true,
								inId: inIds.join(',')
							});
							outList = outResponse?.rows || [];
						} catch (error) {
							// 如果后端不支持 inId 参数，查询全部并在内存中过滤
							const outResponse = await listGiftOut({ noPage: true });
							const allOutList = outResponse?.rows || [];
							// 只保留与当前入库记录相关的出库记录
							outList = allOutList.filter(outItem => {
								const sourceId = outItem?.inId;
								return sourceId && inIds.includes(Number(sourceId));
							});
						}
					}
				} catch (error) {
					console.warn('获取出库列表失败，将跳过出库数量计算:', error);
				}

				// 3. 获取所有退回记录（退回 = 再入库，通过再入库详情接口获取）
				let retList = [];
				try {
					const promises = inList.map(async inItem => {
						try {
							const response = await getGiftInReInDetail(inItem.id);
							let data = [];
							if (response) {
								if (Array.isArray(response)) {
									data = response;
								} else if (Array.isArray(response.data)) {
									data = response.data;
								} else if (Array.isArray(response.rows)) {
									data = response.rows;
								} else if (response.data && Array.isArray(response.data.rows)) {
									data = response.data.rows;
								} else if (response.data && Array.isArray(response.data.data)) {
									data = response.data.data;
								} else if (response.data) {
									data = Array.isArray(response.data) ? response.data : [response.data];
								}
							}
							// 为每条再入库记录（包含退回记录）添加 inId 字段，用于关联入库记录
							return data.map(item => ({
								...item,
								inId: inItem.id
							}));
						} catch (error) {
							// 如果接口404或不存在，静默处理，不影响列表加载
							if (error && error.response && error.response.status === 404) {
								console.warn(`入库记录 ${inItem.id} 的再入库详情接口不存在，跳过退回数据获取`);
							}
							return [];
						}
					});
					const results = await Promise.all(promises);
					retList = results.flat();
				} catch (error) {
					console.warn('获取退回列表失败，将跳过退回数量计算:', error);
				}

				// 4. 计算剩余数量：剩余数量 = 入库数量 - 出库数量 + 退回数量（退回 = 再入库）
				// 逻辑说明：对于每个入库记录，需要统计所有基于该入库记录产生的出库数量和退回数量
				// 出库记录通过 inId 字段关联到入库记录，累加所有匹配的出库记录数量
				// 退回记录（再入库）也通过 inId 字段关联到入库记录，累加所有匹配的退回记录数量
				// 最终剩余数量 = 入库数量 - 累计出库数量 + 累计退回数量
				const resultList = inList.map(inItem => {
					const inId = inItem.id;

					// 计算该入库记录对应的总出库数量
					// 通过 inId 匹配所有关联的出库记录，累加出库数量
					const outQty = outList
						.filter(o => {
							const sourceId = o && o.inId;
							// 匹配出库记录的 inId 与当前入库记录的 id
							return sourceId && String(sourceId) === String(inId);
						})
						.reduce((sum, o) => {
							// 累加每个出库记录的数量
							const qty = Number(o.quantity || 0);
							return add(sum, qty);
						}, 0);

					// 计算总退回数量（退回 = 再入库，所以从再入库详情中获取）
					const retQty = retList
						.filter(r => r.inId && String(r.inId) === String(inId))
						.reduce((sum, r) => {
							const qty = Number(r.quantity || 0);
							return add(sum, qty);
						}, 0);

					// 入库数量（该批次的总入库数量）
					const inQty = Number(inItem.quantity || 0);

					// 注意：规范2要求出库界面不再展示 remainingQuantity，所以不再计算和设置
					// 但保留计算逻辑以备后用（此方法已废弃，仅保留兼容性）

					return inItem;
				});

				// 返回符合 SearchOption 组件期望的格式
				return {
					rows: resultList,
					total: inResponse?.total || resultList.length
				};
			} catch (error) {
				console.error('获取入库记录失败:', error);
				return {
					rows: [],
					total: 0
				};
			}
		},
		updateDialogWidth() {
			this.dialogWidth = window.innerWidth > 768 ? '600px' : '95%';
		},
		/** 查询礼品出库信息列表 */
		getList() {
			this.loading = true;
			this.queryParams.params = {};
			if (this.daterangeOutDate && this.daterangeOutDate.length) {
				this.queryParams.params['beginOutDate'] = this.daterangeOutDate[0] + ' 00:00:00';
				this.queryParams.params['endOutDate'] = this.daterangeOutDate[1] + ' 23:59:59';
			}

			// 使用分页参数，不再使用 noPage
			const params = { ...this.queryParams };
			listGiftOut(params)
				.then(async response => {
					const rows = (response && response.rows) || [];
					// 处理数据（移除每条记录都检查再入库详情的逻辑，改为延迟加载）
					const processedRows = [];
					for (const item of rows) {
						if (!item.estimatedValue && item.quantity && item.unitPrice) {
							const qty = Number(item.quantity) || 0;
							const price = Number(item.unitPrice) || 0;
							if (qty > 0 && price > 0) {
								item.estimatedValue = round(multiply(qty, price), 2);
							}
						}
						// 不再在列表加载时检查，改为延迟加载（在用户点击"更多"按钮时再检查）
						// item.hasReInDetails = await this.checkHasReInDetails(item.id);
						processedRows.push(item);
					}
					// 优化：使用 requestAnimationFrame 延迟 DOM 更新，避免强制重排
					requestAnimationFrame(() => {
						this.giftOutList = processedRows;
						// 使用后端返回的 total 字段作为总条数
						this.total = response.total || processedRows.length;
					});
				})
				.catch(error => {
					this.$message.error('数据加载失败，请稍后重试');
					console.error('获取礼品出库列表失败:', error);
				})
				.finally(() => {
					// 优化：延迟关闭 loading，确保数据已渲染
					this.$nextTick(() => {
						this.loading = false;
					});
				});
		},
		/** 检查出库记录是否有再入库详情（延迟加载，只在需要时调用） */
		async checkHasReInDetails(id) {
			try {
				const response = await getGiftOutOutDetail(id);
				let data = null;
				if (response) {
					if (Array.isArray(response)) {
						data = response;
					} else if (Array.isArray(response.data)) {
						data = response.data;
					} else if (Array.isArray(response.rows)) {
						data = response.rows;
					} else if (response.data && Array.isArray(response.data.rows)) {
						data = response.data.rows;
					} else if (response.data && Array.isArray(response.data.data)) {
						data = response.data.data;
					} else if (response.data) {
						data = Array.isArray(response.data) ? response.data : [response.data];
					}
				}
				// 如果有数据则返回 true，否则返回 false
				return data && data.length > 0;
			} catch (error) {
				// 出错时默认返回 false，按钮保持禁用状态
				console.warn('检查再入库详情失败:', error);
				return false;
			}
		},
		/** 下拉菜单显示时检查是否有再入库详情（延迟加载优化） */
		async handleDropdownVisibleChange(row, visible) {
			// 当下拉菜单打开时，如果还没有检查过，则检查是否有再入库详情
			if (visible && row.hasReInDetails === undefined && !row._checkingReInDetails) {
				this.$set(row, '_checkingReInDetails', true);
				try {
					const hasDetails = await this.checkHasReInDetails(row.id);
					this.$set(row, 'hasReInDetails', hasDetails);
				} catch (error) {
					this.$set(row, 'hasReInDetails', false);
				} finally {
					this.$set(row, '_checkingReInDetails', false);
				}
			}
		},

		/** 获取初始表单 */
		getInitForm() {
			return {
				id: null,
				inId: null,
				outDate: null,
				outMethod: null,
				outLocation: null,
				getReason: null,
				itemName: null,
				unit: null,
				quantity: null,
				unitPrice: null,
				estimatedValue: null,
				handler: null,
				updateTime: null,
				updateBy: null,
				createTime: null,
				createBy: null,
				remark: null
			};
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.handleClose();
		},
		/** 关闭弹窗时清理表单 */
		handleClose() {
			this.$nextTick(() => {
				this.form = this.getInitForm();
				this.itemName = '';
				this.$refs.form?.resetFields();
			});
		},
		// 表单重置
		reset() {
			this.form = this.getInitForm();
			this.itemName = '';
			this.$refs.form?.resetFields();
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.daterangeOutDate = [];
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
			// 自动填充领用人为当前登录用户
			const currentUser = this.$store.getters.trueName || this.$store.getters.name;
			if (currentUser) {
				this.$set(this.form, 'handler', currentUser);
			}
			this.open = true;
			this.title = '添加礼品出库信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = (row && row.id) || (Array.isArray(this.ids) && this.ids.length === 1 ? this.ids[0] : null);

			if (!id) {
				this.$message.warning('请选择一条记录进行修改');
				return;
			}

			getGiftOut(id)
				.then(response => {
					if (!(response && response.data)) {
						this.$message.error('获取礼品出库信息失败，数据为空');
						return;
					}
					this.form = JSON.parse(JSON.stringify(response.data));

					// 确保 ID 字段存在且正确
					if (!this.form.id || this.form.id !== id) {
						console.warn('后端返回的数据中 ID 不匹配，使用请求的 ID:', id);
						this.$set(this.form, 'id', id);
					}

					// 确保 inId 字段正确（如果存在）
					if (this.form.inId !== null && this.form.inId !== undefined) {
						const inId = Number(this.form.inId);
						if (!isNaN(inId) && inId > 0) {
							this.$set(this.form, 'inId', inId);
						} else {
							this.$set(this.form, 'inId', null);
						}
					}

					console.log('编辑出库数据，ID:', this.form.id, 'inId:', this.form.inId);

					// 格式化出库日期
					if (this.form.outDate) {
						this.$set(this.form, 'outDate', this.formatDateTime(this.form.outDate));
					}

					// 设置 itemName 用于 SearchOption 回显
					if (this.form.itemName) {
						this.itemName = this.form.itemName;
					}

					// 如果领用人为空，自动填充为当前登录用户
					if (!this.form.handler || this.form.handler.trim() === '') {
						const currentUser = this.$store.getters.trueName || this.$store.getters.name;
						if (currentUser) {
							this.$set(this.form, 'handler', currentUser);
						}
					}

					// 如果出库数量存在，自动计算金额
					if (this.form.quantity && this.form.unitPrice) {
						this.calculateAmount();
					}

					this.$nextTick(() => {
						this.open = true;
						this.title = '修改礼品出库信息';
					});
				})
				.catch(error => {
					const errorMsg = (error && error.response && error.response.data && (error.response.data.msg || error.response.data.message)) || error.message || '获取礼品出库信息失败，请稍后重试';
					this.$message.error(errorMsg);
					console.error('获取礼品出库信息失败:', error);
				});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					const submitData = { ...this.form };
					if (submitData.quantity) {
						const quantityNum = parseInt(submitData.quantity, 10);
						if (isNaN(quantityNum) || quantityNum <= 0) {
							this.$message.warning('请输入有效的出库数量');
							return;
						}
						submitData.quantity = quantityNum;
					}

					// 确保getReason字段存在且不为空
					if (!submitData.getReason || submitData.getReason.trim() === '') {
						this.$message.warning('请输入领用原因');
						return;
					}

					// 确保金额被正确计算
					this.calculateAmount();

					// 直接提交
					if (submitData.quantity) {
						this.doSubmit(submitData);
					} else {
						this.$message.warning('请输入出库数量');
					}
				} else {
					this.$message.warning('请完善表单信息');
				}
			});
		},
		/** 执行提交 */
		doSubmit(submitData) {
			// 显示加载状态
			const loadingInstance = this.$loading({
				lock: true,
				text: this.form.id != null ? '正在修改...' : '正在新增...',
				spinner: 'el-icon-loading',
				background: 'rgba(0, 0, 0, 0.7)'
			});

			// 数据清理：确保字符串字段不超过最大长度（防御性编程）
			if (submitData.outLocation && typeof submitData.outLocation === 'string') {
				submitData.outLocation = submitData.outLocation.substring(0, 50);
			}
			if (submitData.getReason && typeof submitData.getReason === 'string') {
				submitData.getReason = submitData.getReason.substring(0, 1000);
			}
			if (submitData.itemName && typeof submitData.itemName === 'string') {
				submitData.itemName = submitData.itemName.substring(0, 255);
			}
			if (submitData.unit && typeof submitData.unit === 'string') {
				submitData.unit = submitData.unit.substring(0, 255);
			}
			if (submitData.handler && typeof submitData.handler === 'string') {
				submitData.handler = submitData.handler.substring(0, 20);
			}

			// 规范1：出库修改时 unit 和 unitPrice 必须传递，但用户不能修改，并且不能为 null
			if (this.form.id != null) {
				// 修改时，unit 和 unitPrice 必须存在且不为 null
				if (submitData.unit === null || submitData.unit === undefined || submitData.unit === '') {
					loadingInstance.close();
					this.$message.error('单位不能为空');
					return;
				}
				if (submitData.unitPrice === null || submitData.unitPrice === undefined || submitData.unitPrice === '') {
					loadingInstance.close();
					this.$message.error('单价不能为空');
					return;
				}
			}

			// 确保单价和金额格式正确
			if (submitData.unitPrice !== null && submitData.unitPrice !== undefined) {
				submitData.unitPrice = round(Number(submitData.unitPrice), 2);
			}
			if (submitData.estimatedValue !== null && submitData.estimatedValue !== undefined) {
				submitData.estimatedValue = round(Number(submitData.estimatedValue), 2);
			}

			// 处理 inId 字段：如果存在，确保是有效的数字
			if (submitData.inId !== null && submitData.inId !== undefined && submitData.inId !== '') {
				const inId = Number(submitData.inId);
				if (!isNaN(inId) && inId > 0) {
					submitData.inId = inId;
					console.log('✓ inId 字段有效，已设置为:', inId);
				} else {
					// 如果 inId 无效，设置为 null（允许手动输入物品名称时不关联入库记录）
					console.warn('⚠ inId 字段无效，已设置为 null。原始值:', submitData.inId);
					submitData.inId = null;
				}
			} else {
				// 如果没有 inId，设置为 null
				console.log('ℹ 未提供 inId 字段，设置为 null（允许手动输入物品名称时不关联入库记录）');
				submitData.inId = null;
			}

			// 调试：打印提交的数据
			console.log('提交出库数据，操作类型:', this.form.id != null ? '修改' : '新增');
			console.log('✓ inId 字段最终值:', submitData.inId);
			console.log('提交的完整数据:', JSON.stringify(submitData, null, 2));

			if (this.form.id != null) {
				updateGiftOut(submitData)
					.then(response => {
						loadingInstance.close();
						this.$modal.msgSuccess('修改成功');
						this.open = false;
						this.getList();
						// 通知库存信息页面刷新
						this.$bus.$emit('gift-out-refresh');
					})
					.catch(error => {
						loadingInstance.close();
						const errorMsg = (error && error.response && error.response.data && error.response.data.msg) || (error && error.response && error.response.data && error.response.data.message) || (error && error.message) || '修改失败，请稍后重试';
						this.$message.error(errorMsg);
						console.error('修改礼品出库信息失败:', error);
						console.error('错误详情:', error && error.response && error.response.data);
					});
			} else {
				addGiftOut(submitData)
					.then(response => {
						loadingInstance.close();
						this.$modal.msgSuccess('新增成功');
						this.open = false;
						this.getList();
						// 通知库存信息页面刷新
						this.$bus.$emit('gift-out-refresh');
					})
					.catch(error => {
						loadingInstance.close();
						const errorMsg = (error && error.response && error.response.data && error.response.data.msg) || (error && error.response && error.response.data && error.response.data.message) || (error && error.message) || '新增失败，请稍后重试';
						this.$message.error(errorMsg);
						console.error('新增礼品出库信息失败:', error);
						console.error('错误详情:', error && error.response && error.response.data);
					});
			}
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			const count = Array.isArray(ids) ? ids.length : 1;
			const message = count > 1 ? `是否确认删除选中的${count}条礼品出库信息？` : `是否确认删除礼品出库信息的数据项？`;

			this.$modal
				.confirm(message)
				.then(() => delGiftOut(ids))
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
					// 通知库存信息页面刷新
					this.$bus.$emit('gift-out-refresh');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/giftOut/export',
				{
					...this.queryParams
				},
				`礼品出库信息_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`
			);
		},
		/** 数量输入处理 */
		handleQuantityInput() {
			this.calculateAmount();
		},
		handleQuantityBlur() {
			this.calculateAmount();
		},
		/** 根据数量和单价计算金额 */
		calculateAmount() {
			const quantity = Number(this.form.quantity) || 0;
			const unitPrice = Number(this.form.unitPrice) || 0;
			if (quantity > 0 && unitPrice > 0) {
				const result = multiply(quantity, unitPrice);
				this.$set(this.form, 'estimatedValue', round(result, 2));
			} else {
				this.$set(this.form, 'estimatedValue', null);
			}
		},
		/** 金额输入处理 */
		handleAmountInput() {
			// 手动输入金额时不自动计算
		},
		/** 格式化金额 */
		// formatAmount() {
		// 	// 失去焦点时格式化为两位小数
		// 	if (this.form.estimatedValue !== null && this.form.estimatedValue !== undefined && this.form.estimatedValue !== '') {
		// 		const num = Number(this.form.estimatedValue);
		// 		if (!isNaN(num)) {
		// 			this.$set(this.form, 'estimatedValue', round(num, 2));
		// 		}
		// 	}
		// },
		/** 格式化日期时间 */
		formatDateTime(dateTime) {
			if (!dateTime) return '';
			// 如果已经是字符串格式 yyyy-MM-dd，直接返回
			if (typeof dateTime === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(dateTime)) {
				return dateTime;
			}
			// 如果是字符串格式 yyyy-MM-dd HH:mm:ss，提取日期部分
			if (typeof dateTime === 'string' && /^\d{4}-\d{2}-\d{2}/.test(dateTime)) {
				// 提取日期部分（yyyy-MM-dd）
				const datePart = dateTime.split(' ')[0];
				if (/^\d{4}-\d{2}-\d{2}$/.test(datePart)) {
					return datePart;
				}
				// 尝试解析并格式化
				const date = new Date(dateTime.replace(/-/g, '/'));
				if (!isNaN(date.getTime())) {
					return this.parseTime(date, '{y}-{m}-{d}');
				}
			}
			// 如果是时间戳，转换为字符串格式
			if (typeof dateTime === 'number') {
				// 判断是秒级还是毫秒级时间戳
				const timestamp = dateTime.toString().length === 10 ? dateTime * 1000 : dateTime;
				return this.parseTime(timestamp, '{y}-{m}-{d}');
			}
			// 如果是 Date 对象，转换为字符串格式
			if (dateTime instanceof Date) {
				return this.parseTime(dateTime, '{y}-{m}-{d}');
			}
			// 尝试解析字符串日期
			const date = new Date(dateTime);
			if (!isNaN(date.getTime())) {
				return this.parseTime(date, '{y}-{m}-{d}');
			}
			return dateTime;
		},
		/** 获取初始退回表单 */
		getInitReturnForm() {
			return {
				id: null,
				originalQuantity: null,
				quantity: null,
				totalAfterReturn: null,
				inLocation: null,
				remark: null,
				handler: null,
				localDate: null
			};
		},

		/** 退回按钮操作 */
		handleReturn(row) {
			this.returnForm = this.getInitReturnForm();
			this.returnForm.id = row.id;
			// 使用当前出库数量作为原始数量
			const originalQty = Number(row.quantity) || 0;
			this.$set(this.returnForm, 'originalQuantity', originalQty);
			// 初始化退回后总数等于原始数量
			this.$set(this.returnForm, 'totalAfterReturn', originalQty);
			// 自动填充经办人为当前登录用户
			const currentUser = this.$store.getters.trueName || this.$store.getters.name;
			if (currentUser) {
				this.$set(this.returnForm, 'handler', currentUser);
			}
			this.returnOpen = true;
		},
		/** 关闭退回弹窗 */
		handleReturnClose() {
			this.$nextTick(() => {
				this.returnForm = this.getInitReturnForm();
				this.$refs.returnForm?.resetFields();
			});
		},
		/** 提交退回表单 */
		submitReturnForm() {
			this.$refs['returnForm'].validate(valid => {
				if (valid) {
					const quantity = Number(this.returnForm.quantity);

					// 验证必填字段
					if (!this.returnForm.id || isNaN(Number(this.returnForm.id))) {
						this.$message.error('无效的出库ID');
						return;
					}
					if (!quantity || isNaN(quantity) || quantity <= 0) {
						this.$message.error('请输入有效的退回数量');
						return;
					}

					const submitData = {
						id: Number(this.returnForm.id),
						quantity: quantity,
						localDate: this.returnForm.localDate // 确保包含 localDate 字段
					};

					console.log('提交退回数据:', submitData);
					returnGiftOut(submitData)
						.then(response => {
							this.$modal.msgSuccess('退回成功');
							this.returnOpen = false;
							this.getList();
							// 通知库存信息页面刷新
							this.$bus.$emit('gift-out-refresh');
						})
						.catch(error => {
							console.error('退回礼品出库信息失败:', error);
							if (error && error.response) {
								const errorMsg = error.response.data?.msg || error.response.data?.message || '退回失败';
								this.$message.error(errorMsg);
							} else if (error && error.message) {
								this.$message.error(error.message);
							} else {
								this.$message.error('退回失败，请稍后重试');
							}
						});
				}
			});
		},
		/** 查看再入库详情 */
		handleViewReInDetail(row) {
			this.currentViewRow = row; // 保存当前行
			const id = Number(row.id);
			if (!id || isNaN(id)) {
				this.$message.error('无效的出库ID');
				return;
			}

			this.viewDetailLoading = true;
			this.viewDetailVisible = true;
			this.viewDetailTitle = '查看再入库详情';
			this.viewDetailData = [];
			getGiftOutOutDetail(id)
				.then(response => {
					console.log('再入库详情接口响应:', response);
					// 处理多种可能的响应结构
					let data = null;
					if (response) {
						if (Array.isArray(response)) {
							data = response;
						} else if (Array.isArray(response.data)) {
							data = response.data;
						} else if (Array.isArray(response.rows)) {
							data = response.rows;
						} else if (response.data && Array.isArray(response.data.rows)) {
							data = response.data.rows;
						} else if (response.data && Array.isArray(response.data.data)) {
							data = response.data.data;
						} else if (response.data) {
							data = Array.isArray(response.data) ? response.data : [response.data];
						}
					}
					this.viewDetailData = data || [];
					console.log('解析后的再入库详情数据:', this.viewDetailData);
					if (this.viewDetailData && this.viewDetailData.length > 0) {
						console.log('第一条数据的所有字段:', Object.keys(this.viewDetailData[0]));
						console.log('第一条数据的完整内容:', JSON.stringify(this.viewDetailData[0], null, 2));
					}
					if (!this.viewDetailData || this.viewDetailData.length === 0) {
						this.$message.warning('暂无再入库详情数据');
					}
				})
				.catch(error => {
					console.error('获取再入库详情失败:', error);
					if (error && error.response) {
						const errorMsg = error.response.data?.msg || error.response.data?.message || '获取再入库详情失败';
						if (error.response.status === 404) {
							this.$message.warning('该接口暂未实现，请联系后端开发人员');
						} else {
							this.$message.error(errorMsg);
						}
					} else {
						this.$message.error('获取再入库详情失败，请稍后重试');
					}
					this.viewDetailData = [];
				})
				.finally(() => {
					this.viewDetailLoading = false;
				});
		},
		/** 查看初始入库信息（根据出库 id 查询来源入库记录，可选功能） */
		handleViewInDetail(row) {
			const id = Number(row.id);
			if (!id || isNaN(id)) {
				this.$message.error('无效的出库ID');
				return;
			}
			this.viewDetailLoading = true;
			this.viewDetailVisible = true;
			this.viewDetailTitle = '查看初始入库信息';
			this.viewDetailData = null;
			getGiftOutInDetail(id)
				.then(response => {
					console.log('入库详情接口响应:', response);
					// 处理多种可能的响应结构
					let data = null;
					if (response) {
						if (response.data) {
							data = response.data;
						} else if (typeof response === 'object' && !Array.isArray(response)) {
							data = response;
						}
					}
					// 如果返回的是单个对象，转换为数组以便表格显示
					if (data && !Array.isArray(data)) {
						this.viewDetailData = [data];
					} else if (Array.isArray(data) && data.length > 0) {
						this.viewDetailData = data;
					} else {
						this.viewDetailData = null;
						this.$message.warning('该出库记录没有关联的入库信息');
					}
				})
				.catch(error => {
					console.error('获取入库详情失败:', error);
					if (error && error.response) {
						const errorMsg = error.response.data?.msg || error.response.data?.message || '获取入库详情失败';
						if (error.response.status === 500 && errorMsg.includes('null')) {
							this.$message.warning('该出库记录没有关联的入库信息');
						} else {
							this.$message.error(errorMsg);
						}
					} else {
						this.$message.error('获取入库详情失败，请稍后重试');
					}
					this.viewDetailData = null;
				})
				.finally(() => {
					this.viewDetailLoading = false;
				});
		},
		/** 格式化入库日期 */
		formatInDate(dateValue) {
			if (!dateValue && dateValue !== 0) return '-';
			// 如果已经是 yyyy-MM-dd 格式，直接返回
			if (typeof dateValue === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(dateValue)) {
				return dateValue;
			}
			// 如果是 yyyy-MM-dd HH:mm:ss 格式，提取日期部分
			if (typeof dateValue === 'string' && /^\d{4}-\d{2}-\d{2}/.test(dateValue)) {
				return dateValue.split(' ')[0];
			}
			// 使用 parseTime 格式化
			try {
				const formatted = this.parseTime(dateValue, '{y}-{m}-{d}');
				return formatted || dateValue || '-';
			} catch (e) {
				console.warn('日期格式化失败:', dateValue, e);
				return dateValue || '-';
			}
		},
		/** 格式化金额（如果没有金额字段，根据数量和单价计算） */
		formatAmount(estimatedValue, quantity, unitPrice) {
			// 如果有金额字段，直接使用
			if (estimatedValue !== null && estimatedValue !== undefined && estimatedValue !== '') {
				const num = Number(estimatedValue);
				return isNaN(num) ? '-' : num.toFixed(2);
			}
			// 如果没有金额但有数量和单价，计算金额
			if (quantity && unitPrice) {
				const qty = Number(quantity) || 0;
				const price = Number(unitPrice) || 0;
				if (qty > 0 && price > 0) {
					return round(multiply(qty, price), 2).toFixed(2);
				}
			}
			return '-';
		}
	}
};
</script>

<style scoped>
::v-deep .el-dialog {
	max-height: 90vh;
	overflow-y: auto;
	border-radius: 8px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

::v-deep .el-dialog__body {
	padding: 24px 25px;
	background: #fafafa;
}

::v-deep .el-form {
	background: #fff;
	padding: 20px;
	border-radius: 6px;
}

::v-deep .el-form-item {
	margin-bottom: 18px;
}

::v-deep .el-form-item__label {
	color: #333;
	font-weight: 500;
}

::v-deep .el-dialog__footer {
	padding: 16px 25px;
	border-top: 1px solid #ebeef5;
	background: #fff;
}

::v-deep .el-dialog__footer .el-button {
	padding: 8px 20px;
	border-radius: 4px;
}

/* 优化表格滚动性能，减少 mousewheel 事件警告的影响 */
::v-deep .el-table__body-wrapper {
	overscroll-behavior: contain;
	scroll-behavior: auto;
	-webkit-overflow-scrolling: touch;
}

/* 优化滚动条性能 */
::v-deep .el-table__body-wrapper::-webkit-scrollbar {
	width: 8px;
	height: 8px;
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar-thumb {
	background-color: rgba(144, 147, 153, 0.3);
	border-radius: 4px;
}

::v-deep .el-table__body-wrapper::-webkit-scrollbar-thumb:hover {
	background-color: rgba(144, 147, 153, 0.5);
}
</style>
