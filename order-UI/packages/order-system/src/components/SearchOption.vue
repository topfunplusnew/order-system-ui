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
		}
	},
	data() {
		return {
			// 显示总行数
			total: 0,
			pageNum: 1,
			pageSize: 10,
			dialogVisible: false,
			// 加载效果
			loading: false,
			queryParams: {}
		};
	},

	computed: {
		query: {
			set(val) {
				this.$emit('update:queryName', val);
			},
			get() {
				return this.queryName;
			}
		},
		computedQueryItems: {
			set(val) {
				this.$emit('update:queryItems', val);
			},
			get() {
				return this.queryItems;
			}
		}
	},
	watch: {
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
			// 获取数据 渲染表格
			this.getList();
			this.dialogVisible = true;
		},
		// 点击确认
		commitSomeThing(row) {
			this.$emit('commitBack', row);
			this.query = '';
			Object.keys(this.computedQueryItems.queryList).forEach(key => {
				this.computedQueryItems.queryList[key].value = '';
			});
			this.dialogVisible = false;
		},
		// 条件查询
		handleSearchInfo() {
			_.set(this.limitInfo, 'params', {});
			if (this.computedQueryItems.queryList.length > 0) {
				for (let item of this.computedQueryItems.queryList) {
					const queryItem = _.cloneDeep(item);
					// 如果是params的查询参数
					if (queryItem && queryItem?.extraInfo && queryItem?.extraInfo?.__isParams) {
						// 如果是复合数据 如时间范围
						if (queryItem && queryItem?.extraInfo.__isMultiple) {
							const mutilMeta = (queryItem.prop + '').split('&');
							console.log(`queryItem.prop`, queryItem.prop);
							if (!Array.isArray(mutilMeta)) {
								throw new Error('组件内部错误,请检查复合查询参数是否正确');
							}
							mutilMeta.forEach((meta, index) => {
								this.limitInfo.params[meta] = Array.isArray(queryItem.value) ? queryItem.value[index] : '';
							});
							continue;
						}
						// 如果不是 直接添加
						this.limitInfo.params[queryItem.prop] = queryItem.value;
						continue;
					}
					this.limitInfo[queryItem.prop] = queryItem.value;
				}
			}
			this.limitInfo[this.queryInfo] = this.query;
			const query = {
				...this.limitInfo
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
			this.dialogVisible = false;
			this.query = '';
			Object.keys(this.computedQueryItems.queryList).forEach(key => {
				this.computedQueryItems.queryList[key].value = '';
			});
		},
		handleSubmit() {
			this.dialogVisible = false;
			this.query = '';
			Object.keys(this.computedQueryItems.queryList).forEach(key => {
				this.computedQueryItems.queryList[key].value = '';
			});
		}
	}
};
</script>

<template>
	<div>
		<!--    按钮-->
		<el-button size="mini" :icon="icon" type="primary" @click="handleCallBack" :disabled="disable"></el-button>
		<!--    弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :title="title" :visible.sync="dialogVisible" width="65%">
			<!--      弹出的表格内容-->
			<el-row>
				<div>
					<el-form ref="queryForm" :model="computedQueryItems" size="mini" :inline="true" label-width="100px">
						<el-form-item :label="queryLabel">
							<el-input v-model="query" type="text" placeholder="请输入" size="mini" clearable></el-input>
						</el-form-item>
						<el-form-item v-for="item in computedQueryItems.queryList" :label="item.label" :prop="item.prop" :key="item.id">
							<template v-if="item.type === 'input'">
								<el-input v-model="item.value" placeholder="请输入" size="mini" clearable></el-input>
							</template>
							<template v-else-if="item.type === 'select'">
								<el-select v-model="item.value" size="mini" placeholder="请选择" clearable>
									<el-option v-for="option in item.options" :key="option.value" :label="option.label" :value="option.value"></el-option>
								</el-select>
							</template>
							<template v-else-if="item.type === 'date-picker'">
								<el-date-picker v-model="item.value" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" size="mini" clearable></el-date-picker>
							</template>
							<template v-else-if="item.type === 'date-range-picker'">
								<el-date-picker
									v-model="item.value"
									type="daterange"
									range-separator="至"
									start-placeholder="开始日期"
									end-placeholder="结束日期"
									value-format="yyyy-MM-dd"
									size="mini"
									clearable
								></el-date-picker>
							</template>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleSearchInfo" :disabled="disable">搜索</el-button>
						</el-form-item>
					</el-form>
				</div>

				<!--        列表页-->
				<el-table size="mini" :key="tableData.length" v-loading="loading" :data="tableData">
					<slot name="table-columns" :tableData="tableData"></slot>
					<!--          点击确认的地方-->
					<el-table-column fixed="right" label="操作" width="100">
						<template slot-scope="scope">
							<el-button type="danger" size="mini" :disabled="disable" @click="commitSomeThing(scope.row)">确认</el-button>
						</template>
					</el-table-column>
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
.el-form {
	margin-bottom: 10px;

	.el-form-item {
		margin-right: 15px;
		margin-bottom: 10px;
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
</style>
