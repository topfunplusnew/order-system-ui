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

			<el-form-item label="存货地点" prop="inventoryLocation">
				<el-input v-model="queryParams.inventoryLocation" placeholder="请输入存货地点" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="对方信息" prop="fromInfo">
				<el-input v-model="queryParams.fromInfo" placeholder="请输入对方信息" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="物品名称" prop="itemName">
				<el-input v-model="queryParams.itemName" placeholder="请输入物品名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="经办人" prop="handler">
				<el-input v-model="queryParams.handler" placeholder="请输入经办人" clearable @keyup.enter.native="handleQuery" />
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

			<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" show-overflow-tooltip />

			<el-table-column v-if="columns[1].visible" label="日期" align="center" prop="inDate" width="160" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ parseTime(scope.row.inDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[2].visible" label="入库方式" align="center" prop="inMethod" width="100" show-overflow-tooltip>
				<template #default="scope">
					<dict-tag :options="dict.type.order_gift_in_method" :value="scope.row.inMethod" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[3].visible" label="存货地点" align="center" prop="inventoryLocation" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[4].visible" label="对方信息" align="center" prop="fromInfo" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[5].visible" label="物品名称" align="center" prop="itemName" width="120" show-overflow-tooltip />

			<el-table-column v-if="columns[6].visible" label="单位" align="center" prop="unit" width="80" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.unit || '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[7].visible" label="数量" align="center" prop="quantity" width="80" show-overflow-tooltip />

			<el-table-column v-if="columns[8].visible" label="单价" align="center" prop="unitPrice" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.unitPrice ? Number(scope.row.unitPrice).toFixed(2) : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[9].visible" label="金额" align="center" prop="estimatedValue" width="100" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.estimatedValue !== null && scope.row.estimatedValue !== undefined ? Number(scope.row.estimatedValue).toFixed(2) : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[10].visible" label="经办人" align="center" prop="handler" width="100" show-overflow-tooltip />

			<el-table-column v-if="columns[11].visible" label="本批次剩余可用数量" align="center" prop="remainingQuantity" width="140" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.remainingQuantity !== null && scope.row.remainingQuantity !== undefined ? scope.row.remainingQuantity : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[12].visible" label="现在剩余金额价值" align="center" prop="remainingValue" width="140" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.remainingValue ? Number(scope.row.remainingValue).toFixed(2) : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column v-if="columns[13].visible" label="付款时间" align="center" prop="payTime" width="160" show-overflow-tooltip>
				<template #default="scope">
					<span>{{ scope.row.payTime ? parseTime(scope.row.payTime, '{y}-{m}-{d} {h}:{i}') : '-' }}</span>
				</template>
			</el-table-column>

			<el-table-column label="备注" align="center" prop="remark" width="120" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150" fixed="right">
				<template #default="scope">
					<el-button v-hasPermi="['system:giftIn:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:giftIn:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
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

					<!-- 对方类型和对方信息同行 -->
					<el-col :span="12">
						<el-form-item label="对方类型">
							<el-select v-model="companyType" placeholder="请选择" style="width: 100%">
								<el-option v-for="item in OTHER_TYPE()" :key="item.value" :label="item.label" :value="item.value" />
							</el-select>
						</el-form-item>
					</el-col>

					<el-col :span="12">
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

					<!-- 物品名称单独一行 -->
					<el-col :span="24">
						<el-form-item label="物品名称" prop="itemName">
							<el-input v-model="form.itemName" placeholder="请输入物品名称" />
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
						<el-form-item label="数量" prop="quantity">
							<el-input v-model="form.quantity" placeholder="请输入数量" @input="calculateAmount" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="单价" prop="unitPrice">
							<el-input v-model="form.unitPrice" placeholder="请输入单价" @input="calculateAmount" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="金额" prop="estimatedValue">
							<el-input v-model="form.estimatedValue" placeholder="自动计算" disabled />
						</el-form-item>
					</el-col>

					<!-- 经办人单独一行 -->
					<el-col :span="24">
						<el-form-item label="经办人" prop="handler">
							<el-input v-model="form.handler" placeholder="请输入经办人" />
						</el-form-item>
					</el-col>

					<!-- 付款时间单独一行 -->
					<el-col :span="24">
						<el-form-item label="付款时间" prop="payTime">
							<el-date-picker v-model="form.payTime" clearable type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择付款时间" style="width: 100%" />
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
	</div>
</template>

<script>
import { listGiftIn, getGiftIn, delGiftIn, addGiftIn, updateGiftIn } from '@/api/system/giftIn';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { listCompany } from '../../../api/system/company';
import { mixin_gift_in_fill } from './giftIn_fill';
import SearchOption from '../../../components/SearchOption.vue';
import { OTHER_TYPE } from '../../../utils/order';
import { multiply, round, divide } from 'mathjs';

export default {
	name: 'GiftIn',
	components: { SearchOption },
	// dicts: ['gift_unit'],
	mixins: [mixin_printHTML, mixin_gift_in_fill],
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
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				inDate: null,
				inMethod: null,
				inventoryLocation: null,
				fromInfo: null,
				itemName: null,
				handler: null
			},
			form: {},
			rules: {
				inDate: [{ required: true, message: '请选择入库日期', trigger: 'blur' }],
				inMethod: [{ required: true, message: '请选择入库方式', trigger: 'blur' }],
				inventoryLocation: [{ required: true, message: '请输入存货地点', trigger: 'blur' }],
				fromInfo: [{ required: true, message: '请输入对方信息', trigger: 'blur' }],
				itemName: [{ required: true, message: '请输入物品名称', trigger: 'blur' }],
				unit: [{ required: true, message: '请选择单位', trigger: 'change' }],
				quantity: [
					{ required: true, message: '请输入数量', trigger: 'blur' },
					{ pattern: /^\d+(\.\d+)?$/, message: '请输入有效数字', trigger: 'blur' }
				],
				unitPrice: [
					{ required: true, message: '请输入单价', trigger: 'blur' },
					{ pattern: /^\d+(\.\d{1,2})?$/, message: '请输入有效的金额格式', trigger: 'blur' }
				],
				handler: [{ required: true, message: '请输入经办人', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: `ID`, visible: true },
				{ key: 1, label: `日期`, visible: true },
				{ key: 2, label: `入库方式`, visible: true },
				{ key: 3, label: `存货地点`, visible: true },
				{ key: 4, label: `对方信息`, visible: true },
				{ key: 5, label: `物品名称`, visible: true },
				{ key: 6, label: `单位`, visible: true },
				{ key: 7, label: `数量`, visible: true },
				{ key: 8, label: `单价`, visible: true },
				{ key: 9, label: `金额`, visible: true },
				{ key: 10, label: `经办人`, visible: true },
				{ key: 11, label: `本批次剩余可用数量`, visible: true },
				{ key: 12, label: `现在剩余金额价值`, visible: true },
				{ key: 13, label: `付款时间`, visible: true }
			],
			companyType: '供应商',
			dialogWidth: window.innerWidth > 768 ? '600px' : '95%'
		};
	},
	created() {
		this.getList();
		this.updateDialogWidth();
		window.addEventListener('resize', this.updateDialogWidth);
		// 调试：检查字典数据是否加载
		this.$nextTick(() => {
			if (this.dict && this.dict.type) {
				console.log('单位字典数据:', this.dict.type.gift_unit);
				if (!this.dict.type.gift_unit || this.dict.type.gift_unit.length === 0) {
					console.warn('单位字典数据为空，请检查：1. 字典类型名称是否为 gift_unit 2. 是否已添加字典数据 3. 数据状态是否为正常');
				}
			}
		});
	},
	beforeDestroy() {
		window.removeEventListener('resize', this.updateDialogWidth);
	},
	methods: {
		OTHER_TYPE() {
			return OTHER_TYPE;
		},
		listCompany,
		parseTime,
		updateDialogWidth() {
			this.dialogWidth = window.innerWidth > 768 ? '600px' : '95%';
		},
		getList() {
			this.loading = true;
			this.queryParams.params = {};
			if (this.daterangeInDate && this.daterangeInDate.length) {
				this.queryParams.params['beginInDate'] = this.daterangeInDate[0] + ' 00:00:00';
				this.queryParams.params['endInDate'] = this.daterangeInDate[1] + ' 23:59:59';
			}
			listGiftIn(this.queryParams)
				.then(response => {
					this.giftInList = (response && response.rows) || [];
					this.total = (response && response.total) || 0;
					// 调试：检查返回数据是否包含unit字段
					if (this.giftInList.length > 0) {
						console.log('返回的数据示例:', this.giftInList[0]);
						console.log('是否包含unit字段:', 'unit' in this.giftInList[0]);
					}
				})
				.catch(error => {
					this.$message.error('数据加载失败，请稍后重试');
					console.error('获取礼品入库列表失败:', error);
				})
				.finally(() => {
					this.loading = false;
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
				quantity: null,
				unitPrice: null,
				estimatedValue: null,
				remainingQuantity: null,
				remainingValue: null,
				handler: null,
				payTime: null,
				remark: null,
				updateTime: null,
				updateBy: null,
				createTime: null,
				createBy: null
			};
		},
		cancel() {
			this.open = false;
			this.handleClose();
		},
		handleClose() {
			this.$nextTick(() => {
				this.form = this.getInitForm();
				this.companyType = '供应商';
				this.$refs.form?.resetFields();
			});
		},
		reset() {
			this.form = this.getInitForm();
			this.companyType = '供应商';
			this.$refs.form?.resetFields();
		},
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
			this.companyType = '供应商';
			this.open = true;
			this.title = '添加购入礼品信息';
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
					// 如果后端返回的是 estimatedValue，需要转换为 unitPrice
					if (this.form.estimatedValue && !this.form.unitPrice && this.form.quantity && this.form.quantity > 0) {
						this.$set(this.form, 'unitPrice', round(divide(this.form.estimatedValue, this.form.quantity), 2));
					}
					// 如果没有金额但有数量和单价，计算金额
					if (!this.form.estimatedValue && this.form.quantity && this.form.unitPrice) {
						this.calculateAmount();
					}
					// 兼容旧数据：如果有 storeLocation，转换为 inventoryLocation
					if (this.form.storeLocation && !this.form.inventoryLocation) {
						this.$set(this.form, 'inventoryLocation', this.form.storeLocation);
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
					if (this.form.id != null) {
						updateGiftIn(this.form)
							.then(response => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								this.$message.error('修改失败，请稍后重试');
								console.error('修改礼品入库信息失败:', error);
							});
					} else {
						addGiftIn(this.form)
							.then(response => {
								this.$modal.msgSuccess('新增成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								this.$message.error('新增失败，请稍后重试');
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
				`礼品入库_${this.parseTime(new Date(), '{y}{m}{d}_{h}{i}{s}')}.xlsx`
			);
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
