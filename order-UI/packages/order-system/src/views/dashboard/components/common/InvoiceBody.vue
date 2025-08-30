<script>
import InvoiceItem from '@/views/dashboard/components/common/InvoiceItem.vue';
import { create, all } from 'mathjs';
import { mapGetters } from 'vuex';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { parseTime } from '@/utils/ruoyi';
import { getUuid } from '@/utils/trash/utils';
import { TableName } from '@/api/tool/enums';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import ReadyList from '@/views/dashboard/components/common/ReadyList.vue';

export default {
	name: 'InvoiceBody',
	components: { DialogWrapper, InvoiceItem },
	mixins: [common_dialog],
	props: {},
	watch: {
		// 监听选择订单的变化
		selectedOrder: {
			handler(val) {
				// 选择订单仅控制开关，不自动生成发票；生成发票由用户点击触发
				typeof val === 'object' && val.length > 0 ? this.handleToggle(false) : this.handleToggle(true);
			},
			immediate: true,
			deep: true
		}
	},
	data() {
		return {
			companyName: null,
			// 开票类型
			invoiceType: null,
			// 按钮的禁用状态
			op_customer: true,
			op_supplier: true,
			// 供应商的id  只用作搜索
			supplierId: null,
			// 票点信息
			currentTicketPoint: 0,
			currentTicketPointAmount: 0
		};
	},
	created() {
		this.math = create(all, { number: 'BigNumber', precision: 64 });
	},
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		...mapGetters(['selectedInvoiceList', 'selectedOrder', 'ticketPoint', 'comment', 'invoiceAmount']),
		// 是否已有生成的发票列表，用于控制“开具发票”按钮是否可用
		hasGeneratedInvoices() {
			return Array.isArray(this.selectedInvoiceList) && this.selectedInvoiceList.length > 0;
		}
	},
	methods: {
		// 创建发票对象的工具函数
		createInvoiceObject(params) {
			const { invoiceDate, invoiceObject, invoiceAmount, companyType, companyName, companyID, invoiceCompanyName, ticketPoint = 0, ticketPointAmount, isOrderTax, comments } = params;
			return {
				invoiceDate,
				invoiceObject,
				invoiceAmount,
				companyType,
				companyName,
				companyID,
				invoiceCompanyName,
				ticketPoint,
				ticketPointAmount,
				isOrderTax,
				comments,
				// 随机生成一个uuid和表名
				params: {
					uuid: getUuid(),
					tableName: companyType === PUBLIC_DICT_TYPE.CUSTOMER ? TableName.INVOICE_OUT : TableName.INVOICE_IN
				}
			};
		},

		// 批量开发票
		async handleInvoiceBatch() {
			// 保持旧行为：直接检查当前已经生成的发票列表
			const invoiceList = this.$store.getters.selectedInvoiceList || [];
			if (!invoiceList || invoiceList.length === 0) {
				this.$message.warning('开票列表为空,请检查!');
				return;
			}
			this.handleCheckInvoice(invoiceList);
		},

		/**
		 * 生成发票（按模板分配）
		 *
		 * 概要：
		 *  - 从 Vuex 读取当前选中的订单（selectedOrder）和模板数据（purchaseTemplateData + sellerTemplateData）。
		 *  - 如果组件通过 CompanyList 已经选定了某个公司（this.supplierId），则优先筛选出该公司的模板（优先匹配 seller，再匹配 purchase；当偏好为客户时优先匹配 sellerType 为客户的模板）。
		 *  - 使用深拷贝的模板池（templatePool）进行分配：对每个订单，依次从模板池取出模板行，计算本次使用金额 used = min(templateAmount, orderRemaining)，为该 used 金额生成一条发票对象并加入结果数组。
		 *  - 模板支持部分消耗：每次使用后将模板剩余写回 templatePool（不回写 Vuex），订单剩余减少，直到订单被完全抵扣或模板耗尽。
		 *  - 处理完成后将生成的发票列表写入 Vuex（excel/setSelectedInvoiceList）并通过 this.$message 显示生成条数。
		 *
		 * 输入（隐式）：
		 *  - this.$store.getters.selectedOrder: 选中的订单数组（必须包含 order.allPayments 和 order.params.totalInvoiceAmount 等字段）。
		 *  - this.$store.state.excel.purchaseTemplateData / sellerTemplateData: 模板数组，模板行需包含 total、sellerId、sellerType、purchaseId 等字段。
		 *  - this.supplierId / this.invoiceType: （可选）来自 CompanyList 的当前检索公司和偏好类型，用以筛选模板。
		 *
		 * 输出/副作用：
		 *  - 将生成的发票数组写入 Vuex（dispatch('excel/setSelectedInvoiceList', resultInvoices)）。
		 *  - 在页面上通过 this.$message.success 显示生成数量。
		 *
		 * 算法要点（按订单循环）：
		 *  1. 计算订单剩余 remaining = allPayments - params.totalInvoiceAmount（使用 BigNumber 精度运算）。
		 *  2. 遍历 templatePool：
		 *     - 若 tpl.total 为 0 则跳过；否则 used = min(tpl.total, remaining)。
		 *     - 使用 used 生成一条发票对象（invoiceAmount = used，票点按 used 计算）。
		 *     - 将模板剩余 tpl.total -= used（写回 templatePool），将 remaining -= used。
		 *     - 若 remaining <= 0，标记订单完成并跳出模板循环，继续处理下一个订单。
		 *  3. 所有订单处理结束后，将结果提交到 Vuex 并回显。
		 *
		 * 备注/边界情况：
		 *  - 若未选中订单或无模板数据，会使用 this.$message.warning 提示并返回。
		 *  - 模板部分消耗只在内存拷贝上进行，不会修改 Vuex 中原始模板数据；如需持久化消耗，请告知。
		 *
		 * @returns {void}
		 */
		generateInvoicesByTemplates() {
			// 获取当前选择订单
			const orders = this.$store.getters.selectedOrder || [];
			if (!orders || orders.length === 0) {
				this.$message.warning('请先选择订单后再生成发票');
				return;
			}

			// 读取并合并模板数据（购买方+销方）
			const purchaseTemplates = this.$store.state.excel.purchaseTemplateData || [];
			const sellerTemplates = this.$store.state.excel.sellerTemplateData || [];
			const templates = purchaseTemplates.concat(sellerTemplates);
			if (!templates || templates.length === 0) {
				this.$message.warning('暂无模板数据，无法生成发票');
				return;
			}

			// 这部分逻辑是筛选公司 使用该公司模板数据
			const selectedCompanyId = this.supplierId;
			const preferInvoiceType = this.invoiceType; // PUBLIC_DICT_TYPE
			const isCustomerTypeStr = s => {
				if (!s) return false;
				try {
					const lower = String(s).toLowerCase();
					return lower.includes('客户') || lower.includes('customer');
				} catch (e) {
					return false;
				}
			};

			let filtered = templates;
			if (selectedCompanyId) {
				// 优先按销方 id 过滤；当偏好为 CUSTOMER 时，优先匹配 sellerType 为客户的模板
				let sellerMatches = templates.filter(tpl => tpl && tpl.sellerId && String(tpl.sellerId) === String(selectedCompanyId));
				if (sellerMatches.length > 0) {
					if (preferInvoiceType === this.PUBLIC_DICT_TYPE.CUSTOMER) {
						const customerSellerMatches = sellerMatches.filter(tpl => isCustomerTypeStr(tpl.sellerType));
						if (customerSellerMatches.length > 0) sellerMatches = customerSellerMatches;
					}
					filtered = sellerMatches;
				} else {
					// 尝试按购买方 id 过滤
					const purchaseMatches = templates.filter(tpl => tpl && tpl.purchaseId && String(tpl.purchaseId) === String(selectedCompanyId));
					if (purchaseMatches.length > 0) filtered = purchaseMatches;
				}
			}

			// 深拷贝模板，避免修改原始 Vuex 数据
			let templatePool = filtered.map(t => ({ ...t }));

			// 生成发票列表
			const resultInvoices = [];

			// 使用 mathjs BigNumber 做精确计算
			const b = v => this.math.bignumber(v || 0);

			for (let order of orders) {
				// 每个订单的 remainingAmount 是订单的已开票金额(allPayments)
				let remaining = b(order.allPayments - order.params.totalInvoiceAmount || 0);
				let orderFullyInvoiced = false;
				// 如果订单的剩余开票金额等于0
				if (remaining === 0) {
					continue; // 跳过该订单，继续下一个订单
				}
				for (let i = 0; i < templatePool.length; i++) {
					const tpl = templatePool[i];
					let tplAmount = b(tpl.total || 0);
					// 没有可用模板金额则跳过
					if (this.math.equal(tplAmount, b(0))) continue;

					// 计算本次要使用的金额：used = min(tplAmount, remaining)
					let used;
					if (this.math.largerEq(tplAmount, remaining)) {
						used = remaining;
					} else {
						used = tplAmount;
					}

					// 根据模板行判断 companyType/companyID/companyName：优先判断销方（sellerId），否则判断购买方（purchaseId）
					let companyTypeConst = this.invoiceType || this.PUBLIC_DICT_TYPE.CUSTOMER;
					let companyID = tpl.sellerId || tpl.purchaseId || null;
					let companyName = tpl.sellerName || tpl.purchaseName || tpl.invoiceCompanyName || '未知';
					if (tpl.sellerId && Number(tpl.sellerId) !== 0) {
						companyTypeConst = tpl.sellerType === '供应商' ? this.PUBLIC_DICT_TYPE.SUPPLIER : this.PUBLIC_DICT_TYPE.CUSTOMER;
						companyID = tpl.sellerId;
						companyName = tpl.sellerName || companyName;
					} else if (tpl.purchaseId && Number(tpl.purchaseId) !== 0) {
						companyTypeConst = tpl.purchaseType === '供应商' ? this.PUBLIC_DICT_TYPE.SUPPLIER : this.PUBLIC_DICT_TYPE.CUSTOMER;
						companyID = tpl.purchaseId;
						companyName = tpl.purchaseName || companyName;
					}

					// 生成发票对象（本次使用的金额 used）
					const invoice = this.createInvoiceObject({
						invoiceDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
						invoiceObject: sessionStorage.getItem('us'),
						invoiceAmount: Number(this.math.format(used)),
						companyType: companyTypeConst,
						companyName: companyName,
						companyID: companyID,
						invoiceCompanyName: companyName,
						ticketPoint: tpl.ticketPoint || tpl.ticketPointAmount || 0,
						ticketPointAmount: Number(this.math.format(this.math.multiply(used, b(tpl.ticketPoint || 0)))),
						isOrderTax: order.id,
						comments: this.comment
					});
					resultInvoices.push(invoice);

					// 更新订单剩余和模板剩余
					remaining = this.math.subtract(remaining, used);
					const tplRemainAfter = this.math.subtract(tplAmount, used);
					// 将剩余模板金额写回 pool（转为普通数字），便于后续继续使用
					templatePool[i].total = Number(this.math.format(tplRemainAfter));

					// 如果订单已被完全抵扣，则结束当前订单的模板匹配
					if (this.math.largerEq(b(0), remaining) || this.math.equal(remaining, b(0))) {
						orderFullyInvoiced = true;
						break;
					}
					// 否则继续使用下一个模板行
				}

				// 如果订单在模板循环后被标记为已开完，则继续下一个订单
				if (orderFullyInvoiced) continue;
			}

			// 将生成的发票列表写入 Vuex，触发界面更新
			this.$store.dispatch('excel/setSelectedInvoiceList', resultInvoices);
			this.$message.success(`生成 ${resultInvoices.length} 条发票记录`);
		},

		// 校验
		handleCheckInvoice(resultList) {
			// 打开弹窗
			this.openDialog(
				ReadyList,
				'待开票列表',
				'900px',
				{
					list: resultList
				},
				false
			);
		},
		// 分配金额的具体函数 选择某一个订单后要扣钱
		handleTransform(orderItem) {
			if (this.invoiceType === PUBLIC_DICT_TYPE.CUSTOMER) {
				return this.handleCustomer(orderItem);
			} else {
				return this.handleSupplier(orderItem);
			}
		},
		// 对客户进行处理
		handleCustomer(orderItem) {
			// 不存在id 返回null
			if (!orderItem.customerID) return null;

			const invoiceAmount = Number(orderItem.allPayments);
			// 使用新的票点计算公式：票点金额 = 开票金额 / (1 + 票点) * 票点
			const ticketPointAmount = this.currentTicketPoint > 0 ? Number(((invoiceAmount / (1 + this.currentTicketPoint)) * this.currentTicketPoint).toFixed(2)) : 0;

			// 创建客户发票对象
			return this.createInvoiceObject({
				invoiceDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				invoiceObject: sessionStorage.getItem('us'), // 己方公司实体
				invoiceAmount: invoiceAmount,
				companyType: PUBLIC_DICT_TYPE.CUSTOMER,
				companyName: orderItem.customer,
				companyID: orderItem.customerID,
				invoiceCompanyName: orderItem.customer,
				ticketPoint: this.currentTicketPoint,
				ticketPointAmount: ticketPointAmount,
				isOrderTax: orderItem.id,
				comments: this.comment
			});
		},
		// 对供应商进行处理
		handleSupplier(orderItem) {
			if (!orderItem.smailOrderDetails || orderItem.smailOrderDetails.length === 0) return null;

			// 先找到该检索的供应商
			const _suppliers = orderItem.smailOrderDetails.filter(item => {
				if (item.supplierID === this.supplierId) return item;
			});

			if (_suppliers.length === 0) return null;

			// 计算该供应商的出场货款
			const paymentFactory = _suppliers.reduce((pre, cur) => pre + cur.paymentFactory, 0);
			const invoiceAmount = Number(paymentFactory);

			// 使用新的票点计算公式：票点金额 = 开票金额 / (1 + 票点) * 票点
			const ticketPointAmount = this.currentTicketPoint > 0 ? Number(((invoiceAmount / (1 + this.currentTicketPoint)) * this.currentTicketPoint).toFixed(2)) : 0;

			// 创建供应商发票对象
			return this.createInvoiceObject({
				invoiceDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				invoiceObject: sessionStorage.getItem('us'),
				invoiceAmount: invoiceAmount,
				companyType: PUBLIC_DICT_TYPE.SUPPLIER,
				companyName: _suppliers[0].supplier,
				companyID: _suppliers[0].supplierID, // 供应商id
				invoiceCompanyName: _suppliers[0].supplier,
				ticketPoint: this.currentTicketPoint,
				ticketPointAmount: ticketPointAmount,
				isOrderTax: orderItem.id,
				comments: this.comment
			});
		},
		handleToggle(toggle) {
			this.op_customer = toggle;
			this.op_supplier = toggle;
		}
	},
	mounted() {
		this.$bus.$on('select-goods-row:update', () => {
			this.companyName = null;
			// 清空开票金额
			this.$store.dispatch('excel/clearInvoiceAmount');
		});
		this.$bus.$on('update-goods-order-company', value => {
			this.companyName = value.name;
			this.invoiceType = value.type;
			this.supplierId = value.id;
			// 接收票点信息
			this.currentTicketPoint = value.ticketPoint || 0;
			this.currentTicketPointAmount = value.ticketPointAmount || 0;
		});

		this.$bus.$on('invoice-clear', () => {
			// 重置开票金额
			sessionStorage.clear();
			this.$store.dispatch('excel/clearInvoiceAmount');
			// 重置开票列表
			this.$store.dispatch('excel/clearSelectedInvoiceList');
			// 清除右上角公司信息
			this.companyName = null;
			this.invoiceType = null;
			this.supplierId = null;
			// 清除票点信息
			this.currentTicketPoint = 0;
			this.currentTicketPointAmount = 0;
		});

		// 监听生成发票的触发（由 SelectGoods 发出）
		this.$bus.$on('generate-invoice', this.generateInvoicesByTemplates);
	},
	beforeDestroy() {
		// 清除事件监听 防止内存泄漏
		this.$bus.$off('select-goods:update'); // 清理事件监听
		this.$bus.$off('update-goods-order-company');
		this.$bus.$off('invoice-clear');
		this.$bus.$off('generate-invoice', this.generateInvoicesByTemplates);
	}
};
</script>

