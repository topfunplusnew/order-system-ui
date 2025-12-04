<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="出库日期">
				<el-date-picker v-model="daterangeOutDate" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item label="经办人" prop="handler">
				<el-input v-model="queryParams.handler" placeholder="请输入经办人" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="客户" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入客户" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="出库方式" prop="outMethod">
				<el-tooltip class="item" effect="dark" content="出库方式可在字典中进行修改" placement="top">
					<el-select v-model="queryParams.outMethod" placeholder="请选择出库方式" clearable @keyup.enter.native="handleQuery">
						<el-option v-for="dict in dict.type.order_gift_out_method" :key="dict.value" :label="dict.label" :value="dict.value" />
					</el-select>
				</el-tooltip>
			</el-form-item>
			<el-form-item label="收礼人员" prop="recipientReceiver">
				<el-input v-model="queryParams.recipientReceiver" placeholder="请输入收礼人员" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="礼品来源" prop="itemName">
				<el-input v-model="queryParams.itemName" placeholder="请输入礼品来源" clearable @keyup.enter.native="handleQuery" />
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

			<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" show-overflow-tooltip />

			<el-table-column label="入库ID" align="center" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.inId || scope.row.giftSource || '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[1].visible" label="出库日期" align="center" prop="outDate" width="160" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ parseTime(scope.row.outDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[1].visible" label="日期" align="center" prop="outDate" width="160" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ parseTime(scope.row.outDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[2].visible" label="出库方式" align="center" prop="outMethod" width="100" show-overflow-tooltip>
				<template #default="scope">
					<dict-tag :options="dict.type.order_gift_out_method" :value="scope.row.outMethod" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[3].visible" label="出库地点" align="center" prop="outLocation" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[4].visible" label="领用原因" align="center" prop="useReason" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[5].visible" label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[6].visible" label="规格" align="center" prop="specification" width="100" show-overflow-tooltip />

			<el-table-column v-if="columns[7].visible" label="数量" align="center" prop="quantity" width="80" show-overflow-tooltip />

			<el-table-column v-if="columns[8].visible" label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[9].visible" label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.estimatedValue ? Number(scope.row.estimatedValue).toFixed(2) : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[10].visible" label="领用人" align="center" prop="recipientReceiver" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[11].visible" label="备注" align="center" prop="remark" width="120" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150" fixed="right">
				<template #default="scope">
					<el-button v-hasPermi="['system:giftOut:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:giftOut:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改礼品出库信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" :width="dialogWidth" append-to-body>
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
						<el-form-item label="领用原因" prop="useReason">
							<el-input v-model="form.useReason" placeholder="请输入领用原因" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="对方类型">
							<el-select v-model="companyType" placeholder="请选择" style="width: 100%" @change="handleCompanyTypeChange">
								<el-option v-for="item in OTHER_TYPE()" :key="item.value" :label="item.label" :value="item.value"></el-option>
							</el-select>
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="公司名称" prop="companyName">
							<el-row :gutter="10">
								<el-col :span="20">
									<el-input v-model="form.companyName" placeholder="请输入公司名称" />
								</el-col>
								<el-col :span="2">
									<SearchOption :limit-info="{ companyType: companyType }" :get-data="listCompany" query-info="companyName" query-label="公司名称" :query-name="companyName" @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
										<template #table-columns>
											<el-table-column :label="companyType" align="center" prop="companyName" />
											<el-table-column label="老板姓名" align="center" prop="leader" />
											<el-table-column label="老板电话" align="center" prop="leaderTel" />
											<el-table-column label="区域" align="center" prop="region" />
											<el-table-column label="销售经理" align="center" prop="salesManager" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="收礼人员" prop="recipientReceiver">
							<el-input v-model="form.recipientReceiver" placeholder="请输入收礼人员" />
						</el-form-item>
					</el-col>

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
											<el-table-column label="数量" align="center" prop="quantity" />
											<el-table-column label="预估价值/购买金额" align="center" prop="estimatedValue" />
											<el-table-column label="剩余数量" align="center" prop="remainingQuantity" />
											<el-table-column label="经办人" align="center" prop="handler" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="规格" prop="specification">
							<el-input v-model="form.specification" placeholder="请输入规格" />
						</el-form-item>
					</el-col>

					<!--					<el-col :span="12">-->
					<!--						<el-form-item label="单位" prop="unit">-->
					<!--							<el-select v-model="form.unit" placeholder="请选择单位" style="width: 100%">-->
					<!--								<el-option v-for="dict in dict.type.gift_unit" :key="dict.value" :label="dict.label" :value="dict.value" />-->
					<!--							</el-select>-->
					<!--						</el-form-item>-->
					<!--					</el-col>-->

					<el-col :span="12">
						<el-form-item label="数量" prop="quantity">
							<el-input v-model="form.quantity" placeholder="请输入数量" @blur="handleQuantityBlur" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="剩余数量">
							<el-input :value="remainingQuantity !== null && remainingQuantity !== undefined ? remainingQuantity : '请先选择物品名称'" readonly placeholder="剩余数量" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="单价" prop="unitPrice">
							<el-input v-model="form.unitPrice" placeholder="请输入单价" @input="calculateAmount" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="金额" prop="estimatedValue">
							<el-input v-model="form.estimatedValue" placeholder="自动计算或手动输入" @input="calculateAmountFromValue" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="领用人" prop="recipientReceiver">
							<el-input v-model="form.recipientReceiver" placeholder="请输入领用人" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="经办人" prop="handler">
							<el-input v-model="form.handler" placeholder="请输入经办人" />
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
	</div>
