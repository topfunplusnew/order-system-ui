<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="分类名称" prop="categoryName">
				<el-input v-model="queryParams.categoryName" placeholder="请输入分类名称" clearable />
			</el-form-item>
			<el-form-item label="级别名称" prop="levelName">
				<el-input v-model="queryParams.levelName" placeholder="请输入级别名称" clearable />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row>
			<el-col :span="5">
				<el-tree :data="tempCategories" :props="defaultProps" :load="getCategoryList" @node-click="handleNodeClick">
					<span slot-scope="{ data }" class="custom-tree-node">
						<span>
							<i class="el-icon-document-remove"></i>
							{{ data.value }} {{ data.label }}
						</span>
					</span>
				</el-tree>
				<div style="width: 450px">
					<pagination v-show="category_total > 0" :total="category_total" :page.sync="category_pageNum" :limit.sync="category_pageSize" @pagination="getCategoryList" />
				</div>
			</el-col>
			<el-col :span="19">
				<el-row :gutter="10" class="mb8">
					<el-col :span="1.5">
						<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button type="primary" size="mini" @click="handleAddProductSort">添加产品分类</el-button>
					</el-col>
					<el-col :span="1.5">
						<el-button type="danger" size="mini" @click="handleAddProductLevel">新增产品级别信息</el-button>
					</el-col>
					<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
						<template #print>
							<el-col :span="1.5">
								<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
							</el-col>
						</template>
						<!--        导出-->
						<template #export>
							<el-col :span="1.5">
								<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
							</el-col>
						</template>
					</right-toolbar>
				</el-row>
				<el-table
					id="printBox"
					v-horizontal-scroll="'always'"
					v-loading="loading"
					border
					:data="productLevelList"
					size="mini"
					:cell-style="
						() => {
							return { padding: '.5px' };
						}
					"
					@selection-change="handleSelectionChange"
				>
					<el-table-column v-if="columns[0].visible" label="级别编码" align="center" prop="levelNo" />
					<el-table-column v-if="columns[1].visible" label="级别名称" align="center" prop="levelName" />
					<el-table-column v-if="columns[2].visible" label="分类编号" align="center" prop="categoryNo" />
					<el-table-column v-if="columns[3].visible" label="分类名称" align="center" prop="categoryName" />
					<el-table-column v-if="columns[4].visible" label="厚度" align="center" prop="height" />
					<el-table-column v-if="columns[5].visible" label="长度" align="center" prop="length" />
					<el-table-column v-if="columns[6].visible" label="宽度" align="center" prop="width" />
					<el-table-column v-if="columns[7].visible" label="吨位差" align="center" prop="tonnage" />
					<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
						<template slot-scope="scope">
							<el-button v-hasPermi="['system:productlevel:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
							<el-button v-hasPermi="['system:productlevel:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
						</template>
					</el-table-column>
				</el-table>
			</el-col>
		</el-row>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
		<!--    添加产品分类的弹窗-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="添加产品分类" :visible.sync="addCategoryOpen" width="600px">
			<el-row>
				<el-col :span="12">
					<el-row>
						<span>级别编码</span>
					</el-row>
					<el-row>
						<el-input v-model="tempCategoryInfo.levelNo" placeholder="请输入级别编码" @input="validateLevelNo"></el-input>
					</el-row>
				</el-col>
				<el-col :span="12">
					<el-row>
						<span>分类名称</span>
					</el-row>
					<el-row>
						<el-input v-model="tempCategoryInfo.categoryName" placeholder="请输入分类名称"></el-input>
					</el-row>
				</el-col>
			</el-row>
			<!--      提交-->
			<el-row>
				<el-button type="primary" @click="submitAddCategory">提 交</el-button>
			</el-row>
			<br />
			<el-row>
				<el-table :data="tempCategoryList" border style="width: 100%">
					<el-table-column fixed prop="dictValue" label="分类编码"></el-table-column>
					<el-table-column fixed prop="dictLabel" label="分类名称"></el-table-column>
					<el-table-column label="操作" width="200">
						<template slot-scope="scope">
							<el-row>
								<el-col :span="5">
									<el-button type="text" size="mini" @click="handleClickCategoryList(scope.row)">编辑</el-button>
								</el-col>
								<el-col :span="5">
									<el-button type="text" size="mini" @click="handleDeteleLevel(scope.row)">删除分类</el-button>
								</el-col>
							</el-row>
						</template>
					</el-table-column>
				</el-table>

				<!--        分页-->
				<pagination v-show="level_total > 0" :total="level_total" :page.sync="level_pageNum" :limit.sync="level_pageSize" @pagination="getDictsData" />
			</el-row>
			<span slot="footer" class="dialog-footer">
				<el-button @click="cancelAddProductLevel">取 消</el-button>
				<el-button type="primary" @click="addCategoryOpen = false">确 定</el-button>
			</span>
		</el-dialog>

		<!--    添加产品级别的弹窗-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="添加产品级别" :visible.sync="addProductLevelOpen" width="600px">
			<!--      添加产品级别的表单-->
			<el-form ref="productForm" :model="addCategoryModel" size="mini" label-width="120px" :rules="rules" @keyup.enter.native="submitAddLevel" @submit.native.prevent="submitAddLevel">
				<el-form-item label="分类" prop="categoryName">
					<el-select v-model="addCategoryModel.categoryName" placeholder="请选择分类名称" @change="handleChangeLevelNo">
						<el-option v-for="item in dict.type.order_product_categories" :key="item.value" :label="item.label" :value="item.label"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="分类编号" prop="categoryNo">
					<el-input v-model="addCategoryModel.categoryNo" placeholder="请输入分类编号" />
				</el-form-item>
				<el-form-item label="级别编码" prop="levelNo">
					<el-input v-model="addCategoryModel.levelNo" placeholder="请输入级别编码"></el-input>
				</el-form-item>
				<el-form-item label="级别名称" prop="levelName">
					<el-input v-model="addCategoryModel.levelName" placeholder="请输入级别名称"></el-input>
				</el-form-item>
				<el-form-item label="厚度" prop="height">
					<el-input v-model="addCategoryModel.height" placeholder="请输入厚度"></el-input>
				</el-form-item>
				<el-form-item label="长度" prop="length">
					<el-input v-model="addCategoryModel.length" placeholder="请输入长度"></el-input>
				</el-form-item>
				<el-form-item label="宽度" prop="width">
					<el-input v-model="addCategoryModel.width" placeholder="请输入宽度"></el-input>
				</el-form-item>
				<el-form-item label="吨位差" prop="tonnage">
					<el-input v-model="addCategoryModel.tonnage" placeholder="请输入吨位差"></el-input>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitAddLevel">保 存</el-button>
				<el-button @click="cancelAddProductCategory">取 消</el-button>
			</span>
		</el-dialog>

		<!-- 添加或修改产品级别对话框 -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px" @keyup.enter.native="submitForm">
				<el-form-item label="级别编码" prop="levelNo">
					<el-input v-model="form.levelNo" placeholder="请输入支付类型" />
				</el-form-item>
				<el-form-item label="级别名称" prop="levelName">
					<el-input v-model="form.levelName" placeholder="请输入级别名称" />
				</el-form-item>
				<el-form-item label="分类编号" prop="tableName">
					<el-input v-model="form.categoryNo" placeholder="请输入分类编号" @input="validateFormCategory" />
				</el-form-item>
				<el-form-item label="分类名称" prop="categoryName">
					<el-select v-model="form.categoryName" placeholder="请选择分类名称">
						<el-option v-for="item in dict.type.order_product_categories" :key="item.value" :label="item.label" :value="item.label"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="厚度" prop="height">
					<el-input v-model="form.height" placeholder="请输入厚度" />
				</el-form-item>
				<el-form-item label="宽度" prop="width">
					<el-input v-model="form.width" placeholder="请输入宽度" />
				</el-form-item>
				<el-form-item label="长度" prop="length">
					<el-input v-model="form.length" placeholder="请输入长度" />
				</el-form-item>
				<el-form-item label="吨位差" prop="tonnage">
					<el-input v-model="form.tonnage" placeholder="请输入吨位差" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addProductLevel, delProductLevel, getMaxLevelNo, getProductLevel, listProductLevel, updateProductLevel } from '@/api/system/productLevel';
