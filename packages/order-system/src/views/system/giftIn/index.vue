<template>
	<div class="app-container">
		<!-- 搜索表单 -->
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="入库日期">
				<el-date-picker v-model="daterangeInDate" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" />
			</el-form-item>

			<el-form-item label="入库方式" prop="inMethod">
				<el-tooltip class="item" effect="dark" content="入库方式可在字典中进行修改" placement="top">
					<el-select v-model="queryParams.inMethod" placeholder="请选择入库方式" clearable @keyup.enter.native="handleQuery">
						<el-option v-for="dict in dict.type.order_gift_in_method" :key="dict.value" :label="dict.label" :value="dict.value" />
					</el-select>
				</el-tooltip>
			</el-form-item>

<!--			<el-form-item label="存货地点" prop="inventoryLocation">-->
<!--				<el-input v-model="queryParams.inventoryLocation" placeholder="请输入存货地点" clearable @keyup.enter.native="handleQuery" />-->
<!--			</el-form-item>-->

			<el-form-item label="物品名称" prop="itemName">
				<el-input v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="经办人" prop="handler">
				<el-input v-model="queryParams.handler" placeholder="请输入经办人" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="备注" prop="remark">
				<el-input v-model="queryParams.remark" placeholder="请输入备注" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 工具栏 -->
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:giftIn:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:giftIn:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" table-name="giftIn-columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:giftIn:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 数据表格 -->
		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" border :data="giftInList" size="mini" :cell-style="() => ({ padding: '1px' })" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />

			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="inDate" width="160" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ parseTime(scope.row.inDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[1].visible" label="入库方式" align="center" prop="inMethod" width="100" show-overflow-tooltip>
				<template #default="scope">
					<dict-tag :options="dict.type.order_gift_in_method" :value="scope.row.inMethod" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[2].visible" label="存货地点" align="center" prop="inventoryLocation" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[3].visible" label="对方信息" align="center" prop="fromInfo" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[4].visible" label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[5].visible" label="单位" align="center" prop="unit" width="80" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.unit || '-' }}</span>
				</template>
			</el-table-column>

			<!-- 入库数量：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量 -->
			<el-table-column v-if="columns[6].visible" label="入库数量" align="center" prop="quantity" width="100" show-overflow-tooltip />

			<el-table-column v-if="columns[7].visible" label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip />

			<el-table-column v-if="columns[8].visible" label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ formatCurrency(scope.row.estimatedValue) }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[9].visible" label="经办人" align="center" prop="handler" width="100" show-overflow-tooltip />

			<el-table-column label="备注" align="center" prop="remark" width="120" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="400" fixed="right">
				<template #default="scope">
					<el-button v-hasPermi="['system:giftIn:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:giftIn:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
					<el-button size="mini" type="text" icon="el-icon-refresh-left" @click="handleReturn(scope.row)">退回</el-button>
					<el-button size="mini" type="text" icon="el-icon-view" @click="handleViewReInDetail(scope.row)">查看再入库详情</el-button>
					<el-button size="mini" type="text" icon="el-icon-view" @click="handleViewOutDetail(scope.row)">查看出库详情</el-button>
				</template>
			</el-table-column>
		</el-table>

		<!-- 分页 -->
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加/修改弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" :width="dialogWidth" append-to-body @close="handleClose">
			<el-form ref="form" :model="form" :rules="rules" label-width="120px">
				<el-row :gutter="20">
					<el-col :span="24">
						<el-form-item label="日期" prop="inDate">
							<el-date-picker v-model="form.inDate" clearable type="date" value-format="yyyy-MM-dd" placeholder="请选择入库日期" style="width: 100%" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="入库方式" prop="inMethod">
							<el-select v-model="form.inMethod" placeholder="请选择入库方式" style="width: 100%">
								<el-option v-for="dict in dict.type.order_gift_in_method" :key="dict.value" :label="dict.label" :value="dict.value" />
							</el-select>
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="存货地点" prop="inventoryLocation">
							<el-input v-model="form.inventoryLocation" placeholder="请输入存货地点" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="对方信息" prop="fromInfo">
							<el-input v-model="form.fromInfo" placeholder="请输入对方信息" />
						</el-form-item>
					</el-col>

					<!-- 物品名称单独一行 -->
					<el-col :span="24">
						<el-form-item label="物品名称" prop="itemName">
							<el-row :gutter="10">
								<el-col :span="18">
									<el-input v-model="form.itemName" placeholder="从礼品库存选择或手动输入" />
								</el-col>
								
							</el-row>
						</el-form-item>
					</el-col>

					<!-- 单位、数量、单价、金额四列布局 -->
					<el-col :span="12">
						<el-form-item label="单位" prop="unit">
							<el-select v-model="form.unit" placeholder="请选择单位" style="width: 100%">
								<el-option v-for="dict in dict.type.gift_unit" :key="dict.value" :label="dict.label" :value="dict.value" />
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<!-- 入库数量：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量 -->
						<!-- 文档要求：integer, minimum: 1 -->
						<el-form-item label="入库数量" prop="quantity">
							<el-input v-model="form.quantity" placeholder="请输入入库数量" @input="calculateAmount" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="单价" prop="unitPrice">
							<el-input v-model="form.unitPrice" placeholder="请输入单价" @input="handleUnitPriceInput" @blur="formatUnitPrice" />
						</el-form-item>
					</el-col>

					<!-- 将原来的金额输入框替换为以下代码 -->
					<el-col :span="12">
						<el-form-item label="金额" prop="estimatedValue">
							<el-input
								v-model="form.estimatedValue"
								placeholder="自动计算"
								readonly
								disabled
							/>
						</el-form-item>
					</el-col>


					<!-- 经办人单独一行 -->
					<el-col :span="24">
						<el-form-item label="经办人" prop="handler">
							<el-input v-model="form.handler" placeholder="请输入经办人" />
						</el-form-item>
					</el-col>

					<!-- 备注单独一行 -->
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
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="退回购入礼品信息" :visible.sync="returnOpen" width="600px" append-to-body @close="handleReturnClose">
			<el-form ref="returnForm" :model="returnForm" :rules="returnRules" label-width="120px">
				<el-form-item label="现在的数量">
					<el-input :value="returnForm.originalQuantity || 0" disabled />
				</el-form-item>
				<el-form-item label="退回数量" prop="quantity">
					<el-input v-model="returnForm.quantity" placeholder="请输入退回数量" @input="calculateReturnTotal" />
				</el-form-item>
				<el-form-item label="出库地点" prop="outLocation">
					<el-input v-model="returnForm.outLocation" placeholder="请输入出库地点" />
				</el-form-item>
				<el-form-item label="经办人" prop="handler">
					<el-input v-model="returnForm.handler" placeholder="请输入经办人" />
				</el-form-item>
				<el-form-item label="备注" prop="remark">
					<el-input v-model="returnForm.remark" type="textarea" placeholder="请输入备注" :rows="3" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitReturnForm">确 定</el-button>
				<el-button @click="returnOpen = false">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 查看详情弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="viewDetailTitle" :visible.sync="viewDetailVisible" width="1200px" append-to-body>
			<!-- 再入库详情表格 -->
			<el-table v-if="viewDetailTitle === '查看再入库详情' && viewDetailData && Array.isArray(viewDetailData) && viewDetailData.length > 0" :data="viewDetailData" border size="mini" max-height="500" v-loading="viewDetailLoading">
				<el-table-column label="ID" align="center" prop="id" width="80" show-overflow-tooltip />
