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
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
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

		<el-table
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="giftOutList"
			border
			size="mini"
			:cell-style="
				() => {
					return { padding: '1px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />

			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="outDate" width="160" show-overflow-tooltip>
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

			<el-table-column v-if="columns[4].visible" label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[5].visible" label="规格" align="center" prop="unit" width="100" show-overflow-tooltip />

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

			<el-table-column v-if="columns[10].visible" label="备注" align="center" prop="remark" width="120" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="400" fixed="right">
				<template #default="scope">
					<el-button v-hasPermi="['system:giftOut:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:giftOut:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
					<el-button size="mini" type="text" icon="el-icon-refresh-left" @click="handleReturn(scope.row)">退回</el-button>
					<el-button size="mini" type="text" icon="el-icon-view" @click="handleViewReInDetail(scope.row)">查看再入库详情</el-button>
					<el-button size="mini" type="text" icon="el-icon-view" @click="handleViewOutDetail(scope.row)">查看出库详情</el-button>
				</template>
			</el-table-column>
		</el-table>

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
							<el-input v-model="form.outLocation" placeholder="请输入出库地点" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="领用原因" prop="getReason">
							<el-input v-model="form.getReason" placeholder="请输入领用原因" />
						</el-form-item>
					</el-col>

<!--					<el-col :span="12">-->
<!--						<el-form-item label="收礼人员" prop="recipientReceiver">-->
<!--							<el-input v-model="form.recipientReceiver" placeholder="请输入收礼人员" />-->
<!--						</el-form-item>-->
<!--					</el-col>-->

					<el-col :span="24">
						<el-form-item label="物品名称" prop="itemName">
							<el-row :gutter="10">
								<el-col :span="20">
									<el-input v-model="form.itemName" placeholder="从入库记录自动获取" readonly />
								</el-col>
								<el-col :span="2">
									<SearchOption :get-data="listGiftInWithRemaining" query-info="itemName" query-label="物品名称" :query-name="itemName" @update:queryName="handleUpdateItemName" @commitBack="handleCommitBackItem">
										<template #table-columns>
											<el-table-column label="物品名称" align="center" prop="itemName" />
											<!-- 入库数量：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量 -->
											<el-table-column label="入库数量" align="center" prop="quantity" />
											<el-table-column label="预估价值/购买金额" align="center" prop="estimatedValue" />
											<!-- 剩余数量：当前批次礼品的可用库存数量，计算公式 = 入库数量 - 已出库数量 -->
											<el-table-column label="剩余数量" align="center" prop="remainingQuantity" />
											<el-table-column label="经办人" align="center" prop="handler" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="规格" prop="unit">
							<el-input v-model="form.unit" placeholder="请输入规格" disabled />
						</el-form-item>

					</el-col>

					<el-col :span="12">
						<el-form-item label="数量" prop="quantity">
							<el-input v-model="form.quantity" placeholder="请输入数量" @input="handleQuantityInput" @blur="handleQuantityBlur" />
						</el-form-item>
					</el-col>

					<!-- 剩余数量：当前批次礼品的可用库存数量，计算公式 = 入库数量 - 已出库数量，是动态变化的值 -->
					<el-col :span="12">
						<el-form-item label="剩余数量">
							<el-input
								:value="form.remainingQuantity !== null && form.remainingQuantity !== undefined ? form.remainingQuantity : '请先选择物品名称'"
								readonly
								placeholder="剩余数量（入库时的可用数量）" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="单价" prop="unitPrice">
							<el-input v-model="form.unitPrice" placeholder="请输入单价" disabled />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="金额" prop="estimatedValue">
							<el-input v-model="form.estimatedValue" placeholder="自动计算或手动输入" @input="calculateAmountFromValue" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="领用人" prop="handler">
							<el-input v-model="form.handler" placeholder="请输入领用人" />
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
				<el-form-item label="原本数量">
					<el-input :value="returnForm.originalQuantity || 0" disabled />
				</el-form-item>
				<el-form-item label="退回数量" prop="quantity">
					<el-input v-model="returnForm.quantity" placeholder="请输入退回数量" @input="calculateReturnTotal" />
				</el-form-item>
<!--				<el-form-item label="退回后总数">-->
<!--					<el-input :value="returnForm.totalAfterReturn || returnForm.originalQuantity || 0" disabled />-->
<!--				</el-form-item>-->
				<el-form-item label="入库地点" prop="inLocation">
					<el-input v-model="returnForm.inLocation" placeholder="请输入入库地点" />
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
				<el-table-column label="日期" align="center" prop="inDate" width="120" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.inDate ? parseTime(scope.row.inDate, '{y}-{m}-{d}') : '-' }}</span>
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
				<el-table-column label="入库数量" align="center" prop="quantity" width="100" show-overflow-tooltip />
				<el-table-column label="剩余数量" align="center" prop="remainingQuantity" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.remainingQuantity !== null && scope.row.remainingQuantity !== undefined ? scope.row.remainingQuantity : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.estimatedValue ? Number(scope.row.estimatedValue).toFixed(2) : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="剩余金额价值" align="center" prop="remainingValue" width="120" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.remainingValue ? Number(scope.row.remainingValue).toFixed(2) : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="经办人" align="center" prop="handler" width="100" show-overflow-tooltip />
				<el-table-column label="付款时间" align="center" prop="payTime" width="160" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.payTime ? parseTime(scope.row.payTime, '{y}-{m}-{d} {h}:{i}:{s}') : '-' }}</span>
					</template>
				</el-table-column>
				<el-table-column label="备注" align="center" prop="remark" show-overflow-tooltip />
			</el-table>
			<!-- 出库详情表格 -->
			<el-table v-else-if="viewDetailTitle === '查看出库详情' && viewDetailData && Array.isArray(viewDetailData) && viewDetailData.length > 0" :data="viewDetailData" border size="mini" max-height="500" v-loading="viewDetailLoading">
				<el-table-column label="ID" align="center" prop="id" width="80" show-overflow-tooltip />
