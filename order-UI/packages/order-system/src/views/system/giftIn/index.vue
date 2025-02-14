<template>
	<div class="app-container">
		<el-form
			v-show="showSearch"
			ref="queryForm"
			:model="queryParams"
			size="small"
			:inline="true"
			label-width="68px"
		>
			<el-form-item label="入库日期">
				<el-date-picker
					v-model="daterangeInDate"
					style="width: 240px"
					value-format="yyyy-MM-dd HH:mm:ss"
					type="daterange"
					range-separator="-"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
				></el-date-picker>
			</el-form-item>
			<el-form-item label="入库方式" prop="inMethod">
				<el-tooltip
					class="item"
					effect="dark"
					content="入库方式可在字典中进行修改"
					placement="top"
				>
					<el-select
						v-model="queryParams.inMethod"
						placeholder="请选择入库方式"
						clearable
					>
						<el-option
							v-for="dict in dict.type.order_gift_in_method"
							:key="dict.value"
							:label="dict.label"
							:value="dict.value"
						/>
					</el-select>
				</el-tooltip>
			</el-form-item>
			<el-form-item label="经办人" prop="handler">
				<el-input
					v-model="queryParams.handler"
					placeholder="请输入经办人"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>

			<el-form-item label="客户" prop="fromInfo">
				<el-input
					v-model="queryParams.fromInfo"
					placeholder="请输入客户"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="收礼方式" prop="receiveMethod">
				<el-input
					v-model="queryParams.receiveMethod"
					placeholder="请输入收礼方式"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="物品名称" prop="itemName">
				<el-input
					v-model="queryParams.itemName"
					placeholder="请输入物品名称"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>

			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
					>搜索
				</el-button>
				<el-button
					icon="el-icon-refresh"
					size="mini"
					@click="resetQuery"
					>重置
				</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:giftIn:add']"
					type="primary"
					plain
					icon="el-icon-plus"
					size="mini"
					@click="handleAdd"
					>新增
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:giftIn:remove']"
					type="danger"
					plain
					icon="el-icon-delete"
					size="mini"
					:disabled="multiple"
					@click="handleDelete"
					>删除
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:giftIn:export']"
					type="warning"
					plain
					icon="el-icon-download"
					size="mini"
					@click="handleExport"
					>导出
				</el-button>
			</el-col>
			<right-toolbar
				:showSearch.sync="showSearch"
				:columns="columns"
				@queryTable="getList"
			>
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						>
						</el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:adjustOrders:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						>
						</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="giftInList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />

			<el-table-column
				v-if="columns[0].visible"
				label="ID"
				align="center"
				prop="id"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[1].visible"
				label="入库日期"
				align="center"
				prop="inDate"
				width="180"
				show-overflow-tooltip
			>
				<template #default="scope">
					<span>{{
						parseTime(scope.row.inDate, '{y}-{m}-{d} {h}:{i}:{s}')
					}}</span>
				</template>
			</el-table-column>

			<el-table-column
				v-if="columns[2].visible"
				label="入库方式"
				align="center"
				prop="inMethod"
				show-overflow-tooltip
			>
				<template #default="scope">
					<dict-tag
						:options="dict.type.order_gift_in_method"
						:value="scope.row.inMethod"
					/>
				</template>
			</el-table-column>

			<el-table-column
				v-if="columns[3].visible"
				label="对方信息"
				align="center"
				prop="fromInfo"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[4].visible"
				label="物品名称"
				align="center"
				prop="itemName"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[5].visible"
				label="数量"
				align="center"
				prop="quantity"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[6].visible"
				label="预估价值/购买金额"
				align="center"
				prop="estimatedValue"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[7].visible"
				label="经办人"
				align="center"
				prop="handler"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[8].visible"
				label="收礼方式"
				align="center"
				prop="receiveMethod"
				show-overflow-tooltip
			/>

			<el-table-column
				label="备注"
				align="center"
				prop="remark"
				show-overflow-tooltip
			/>

			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
				show-overflow-tooltip
				width="180"
				fixed="right"
			>
				<template #default="scope">
					<el-button
						v-hasPermi="['system:giftIn:edit']"
						size="mini"
						type="text"
						icon="el-icon-edit"
						@click="handleUpdate(scope.row)"
						>修改
					</el-button>
					<el-button
						v-hasPermi="['system:giftIn:remove']"
						size="mini"
						type="text"
						icon="el-icon-delete"
						@click="handleDelete(scope.row)"
						>删除
					</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>

		<!-- 添加或修改购入礼品信息对话框 -->
		<el-dialog
			:title="title"
			:visible.sync="open"
			width="500px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="入库日期" prop="inDate">
					<el-date-picker
						v-model="form.inDate"
						clearable
						type="datetime"
						value-format="yyyy-MM-dd HH:mm:ss"
						placeholder="请选择入库日期"
					>
					</el-date-picker>
				</el-form-item>
				<el-form-item label="入库方式" prop="inMethod">
					<el-select
						v-model="form.inMethod"
						placeholder="请选择入库方式"
					>
						<el-option
							v-for="dict in dict.type.order_gift_in_method"
							:key="dict.value"
							:label="dict.label"
							:value="dict.value"
						></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="对方类型">
					<el-select v-model="companyType" placeholder="请选择">
						<el-option
							v-for="item in OTHER_TYPE()"
							:key="item.value"
							:label="item.label"
							:value="item.value"
						>
						</el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="对方信息" prop="fromInfo">
					<el-row>
						<el-col :span="10">
							<el-input
								v-model="form.fromInfo"
								placeholder="请输入对方信息"
							/>
						</el-col>
						<el-col :span="2">
							<SearchOption
								:limit-info="{ companyType: companyType }"
								:get-data="listCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="companyName"
								@update:queryName="handleUpdateCompanyName"
								@commitBack="handleCommitBackCompany"
							>
								<template #table-columns>
									<el-table-column
										:label="companyType"
										align="center"
										prop="companyName"
									/>
									<el-table-column
										label="老板姓名"
										align="center"
										prop="leader"
									/>
									<el-table-column
										label="老板电话"
										align="center"
										prop="leaderTel"
									/>
									<el-table-column
										label="区域"
										align="center"
										prop="region"
									/>

									<el-table-column
										label="销售经理"
										align="center"
										prop="salesManager"
									/>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="物品名称" prop="itemName">
					<el-input
						v-model="form.itemName"
						placeholder="请输入物品名称"
					/>
				</el-form-item>
				<el-form-item label="数量" prop="quantity">
					<el-input
						v-model="form.quantity"
						placeholder="请输入数量"
					/>
				</el-form-item>
				<el-form-item label="预估价值/购买金额" prop="estimatedValue">
					<el-input
						v-model="form.estimatedValue"
						placeholder="请输入预估价值/购买金额"
					/>
				</el-form-item>
				<el-form-item label="经办人" prop="handler">
					<el-input
						v-model="form.handler"
						placeholder="请输入经办人"
					/>
				</el-form-item>
				<el-form-item label="收礼方式" prop="receiveMethod">
					<el-input
						v-model="form.receiveMethod"
						placeholder="请输入收礼方式"
					/>
				</el-form-item>
				<el-form-item label="备注" prop="remark">
					<el-input
						v-model="form.remark"
						type="textarea"
						placeholder="请输入内容"
					/>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import {
	listGiftIn,
	getGiftIn,
	delGiftIn,
	addGiftIn,
	updateGiftIn
} from '@/api/system/giftIn';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { listCompany } from '../../../api/system/company';
import { mixin_gift_in_fill } from './giftIn_fill';
import SearchOption from '../../../components/SearchOption.vue';
import { OTHER_TYPE } from '../../../utils/order';