<!--				<el-table-column label="日期" align="center" prop="inDate" width="120" show-overflow-tooltip>-->
<!--					<template #default="scope">-->
<!--						<span>{{ scope.row.inDate ? parseTime(scope.row.inDate, '{y}-{m}-{d}') : '-' }}</span>-->
<!--					</template>-->
<!--				</el-table-column>-->
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
				<el-table-column label="数量" align="center" prop="quantity" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.quantity !== null && scope.row.quantity !== undefined ? scope.row.quantity : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ calculateDetailAmount(scope.row) }}</span>
					</template>
				</el-table-column>
				<el-table-column label="经办人" align="center" prop="handler" width="100" show-overflow-tooltip />
				<el-table-column label="备注" align="center" prop="remark" show-overflow-tooltip />
			</el-table>
			<!-- 出库详情表格 -->
			<el-table v-else-if="viewDetailTitle === '查看出库详情' && viewDetailData && Array.isArray(viewDetailData) && viewDetailData.length > 0" :data="viewDetailData" border size="mini" max-height="500" v-loading="viewDetailLoading">
				<el-table-column label="ID" align="center" prop="id" width="80" show-overflow-tooltip />
				<el-table-column label="出库日期" align="center" prop="outDate" width="120" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.outDate ? parseTime(scope.row.outDate, '{y}-{m}-{d}') : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="出库方式" align="center" prop="outMethod" width="100" show-overflow-tooltip>
					<template #default="scope">
						<dict-tag :options="dict.type.order_gift_out_method" :value="scope.row.outMethod" />
					</template>
				</el-table-column>
				<el-table-column label="出库地点" align="center" prop="outLocation" width="120" show-overflow-tooltip />
				<el-table-column label="物品名称" align="center" prop="itemName"  show-overflow-tooltip />
				<el-table-column label="单位" align="center" prop="unit" width="80" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.unit || '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="数量" align="center" prop="quantity" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.quantity !== null && scope.row.quantity !== undefined ? scope.row.quantity : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ calculateDetailAmount(scope.row) }}</span>
					</template>
				</el-table-column>
			</el-table>
			<div v-else-if="viewDetailData && !Array.isArray(viewDetailData)" style="padding: 20px;">
				<el-descriptions :column="2" border>
					<el-descriptions-item v-for="(value, key) in viewDetailData" :key="key" :label="key">{{ value }}</el-descriptions-item>
				</el-descriptions>
			</div>
			<div v-else-if="!viewDetailLoading && (!viewDetailData || (Array.isArray(viewDetailData) && viewDetailData.length === 0))" style="padding: 20px; text-align: center; color: #909399;">暂无数据</div>
			<div slot="footer" class="dialog-footer">
				<el-button @click="viewDetailVisible = false">关 闭</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listGiftIn, getGiftIn, delGiftIn, addGiftIn, updateGiftIn, returnGiftIn, getGiftInReInDetail, getGiftInOutDetail } from '@/api/system/giftIn';
