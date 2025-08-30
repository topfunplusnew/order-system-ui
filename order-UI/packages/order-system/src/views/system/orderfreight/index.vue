<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="申请开始日期" prop="applyDate">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期" clearable />
			</el-form-item>
			<el-form-item label="支付日期" prop="payDate">
				<el-date-picker v-model="queryParams.payDate" placeholder="请选择支付日期" style="width: 240px" value-format="yyyy-MM-dd" type="date" clearable />
			</el-form-item>
			<el-form-item label="司机名称/海运公司" prop="driverName">
				<el-input v-model="queryParams.driverName" placeholder="请输入司机名称" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="车牌/柜号" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入车牌/柜号" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="车队名称" prop="fleet">
				<el-input v-model="queryParams.fleet" placeholder="请输入车队名称" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input v-model="queryParams.otherAcountsName" placeholder="请输入车队名称" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="支付状态" prop="paymentState">
				<el-select v-model="queryParams.paymentState" placeholder="请选择" size="mini" clearable>
					<el-option v-for="item in PaymentState()" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<!-- 刷新按钮-->
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="success" size="mini" @click="selectUnPayment(orderFreightList)">勾选未支付</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="success" size="mini" :disabled="freightPaymentOnceDisabled" @click="handleFreightPaymentOnce">一键付运费</el-button>
			</el-col>

			<!--  运费修正-->
			<FillFreight />

			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:orderfreight:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			ref="multipleTable"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="orderFreightList"
			max-height="600px"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" fixed="left" />
			<el-table-column v-if="columns[0].visible" label="付款日期" align="center" prop="payDate" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="运费类型" align="center" prop="freightType" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="车队" align="center" prop="fleet" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="车牌号" align="center" prop="carNo" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="金额" align="center" prop="moneyAmount" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="对方户名" align="center" prop="otherAcountsName" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="对方账号" align="center" prop="otherBankNo" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="对方开户行" align="center" prop="otherBankName" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="运费来源" align="center" prop="source" width="100" show-overflow-tooltip>
				<template slot-scope="scope">
					<el-tag v-if="scope.row.source === FREIGHT_TYPE.GOODS_ORDER">订单</el-tag>
					<el-tag v-if="scope.row.source === FREIGHT_TYPE.INVENTORY">库存</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[9].visible" label="支付状态" align="center" prop="paymentState" width="100" show-overflow-tooltip>
				<template slot-scope="scope">
					<PaymentFlag :business-object="scope.row" size="mini" :custom-status-fn="customFreightStatusFn" :custom-status-styles="freightStatusStyles" />
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="申请人员姓名" align="center" prop="applyUserName" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="申请日期" align="center" prop="applyDate" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="付款人员姓名" align="center" prop="payUserName" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[13].visible" label="我方户名" align="center" prop="selfAcountsName" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[14].visible" label="我方账号" align="center" prop="selfBankNo" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[15].visible" label="我方开户行" align="center" prop="selfBankName" width="100" show-overflow-tooltip />
			<el-table-column v-if="columns[16].visible" label="备注" align="center" prop="comments" width="100" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="150">
				<template slot-scope="scope">
					<CheckOrderInfo :row="scope.row" />
					<el-button v-if="scope.row.isedit" v-hasPermi="['system:orderfreight:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:orderfreight:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="对方户名" prop="otherAcountsName">
					<el-row>
						<el-col :span="10">
							<el-input v-model="form.otherAcountsName" placeholder="请输入对方户名" :disabled="bankInputDisabled" />
						</el-col>
						<el-col v-if="bankInputDisabled === false" :span="3">
							<SearchOption
								:get-data="listBankAccount"
								icon="el-icon-search"
								:limit-info="{}"
								query-label="户名查找"
								query-info="acountsName"
								:query-name="queryCompany"
								@commitBack="handleCommitBack"
								@update:queryName="handleUpdateQueryName"
							>
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName" />
									<el-table-column label="公司类型" align="center" prop="companyType" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="账号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方账号" prop="otherBankNo">
					<el-input v-model="form.otherBankNo" placeholder="请输入对方账号" />
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" />
				</el-form-item>
				<el-form-item label="备注">
					<el-input v-model="form.content" placeholder="请输入备注" />
				</el-form-item>
				<el-form-item label="司机姓名" prop="driverName">
					<el-input v-model="form.driverName" placeholder="请输入司机姓名" />
				</el-form-item>
				<el-form-item label="车牌号/柜号" prop="carNo">
					<el-row>
						<el-col :span="20">
							<el-input v-model="form.carNo" placeholder="请输入车牌号" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ dictType: 'order_cars' }"
								:get-data="listData"
								query-label="车牌搜索"
								:query-name="queryCars"
								query-info="dictLabel"
								@update:queryName="updateQueryCars"
								@commitBack="handleCommitBackCars"
							>
								<template #table-columns>
									<el-table-column label="车牌" prop="dictLabel" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="车队" prop="fleet">
					<el-col :span="20">
						<el-input v-model="form.fleet" placeholder="请输入车队" />
					</el-col>
					<el-col :span="4">
						<SearchOption
							:limit-info="{}"
							:get-data="listFleet"
							query-label="车队名称搜索"
							:query-name="queryFleet"
							query-info="fname"
							@update:queryName="updateQueryFleet"
							@commitBack="handleCommitBackFleet"
						>
							<template #table-columns>
								<el-table-column label="车队名称" prop="fname" />
							</template>
						</SearchOption>
					</el-col>
				</el-form-item>
				<el-form-item label="申请日期" prop="applyDate">
					<el-date-picker v-model="form.applyDate" type="datetime" placeholder="请选择申请日期" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="付款日期" prop="payDate">
					<el-date-picker v-model="form.payDate" type="datetime" placeholder="请选择付款日期" value-format="yyyy-MM-dd HH:mm:ss" />
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

		<!--    一键付运费的弹窗-->
		<InfoDialog :visible="freightOnceVisible" title="一键付运费" @close="freightOnceVisible = false">
			<template #info>
				<!--        输入我方信息-->
				<div class="order-freight-body">
					<!--          运费信息-->
					<div class="order-freight-info">
						<el-collapse v-model="activeNames">
							<el-collapse-item v-for="(item, index) in selectedList" :key="index" :title="'运费信息(' + (index + 1) + ')'" :name="index + ''">
								<el-card class="box-card">
									<div>
										<el-descriptions :title="'运费信息(' + (index + 1) + ')'">
											<el-descriptions-item label="司机">
												{{ item.driverName }}
											</el-descriptions-item>
											<el-descriptions-item label="车牌号">
												{{ item.carNo }}
											</el-descriptions-item>
											<el-descriptions-item label="车队">
												{{ item.fleet }}
											</el-descriptions-item>
											<el-descriptions-item label="运费">
												{{ item.moneyAmount }}
											</el-descriptions-item>
											<el-descriptions-item label="运输类型">
												<el-tag size="mini">
													{{ item.freightType }}
												</el-tag>
											</el-descriptions-item>
											<el-descriptions-item label="开户名">
												{{ item.otherAcountsName }}
											</el-descriptions-item>
											<el-descriptions-item label="开户行">
												{{ item.otherBankName }}
											</el-descriptions-item>
											<el-descriptions-item label="银行账号">
												{{ item.otherBankNo }}
											</el-descriptions-item>
										</el-descriptions>
									</div>
								</el-card>
							</el-collapse-item>
						</el-collapse>
					</div>
					<!--          我方付款信息-->
					<div class="order-freight-self-info">
						<el-form ref="freightPaymentOnceForm" :model="freightSelfOnceInfo" :rules="freightSelfOnceInfoRules" label-width="120px">
							<el-form-item label="支付类型" prop="payType">
								<el-cascader v-model="freightSelfOnceInfo.payType" :options="paymentTypeTree" :props="props" />
							</el-form-item>
							<el-form-item label="我方户名" prop="selfAcountsName">
								<el-row>
									<el-col :span="10">
										<el-input v-model="freightSelfOnceInfo.selfAcountsName" placeholder="请输入我方户名" />
									</el-col>
									<!--   自定义组件查找-->
									<el-col :span="3">
										<SearchOption
											:get-data="listBankAccount"
											title="银行卡信息"
											icon="el-icon-search"
											:limit-info="{
												acountsType: '己方公司'
											}"
											:query-name="bankQuery"
											query-info="acountsName"
											query-label="户名查询"
											@commitBack="handleCallBack"
											@update:queryName="handleCommitBackBank"
										>
											<template #table-columns>
												<el-table-column label="账户类型" align="center" prop="acountsType" />
												<el-table-column label="己方公司" align="center" prop="displayName" />
												<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
												<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
												<el-table-column label="开户行" align="center" prop="bankName" />
												<el-table-column label="公司名称" align="center" prop="companyName" />
											</template>
										</SearchOption>
									</el-col>
								</el-row>
							</el-form-item>
							<el-form-item label="我方账号" prop="selfBankNo">
								<el-input v-model="freightSelfOnceInfo.selfBankNo" placeholder="请输入我方账号" />
							</el-form-item>
							<el-form-item label="我方开户行" prop="selfBankName">
								<el-input v-model="freightSelfOnceInfo.selfBankName" placeholder="请输入我方开户行" />
							</el-form-item>

							<el-form-item label="运费总和">
								<el-button type="text" disabled style="color: orangered">
									{{ fix(total_freight) }}
								</el-button>
							</el-form-item>
							<el-form-item>
								<div class="order-freight-submit">
									<el-button type="success" @click="submitFreightOnce">一键付运费</el-button>
								</div>
							</el-form-item>
						</el-form>
					</div>
				</div>
				<!--        然后是一个按钮 表示一键付运费-->
			</template>
		</InfoDialog>

		<!--    created第一次传递的props，然后监听后来props的变化-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="运费付款申请"
			:visible.sync="applyPaymentVisible"
			width="500px"
			append-to-body
		>
			<keep-alive>
				<ApplyPayment :table-name="TableName.ORDER_FREIGHT" :t-i-d="tID" :need-info="needInfo" :need-money="freight" @changeOpen="changeOpen" />
			</keep-alive>
		</el-dialog>
	</div>
