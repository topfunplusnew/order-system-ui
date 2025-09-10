<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="日期" prop="fundsDate">
				<el-input v-model="queryParams.fundsDate" placeholder="请输入日期" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input v-model="queryParams.otherAcountsName" placeholder="请输入对方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方账号" prop="otherBankNo">
				<el-input v-model="queryParams.otherBankNo" placeholder="请输入对方账号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方开户行" prop="otherBankName">
				<el-input v-model="queryParams.otherBankName" placeholder="请输入对方开户行" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方公司" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入对方公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:paymentapply:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增付款信息</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:paymentapply:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
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

		<!--    列表-->
		<el-table id="printBox" v-horizontal-scroll="'always'" v-loading="loading" border :data="paymentApplyList" @selection-change="handleSelectionChange">
			<!--      <el-table-column label="对应的表名" align="center" prop="tableName"/>-->
			<!--      <el-table-column label="对应的表主键" align="center" prop="tID"/>-->
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="fundsDate" />
			<el-table-column v-if="columns[1].visible" label="支付类型" align="center" prop="payType" />
			<el-table-column v-if="columns[2].visible" label="金额" align="center" prop="moneyAmount" />
			<el-table-column v-if="columns[3].visible" label="对方户名" align="center" prop="otherAcountsName" />
			<el-table-column v-if="columns[4].visible" label="对方账号" align="center" prop="otherBankNo" />
			<el-table-column v-if="columns[5].visible" label="对方开户行" align="center" prop="otherBankName" />
			<el-table-column v-if="columns[6].visible" label="对方公司" align="center" prop="companyName" />
			<!--      <el-table-column label="对方公司ID" align="center" prop="companyId"/>-->
			<el-table-column v-if="columns[7].visible" label="对方公司类型" align="center" prop="companyType" />
			<el-table-column v-if="columns[8].visible" label="付款原因" align="center" prop="reason" />
			<el-table-column v-if="columns[9].visible" label="附件" align="center" prop="attachmentList">
				<template #default="scope">
					<CheckFiles
						:attachmentList="scope.row.attachmentList"
						@needToUpdate="value => handleUpdateFilePath(value, scope.row, getPaymentApply, updatePaymentApply)"
						:is-upload="false"
						flag="attachmentList"
					/>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="申请人" align="center" prop="applyPerson" />
			<!--      <el-table-column label="申请人ID" align="center" prop="applyPersonID"/>-->
			<el-table-column v-if="columns[11].visible" label="审核状态" align="center" prop="checkState">
				<template slot-scope="scope">
					<el-tag :type="scope.row.checkState === '通过' ? 'success' : 'danger'" disable-transitions>
						{{ scope.row.checkState }}
					</el-tag>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[12].visible" label="备注" align="center" prop="comments" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:paymentapply:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:paymentapply:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
					<el-button v-hasPermi="['system:paymentapply:remove']" size="mini" @click="checkPaymentApplyInfo(scope.row)">查看信息</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 2.添加或修改付款信息对话框 -->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="付款申请"
			:visible.sync="open"
			width="500px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<!--        表名要自动填充 手动添加无需-->
				<!--        <el-form-item label="对应的表名" prop="tableName">-->
				<!--          <el-input v-model="form.tableName" placeholder="请输入对应的表名"/>-->
				<!--        </el-form-item>-->
				<!--        <el-form-item label="对应的表主键" prop="tID">-->
				<!--          <el-input v-model="form.tID" placeholder="请输入对应的表主键"/>-->
				<!--        </el-form-item>-->
				<el-form-item label="日期" prop="fundsDate">
					<el-date-picker v-model="form.fundsDate" type="datetime" placeholder="选择日期"></el-date-picker>
				</el-form-item>
				<el-form-item label="支付类型" prop="payType">
					<!--          <el-input v-model="form.receiveType" placeholder="请输入支付类型"/>-->
					<el-row :gutter="5">
						<!--            一级分类-->
						<el-col :span="8">
							<el-select v-model="currentSort.levelOne" placeholder="请选择一级分类" @change="handleSelectOneLevel">
								<el-option v-for="item in OneLevelOption" :key="item.id" :label="item.title" :value="item.title"></el-option>
							</el-select>
						</el-col>
						<!--            二级分类-->
						<el-col :span="8">
							<el-select v-model="currentSort.levelTwo" placeholder="请选择二级分类" @change="handleSelectTwoLevel">
								<el-option v-for="item in TwoLevelOption" :key="item.id" :label="item.title" :value="item.title"></el-option>
							</el-select>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>

				<!--        对方信息-->
				<el-form-item label="对方户名" prop="otherAcountsName">
					<el-row>
						<el-col :span="10">
							<el-input v-model="form.otherAcountsName" placeholder="请输入对方户名" />
						</el-col>
						<el-col :span="3">
							<SearchOption :get-data="listCompany" icon="el-icon-search" @commitBack="handleCommitBack">
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName" />
									<el-table-column label="公司类型" align="center" prop="companyType" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="账号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方账号" prop="otherBankNo">
					<el-input v-model="form.otherBankNo" placeholder="请输入对方账号" />
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" />
				</el-form-item>
				<el-form-item label="对方公司" prop="companyName">
					<el-input v-model="form.companyName" placeholder="请输入对方公司" />
				</el-form-item>
				<!--        <el-form-item label="对方公司ID" prop="companyId">-->
				<!--          <el-input v-model="form.companyId" placeholder="请输入对方公司ID"/>-->
				<!--        </el-form-item>-->

				<el-form-item label="付款原因" prop="reason">
					<el-input v-model="form.reason" type="textarea" placeholder="请输入内容" />
				</el-form-item>

				<!--        文件-->
				<el-form-item label="附件" prop="attachmentList">
					<UploadFilesButton flag="attachmentList" :initial-attachments="(form.params && form.params.attachments) || []" @files-updated="handleAttachmentFilesUpdated" />
				</el-form-item>

				<!--        发起付款人的信息-->
				<!--        <el-form-item label="申请人" prop="applyPerson">-->
				<!--          <el-input v-model="form.applyPerson" placeholder="请输入申请人"/>-->
				<!--        </el-form-item>-->
				<!--        <el-form-item label="申请人ID" prop="applyPersonID">-->
				<!--          <el-input v-model="form.applyPersonID" placeholder="请输入申请人ID"/>-->
				<!--        </el-form-item>-->
				<!--        <el-form-item label="审核状态" prop="checkState">-->
				<!--          <el-input v-model="form.checkState" placeholder="请输入审核状态"/>-->
				<!--        </el-form-item>-->
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    查看-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="查看信息" :visible.sync="checkVisible" width="30%">
			<NeedToShowInfo :need-to-show-info="needToShowInfo" :table-name-to-prop="tableName" />
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkVisible = false">取 消</el-button>
				<el-button type="primary" @click="checkVisible = false">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { listPaymentApply, getPaymentApply, delPaymentApply, addPaymentApply, updatePaymentApply } from '@/api/system/paymentApply';