import { listGift as listGiftApi } from '@/api/system/giftStock';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { mixin_gift_in_fill } from './giftIn_fill';
import SearchOption from '../../../components/SearchOption.vue';
import { multiply, round, divide, subtract, add } from 'mathjs';

export default {
	name: 'GiftIn',
	dicts: ['order_gift_in_method', 'gift_unit', 'order_gift_out_method'],
	mixins: [mixin_printHTML, mixin_gift_in_fill],
	components: { SearchOption },
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			giftInList: [],
			title: '',
			open: false,
			daterangeInDate: [],
			itemName: '',
		queryParams: {
			pageNum: 1,
			pageSize: 20,
			inDate: null,
			inMethod: null,
			inventoryLocation: null,
			fromInfo: null,
			itemName: null,
			handler: null,
			remark: null,
			receiveMethod: null
		},
			form: {},
		rules: {
			inDate: [{ required: true, message: '请选择入库日期', trigger: 'blur' }],
			inMethod: [
				{ required: true, message: '请选择入库方式', trigger: 'blur' },
				{ max: 255, message: '入库方式长度不能超过255个字符', trigger: 'blur' }
			],
			inventoryLocation: [{ required: false, message: '请输入存货地点', trigger: 'blur' }],
			fromInfo: [
				{ required: false, message: '请输入对方信息', trigger: 'blur' },
				{ max: 255, message: '对方信息长度不能超过255个字符', trigger: 'blur' }
			],
			itemName: [
				{ required: true, message: '请输入物品名称', trigger: 'blur' },
				{ max: 255, message: '物品名称长度不能超过255个字符', trigger: 'blur' }
			],
			unit: [{ required: false, message: '请选择单位', trigger: 'change' }],
			// 入库数量：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量
			// 文档要求：integer, minimum: 1
			quantity: [
				{ required: true, message: '请输入入库数量', trigger: 'blur' },
				{ validator: (rule, value, callback) => {
					if (!value) {
						callback(new Error('请输入入库数量'));
						return;
					}
					const num = Number(value);
					if (isNaN(num) || !Number.isInteger(num) || num < 1) {
						callback(new Error('数量必须是大于等于1的整数'));
						return;
					}
					callback();
				}, trigger: 'blur' }
			],
			unitPrice: [
				{ required: false, message: '请输入单价', trigger: 'blur' },
				{ pattern: /^\d+(\.\d{1,2})?$/, message: '请输入有效的金额格式', trigger: 'blur' }
			],
			// estimatedValue: [
			// 	{ required: true, message: '请输入预估价值/购买金额', trigger: 'blur' },
			// 	{ validator: (rule, value, callback) => {
			// 		if (value === null || value === undefined || value === '') {
			// 			callback(new Error('请输入预估价值/购买金额'));
			// 			return;
			// 		}
			// 		const num = Number(value);
			// 		if (isNaN(num)) {
			// 			callback(new Error('预估价值必须是有效数字'));
			// 			return;
			// 		}
			// 		callback();
			// 	}, trigger: 'blur' }
			// ],
			handler: [
				{ required: true, message: '请输入经办人', trigger: 'blur' },
				{ max: 20, message: '经办人长度不能超过20个字符', trigger: 'blur' }
			],
			receiveMethod: [
				{ required: false, message: '请输入收礼方式', trigger: 'blur' },
				{ max: 50, message: '收礼方式长度不能超过50个字符', trigger: 'blur' }
			],
			remark: [{ required: false, message: '请输入备注', trigger: 'blur' }]
		},
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `入库方式`, visible: true },
				{ key: 2, label: `存货地点`, visible: true },
				{ key: 3, label: `对方信息`, visible: true },
				{ key: 4, label: `物品名称`, visible: true },
				{ key: 5, label: `单位`, visible: true },
				{ key: 6, label: `入库数量`, visible: true },
				{ key: 7, label: `单价`, visible: true },
				{ key: 8, label: `金额`, visible: true },
				{ key: 9, label: `经办人`, visible: true }
			],
			// companyType: '供应商',
			dialogWidth: window.innerWidth > 768 ? '600px' : '95%',
			viewDetailVisible: false,
			viewDetailTitle: '',
			viewDetailData: null,
			viewDetailLoading: false,
			returnOpen: false,
			returnForm: {},
			returnRules: {
				quantity: [
					{ required: true, message: '请输入退回数量', trigger: 'blur' },
					{ validator: (rule, value, callback) => {
						if (!value) {
							callback(new Error('请输入退回数量'));
							return;
						}
						const num = Number(value);
						if (isNaN(num) || !Number.isInteger(num) || num < 1) {
							callback(new Error('退回数量必须是大于等于1的整数'));
							return;
						}
						callback();
					}, trigger: 'blur' }
				],
				outLocation: [
					{ required: true, message: '请输入出库地点', trigger: 'blur' },
					{ max: 255, message: '出库地点长度不能超过255个字符', trigger: 'blur' }
				],
				handler: [
					{ max: 20, message: '经办人长度不能超过20个字符', trigger: 'blur' }
				],
				remark: [
					{ required: true, message: '请输入备注', trigger: 'blur' }
				]
			}
		};
	},
	created() {
		this.getList();
		this.updateDialogWidth();
		window.addEventListener('resize', this.updateDialogWidth);
		// 调试：检查字典数据是否加载

	},
	beforeDestroy() {
		window.removeEventListener('resize', this.updateDialogWidth);
	},
	methods: {
		parseTime,
		// 包装 listGift 函数，计算金额字段
		async listGift(query) {
			const response = await listGiftApi(query);
			// 如果没有金额字段，则计算：剩余数量 × 单价
			if (response && response.rows) {
				response.rows = response.rows.map(item => {
					if (!item.remainingValue && item.remainingQuantity !== undefined && item.unitPrice !== undefined) {
						item.remainingValue = Number(multiply(Number(item.remainingQuantity) || 0, Number(item.unitPrice) || 0).toFixed(2));
					}
					return item;
				});
			}
			return response;
		},
		updateDialogWidth() {
			this.dialogWidth = window.innerWidth > 768 ? '600px' : '95%';
		},
		async getList() {
			this.loading = true;
			this.queryParams.params = {};
			// 处理日期范围查询
			if (this.daterangeInDate && this.daterangeInDate.length === 2) {
				this.queryParams.params['beginInDate'] = this.daterangeInDate[0] + ' 00:00:00';
				this.queryParams.params['endInDate'] = this.daterangeInDate[1] + ' 23:59:59';
			}
			// 文档中查询接口的参数都是可选的,不需要强制必填

			try {
				// 1. 获取入库列表
				const inResponse = await listGiftIn(this.queryParams);
				let inList = (inResponse && inResponse.rows) || [];

				//  自动计算金额（修复金额列不显示的真正原因）
				inList = inList.map(item => {
					if (!item.estimatedValue) {
						const qty = Number(item.quantity) || 0;
						const price = Number(item.unitPrice) || 0;
						item.estimatedValue = Number((qty * price).toFixed(2));
					}
					return item;
				});

				// 2. 获取所有出库记录（通过入库ID查询每个入库记录对应的出库记录）
				let outList = [];
				try {
					outList = await this.getAllOutList(inList);
				} catch (error) {
					console.warn('获取出库列表失败，将跳过出库数量计算:', error);
				}

				// 3. 获取当前页的退回记录（退回 = 再入库，通过再入库详情接口获取）
				let retList = [];
				try {
					retList = await this.getAllReturnList(inList);
				} catch (error) {
					console.warn('获取退回列表失败，将跳过退回数量计算:', error);
				}

				// 4. 计算剩余数量：剩余数量 = 入库数量 - 出库数量 + 退回数量（退回 = 再入库）
				this.giftInList = this.calculateRemaining(inList, outList, retList);
				this.total = (inResponse && inResponse.total) || 0;

				// 调试输出
				if (this.giftInList.length > 0) {
					console.log('✓ 最终返回的数据示例:', this.giftInList[0]);
					console.log('✓ 已出库数量字段值:', this.giftInList[0].outQuantity);
					// 检查所有记录的 outQuantity 字段
					const hasOutQuantity = this.giftInList.some(item => item.outQuantity !== undefined && item.outQuantity !== null);
					console.log('✓ 是否有记录包含 outQuantity 字段:', hasOutQuantity);
					if (hasOutQuantity) {
						const outQuantityList = this.giftInList.map(item => ({
							id: item.id,
							itemName: item.itemName,
							outQuantity: item.outQuantity
						}));
						console.log('✓ 所有记录的已出库数量:', outQuantityList);
					}
				}
			} catch (error) {
				this.$message.error('数据加载失败，请稍后重试');
				console.error('获取礼品入库列表失败:', error);
			} finally {
				this.loading = false;
			}
		},
		// 获取所有出库记录（通过入库ID查询每个入库记录对应的出库记录）
		async getAllOutList(inList) {
			// 遍历当前页的入库记录，获取每个记录的出库详情
			const promises = inList.map(async (inItem) => {
				try {
					const response = await getGiftInOutDetail(inItem.id);
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
					// 为每条出库记录添加 inId 字段，用于关联入库记录
					return data.map(item => ({
						...item,
						inId: inItem.id
					}));
				} catch (error) {
					// 如果接口404或不存在，静默处理，不影响列表加载
					if (error && error.response && error.response.status === 404) {
						console.warn(`入库记录 ${inItem.id} 的出库详情接口不存在，跳过出库数据获取`);
					} else {
						console.warn(`获取入库记录 ${inItem.id} 的出库详情失败:`, error);
					}
					return [];
				}
			});
			const results = await Promise.all(promises);
			return results.flat();
		},
		// 获取所有退回记录（退回 = 再入库，所以通过再入库详情接口获取）
		async getAllReturnList(inList) {
			// 遍历当前页的入库记录，获取每个记录的再入库详情
			// 注意：退回操作会作为再入库记录显示在"查看再入库详情"中
			const promises = inList.map(async (inItem) => {
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
					} else {
						console.warn(`获取入库记录 ${inItem.id} 的再入库详情失败:`, error);
					}
					return [];
				}
			});
			const results = await Promise.all(promises);
			return results.flat();
		},
		// 计算剩余数量
		// 公式：剩余数量 = 入库数量 - 出库数量 + 退回数量（退回 = 再入库）
		calculateRemaining(inList, outList, retList) {
			console.log('🔍 开始计算已出库数量，入库记录数:', inList.length, '出库记录数:', outList.length);
			
			return inList.map(inItem => {
				const id = inItem.id;
				const idStr = String(id);

				// 计算总出库数量（强关联：显示已出库数量）
				// 匹配出库记录中 inId 等于当前入库记录 id 的所有记录
				const matchedOutList = outList.filter(o => {
					const sourceId = o && o.inId;
					const sourceIdStr = sourceId ? String(sourceId) : null;
					const isMatch = sourceId && sourceIdStr === idStr;
					
					// 详细日志：显示匹配过程
					if (id === 8 || id === 7 || id === 5 || id === 4 || id === 3) {
						console.log(`🔍 匹配检查: 入库ID=${id}(${typeof id}), 出库ID=${o?.id}, 出库inId=${sourceId}(${typeof sourceId}), 是否匹配=${isMatch}`);
					}
					
					if (isMatch) {
						console.log(`✓ 找到匹配的出库记录: 入库ID=${id}, 出库ID=${o.id}, 出库数量=${o.quantity || o.outQuantity || 0}`);
					}
					return isMatch;
				});
				
				const outQty = matchedOutList.reduce((sum, o) => {
					const qty = Number(o.quantity || o.outQuantity || 0);
					console.log(`  累加出库数量: ${qty}, 当前总和: ${sum}, 累加后: ${add(sum, qty)}`);
					return add(sum, qty);
				}, 0);

				// 计算总退回数量（退回 = 再入库，所以从再入库详情中获取）
				const retQty = retList
					.filter(r => r.inId && String(r.inId) === String(id))
					.reduce((sum, r) => {
						const qty = Number(r.quantity || 0);
						return add(sum, qty);
					}, 0);

				// 入库数量（第一次入库的数量）
				const inQty = Number(inItem.quantity || 0);

				// 强关联：在入库列表中显示已出库数量
				inItem.outQuantity = outQty;
				
				// 计算剩余数量：剩余数量 = 入库数量 - 出库数量 + 退回数量（退回 = 再入库）
				const remainingQty = subtract(add(inQty, retQty), outQty);
				inItem.remainingQuantity = remainingQty;
				
				console.log(`📊 入库记录 ID=${id}, 物品=${inItem.itemName}, 入库数量=${inQty}, 已出库数量=${outQty}, 退回数量=${retQty}, 剩余数量=${remainingQty}`);

				return inItem;
			});
		},
		getInitForm() {
			return {
				id: null,
				inDate: null,
				inMethod: null,
				inventoryLocation: null,
				fromInfo: null,
				itemName: null,
				unit: null,
				// 入库数量 (quantity)：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量
				// 文档要求：integer, minimum: 1
				quantity: null,
				unitPrice: '',
				estimatedValue: '',
				handler: null,
				remark: null,
				receiveMethod: null,
				payTime: null,
				updateTime: null,
				updateBy: null,
				createTime: null,
				createBy: null
			};
		},
		getInitReturnForm() {
			return {
				id: null,
				originalQuantity: null,
				quantity: null,
				outLocation: null,
				handler: null,
				remark: null
			};
		},
		calculateReturnTotal() {
			const originalQty = Number(this.returnForm.originalQuantity) || 0;
			const returnQty = Number(this.returnForm.quantity) || 0;
			// 退回后总数 = 原始数量 + 退回数量（因为退回是增加库存）
			const totalAfterReturn = originalQty + returnQty;
			this.$set(this.returnForm, 'totalAfterReturn', totalAfterReturn);
		},
		cancel() {
			this.open = false;
			this.handleClose();
		},
		handleClose() {
			this.$nextTick(() => {
				this.form = this.getInitForm();
				// this.companyType = '供应商';
				this.$refs.form?.resetFields();
			});
		},
		reset() {
			this.form = this.getInitForm();
			// this.companyType = '供应商';
			this.$refs.form?.resetFields();
		},
		handleUnitPriceInput() {
			// 输入时触发金额计算
			this.calculateAmount();
		},
		formatUnitPrice() {
			// 失去焦点时格式化为两位小数
			if (this.form.unitPrice !== null && this.form.unitPrice !== undefined && this.form.unitPrice !== '') {
				const num = Number(this.form.unitPrice);
				if (!isNaN(num)) {
					this.$set(this.form, 'unitPrice', round(num, 2).toFixed(2));
					// 格式化后重新计算金额
					this.calculateAmount();
				}
			}
		},
		handleAmountInput() {
			// 手动输入金额时不自动计算
		},
		formatAmount() {
			// 失去焦点时格式化为两位小数
			if (this.form.estimatedValue !== null && this.form.estimatedValue !== undefined && this.form.estimatedValue !== '') {
				const num = Number(this.form.estimatedValue);
				if (!isNaN(num)) {
					this.$set(this.form, 'estimatedValue', round(num, 2).toFixed(2));
				}
			}
		},
		calculateAmount() {
			// 根据数量和单价自动计算金额
			// 文档要求：quantity 是 integer, estimatedValue 是 number
			const quantity = Number(this.form.quantity) || 0;
			const unitPrice = Number(this.form.unitPrice) || 0;

			if (quantity > 0 && unitPrice > 0) {
				const result = multiply(quantity, unitPrice);
				// 文档要求 estimatedValue 是 number 类型，显示时保留两位小数
				this.$set(this.form, 'estimatedValue', round(result, 2).toFixed(2));
			} else if (!this.form.estimatedValue || this.form.estimatedValue === '' || this.form.estimatedValue === 0 || this.form.estimatedValue === '0.00') {
				// 如果金额为空或0，且无法计算，则设为空字符串
				this.$set(this.form, 'estimatedValue', '');
			}
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.daterangeInDate = [];
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		handleAdd() {
			this.form = this.getInitForm();
			// this.companyType = '供应商';
			this.open = true;
			this.title = '添加购入礼品信息';
		},
		formatCurrency(value) {
			// 处理空值和无效值
			if (value === null || value === undefined || value === '' || value === 'null' || value === 'undefined') {
				return '-';
			}

			// 转换为数字
			const numValue = typeof value === 'string' ? parseFloat(value) : Number(value);

			// 检查是否为有效数字
			if (isNaN(numValue)) {
				return '-';
			}

			// 返回格式化的金额
			return numValue.toFixed(2);
		},
		// 计算金额：优先使用 estimatedValue，否则根据数量和单价计算
		calculateDetailAmount(row) {
			if (row.estimatedValue !== null && row.estimatedValue !== undefined && row.estimatedValue !== '') {
				return this.formatCurrency(row.estimatedValue);
			}
			const quantity = Number(row.quantity) || 0;
			const unitPrice = Number(row.unitPrice) || 0;
			if (quantity > 0 && unitPrice > 0) {
				const result = multiply(quantity, unitPrice);
				return this.formatCurrency(result);
			}
			return '-';
		},
		handleUpdate(row) {
			const id = row.id || this.ids;
			getGiftIn(id)
				.then(response => {
					if (!(response && response.data)) {
						this.$message.error('获取礼品入库信息失败，数据为空');
						return;
					}
					this.form = JSON.parse(JSON.stringify(response.data));

					// 确保日期格式正确
					if (this.form.inDate) {
						const formattedDate = this.formatDateTime(this.form.inDate);
						this.$set(this.form, 'inDate', formattedDate);
					}

					// 处理金额数据 - 文档要求是 number 类型，显示时保留两位小数
					if (this.form.estimatedValue !== null && this.form.estimatedValue !== undefined) {
						const num = Number(this.form.estimatedValue);
						if (!isNaN(num)) {
							this.$set(this.form, 'estimatedValue', round(num, 2).toFixed(2));
						} else {
							this.$set(this.form, 'estimatedValue', '');
						}
					} else {
						this.$set(this.form, 'estimatedValue', '');
					}

					// 处理单价数据 - 显示时保留两位小数
					if (this.form.unitPrice !== null && this.form.unitPrice !== undefined) {
						const num = Number(this.form.unitPrice);
						if (!isNaN(num)) {
							this.$set(this.form, 'unitPrice', round(num, 2).toFixed(2));
						} else {
							this.$set(this.form, 'unitPrice', '');
						}
					} else {
						this.$set(this.form, 'unitPrice', '');
					}

					// 如果后端返回的是 estimatedValue，需要转换为 unitPrice
					if (this.form.estimatedValue && !this.form.unitPrice && this.form.quantity && this.form.quantity > 0) {
						const estimatedValueNum = parseFloat(this.form.estimatedValue);
						if (!isNaN(estimatedValueNum)) {
							this.$set(this.form, 'unitPrice', round(divide(estimatedValueNum, this.form.quantity), 2).toFixed(2));
						}
					}

					// 如果没有金额但有数量和单价，计算金额
					if ((this.form.estimatedValue === null || this.form.estimatedValue === undefined || this.form.estimatedValue === '') && this.form.quantity && this.form.unitPrice) {
						this.calculateAmount();
					}

					// 兼容旧数据：如果有 storeLocation，转换为 inventoryLocation
					if (this.form.storeLocation && !this.form.inventoryLocation) {
						this.$set(this.form, 'inventoryLocation', this.form.storeLocation);
					}

					// 编辑时，如果有 fromInfo，同步到 companyName 用于回显
					if (this.form.fromInfo && !this.form.companyName) {
						this.$set(this.form, 'companyName', this.form.fromInfo);
					}

					this.$nextTick(() => {
						this.open = true;
						this.title = '修改购入礼品信息';
					});
				})
				.catch(error => {
					this.$message.error('获取礼品入库信息失败，请稍后重试');
					console.error('获取礼品入库信息失败:', error);
				});
		},
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
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 总是根据数量和单价计算金额，无视用户输入
					this.calculateAmount();

					// 创建提交数据副本，严格按照文档字段提交
					const submitData = JSON.parse(JSON.stringify(this.form));

					// 移除前端临时字段
					delete submitData.companyName;

					// 确保必填字段符合文档要求
					// 文档必填：inDate, inMethod, itemName, quantity, estimatedValue, handler
					if (!submitData.inDate || !submitData.inMethod || !submitData.itemName ||
						!submitData.quantity || submitData.estimatedValue === null || submitData.estimatedValue === undefined ||
						!submitData.handler) {
						this.$message.error('请填写所有必填字段');
						return;
					}

					// 确保 quantity 是整数且 >= 1（文档要求：integer, minimum: 1）
					submitData.quantity = parseInt(submitData.quantity);
					if (isNaN(submitData.quantity) || submitData.quantity < 1) {
						this.$message.error('数量必须是大于等于1的整数');
						return;
					}

					// 处理单价：转换为数字类型，保留两位小数
					if (submitData.unitPrice !== null && submitData.unitPrice !== undefined && submitData.unitPrice !== '') {
						submitData.unitPrice = Number(submitData.unitPrice);
						if (isNaN(submitData.unitPrice)) {
							this.$message.error('单价必须是有效数字');
							return;
						}
						// 保留两位小数
						submitData.unitPrice = round(submitData.unitPrice, 2);
					}

					// 确保 estimatedValue 是数字类型（文档要求：number），保留两位小数
					// 不再依赖用户输入，而是基于数量和单价计算
					if (submitData.quantity && submitData.unitPrice) {
						const result = multiply(Number(submitData.quantity), Number(submitData.unitPrice));
						submitData.estimatedValue = round(result, 2);
					} else {
						this.$message.error('请输入数量和单价以计算金额');
						return;
					}

					// 字段长度限制（按照文档）
					if (submitData.inMethod && submitData.inMethod.length > 255) {
						this.$message.error('入库方式长度不能超过255个字符');
						return;
					}
					if (submitData.fromInfo && submitData.fromInfo.length > 255) {
						this.$message.error('对方信息长度不能超过255个字符');
						return;
					}
					if (submitData.itemName && submitData.itemName.length > 255) {
						this.$message.error('物品名称长度不能超过255个字符');
						return;
					}
					if (submitData.handler && submitData.handler.length > 20) {
						this.$message.error('经办人长度不能超过20个字符');
						return;
					}
					if (submitData.receiveMethod && submitData.receiveMethod.length > 50) {
						this.$message.error('收礼方式长度不能超过50个字符');
						return;
					}

					if (this.form.id != null) {
						updateGiftIn(submitData)
							.then(response => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								const errorMsg = error?.response?.data?.msg || error?.message || '修改失败，请稍后重试';
								this.$message.error(errorMsg);
								console.error('修改礼品入库信息失败:', error);
							});
					} else {
						addGiftIn(submitData)
							.then(response => {
								this.$modal.msgSuccess('新增成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								const errorMsg = error?.response?.data?.msg || error?.message || '新增失败，请稍后重试';
								this.$message.error(errorMsg);
								console.error('新增礼品入库信息失败:', error);
							});
					}
				}
			});
		},

		handleDelete(row) {
			const ids = row.id || this.ids;
			const count = Array.isArray(ids) ? ids.length : 1;
			const message = count > 1 ? `是否确认删除选中的${count}条购入礼品信息？` : `是否确认删除购入礼品信息编号为"${ids}"的数据项？`;

			this.$modal
				.confirm(message)
				.then(() => delGiftIn(ids))
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		handleExport() {
			this.download(
				'system/giftIn/export',
				{
					...this.queryParams
				},
				`购入礼品信息_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`
			);
		},
		handleReturn(row) {
			this.returnForm = this.getInitReturnForm();
			this.returnForm.id = row.id;
			// 使用剩余数量（现在的数量）作为原始数量
			const currentQty = Number(row.remainingQuantity !== undefined ? row.remainingQuantity : row.quantity) || 0;
			this.$set(this.returnForm, 'originalQuantity', currentQty);
			// 初始化退回后总数等于现在的数量
			this.$set(this.returnForm, 'totalAfterReturn', currentQty);
			this.returnOpen = true;
		},
		handleReturnClose() {
			this.$nextTick(() => {
				this.returnForm = this.getInitReturnForm();
				this.$refs.returnForm?.resetFields();
			});
		},
		submitReturnForm() {
			this.$refs['returnForm'].validate(valid => {
				if (valid) {
					// 创建提交数据副本
					const submitData = {
						id: Number(this.returnForm.id),
						quantity: parseInt(this.returnForm.quantity),
						outLocation: this.returnForm.outLocation || '',
						handler: this.returnForm.handler || '',
						remark: this.returnForm.remark || ''
					};

					// 验证必填字段
					if (!submitData.id || isNaN(submitData.id)) {
						this.$message.error('无效的入库ID');
						return;
					}
					if (!submitData.quantity || isNaN(submitData.quantity) || submitData.quantity < 1) {
						this.$message.error('退回数量必须是大于等于1的整数');
						return;
					}
					if (!submitData.outLocation || submitData.outLocation.trim() === '') {
						this.$message.error('请输入出库地点');
						return;
					}
					if (!submitData.remark || submitData.remark.trim() === '') {
						this.$message.error('请输入备注');
						return;
					}

					// 字段长度限制
					if (submitData.outLocation && submitData.outLocation.length > 255) {
						this.$message.error('出库地点长度不能超过255个字符');
						return;
					}
					if (submitData.handler && submitData.handler.length > 20) {
						this.$message.error('经办人长度不能超过20个字符');
						return;
					}

					console.log('提交退回数据:', submitData);
					returnGiftIn(submitData)
						.then(response => {
							this.$modal.msgSuccess('退回成功');
							this.returnOpen = false;
							this.getList();
						})
						.catch(error => {
							console.error('退回购入礼品信息失败:', error);
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
		handleViewReInDetail(row) {
			const id = Number(row.id);
			if (!id || isNaN(id)) {
				this.$message.error('无效的入库ID');
				return;
			}
			this.viewDetailLoading = true;
			this.viewDetailVisible = true;
			this.viewDetailTitle = '查看再入库详情';
			this.viewDetailData = [];
			getGiftInReInDetail(id)
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
					// 调试：打印第一条数据的字段名
					if (this.viewDetailData && this.viewDetailData.length > 0) {
						console.log('第一条数据的字段:', Object.keys(this.viewDetailData[0]));
						console.log('第一条数据的数量字段值:', this.viewDetailData[0].quantity, this.viewDetailData[0]);
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
		handleViewOutDetail(row) {
			const id = row.id;
			this.viewDetailLoading = true;
			this.viewDetailVisible = true;
			this.viewDetailTitle = '查看出库详情';
			getGiftInOutDetail(id)
				.then(response => {
					console.log('出库详情接口响应:', response);
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
					console.log('解析后的出库详情数据:', this.viewDetailData);
					// 调试：打印第一条数据的字段名
					if (this.viewDetailData && this.viewDetailData.length > 0) {
						console.log('第一条数据的字段:', Object.keys(this.viewDetailData[0]));
						console.log('第一条数据的数量字段值:', this.viewDetailData[0].quantity, this.viewDetailData[0]);
					}
					if (!this.viewDetailData || (Array.isArray(this.viewDetailData) && this.viewDetailData.length === 0)) {
						this.$message.warning('暂无出库详情数据');
					}
				})
				.catch(error => {
					if (error && error.response) {
						const errorMsg = error.response.data?.msg || error.response.data?.message || '获取出库详情失败';
						if (error.response.status === 404) {
							this.$message.warning('该接口暂未实现，请联系后端开发人员');
						} else {
							this.$message.error(errorMsg);
						}
					} else {
						this.$message.error('获取出库详情失败，请稍后重试');
					}
					console.error('获取出库详情失败:', error);
					this.viewDetailData = [];
				})
				.finally(() => {
					this.viewDetailLoading = false;
				});
		}
	}
};
</script>

<style scoped>
.el-dialog {
	max-height: 90vh;
	overflow-y: auto;
}
</style>
