<!-- TODO 默认搜索全部非停用科目 但科目页面显示所有的
所有都显示警告，如果不想用调用修改禁用，修改可以禁用 -->

<template>
	<div class="app-container">
		<el-row>
			<!--      表格-->
			<el-col :span="24">
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button type="info" plain size="mini" @click="toggleExpandAll">展开/折叠</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button plain size="mini" @click="resetQuery">刷新</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button type="primary" size="mini" @click="handleAddType">1-添加科目类型</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:subject:add']" type="danger" size="mini" @click="handleAdd">2-添加科目信息</el-button>
					</el-col>
					<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
						<!--    打印    -->
						<template #print>
							<el-col :span="1.5">
								<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
							</el-col>
						</template>
					</right-toolbar>
				</el-row>

				<!--        表格-->
				<el-table
					id="printBox"
					v-if="refreshTable"
					v-loading="loading"
					border
					:data="subjectList"
					row-key="id"
					:default-expand-all="isExpandAll"
					:tree-props="{
						children: 'children',
						hasChildren: 'hasChildren'
					}"
					size="mini"
				>
					<el-table-column v-if="columns[0].visible" label="科目名称" prop="title" show-overflow-tooltip>
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.title }}</div>
								<span>{{ scope.row.title }}</span>
							</el-tooltip>
						</template>
					</el-table-column>
					<el-table-column v-if="columns[1].visible" label="科目编码" align="center" prop="subjectNo" show-overflow-tooltip>
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.subjectNo }}</div>
								<span>{{ scope.row.subjectNo }}</span>
							</el-tooltip>
						</template>
					</el-table-column>
					<el-table-column label="排序" prop="orderNum" width="120" show-overflow-tooltip>
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.orderNum }}</div>
								<span>{{ scope.row.orderNum }}</span>
							</el-tooltip>
						</template>
					</el-table-column>
					<!-- 新增是否禁用列 -->
					<el-table-column label="是否禁用" prop="STATUS" align="center" width="100" show-overflow-tooltip>
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.STATUS === YES_OR_NO.YES ? '是' : '否' }}</div>
								<span v-if="scope.row.STATUS === YES_OR_NO.YES">是</span>
								<span v-else>否</span>
							</el-tooltip>
						</template>
					</el-table-column>
					<!--					<el-table-column v-if="columns[2].visible" label="科目类别" align="center" prop="type" />-->
					<!--          <el-table-column label="父级ID" align="center" prop="parentId" v-if="columns[3].visible"/>-->
					<el-table-column v-if="columns[2].visible" label="备注" align="center" prop="remark" show-overflow-tooltip>
						<template #default="scope">
							<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
								<div slot="content">{{ scope.row.remark }}</div>
								<span>{{ scope.row.remark }}</span>
							</el-tooltip>
						</template>
					</el-table-column>
					<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
						<template slot-scope="scope">
							<el-button v-hasPermi="['system:subject:edit']" size="mini" @click="handleUpdate(scope.row)">修改</el-button>
							<el-button v-hasPermi="['system:subject:add']" size="mini" type="primary" @click="handleAdd(scope.row)">新增</el-button>
							<el-button v-hasPermi="['system:subject:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
						</template>
					</el-table-column>
				</el-table>
			</el-col>
		</el-row>
		<!-- 添加或修改科目对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px" @keyup.enter.native="submitForm" @submit.native.prevent="submitForm">
				<el-form-item label="父级ID" prop="parentId">
					<treeselect v-model="form.parentId" :options="subjectOptions" :normalizer="normalizer" placeholder="请选择父级ID" />
				</el-form-item>
				<el-form-item label="科目名称" prop="title">
					<el-input v-model="form.title" placeholder="请输入科目名称" @input="handleInputTrim($event, 'form', 'title')" />
				</el-form-item>
				<el-form-item label="排序" prop="orderNum">
					<el-input v-model="form.orderNum" placeholder="请输入排序" @input="handleInputTrim($event, 'form', 'orderNum')" />
				</el-form-item>
				<el-form-item label="编号" prop="subjectNo">
					<el-input v-model="form.subjectNo" placeholder="请输入编号" @input="handleInputTrim($event, 'form', 'subjectNo')" />
				</el-form-item>
				<el-form-item label="是否禁用" prop="STATUS">
					<el-radio-group v-model="form.STATUS">
						<el-radio :label="YES_OR_NO.YES">否</el-radio>
						<el-radio :label="YES_OR_NO.NO">是</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item label="备注" prop="remark">
					<el-input v-model="form.remark" type="textarea" placeholder="请输入内容" @input="handleInputTrim($event, 'form', 'remark')" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    添加科目分类的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="添加科目分类" :visible.sync="openType" width="500px" append-to-body>
			<el-form ref="formBodyType" :model="formType" :rules="typeRules" label-width="80px" @keyup.enter.native="submitFormType" @submit.native.prevent="submitFormType">
				<el-form-item label="科目分类" prop="type">
					<el-select v-model="formType.type" placeholder="请选择">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="科目编号" prop="subjectNo">
					<el-input v-model="formType.subjectNo" type="textarea" placeholder="请输入科目编号" @input="handleInputTrim($event, 'formType', 'subjectNo')" />
				</el-form-item>
				<el-form-item label="备注" prop="remark">
					<el-input v-model="formType.remark" type="textarea" placeholder="请输入备注" @input="handleInputTrim($event, 'formType', 'remark')" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitFormType">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listSubject, getSubject, delSubject, addSubject, updateSubject } from '@/api/system/subject';
