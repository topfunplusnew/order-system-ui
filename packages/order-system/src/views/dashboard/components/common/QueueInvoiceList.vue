<script>
import InvoiceItem from '@/views/dashboard/components/common/InvoiceItem.vue';
import { create, all } from 'mathjs';
import { mapGetters } from 'vuex';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { parseTime } from '@/utils/ruoyi';
import { getUuid } from '@/utils/trash/utils';
import { TableName } from '@/api/tool/enums';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { batchInvoice } from '@/api/system/excel';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';

export default {
	name: 'QueueInvoiceList',
	components: { InvoiceItem },
	mixins: [common_dialog],
	props: {
		mode: {
			type: String,
			default: 'in'
		}
	},
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
		...mapGetters(['selectedInvoiceList', 'selectedOrder', 'ticketPoint', 'comment', 'invoiceAmount', 'batchDetailRows']),
		// 是否已有生成的发票列表，用于控制"开具发票"按钮是否可用
		hasGeneratedInvoices() {
			return Array.isArray(this.selectedInvoiceList) && this.selectedInvoiceList.length > 0;
		},
		// 实时计算剩余开票金额（基于模板数据中的未开票金额总和）
		remainingInvoiceAmount() {
			if (!this.supplierId || !this.batchDetailRows || this.batchDetailRows.length === 0) {
				return 0;
			}

			// 筛选出该公司对应的未开票模板数据
			const relevantTemplates = this.batchDetailRows.filter(tpl => {
				// 只计算未开票的记录
				if (tpl.invoiced) {
					return false;
				}

				// 根据发票类型匹配
				if (this.invoiceType === PUBLIC_DICT_TYPE.CUSTOMER) {
					// 客户模式：查找购买方ID匹配的记录
					return tpl.purchaseId && String(tpl.purchaseId) === String(this.supplierId);
				} else if (this.invoiceType === PUBLIC_DICT_TYPE.SUPPLIER) {
					// 供应商模式：查找销方ID匹配的记录
					return tpl.sellerId && String(tpl.sellerId) === String(this.supplierId);
				}

				return false;
			});

			// 计算模板数据总金额
			let totalAmount = this.math.bignumber(0);
			relevantTemplates.forEach(tpl => {
				totalAmount = this.math.add(totalAmount, this.math.bignumber(tpl.total || 0));
			});

			// 减去已生成的发票金额
			if (this.selectedInvoiceList && this.selectedInvoiceList.length > 0) {
				const generatedAmount = this.selectedInvoiceList.reduce((sum, invoice) => {
					return this.math.add(sum, this.math.bignumber(invoice.invoiceAmount || 0));
				}, this.math.bignumber(0));
				totalAmount = this.math.subtract(totalAmount, generatedAmount);
			}

			const result = Number(this.math.format(totalAmount, { precision: 2, notation: 'fixed' }));
			// 确保不为负数
			return Math.max(0, result);
		}
	},
	methods: {
		// 创建发票对象的工具函数
		createInvoiceObject(params, extra = {}) {
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
				},
				...extra
			};
		},

		// 批量开发票
		async handleInvoiceBatch() {
			// 获取当前已经生成的发票列表
			const invoiceList = this.$store.getters.selectedInvoiceList || [];
			if (!invoiceList || invoiceList.length === 0) {
				this.$message.warning('开票列表为空,请检查!');
				return;
			}

			// 显示加载状态
			const loadingInstance = this.$loading({
				lock: true,
				text: '正在批量开票，请稍候...',
				spinner: 'el-icon-loading',
				background: 'rgba(0, 0, 0, 0.7)'
			});

			try {
				// 直接执行批量开票
				await this.executeBatchInvoice(invoiceList);
			} catch (error) {
				console.error('批量开票失败:', error);
			} finally {
				loadingInstance.close();
			}
		},

		// 执行批量开票的核心逻辑（从ReadyList.vue迁移）
		async executeBatchInvoice(invoices) {
			const filteredInvoices = invoices.filter(item => item !== null);
			if (filteredInvoices.length === 0) {
				this.$message.error('开票信息为空');
				return;
			}

			const res = await batchInvoice(filteredInvoices);
			if (!res.data && !res.rows) {
				this.$message.error('批量开票出现问题：返回结果非法');
				return;
			}

			const result = this.checkInvoiceResult(res.data);
			if (!result) {
				this.$message.error('批量开票出现问题：返回结果非法');
				return;
			}

			// 如果成功
			if (result.flag) {
				// 告诉订单列表重新加载
				this.$bus.$emit('select-goods:update');

				// 清理发票相关状态
				if (this.$store && this.$store.dispatch) {
					this.$store.dispatch('excel/clearSelectedInvoiceList');
					this.$store.dispatch('excel/clearInvoiceAmount');
				}

				// 清理 sessionStorage 中的临时数据
				sessionStorage.removeItem('invoiceAmount');
				sessionStorage.removeItem('us');
				sessionStorage.removeItem('companyList_selected_company_id');
				sessionStorage.removeItem('merged_company_info');

				// 广播清理事件
				this.$bus.$emit('invoice-clear');
				this.$message.success('本批开票成功');

				// 通知父组件刷新数据（从后端重新获取列表，invoiced 状态会自动更新）
				this.$bus.$emit('batch-invoice:refresh');
			} else {
				this.$message.error('本批开票有误 请检查错误信息后重新提交');

				// 延迟显示错误详情
				setTimeout(() => {
					this.handleInvoiceError(result, filteredInvoices);
				}, 1000);
			}
		},

		// 处理开票错误详情
		handleInvoiceError(result, invoices) {
			const uuid = result.uuid;
			for (let i = 0; i < invoices.length; i++) {
				const item = invoices[i];
				const index = i;
				if (item.uuid === uuid) {
					// 查找该出错的信息 提示用户
					this.$message.error(`第${index}条信息发生错误:${item.result}`);
					// 判断tableName并打开对应的错误信息弹窗
					switch (item.tableName) {
						case TableName.INVOICE_OUT: {
							this.openDialog(
								INVOICE_OUT,
								'出错的发票信息',
								'900px',
								{
									needToShowInfo: item
								},
								false
							);
							break;
						}
						case TableName.INVOICE_IN: {
							this.openDialog(
								INVOICE_IN,
								'出错的发票信息',
								'900px',
								{
									needToShowInfo: item
								},
								false
							);
							break;
						}
					}
					break;
				}
			}
		},

		// 检查开票结果（从ReadyList.vue迁移）
		checkInvoiceResult(data) {
			let result = {};
			for (let item of data) {
				if (item.result !== 'success') {
					result.message = item.result;
					result.uuid = item.uuid;
					result.flag = false;
				} else {
					result.flag = true;
				}
			}
			return result;
		},

		/**
		 * 生成发票（以模板数据为主）
		 * 每个模板数据生成一张发票，发票金额以模板数据为准，但不能超过订单的剩余货款
		 */
		generateInvoicesByTemplates() {
			const orders = this.$store.getters.selectedOrder || [];
			if (!orders || orders.length === 0) {
				this.$message.warning('请先选择订单');
				return;
			}

			// 从 Vuex 获取批次详情数据
			const batchRows = this.$store.getters.batchDetailRows || [];
			if (!batchRows || batchRows.length === 0) {
				this.$message.warning('暂无批次数据，无法生成发票');
				return;
			}

			// 筛选未开票的记录
			const selectedCompanyId = this.supplierId;
			let filtered = batchRows.filter(row => !row.invoiced);

			// 按公司ID筛选
			if (selectedCompanyId) {
				const sellerMatches = filtered.filter(row => row.sellerId && String(row.sellerId) === String(selectedCompanyId));
				if (sellerMatches.length > 0) {
					filtered = sellerMatches;
				} else {
					const purchaseMatches = filtered.filter(row => row.purchaseId && String(row.purchaseId) === String(selectedCompanyId));
					if (purchaseMatches.length > 0) {
						filtered = purchaseMatches;
					}
				}
			}

			if (filtered.length === 0) {
				this.$message.warning('该公司暂无未开票的批次记录');
				return;
			}

			const resultInvoices = [];
			const b = v => this.math.bignumber(v || 0);
			// 记录未用完的模板数据（原子性要求：必须用完）
			const unfinishedTemplates = [];

			// 为每个订单计算剩余货款（用于限制发票金额）
			const orderRemainingMap = new Map();
			orders.forEach(order => {
				let remaining = 0;
				if (this.invoiceType === PUBLIC_DICT_TYPE.CUSTOMER) {
					// 客户模式：使用总货款减去已开票金额
					const allPayments = b(order.allPayments || 0);
					const totalInvoiceAmount = b(order.params?.totalInvoiceAmount || 0);
					remaining = Number(this.math.format(this.math.subtract(allPayments, totalInvoiceAmount), { precision: 2, notation: 'fixed' }));
				} else if (this.invoiceType === PUBLIC_DICT_TYPE.SUPPLIER) {
					// 供应商模式：使用出厂货款之和减去已开票金额
					if (order.smailOrderDetails && Array.isArray(order.smailOrderDetails)) {
						const supplierDetails = order.smailOrderDetails.filter(detail => detail.supplierID === selectedCompanyId);
						let totalFactoryPayment = b(0);
						supplierDetails.forEach(detail => {
							totalFactoryPayment = this.math.add(totalFactoryPayment, b(detail.paymentFactory || 0));
						});
						const totalInvoiceAmount = b(order.params?.totalInvoiceAmount || 0);
						remaining = Number(this.math.format(this.math.subtract(totalFactoryPayment, totalInvoiceAmount), { precision: 2, notation: 'fixed' }));
					}
				}
				orderRemainingMap.set(order.id, remaining);
			});

			// 以模板数据为主，遍历每个模板数据
			for (const tpl of filtered) {
				let tplRemaining = b(tpl.total || 0); // 模板剩余金额
				if (this.math.equal(tplRemaining, b(0))) {
					continue; // 跳过金额为0的模板
				}

				// 一个模板数据可以分配给多个订单，直到模板金额用完
				while (this.math.larger(tplRemaining, b(0))) {
					// 找到匹配的订单（根据公司ID匹配）
					let matchedOrder = null;
					for (const order of orders) {
						// 检查模板数据是否匹配当前订单的公司
						let isMatched = false;
						if (this.invoiceType === PUBLIC_DICT_TYPE.CUSTOMER) {
							// 客户模式：检查购买方ID是否匹配
							isMatched = tpl.purchaseId && String(tpl.purchaseId) === String(order.customerID);
						} else if (this.invoiceType === PUBLIC_DICT_TYPE.SUPPLIER) {
							// 供应商模式：检查销方ID是否匹配
							isMatched = tpl.sellerId && String(tpl.sellerId) === String(selectedCompanyId);
							// 还需要检查订单明细中是否包含该供应商
							if (isMatched && order.smailOrderDetails) {
								isMatched = order.smailOrderDetails.some(detail => detail.supplierID === selectedCompanyId);
							}
						}

						if (isMatched) {
							const remaining = orderRemainingMap.get(order.id) || 0;
							// 如果订单还有剩余货款，可以使用
							if (remaining > 0) {
								matchedOrder = order;
								break;
							}
						}
					}

					// 如果没有匹配的订单，跳出循环
					if (!matchedOrder) {
						break;
					}

					// 获取订单剩余货款
					const orderRemaining = b(orderRemainingMap.get(matchedOrder.id) || 0);

					// 如果订单剩余开票金额为0或负数，跳出循环
					if (this.math.smallerEq(orderRemaining, b(0))) {
						break;
					}

					// 发票金额 = min(模板剩余金额, 订单剩余开票金额)
					let invoiceAmount = tplRemaining;
					if (this.math.larger(tplRemaining, orderRemaining)) {
						// 如果模板剩余金额大于订单剩余开票金额，使用订单剩余开票金额
						invoiceAmount = orderRemaining;
					}

					// 确定公司信息
					let companyTypeConst = this.invoiceType;
					let companyID = tpl.sellerId || tpl.purchaseId || null;
					let companyName = tpl.sellerName || tpl.purchaseName || '';
					let invoiceObject = null;

					if (tpl.sellerId && Number(tpl.sellerId) !== 0) {
						companyTypeConst = tpl.sellerType;
						companyID = tpl.sellerId;
						companyName = tpl.sellerName || companyName;
						invoiceObject = tpl.purchaseName || null;
					} else if (tpl.purchaseId && Number(tpl.purchaseId) !== 0) {
						companyTypeConst = tpl.purchaseType;
						companyID = tpl.purchaseId;
						companyName = tpl.purchaseName || companyName;
						invoiceObject = tpl.sellerName || null;
					}

					// 从 sessionStorage 获取我方公司信息
					if (!invoiceObject) {
						const storedUs = sessionStorage.getItem('us');
						if (storedUs) {
							try {
								const parsedUs = JSON.parse(storedUs);
								invoiceObject = Array.isArray(parsedUs) && parsedUs.length > 0 ? parsedUs[0] : storedUs;
							} catch (e) {
								invoiceObject = storedUs;
							}
						}
					}

					// 计算票点金额（使用实际发票金额计算）
					const actualInvoiceAmount = Number(this.math.format(invoiceAmount, { precision: 2, notation: 'fixed' }));
					let ticketPointAmount = 0;
					if (this.math.larger(b(tpl.ticketPoint || 0), b(0))) {
						const denominator = this.math.add(b(1), b(tpl.ticketPoint || 0));
						const fraction = this.math.divide(invoiceAmount, denominator);
						ticketPointAmount = Number(this.math.format(this.math.multiply(fraction, b(tpl.ticketPoint || 0)), { precision: 2, notation: 'fixed' }));
					}

					// 生成发票对象，优先使用批次导入时的开票时间
					const invoice = this.createInvoiceObject(
						{
							invoiceDate: tpl.invoiceDate || parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
							invoiceObject: invoiceObject || sessionStorage.getItem('us') || '',
							invoiceAmount: actualInvoiceAmount,
							companyType: companyTypeConst,
							companyName: companyName,
							companyID: companyID,
							invoiceCompanyName: companyName,
							ticketPoint: tpl.ticketPoint || 0,
							ticketPointAmount: ticketPointAmount,
							isOrderTax: matchedOrder.id,
							comments: this.comment
						},
						{
							batchInvoiceId: tpl.id || null,
							batchVoucher: tpl.voucher || ''
						}
					);
					resultInvoices.push(invoice);

					// 更新订单剩余货款（减少已使用的金额）
					const newRemaining = this.math.subtract(orderRemaining, invoiceAmount);
					orderRemainingMap.set(matchedOrder.id, Number(this.math.format(newRemaining, { precision: 2, notation: 'fixed' })));

					// 更新模板剩余金额（减少已使用的金额）
					tplRemaining = this.math.subtract(tplRemaining, invoiceAmount);
				}

				// 检查模板数据是否用完（原子性要求：必须用完）
				const remainingAmount = Number(this.math.format(tplRemaining, { precision: 2, notation: 'fixed' }));
				if (remainingAmount > 0.01) {
					// 允许0.01的误差（浮点数精度问题）
					// 记录未用完的模板数据
					unfinishedTemplates.push({
						id: tpl.id,
						voucher: tpl.voucher || '',
						total: tpl.total || 0,
						remaining: remainingAmount,
						companyName: tpl.sellerName || tpl.purchaseName || '未知公司'
					});
				}
			}

			if (resultInvoices.length > 0) {
				this.$store.dispatch('excel/setSelectedInvoiceList', resultInvoices);
				this.$message.success(`已自动生成 ${resultInvoices.length} 条发票记录`);

				// 检查是否有未用完的模板数据（原子性要求）
				if (unfinishedTemplates.length > 0) {
					const templateInfo = unfinishedTemplates.map(t => `模板ID ${t.id}（${t.companyName}）剩余 ¥${t.remaining.toFixed(2)}`).join('；');
					this.$message.warning(`以下模板数据未用完，请继续选择订单完成开票：${templateInfo}`);
				}
			} else {
				this.$message.warning('没有找到合适的批次记录来生成发票');
			}
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
			const invoiceAmount = this.math.bignumber(orderItem.allPayments);
			// 使用新的票点计算公式：票点金额 = 开票金额 / (1 + 票点) * 票点
			let ticketPointAmount = 0;
			if (this.math.larger(this.currentTicketPoint, 0)) {
				const denominator = this.math.add(this.math.bignumber(1), this.math.bignumber(this.currentTicketPoint));
				const fraction = this.math.divide(invoiceAmount, denominator);
				const multiplied = this.math.multiply(fraction, this.math.bignumber(this.currentTicketPoint));
				ticketPointAmount = Number(this.math.format(multiplied, { precision: 2, notation: 'fixed' }));
			}
			// 创建客户发票对象
			return this.createInvoiceObject({
				invoiceDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				invoiceObject: sessionStorage.getItem('us'), // 己方公司实体
				invoiceAmount: Number(this.math.format(invoiceAmount, { precision: 2, notation: 'fixed' })),
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
			const paymentFactory = _suppliers.reduce((pre, cur) => this.math.add(this.math.bignumber(pre), this.math.bignumber(cur.paymentFactory)), this.math.bignumber(0));
			const invoiceAmount = this.math.bignumber(Number(this.math.format(paymentFactory, { precision: 2, notation: 'fixed' })));
			// 使用新的票点计算公式：票点金额 = 开票金额 / (1 + 票点) * 票点
			let ticketPointAmount = 0;
			if (this.math.larger(this.currentTicketPoint, 0)) {
				const denominator = this.math.add(this.math.bignumber(1), this.math.bignumber(this.currentTicketPoint));
				const fraction = this.math.divide(invoiceAmount, denominator);
				const multiplied = this.math.multiply(fraction, this.math.bignumber(this.currentTicketPoint));
				ticketPointAmount = Number(this.math.format(multiplied, { precision: 2, notation: 'fixed' }));
			}
			// 创建供应商发票对象
			return this.createInvoiceObject({
				invoiceDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				invoiceObject: sessionStorage.getItem('us'),
				invoiceAmount: Number(this.math.format(invoiceAmount, { precision: 2, notation: 'fixed' })),
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
		// 监听左侧选择某个公司点击检索后
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
			sessionStorage.removeItem('invoiceAmount');
			sessionStorage.removeItem('us');
			sessionStorage.removeItem('companyList_selected_company_id');
			sessionStorage.removeItem('merged_company_info');
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
		this.$bus.$off('sheet-info-updated');
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
						<span class="money">{{ remainingInvoiceAmount.toFixed(2) || '暂无' }}</span>
					</div>
				</div>
				<div class="invoice-list">
					<InvoiceItem v-for="(item, index) in selectedInvoiceList" :key="index" :invoice="item" />
				</div>
				<!--    批量开票-->
				<div class="options">
					<el-button v-if="invoiceType === PUBLIC_DICT_TYPE.CUSTOMER" type="success" size="small" :disabled="op_customer || !hasGeneratedInvoices" @click="handleInvoiceBatch" class="invoice-button">开具客户发票</el-button>
					<el-button v-if="invoiceType === PUBLIC_DICT_TYPE.SUPPLIER" type="success" size="small" :disabled="op_supplier || !hasGeneratedInvoices" @click="handleInvoiceBatch" class="invoice-button">开具供应商发票</el-button>
				</div>
			</div>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.invoice-body-wrapper {
	height: 100%;
	max-height: 100%;
	display: flex;
	flex-direction: column;
	overflow: hidden;
}

.invoice-card {
	height: 100%;
	max-height: 100%;
	display: flex;
	flex-direction: column;
	box-shadow: none;
	border: none;
	background: transparent;
	overflow: hidden;

	::v-deep .el-card__header {
		padding: 12px 16px;
		border-bottom: 1px solid rgba(0, 0, 0, 0.08);
		flex-shrink: 0;
		background: transparent;

		.card-header {
			margin: 0;
		}
	}

	::v-deep .el-card__body {
		flex: 1;
		min-height: 0;
		padding: 16px;
		overflow: hidden;
		display: flex;
		flex-direction: column;
		background: transparent;
	}
}

.invoice-content {
	height: 100%;
	min-height: 0;
	display: flex;
	flex-direction: column;
	overflow: hidden;
}

.bold-text {
	font-weight: bold;
	color: #161617;
	font-size: 14px;
}

.info-section {
	flex: 0 0 auto;
	margin-bottom: 16px;
	padding: 12px;
	background-color: #f8f9fa;
	border-radius: 4px;
	border: none;
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
	min-height: 0;
	max-height: calc(100% - 140px); /* 减去 info-section 和 options 的高度 */
	overflow-y: auto;
	margin-bottom: 16px;
	border: none;
	border-radius: 0;
	padding: 8px;
	background-color: transparent;

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
	flex: 0 0 auto;
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 12px 0;
	border-top: none;

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
