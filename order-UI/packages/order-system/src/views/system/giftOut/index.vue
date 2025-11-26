<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="120px">
			<el-form-item label="出库日期">
				<el-date-picker v-model="daterangeOutDate" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="datetimerange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item label="经办人" prop="handler">
				<el-input v-model="queryParams.handler" placeholder="请输入经办人" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="客户" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入客户" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<!-- 在查询表单中修改礼品来源的显示 -->
			<el-form-item label="礼品来源" prop="giftSource">
				<el-row :gutter="10">
					<el-col :span="20">
						<el-input v-model="giftSourceName" placeholder="请选择礼品来源" readonly />
					</el-col>
					<el-col :span="4">
						<SearchOption :limit-info="{}" :get-data="listGiftIn" query-info="itemName" query-label="物品名称" :query-name="giftSourceName" @update:queryName="handleUpdateGiftSourceName" @commitBack="handleCommitBackGiftSource">
							<template #table-columns>
								<el-table-column label="对方信息" align="center" prop="fromInfo" />
								<el-table-column label="物品名称" align="center" prop="itemName" />
								<el-table-column label="数量" align="center" prop="quantity" />
								<el-table-column label="预估价值" align="center" prop="estimatedValue" />
								<el-table-column label="入库日期" align="center" prop="inDate">
									<template #default="scope">
										<span>{{ parseTime(scope.row.inDate, '{y}-{m}-{d}') }}</span>
									</template>
								</el-table-column>
							</template>
						</SearchOption>
					</el-col>
				</el-row>
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
			<el-form-item label="物品名称" prop="itemName">
				<el-input v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter.native="handleQuery" />
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

			<el-table-column v-if="columns[1].visible" label="出库日期" align="center" prop="outDate" width="160" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ parseTime(scope.row.outDate, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[2].visible" label="礼品来源" align="center" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.giftSourceName || scope.row.itemName || '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[3].visible" label="出库方式" align="center" prop="outMethod" width="100" show-overflow-tooltip>
				<template #default="scope">
					<dict-tag :options="dict.type.order_gift_out_method" :value="scope.row.outMethod" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[4].visible" label="公司名称" align="center" prop="companyName" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[5].visible" label="收礼人员" align="center" prop="recipientReceiver" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[6].visible" label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[7].visible" label="数量" align="center" prop="quantity" width="80" show-overflow-tooltip />

			<el-table-column v-if="columns[8].visible" label="预估价值" align="center" prop="estimatedValue" width="100" show-overflow-tooltip />

			<el-table-column v-if="columns[9].visible" label="经办人" align="center" prop="handler" width="100" show-overflow-tooltip />

			<el-table-column v-if="columns[10].visible" label="备注" align="center" prop="remark" width="120" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150" fixed="right">
				<template #default="scope">
					<el-button v-hasPermi="['system:giftOut:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:giftOut:remove']" size="mini" t ype="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
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
							<el-date-picker v-model="form.outDate" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择出库日期" style="width: 100%"></el-date-picker>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<!-- 在表单中修改礼品来源的显示 -->
						<el-form-item label="礼品来源" prop="giftSource">
							<el-row :gutter="10">
								<el-col :span="20">
									<el-input v-model="giftSourceName" placeholder="请选择礼品来源" readonly />
								</el-col>
								<el-col :span="4">
									<SearchOption :limit-info="{}" :get-data="listGiftIn" query-info="itemName" query-label="物品名称" :query-name="giftSourceName" @update:queryName="handleUpdateGiftSourceName" @commitBack="handleCommitBackGiftSource">
										<template #table-columns>
											<el-table-column label="入库ID" align="center" prop="id" />
											<el-table-column label="对方信息" align="center" prop="fromInfo" />
											<el-table-column label="物品名称" align="center" prop="itemName" />
											<el-table-column label="数量" align="center" prop="quantity" />
											<el-table-column label="预估价值" align="center" prop="estimatedValue" />
											<el-table-column label="备注" align="center" prop="remark" />
											<el-table-column label="入库日期" align="center" prop="inDate">
												<template #default="scope">
													<span>{{ parseTime(scope.row.inDate, '{y}-{m}-{d}') }}</span>
												</template>
											</el-table-column>
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="出库方式" prop="outMethod">
							<el-select v-model="form.outMethod" placeholder="请选择出库方式" style="width: 100%">
								<el-option v-for="dict in dict.type.order_gift_out_method" :key="dict.value" :label="dict.label" :value="dict.value"></el-option>
							</el-select>
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="对方类型">
							<el-select v-model="companyType" placeholder="请选择" style="width: 100%">
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
								<el-col :span="4">
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

					<el-col :span="24">
						<el-form-item label="收礼人员" prop="recipientReceiver">
							<el-input v-model="form.recipientReceiver" placeholder="请输入收礼人员" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
						<el-form-item label="物品名称" prop="itemName">
							<el-input v-model="form.itemName" placeholder="请输入物品名称" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="数量" prop="quantity">
							<el-input v-model="form.quantity" placeholder="请输入数量" />
						</el-form-item>
					</el-col>

					<el-col :span="12">
						<el-form-item label="预估价值" prop="estimatedValue">
							<el-input v-model="form.estimatedValue" placeholder="请输入预估价值" />
						</el-form-item>
					</el-col>

					<el-col :span="24">
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
import { listGiftIn, getGiftIn } from '@/api/system/giftIn';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import SearchOption from '../../../components/SearchOption.vue';
import { listCompany } from '../../../api/system/company';
import { mixin_gift_out_fill } from './giftOut_fill';
import { OTHER_TYPE } from '../../../utils/order';

export default {
	name: 'GiftOut',
	components: { SearchOption },
	dicts: ['order_gift_out_method'],
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
				giftSource: null,
				outMethod: null,
				companyName: null,
				recipientReceiver: null,
				itemName: null,
				quantity: null,
				estimatedValue: null,
				handler: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				outDate: [{ required: true, message: '请选择出库日期', trigger: 'blur' }],
				giftSource: [{ required: true, message: '请选择礼品来源', trigger: 'change' }],
				outMethod: [{ required: true, message: '请选择出库方式', trigger: 'blur' }],
				companyName: [{ required: true, message: '请输入公司名称', trigger: 'blur' }],
				recipientReceiver: [{ required: true, message: '请输入收礼人员', trigger: 'blur' }],
				itemName: [{ required: true, message: '请输入物品名称', trigger: 'blur' }],
				quantity: [
					{ required: true, message: '请输入数量', trigger: 'blur' },
					{ pattern: /^\d+(\.\d+)?$/, message: '请输入有效数字', trigger: 'blur' }
				],
				estimatedValue: [
					{ required: true, message: '请输入预估价值', trigger: 'blur' },
					{ pattern: /^\d+(\.\d{1,2})?$/, message: '请输入有效的金额格式', trigger: 'blur' }
				],
				handler: [{ required: true, message: '请输入经办人', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: `ID`, visible: true },
				{ key: 1, label: `出库日期`, visible: true },
				{ key: 2, label: `礼品来源`, visible: true },
				{ key: 3, label: `出库方式`, visible: true },
				{ key: 4, label: `公司名称`, visible: true },
				{ key: 5, label: `收礼人员`, visible: true },
				{ key: 6, label: `物品名称`, visible: true },
				{ key: 7, label: `数量`, visible: true },
				{ key: 8, label: `预估价值`, visible: true },
				{ key: 9, label: `经办人`, visible: true },
				{ key: 10, label: `备注`, visible: true }
			],
			companyType: '供应商',
			dialogWidth: window.innerWidth > 768 ? '600px' : '95%',
			giftSourceName: '',
			isUpdatingGiftSource: false
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
		parseTime,
		updateDialogWidth() {
			this.dialogWidth = window.innerWidth > 768 ? '600px' : '95%';
		},
		/** 查询礼品出库信息列表 */
		getList() {
			this.loading = true;
			this.queryParams.params = {};
			if (this.daterangeOutDate && this.daterangeOutDate.length) {
				this.queryParams.params['beginOutDate'] = this.daterangeOutDate[0];
				this.queryParams.params['endOutDate'] = this.daterangeOutDate[1];
			}
			listGiftOut(this.queryParams)
				.then(response => {
					this.giftOutList = response.rows || [];
					this.total = response.total;
					// 如果数据中没有itemName，根据giftSource获取入库信息
					const needFetchItems = this.giftOutList.filter(item => item.giftSource && !item.itemName);
					if (needFetchItems.length > 0) {
						const fetchPromises = needFetchItems.map(item =>
							getGiftIn(String(item.giftSource))
								.then(giftInResponse => {
									this.$set(item, 'itemName', giftInResponse.data?.itemName || '');
									this.$set(item, 'giftSourceName', giftInResponse.data?.itemName || '');
								})
								.catch(() => {
									this.$set(item, 'itemName', '');
									this.$set(item, 'giftSourceName', '');
								})
						);
						Promise.all(fetchPromises);
					}
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
				giftSource: null,
				outMethod: null,
				companyName: null,
				recipientReceiver: null,
				itemName: null,
				quantity: null,
				estimatedValue: null,
				handler: null,
				updateTime: null,
				updateBy: null,
				createTime: null,
				createBy: null,
				remark: null
			};
			this.companyType = '供应商';
			this.giftSourceName = '';
			this.isUpdatingGiftSource = false;
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
			this.giftSourceName = '';
			this.queryParams.giftSource = null;
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
			const id = row.id || (this.ids.length === 1 ? this.ids[0] : null);

			// 添加检查确保有且仅有一个ID
			if (!id) {
				this.$message.warning('请选择一条记录进行修改');
				return;
			}

			getGiftOut(id)
				.then(response => {
					this.form = response.data;
					// 确保 giftSource 为字符串类型
					if (this.form.giftSource != null) {
						this.form.giftSource = String(this.form.giftSource);
					}
					// 先打开对话框，确保DOM已渲染
					this.open = true;
					this.title = '修改礼品出库信息';
					// 使用 $nextTick 确保对话框已完全渲染后再设置值
					this.$nextTick(() => {
						// 先设置物品名称（如果表单中已有）
						this.giftSourceName = this.form.itemName || '';
						// 如果 giftSource 是入库记录ID，且表单中没有itemName，需要获取对应的入库记录信息
						if (this.form.giftSource && !this.form.itemName) {
							getGiftIn(String(this.form.giftSource))
								.then(giftInResponse => {
									// 显示入库记录中的物品名称
									if (giftInResponse.data?.itemName) {
										this.giftSourceName = giftInResponse.data.itemName;
									}
									// 清除验证错误
									this.$refs.form?.clearValidate('giftSource');
								})
								.catch(error => {
									console.error('获取入库信息失败:', error);
									// 清除验证错误
									this.$refs.form?.clearValidate('giftSource');
								});
						} else {
							// 清除验证错误
							this.$refs.form?.clearValidate('giftSource');
						}
					});
				})
				.catch(error => {
					this.$message.error('获取礼品出库信息失败，请稍后重试');
					console.error('获取礼品出库信息失败:', error);
				});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 确保 giftSource 字段有值
					if (!this.form.giftSource) {
						this.$message.warning('请选择礼品来源');
						return;
					}
					if (this.form.id != null) {
						updateGiftOut(this.form)
							.then(response => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								const errorMsg = error?.response?.data?.msg || error?.response?.data?.message || error?.message || '修改失败，请稍后重试';
								this.$message.error(errorMsg);
								console.error('修改礼品出库信息失败:', error);
								console.error('错误详情:', error?.response?.data);
							});
					} else {
						addGiftOut(this.form)
							.then(response => {
								this.$modal.msgSuccess('新增成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								const errorMsg = error?.response?.data?.msg || error?.response?.data?.message || error?.message || '新增失败，请稍后重试';
								this.$message.error(errorMsg);
								console.error('新增礼品出库信息失败:', error);
								console.error('错误详情:', error?.response?.data);
							});
					}
				} else {
					this.$message.warning('请完善表单信息');
				}
			});
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
		// 更新礼品来源名称
		handleUpdateGiftSourceName(name) {
			// 如果正在通过回调更新，则忽略 SearchOption 的清空操作
			if (!this.isUpdatingGiftSource) {
				this.giftSourceName = name;
			}
		},
		// 选中礼品来源后的回调处理
		handleCommitBackGiftSource(row) {
			if (row && row.id) {
				const itemName = row.itemName || '';
				// 设置标志，防止 handleUpdateGiftSourceName 覆盖值
				this.isUpdatingGiftSource = true;
				// 根据当前上下文更新对应的数据
				if (this.open && this.$refs.form) {
					// 编辑表单上下文：更新表单数据
					this.form.giftSource = String(row.id);
					this.form.itemName = itemName;
					this.form.estimatedValue = row.estimatedValue;
					this.form.quantity = row.quantity;
					// 使用 $nextTick 确保 SearchOption 组件完成清理后再更新显示值
					this.$nextTick(() => {
						this.giftSourceName = itemName;
						this.isUpdatingGiftSource = false;
						// 触发表单验证
						this.$refs.form?.validateField('giftSource');
					});
				} else {
					// 查询表单上下文：更新查询参数
					this.queryParams.giftSource = String(row.id);
					// 使用 $nextTick 确保 SearchOption 组件完成清理后再更新显示值
					this.$nextTick(() => {
						this.giftSourceName = itemName;
						this.isUpdatingGiftSource = false;
					});
				}
			} else {
				this.isUpdatingGiftSource = false;
			}
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