import Treeselect from '@riophae/vue-treeselect';
import '@riophae/vue-treeselect/dist/vue-treeselect.css';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { YES_OR_NO } from '@/api/tool/enums';
import { Modal } from 'ant-design-vue'; // 引入antd Modal

export default {
	name: 'Subject',
	components: {
		Treeselect
	},
	dicts: ['order_product_categories'],
	mixins: [mixin_printHTML],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 显示搜索条件
			showSearch: true,
			// 科目表格数据
			subjectList: [],
			// 科目树选项
			subjectOptions: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 是否展开，默认全部展开
			isExpandAll: true,
			// 重新渲染表格状态
			refreshTable: true,
			// 查询参数
			queryParams: {
				title: null,
				type: null,
				subjectNo: null,
				parentId: null,
				orderNum: null,
				STATUS: null
			},
			// 表单参数
			form: { type: '', STATUS: 0 }, // 默认否
			titleOptions: [],
			columns: [
				{ key: 0, label: `科目名称`, visible: true },
				{ key: 1, label: `科目编码`, visible: true },
				// { key: 2, label: `科目类别`, visible: true },
				{ key: 2, label: `备注`, visible: true }
			],
			// 表单校验
			rules: {
				title: [
					{
						required: true,
						message: '科目名称不能为空',
						trigger: 'blur'
					}
				],
				subjectNo: [{ required: true, message: '编号不能为空', trigger: 'blur' }],
				STATUS: [{ required: true, message: '请选择是否禁用', trigger: 'change' }] // 新增校验
			},
			typeRules: {
				type: [
					{
						required: true,
						message: '科目分类不能为空',
						trigger: 'blur'
					}
				],
				subjectNo: [{ required: true, message: '编号不能为空', trigger: 'blur' }]
			},

			// 树形控件
			defaultProps: {
				children: 'children',
				label: 'label'
			},

			// 添加产品分类
			openType: false,
			options: [
				{
					value: '收入',
					label: '收入'
				},
				{
					value: '支出',
					label: '支出'
				},
				{
					value: '其他',
					label: '其他'
				}
			],
			current_title: '',
			formType: {
				type: '',
				subjectNo: '',
				remark: ''
			}
		};
	},
	computed: {
		// 利用computed做中间层
		formId() {
			return this.form.parentId;
		},
		YES_OR_NO() {
			return YES_OR_NO;
		}
	},
	watch: {
		// 展示与隐藏
		columns: {
			handler: function (newVal) {
				localStorage.setItem('subject-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		formId: {
			// handler不该用箭头函数 会拿不到this
			handler: function (val) {
				if (val !== 0 && val !== null && val !== undefined) {
					// 应该先getId 填充this.form.type数据
					getSubject(val).then(response => {
						// this.form.type = response.data.type;
						this.form.subjectNo = response.data.subjectNo;
					});
					// val是id 然后再拿id去查找该元素的子元素个数 用来拼接
					listSubject({ id: val }, false).then(response => {
						// 查询该id下的子元素数组
						const filters = response.data.filter(item => {
							return item.parentId === val;
						});
						this.form.subjectNo += `00${filters.length + 1}`;
					});
				}
			}
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('subject-columns') === 'null' || !localStorage.getItem('subject-columns')) {
			// 设置localStorage
			localStorage.setItem('subject-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('subject-columns'));
		}
		// 获取科目分类列表
		listSubject({}, false).then(response => {
			this.titleOptions = [];
			const data = { id: 0, title: '科目根信息', children: [] };
			data.children = this.handleTree(response.data, 'id', 'parentId');
			this.titleOptions.push(data);
			this.orderNumSort(this.titleOptions);
		});
	},
	methods: {
		// 处理输入框禁止输入空格
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},
		orderNumSort(list) {
			list.sort((a, b) => a.orderNum - b.orderNum);
			list.forEach(item => {
				if (item.children !== undefined) {
					this.orderNumSort(item.children);
				}
			});
		},
		// 添加科目分类
		handleAddType() {
			this.openType = true;
		},
		/** 查询科目列表 */
		getList() {
			this.loading = true;
			listSubject(this.queryParams, false).then(response => {
				// children:[]
				this.subjectList = this.handleTree(response.data, 'id', 'parentId');
				this.orderNumSort(this.subjectList);
				this.loading = false;
			});
		},
		/** 转换科目数据结构 */
		normalizer(node) {
			if (node.children && !node.children.length) {
				delete node.children;
			}
			return {
				id: node.id,
				label: node.title,
				children: node.children
			};
		},
		/** 查询科目下拉树结构 */
		getTreeselect() {
			listSubject({}, false).then(response => {
				this.subjectOptions = [];
				const data = { id: 0, title: '科目根信息', children: [] };
				data.children = this.handleTree(response.data, 'id', 'parentId');
				this.subjectOptions.push(data);
			});
		},

		// 取消按钮
		cancel() {
			this.open = false;
			this.openType = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				title: null,
				type: null,
				subjectNo: null,
				parentId: null,
				orderNum: null,
				STATUS: 0, // 默认否
				createBy: null,
				createTime: null,
				updateBy: null,
				updateTime: null,
				remark: null
			};
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		/** 新增按钮操作 */
		handleAdd(row) {
			this.reset();
			this.getTreeselect();
			if (row != null && row.id) {
				this.form.parentId = row.id;
			} else {
				this.form.parentId = 0;
			}
			this.open = true;
			this.title = '添加科目';
		},
		/** 展开/折叠操作 */
		toggleExpandAll() {
			this.refreshTable = false;
			this.isExpandAll = !this.isExpandAll;
			this.$nextTick(() => {
				this.refreshTable = true;
			});
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			Modal.confirm({
				title: '操作提示',
				content: '修改科目可能会影响系统数据完整性，若该科目已被引用，修改可能导致系统故障。是否继续？',
				okText: '是',
				cancelText: '否',
				onOk: () => {
					this.reset();
					this.getTreeselect();
					if (row != null) {
						this.form.parentId = row.parentId;
					}
					getSubject(row.id).then(response => {
						this.form = {
							...response.data,
							STATUS: Number(response.data.STATUS)
						};
						this.open = true;
						this.title = '修改科目';
					});
				},
				onCancel: () => {}
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 如果添加类别
					if (this.form.id != null) {
						updateSubject(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addSubject(this.form).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		// 提交添加分类
		submitFormType() {
			this.$refs['formBodyType'].validate(valid => {
				if (valid) {
					this.formType.title = this.formType.type;
					addSubject(this.formType).then(() => {
						this.$modal.msgSuccess('新增成功');
						this.openType = false;
						this.getList();
					});
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			Modal.confirm({
				title: '操作提示',
				content: '删除科目可能会影响系统数据完整性，若该科目已被引用，删除可能导致系统故障。是否继续？',
				okText: '是',
				cancelText: '否',
				onOk: () => {
					this.$modal
						.confirm('是否确认删除科目编号为"' + row.id + '"的数据项？')
						.then(function () {
							return delSubject(row.id);
						})
						.then(() => {
							this.getList();
							this.$modal.msgSuccess('删除成功');
						})
						.catch(() => {});
				},
				onCancel: () => {}
			});
		}
	}
};
</script>