<!--				<el-table-column label="出库日期" align="center" prop="outDate" width="120" show-overflow-tooltip>-->
<!--					<template #default="scope">-->
<!--						<span>{{ scope.row.outDate ? parseTime(scope.row.outDate, '{y}-{m}-{d}') : '-' }}</span>-->
<!--					</template>-->
<!--				</el-table-column>-->
<!--				<el-table-column label="出库方式" align="center" prop="outMethod" width="100" show-overflow-tooltip>-->
<!--					<template #default="scope">-->
<!--						<dict-tag :options="dict.type.order_gift_out_method" :value="scope.row.outMethod" />-->
<!--					</template>-->
<!--				</el-table-column>-->
<!--				<el-table-column label="出库地点" align="center" prop="outLocation" width="120" show-overflow-tooltip />-->
<!--				<el-table-column label="领用原因" align="center" width="120" show-overflow-tooltip>-->
<!--					<template #default="scope">-->
<!--						<span>{{ scope.row.getReason || scope.row.useReason || '-' }}</span>-->
<!--					</template>-->
<!--				</el-table-column>-->
				<el-table-column label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />
<!--				<el-table-column label="数量" align="center" prop="quantity" width="80" show-overflow-tooltip />-->
				<el-table-column label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
					<template #default="scope">
						<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
					</template>
				</el-table-column>
<!--				<el-table-column label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>-->
<!--					<template #default="scope">-->
<!--						<span>{{ scope.row.estimatedValue ? Number(scope.row.estimatedValue).toFixed(2) : '-' }}</span>-->
<!--					</template>-->
<!--				</el-table-column>-->
				<el-table-column label="领用人" align="center" prop="handler" width="100" show-overflow-tooltip />
				<el-table-column label="备注" align="center" prop="remark" show-overflow-tooltip />
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
import { listGiftOut, getGiftOut, delGiftOut, addGiftOut, updateGiftOut, returnGiftOut, getGiftOutReInDetail, getGiftOutOutDetail } from '@/api/system/giftOut';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import SearchOption from '../../../components/SearchOption.vue';
import { listGiftIn, getGiftIn } from '@/api/system/giftIn';
import { mixin_gift_out_fill } from './giftOut_fill';
import { subtract, round, add, multiply, divide } from 'mathjs';

