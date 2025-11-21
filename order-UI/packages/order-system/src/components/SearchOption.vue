<!-- 封装的通用搜索组件 -->
<!-- 使用方式 -->
<!-- 1. 必传属性: -->
<!--   - getData: 获取数据的函数 -->
<!--   - limitInfo: 限制条件，限制获取函数，例如查询客户类型为供应商信息 -->
<!-- 2. 选传属性: -->
<!--   - title: 弹出框的标题，默认为 "标题" -->
<!--   - icon: 组件的图标，默认为 "el-icon-search" -->
<!--   - queryInfo: 搜索框要查询的字段，默认为 "name" -->
<!--   - queryName: 搜索框中输入的值，需要和 $emit 配合使用，默认为 "name" -->
<!--   - queryLabel: 搜索框前面的文字提示，默认为 "name" -->
<!--   - disable: 是否禁用确认按钮，默认为 false -->
<!-- 3. 插槽: -->
<!--   - table-columns: 表格的列配置 -->
<!-- 4. 回调函数 -->
<!--   - @update:queryName: 修改父组件传入的 queryName 的值，保证输入框的响应式 -->
<!--   - @commitBack(val): 点击确认后的回调，val 是需要自动填充的对象 -->

<!-- 混入中是对于数据的进一步处理 mixin_search_option -->

<!--特别注意 针对某些特殊情况 可以补充字段-->
<script>
import { mixin_search_option } from '../views/dashboard/mixins/search_option/serch_option';
import _ from 'lodash';