export default {
	name: 'GiftIn',
	components: { SearchOption },
	dicts: ['order_gift_in_method'],
	mixins: [mixin_printHTML, mixin_gift_in_fill],
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
			// 购入礼品信息表格数据
			giftInList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 备注时间范围
			daterangeInDate: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				inDate: null,
				inMethod: null,
				fromInfo: null,
				itemName: null,
				quantity: null,
				estimatedValue: null,
				handler: null,
				receiveMethod: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				inDate: [
					{
						required: true,
						message: '请选择入库日期',
						trigger: 'blur'
					}
				],
				inMethod: [
					{
						required: true,
						message: '请选择入库方式',
						trigger: 'blur'
					}
				],
				fromInfo: [
					{
						required: true,
						message: '请输入对方信息',
						trigger: 'blur'
					}
				],
				itemName: [
					{
						required: true,
						message: '请输入物品名称',
						trigger: 'blur'
					}
				],
				quantity: [
					{ required: true, message: '请输入数量', trigger: 'blur' }
				],
				estimatedValue: [
					{
						required: true,
						message: '请输入预估价值/购买金额',
						trigger: 'blur'
					}
				],
				handler: [
					{ required: true, message: '请输入经办人', trigger: 'blur' }
				],
				receiveMethod: [
					{
						required: true,
						message: '请输入收礼方式',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `ID`, visible: true },
				{ key: 1, label: `入库日期`, visible: true },
				{ key: 2, label: `入库方式`, visible: true },
				{ key: 3, label: `对方信息`, visible: true },
				{ key: 4, label: `物品名称`, visible: true },
				{ key: 5, label: `数量`, visible: true },
				{ key: 6, label: `预估价值/购买金额`, visible: true },
				{ key: 7, label: `经办人`, visible: true },
				{ key: 8, label: `收礼方式`, visible: true }
			],
			companyType: ''
		};
	},
	created() {
		this.getList();
	},
	methods: {
		OTHER_TYPE() {
			return OTHER_TYPE;
		},
		listCompany,
		/** 查询购入礼品信息列表 */
		getList() {
			this.loading = true;
			this.queryParams.params = {};
			if (this.daterangeInDate != null && this.daterangeInDate != '') {
				this.queryParams.params['beginInDate'] =
					this.daterangeInDate[0];
				this.queryParams.params['endInDate'] = this.daterangeInDate[1];
			}
			listGiftIn(this.queryParams).then(response => {
				this.giftInList = response.rows;
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
				inDate: null,
				inMethod: null,
				fromInfo: null,
				itemName: null,
				quantity: null,
				estimatedValue: null,
				handler: null,
				receiveMethod: null,
				updateTime: null,
				updateBy: null,
				createTime: null,
				createBy: null,
				remark: null
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
			this.daterangeInDate = [];
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
			this.title = '添加购入礼品信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getGiftIn(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改购入礼品信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateGiftIn(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addGiftIn(this.form).then(response => {
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
				.confirm(
					'是否确认删除购入礼品信息编号为"' + ids + '"的数据项？'
				)
				.then(function () {
					return delGiftIn(ids);
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
				'system/giftIn/export',
				{
					...this.queryParams
				},
				`giftIn_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