</template>

<script>
import { listOrderFreight, getOrderFreight, delOrderFreight, addOrderFreight, updateOrderFreight } from '@/api/system/orderFreight';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { TableName } from '@/api/tool/enums';
import { addDateRange } from '@/utils/ruoyi';
import { listData } from '@/api/system/dict/data';
import { listFleet } from '@/api/system/fleet';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_order_base } from '../../dashboard/mixins/order/order_base';
import { mixin_order_freight_payment } from '../../dashboard/mixins/order/order_freight_payment';
import InfoDialog from '../../../components/InfoDialog.vue';
import { mixin_payment_subject } from '../../dashboard/mixins/payment/payment_subject';
import { PaymentState } from '../../../api/tool/enums';
import CheckOrderInfo from '../../dashboard/components/orderfreight/CheckOrderInfo.vue';
import FillFreight from '../../dashboard/components/orderfreight/FillFreight.vue';
import { mixin_order_freight_fill } from './orderFreightFill';
import { FREIGHT_TYPE, mixin_freight_payment } from '@/views/dashboard/mixins/freight/freight_payment';
import { fix } from '../../../api/tool/format';
import PaymentFlag from '@/components/PaymentFlag';

export default {
	name: 'OrderFreight',
	components: {
		PaymentFlag,
		FillFreight,
		CheckOrderInfo,
		InfoDialog,
		ApplyPayment,
		SearchOption
	},
	mixins: [mixin_order_freight_fill, mixin_order_base, mixin_order_freight_payment, /* 引入支付类型的混入*/ mixin_payment_subject, /* 引入支付类型的混入*/ mixin_freight_payment],
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
			dateRange: [],
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 订单运费表格数据
			orderFreightList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				ordersNo: null,
				freightType: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				content: null,
				paymentState: null,
				driverName: null,
				driverId: null,
				CarNo: null,
				fleet: null,
				applyUserId: null,
				applyUserName: null,
				applyDate: null,
				isedit: null,
				payUserId: null,
				payUserName: null,
				payDate: null,
				cancelFlag: null,
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
				{ key: 0, label: `付款日期`, visible: true },
				{ key: 1, label: `运费类型`, visible: true },
				{ key: 2, label: `车队`, visible: true },
				{ key: 3, label: `车牌号`, visible: true },
				{ key: 4, label: `金额`, visible: true },
				{ key: 5, label: `对方户名`, visible: true },
				{ key: 6, label: `对方账号`, visible: true },
				{ key: 7, label: `对方开户行`, visible: true },
				{ key: 8, label: `运费来源`, visible: true },
				{ key: 9, label: `支付状态`, visible: true },
				{ key: 10, label: `申请人员姓名`, visible: true },
				{ key: 11, label: `申请日期`, visible: true },
				{ key: 12, label: `付款人员姓名`, visible: true },
				{ key: 13, label: `我方户名`, visible: true },
				{ key: 14, label: `我方账号`, visible: true },
				{ key: 15, label: `我方开户行`, visible: true },
				{ key: 16, label: `备注`, visible: true }
			],
			bankInputDisabled: false,
			tID: null,
			freight: null,
			applyInfo: null,
			applyPaymentVisible: false,
			needInfo: {},
			freightSelfOnceInfo: {
				payType: null,
				selfAcountsName: '',
				selfBankNo: '',
				selfBankName: '',
				otherBankCardType: null
			},
			freightSelfOnceInfoRules: {
				payType: [
					{
						required: true,
						message: '请选择支付类型',
						trigger: 'change'
					}
				],
				selfAcountsName: [
					{
						required: true,
						message: '请输入我方户名',
						trigger: 'blur'
					}
				],
				selfBankNo: [
					{
						required: true,
						message: '请输入我方账号',
						trigger: 'blur'
					}
				],
				selfBankName: [
					{
						required: true,
						message: '请输入我方开户行',
						trigger: 'blur'
					}
				]
			}
		};
	},
	computed: {
		FREIGHT_TYPE() {
			return FREIGHT_TYPE;
		},
		TableName() {
			return TableName;
		},
		// 运费状态自定义样式映射
		freightStatusStyles() {
			return {
				PAID: {
					color: '#67C23A'
				},
				UNPAID: {
					color: '#F56C6C'
				}
			};
		}
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('freight-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		// 拿到地址栏中的参数
		const { fundsDate, driver } = this.$route.query;
		// 如果存在
		if (fundsDate && driver) {
			// 拿取地址中的参数 查询list
			this.getQueryParams(fundsDate, driver);
		} else {
			// 如果没有 正常查询
			this.getList();
		}
		// 设置本地存储
		if (localStorage.getItem('freight-columns') === 'null' || !localStorage.getItem('freight-columns')) {
			// 设置localStorage
			localStorage.setItem('freight-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('freight-columns'));
		}
	},
	mounted() {
		if (Object.keys(this.$route.query).length) {
			this.$router.replace({ path: this.$route.path });
		}
	},
	methods: {
		fix,
		listFleet,
		listData,
		listBankAccount,
		// 运费业务自定义状态判断函数
		customFreightStatusFn(businessObject) {
			// 运费业务逻辑：有payment对象就是已支付，没有就是未支付
			if (businessObject && businessObject.payment && businessObject.payment !== null) {
				return {
					text: '已支付',
					type: 'success',
					status: 'PAID',
					statusType: 'payment'
				};
			} else {
				return {
					text: '未支付',
					type: 'danger',
					status: 'UNPAID',
					statusType: 'payment'
				};
			}
		},
		// 拿到付款状态
		PaymentState() {
			return PaymentState;
		},
		// 拿取地址中的参数 查询list展示
		getQueryParams(fundsDate, driver) {
			// 当都存在的时候 表名是跳转过来的 要查询一次list
			listOrderFreight({ payDate: fundsDate, driverName: driver }).then(response => {
				this.orderFreightList = response.rows;
				this.total = response.total;
				this.loading = false;
				// 如果查询到了
				if (this.total > 0) {
					this.$message.success('已查询付款时间为' + fundsDate + '司机名称为' + driver + '的' + this.total + '条数据');
				} else {
					this.$message.warning('未查询到付款时间为' + fundsDate + '司机名称为' + driver + '的运费信息');
				}
			});
		},
		// 填充我方银行卡账户类型
		handleBankTypeSelf(value) {
			this.freightSelfOnceInfo.selfBankCardType = value;
		},
		// 对方银行账户类型
		handleBankTypeOther(value) {
			this.freightSelfOnceInfo.otherBankCardType = value;
		},
		changeOpen() {
			this.needMoney = 0;
			this.applyPaymentVisible = false;
			this.getList();
		},
		/** 查询订单运费列表 */
		getList() {
			this.loading = true;
			// applyDateStartTime
			listOrderFreight(addDateRange(this.queryParams, this.dateRange, 'orderfreight')).then(response => {
				this.orderFreightList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
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
				ordersNo: null,
				freightType: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				content: null,
				paymentState: null,
				driverName: null,
				driverId: null,
				CarNo: null,
				fleet: null,
				applyUserId: null,
				applyUserName: null,
				applyDate: null,
				isedit: null,
				payUserId: null,
				payUserName: null,
				payDate: null,
				cancelFlag: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				// 对方银行卡类型
				otherBankCardType: null
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
			this.selectedList = selection;
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加订单运费申请';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getOrderFreight(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改订单运费';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateOrderFreight(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addOrderFreight(this.form).then(() => {
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
				.confirm('是否确认删除订单运费编号为"' + ids + '"的数据项？')
				.then(function () {
					return delOrderFreight(ids);
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
				'system/orderFreight/export',
				{
					...this.queryParams
				},
				`orderFreight_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
<style scoped>
/* 一键付运费弹窗布局与滚动优化，仅样式调整，不改业务结构 */
.order-freight-body {
	/* 改为网格布局，避免内容撑高弹窗 */
	display: grid;
	grid-template-columns: 1.1fr 0.9fr;
	gap: 16px;
	/* 固定内部可视高度，内部滚动 */
	height: 68vh;
	min-height: 420px;
	overflow: hidden;
	padding-right: 4px;
	/* 预留滚动条空间，避免抖动 */
}

.order-freight-info,
.order-freight-self-info {
	min-width: 0;
	/* 防止子元素溢出 */
}

.order-freight-info {
	/* 左侧面板可滚动 */
	height: 100%;
	overflow: auto;
	padding-right: 4px;
}

.order-freight-self-info {
	/* 右侧面板使用列布局，表单滚动，按钮吸底 */
	height: 100%;
	display: flex;
	flex-direction: column;
	background: #fafafa;
	border-left: 1px solid #f0f0f0;
	padding-left: 12px;
}

/* 让表单在右侧面板中自适应滚动 */
.order-freight-self-info ::v-deep .el-form {
	height: 100%;
	display: flex;
	flex-direction: column;
}

.order-freight-self-info ::v-deep .el-form-item {
	margin-bottom: 10px;
}

/* 将按钮区域吸底并加柔和分隔效果 */
.order-freight-submit {
	margin-top: auto;
	display: flex;
	justify-content: center;
	align-items: center;
	position: sticky;
	bottom: 0;
	background: linear-gradient(to top, rgba(250, 250, 250, 1), rgba(250, 250, 250, 0.92));
	padding: 10px 0 6px;
	border-top: 1px solid #eee;
}

/* 优化左侧卡片与折叠面板的紧凑感 */
.order-freight-info ::v-deep .el-collapse-item__header {
	padding: 0 10px;
	font-size: 13px;
}

.order-freight-info ::v-deep .el-card {
	border: 1px solid #f0f0f0;
	box-shadow: none;
}

.order-freight-info ::v-deep .el-card__body {
	padding: 10px 12px;
}

.order-freight-info ::v-deep .el-descriptions__title {
	font-size: 14px;
}

.order-freight-info ::v-deep .el-descriptions__label {
	color: #888;
	width: 88px;
	/* 控制标签宽度，提升可读性 */
}

.order-freight-info ::v-deep .el-tag.el-tag--mini {
	line-height: 18px;
	height: 18px;
}

/* 表单输入宽度与组件对齐优化 */
.order-freight-self-info ::v-deep .el-input,
.order-freight-self-info ::v-deep .el-cascader,
.order-freight-self-info ::v-deep .el-select {
	width: 100%;
}

/* 小屏幕降级为单列布局 */
@media (max-width: 1366px) {
	.order-freight-body {
		grid-template-columns: 1fr;
		height: 75vh;
	}

	.order-freight-self-info {
		border-left: none;
		border-top: 1px solid #f0f0f0;
		padding-top: 12px;
	}
}
</style>