export default {
	name: 'SearchOption',
	mixins: [mixin_search_option],
	props: {
		// 弹出框的标题
		title: {
			type: String,
			default: '请选择'
		},
		// 图标信息
		icon: {
			type: String,
			default: 'el-icon-search'
		},
		// 查询条件
		queryInfo: {
			type: String,
			default: 'name'
		},
		queryName: {
			type: String,
			default: 'name'
		},
		// 查询标签
		queryLabel: {
			type: String,
			default: 'name'
		},
		disable: {
			type: Boolean,
			default: false
		},
		// 搜索项集合
		queryItems: {
			type: Object,
			default: () => {
				return {
					queryList: []
				};
			}
		},
		// 弹窗宽度
		width: {
			type: [Number, String],
			default: '65%'
		},
		// 请求方法返回的数据是否分页
		isPage: {
			type: Boolean,
			default: true
		},
		// 额外的查询参数信息
		extraParams: {
			type: Object,
			default: () => {
				return null;
			}
		},
		// 自动操作配置：支持多种操作类型（填充、自定义等）
		// 格式: {
		//   fields: ['__fillValue', '__fillValue1'],
		//   actions: [
		//     { type: 'fill', handler: (value, fieldName, actionType, context) => { ... } },
		//     { type: 'custom', handler: (value, fieldName, actionType, context) => { ... } }
		//   ],
		//   shouldAutoSearch: true // 是否自动触发搜索，默认 true
		// }
		// handler 参数说明：
		//   - value: 字段的值
		//   - fieldName: 字段名
		//   - actionType: 操作类型（如 'fill', 'custom' 等）
		//   - context: 上下文对象，提供 setQuery、fillQuery 等方法
		autoFillConfig: {
			type: Object,
			default: () => {
				return null;
			}
		}
	},
	data() {
		return {
			// 显示总行数
			total: 0,
			pageNum: 1,
			pageSize: 20,
			dialogVisible: false,
			// 加载效果
			loading: false,
			queryParams: {},
			// 输入框宽度
			inputWidth: '160px',
			// span文本内容（用于测量宽度）
			spanText: '',
			// 内部查询值，用于双向绑定
			internalQuery: ''
		};
	},

	computed: {
		query: {
			set(val) {
				this.internalQuery = val;
				this.$emit('update:queryName', val);
			},
			get() {
				// 使用内部值，确保输入框可以正常输入
				return this.internalQuery;
			}
		},
		computedQueryItems: {
			set(val) {
				this.$emit('update:queryItems', val);
			},
			get() {
				return this.queryItems;
			}
		},
		// 是否为params的限制信息
		isParamsLimitInfo() {
			return this.limitInfo && this.limitInfo.__params && Object.keys(this.limitInfo.__params).length > 0;
		}
	},
	mounted() {
		// 初始化内部查询值
		this.internalQuery = this.queryName || '';
		// 初始化输入框宽度
		this.updateInputWidth();
	},
	watch: {
		queryName: {
			handler(newVal) {
				// 当 prop 值变化时，同步更新内部值（仅在对话框关闭时或内部值为空时）
				if (!this.dialogVisible || this.internalQuery === '') {
					this.internalQuery = newVal || '';
				}
			},
			immediate: true
		},
		query: {
			handler() {
				var queryParams = Object.create({});
				Object.defineProperty(queryParams, this.queryInfo, {
					value: this.query,
					enumerable: true
				});
				Object.assign(this.limitInfo, queryParams);
			}
		}
	},
	methods: {
		// 更新输入框宽度（参考CSDN文章思路：使用隐藏span测量宽度）
		updateInputWidth() {
			this.spanText = this.query || '';
			this.$nextTick(() => {
				// 使用$nextTick确保DOM更新后再获取宽度
				const spanEl = this.$refs.widthMeasure;
				if (spanEl) {
					const minWidth = 160; // 最小宽度
					const maxWidth = 400; // 最大宽度
					const padding = 30; // 输入框内边距和清空图标的空间
					const textWidth = spanEl.offsetWidth;
					const calculatedWidth = textWidth < minWidth ? minWidth : Math.min(textWidth + padding, maxWidth);
					this.inputWidth = calculatedWidth + 'px';
				}
			});
		},
		getList() {
			// 启动加载效果
			this.loading = true;
			// 获取表格数据
			this.getTableData();
		},
		// 点击弹窗
		handleCallBack() {
			// 刷新状态
			this.tableData = [];
			// 初始化查询值
			let shouldAutoSearch = false;

			// 检查是否有自动操作配置
			if (this.autoFillConfig && this.extraParams) {
				const { fields, actions, shouldAutoSearch: configShouldAutoSearch } = this.autoFillConfig;

				if (Array.isArray(fields) && Array.isArray(actions) && actions.length > 0) {
					// 遍历配置的字段，查找第一个有值的字段
					for (const fieldName of fields) {
						if (this.extraParams[fieldName]) {
							const fieldValue = this.extraParams[fieldName];

							// 创建上下文对象，提供操作 SearchOption 状态的方法
							const context = {
								setQuery: value => {
									this.internalQuery = value;
									this.query = value;
								},
								getQuery: () => this.query,
								setInternalQuery: value => {
									this.internalQuery = value;
								},
								getInternalQuery: () => this.internalQuery,
								// 提供一些内置的常用操作
								fillQuery: value => {
									this.internalQuery = value;
									this.query = value;
								}
							};

							// 按顺序执行所有配置的操作
							for (const action of actions) {
								if (action && typeof action.handler === 'function') {
									// 执行处理函数，传入值、字段名、操作类型和上下文对象
									action.handler(fieldValue, fieldName, action.type || 'custom', context);
								}
							}

							// 根据配置决定是否自动搜索（默认 true）
							shouldAutoSearch = configShouldAutoSearch !== false;
							break; // 找到第一个有效值后停止
						}
					}
				}
			}

			// 如果没有自动填充，使用默认的 queryName
			if (!shouldAutoSearch) {
				this.internalQuery = this.queryName || '';
			}

			// 初始化params属性
			_.set(this.limitInfo, 'params', {});
			// 这里需要加一个特殊逻辑 支持limitInfo传入放置于params的属性
			if (this.isParamsLimitInfo) {
				Object.assign(this.limitInfo.params, this.limitInfo.__params);
				delete this.limitInfo.__params;
			}
			console.log(`已设置params属性`, this.limitInfo);

			// 如果需要自动搜索，则打开弹窗后触发搜索
			if (shouldAutoSearch) {
				this.dialogVisible = true;
				// 使用 $nextTick 确保弹窗已打开后再触发搜索
				this.$nextTick(() => {
					this.handleSearchInfo();
				});
			} else {
				// 获取数据 渲染表格
				this.getList();
				this.dialogVisible = true;
			}
		},
		// 点击确认
		commitSomeThing(row) {
			this.$emit('commitBack', row);
			this.internalQuery = '';
			this.query = '';
			this.inputWidth = '160px'; // 重置宽度
			Object.keys(this.computedQueryItems.queryList).forEach(key => {
				this.computedQueryItems.queryList[key].value = '';
			});
			this.dialogVisible = false;
		},
		// 条件查询
		handleSearchInfo(event) {
			// 启动加载效果
			this.loading = true;
			// 阻止表单默认提交行为，防止页面刷新
			if (event) {
				event.preventDefault();
				event.stopPropagation();
			}
			// 确保 params 属性存在，如果不存在则初始化
			if (!this.limitInfo.params) {
				this.limitInfo.params = {};
			}
			if (this.computedQueryItems.queryList.length > 0) {
				console.log(`this.computedQueryItems.queryList`, this.computedQueryItems.queryList);
				for (let item of this.computedQueryItems.queryList) {
					const queryItem = _.cloneDeep(item);
					// 如果是params的查询参数
					if (queryItem && queryItem?.extraInfo && queryItem?.extraInfo?.__isParams) {
						// 如果是复合数据 如时间范围
						if (queryItem && queryItem?.extraInfo.__isMultiple) {
							const mutilMeta = (queryItem.prop + '').split('&');
							if (!Array.isArray(mutilMeta)) {
								throw new Error('组件内部错误,请检查复合查询参数是否正确');
							}
							mutilMeta.forEach((meta, index) => {
								this.limitInfo.params[meta] = Array.isArray(queryItem.value) ? queryItem.value[index] : '';
							});
							continue;
						}
						console.log(`this.limitInfo`, this.limitInfo);
						console.log(`this.limitInfo.params`, this.limitInfo.params);
						// 如果不是 直接添加
						this.limitInfo.params[queryItem.prop] = queryItem.value;
						continue;
					}
					this.limitInfo[queryItem.prop] = queryItem.value;
				}
			}
			this.limitInfo[this.queryInfo] = this.query;
			const query = {
				...this.limitInfo,
				page: this.pageNum,
				pageSize: this.pageSize
			};
			// 判断一下 如果额外的请求参数不为空
			if (this.extraParams != null) {
				Object.assign(query, this.extraParams);
			}
			this.getData(query).then(res => {
				this.total = res.total;
				this.tableData = res.rows;
				this.loading = false;
			});
		},
		handleCancel() {
			this.internalQuery = '';
			this.query = '';
			this.inputWidth = '160px'; // 重置宽度
			Object.keys(this.computedQueryItems.queryList).forEach(key => {
				this.computedQueryItems.queryList[key].value = '';
			});
			this.dialogVisible = false;
		},
		handleSubmit() {
			this.internalQuery = '';
			this.query = '';
			this.inputWidth = '160px'; // 重置宽度
			Object.keys(this.computedQueryItems.queryList).forEach(key => {
				this.computedQueryItems.queryList[key].value = '';
			});
			this.dialogVisible = false;
		},
		// 点击清空按钮
		handleClear() {
			this.$emit('commitBack', {});
			this.internalQuery = '';
			this.query = '';
			this.inputWidth = '160px'; // 重置宽度
			Object.keys(this.computedQueryItems.queryList).forEach(key => {
				this.computedQueryItems.queryList[key].value = '';
			});
		}
	}
};
</script>

