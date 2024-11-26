// 运费一键申请
import { DocumentNumber } from '../../../../api/tool/enums';
import { parseTime } from '../../../../utils/ruoyi';
import { mapGetters } from 'vuex';
import { listGoodsOrder } from '../../../../api/system/goodsOrder';

export var mixin_credentials_generation_orderlist = {
	data: function () {
		return {
			// 订单票据生成的弹窗
			orderDialogVisible: false,
			// 选中的要生成的订单列表
			selectedNeedOrderList: [],
			needToMakeList: [],
			// 检查订单的页面
			CheckDialogVisible: false,
			// 票据类型 用于区分票据生成
			DOC_TYPE: ''
		};
	},
	computed: {
		...mapGetters(['trueName'])
	},
	// 监听选择的单据类型 如果是订单，那么就显示订单列表 选择生成单据
	watch: {
		type: {
			handler(val) {
				// 赋值类型 根据这个类型来决定渲染哪一个组件
				this.DOC_TYPE = val;
				this.$message.info('type:' + this.DOC_TYPE);
				this.orderDialogVisible = true;
			},
			deep: true
		}
	},
	methods: {
		// 生成凭证
		makeCredentials() {
			this.CheckDialogVisible = true;
		},
		// 订单确认生成凭证 分两类 一种是订单的运费 总货款 出厂贷款的凭证生成  一种是票点的 包含 买入 卖出 第三方
		submitMakeCredentials() {
			// 根据类型生成
			switch (this.DOC_TYPE) {
				case DocumentNumber.GOODS_ORDER:
					// 如果是第一类凭证
					this.makeCredentialsFirst('orderId');
					break;
				case DocumentNumber.INVOICE_IN:
					// 如果是第二类凭证 即发票 如果是买入
					this.makeCredentialsSecond(invoiceIn, 'voiceIn');
					break;
				case DocumentNumber.INVOICE_OUT:
					// 如果是第二类凭证 即发票 如果是卖出
					this.makeCredentialsSecond(invoiceOut, 'voiceOt');
					break;
				case DocumentNumber.INVOICE_OTHER:
					// 第三方特殊处理
					this.makeCredentialsSecond(invoiceOther, 'voiceTr');
					break;
				case DocumentNumber.INVENTORY:
					this.makeCredentialsInventory('inventory');
					break;
			}
			this.CheckDialogVisible = false;
			this.orderDialogVisible = false;

			// 发票买入生成凭证函数
			function invoiceIn(item, strings) {
				// 买入的逻辑 借 主营业务成本-票点成本  票点金额成本(金额)
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '主营业务成本-票点成本',
					lender: item.invoiceAmount,
					borrower: '',
					comments: '无',
					amount: item.invoiceAmount,
					// 基本信息
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: item.isOrderTax,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
				// 贷 应付账款 - 供应商往来 - 供应商name   票点金额成本(金额)
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '应付账款-供应商往来-' + item.companyName,
					lender: '',
					borrower: item.invoiceAmount,
					comments: '无',
					amount: item.invoiceAmount,
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: item.isOrderTax,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
			}

			// 发票卖出生成凭证函数
			function invoiceOut(item, strings) {
				// 卖出的逻辑 借 应收账款-客户往来-客户名字 票点收入金额
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '应收账款-客户往来' + item.companyName,
					lender: item.invoiceAmount,
					borrower: '',
					comments: '无',
					amount: item.invoiceAmount,
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: item.isOrderTax,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
				// 贷 主营业务收入-票点收入 票点收入金额
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '主营业务收入-票点收入',
					lender: '',
					borrower: item.invoiceAmount,
					comments: '无',
					amount: item.invoiceAmount,
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: item.isOrderTax,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
			}

			// 第三方 要查询一下订单的id
			async function invoiceOther(item, strings) {
				// 查询订单id
				const res = await listGoodsOrder({ ordersNo: item.ordersNo });
				// 拿到订单id
				const orderId = res.rows[0].id;
				// 同时有买入和卖出 客户是卖出 供应商是买入
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '主营业务成本-票点成本',
					lender: item.invoiceAmount,
					borrower: '',
					comments: '无',
					amount: item.invoiceAmount,
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: orderId,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '应付账款-供应商往来-' + item.Supplier,
					lender: '',
					borrower: item.invoiceAmount,
					comments: '无',
					amount: item.invoiceAmount,
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: orderId,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '应收账款-客户往来' + item.customer,
					lender: item.invoiceAmount,
					borrower: '',
					comments: '无',
					amount: item.invoiceAmount,
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: orderId,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
				this.needToMakeList.push({
					quote: parseTime(new Date()),
					voucherType: '主营业务收入-票点收入',
					lender: '',
					borrower: item.invoiceAmount,
					comments: '无',
					amount: item.invoiceAmount,
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: orderId,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
			}
		},
		// strings 是凭证编号前面的代码 用于区分凭证信息
		// 生成第一类凭证 订单的运费 总货款 出厂贷款的凭证生成
		makeCredentialsFirst(strings) {
			// 1. 如果出厂货款大于0 贷 应付账款 - 供应商往来 - 宁夏xxxxx 供应商名字 金额 2271.46  **注意一个订单多个供应商  group by 供应商分组 *
			function makeSupplierVoucher(item, strings) {
				if (item.supplierNames) {
					// 获取供应商列表 分组添加
					item.orderDetailList.forEach(element => {
						// 贷方
						this.needToMakeList.push({
							quote: parseTime(new Date()) + element.supplier + '进货',
							voucherType: '应付账款-供应商往来-' + element.supplier,
							lender: '',
							borrower: element.paymentFactory,
							comments: element.supplier,
							amount: element.paymentFactory,
							// 基本信息
							voucherNo:
								`${strings}_` +
								this.selectedNeedOrderList.map(item => item.id).join('_') +
								'_',
							pid: item.id,
							vDate: parseTime(new Date()),
							makeUser: this.trueName
						});
						// 借方
						this.needToMakeList.push({
							quote: parseTime(new Date()) + element.supplier + '进货',
							voucherType: '主营业务成本-玻璃成本',
							lender: element.paymentFactory,
							borrower: '',
							comments: '无',
							amount: element.paymentFactory,
							// 基本信息
							voucherNo:
								`${strings}_` +
								this.selectedNeedOrderList.map(item => item.id).join('_') +
								'_',
							pid: item.id,
							vDate: parseTime(new Date()),
							makeUser: this.trueName
						});
					});
				}
			}

			// 2. 总货款 借  应收账款 - 客户往来 - - 客户名称    总货款  2271.46 // 贷 主营业务收入 - 玻璃收入 - 金额 总货款  2271.46
			function makeCustomerVoucher(item, strings) {
				if (item.allPayments > 0) {
					// 贷方
					this.needToMakeList.push({
						quote: parseTime(new Date()) + item.customer + '进货',
						voucherType: '主营业务收入-玻璃收入-金额',
						lender: item.allPayments,
						borrower: '',
						comments: item.customer,
						amount: item.allPayments,
						// 基本信息
						voucherNo:
							`${strings}_` +
							this.selectedNeedOrderList.map(item => item.id).join('_') +
							'_',
						pid: item.id,
						vDate: parseTime(new Date()),
						makeUser: this.trueName
					});
					// 借方
					this.needToMakeList.push({
						quote: parseTime(new Date()) + item.customer + '进货',
						voucherType: '应收账款-客户往来-' + item.customer,
						lender: '',
						borrower: item.allPayments,
						comments: '无',
						amount: item.allPayments,
						// 基本信息
						voucherNo:
							`${strings}_` +
							this.selectedNeedOrderList.map(item => item.id).join('_') +
							'_',
						pid: item.id,
						vDate: parseTime(new Date()),
						makeUser: this.trueName
					});
				}
			}

			// 3. 运费  借  主营业务成本-运费成本 - 68.25  运费 海运陆运之和  贷  应付运费 - 陆运   应付运费 - 海运  分开写填运费
			function makeFreightVoucher(item, strings) {
				if (item.landFreight || item.seaFreight) {
					// 贷方
					this.needToMakeList.push({
						quote: parseTime(new Date()) + '运费',
						voucherType: '应付运费-陆运',
						lender: '',
						borrower: item.landFreight,
						comments: item.landCarNo,
						amount: item.landFreight,
						// 基本信息
						voucherNo:
							`${strings}_` +
							this.selectedNeedOrderList.map(item => item.id).join('_') +
							'_',
						pid: item.id,
						vDate: parseTime(new Date()),
						makeUser: this.trueName
					});
					if (item.seaFreight) {
						this.needToMakeList.push({
							quote: parseTime(new Date()) + '运费',
							voucherType: '应付运费-海运',
							lender: '',
							borrower: item.seaFreight,
							comments: item.seaCarNo,
							amount: item.seaFreight,
							// 基本信息
							voucherNo:
								`${strings}_` +
								this.selectedNeedOrderList.map(item => item.id).join('_') +
								'_',
							pid: item.id,
							vDate: parseTime(new Date()),
							makeUser: this.trueName
						});
					}
					// 借方
					this.needToMakeList.push({
						quote: parseTime(new Date()) + '运费',
						voucherType: '主营业务成本-运费成本',
						lender: item.landFreight + item.seaFreight,
						borrower: '',
						comments: item.landCarNo,
						amount: item.landFreight + item.seaFreight,
						// 基本信息
						voucherNo:
							`${strings}_` +
							this.selectedNeedOrderList.map(item => item.id).join('_') +
							'_',
						pid: item.id,
						vDate: parseTime(new Date()),
						makeUser: this.trueName
					});
				}
			}

			// 生成
			this.selectedNeedOrderList.forEach(item => {
				makeSupplierVoucher.call(this, item, strings);
				makeCustomerVoucher.call(this, item, strings);
				makeFreightVoucher.call(this, item, strings);
			});
		},
		// 生成第二类凭证  分为买入 和 卖出 需要查询订单信息
		makeCredentialsSecond(callback, strings) {
			this.$message.success('制作票点凭证');
			// 生成
			this.selectedNeedOrderList.forEach(item => {
				callback.call(this, item, strings);
			});
		},
		// 生成库存凭证
		makeCredentialsInventory(strings) {
			// 生成凭证逻辑函数
			function makeInventoryVoucher(item, strings) {
				// 贷方
				this.needToMakeList.push({
					quote: parseTime(new Date()) + item.supplier + '进货',
					voucherType: '应付账款-供应商往来-' + item.supplier,
					lender: '',
					borrower: item.paymentFactory,
					comments: item.supplier,
					amount: item.paymentFactory,
					// 基本信息
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: item.id,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
				// 借方
				this.needToMakeList.push({
					quote: parseTime(new Date()) + item.supplier + '进货',
					voucherType: '主营业务成本-玻璃成本',
					lender: item.paymentFactory,
					borrower: '',
					comments: '无',
					amount: item.paymentFactory,
					// 基本信息
					voucherNo:
						`${strings}_` +
						this.selectedNeedOrderList.map(item => item.id).join('_') +
						'_',
					pid: item.id,
					vDate: parseTime(new Date()),
					makeUser: this.trueName
				});
				// 生成运费凭证
				if (item.landFreight || item.seaFreight) {
					// 贷方
					this.needToMakeList.push({
						quote: parseTime(new Date()) + '运费',
						voucherType: '应付运费-陆运',
						lender: '',
						borrower: item.landFreight,
						comments: item.landCarNo,
						amount: item.landFreight,
						// 基本信息
						voucherNo:
							`${strings}_` +
							this.selectedNeedOrderList.map(item => item.id).join('_') +
							'_',
						pid: item.id,
						vDate: parseTime(new Date()),
						makeUser: this.trueName
					});
					if (item.seaFreight) {
						this.needToMakeList.push({
							quote: parseTime(new Date()) + '运费',
							voucherType: '应付运费-海运',
							lender: '',
							borrower: item.seaFreight,
							comments: item.seaCarNo,
							amount: item.seaFreight,
							// 基本信息
							voucherNo:
								`${strings}_` +
								this.selectedNeedOrderList.map(item => item.id).join('_') +
								'_',
							pid: item.id,
							vDate: parseTime(new Date()),
							makeUser: this.trueName
						});
					}
					// 借方
					this.needToMakeList.push({
						quote: parseTime(new Date()) + '运费',
						voucherType: '主营业务成本-运费成本',
						lender: item.landFreight + item.seaFreight,
						borrower: '',
						comments: item.landCarNo,
						amount: item.landFreight + item.seaFreight,
						// 基本信息
						voucherNo:
							`${strings}_` +
							this.selectedNeedOrderList.map(item => item.id).join('_') +
							'_',
						pid: item.id,
						vDate: parseTime(new Date()),
						makeUser: this.trueName
					});
				}
			}

			// 首先对选择的每一条库存数据进行处理
			this.selectedNeedOrderList.forEach(item => {
				makeInventoryVoucher.call(this, item, strings);
			});
			this.$message.success('制作库存凭证');
		},
		// 获取出厂货款
		getPaymentFactory(row) {
			return row.orderDetailList.reduce((pre, cur) => {
				return pre + cur.paymentFactory;
			}, 0);
		},
		// 获取供应商列表
		getSupplierNames(list) {
			if (list.length === 0) {
				return;
			}
			return list.map(item => {
				return {
					supplier: item.supplier,
					supplierID: item.supplierID
				};
			});
		}
	}
};
