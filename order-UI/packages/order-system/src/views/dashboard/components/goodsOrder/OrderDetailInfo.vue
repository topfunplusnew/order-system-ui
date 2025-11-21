<!--订单详情列表-->

<script>
import { addRebate } from '@/api/system/Rebate';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
// 不再通过字典接口获取返利方式，使用硬编码选项
import { fix, fix_2 } from '@/api/tool/format';
import { RebateType } from '@/api/tool/enums';
import ExpandCursor from '../common/ExpandCursor.vue';

export default {
	name: 'OrderDetailInfo',
	components: { SearchOption, ExpandCursor },
	props: {
		orderDetailInfoList: {
			type: Array,
			default: () => []
		},
		ban: {
			type: Boolean,
			default: false
		}
	},
	computed: {
		filteredOrderDetailInfoList() {
			// 显示所有行，包括没有备注的行
			return this.orderDetailInfoList;
		},
		RebateType() {
			return RebateType;
		}
	},
	data() {
		return {
			addMoneyBackVisible: false,
			// 控制表格展开行的keys
			expandRowKeys: [],
			// 列宽度配置
			columnWidths: {
				action: '100px', // 操作列：按钮文字"货物返利"
				storeHouseName: '100px', // 仓库名称：通常较短
				supplier: '180px', // 供应商：公司名称可能较长
				levelName: '120px', // 级别名称：级别名称通常不会太长
				countingUnit: '90px', // 计量单位：单位名称较短
				height: '50px', // 厚度：数字较短
				length: '50px', // 长度：数字较短
				width: '50px', // 宽度：数字较短
				piecesPerPack: '50px', // 每包片数：数字
				packs: '50px', // 包数：数字较短
				pieces: '50px', // 出厂片数：数字
				price: '110px', // 出厂单价：价格数字
				isIncludeTaxFactory: '110px', // 出厂是否含税："是/否"标签
				sundryCost: '90px', // 杂费：金额数字
				paymentFactory: '120px', // 出厂货款：金额数字
				actualPieces: '90px', // 卸货片数：数字
				paymentUnload: '110px', // 卸货价：价格数字
				isIncludeTaxSale: '110px', // 销售是否含税："是/否"标签
				paymentsWithSundry: '120px', // 总货款杂费：金额数字
				payments: '120px', // 总货款：金额数字
				erro: '70px', // 误差：数字较短
				tonnage: '90px', // 吨位：数字+单位
				landFreightPrice: '120px', // 陆运费单价：价格数字
				additionalFees: '90px', // 加费：金额数字
				landFreight: '100px', // 陆运费：金额数字
				seaFreight: '100px', // 海运费：金额数字
				freight: '100px', // 总运费：金额数字
				otherCost: '100px', // 其他费用：金额数字
				profit: '110px', // 利润：金额数字
				profitNoTax: '120px', // 不含税利润：金额数字
				logisticsProfit: '110px', // 物流利润：金额数字
				customerCommission: '110px', // 客户佣金：金额数字
				factoryCommission: '110px', // 厂家佣金：金额数字
				factoryRebateAmount: '140px', // 计提厂家返利金额：金额数字，列名较长
				factoryDiscountAmount: '140px', // 计提厂家降价金额：金额数字，列名较长
				comments: '120px' // 备注：可能需要显示较长文本
			},
			// 返利回扣信息
			moneyBackInfo: {
				// 后端期望的是 orderDetailIds 数组
				orderDetailIds: [],
				rebateDate: '',
				// （返利/降价）单价
				unitPrice: null,
				// 最终金额
				rebate: '',
				// 使用 RebateType 常量（Weight / Square）
				rebateMethod: RebateType.Weight,
				// 供应商/账号信息
				inAcountsName: '',
				inBankNo: '',
				supplier: '',
				outAcountsName: '',
				outBankNo: '',
				rebateReason: '',
				comments: '',
				// 计算字段：面积 / 重箱
				area: 0,
				weightBox: 0
			},
			// 硬编码的返利方式：重箱(Weight)、面积(Square)，值使用 RebateType
			rebateMethods: [
				{ dictValue: RebateType.Weight, dictLabel: '重箱' },
				{ dictValue: RebateType.Square, dictLabel: '面积' }
			],
			loading: false
		};
	},
	watch: {
		// 监听订单详情列表变化，更新默认展开的行
		orderDetailInfoList: {
			handler(newVal) {
				this.updateExpandRows(newVal);
				// 数据变化后重新计算列宽
				if (newVal && newVal.length > 0) {
					this.$nextTick(() => {
						this.$nextTick(() => {
							this.fitColumns();
						});
					});
				}
			},
			immediate: true
		}
	},
	mounted() {
		// 组件挂载后，等待DOM渲染完成再调整列宽
		this.$nextTick(() => {
			this.$nextTick(() => {
				setTimeout(() => {
					if (this.filteredOrderDetailInfoList && this.filteredOrderDetailInfoList.length > 0) {
						this.fitColumns();
					}
				}, 100);
			});
		});

		// 监听窗口大小变化，重新调整列宽
		this.handleResize = this.debounce(() => {
			this.fitColumns();
		}, 300);
		window.addEventListener('resize', this.handleResize);
	},
	beforeDestroy() {
		// 移除窗口大小变化监听
		if (this.handleResize) {
			window.removeEventListener('resize', this.handleResize);
		}
	},
	// 不再需要在 created 中请求字典，返利方式已硬编码
	methods: {
		listBankAccount,
		listCompany,
		// 更新默认展开的行
		updateExpandRows(list) {
			// 如果有需要展开的行，可以在这里处理
			// 暂时保留空实现，避免报错
		},
		// 原生列宽自动调整方法
		fitColumns() {
			if (!this.$refs.tableRef) {
				return;
			}

			// 确保表格有数据
			if (!this.filteredOrderDetailInfoList || this.filteredOrderDetailInfoList.length === 0) {
				return;
			}

			// 先调用表格的 doLayout 方法，确保表格布局完成
			this.$refs.tableRef.doLayout();

			// 使用 requestAnimationFrame 确保在浏览器下一次重绘时执行
			requestAnimationFrame(() => {
				setTimeout(() => {
					if (this.$refs.tableRef) {
						try {
							this.autoFitColumns();
						} catch (error) {
							console.warn('调整列宽失败:', error);
						}
					}
				}, 100);
			});
		},
		// 原生实现：自动调整表格列宽（简化版本，确保表头和表体对齐）
		autoFitColumns() {
			const table = this.$refs.tableRef.$el;
			if (!table) return;

			// 先调用 doLayout 确保表格结构完整
			this.$refs.tableRef.doLayout();

			// 等待表格完全渲染
			this.$nextTick(() => {
				setTimeout(() => {
					const mainColgroup = table.querySelector('colgroup');
					if (!mainColgroup) return;

					const colDefs = Array.from(mainColgroup.querySelectorAll('col'));
					const columnWidths = {};

					// 获取表格列配置
					const tableColumns = this.$refs.tableRef.columns || [];

					// 计算每列的最大内容宽度
					colDefs.forEach((col, colIndex) => {
						const colName = col.getAttribute('name');
						if (!colName) return;

						const headerCells = Array.from(table.querySelectorAll(`th.${colName}`));
						const bodyCells = Array.from(table.querySelectorAll(`td.${colName}`));

						if (headerCells.length === 0 && bodyCells.length === 0) return;

						// 检查是否应该跳过此列（如操作列）
						const firstCell = headerCells[0] || bodyCells[0];
						if (firstCell && firstCell.classList.contains('leave-alone')) {
							return;
						}

						let maxWidth = 0;

						// 获取列配置
						const column = tableColumns[colIndex];
						const columnProp = column ? column.property : null;

						// 测量表头宽度
						// if (headerCells.length > 0) {
						//   const headerCell = headerCells[0];
						//   const headerContent = headerCell.querySelector('.cell');
						//   if (headerContent) {
						//     const headerText = headerContent.textContent || headerContent.innerText || '';
						//     const headerStyle = window.getComputedStyle(headerContent);
						//     const tempDiv = document.createElement('div');
						//     tempDiv.style.cssText = `
						//       position: absolute;
						//       visibility: hidden;
						//       white-space: nowrap;
						//       font-size: ${headerStyle.fontSize};
						//       font-family: ${headerStyle.fontFamily};
						//       font-weight: ${headerStyle.fontWeight};
						//       padding: 0;
						//       margin: 0;
						//       left: -9999px;
						//       top: -9999px;
						//     `;
						//     tempDiv.textContent = headerText;
						//     document.body.appendChild(tempDiv);
						//     maxWidth = Math.max(maxWidth, tempDiv.offsetWidth);
						//     document.body.removeChild(tempDiv);
						//   }
						// }

						// 测量数据单元格宽度（从数据源获取完整文本）
						if (columnProp && this.filteredOrderDetailInfoList && this.filteredOrderDetailInfoList.length > 0) {
							this.filteredOrderDetailInfoList.forEach(row => {
								let cellText = '';
								const value = row[columnProp];

								if (value !== null && value !== undefined) {
									if (columnProp === 'isIncludeTaxFactory' || columnProp === 'isIncludeTaxSale') {
										cellText = value == 0 ? '否' : '是';
									} else {
										cellText = String(value);
									}
								}

								if (cellText) {
									// 获取第一个数据单元格的样式作为参考
									const styleRef = bodyCells[0]?.querySelector('.cell') || headerCells[0]?.querySelector('.cell');
									if (styleRef) {
										const computedStyle = window.getComputedStyle(styleRef);
										const tempDiv = document.createElement('div');
										tempDiv.style.cssText = `
                      position: absolute;
                      visibility: hidden;
                      white-space: nowrap;
                      font-size: ${computedStyle.fontSize};
                      font-family: ${computedStyle.fontFamily};
                      font-weight: ${computedStyle.fontWeight};
                      padding: 0;
                      margin: 0;
                      left: -9999px;
                      top: -9999px;
                    `;
										tempDiv.textContent = cellText;
										document.body.appendChild(tempDiv);
										maxWidth = Math.max(maxWidth, tempDiv.offsetWidth);
										document.body.removeChild(tempDiv);
									}
								}
							});
						}

						// 设置列宽 - 只添加最小间距，让文字刚好显示
						if (maxWidth > 0) {
							const padding = 0; // 最小间距，确保文字不被截断
							const finalWidth = Math.max(maxWidth + padding, 60);
							columnWidths[colName] = finalWidth;
						}
					});

					// 统一更新所有 colgroup 中的列宽（确保表头和表体同步）
					const allColgroups = table.querySelectorAll('colgroup');
					allColgroups.forEach(colgroup => {
						Object.keys(columnWidths).forEach(colName => {
							const cols = colgroup.querySelectorAll(`col[name="${colName}"]`);
							cols.forEach(colEl => {
								colEl.setAttribute('width', columnWidths[colName]);
								colEl.style.width = `${columnWidths[colName]}px`;
								colEl.style.minWidth = `${columnWidths[colName]}px`;
								colEl.style.maxWidth = `${columnWidths[colName]}px`;
							});
						});
					});

					// 强制表格重新布局，确保对齐
					this.$refs.tableRef.doLayout();

					// 再次确保同步
					this.$nextTick(() => {
						this.$refs.tableRef.doLayout();
					});
				}, 150);
			});
		},
		// 防抖函数
		debounce(func, wait) {
			let timeout;
			return function executedFunction(...args) {
				const later = () => {
					clearTimeout(timeout);
					func(...args);
				};
				clearTimeout(timeout);
				timeout = setTimeout(later, wait);
			};
		},
		// 处理表头点击事件（如果需要）
		handleHeaderClick(column, event) {
			// 表头点击后重新调整列宽
			this.$nextTick(() => {
				this.fitColumns();
			});
		},
		tableRowClassName({ row }) {
			// 所有行都显示展开图标
			return 'expandable-row';
		},

		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			const summaryColumns = ['paymentFactory', 'payments', 'tonnage', 'landFreight', 'seaFreight', 'freight', 'profit', 'profitNoTax', 'sundryCost', 'paymentsWithSundry'];

			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				// 如果列没有属性（如expand列、操作列），跳过计算
				if (!column.property) {
					return;
				}

				if (summaryColumns.includes(column.property)) {
					const values = data.map(item => Number(item[column.property]));
					if (!values.every(value => isNaN(value))) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = fix_2(sums[index]);
						sums[index] += column.property === 'tonnage' ? ' 吨' : ' 元';
					} else {
						sums[index] = 'N/A';
					}
				}
			});

			return sums;
		},

		// 每一个组件必须要实现的方法
		handleProcess(that) {
			that.dialogVisible = false;
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		// 点击确认
		handleCommitBankAccount(val) {
			this.moneyBackInfo.inAcountsName = val.acountsName;
			this.moneyBackInfo.inBankNo = val.bankNo;
		},
		handleCommitCompany(val) {
			this.moneyBackInfo.supplierID = val.id;
			this.moneyBackInfo.supplier = val.companyName;
		},
		// 返利回扣（从行创建）
		handleMoneyBack(row) {
			this.reset();
			// 通过行确定订单明细 id
			this.moneyBackInfo.orderDetailIds = [row.id];
			// 按照 rebate/index.vue 的公式计算该行的面积与重箱
			const area = (Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000 || 0;
			const weightBox = (Number(row.height) * Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000 / 20 || 0;
			this.moneyBackInfo.area = area;
			this.moneyBackInfo.weightBox = weightBox;
			// 默认选重箱（与主页面一致）
			this.moneyBackInfo.rebateMethod = RebateType.Weight;
			this.addMoneyBackVisible = true;
		},
		// 添加返利回扣信息（提交前计算金额并转换 rebateMethod）
		addMoneyBackInfo() {
			// 计算金额：根据选择的返利方式，使用面积或重箱乘以单价
			const base = this.moneyBackInfo.rebateMethod === RebateType.Weight ? this.moneyBackInfo.weightBox : this.moneyBackInfo.area;
			const unit = Number(this.moneyBackInfo.unitPrice) || 0;
			this.moneyBackInfo.rebate = fix_2((base || 0) * unit);
			// 不要直接修改组件使用的 rebateMethod（仍为 RebateType），为后端构造 payload 时转换为 1/2
			const payload = Object.assign({}, this.moneyBackInfo, {
				rebateMethod: this.moneyBackInfo.rebateMethod === RebateType.Weight ? 1 : 2
			});
			addRebate(payload).then(res => {
				this.$message.success('添加成功~');
				this.addMoneyBackVisible = false;
			});
		},
		// 重置moneyBackInfo
		reset() {
			this.moneyBackInfo = {
				orderDetailIds: [],
				rebateDate: '',
				unitPrice: null,
				rebate: '',
				rebateMethod: RebateType.Weight,
				inAcountsName: '',
				inBankNo: '',
				supplier: '',
				outAcountsName: '',
				outBankNo: '',
				rebateReason: '',
				comments: '',
				area: 0,
				weightBox: 0
			};
		},
		// 处理展开行变化
		handleExpandChange(row, expandedRows) {
			// 展开/收起行后重新调整列宽
			this.$nextTick(() => {
				this.fitColumns();
			});
		},
		// 处理表格滚动（可选，用于某些场景下的列宽调整）
		handleTableScroll() {
			// 滚动时不需要调整列宽，避免性能问题
		}
	}
};
</script>

<template>
	<div>
		<!-- 固定标题区域 -->
		<el-row v-fixed="{ position: 'top', zIndex: 1000 }" style="background-color: #fff; padding: 10px 0">
			<el-col :span="8">
				<span style="font-weight: bolder">订单货物详情列表</span>
			</el-col>
		</el-row>
		<el-row>
			<el-table
				ref="tableRef"
				border
				:data="filteredOrderDetailInfoList"
				row-key="id"
				max-height="700"
				fit
				:cell-style="() => ({ padding: '0', textAlign: 'center' })"
				:header-cell-style="{ padding: '0', textAlign: 'center' }"
				size="mini"
				show-summary
				:summary-method="getSummaries"
				:row-class-name="tableRowClassName"
				:expand-row-keys="expandRowKeys"
				@header-click="handleHeaderClick"
				@expand-change="handleExpandChange"
			>
				<el-table-column v-if="!ban" label="操作" align="center" class-name="small-padding fixed-width leave-alone" fixed="left" :min-width="columnWidths.action">
					<template slot-scope="scope">
						<el-button size="mini" type="warning" @click="handleMoneyBack(scope.row)">货物返利</el-button>
					</template>
				</el-table-column>
				<el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip :min-width="columnWidths.storeHouseName">
					<!--          如果有 显示 如果没有 显示- -->
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.storeHouseName ? scope.row.storeHouseName : '-' }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="供应商" align="center" prop="supplier" :min-width="columnWidths.supplier">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.supplier }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="级别名称" align="center" prop="levelName" show-overflow-tooltip :min-width="columnWidths.levelName">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.levelName }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip :min-width="columnWidths.countingUnit">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.countingUnit }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="厚度" align="center" prop="height" :min-width="columnWidths.height">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.height }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="长度" align="center" prop="length" :min-width="columnWidths.length">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.length }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="宽度" align="center" prop="width" :min-width="columnWidths.width">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.width }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="每包片数" align="center" prop="piecesPerPack" :min-width="columnWidths.piecesPerPack">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.piecesPerPack }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="包数" align="center" prop="packs" :min-width="columnWidths.packs">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.packs }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="出厂片数" align="center" prop="pieces" :min-width="columnWidths.pieces">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.pieces }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip :min-width="columnWidths.price">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.price }}
						</ExpandCursor>
					</template>
				</el-table-column>

				<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip :min-width="columnWidths.isIncludeTaxFactory">
					<template slot-scope="scope">
						<ExpandCursor>
							<el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory == 0 ? '否' : '是' }}</el-tag>
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="杂费" align="center" prop="sundryCost" :min-width="columnWidths.sundryCost">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.sundryCost }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip :min-width="columnWidths.paymentFactory">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.paymentFactory }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="卸货片数" align="center" prop="actualPieces" show-overflow-tooltip :min-width="columnWidths.actualPieces">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.actualPieces }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="卸货价" align="center" prop="paymentUnload" show-overflow-tooltip :min-width="columnWidths.paymentUnload">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.paymentUnload }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip :min-width="columnWidths.isIncludeTaxSale">
					<template slot-scope="scope">
						<ExpandCursor>
							<el-tag disable-transitions>{{ scope.row.isIncludeTaxSale == 0 ? '否' : '是' }}</el-tag>
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" show-overflow-tooltip :min-width="columnWidths.paymentsWithSundry">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.paymentsWithSundry }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip :min-width="columnWidths.payments">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.payments }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip :min-width="columnWidths.erro">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.erro }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip :min-width="columnWidths.tonnage">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.tonnage }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip :min-width="columnWidths.landFreightPrice">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.landFreightPrice }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="加费" align="center" prop="additionalFees" show-overflow-tooltip :min-width="columnWidths.additionalFees">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.additionalFees }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip :min-width="columnWidths.landFreight">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.landFreight }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip :min-width="columnWidths.seaFreight">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.seaFreight }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip :min-width="columnWidths.freight">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.freight }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip :min-width="columnWidths.otherCost">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.otherCost }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip :min-width="columnWidths.profit">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.profit }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip :min-width="columnWidths.profitNoTax">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.profitNoTax }}
						</ExpandCursor>
					</template>
				</el-table-column>

				<el-table-column label="物流利润" align="center" prop="logisticsProfit" show-overflow-tooltip :min-width="columnWidths.logisticsProfit">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.logisticsProfit }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="客户佣金" align="center" prop="customerCommission" show-overflow-tooltip :min-width="columnWidths.customerCommission">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.customerCommission }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="厂家佣金" align="center" prop="factoryCommission" show-overflow-tooltip :min-width="columnWidths.factoryCommission">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.factoryCommission }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="计提厂家返利金额" align="center" prop="factoryRebateAmount" show-overflow-tooltip :min-width="columnWidths.factoryRebateAmount">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.factoryRebateAmount }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column label="计提厂家降价金额" align="center" prop="factoryDiscountAmount" show-overflow-tooltip :min-width="columnWidths.factoryDiscountAmount">
					<template slot-scope="scope">
						<ExpandCursor>
							{{ scope.row.factoryDiscountAmount }}
						</ExpandCursor>
					</template>
				</el-table-column>
				<el-table-column type="expand" label="备注" align="center" :min-width="columnWidths.comments">
					<template slot-scope="scope">
						<div class="expand-row">
							<div class="expand-label">备注：</div>
							<div class="expand-content">{{ scope.row.comments }}</div>
						</div>
					</template>
				</el-table-column>
			</el-table>
		</el-row>

		<!--    返利回扣-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="添加返利信息" :visible.sync="addMoneyBackVisible" width="40%" append-to-body>
			<el-form :model="moneyBackInfo" label-width="80px">
				<el-form-item label="日期" prop="rebateDate">
					<el-date-picker v-model="moneyBackInfo.rebateDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<!-- （返利/降价）单价 -->
				<el-form-item label="（返利/降价）单价" prop="unitPrice">
					<el-input v-model="moneyBackInfo.unitPrice" placeholder="请输入（返利/降价）单价" />
				</el-form-item>
				<el-form-item label="金额" prop="rebate">
					<el-input v-model="moneyBackInfo.rebate" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="供应商" prop="supplier">
					<el-row>
						<el-col :span="10">
							<el-input v-model="moneyBackInfo.supplier" placeholder="请输入供应商" />
						</el-col>
						<el-col :span="3">
							<SearchOption :get-data="listCompany" :limit-info="{ companyType: '供应商' }" @commitBack="handleCommitCompany">
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="返利方式" prop="rebateMethod">
					<el-select v-model="moneyBackInfo.rebateMethod" default-first-option placeholder="请选择返利方式">
						<el-option v-for="item in rebateMethods" :key="item.dictValue" :label="item.dictLabel" :value="item.dictValue"></el-option>
					</el-select>
				</el-form-item>
				<!-- 重箱值 -->
				<el-form-item label="重箱值" prop="weightBox" v-if="moneyBackInfo.rebateMethod === RebateType.Weight">
					<el-input v-model="moneyBackInfo.weightBox" placeholder="根据订单自动计算" disabled />
				</el-form-item>
				<!-- 面积值 -->
				<el-form-item label="面积值" prop="area" v-if="moneyBackInfo.rebateMethod === RebateType.Square">
					<el-input v-model="moneyBackInfo.area" placeholder="根据订单自动计算" disabled />
				</el-form-item>
				<el-form-item label="返利原因" prop="rebateReason">
					<el-input v-model="moneyBackInfo.rebateReason" placeholder="请输入返利原因" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="moneyBackInfo.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="addMoneyBackVisible = false">取 消</el-button>
				<el-button type="primary" @click="addMoneyBackInfo">添加</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