<template>
	<div>
		<!--    按钮组 - 悬停显示清空按钮 -->
		<div class="button-group">
			<el-button size="mini" :icon="icon" type="primary" @click="handleCallBack" :disabled="disable" class="search-btn"></el-button>
			<el-button size="mini" icon="el-icon-delete" type="danger" @click="handleClear" :disabled="disable" class="clear-btn"></el-button>
		</div>
		<!--    弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :title="title" :visible.sync="dialogVisible" :width="width">
			<!--      弹出的表格内容-->
			<el-row>
				<div>
					<el-form ref="queryForm" :model="computedQueryItems" size="mini" :inline="true" label-width="100px" @submit.native.prevent>
						<el-form-item :label="queryLabel">
							<div class="input-wrapper">
								<!-- 隐藏的测量元素，用于获取文本实际宽度 -->
								<span ref="widthMeasure" class="width-measure">{{ spanText }}</span>
								<el-input v-model="query" type="text" placeholder="请输入" size="mini" clearable @input="updateInputWidth" @keyup.enter.native.prevent="handleSearchInfo" :style="{ width: inputWidth }"></el-input>
							</div>
						</el-form-item>
						<el-form-item v-for="item in computedQueryItems.queryList" :label="item.label" :prop="item.prop" :key="item.id">
							<template v-if="item.type === 'input'">
								<el-input v-model="item.value" placeholder="请输入" size="mini" clearable @keyup.enter.native.prevent="handleSearchInfo"></el-input>
							</template>
							<template v-else-if="item.type === 'select'">
								<el-select v-model="item.value" size="mini" placeholder="请选择" clearable @keyup.enter.native.prevent="handleSearchInfo">
									<el-option v-for="option in item.options" :key="option.value" :label="option.label" :value="option.value"></el-option>
								</el-select>
							</template>
							<template v-else-if="item.type === 'date-picker'">
								<el-date-picker v-model="item.value" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" size="mini" clearable></el-date-picker>
							</template>
							<template v-else-if="item.type === 'date-range-picker'">
								<el-date-picker v-model="item.value" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" size="mini" clearable></el-date-picker>
							</template>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleSearchInfo" :disabled="disable">搜索</el-button>
						</el-form-item>
					</el-form>
				</div>
				<el-table size="mini" :key="tableData.length" v-loading="loading" :data="tableData" border>
					<el-table-column label="操作" width="60" align="center" fixed="left">
						<template slot-scope="scope">
							<el-button type="danger" size="mini" :disabled="disable" @click="commitSomeThing(scope.row)">确认</el-button>
						</template>
					</el-table-column>
					<slot name="table-columns" :tableData="tableData"></slot>
				</el-table>
				<pagination v-if="isPage" v-show="total > 0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" @pagination="getList" />
			</el-row>
			<span slot="footer" class="dialog-footer">
				<el-button @click="handleCancel">取 消</el-button>
				<el-button type="primary" @click="handleSubmit">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
