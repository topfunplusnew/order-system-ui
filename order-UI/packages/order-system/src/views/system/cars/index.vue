<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="车牌" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入车牌" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'carNo')" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:cars:add']" type="danger" size="mini" @click="handleAdd">添加车辆信息</el-button>
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
						<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="carsList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="车牌/柜号" align="center" prop="carNo" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="司机姓名/海运公司" align="center" prop="driver" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="司机电话" align="center" prop="tel" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="运输类型" align="center" prop="carType" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="checkBankInfo(scope.row)">查看银行卡</el-button>
					<el-button v-hasPermi="['system:cars:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:cars:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改外部车辆信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="120px" @keyup.enter.native="submitForm" @submit.native.prevent="submitForm">
				<el-form-item label="运输类型" prop="carType">
					<el-radio v-model="form.carType" label="陆运">陆运</el-radio>
					<el-radio v-model="form.carType" label="海运">海运</el-radio>
				</el-form-item>
				<el-form-item v-if="form.carType === '陆运'" label="车牌" prop="carNo">
					<el-input v-model="form.carNo" placeholder="请输入车牌" @input="handleCheckInput" @blur="handleCheckIsExits" />
				</el-form-item>
				<!--        陆运司机名称或者 海运公司-->
				<el-form-item :label="form.carType === '陆运' ? '司机' : '海运公司'" prop="driver">
					<el-input v-model="form.driver" :placeholder="form.carType === '陆运' ? '请输入司机' : '请输入海运公司'" @input="handleInputTrim($event, 'form', 'driver')" />
				</el-form-item>
				<el-form-item :label="form.carType === '陆运' ? '司机电话' : '联系电话'" prop="tel">
					<el-input v-model="form.tel" :placeholder="form.carType === '陆运' ? '请输入司机电话' : '请输入联系电话'" @input="handleInputTrim($event, 'form', 'tel')" />
				</el-form-item>
				<el-form-item label="开户行" prop="bankName">
					<el-row>
						<el-col :span="10">
							<el-input v-model="form.bankName" placeholder="请输入开户行" @input="handleInputTrim($event, 'form', 'bankName')" />
						</el-col>
						<el-col :span="3">
							<SearchOption
								title="搜索未绑定的司机银行卡"
								:limit-info="{
									acountsType: '司机',
									companyId: 0
								}"
								:get-data="listBankAccount"
								icon="el-icon-search"
								query-info="acountsName"
								query-label="开户名查找"
								:query-name="queryCars"
								@commitBack="handleCommitBack"
								@update:queryName="handleCommitQueryName"
							>
								<template #table-columns>
									<el-table-column label="账号类型" align="center" prop="acountsType" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="账号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="开户名" prop="acountsName">
					<el-input v-model="form.acountsName" placeholder="请输入开户名" @input="handleInputTrim($event, 'form', 'acountsName')" />
				</el-form-item>
				<el-form-item label="账号" prop="bankNo">
					<el-input v-model="form.bankNo" placeholder="请输入账号" @input="handleInputTrim($event, 'form', 'bankNo')" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    查看银行卡组件-->
		<keep-alive>
			<DialogListShow :title="'司机银行卡信息'" :get-data="listBankAccount" :query-object="queryObject" :visible.sync="driverBankAccout">
				<template #column>
					<el-table-column label="账号类型" align="center" prop="acountsType" />
					<el-table-column label="开户行" align="center" prop="bankName" />
					<el-table-column label="开户名" align="center" prop="acountsName" />
					<el-table-column label="账号" align="center" prop="bankNo" />
				</template>
			</DialogListShow>
		</keep-alive>
	</div>
</template>

<script>
import { listCars, getCars, delCars, addCars, updateCars, checkCarsIsExit } from '@/api/system/cars';
import { excludeParams } from '@/api/tool/exclude';
import SearchOption from '../../../components/SearchOption.vue';
import { listBankAccount } from '../../../api/system/bankAccount';
import DialogListShow from '../../../components/DialogListShow.vue';
import { INFO_TYPE, isUsed } from '../../../api/system/isUsed';
import { checkCustomerIsExit, updateCompany } from '@/api/system/company';
import _ from 'lodash';

