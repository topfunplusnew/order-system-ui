import { getGoodsOrder, listGoodsOrder } from '../../../../api/system/goodsOrder';
import { fix } from '../../../../api/tool/format';
import { listOrderDetail } from '@/api/system/orderDetail';
import { RebateType } from '@/api/tool/enums';

export var mixin_choose_order = {
	data() {
		return {
			// 选中货物 这个是最终要传递给后端的id数组
			goods: [],
			// 点击选择订单后 选择订单的显示
			orderSelectVisible: false,
			// 选择供应商出来的搜索
			queryParamsSupplier: {
				supplier: '',
				params: {
					beginTime: null,
					endTime: null
				}
			},
			// 供应商筛选  供应商列表名称 可以通过list拿
			nameFilters: [],
			// 已经选择的订单货物弹窗
			orderGoodsVisible: false,
			// 已选择的货物列表
			orderDetailInfoList: [],
			// 查看订单详情
			checkOrderInformation: {},
			// 查看订单信息
			orderVisible: false,
			// 选择供应商
			orderBySupplierVisible: false,
			// 筛选的订单详情列表
			needToSelectOrderDetailList: [],
			orderDetailTotal: 0,
			orderGoodsListVisible: false
		};
	},
	methods: {
		// 点击选择订单
		selectOrderItem() {
			listGoodsOrder(this.queryOrderParams).then(res => {
				this.selectOrdersList = res.rows;
				this.orderTotal = res.total;
				this.orderSelectVisible = true;
			});
		},
		// 两种方式 一种是直接选订单 另一种是先选供应商 再选订单
		// 1.根据供应商选择
		selectBySupplier() {
			this.orderBySupplierVisible = true;
		},
		// 供应商自动填充
		handleCommitCompany(val) {
			this.queryParamsSupplier.supplier = val.companyName;
		},
		getDetailBySupper(query) {
			const qs = {
				...query,
				supplier: this.queryParamsSupplier.supplier,
				params: {
					beginTime: this.queryParamsSupplier.params.beginTime,
					endTime: this.queryParamsSupplier.params.endTime
				}
			};
			// 点击选择供应商和时间段后 查询列表 然后弹出选择货物详情
			listOrderDetail(qs).then(res => {
				if (!res.rows) {
					this.$message.info('暂时没有数据');
					return;
				}
				this.needToSelectOrderDetailList = res.rows;
				this.orderGoodsListVisible = true;
				this.orderDetailTotal = res.total;
			});
		},
		// 确认选择供应商
		handleCommitSupplier() {
			this.getDetailBySupper(this.queryParamsSupplier);
		},
		// 2. 直接选择订单
		// 点击选择订单弹出的订单列表页选择某个订单 需要自动填充信息
		handleSelectOrderItem(row) {
			// 先重新重置选中的货物信息
			this.goods = [];
			// 获取订单信息 拿到货物的信息
			getGoodsOrder(row.id).then(res => {
				// 拿到订单的信息
				this.orderInfo = res.data;
				// 拿到订单的货物信息
				this.orderDetailList = res.data.orderDetailList;
				// 补充供应商信息
				this.nameFilters = this.orderDetailList.map(item => {
					return {
						text: item.supplier,
						value: item.supplier
					};
				});
				// 关闭弹窗
				this.orderSelectVisible = false;
			});
		},
		// 查看订单信息
		checkOrderInfo(row) {
			getGoodsOrder(row.id).then(res => {
				this.checkOrderInformation = res.data;
				this.orderVisible = true;
			});
		},
		// 这个多选框每次都会返回一个数组 表示当前已经选中的货物
		// 订单多选
		handleSelectionChangeOrders(selection) {
			this.goods = [];
			this.goods = selection;
		},
		// 多选某个货物
		handleSelectionChangeOrderDetail(selection) {
			this.goods = [];
			this.goods = selection;
		},
		// 选择需要返利的订单进行返利
		handleSelectOrderDetailChange(selection) {
			this.goods = [];
			this.goods = selection;
			this.orderGoodsListVisible = false;
			this.orderBySupplierVisible = false;
			this.submitSelectOrderDetail();
		},
		// 查看已选择的货物
		checkSelectedGoods() {
			this.orderGoodsVisible = true;
		},
		// 确认选择 货物的列表 点击后 会把goods数组中的id 放到form中
		// 计算重箱和面积并且将选择的货物放入body
		submitSelectOrderDetail() {
			this.form.orderDetailIds = [];
			if (!this.goods || this.goods.length < 0) {
				this.$message.info('请选择货物');
				return;
			}
			// 计算重箱和面积的和
			const result = this.goods.reduce(
				(prev, next) => {
					// 累加面积 - 修改计算公式为：长度*宽度*出场片数/1000000
					prev.area += (next.length * next.width * next.pieces) / 1000000;
					// 累加重箱
					prev.weightBox += (next.height * next.length * next.width * next.pieces) / 1000000 / 20;
					return prev;
				},
				{ area: 0, weightBox: 0 } // 初始值
			);
			// 推入id数组
			this.goods.forEach(item => {
				this.form.orderDetailIds.push(item.id);
			});
			// 判断一下是重箱还是面积
			if (this.form.rebateMethod === RebateType.Weight) {
				this.form.weightBox = result.weightBox || 0;
			} else {
				this.form.area = result.area || 0;
			}
			// 修复精度
			this.form.rebate = fix((this.form.area || this.form.weightBox) * this.form.unitPrice);
			this.orderDialogVisible = false;
		},
		// 清空已选择的货物
		refreshSelectedGoods() {
			this.goods = [];
			this.form.orderDetailIds = [];
			this.toggleSelection();
		},
		// 清除选择
		toggleSelection(rows) {
			if (rows) {
				rows.forEach(row => {
					this.$refs.multipleTable.toggleRowSelection(row);
				});
			} else {
				this.$refs.multipleTable.clearSelection();
			}
		}
	}
};
