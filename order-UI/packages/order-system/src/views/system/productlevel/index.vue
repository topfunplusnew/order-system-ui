<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="分类名称" prop="categoryName">
				<el-input v-model="queryParams.categoryName" placeholder="请输入分类名称" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'categoryName')" />
			</el-form-item>
			<el-form-item label="级别名称" prop="levelName">
				<el-input v-model="queryParams.levelName" placeholder="请输入级别名称" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'levelName')" />
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
				<el-table-column v-if="columns[0].visible" label="级别编码" align="center" prop="levelNo" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.levelNo }}</div>
							<span>{{ scope.row.levelNo }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[1].visible" label="级别名称" align="center" prop="levelName" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.levelName }}</div>
							<span>{{ scope.row.levelName }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[2].visible" label="分类编号" align="center" prop="categoryNo" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.categoryNo }}</div>
							<span>{{ scope.row.categoryNo }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[3].visible" label="分类名称" align="center" prop="categoryName" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.categoryName }}</div>
							<span>{{ scope.row.categoryName }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[4].visible" label="厚度" align="center" prop="height" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.height }}</div>
							<span>{{ scope.row.height }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[5].visible" label="长度" align="center" prop="length" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.length }}</div>
							<span>{{ scope.row.length }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[6].visible" label="宽度" align="center" prop="width" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.width }}</div>
							<span>{{ scope.row.width }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[7].visible" label="吨位差" align="center" prop="tonnage" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<div slot="content">{{ scope.row.tonnage }}</div>
							<span>{{ scope.row.tonnage }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
					<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
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
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="添加产品分类"
			:visible.sync="addCategoryOpen"
			width="600px"
		>
			<el-row>
				<el-col :span="12">
					<el-row>
						<span>级别编码</span>
					</el-row>
					<el-row>
						<el-input disabled v-model="tempCategoryInfo.levelNo" placeholder="请输入级别编码" @input="validateLevelNo"></el-input>
					</el-row>
				</el-col>
				<el-col :span="12">
					<el-row>
						<span>分类名称</span>
					</el-row>
					<el-row>
						<el-input v-model="tempCategoryInfo.categoryName" placeholder="请输入分类名称" @input="handleInputTrim($event, 'tempCategoryInfo', 'categoryName')"></el-input>
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
					<el-table-column prop="dictValue" label="分类编码"></el-table-column>
					<el-table-column prop="dictLabel" label="分类名称"></el-table-column>
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
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="添加产品级别"
			:visible.sync="addProductLevelVisible"
			width="600px"
		>
			<!--      添加产品级别的表单-->
			<el-form ref="productForm" :model="addCategoryModel" size="mini" label-width="120px" :rules="rules" @keyup.enter.native="submitAddLevel" @submit.native.prevent="submitAddLevel">
				<el-form-item label="分类" prop="categoryName">
					<el-select v-model="addCategoryModel.categoryName" placeholder="请选择分类名称" @change="handleChangeLevelNo">
						<el-option v-for="item in dict.type.order_product_categories" :key="item.value" :label="item.label" :value="item.label"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="分类编号" prop="categoryNo">
					<el-input v-model="addCategoryModel.categoryNo" placeholder="请输入分类编号" @input="handleInputTrim($event, 'addCategoryModel', 'categoryNo')" />
				</el-form-item>
				<el-form-item label="级别编码" prop="levelNo">
					<el-input v-model="addCategoryModel.levelNo" placeholder="请输入级别编码" @input="handleInputTrim($event, 'addCategoryModel', 'levelNo')"></el-input>
				</el-form-item>
				<el-form-item label="级别名称" prop="levelName">
					<el-input v-model="addCategoryModel.levelName" placeholder="请输入级别名称" @input="handleInputTrim($event, 'addCategoryModel', 'levelName')"></el-input>
				</el-form-item>
				<el-form-item label="厚度" prop="height">
					<el-input v-model="addCategoryModel.height" placeholder="请输入厚度" @input="handleNumberInput($event, 'addCategoryModel', 'height')"></el-input>
				</el-form-item>
				<el-form-item label="长度" prop="length">
					<el-input v-model="addCategoryModel.length" placeholder="请输入长度" @input="handleNumberInput($event, 'addCategoryModel', 'length')"></el-input>
				</el-form-item>
				<el-form-item label="宽度" prop="width">
					<el-input v-model="addCategoryModel.width" placeholder="请输入宽度" @input="handleNumberInput($event, 'addCategoryModel', 'width')"></el-input>
				</el-form-item>
				<el-form-item label="吨位差" prop="tonnage">
					<el-input v-model="addCategoryModel.tonnage" placeholder="请输入吨位差" @input="handleNumberInput($event, 'addCategoryModel', 'tonnage')"></el-input>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitAddLevel">保 存</el-button>
				<el-button @click="cancelAddProductCategory">取 消</el-button>
			</span>
		</el-dialog>

		<!-- 添加或修改产品级别对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px" @keyup.enter.native="submitForm">
				<el-form-item label="级别编码" prop="levelNo">
					<el-input v-model="form.levelNo" placeholder="请输入支付类型" @input="handleInputTrim($event, 'form', 'levelNo')" />
				</el-form-item>
				<el-form-item label="级别名称" prop="levelName">
					<el-input v-model="form.levelName" placeholder="请输入级别名称" @input="handleInputTrim($event, 'form', 'levelName')" />
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
					<el-input v-model="form.height" placeholder="请输入厚度" @input="handleNumberInput($event, 'form', 'height')" />
				</el-form-item>
				<el-form-item label="长度" prop="length">
					<el-input v-model="form.length" placeholder="请输入长度" @input="handleNumberInput($event, 'form', 'length')" />
				</el-form-item>
				<el-form-item label="宽度" prop="width">
					<el-input v-model="form.width" placeholder="请输入宽度" @input="handleNumberInput($event, 'form', 'width')" />
				</el-form-item>
				<el-form-item label="吨位差" prop="tonnage">
					<el-input v-model="form.tonnage" placeholder="请输入吨位差" @input="handleNumberInput($event, 'form', 'tonnage')" />
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
				pageSize: 20,
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
					},
					{
						pattern: /^-?(0|[1-9]\d*)(\.\d+)?$/,
						message: '厚度必须是有效的数字',
						trigger: 'blur'
					}
				],
				length: [
					{
						required: true,
						message: '长度不能为空',
						trigger: 'blur'
					},
					{
						pattern: /^-?(0|[1-9]\d*)(\.\d+)?$/,
						message: '长度必须是有效的数字',
						trigger: 'blur'
					}
				],
				width: [
					{
						required: true,
						message: '宽度不能为空',
						trigger: 'blur'
					},
					{
						pattern: /^-?(0|[1-9]\d*)(\.\d+)?$/,
						message: '宽度必须是有效的数字',
						trigger: 'blur'
					}
				],
				tonnage: [
					{
						required: true,
						message: '吨位差不能为空',
						trigger: 'blur'
					},
					{
						pattern: /^-?(0|[1-9]\d*)(\.\d+)?$/,
						message: '吨位差必须是有效的数字',
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
			addProductLevelVisible: false,
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
			level_pageSize: 20,

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
		// 处理输入框禁止输入空格
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},
		// 处理数字输入框，允许正数和小数
		handleNumberInput(val, obj, prop) {
			// 移除所有非数字、小数点和负号的字符
			let cleanValue = val.replace(/[^\d.-]/g, '');

			// 确保只有一个小数点
			let parts = cleanValue.split('.');
			if (parts.length > 2) {
				cleanValue = parts[0] + '.' + parts.slice(1).join('');
			}

			// 确保只有一个负号，且在开头
			if (cleanValue.includes('-')) {
				let negativeCount = (cleanValue.match(/-/g) || []).length;
				if (negativeCount > 1 || cleanValue.indexOf('-') !== 0) {
					// 移除多余的负号或不在开头的负号
					cleanValue = cleanValue.replace(/-/g, '');
					if (val.charAt(0) === '-') {
						cleanValue = '-' + cleanValue;
					}
				}
			}

			// 防止以小数点开头（除非前面有负号）
			if (cleanValue.startsWith('.')) {
				cleanValue = '0' + cleanValue;
			} else if (cleanValue.startsWith('-.')) {
				cleanValue = '-0' + cleanValue.substring(1);
			}

			// 防止以0开头但不是0.xx或-0.xx的情况
			if (cleanValue.length > 1 && cleanValue.startsWith('0') && !cleanValue.startsWith('0.')) {
				cleanValue = cleanValue.substring(1);
			} else if (cleanValue.length > 2 && cleanValue.startsWith('-0') && !cleanValue.startsWith('-0.')) {
				cleanValue = '-' + cleanValue.substring(2);
			}

			this[obj][prop] = cleanValue;
		},
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
						this.$set(this.addCategoryModel, 'levelNo', this.addCategoryModel.categoryNo + this.plusOne(_levelMap[this.addCategoryModel.categoryNo]));
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
			// 发请求  获取数据 TODO
			listProductLevel({ categoryNo: data.value, pageNum: this.queryParams.pageNum, pageSize: this.queryParams.pageSize }).then(res => {
				this.productLevelList = res.rows;
			});
		},
		plusOne(maxValue) {
			let arr = maxValue.split('');
			let carry = 1; // 进位标志，初始为1（要加1）
			const originalLength = arr.length; // 保存原始长度
			// 从右到左逐位处理
			for (let i = arr.length - 1; i >= 0; i--) {
				if (carry === 0) {
					// 没有进位了，直接跳出循环
					break;
				}

				// 当前位加上进位
				let sum = Number(arr[i]) + carry;
				carry = Math.floor(sum / 10); // 计算新的进位
				arr[i] = (sum % 10).toString(); // 当前位的值
			}

			// 如果还有进位，需要在前面添加1
			if (carry > 0) {
				arr.unshift('1');
			}

			// 保持原有的位数（前面补0）
			while (arr.length < originalLength) {
				console.log(`需要进位`);
				arr.unshift('0');
			}

			return arr.join('');
		},
		// 点击添加产品分类信息
		handleAddProductSort() {
			// 获取产品字典信息 为了自动填充最大的分类编码
			getDicts('order_product_categories').then(res => {
				// 如果没有数据 则默认为001
				if (!res.data || res.data.length === 0) {
					this.tempCategoryInfo.levelNo = '001';
					// 否则获取最大的分类编码
				} else {
					const maxNo = Math.max(...res.data.map(obj => Number(obj.dictValue)));
					let maxValue = res.data.find(obj => Number(obj.dictValue) === maxNo).dictValue;
					console.log(`maxValue:`, maxValue);
					console.log(`plusOne(maxValue):`, this.plusOne(maxValue));
					this.tempCategoryInfo.levelNo = this.plusOne(maxValue);
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
			this.addProductLevelVisible = true;
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
				this.addDictInfo.dictSort = this.tempCategoryInfo.dictCode;
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
			this.$antdconfirm({
				title: '提示',
				content: '是否要删除该分类?',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						await delData(row.dictCode);
						// 处理弹窗内分页边界：若当前页只有1条且不是第1页，删除后回退一页
						if (this.level_pageNum > 1 && this.tempCategoryList && this.tempCategoryList.length === 1) {
							this.level_pageNum = this.level_pageNum - 1;
						}
						await this.getDictsData();
						await this.getCategoryList();
						// 若右侧当前筛选分类等于被删分类，则清空筛选并刷新列表
						if (this.queryParams && this.queryParams.categoryNo === row.dictValue) {
							this.queryParams.categoryNo = null;
						}
						await this.getList();
						this.$message.success('删除成功!');
					} catch {
						this.$message.error('删除失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消删除操作');
				}
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
			return listData({
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
			return listData({
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
			this.addProductLevelVisible = false;
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
