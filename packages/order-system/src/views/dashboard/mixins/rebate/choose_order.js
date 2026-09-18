/*
需求：订单选择支持产品级别、厚度、长度、宽度筛选，并允许跨条件多次追加且保留已选状态。
改动：选择列表由 OrderDetailList 维护跨查询状态，混入层透传已选数据并兼容清空操作。
需求：在"根据供应商选择订单"弹窗选好开始/结束时间后，要带到"根据供应商所选货物列表"弹窗的时间选择器里。
改动：确定时把 orderDateRange 一并传给货物列表（用于选择器回显）。
需求：时间按范围查询。改动（apifox 已更新，params.beginTime/params.endTime 支持范围查找）：
     选择器的 orderDateRange 统一转成 params.beginTime/params.endTime，不再发送 orderDate（避免与范围叠加多筛一次）。
*/
// 以下 import 仅被已注释的旧版 submitSelectOrderDetail 使用，保留备查
// import { fix } from '../../../../api/tool/format';
import { listOrderDetail } from '@/api/system/orderDetail';
import { convertOrderDateRangeToParams, pickFilterValue, resolveBeginEndTime } from './orderDateRange';
// import { RebateType } from '@/api/tool/enums';

export var mixin_choose_order = {
	data() {
		return {
			// 选中货物 这个是最终要传递给后端的id数组
			goods: [],
			// 点击选择订单后 选择订单的显示
			orderSelectVisible: false,
			// 直接搜索全部订单明细的列表
			directOrderDetailList: [],
			directOrderDetailTotal: 0,
			// 选择供应商出来的搜索
			queryParamsSupplier: {
				pageNum: 1,
				pageSize: 20,
				supplier: '',
				levelName: '',
				height: '',
				length: '',
				width: '',
				params: {
					beginTime: null,
					endTime: null
				}
			},
			// 供应商筛选  供应商列表名称 可以通过list拿（rebate/index 未使用）
			// nameFilters: [],
			// 已经选择的订单货物弹窗
			orderGoodsVisible: false,
			// 已选择的货物列表（rebate/index 使用 goods，未使用本字段）
			// orderDetailInfoList: [],
			// 查看订单详情（rebate/index 未使用）
			// checkOrderInformation: {},
			// 查看订单信息（rebate/index 未使用）
			// orderVisible: false,
			// 选择供应商
			orderBySupplierVisible: false,
			// 筛选的订单详情列表
			needToSelectOrderDetailList: [],
			orderDetailTotal: 0,
			orderGoodsListVisible: false
		};
	},
	methods: {
		handleOpenSelectOrder() {
			this.orderSelectVisible = true;
			this.getDirectOrderDetailList({
				pageNum: 1,
				pageSize: 20,
				params: {
					orderDateSort: null
				}
			});
		},
		// 两种方式 一种是直接选订单 另一种是先选供应商 再选订单
		// 1.根据供应商选择
		selectBySupplier() {
			this.orderBySupplierVisible = true;
		},
		// 2. 直接搜索全部订单明细
		getDirectOrderDetailList(query) {
			// 时间选择器用的是 orderDateRange，转换成接口支持的范围参数 params.beginTime/params.endTime
			const { query: baseQuery } = convertOrderDateRangeToParams(query);
			const requestQuery = {
				...baseQuery,
				pageNum: baseQuery.pageNum || 1,
				pageSize: baseQuery.pageSize || 20,
				params: {
					...(baseQuery.params || {})
				}
			};
			// 时间统一由范围参数控制，不再发送 orderDate（避免与范围叠加导致多筛一次）
			delete requestQuery.orderDate;
			listOrderDetail(requestQuery).then(res => {
				this.directOrderDetailList = res.rows || [];
				this.directOrderDetailTotal = res.total || 0;
			});
		},
		// 供应商自动填充
		handleCommitCompany(val) {
			this.queryParamsSupplier.supplier = val.companyName;
		},
		getDetailBySupper(query) {
			// 时间范围：接口已支持 params.beginTime / params.endTime 范围查找，选择器的 orderDateRange 转成这两个字段
			const { query: baseQuery, hasOrderDateRange } = convertOrderDateRangeToParams(query);
			const pageNum = baseQuery.pageNum || this.queryParamsSupplier.pageNum || 1;
			const pageSize = baseQuery.pageSize || this.queryParamsSupplier.pageSize || 20;
			// 筛选条件以「根据供应商所选货物列表」弹窗的表单为准：表单里被清空（'' / null）就按清空处理，
			// 只有表单里完全没有该字段时才回退到「根据供应商选择订单」弹窗的旧值。
			const supplier = pickFilterValue(baseQuery, 'supplier', this.queryParamsSupplier.supplier) || '';
			const levelName = pickFilterValue(baseQuery, 'levelName', this.queryParamsSupplier.levelName) || '';
			const height = pickFilterValue(baseQuery, 'height', this.queryParamsSupplier.height) || '';
			const length = pickFilterValue(baseQuery, 'length', this.queryParamsSupplier.length) || '';
			const width = pickFilterValue(baseQuery, 'width', this.queryParamsSupplier.width) || '';
			// 时间：货物列表弹窗的选择器优先，没有则由「根据供应商选择订单」弹窗的开始/结束时间兜底
			const { beginTime, endTime } = resolveBeginEndTime(baseQuery.params, this.queryParamsSupplier.params, hasOrderDateRange);

			// 回写「根据供应商选择订单」弹窗的时间条件，保证两个弹窗时间显示一致（追加选择时也会沿用）
			this.queryParamsSupplier.params.beginTime = beginTime;
			this.queryParamsSupplier.params.endTime = endTime;

			// ruoyi 的 tansParams 会把 params 对象序列化成 params[xx]
			const qs = {
				...baseQuery,
				pageNum,
				pageSize,
				supplier,
				levelName,
				height,
				length,
				width,
				params: {
					...(baseQuery.params || {}),
					beginTime,
					endTime
				}
			};
			// 时间统一由范围参数控制，不再发送 orderDate（避免与范围叠加导致多筛一次）
			delete qs.orderDate;
			// 点击选择供应商和时间段后 查询列表 然后弹出选择货物详情
			listOrderDetail(qs).then(res => {
				if (!res.rows) {
					this.$message.info('暂时没有数据');
					return;
				}
				// 追加选择时，将上次已选明细并入当前结果，确保可见且保持勾选状态。
				const rowsById = new Map((res.rows || []).filter(row => row && row.id != null).map(row => [String(row.id), row]));
				(this.goods || []).forEach(row => {
					if (row && row.id != null && !rowsById.has(String(row.id))) rowsById.set(String(row.id), row);
				});
				this.needToSelectOrderDetailList = [...rowsById.values()];
				this.orderGoodsListVisible = true;
				this.orderDetailTotal = Math.max(Number(res.total) || 0, this.needToSelectOrderDetailList.length);
				this.$nextTick(() => {
					if (this.restoreAppendSelection) this.restoreAppendSelection();
					setTimeout(() => this.restoreAppendSelection && this.restoreAppendSelection(), 200);
				});
			});
		},
		// 确认选择供应商
		handleCommitSupplier() {
			// 初次进入列表时保证走第一页，避免分页参数缺失
			this.queryParamsSupplier.pageNum = 1;
			const beginTime = this.queryParamsSupplier.params.beginTime || null;
			const endTime = this.queryParamsSupplier.params.endTime || null;
			this.orderDetailInitialQuery = {
				// 货物列表弹窗的时间选择器绑定的是 orderDateRange，把开始/结束时间一起带过去（查询用 params 范围）
				orderDateRange: beginTime || endTime ? [beginTime, endTime] : null,
				supplier: this.queryParamsSupplier.supplier,
				levelName: this.queryParamsSupplier.levelName,
				height: this.queryParamsSupplier.height,
				length: this.queryParamsSupplier.length,
				width: this.queryParamsSupplier.width
			};
			this.getDetailBySupper(this.queryParamsSupplier);
		},
		// 以下方法已在 rebate/index.vue 中重写，混入内保留注释备查
		// 多选某个货物
		// handleSelectionChangeOrderDetail(selection) {
		// 	this.goods = [];
		// 	this.goods = selection;
		// },
		// 选择需要返利的订单进行返利
		// handleSelectOrderDetailChange(selection) {
		// 	this.goods = [];
		// 	this.goods = selection;
		// 	this.orderGoodsListVisible = false;
		// 	this.orderBySupplierVisible = false;
		// 	this.submitSelectOrderDetail();
		// },
		// 查看已选择的货物
		checkSelectedGoods() {
			this.orderGoodsVisible = true;
		}
		// 确认选择货物的列表（旧版：原生运算，已由 rebate/index.vue 的 mathjs 版本替代）
		// submitSelectOrderDetail() {
		// 	this.form.orderDetailIds = [];
		// 	if (!this.goods || this.goods.length < 0) {
		// 		this.$message.info('请选择货物');
		// 		return;
		// 	}
		// 	const result = this.goods.reduce(
		// 		(prev, next) => {
		// 			prev.area += (next.length * next.width * next.pieces) / 1000000;
		// 			prev.weightBox += (next.height * next.length * next.width * next.pieces) / 1000000 / 20;
		// 			return prev;
		// 		},
		// 		{ area: 0, weightBox: 0 }
		// 	);
		// 	this.goods.forEach(item => {
		// 		this.form.orderDetailIds.push(item.id);
		// 	});
		// 	if (this.form.rebateMethod === RebateType.Weight) {
		// 		this.form.weightBox = result.weightBox || 0;
		// 	} else {
		// 		this.form.area = result.area || 0;
		// 	}
		// 	this.form.rebate = fix((this.form.area || this.form.weightBox) * this.form.unitPrice);
		// 	this.orderDialogVisible = false;
		// },
		// 清空已选择的货物
		// refreshSelectedGoods() {
		// 	this.goods = [];
		// 	this.form.orderDetailIds = [];
		// 	this.toggleSelection();
		// },
		// 清除选择（仅被上方已注释的 refreshSelectedGoods 调用）
		// toggleSelection(rows) {
		// 	if (rows) {
		// 		rows.forEach(row => {
		// 			this.$refs.multipleTable.toggleRowSelection(row);
		// 		});
		// 	} else {
		// 		this.$refs.multipleTable.clearSelection();
		// 	}
		// }
	}
};
