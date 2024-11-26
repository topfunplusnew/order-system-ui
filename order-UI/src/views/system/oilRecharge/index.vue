<template>
	<div class="app-container">
		<el-form
			v-show="showSearch"
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="85px"
		>
			<el-form-item label="加油卡卡号" prop="oilCardNo">
				<el-input
					v-model="queryParams.oilCardNo"
					placeholder="请输入加油卡卡号"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="充值时间" prop="rechargeDate">
				<el-date-picker
					v-model="dateRange"
					style="width: 240px"
					value-format="yyyy-MM-dd HH:mm:ss"
					type="daterange"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
				></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
				>
					搜索
				</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:oilrecharge:add']"
					type="primary"
					plain
					icon="el-icon-plus"
					size="mini"
					@click="handleAdd"
				>
					新增加油卡充值信息
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">
					刷新
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
						></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:oilrecharge:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="oilRechargeList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column label="id" align="center" prop="id" />
			<el-table-column
				v-if="columns[0].visible"
				label="审核状态"
				align="center"
				prop="checkState"
			></el-table-column>
			<!--      <el-table-column label="出差编号UUID" align="center" prop="bTripId"/>-->
			<el-table-column
				v-if="columns[1].visible"
				label="加油卡卡号"
				align="center"
				prop="oilCardNo"
			/>
			<el-table-column
				v-if="columns[2].visible"
				label="充值类型"
				align="center"
				prop="rechargeType"
			/>
			<el-table-column
				v-if="columns[3].visible"
				label="充值金额"
				align="center"
				prop="rechargeMoney"
			/>
			<el-table-column
				v-if="columns[4].visible"
				label="充值时间"
				align="center"
				prop="rechargeDate"
			/>
			<el-table-column
				v-if="columns[5].visible"
				label="银行开户名"
				align="center"
				prop="acountsName"
			/>
			<el-table-column
				v-if="columns[6].visible"
				label="银行账号"
				align="center"
				prop="bankNo"
			/>
			<el-table-column
				v-if="columns[7].visible"
				label="充值人员姓名"
				align="center"
				prop="rechargeName"
			/>
			<el-table-column
				v-if="columns[8].visible"
				label="充值附件"
				align="center"
				prop="attachment"
			>
				<template #default="scope">
					<CheckFiles
						:path="scope.row.attachment"
						@needToUpdate="
							value =>
								handleUpdateFilePath(
									value,
									scope.row,
									'attachment',
									getOilRecharge(),
									updateOilRecharge()
								)
						"
					/>
				</template>
			</el-table-column>
			<el-table-column
				v-if="columns[9].visible"
				label="备注"
				align="center"
				prop="comments"
			/>
			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
				fixed="right"
				width="150px"
			>
				<template slot-scope="scope">
					<el-button
						v-if="scope.row.checkState === '未申请'"
						size="mini"
						type="text"
						@click="addPaymentApply(scope.row)"
					>
						申请付款
					</el-button>
					<el-button
						v-if="scope.row.checkState === '已支付'"
						size="mini"
						type="success"
						disabled
					>
						已支付
					</el-button>
					<el-button
						v-if="scope.row.checkState === '未支付'"
						size="mini"
						type="danger"
						disabled
					>
						未支付
					</el-button>
					<el-button
						v-hasPermi="['system:oilrecharge:edit']"
						size="mini"
						type="primary"
						@click="handleUpdate(scope.row)"
					>
						修改
					</el-button>
					<el-button
						v-hasPermi="['system:oilrecharge:remove']"
						size="mini"
						type="danger"
						@click="handleDelete(scope.row)"
					>
						删除
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

		<!-- 添加或修改加油卡充值信息对话框 -->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			:title="title"
			:visible.sync="open"
			width="500px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="加油卡卡号" prop="oilCardNo">
					<el-row>
						<el-col :span="10">
							<el-input
								v-model="form.oilCardNo"
								placeholder="请输入加油卡卡号"
							/>
						</el-col>
						<el-col :span="4">
							<SearchOption
								:get-data="listOilCard"
								query-info="oilCardNo"
								:query-name="queryOilCard"
								query-label="油卡账号查询"
								:limit-info="{ oilType: '主卡' }"
								@commitBack="handleCommitBackOilCard"
								@update:queryName="handleCommitBackQueryOilCard"
							>
								<template #table-columns>
									<el-table-column
										label="加油卡卡号"
										align="center"
										prop="oilCardNo"
									/>
									<el-table-column
										label="当前金额"
										align="center"
										prop="moneyAmount"
									/>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="充值金额" prop="rechargeMoney">
					<el-input v-model="form.rechargeMoney" placeholder="请输入充值金额" />
				</el-form-item>
				<el-form-item label="充值人员姓名" prop="rechargeName">
					<el-input
						v-model="form.rechargeName"
						disabled
						placeholder="请输入充值人员姓名"
					/>
				</el-form-item>
				<el-form-item label="充值附件" prop="attachment">
					<file-upload ref="uploadFile" @input="handleUpload" />
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

		<!--    加油卡付款申请-->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			title="加油卡付款申请"
			:visible.sync="paymentApplyVisible"
			width="500px"
		>
			<OilApply
				:need-money="needMoney"
				:table-name="TableName.OIL_RECHARGE"
				:t-i-d="tid"
				@changeOpen="resetApplyPaymentInfo"
			/>
		</el-dialog>
	</div>