<template>
	<div class="invoice-body-wrapper">
		<el-card class="invoice-card">
			<div slot="header" class="card-header">
				<span class="bold-text">开票信息</span>
			</div>
			<div class="invoice-content">
				<div class="info-section">
					<div class="info-item">
						<span class="info-label">公司名称：</span>
						<span class="info-value">{{ companyName || '无' }}</span>
					</div>
					<div class="info-item">
						<span class="info-label">剩余开票金额：</span>
						<span class="money">{{ invoiceAmount || '无' }}</span>
					</div>
				</div>

				<div class="invoice-list">
					<InvoiceItem v-for="(item, index) in selectedInvoiceList" :key="index" :invoice="item" />
				</div>

				<!--    批量开票-->
				<div class="options">
					<el-button
						v-if="invoiceType === PUBLIC_DICT_TYPE.CUSTOMER"
						type="success"
						size="small"
						:disabled="op_customer || !hasGeneratedInvoices"
						@click="handleInvoiceBatch"
						class="invoice-button"
					>
						开具客户发票
					</el-button>
					<el-button
						v-if="invoiceType === PUBLIC_DICT_TYPE.SUPPLIER"
						type="success"
						size="small"
						:disabled="op_supplier || !hasGeneratedInvoices"
						@click="handleInvoiceBatch"
						class="invoice-button"
					>
						开具供应商发票
					</el-button>
				</div>
			</div>
		</el-card>

		<!--    通用弹窗 配合common_dialogs 使用-->
		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
	</div>
