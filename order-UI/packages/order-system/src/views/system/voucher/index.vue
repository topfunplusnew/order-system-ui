<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<!-- 后端不支持 已删除 -->
			<!-- <el-form-item label="凭证编号" prop="voucherNo">
				<el-input
					v-model="queryParams.voucherNo"
					placeholder="请输入凭证编号"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item> -->
			<el-form-item label="分类" prop="voucherNo">
				<el-select v-model="queryParams.voucherNoPrefix" placeholder="单据类型" clearable>
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row>
			<el-col>
				<el-button size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
		</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:freight:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="voucherList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			border
		>
			<!-- 凭证编号 -->
			<el-table-column v-if="columns[0].visible" label="凭证编号" align="center" prop="voucherNo" width="300" />

			<!-- 制单日期 -->
			<el-table-column v-if="columns[1].visible" label="制单日期" align="center" prop="vdate" show-overflow-tooltip />
			<!-- 制单人 -->
			<el-table-column v-if="columns[2].visible" label="制单人" align="center" prop="makeUser" show-overflow-tooltip />

			<!-- 合计 -->
			<el-table-column v-if="columns[3].visible" label="合计" align="center" prop="amount" show-overflow-tooltip />

			<!-- 借方 -->
			<el-table-column v-if="columns[4].visible" label="借方" align="center" prop="borrower" show-overflow-tooltip />

			<!-- 贷方 -->
			<el-table-column v-if="columns[5].visible" label="贷方" align="center" prop="lender" show-overflow-tooltip />

			<!-- 凭证类型 -->
			<el-table-column v-if="columns[6].visible" label="凭证类型" align="center" prop="voucherType" show-overflow-tooltip />
			<!-- 备注 -->
			<el-table-column v-if="columns[7].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />

			<!-- 操作 -->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-if="isOrderOrNot(scope.row)" size="mini" type="text" @click="handleGoodsOrder(scope.row)">查看订单信息</el-button>
					<el-button v-hasPermi="['system:voucher:remove']" size="mini" type="text" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!--    查看订单的弹窗-->
		<InfoDialog :visible="goodsOrderVisible" title="订单列表" @close="goodsOrderVisible = false">
			<template #info>
				<OrderInfos :order-info="orderInfo" />
				<OrderDetailInfo :order-detail-info-list="orderInfo.orderDetailList" />
			</template>
		</InfoDialog>
		<!-- 添加或修改凭证对话框 -->
		<!--    <el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :title="title" :visible.sync="open" width="800px" append-to-body>-->
		<!--      <el-form ref="form" :model="form" :rules="rules" label-width="120px">-->
		<!--        <el-form-item label="制单人" prop="makeUser">-->
		<!--          <el-input v-model="form.makeUser" placeholder="请输入制单人"/>-->
		<!--        </el-form-item>-->
		<!--        <el-form-item label="合计" prop="amount">-->
		<!--          <el-input v-model="form.amount" placeholder="请输入合计"/>-->
		<!--        </el-form-item>-->
		<!--        <el-form-item label="借方" prop="borrower">-->
		<!--          <el-input v-model="form.borrower" placeholder="请输入借方"/>-->
		<!--        </el-form-item>-->
		<!--        <el-form-item label="贷方" prop="lender">-->
		<!--          <el-input v-model="form.lender" placeholder="请输入贷方"/>-->
		<!--        </el-form-item>-->
		<!--        <el-form-item label="备注" prop="comments">-->
		<!--          <el-input v-model="form.comments" placeholder="请输入备注"/>-->
		<!--        </el-form-item>-->
		<!--      </el-form>-->
		<!--      <div slot="footer" class="dialog-footer">-->
		<!--        <el-button type="primary" @click="submitForm">确 定</el-button>-->
		<!--        <el-button @click="cancel">取 消</el-button>-->
		<!--      </div>-->
		<!--    </el-dialog>-->
	</div>
</template>

<script>
import { listVoucher, getVoucher, delVoucher } from '@/api/system/voucher';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { mixin_vouncher_options } from '../../dashboard/mixins/vouncher/vouncher_options';
import InfoDialog from '../../../components/InfoDialog.vue';
import OrderInfos from '../../dashboard/components/goodsOrder/OrderInfos.vue';
import OrderDetailInfo from '../../dashboard/components/goodsOrder/OrderDetailInfo.vue';
import { addDateRange } from '../../../utils/ruoyi';

export default {
	name: 'Voucher',
	components: { OrderDetailInfo, OrderInfos, InfoDialog },
	mixins: [mixin_printHTML, mixin_vouncher_options],
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
			// 凭证表格数据
			voucherList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				voucherNoPrefix: '',
				pageNum: 1,
				pageSize: 10,
				voucherNo: null,
				vDate: null,
				makeUser: null,
				amount: null,
				borrower: null,
				lender: null,
				pid: null,
				voucherType: null,
				editUserid: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {},
			columns: [
				{ key: 0, label: `凭证编号`, visible: true },
				{ key: 1, label: `制单日期`, visible: true },
				{ key: 2, label: `制单人`, visible: true },
				{ key: 3, label: `合计`, visible: true },
				{ key: 4, label: `借方`, visible: true },
				{ key: 5, label: `贷方`, visible: true },
				{ key: 6, label: `凭证类型`, visible: true },
				{ key: 7, label: `备注`, visible: true }
			],

			options: [
				{
					value: 'orderId_',
					label: '订单'
				},
				{
					value: 'voiceIn_',
					label: '发票买入'
				},
				{
					value: 'voiceOt_',
					label: '发票卖出'
				},
				{
					value: 'voiceTr_',
					label: '第三方开票'
				}
			]
		};
	},
	created() {
		this.getList();
	},
	methods: {
		// 这个函数用于日后判断是不是与订单相关 例如库存还没有与订单产生联系
		isOrderOrNot(row) {
			// todo 日后如果有新的凭证类型 就放入这个数组中
			const excludeList = ['inventory_'];
			for (const item of excludeList) {
				let voucherNo = row.voucherNo;
				if (!voucherNo) {
					return false;
				}
				if (voucherNo.startsWith(item)) {
					return false;
				}
			}
			return true;
		},
		/** 查询凭证列表 */
		getList() {
			this.loading = true;
			listVoucher(addDateRange(this.queryParams, [], 'voucher', this.queryParams.voucherNoPrefix)).then(response => {
				this.voucherList = response.rows;
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
				voucherNo: null,
				vDate: null,
				makeUser: null,
				amount: null,
				borrower: null,
				lender: null,
				pid: null,
				voucherType: null,
				editUserid: null,
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
			this.title = '添加凭证';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getVoucher(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改凭证';
			});
		},
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除凭证编号为"' + ids + '"的数据项？')
				.then(function () {
					return delVoucher(ids);
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
				'system/voucher/export',
				{
					...this.queryParams
				},
				`voucher_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