// 表格滚动条样式
::v-deep .el-table__body-wrapper {
	&::-webkit-scrollbar {
		width: 12px;
		height: 22px;
	}

	&::-webkit-scrollbar-thumb {
		background-color: #909399;
		border-radius: 2px;
		border: 2px solid #f2f6fc;

		&:hover {
			background-color: #606266;
		}
	}

	&::-webkit-scrollbar-track {
		background-color: #f2f6fc;
		border-radius: 6px;
	}
}

::v-deep .non-expandable-row {
	.el-table__expand-column .el-table__expand-icon {
		display: none;
	}
}

::v-deep .expandable-row {
	.el-table__expand-column .el-table__expand-icon {
		display: inline-block;
	}
}

// 全局滚动条样式
::-webkit-scrollbar {
	width: 12px;
	height: 22px;
}

::-webkit-scrollbar-thumb {
	background-color: #909399;
	border-radius: 6px;
	border: 2px solid #f2f6fc;

	&:hover {
		background-color: #606266;
	}
}

::-webkit-scrollbar-track {
	background-color: #f2f6fc;
	border-radius: 6px;
}

/* 表格样式：内容紧贴边框，零间距布局 */
::v-deep .el-table {
	width: 100% !important;
	table-layout: auto; /* 使用 auto 布局，允许手动调整列宽 */

	/* 表头和表体单元格 - 零内边距，内容紧贴边框 */
	th,
	td {
		padding: 0 !important; /* 零内边距，内容紧贴边框 */
		margin: 0 !important;
		text-align: center !important;
		vertical-align: middle;
		line-height: 1.1 !important; /* 最小行高，更紧凑 */
	}

	/* 单元格内容容器 - 零间距，内容紧贴 */
	.cell {
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		word-break: normal;
		padding: 0 !important;
		margin: 0 !important;
		text-align: center !important;
		line-height: 1.1 !important;

		/* 确保 .cell 内的所有直接子元素都零间距 */
		> * {
			margin: 0 !important;
			padding: 0 !important;
		}
	}

	/* 表头样式 */
	thead th {
		padding: 0 !important;
		text-align: center !important;
		font-weight: 500;
		line-height: 1.1 !important;

		.cell {
			text-align: center !important;
			padding: 0 !important;
			margin: 0 !important;
			line-height: 1.1 !important;

			> * {
				margin: 0 !important;
				padding: 0 !important;
			}
		}
	}

	/* 表体样式 */
	tbody td {
		padding: 0 !important;
		text-align: center !important;
		line-height: 1.1 !important;

		.cell {
			text-align: center !important;
			padding: 0 !important;
			margin: 0 !important;
			line-height: 1.1 !important;

			> * {
				margin: 0 !important;
				padding: 0 !important;
			}
		}
	}

	/* 合计行样式 */
	.el-table__footer-wrapper {
		tbody td {
			padding: 0 !important;
			text-align: center !important;
			line-height: 1.1 !important;

			.cell {
				text-align: center !important;
				padding: 0 !important;
				margin: 0 !important;
				line-height: 1.1 !important;

				> * {
					margin: 0 !important;
					padding: 0 !important;
				}
			}
		}
	}

	/* 最小行高，让内容紧贴 */
	tr {
		height: auto !important;
		line-height: 1.1 !important;
	}

	/* 确保边框紧贴内容 */
	.el-table__header-wrapper,
	.el-table__body-wrapper,
	.el-table__footer-wrapper {
		th,
		td {
			padding: 0 !important;
		}
	}

	/* ExpandCursor 组件零间距样式 - 确保所有列都紧贴边框 */
	.expand-cursor-wrapper {
		margin: 0 !important;
		padding: 0 !important;
		width: 100% !important;
		display: inline-flex !important;
		align-items: center !important;
		justify-content: center !important;

		.text-container {
			margin: 0 !important;
			padding: 0 !important;
			flex: 1 !important;
			min-width: 0 !important;

			.text-content {
				margin: 0 !important;
				padding: 0 !important;
				width: 100% !important;
				display: block !important;
				text-align: center !important;
			}
		}
	}
}

/* 固定表头样式 - 确保表头在滚动时保持固定 */
::v-deep .el-table__header-wrapper {
	position: sticky !important;
	top: 0 !important;
	z-index: 99 !important;
	background-color: #fff !important;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05) !important;
}

/* 确保表头和表体的列宽同步 - 通过 JavaScript 设置，这里不强制覆盖 */

// 展开行样式
.expand-row {
	padding: 4px 5px;
	display: flex;
	align-items: center;
	justify-content: center;
	background-color: #fafafa;
	border-left: 3px solid #409eff;

	.expand-label {
		font-weight: bold;
		color: #606266;
		margin-right: 10px;
		flex-shrink: 0;
		font-size: 13px;
	}

	.expand-content {
		color: #303133;
		word-break: break-all;
		white-space: pre-wrap;
		line-height: 1.4;
		font-size: 13px;
		text-align: center;
	}
}
</style>