</template>

<style scoped lang="scss">
.invoice-body-wrapper {
	height: 100%;
	display: flex;
	flex-direction: column;
}

.invoice-card {
	height: 100%;
	display: flex;
	flex-direction: column;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
	border: 1px solid #ebeef5;
	border-radius: 6px;

	&:hover {
		box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.12);
	}

	::v-deep .el-card__header {
		padding: 12px 16px;
		border-bottom: 1px solid #ebeef5;
		flex-shrink: 0;

		.card-header {
			margin: 0;
		}
	}

	::v-deep .el-card__body {
		flex: 1;
		padding: 16px;
		overflow: hidden;
		display: flex;
		flex-direction: column;
	}
}

.invoice-content {
	height: 100%;
	display: flex;
	flex-direction: column;
}

.bold-text {
	font-weight: bold;
	color: #161617;
	font-size: 14px;
}

.info-section {
	flex-shrink: 0;
	margin-bottom: 16px;
	padding: 12px;
	background-color: #f8f9fa;
	border-radius: 4px;
	border-left: 4px solid #409eff;
}

.info-item {
	display: flex;
	align-items: center;
	margin-bottom: 8px;

	&:last-child {
		margin-bottom: 0;
	}
}

.info-label {
	font-size: 13px;
	color: #606266;
	min-width: 80px;
	margin-right: 8px;
}