// 按钮组悬停效果
.button-group {
	display: inline-flex;
	align-items: center;
	gap: 0;
	position: relative;

	.search-btn {
		flex-shrink: 0;
		transition: all 0.3s ease;
	}

	.clear-btn {
		position: absolute;
		left: 100%;
		opacity: 0;
		visibility: hidden;
		transition: all 0.3s ease;
		margin-left: 4px;
		z-index: 999999;
	}

	&:hover {
		.clear-btn {
			opacity: 1;
			visibility: visible;
			z-index: 999999;
		}
	}
}

.el-form {
	margin-bottom: 10px;
	display: flex;
	flex-wrap: wrap;

	.el-form-item {
		margin-right: 15px;
		margin-bottom: 10px;
		flex: 0 0 auto;
	}
}

.el-table {
	margin-top: 10px;
	font-size: 13px;

	::v-deep .el-table__header th {
		padding: 8px 0;
	}

	::v-deep .el-table__body td {
		padding: 8px 0;
	}
}

.pagination {
	margin-top: 10px;
	text-align: right;

	::v-deep .el-pagination__total,
	::v-deep .el-pagination__jump {
		font-size: 13px;
	}

	::v-deep .el-pager li {
		min-width: 24px;
		height: 24px;
		line-height: 24px;
		font-size: 13px;
	}

	::v-deep .btn-prev,
	::v-deep .btn-next {
		min-width: 24px;
		height: 24px;
		line-height: 24px;
	}
}

// 输入框包装器
.input-wrapper {
	position: relative;
	display: inline-block;
}

// 隐藏的测量元素（参考CSDN文章思路）
.width-measure {
	font-size: 13px; // 与输入框字体大小保持一致（size="mini"）
	position: absolute;
	left: 0;
	padding: 0 15px; // 与el-input的padding保持一致
	white-space: nowrap;
	visibility: hidden;
	pointer-events: none;
}
</style>