import { excludeParams } from '@/api/tool/exclude';
import { listSubject } from '@/api/system/subject';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import NeedToShowInfo from '@/components/NeedToShowInfo.vue';
import { TableName } from '@/api/tool/enums';
import { getOrderFreight } from '@/api/system/orderFreight';
import { getBorrowedMoney } from '@/api/system/borrowedMoney';
import { findFileExtension } from '@/utils/trash/utils';
import CheckFiles from '@/components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';

export default {
	name: 'PaymentApply',
	components: { CheckFiles, UploadFilesButton, NeedToShowInfo, SearchOption },
	mixins: [mixin_checkfile],
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
			// 付款信息表格数据
			paymentApplyList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				tableName: null,
				tID: null,
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				attachmentList: [],
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				submitflag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {},
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `支付类型`, visible: true },
				{ key: 2, label: `金额`, visible: true },
				{ key: 3, label: `对方户名`, visible: true },
				{ key: 4, label: `对方账号`, visible: true },
				{ key: 5, label: `对方开户行`, visible: true },
				{ key: 6, label: `对方公司`, visible: true },
				{ key: 7, label: `对方公司类型`, visible: true },
				{ key: 8, label: `付款原因`, visible: true },
				{ key: 9, label: `附件`, visible: true },
				{ key: 10, label: `申请人`, visible: true },
				{ key: 11, label: `审核状态`, visible: true },
				{ key: 12, label: `备注`, visible: true }
			],
			// 付款分类信息
			subjectTree: [],
			// 分类信息
			currentSort: {
				levelOne: '',
				levelTwo: ''
			},
			// 一级分类列表
			OneLevelOption: [],
			// 二级分类
			TwoLevelOption: [],

			checkVisible: false,
			needToShowInfo: {},
			tableName: ''
		};
	},
	computed: {
		TableName() {
			return TableName;
		},
		fullLevel() {
			return this.currentSort.levelOne + '-' + this.currentSort.levelTwo;
		}
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('paymentapply-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('paymentapply-columns') === 'null' || !localStorage.getItem('paymentapply-columns')) {
			// 设置localStorage
			localStorage.setItem('paymentapply-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('paymentapply-columns'));
		}
		listSubject({}, true).then(res => {
			this.subjectTree = this.handleTree(res.data, 'id', 'parentId');
			this.OneLevelOption = this.subjectTree;
		});
	},
	methods: {
		listCompany,
		// 附件
		isPic(url) {
			console.log(url);
			return this.$imgs.includes(findFileExtension(url));
		},
		// 点击一级分类后的回调
		handleSelectOneLevel(value) {
			this.currentSort.levelOne = value;
			for (var i = 0; i < this.OneLevelOption.length; i++) {
				// 每个一级分类
				var oneSubject = this.OneLevelOption[i];
				// 判断：所有一级分类id和点击一级分类id是否一样
				if (value === oneSubject.title) {
					// ===即比较值 还要比较类型
					// 从一级分类中获取所有的二级分类
					this.TwoLevelOption = oneSubject.children;
					// 把二级分类Id值清空
					this.currentSort.levelTwo = '';
				}
			}
		},
		// 点击二级
		handleSelectTwoLevel(value) {
			this.currentSort.levelTwo = value;
		},

		// 对方信息 - 点击确认后自动填充
		handleCommitBack(val) {
			this.form.otherBankNo = val.bankNo;
			this.form.otherBankName = val.bankName;
			this.form.companyName = val.companyName;
			this.form.companyId = val.id;
			this.form.otherAcountsName = val.acountsName;
			this.form.companyType = val.companyType;
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		checkPaymentApplyInfo(row) {
			console.log(row);
			// 根据TableId发请求
			switch (row.tableName) {
				// 订单运费
				case TableName.ORDER_FREIGHT: {
					// 发请求 获取订单运费信息
					getOrderFreight(row.tID).then(res => {
						console.log('运费信息', res);
						this.needToShowInfo = res.data;
						this.tableName = TableName.ORDER_FREIGHT;
					});
					break;
				}
				case TableName.BORROWED_MONEY:
					getBorrowedMoney(row.tID).then(res => {
						console.log('借款信息', res);
						this.needToShowInfo = res.data;
						this.tableName = TableName.BORROWED_MONEY;
					});
					break;

				// todo 这里继续加表名 然后发请求获取数据 赋值给需要展示的needToShowInfo 然后创建组件
				case 'paymentApplyDetailItem':
					// this.needToShowInfo = item.paymentApplyDetailItem;
					break;
				default:
					break;
			}
			// 查询信息
			this.checkVisible = true;
		},
		/** 查询付款信息列表 */
		getList() {
			this.loading = true;
			listPaymentApply(this.queryParams).then(response => {
				this.paymentApplyList = response.rows;
				this.total = response.total;
				this.loading = false;
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
				tableName: null,
				tID: null,
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				attachmentList: [],
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				submitflag: null,
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('form');
		},
		// 附件更新处理
		handleAttachmentFilesUpdated(files) {
			if (this.form && this.form.params) {
				this.form.params.attachmentIds = files.map(file => file.id);
			}
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
			this.title = '添加付款信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getPaymentApply(id).then(response => {
				this.form = response.data;
				// 确保 params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 确保 attachmentIds 是数组
				if (!Array.isArray(this.form.params.attachmentIds)) {
					this.form.params.attachmentIds = [];
				}
				// 处理附件列表
				if (this.form.attachmentList && Array.isArray(this.form.attachmentList)) {
					this.form.params.attachments = this.form.attachmentList;
					this.form.params.attachmentIds = this.form.attachmentList.map(item => item.id);
				} else {
					this.form.params.attachments = [];
				}
				this.open = true;
				this.title = '修改付款信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 保存当前附件ID用于错误回滚
					const originalAttachmentIds = this.$store.getters.attachmentIds ? [...this.$store.getters.attachmentIds] : [];

					// 去重附件ID
					const uniqueAttachmentIds = [...new Set(originalAttachmentIds)];
					if (uniqueAttachmentIds.length !== originalAttachmentIds.length) {
						// 清空并重新添加去重后的ID
						this.$store.commit('CLEAR_ATTACHMENT_IDS');
						uniqueAttachmentIds.forEach(id => {
							this.$store.commit('ADD_ATTACHMENT_ID', id);
						});
					}

					if (this.form.id != null) {
						// 排除不必要字段
						excludeParams(this, this.$exclude);
						updatePaymentApply(this.form)
							.then(response => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								console.error('修改付款申请失败:', error);
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('修改失败，请重试');
							});
					} else {
						excludeParams(this, this.$exclude);
						this.form.payType = this.fullLevel;
						addPaymentApply(this.form)
							.then(response => {
								this.$modal.msgSuccess('新增成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								console.error('新增付款申请失败:', error);
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('新增失败，请重试');
							});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除付款信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delPaymentApply(ids);
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
				'system/paymentApply/export',
				{
					...this.queryParams
				},
				`paymentApply_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