export default {
	name: 'GiftOut',
	components: { SearchOption },
	dicts: ['order_gift_out_method', 'gift_unit', 'order_gift_in_method'],
	mixins: [mixin_printHTML, mixin_gift_out_fill],
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
			// 礼品出库信息表格数据
			giftOutList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 记录编辑时的原始单位和单价（用于防止误判修改）
			originalUnit: null,
			originalUnitPrice: null,
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
				recipientReceiver: null,
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
				outDate: null,
				outMethod: null,
				outLocation: null,
				getReason: null,
				recipientReceiver: null,
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
				remark: null,
				inId: null,
				remainingQuantity: null // 添加此
			},
			// 表单校验
			rules: {
				outDate: [{ required: true, message: '请选择出库日期', trigger: 'blur' }],
				outMethod: [{ required: true, message: '请选择出库方式', trigger: 'blur' }],
				getReason: [{ required: true, message: '请输入领用原因', trigger: 'blur' }],
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
							// 如果有入库ID，检查库存数量
							if (this.form.inId && this.form.itemName) {
								this.checkStockQuantity(this.form.inId, num, this.form.id)
									.then(() => {
										callback();
									})
									.catch(error => {
										callback(new Error(error));
									});
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				estimatedValue: [
					{ required: true, message: '请输入预估价值', trigger: 'blur' },
					{ pattern: /^\d+(\.\d{1,2})?$/, message: '请输入有效的金额格式', trigger: 'blur' }
				],
				// handler: [{ required: true, message: '请输入经办人', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `出库方式`, visible: true },
				{ key: 2, label: `出库地点`, visible: true },
				{ key: 3, label: `领用原因`, visible: true },
				{ key: 4, label: `物品名称`, visible: true },
				{ key: 5, label: `规格`, visible: true },
				{ key: 6, label: `数量`, visible: true },
				{ key: 7, label: `单价`, visible: true },
				{ key: 8, label: `金额`, visible: true },
				{ key: 9, label: `领用人`, visible: true },
				{ key: 10, label: `备注`, visible: true }
			],
			dialogWidth: window.innerWidth > 768 ? '600px' : '95%',
			// 剩余数量 (remainingQuantity)：当前批次礼品的可用库存数量，计算公式 = 入库数量 - 已出库数量，是动态变化的值
			remainingQuantity: null,
			// 退回相关
			returnOpen: false,
			returnForm: {},
			returnRules: {
				quantity: [
					{ required: true, message: '请输入退回数量', trigger: 'blur' },
					{ pattern: /^\d+(\.\d+)?$/, message: '请输入有效数字', trigger: 'blur' }
				],
				inLocation: [{ required: true, message: '请输入入库地点', trigger: 'blur' }],
				remark: [{ required: true, message: '请输入备注', trigger: 'blur' }],
				handler: [{ required: true, message: '请输入经办人', trigger: 'blur' }]
			},
			// 查看详情相关
			viewDetailVisible: false,
			viewDetailTitle: '',
			viewDetailData: null,
			viewDetailLoading: false
		};
	},
	created() {
		this.getList();
		this.updateDialogWidth();
		window.addEventListener('resize', this.updateDialogWidth);
	},
	beforeDestroy() {
		window.removeEventListener('resize', this.updateDialogWidth);
	},
	methods: {
		listGiftIn,
		getGiftIn,
		parseTime,
		/**
		 * 获取入库数据并计算剩余数量
		 * 剩余数量计算公式：入库数量 (quantity) - 已出库数量 = 剩余数量 (remainingQuantity)
		 */
		listGiftInWithRemaining(query) {
			return Promise.all([listGiftIn(query), listGiftOut({ pageNum: 1, pageSize: 10000 })]).then(([inResponse, outResponse]) => {
				const giftInList = (inResponse && inResponse.rows) || [];
				const giftOutList = (outResponse && outResponse.rows) || [];
				// 计算每个入库记录的出库数量
				const outQuantityMap = new Map();
				giftOutList.forEach(outItem => {
					const sourceId = outItem && outItem.inId;
					if (sourceId) {
						const inId = String(sourceId);
						const outQty = Number(outItem.quantity) || 0;
						const currentOutQty = outQuantityMap.get(inId) || 0;
						outQuantityMap.set(inId, add(currentOutQty, outQty));
					}
				});
				// 为每个入库记录添加剩余数量
				// 剩余数量 (remainingQuantity) = 入库数量 (quantity) - 已出库数量
				const result = giftInList.map(item => {
					// 入库数量：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量
					const inQty = Number(item.quantity) || 0;
					// 使用入库记录的ID来匹配出库记录
					const inId = String(item.id);
					const outQty = outQuantityMap.get(inId) || 0;
					// 计算剩余数量：当前批次礼品的可用库存数量，是动态变化的值
					const remainingQty = subtract(inQty, outQty);
					const remainingQtyNum = remainingQty > 0 ? remainingQty : 0;
					return {
						...item,
						remainingQuantity: round(remainingQtyNum, 2)
					};
				});
				return {
					...inResponse,
					rows: result
				};
			});
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

			listGiftOut(this.queryParams)
				.then(response => {
					let rows = (response && response.rows) || [];
					this.total = (response && response.total) || 0;

					// ⭐⭐⭐ 自动补出库金额（核心）
					rows = rows.map(item => {
						const qty = Number(item.outQuantity || item.quantity) || 0; // 出库数量字段自己确认
						const price = Number(item.unitPrice) || 0; // 后端有这个字段吗？

						// 如果后端没提供 estimatedValue，就自己算（使用 mathjs）
						if (!item.estimatedValue || item.estimatedValue === null) {
							const result = multiply(qty, price);
							item.estimatedValue = round(result, 2);
						}

						return item;
					});

					// ⭐ 最终赋值
					this.giftOutList = rows;


				})
				.catch(error => {
					this.$message.error('数据加载失败，请稍后重试');
					console.error('获取礼品出库列表失败:', error);
				})
				.finally(() => {
					this.loading = false;
				});
		},
		/** 获取初始表单 */
		getInitForm() {
			return {
				id: null,
				outDate: null,
				outMethod: null,
				outLocation: null,
				getReason: null,
				recipientReceiver: null,
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
				remark: null,
				inId: null,
				remainingQuantity: null
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
				this.remainingQuantity = null;
				// 清空原始值记录
				this.originalUnit = null;
				this.originalUnitPrice = null;
				this.$refs.form?.resetFields();
			});
		},
		// 表单重置
		reset() {
			this.form = this.getInitForm();
			this.itemName = '';
			this.remainingQuantity = null;
			// 清空原始值记录
			this.originalUnit = null;
			this.originalUnitPrice = null;
			this.$refs.form?.resetFields();
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
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
					console.log('[handleUpdate] 加载出库记录 - form.unit:', this.form.unit, 'form.unitPrice:', this.form.unitPrice);

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

					// 获取对应入库记录，设置原始值用于后续校验
					if (this.form.inId) {
						this.getGiftIn(this.form.inId).then(res => {
							const inData = res?.data;
							if (inData) {
								// ⭐ 先记录原始值（从入库记录获取，这是后端认为的"正确值"）
								this.originalUnit = inData.unit;
								this.originalUnitPrice = inData.unitPrice !== null && inData.unitPrice !== undefined 
									? Number(inData.unitPrice) 
									: null;
								console.log('[handleUpdate] 已设置 originalUnit:', this.originalUnit, 'originalUnitPrice:', this.originalUnitPrice);
								
								// ⭐ 编辑模式下：保持 form 中的原有值，不从入库记录覆盖
								// 如果 form 中没有 unit/unitPrice，才从入库记录填充
								if (!this.form.unit && inData.unit) {
									this.$set(this.form, 'unit', inData.unit);
									console.log('[handleUpdate] form.unit 为空，已从入库记录填充:', inData.unit);
								}
								if ((this.form.unitPrice === null || this.form.unitPrice === undefined) && this.originalUnitPrice !== null) {
									this.$set(this.form, 'unitPrice', this.originalUnitPrice);
									console.log('[handleUpdate] form.unitPrice 为空，已从入库记录填充:', this.originalUnitPrice);
								}

								// 如果出库数量存在，自动计算金额
								if (this.form.quantity) {
									this.calculateAmount();
								}

								// 计算剩余数量
								this.calculateRemainingQuantity(this.form.inId);
							}
						}).catch(error => {
							console.error('[handleUpdate] 获取入库记录失败:', error);
							// 即使获取入库记录失败，也不影响编辑流程
							this.originalUnit = null;
							this.originalUnitPrice = null;
						});
					} else {
						// 如果没有入库ID，清空原始值记录
						this.originalUnit = null;
						this.originalUnitPrice = null;
						console.log('[handleUpdate] 无入库ID，已清空 originalUnit 和 originalUnitPrice');
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
						submitData.quantity = parseInt(submitData.quantity, 10);
					}

					// 确保getReason字段存在且不为空
					if (!submitData.getReason || submitData.getReason.trim() === '') {
						this.$message.warning('请输入领用原因');
						return;
					}

					// 验证库存：如果有入库ID，检查剩余数量是否足够
					if (submitData.inId && submitData.quantity) {
						this.validateStock(submitData.inId, submitData.quantity, submitData.id)
							.then(() => {
								this.doSubmit(submitData);
							})
							.catch(error => {
								this.$message.error(error || '批次库存不足或操作失败，请重试！');
							});
					} else if (submitData.inId) {
						this.$message.warning('请输入出库数量');
					} else {
						this.doSubmit(submitData);
					}
				} else {
					this.$message.warning('请完善表单信息');
				}
			});
		},
		/** 验证库存 */
		validateStock(inId, outQuantity, currentOutId) {
			return Promise.all([getGiftIn(inId), listGiftOut({ pageNum: 1, pageSize: 10000 })]).then(([inResponse, outResponse]) => {
				const giftInData = inResponse && inResponse.data;
				if (!giftInData) {
					return Promise.reject('未找到对应的入库记录');
				}
				// 入库数量：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量
				const inQty = Number(giftInData.quantity) || 0;
				const giftOutList = (outResponse && outResponse.rows) || [];
				// 计算已出库数量（排除当前正在编辑的记录）
				let totalOutQty = 0;
				giftOutList.forEach(outItem => {
					const sourceId = outItem && outItem.inId;
					if (sourceId && String(sourceId) === String(inId) && outItem.id !== currentOutId) {
						totalOutQty = add(totalOutQty, Number(outItem.quantity) || 0);
					}
				});
				// 计算剩余数量：当前批次礼品的可用库存数量，计算公式 = 入库数量 - 已出库数量
				const remainingQty = subtract(inQty, totalOutQty);
				const remainingQtyNum = remainingQty > 0 ? remainingQty : 0;
				// 验证剩余数量是否足够
				if (remainingQtyNum < outQuantity) {
					return Promise.reject(`批次库存不足，剩余数量：${round(remainingQtyNum, 2)}，需要出库数量：${outQuantity}`);
				}
			});
		},
		/** 检查库存数量（用于表单验证） */
		checkStockQuantity(inId, outQuantity, currentOutId) {
			return Promise.all([getGiftIn(inId), listGiftOut({ pageNum: 1, pageSize: 10000 })]).then(([inResponse, outResponse]) => {
				const giftInData = inResponse && inResponse.data;
				if (!giftInData) {
					return Promise.reject('未找到对应的入库记录');
				}
				const inQty = Number(giftInData.quantity) || 0;
				const giftOutList = (outResponse && outResponse.rows) || [];
				// 计算已出库数量（排除当前正在编辑的记录）
				let totalOutQty = 0;
				giftOutList.forEach(outItem => {
					const sourceId = outItem && outItem.inId;
					if (sourceId && String(sourceId) === String(inId) && outItem.id !== currentOutId) {
						totalOutQty = add(totalOutQty, Number(outItem.quantity) || 0);
					}
				});
				// 计算剩余数量
				const remainingQty = subtract(inQty, totalOutQty);
				const remainingQtyNum = remainingQty > 0 ? remainingQty : 0;
				// 更新显示的剩余数量
				this.$set(this, 'remainingQuantity', round(remainingQtyNum, 2));
				// 验证剩余数量是否足够
				if (remainingQtyNum < outQuantity) {
					return Promise.reject(`库存不足，剩余：${round(remainingQtyNum, 2)}`);
				}
			});
		},
		/**
		 * 计算剩余数量并更新显示
		 * 剩余数量 (remainingQuantity) = 入库数量 (quantity) - 已出库数量
		 * 剩余数量是当前批次礼品的可用库存数量，是动态变化的值
		 */
		calculateRemainingQuantity(inId) {
			if (!inId) {
				this.$set(this, 'remainingQuantity', null);
				return;
			}

			Promise.all([getGiftIn(inId), listGiftOut({ pageNum: 1, pageSize: 10000 })])
				.then(([inResponse, outResponse]) => {
					const giftInData = inResponse && inResponse.data;
					if (!giftInData) {
						this.$set(this, 'remainingQuantity', null);
						return;
					}

					// 入库数量：存储在 giftIn 表的 quantity 字段，表示一次性入库操作的总量
					const inQty = Number(giftInData.quantity) || 0;
					const giftOutList = (outResponse && outResponse.rows) || [];
					let totalOutQty = 0;
					const currentOutId = this.form && this.form.id;

					giftOutList.forEach(outItem => {
						const sourceId = outItem && outItem.inId;
						if (sourceId && String(sourceId) === String(inId) && outItem.id !== currentOutId) {
							totalOutQty = add(totalOutQty, Number(outItem.quantity) || 0);
						}
					});

					// 计算剩余数量：当前批次礼品的可用库存数量，计算公式 = 入库数量 - 已出库数量
					const remainingQty = subtract(inQty, totalOutQty);
					const remainingQtyNum = remainingQty > 0 ? remainingQty : 0;

					// 同时更新 data 和 form 中的值
					this.$set(this, 'remainingQuantity', round(remainingQtyNum, 2));
					this.$set(this.form, 'remainingQuantity', round(remainingQtyNum, 2));
				})
				.catch(error => {
					console.error('计算剩余数量失败:', error);
					this.$set(this, 'remainingQuantity', null);
					this.$set(this.form, 'remainingQuantity', null);
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
			if (this.form.id != null) {
				// 编辑时：防止后端把 unit/unitPrice 误判为修改，删除这两个字段
				// 因为后端不允许在出库记录上修改单位和单价，这些值应该从入库记录获取
				
				// ⭐ 优化后的 normalize 函数：正确处理字符串和数字
				const normalizeUnit = v => {
					if (v === null || v === undefined || v === '') return null;
					// unit 可能是字符串（如"个"、"箱"），直接转为字符串比较
					return String(v).trim();
				};
				
				const normalizePrice = v => {
					if (v === null || v === undefined || v === '') return null;
					const num = Number(v);
					// 如果是有效数字，保留2位小数
					return isNaN(num) ? null : round(num, 2);
				};
				
				// ⭐ 只有当 originalUnit 和 originalUnitPrice 都已设置时才进行校验
				if (this.originalUnit !== null && this.originalUnit !== undefined && 
					this.originalUnitPrice !== null && this.originalUnitPrice !== undefined) {
					const currentUnit = normalizeUnit(submitData.unit);
					const currentUnitPrice = normalizePrice(submitData.unitPrice);
					const originalUnitNormalized = normalizeUnit(this.originalUnit);
					const originalUnitPriceNormalized = normalizePrice(this.originalUnitPrice);
					
					console.log('[doSubmit] 单位比较:', {
						current: currentUnit,
						original: originalUnitNormalized,
						equal: currentUnit === originalUnitNormalized
					});
					console.log('[doSubmit] 单价比较:', {
						current: currentUnitPrice,
						original: originalUnitPriceNormalized,
						equal: currentUnitPrice === originalUnitPriceNormalized
					});
					
					// ⭐ 使用更宽松的比较：允许精度差异（0.01以内视为相等）
					const unitChanged = currentUnit !== originalUnitNormalized;
					const priceChanged = currentUnitPrice !== null && originalUnitPriceNormalized !== null 
						? Math.abs(currentUnitPrice - originalUnitPriceNormalized) > 0.01 
						: currentUnitPrice !== originalUnitPriceNormalized;
					
					if (unitChanged || priceChanged) {
						console.warn('[doSubmit] 检测到单位或单价被修改:', {
							unitChanged,
							priceChanged,
							currentUnit,
							originalUnit: originalUnitNormalized,
							currentUnitPrice,
							originalUnitPrice: originalUnitPriceNormalized
						});
						this.$message.warning('出库无法修改单位和单位价值，请通过礼品入库模块进行修改');
						loadingInstance.close();
						return;
					}
				} else {
					console.log('[doSubmit] 跳过校验 - originalUnit:', this.originalUnit, 'originalUnitPrice:', this.originalUnitPrice);
				}

				// 快速修复方案：直接删除这两个字段，避免任何类型/精度差异导致的误判
				delete submitData.unit;
				delete submitData.unitPrice;

				console.log('[doSubmit] 提交更新数据（已删除 unit 和 unitPrice）:', submitData);
				
				updateGiftOut(submitData)
					.then(response => {
						loadingInstance.close();
						this.$modal.msgSuccess('修改成功');
						this.open = false;
						this.getList();
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
			const message = count > 1 ? `是否确认删除选中的${count}条礼品出库信息？` : `是否确认删除礼品出库信息编号为"${ids}"的数据项？`;

			this.$modal
				.confirm(message)
				.then(() => delGiftOut(ids))
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
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
		/** 数量输入失焦处理 */
		handleQuantityInput() {
			// 当数量输入时，实时计算金额
			if (this.form.quantity && this.form.unitPrice) {
				this.calculateAmount();
			}
		},
		handleQuantityBlur() {
			// 当数量变化时，重新计算剩余数量（用于实时显示）
			if (this.form.inId) {
				this.calculateRemainingQuantity(this.form.inId);
			}
			// 如果数量和单价都有值，计算金额
			if (this.form.quantity && this.form.unitPrice) {
				this.calculateAmount();
			}
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
		/** 根据金额和数量计算单价 */
		calculateAmountFromValue() {
			const quantity = Number(this.form.quantity) || 0;
			const estimatedValue = Number(this.form.estimatedValue) || 0;
			if (quantity > 0 && estimatedValue > 0) {
				const result = divide(estimatedValue, quantity);
				this.$set(this.form, 'unitPrice', round(result, 2));
			} else if (!estimatedValue) {
				this.$set(this.form, 'unitPrice', null);
			}
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
		/** 获取初始退回表单 */
		getInitReturnForm() {
			return {
				id: null,
				originalQuantity: null,
				quantity: null,
				totalAfterReturn: null,
				inLocation: null,
				remark: null,
				handler: null
			};
		},
		/** 计算退回后总数 */
		// calculateReturnTotal() {
		// 	const originalQty = Number(this.returnForm.originalQuantity) || 0;
		// 	const returnQty = Number(this.returnForm.quantity) || 0;
		// 	// 退回后总数 = 原始数量 + 退回数量（因为退回是增加库存）
		// 	const totalAfterReturn = add(originalQty, returnQty);
		// 	this.$set(this.returnForm, 'totalAfterReturn', round(totalAfterReturn, 2));
		// },
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
					const submitData = {
						id: Number(this.returnForm.id),
						quantity: String(this.returnForm.quantity || ''),
						inLocation: String(this.returnForm.inLocation || ''),
						remark: String(this.returnForm.remark || ''),
						handler: String(this.returnForm.handler || '')
					};

					// 验证必填字段
					if (!submitData.id || isNaN(submitData.id)) {
						this.$message.error('无效的出库ID');
						return;
					}
					if (!submitData.quantity || submitData.quantity === '') {
						this.$message.error('请输入退回数量');
						return;
					}
					if (!submitData.inLocation || submitData.inLocation === '') {
						this.$message.error('请输入入库地点');
						return;
					}
					if (!submitData.remark || submitData.remark === '') {
						this.$message.error('请输入备注');
						return;
					}
					if (!submitData.handler || submitData.handler === '') {
						this.$message.error('请输入经办人');
						return;
					}

					console.log('提交退回数据:', submitData);
					returnGiftOut(submitData)
						.then(response => {
							this.$modal.msgSuccess('退回成功');
							this.returnOpen = false;
							this.getList();
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
			const id = Number(row.id);
			if (!id || isNaN(id)) {
				this.$message.error('无效的出库ID');
				return;
			}
			this.viewDetailLoading = true;
			this.viewDetailVisible = true;
			this.viewDetailTitle = '查看再入库详情';
			this.viewDetailData = [];
			getGiftOutReInDetail(id)
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
		/** 查看出库详情 */
		handleViewOutDetail(row) {
			const id = row.id;
			this.viewDetailLoading = true;
			this.viewDetailVisible = true;
			this.viewDetailTitle = '查看出库详情';
			getGiftOutOutDetail(id)
				.then(response => {
					this.viewDetailData = (response && response.data) || (response && response.rows) || [];
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
</style>