export default {
	name: 'Cars',
	components: { DialogListShow, SearchOption },
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			carsList: [],
			title: '',
			open: false,
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				carNo: null,
				driver: null,
				tel: null,
				bankName: null,
				carsName: null,
				bankNo: null,
				carsType: null,
				carType: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			form: {},
			carType: null,
			rules: {
				carNo: [
					{
						required: true,
						validator: (rule, value, callback) => {
							// 只有在陆运类型时才验证车牌号
							if (this.form.carType === '陆运') {
								if (!value) {
									callback(new Error('车牌号不能为空'));
									return;
								}
								const maxLength = 8;
								if (value.length > maxLength) {
									callback(new Error(`车牌长度不能超过${maxLength}位`));
									return;
								}

								// 车牌号格式校验：省份简称（中文）+ 字母和数字
								const platePattern = /^[\u4e00-\u9fa5]+[A-Za-z0-9]*$/;
								if (!platePattern.test(value)) {
									callback(new Error('车牌号格式不正确，应为省份简称（中文）+ 字母数字组合'));
									return;
								}

								callback();
							} else {
								callback();
							}
						},
						trigger: ['blur', 'change']
					}
				],
				driver: [
					{
						required: true,
						validator: (rule, value, callback) => {
							const fieldName = this.form.carType === '陆运' ? '司机姓名' : '海运公司';
							if (!value) {
								callback(new Error(`${fieldName}不能为空`));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				tel: [
					{
						required: true,
						validator: (rule, value, callback) => {
							const fieldName = this.form.carType === '陆运' ? '司机电话' : '联系电话';
							if (!value) {
								callback(new Error(`${fieldName}不能为空`));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				carsName: [
					{
						required: true,
						message: '车辆名称不能为空',
						trigger: 'blur'
					}
				],
				carType: [
					{
						required: true,
						message: '运输类型不能为空',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `车牌/柜号`, visible: true },
				{ key: 1, label: `司机姓名/海运公司`, visible: true },
				{ key: 2, label: `司机电话`, visible: true },
				{ key: 3, label: `运输类型`, visible: true }
			],
			companyList: [],
			queryCars: '',
			// 查询对象
			queryObject: {},
			driverBankAccout: false
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('car-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		'form.carType': {
			handler: function (newVal) {
				// 当选择海运时，清空车牌号字段
				if (newVal === '海运') {
					this.form.carNo = null;
				}
			}
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('car-columns') === 'null' || !localStorage.getItem('car-columns')) {
			localStorage.setItem('car-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('car-columns'));
		}
	},
	methods: {
		// 处理输入框禁止输入空格
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},
		listBankAccount,
		handleCommitBack(val) {
			this.form.bankName = val.bankName;
			this.form.bankNo = val.bankNo;
			this.form.acountsName = val.acountsName;
		},
		handleCommitQueryName(val) {
			this.queryCars = val;
		},
		// 查看银行卡信息
		checkBankInfo(row) {
			console.log(`row`, row);
			this.queryObject = {
				companyId: row.id,
				companyName: row.carNo,
				acountsType: '司机'
			};
			// 查询该银行卡
			this.driverBankAccout = true;
		},
		handleCheckInput(value) {
			// 只有陆运类型才处理车牌号输入
			if (this.form.carType !== '陆运') {
				return;
			}

			// 1. 清除所有空格
			let cleanedValue = value.replace(/\s+/g, '');

			// 2. 车牌号格式校验：省份简称（中文）+ 字母和数字
			// 匹配模式：1个或多个中文字符 + 字母和数字的组合
			const platePattern = /^[\u4e00-\u9fa5]+[A-Za-z0-9]*$/;

			if (cleanedValue && !platePattern.test(cleanedValue)) {
				// 提取有效字符：保留中文字符和字母数字
				const validChars = cleanedValue.match(/[\u4e00-\u9fa5A-Za-z0-9]/g);
				if (validChars) {
					cleanedValue = validChars.join('');
				} else {
					cleanedValue = '';
				}
				this.$message.warning('车牌号只能包含省份简称（中文）和字母数字');
			}

			// 3. 将字母转为大写
			cleanedValue = cleanedValue.toUpperCase();

			// 4. 限制车牌长度
			const maxLength = 8;
			if (cleanedValue.length > maxLength) {
				this.$message.warning(`车牌长度不能超过${maxLength}位`);
				cleanedValue = cleanedValue.substring(0, maxLength);
			}

			// 5. 更新表单数据
			this.form.carNo = cleanedValue;
		},
		handleCheckIsExits() {
			// 只有陆运类型且有车牌号时才检查
			if (this.form.carType === '陆运' && this.form.carNo) {
				const exitId = _.cloneDeep(this.form.id);
				// 如果id不为空,说明为修改,修改时传入id,后端返回true 说明唯一 可以修改 如果返回false,那么后端有问题
				if (exitId) {
					checkCarsIsExit(this.form.carNo, exitId).then(res => {
						if (!res.data) {
							this.$message.error(`检查时出现错误 车牌 ${this.form.carNo} 已存在!`);
						}
					});
				} else {
					checkCarsIsExit(this.form.carNo, null).then(res => {
						if (!res.data) {
							this.$message.error(`车牌 ${this.form.carNo} 已存在,请修改单据信息`);
						}
					});
				}
			}
		},
		/** 查询外部车辆信息列表 */
		getList() {
			this.loading = true;
			listCars(this.queryParams).then(response => {
				this.carsList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 打印
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
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
				carNo: null,
				driver: null,
				tel: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				// 默认值
				carType: '陆运'
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

		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加外部车辆信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getCars(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改外部车辆信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 提交前再次校验车牌/柜号长度（仅对陆运）
					if (this.form.carType === '陆运') {
						const maxLength = 8;
						if (this.form.carNo && this.form.carNo.length > maxLength) {
							this.$message.error(`车牌长度不能超过${maxLength}位`);
							return;
						}
					}

					// 创建提交数据的副本
					let submitData = { ...this.form };

					// 如果是海运类型，移除车牌号字段
					if (this.form.carType === '海运') {
						delete submitData.carNo;
					}

					// 移除 acountsType 字段，不再向后端传递
					delete submitData.acountsType;

					if (this.form.id != null) {
						submitData = excludeParams(submitData, this.$exclude);

						// 对于陆运类型才检查车牌号是否存在
						if (this.form.carType === '陆运') {
							checkCarsIsExit(this.form.carNo, this.form.id).then(res => {
								if (res.data) {
									updateCars(submitData).then(response => {
										this.$modal.msgSuccess('修改成功');
										this.open = false;
										this.getList();
									});
								} else {
									this.$message.error('修改时出现错误:该行ID已存在车牌信息,但数据返回不存在');
								}
							});
						} else {
							// 海运类型直接提交
							updateCars(submitData).then(response => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								this.getList();
							});
						}
					} else {
						// 对于陆运类型才检查车牌号是否存在
						if (this.form.carType === '陆运') {
							checkCarsIsExit(this.form.carNo, null).then(res => {
								if (!res.data) {
									this.$message.error('车牌信息已存在');
									return;
								}
								addCars(submitData).then(response => {
									submitData = excludeParams(submitData, this.$exclude);
									this.$modal.msgSuccess('新增成功');
									this.open = false;
									this.getList();
								});
							});
						} else {
							// 海运类型直接提交
							addCars(submitData).then(response => {
								submitData = excludeParams(submitData, this.$exclude);
								this.$modal.msgSuccess('新增成功');
								this.open = false;
								this.getList();
							});
						}
					}
				}
			});
		},

		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			const query = {
				id: ids,
				type: INFO_TYPE.DRIVER
			};
			// 弹窗删除
			this.$modal
				.confirm('是否确认删除编号为"' + ids + '"的数据项？')
				.then(() => {
					isUsed(query).then(res => {
						if (res.data.isUsed) {
							this.$modal
								.confirm('系统检测该车辆信息:"' + ids + '"的车辆信息数据在系统中被使用，是否要继续删除?')
								.then(function () {
									return delCars(ids);
								})
								.then(() => {
									this.getList();
									this.$modal.msgSuccess('删除成功');
								})
								.catch(() => {});
						} else {
							delCars(ids).then(() => {
								this.getList();
								this.$modal.msgSuccess('删除成功');
							});
						}
					});
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/cars/export',
				{
					...this.queryParams
				},
				`cars_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