import { addData, delData, getDicts, listData } from '@/api/system/dict/data';
import { updateData } from '../../../api/system/dict/data';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { excludeParams } from '../../../api/tool/exclude';
import { TypeUtils } from '@/views/dashboard/backuplog';

export default {
	name: 'ProductLevel',
	dicts: ['order_product_categories'],
	mixins: [mixin_printHTML],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 产品级别表格数据
			productLevelList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				levelNo: null,
				levelName: null,
				categoryNo: null,
				categoryName: null,
				height: null,
				length: null,
				width: null,
				tonnage: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				levelNo: [
					{
						required: true,
						message: '级别编码不能为空',
						trigger: 'blur'
					}
				],
				levelName: [
					{
						required: true,
						message: '级别名称不能为空',
						trigger: 'blur'
					}
				],
				categoryName: [
					{
						required: true,
						message: '分类名称不能为空',
						trigger: 'blur'
					}
				],
				height: [
					{
						required: true,
						message: '厚度不能为空',
						trigger: 'blur'
					}
				],
				length: [
					{
						required: true,
						message: '长度不能为空',
						trigger: 'blur'
					}
				],
				width: [
					{
						required: true,
						message: '宽度不能为空',
						trigger: 'blur'
					}
				],
				tonnage: [
					{
						required: true,
						message: '吨位差不能为空',
						trigger: 'blur'
					}
				]
			},
			test: [],
			columns: [
				{ key: 0, label: `级别编码`, visible: true },
				{ key: 1, label: `级别名称`, visible: true },
				{ key: 2, label: `分类编号`, visible: true },
				{ key: 3, label: `分类名称`, visible: true },
				{ key: 4, label: `厚度`, visible: true },
				{ key: 5, label: `长度`, visible: true },
				{ key: 6, label: `宽度`, visible: true },
				{ key: 7, label: `吨位差`, visible: true }
			],
			// 产品分类信息
			categoryList: [],
			defaultProps: {
				children: 'children',
				label: 'label'
			},
			// 弹窗中的 级别编码 分类名称
			tempCategoryInfo: {
				levelNo: '',
				categoryName: ''
			},
			// 添加产品分类的弹窗
			addCategoryOpen: false,
			// 添加产品级别的弹窗
			addProductLevelOpen: false,
			// 弹窗中的分类列表 包含分类编码 分类名称
			tempCategoryList: [],

			// 添加字典信息
			addDictInfo: {
				dictLabel: '',
				dictSort: '',
				dictType: 'order_product_categories',
				dictValue: '',
				listClass: 'default',
				status: '0' // 区分分类的开启信息
			},

			// 添加产品级别的表单参数
			addCategoryModel: {},
			// 字典列表
			dictObj: {},

			// created 查询类型字典信息
			dictList: [],

			// 分类
			level_total: 0,
			level_pageNum: 1,
			level_pageSize: 10,

			// 最大的级别编码数
			maxCategoryNo: null,

			// 左侧树表的数据
			tempCategories: [],

			category_total: 0,
			category_pageNum: 1,
			category_pageSize: 20
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('productlevel-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		// 获取树
		this.getCategoryList();

		if (localStorage.getItem('productlevel-columns') === 'null' || !localStorage.getItem('productlevel-columns')) {
			// 设置localStorage
			localStorage.setItem('productlevel-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('productlevel-columns'));
		}
	},
	methods: {
		// 监听产品分类变化 自动填充分类编码 查询各个分类的最大级别数，然后+1后存储
		handleChangeLevelNo(newVal) {
			if (newVal) {
				getMaxLevelNo().then(res => {
					const _levelMap = res?.data;
					const category = this.dictList.find(item => item.dictLabel === newVal);
					if (!category) {
						this.$message.error('分类名称不存在!');
						return;
					}
					// 自动填充分类编码
					this.addCategoryModel.categoryNo = category.dictValue;
					if (!_levelMap) {
						this.$message.error('请先添加分类!');
						return;
					}
					if (!_levelMap[this.addCategoryModel.categoryNo]) {
						this.$message.warning('无相关数据 已生成');
						this.$nextTick(() => {
							this.$set(this.addCategoryModel, 'levelNo', this.addCategoryModel.categoryNo + 1);
						});
						return;
					}
					this.$nextTick(() => {
						this.$set(this.addCategoryModel, 'levelNo', this.addCategoryModel.categoryNo + (Number(_levelMap[this.addCategoryModel.categoryNo]) + 1));
					});
				});
			}
		},
		validateLevelNo(val) {
			// 校验newVal的值，只能是数字 如果是其他就提示
			if (isNaN(val)) {
				this.$message.error('请输入数字');
				this.tempCategoryInfo.levelNo = '';
			}
		},
		validateFormCategory(newVal) {
			if (newVal !== null) {
				this.form.categoryNo = this.dictList.find(item => item.dictLabel === newVal).dictValue;
			}
		},
		// 左侧的产品列表点击某个分类
		handleNodeClick(data) {
			// 发请求  获取数据
			listProductLevel({ categoryNo: data.value }).then(res => {
				this.productLevelList = res.rows;
			});
		},
		// 点击添加产品分类信息
		handleAddProductSort() {
			// +1的操作
			function plusOne(maxValue) {
				let arr = maxValue.split('');
				for (let i = arr.length - 1; i >= 0; i--) {
					arr[i] = Number(arr[i]) + 1 + '';
					arr[i] = (Number(arr[i]) % 10) + '';

					if (arr[i] !== '0') {
						return arr.join('');
					}
				}
				arr.map(() => '0');
				arr.unshift(1);
				return arr.join('');
			}

			// 获取产品字典信息 为了自动填充最大的分类编码
			getDicts('order_product_categories').then(res => {
				// 如果没有数据 则默认为001
				if (!res.data || res.data.length === 0) {
					this.tempCategoryInfo.levelNo = '001';
					// 否则获取最大的分类编码
				} else {
					const maxNo = Math.max(...res.data.map(obj => Number(obj.dictValue)));
					let maxValue = res.data.find(obj => Number(obj.dictValue) === maxNo).dictValue;
					this.tempCategoryInfo.levelNo = plusOne(maxValue);
				}
				this.getDictsData();
				this.addCategoryOpen = true;
			});
		},
		// 点击新增产品级别信息获取字典数据
		getDictsValues() {
			getDicts('order_product_categories').then(res => {
				this.dictList = res.data;
			});
		},
		// 点击添加产品级别信息
		handleAddProductLevel() {
			this.getDictsValues();
			this.addProductLevelOpen = true;
		},
		// 点击编辑
		handleClickCategoryList(row) {
			this.tempCategoryInfo.dictCode = row.dictCode;
			this.tempCategoryInfo.levelNo = row.dictValue;
			this.tempCategoryInfo.categoryName = row.dictLabel;
		},
		// 点击提交 这里修改产品分类 添加到字典中
		submitAddCategory() {
			// 两种情况 如果没有自动填充dictCode 说明是新增 需要添加到字典中 其他则是修改
			if (this.tempCategoryInfo.dictCode) {
				// 添加到字典中
				this.addDictInfo.dictLabel = this.tempCategoryInfo.categoryName;
				this.addDictInfo.dictValue = this.tempCategoryInfo.levelNo;
				this.addDictInfo.dictCode = this.tempCategoryInfo.dictCode;
				updateData(this.addDictInfo).then(() => {
					this.$message.success('修改成功~');
					this.getList();
					location.reload();
					this.cancelAddProductLevel();
				});
			} else {
				// 新增
				this.addDictInfo.dictLabel = this.tempCategoryInfo.categoryName;
				this.addDictInfo.dictValue = this.tempCategoryInfo.levelNo;
				// 字典类型为 'order_product_categories'
				this.addDictInfo.dictType = 'order_product_categories';
				addData(this.addDictInfo).then(() => {
					this.$message.success('添加成功~');
					this.getList();
					location.reload();
					this.cancelAddProductLevel();
				});
			}
		},
		// 删除分类 row.dictCode
		handleDeteleLevel(row) {
			this.$confirm('是否要删除该分类?', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				delData(row.dictCode).then(() => {
					this.$message({
						type: 'success',
						message: '删除成功!'
					});
				});
				this.getList();
			});
		},

		// 点击添加级别信息
		submitAddLevel() {
			this.$refs['productForm'].validate(valid => {
				if (valid) {
					addProductLevel(excludeParams(this.addCategoryModel, this.$exclude)).then(() => {
						this.$message.success('添加成功~');
						this.cancelAddProductCategory();
						this.getList();
					});
				}
			});
		},
		// 查询产品级别列表
		getList() {
			this.loading = true;
			listProductLevel(this.queryParams).then(response => {
				this.productLevelList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 分页获取左边的分类树
		getCategoryList() {
			listData({
				dictType: 'order_product_categories',
				pageNum: this.category_pageNum,
				pageSize: this.category_pageSize
			}).then(res => {
				this.tempCategories = res.rows
					.map(item => {
						return {
							label: item.dictLabel,
							value: item.dictValue,
							children: ''
						};
					})
					.sort((a, b) => Number(a.value) - Number(b.value));
				this.category_total = res.total;
			});
		},
		// 添加产品分类弹窗中的分页获取数据的函数
		getDictsData() {
			listData({
				dictType: 'order_product_categories',
				pageNum: this.level_pageNum,
				pageSize: this.level_pageSize
			}).then(res => {
				this.tempCategoryList = res.rows;
				this.level_total = res.total;
			});
		},
		cancelAddProductLevel() {
			this.addCategoryOpen = false;
			this.tempCategoryInfo = {
				dictCode: '',
				levelNo: '',
				categoryName: ''
			};
		},
		cancelAddProductCategory() {
			this.resetCategoryModel();
			this.addProductLevelOpen = false;
		},
		resetCategoryModel() {
			this.addCategoryModel = {
				categoryName: '',
				levelNo: '',
				levelName: '',
				height: '',
				length: '',
				width: '',
				tonnage: '',
				addtime: '',
				userId: '',
				UserName: ''
			};
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				levelNo: null,
				levelName: null,
				categoryNo: null,
				categoryName: null,
				height: null,
				length: null,
				width: null,
				tonnage: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};

			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getProductLevel(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改产品级别';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						updateProductLevel(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						addProductLevel(this.form).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除产品级别编号为"' + ids + '"的数据项？')
				.then(function () {
					return delProductLevel(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/productLevel/export',
				{
					...this.queryParams
				},
				`productLevel_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