</template>

<script>
import { listGiftOut, getGiftOut, delGiftOut, addGiftOut, updateGiftOut } from '@/api/system/giftOut';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import SearchOption from '../../../components/SearchOption.vue';
import { listCompany } from '../../../api/system/company';
import { listGiftIn, getGiftIn } from '@/api/system/giftIn';
import { mixin_gift_out_fill } from './giftOut_fill';
import { OTHER_TYPE } from '../../../utils/order';
import { subtract, round, add, multiply, divide } from 'mathjs';

export default {
	name: 'GiftOut',
	components: { SearchOption },
	dicts: ['order_gift_out_method', 'gift_unit'],
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
			// 备注时间范围
			daterangeOutDate: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				outDate: null,
				outMethod: null,
				outLocation: null,
				useReason: null,
				companyName: null,
				recipientReceiver: null,
				itemName: null,
				specification: null,
				quantity: null,
				unitPrice: null,
				estimatedValue: null,
				handler: null
			},
			// 表单参数
			form: {
				unit: null
			},
			// 表单校验
			rules: {
				outDate: [{ required: true, message: '请选择出库日期', trigger: 'blur' }],
				outMethod: [{ required: true, message: '请选择出库方式', trigger: 'blur' }],
				companyName: [{ required: true, message: '请输入公司名称', trigger: 'blur' }],
				recipientReceiver: [{ required: true, message: '请输入收礼人员', trigger: 'blur' }],
				itemName: [{ required: true, message: '请输入礼品来源', trigger: 'blur' }],
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
				handler: [{ required: true, message: '请输入经办人', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: `ID`, visible: true },
				{ key: 1, label: `日期`, visible: true },
				{ key: 2, label: `出库方式`, visible: true },
				{ key: 3, label: `出库地点`, visible: true },
				{ key: 4, label: `领用原因`, visible: true },
				{ key: 5, label: `物品名称`, visible: true },
				{ key: 6, label: `规格`, visible: true },
				{ key: 7, label: `数量`, visible: true },
				{ key: 8, label: `单价`, visible: true },
				{ key: 9, label: `金额`, visible: true },
				{ key: 10, label: `领用人`, visible: true },
				{ key: 11, label: `备注`, visible: true }
			],
			companyType: '供应商',
			dialogWidth: window.innerWidth > 768 ? '600px' : '95%',
			// 剩余数量
			remainingQuantity: null
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
		OTHER_TYPE() {
			return OTHER_TYPE;
		},
		listCompany,
		listGiftIn,
		getGiftIn,
		parseTime,
		// 获取入库数据并计算剩余数量
		listGiftInWithRemaining(query) {
			return Promise.all([listGiftIn(query), listGiftOut({ pageNum: 1, pageSize: 10000 })]).then(([inResponse, outResponse]) => {
				const giftInList = (inResponse && inResponse.rows) || [];
				const giftOutList = (outResponse && outResponse.rows) || [];
				// 计算每个入库记录的出库数量
				const outQuantityMap = new Map();
				giftOutList.forEach(outItem => {
					// 兼容giftSource和inId两种字段名，确保正确匹配入库ID
					const sourceId = (outItem && outItem.giftSource) || (outItem && outItem.inId);
					if (sourceId) {
						const inId = String(sourceId);
						const outQty = Number(outItem.quantity) || 0;
						const currentOutQty = outQuantityMap.get(inId) || 0;
						outQuantityMap.set(inId, add(currentOutQty, outQty));
					}
				});
				// 为每个入库记录添加剩余数量
				const result = giftInList.map(item => {
					const inQty = Number(item.quantity) || 0;
					// 使用入库记录的ID来匹配出库记录
					const inId = String(item.id);
					const outQty = outQuantityMap.get(inId) || 0;
					// 计算剩余数量 = 入库数量 - 已出库数量
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
					this.giftOutList = (response && response.rows) || [];
					this.total = (response && response.total) || 0;
					// 调试：检查出库记录是否有关联的入库ID
					console.log('=== 出库记录入库ID检查 ===');
					this.giftOutList.forEach((item, index) => {
						const sourceId = (item && item.giftSource) || (item && item.inId);
						console.log(`出库记录 ${index + 1} (ID: ${item.id}):`, {
							礼品来源: item.itemName,
							giftSource: item.giftSource,
							inId: item.inId,
							入库ID: sourceId || '无'
						});
					});
					console.log('=== 检查完成 ===');
				})
				.catch(error => {
					this.$message.error('数据加载失败，请稍后重试');
					console.error('获取礼品出库列表失败:', error);
				})
				.finally(() => {
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
				outDate: null,
				outMethod: null,
				outLocation: null,
				useReason: null,
				companyName: null,
				recipientReceiver: null,
				itemName: null,
				specification: null,
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
				recipientInfo: null,
				recipientType: null,
				inId: null
			};
			this.companyType = '供应商';
			this.companyName = '';
			this.itemName = '';
			this.remainingQuantity = null;
			this.resetForm('form');
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
			this.open = true;
			this.title = '添加礼品出库信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = (row && row.id) || (Array.isArray(this.ids) && this.ids.length === 1 ? this.ids[0] : null);

			// 添加检查确保有且仅有一个ID
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
					this.form = response.data;
					// 确保日期格式正确（日期选择器需要 yyyy-MM-dd HH:mm:ss 格式）
					if (this.form.outDate) {
						const formattedDate = this.formatDateTime(this.form.outDate);
						this.$set(this.form, 'outDate', formattedDate);
					}
					// 根据recipientType设置companyType，用于下拉框显示
					if (this.form.recipientType) {
						this.companyType = this.form.recipientType;
					}
					// 设置companyName和itemName用于SearchOption组件
					if (this.form.companyName) {
						this.companyName = this.form.companyName;
					}
					if (this.form.itemName) {
						this.itemName = this.form.itemName;
					}
					// 确保 recipientInfo 存在
					if (!this.form.recipientInfo && this.form.companyName) {
						// 如果已有公司名称但没有ID，可能需要重新选择
						this.$message.warning('请重新选择客户信息以确保数据完整性');
					}
					// 如果后端返回了 estimatedValue 但没有 unitPrice，根据数量和金额计算单价
					if (this.form.estimatedValue && !this.form.unitPrice && this.form.quantity && this.form.quantity > 0) {
						const result = divide(this.form.estimatedValue, this.form.quantity);
						this.$set(this.form, 'unitPrice', round(result, 2));
					}
					// 如果没有金额但有数量和单价，计算金额
					if (!this.form.estimatedValue && this.form.quantity && this.form.unitPrice) {
						this.calculateAmount();
					}
					// 计算并显示剩余数量
					if (this.form.inId) {
						this.calculateRemainingQuantity(this.form.inId);
					}
					this.$nextTick(() => {
						this.open = true;
						this.title = '修改礼品出库信息';
					});
				})
				.catch(error => {
					const errorMsg = (error && error.response && error.response.data && error.response.data.msg) || (error && error.response && error.response.data && error.response.data.message) || (error && error.message) || '获取礼品出库信息失败，请稍后重试';
					this.$message.error(errorMsg);
					console.error('获取礼品出库信息失败:', error);
				});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 准备提交数据，确保quantity为整数
					const submitData = { ...this.form };
					if (submitData.quantity) {
						submitData.quantity = parseInt(submitData.quantity, 10);
					}
					// 确保giftSource字段存在（后端可能使用giftSource而不是inId）
					if (submitData.inId && !submitData.giftSource) {
						submitData.giftSource = submitData.inId;
					}
					// 字段映射：确保 recipientType 从 companyType 正确映射
					if (this.companyType && !submitData.recipientType) {
						submitData.recipientType = this.companyType;
					}
					// 验证必填字段
					if (!submitData.recipientInfo) {
						this.$message.warning('请选择客户信息');
						return;
					}
					if (!submitData.itemName || !submitData.inId) {
						this.$message.warning('请选择礼品来源');
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
						// 有入库ID但没有数量，也需要验证
						this.$message.warning('请输入出库数量');
					} else {
						// 没有入库ID的情况，直接提交（可能是手动输入的礼品来源）
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
				const inQty = Number(giftInData.quantity) || 0;
				const giftOutList = (outResponse && outResponse.rows) || [];
				// 计算已出库数量（排除当前正在编辑的记录）
				let totalOutQty = 0;
				giftOutList.forEach(outItem => {
					const sourceId = (outItem && outItem.giftSource) || (outItem && outItem.inId);
					if (sourceId && String(sourceId) === String(inId) && outItem.id !== currentOutId) {
						totalOutQty = add(totalOutQty, Number(outItem.quantity) || 0);
					}
				});
				// 计算剩余数量
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
					const sourceId = (outItem && outItem.giftSource) || (outItem && outItem.inId);
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
		/** 计算剩余数量并更新显示 */
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
					const inQty = Number(giftInData.quantity) || 0;
					const giftOutList = (outResponse && outResponse.rows) || [];
					// 计算已出库数量
					let totalOutQty = 0;
					giftOutList.forEach(outItem => {
						const sourceId = (outItem && outItem.giftSource) || (outItem && outItem.inId);
						if (sourceId && String(sourceId) === String(inId)) {
							totalOutQty = add(totalOutQty, Number(outItem.quantity) || 0);
						}
					});
					// 计算剩余数量
					const remainingQty = subtract(inQty, totalOutQty);
					const remainingQtyNum = remainingQty > 0 ? remainingQty : 0;
					this.$set(this, 'remainingQuantity', round(remainingQtyNum, 2));
				})
				.catch(error => {
					console.error('计算剩余数量失败:', error);
					this.$set(this, 'remainingQuantity', null);
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
				`giftOut_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`
			);
		},
		/** 对方类型变化处理 */
		handleCompanyTypeChange(value) {
			// 当对方类型变化时，同步更新 form.recipientType
			if (value) {
				this.$set(this.form, 'recipientType', value);
			}
		},
		/** 数量输入失焦处理 */
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