.info-value {
	font-size: 13px;
	color: #303133;
	font-weight: 500;
}

.money {
	color: #e6a23c;
	font-weight: bold;
	font-size: 14px;
}

.invoice-list {
	flex: 1;
	overflow-y: auto;
	min-height: 0;
	margin-bottom: 16px;
	border: 1px solid #ebeef5;
	border-radius: 4px;
	padding: 8px;
	background-color: #fafbfc;

	/* 美化滚动条 */
	&::-webkit-scrollbar {
		width: 6px;
	}

	&::-webkit-scrollbar-thumb {
		background: #dcdfe6;
		border-radius: 3px;

		&:hover {
			background: #c0c4cc;
		}
	}

	&::-webkit-scrollbar-track {
		background: transparent;
	}
}

.options {
	flex-shrink: 0;
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 12px 0;
	border-top: 1px solid #ebeef5;

	.invoice-button {
		min-width: 120px;
		height: 36px;
		font-size: 13px;
		border-radius: 4px;
		transition: all 0.3s ease;

		&:not(:disabled):hover {
			transform: translateY(-1px);
			box-shadow: 0 4px 12px rgba(103, 194, 58, 0.3);
		}

		&:disabled {
			cursor: not-allowed;
			opacity: 0.6;
		}
	}
}

/* 响应式适配 */
@media screen and (max-width: 1200px) {
	.info-section {
		padding: 10px;
	}

	.invoice-list {
		min-height: 200px;
	}
}

@media screen and (max-width: 768px) {
	.invoice-card {
		::v-deep .el-card__body {
			padding: 12px;
		}
	}

	.info-item {
		flex-direction: column;
		align-items: flex-start;

		.info-label {
			min-width: auto;
			margin-right: 0;
			margin-bottom: 4px;
		}
	}

	.options {
		.invoice-button {
			min-width: 100px;
			height: 32px;
			font-size: 12px;
		}
	}
}

@media screen and (max-width: 480px) {
	.info-section {
		padding: 8px;
		margin-bottom: 12px;
	}

	.invoice-list {
		margin-bottom: 12px;
		min-height: 150px;
	}

	.options {
		padding: 8px 0;

		.invoice-button {
			width: 100%;
			max-width: 200px;
		}
	}
}
</style>