</template>

<script>
import {
	addOilRecharge,
	delOilRecharge,
	listOilRecharge
} from '@/api/system/oilRecharge';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { TableName } from '@/api/tool/enums';
import SearchOption from '@/components/SearchOption.vue';
import { listOilCard } from '@/api/system/oilCard';
import { listBankAccount } from '@/api/system/bankAccount';
import { mapGetters } from 'vuex';
import { addDateRange } from '@/utils/ruoyi';
import { parseTime } from '../../../utils/ruoyi';
import { excludeParams } from '@/api/tool/exclude';
import OilApply from '@/views/dashboard/components/oilCard/OilApply.vue';
import CheckFiles from '@/components/CheckFiles.vue';
import {
	getOilRecharge,
	updateOilRecharge
} from '../../../api/system/oilRecharge';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import { mixin_oil_recharge_fill } from './oilRechargeFill';

export default {
	name: 'OilRecharge',
	computed: {
		TableName() {
			return TableName;
		},
		...mapGetters(['trueName'])
	},
	components: { CheckFiles, OilApply, SearchOption, ApplyPayment },
	mixins: [mixin_printHTML, mixin_oil_recharge_fill, mixin_checkfile],
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
			// 加油卡充值信息表格数据
			oilRechargeList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			dateRange: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				bTripId: null,
				oilCardNo: null,
				rechargeType: null,
				rechargeMoney: null,
				rechargeDate: null,
				acountsName: null,
				bankNo: null,
				rechargeName: null,
				attachment: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {
				rechargeName: '',
				rechargeDate: parseTime(new Date()),
				rechargeType: '银行卡'
			},
			// 表单校验
			rules: {},
			columns: [
				{ key: 0, label: `审核状态`, visible: true },
				{ key: 1, label: `加油卡卡号`, visible: true },
				{ key: 2, label: `充值类型`, visible: true },
				{ key: 3, label: `充值金额`, visible: true },
				{ key: 4, label: `充值时间`, visible: true },
				{ key: 5, label: `银行开户名`, visible: true },
				{ key: 6, label: `银行账号`, visible: true },
				{ key: 7, label: `充值人员姓名`, visible: true },
				{ key: 8, label: `充值附件`, visible: true },
				{ key: 9, label: `备注`, visible: true }
			],
			tid: '',
			paymentApplyVisible: false,
			needMoney: 0,
			needInfo: {}
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('oilrecharge-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (
			localStorage.getItem('oilrecharge-columns') === 'null' ||
			!localStorage.getItem('oilrecharge-columns')
		) {
			// 设置localStorage
			localStorage.setItem('oilrecharge-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('oilrecharge-columns'));
		}
		this.resetQuery();
	},
	methods: {
		updateOilRecharge() {
			return updateOilRecharge;
		},
		getOilRecharge() {
			return getOilRecharge;
		},
		listBankAccount,
		listOilCard,
		// 加油卡付款申请
		addPaymentApply(row) {
			console.log(row);
			this.tid = row.id;
			this.needMoney = row.rechargeMoney;
			this.needInfo = row;
			this.paymentApplyVisible = true;
		},
		handleUpload(val) {
			this.form.attachment = val;
		},
		// 重置传递给子组件的状态
		resetApplyPaymentInfo() {
			// 把needMoney重置一下 避免子组件无法监听
			this.needMoney = 0;
			// 先关闭弹窗
			this.paymentApplyVisible = false;
			this.getList();
		},
		/** 查询加油卡充值信息列表 */
		getList() {
			this.loading = true;
			listOilRecharge(addDateRange(this.queryParams, this.dateRange)).then(
				response => {
					this.oilRechargeList = response.rows;
					this.total = response.total;
					this.loading = false;
				}
			);
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.$refs.uploadFile.clearFileList();
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				bTripId: null,
				oilCardNo: null,
				rechargeType: '银行卡',
				rechargeMoney: null,
				rechargeDate: parseTime(new Date()),
				acountsName: null,
				bankNo: null,
				rechargeName: null,
				attachment: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
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
			// 填充充值人员姓名
			this.form.rechargeName = this.trueName;
			this.title = '添加加油卡充值信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getOilRecharge(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改加油卡充值信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateOilRecharge(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.$refs.uploadFile.clearFileList();
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addOilRecharge(this.form).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.$refs.uploadFile.clearFileList();
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
				.confirm('是否确认删除加油卡充值信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delOilRecharge(ids);
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
				'system/oilRecharge/export',
				{
					...this.queryParams
				},
				`oilRecharge_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
