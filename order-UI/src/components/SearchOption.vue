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

<!--特别注意 针对某些特殊情况 可以补充字段-->
<script>
import { mixin_search_option } from '../views/dashboard/mixins/search_option/serch_option';

export default {
	name: 'SearchOption',
	mixins: [mixin_search_option],
	props: {
		// 弹出框的标题
		title: {
			type: String,
			default: '标题'
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
			this.dialogVisible = false;
		},
		// 条件查询
		handleSearchInfo() {
			if (this.queryItems.queryList.length > 0) {
				this.queryItems.queryList.forEach(item => {
					this.limitInfo[item.prop] = item.value;
				});
			}
			this.limitInfo[this.queryInfo] = this.query;
			const query = {
				...this.limitInfo
			};
			this.getData(query).then(res => {
				this.total = res.total;
				this.tableData = res.rows;
				this.loading = false;
			});
		}
	}
};
</script>

<template>
	<div>
		<!--    按钮-->
		<el-button
			size="mini"
			:icon="icon"
			type="primary"
			@click="handleCallBack"
		></el-button>
		<!--    弹窗-->
		<el-dialog
			:close-on-click-modal="false"
			:title="title"
			:visible.sync="dialogVisible"
			destroy-on-close
			width="65%"
			append-to-body
		>
			<!--      弹出的表格内容-->
			<el-row>
				<div>
					<el-form
						ref="queryForm"
						:model="queryItems"
						size="mini"
						:inline="true"
						label-width="100px"
					>
						<el-form-item
							v-for="item in queryItems.queryList"
							:label="item.label"
							:prop="item.prop"
							:key="item.id"
						>
							<el-input
								v-if="item.type === 'input'"
								v-model="item.value"
								placeholder="请输入"
								size="mini"
								clearable
							></el-input>
							<el-select
								v-else-if="item.type === 'select'"
								v-model="item.value"
								size="mini"
								placeholder="请选择"
								clearable
							>
								<el-option
									v-for="option in item.options"
									:key="option.value"
									:label="option.label"
									:value="option.value"
								></el-option>
							</el-select>
						</el-form-item>
						<el-form-item :label="queryLabel">
							<el-input
								v-model="query"
								type="text"
								placeholder="请输入"
								size="mini"
								clearable
							></el-input>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleSearchInfo"
								>搜索
							</el-button>
						</el-form-item>
					</el-form>
				</div>

				<!--        列表页-->
				<el-table
					:key="tableData.length"
					v-loading="loading"
					:data="tableData"
					size="mini"
				>
					<slot name="table-columns" :tableData="tableData"></slot>

					<!--          点击确认的地方-->
					<el-table-column fixed="right" label="操作" width="100">
						<template slot-scope="scope">
							<el-button
								type="danger"
								size="small"
								:disabled="disable"
								@click="commitSomeThing(scope.row)"
							>
								确认
							</el-button>
						</template>
					</el-table-column>
				</el-table>
				<pagination
					v-if="isPage"
					v-show="total > 0"
					:total="total"
					:page.sync="pageNum"
					:limit.sync="pageSize"
					@pagination="getList"
				/>
			</el-row>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogVisible = false"
					>确 定</el-button
				>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
