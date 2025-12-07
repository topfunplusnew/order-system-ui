<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="190px">
			<el-form-item label="加油卡卡号" prop="oilCardNo">
				<el-input v-model="queryParams.oilCardNo" placeholder="请输入加油卡卡号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="使用加油卡开始时间" prop="useDateStart">
				<el-date-picker v-model="queryParams.useDateStart" type="datetime" placeholder="选择使用加油卡时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="使用加油卡结束时间" prop="useDateEnd">
				<el-date-picker v-model="queryParams.useDateEnd" type="datetime" placeholder="选择使用加油卡时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="primary" icon="el-icon-plus" size="mini" v-hasPermi="['system:oilcardconsume:add']" @click="handleAdd">新增</el-button>
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
						<el-button v-hasPermi="['system:oilcardconsume:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="OilCardConsumeList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="id" align="center" prop="id" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="加油卡卡号" align="center" prop="oilCardNo" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="使用加油卡时间" align="center" prop="useDate" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="使用加油卡车辆车牌号" align="center" prop="carNo" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="期初余额" align="center" prop="startCardSurplus" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="加油量" align="center" prop="refuelingNumber" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="单价" align="center" prop="unitPrice" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="加油金额(元）" align="center" prop="refuelingMoney" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="加油卡余额" align="center" prop="endCardSurplus" width="110" show-overflow-tooltip />
			<!--      <el-table-column label="加油小票附件" align="center" prop="attachmentOiladd" v-if="columns[10].visible"-->
			<!--                       width="300px"/>-->
			<el-table-column v-if="columns[9].visible" label="加油小票附件" align="center" prop="attachmentOiladd" show-overflow-tooltip>
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles :attachmentList="scope.row.attachmentList" :flag="'attachmentOiladd'" @needToUpdate="value => handleUpdateFilePath(value, scope.row, getOilCardConsume, updateOilCardConsume)" />
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[10].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:oilcardconsume:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:oilcardconsume:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改加油卡消费信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="130px">
				<el-form-item label="加油卡卡号" prop="oilCardNo">
					<el-row>
						<el-col :span="20">
							<el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:limit-info="{}"
								:get-data="listOilCard"
								query-info="oilCardNo"
								query-label="加油卡卡号"
								:query-name="oilCardNoQuery"
								@update:queryName="value => (oilCardNoQuery = value)"
								@commitBack="handleOilCardSelect"
							>
								<template #table-columns>
									<el-table-column label="加油卡卡号" align="center" prop="oilCardNo" />
									<el-table-column label="加油卡类型" align="center" prop="oilType" />
									<el-table-column label="当前金额" align="center" prop="moneyAmount"></el-table-column>
									<el-table-column label="待圈存金额" align="center" prop="virtualMoneyAmount" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="车辆派出记录" prop="carApplyId">
					<el-row>
						<el-col :span="20">
							<el-input v-model="form.carApplyDisplay" disabled placeholder="请选择车辆派出记录" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ auditState: '已审核' }"
								:get-data="listCarApply"
								query-info="carNo"
								query-label="车牌"
								:query-name="queryCarApply"
								@update:queryName="value => (queryCarApply = value)"
								@commitBack="handleCommitBackCarApply"
							>
								<template #table-columns>
									<el-table-column label="申请人" prop="applyUser" />
									<el-table-column label="部门" prop="department" />
									<el-table-column label="车牌" prop="carNo" />
									<el-table-column label="用车时间" prop="startTime" />
									<el-table-column label="审核状态" prop="auditState" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="使用加油卡时间" prop="useDate">
					<el-date-picker v-model="form.useDate" type="datetime" placeholder="选择使用加油卡时间" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="使用加油卡车辆车牌号" prop="carNo">
					<el-input v-model="form.carNo" disabled placeholder="选择车辆派出记录后自动填充" />
				</el-form-item>
				<el-form-item label="地点和事由" prop="locationReason">
					<el-input v-model="form.locationReason" placeholder="请输入地点和事由" />
				</el-form-item>
				<el-form-item label="期初余额" prop="startCardSurplus">
					<el-input v-model="form.startCardSurplus" placeholder="选择油卡时自动计算，允许手动修改" @blur="calculateEndCardSurplus" />
				</el-form-item>
				<el-form-item label="用加油卡加油次数" prop="refuelingCount">
					<el-input type="number" v-model="form.refuelingCount" placeholder="请输入用加油卡加油次数" />
				</el-form-item>
				<el-form-item label="加油量" prop="refuelingNumber">
					<el-input v-model="form.refuelingNumber" placeholder="请输入加油量" @blur="calculateRefuelingMoney" />
				</el-form-item>
				<el-form-item label="单价" prop="unitPrice">
					<el-input v-model="form.unitPrice" placeholder="请输入单价" @blur="calculateRefuelingMoney" />
				</el-form-item>
				<el-form-item label="加油金额(元）" prop="refuelingMoney">
					<el-input v-model="form.refuelingMoney" placeholder="填完加油量和单价后自动计算，允许修改" @blur="calculateEndCardSurplus" />
				</el-form-item>
				<el-form-item label="加油卡余额" prop="endCardSurplus">
					<el-input v-model="form.endCardSurplus" placeholder="填完加油金额和期初余额后自动计算，允许修改" />
				</el-form-item>
				<el-form-item label="加油小票是否交回" prop="receiptReturned">
					<el-radio v-model="form.receiptReturned" label="是">是</el-radio>
					<el-radio v-model="form.receiptReturned" label="否">否</el-radio>
				</el-form-item>
				<el-form-item label="加油小票附件" prop="attachmentOiladd">
					<UploadFilesButton ref="attachmentUpload" flag="attachmentOiladd" :extra-info="{ moduleType: 'oilCardConsume', formId: form.id }" :initial-attachments="form.attachmentList || []" @files-updated="handleAttachmentFilesUpdated" />
					<span style="color: red;">* 必填</span>
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
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
import { listOilCardConsume, getOilCardConsume, delOilCardConsume, addOilCardConsume, updateOilCardConsume } from '@/api/system/OilCardConsume';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import CheckFiles from '@/components/CheckFiles.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import SearchOption from '@/components/SearchOption.vue';
import { listOilCard, getOilCard } from '@/api/system/oilCard';
import { listCarApply } from '@/api/system/carApply';
import { multiply, subtract } from 'mathjs';
import { parseTime } from '../../../utils/ruoyi';
import { listVehicles } from '../../../api/system/vehicles';

export default {
	name: 'OilCardConsume',
	components: {
		SearchOption,
		CheckFiles,
		UploadFilesButton
	},
	mixins: [mixin_printHTML, mixin_checkfile],
	data() {
		// 校验数字且最多两位小数
		const validateNumber = (rule, value, callback) => {
			if (value === '' || value === null) {
				callback(new Error('该字段不能为空'));
			} else {
				callback();
			}
		};
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			OilCardConsumeList: [],
			title: '',
			open: false,
			queryParams: {
				useDateEnd: '',
				useDateStart: '',
				pageNum: 1,
				pageSize: 20,
				bTripId: null,
				oilCardNo: null,
				useDate: null,
				carNo: null,
				startCardSurplus: null,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				endCardSurplus: null,
				attachmentOiladd: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			form: {},
			rules: {
				carApplyId: [{ required: true, message: '请选择车辆派出记录', trigger: 'change' }],
				oilCardNo: [{ required: true, message: '加油卡卡号不能为空', trigger: 'blur' }],
				useDate: [{ required: true, message: '使用时间不能为空', trigger: 'change' }],
				carNo: [{ required: true, message: '车牌号不能为空', trigger: 'blur' }],
				locationReason: [{ required: false }],
				startCardSurplus: [{ required: true, trigger: 'blur', validator: validateNumber }],
				refuelingCount: [{ required: true, message: '用加油卡加油次数不能为空', trigger: 'blur' }],
				refuelingNumber: [{ required: true, trigger: 'blur', validator: validateNumber }],
				unitPrice: [{ required: true, trigger: 'blur', validator: validateNumber }],
				refuelingMoney: [{ required: true, trigger: 'blur', validator: validateNumber }],
				endCardSurplus: [{ required: true, trigger: 'blur', validator: validateNumber }],
				receiptReturned: [{ required: true, message: '请选择加油小票是否交回', trigger: 'change' }]
			},
			columns: [
				{ key: 0, label: `id`, visible: true },
				{ key: 1, label: `加油卡卡号`, visible: true },
				{ key: 2, label: `使用加油卡时间`, visible: true },
				{ key: 3, label: `使用加油卡车辆车牌号`, visible: true },
				{ key: 4, label: `期初余额`, visible: true },
				{ key: 5, label: `加油量`, visible: true },
				{ key: 6, label: `单价`, visible: true },
				{ key: 7, label: `加油金额（元）`, visible: true },
				{ key: 8, label: `加油卡余额`, visible: true },
				{ key: 9, label: `加油小票附件`, visible: true },
				{ key: 10, label: `备注`, visible: true }
			],
			oilCardNoQuery: null,
			carNo: null,
			queryCarApply: ''
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('oilcardconsume-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('oilcardconsume-columns') === 'null' || !localStorage.getItem('oilcardconsume-columns')) {
			// 设置localStorage
			localStorage.setItem('oilcardconsume-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('oilcardconsume-columns'));
		}
	},
	methods: {
		parseTime,
		listOilCard,
		updateOilCardConsume,
		getOilCardConsume,
		listVehicles,
		listCarApply,
		// 附件更新处理
		handleAttachmentFilesUpdated(uploadParams) {
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				// 确保 form.params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 直接使用上传组件返回的统一附件ID数组
				this.form.params.attachmentIds = uploadParams.params.attachmentIds;
			}
		},
		/** 查询加油卡消费信息列表 */
		getList() {
			this.loading = true;
			listOilCardConsume(this.queryParams).then(response => {
				this.OilCardConsumeList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
			// 清除上传组件状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				carApplyId: null,
				carApplyDisplay: null,
				bTripId: null,
				oilCardNo: null,
				useDate: parseTime(new Date()),
				carNo: null,
				locationReason: null,
				startCardSurplus: null,
				refuelingCount: 1,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				endCardSurplus: null,
				receiptReturned: '是',
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('form');
			// 清除上传组件状态
			if (this.$refs.attachmentUpload) {
				this.$refs.attachmentUpload.clearUploadedFiles();
			}
		},
		// 车辆派出引用回调
		handleCommitBackCarApply(value) {
			this.form.carApplyId = value.id;
			this.form.carNo = value.carNo;
			this.form.useDate = value.startTime;
			// 修复：设置 form.carApplyDisplay 而不是 this.carApplyDisplay，展示车辆派出id
			this.form.carApplyDisplay = String(value.id);
		},
		// 选择油卡时自动填充期初余额
		handleOilCardSelect(value) {
			this.form.oilCardNo = value.oilCardNo;
			// 获取油卡详细信息，自动填充期初余额
			if (value.id) {
				getOilCard(value.id).then(res => {
					if (res.data && res.data.moneyAmount) {
						this.form.startCardSurplus = String(res.data.moneyAmount);
					}
				});
			}
		},
		// 自动计算加油金额（加油量 * 单价）
		calculateRefuelingMoney() {
			if (this.form.refuelingNumber && this.form.unitPrice) {
				const refuelingNumber = Number(this.form.refuelingNumber) || 0;
				const unitPrice = Number(this.form.unitPrice) || 0;
				const result = multiply(refuelingNumber, unitPrice);
				this.form.refuelingMoney = String(Number(result.toFixed(2)));
				this.calculateEndCardSurplus();
			}
		},
		// 自动计算加油卡余额（期初余额 - 加油金额）
		calculateEndCardSurplus() {
			if (this.form.startCardSurplus && this.form.refuelingMoney) {
				const startCardSurplus = Number(this.form.startCardSurplus) || 0;
				const refuelingMoney = Number(this.form.refuelingMoney) || 0;
				const result = subtract(startCardSurplus, refuelingMoney);
				this.form.endCardSurplus = String(Number(result.toFixed(2)));
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
			this.title = '添加加油卡消费信息';
		},

		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getOilCardConsume(id).then(response => {
				this.form = {
					...response.data,
					// 如果有 carApplyId，显示它
					carApplyDisplay: response.data.carApplyId ? String(response.data.carApplyId) : null,
					params: {
						...response.data.params,
						attachmentIds: response.data.attachmentList ? response.data.attachmentList.map(item => item.id) : []
					}
				};
				this.open = true;
				this.title = '修改加油卡消费信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 校验附件是否上传
					if (!this.form.params || !this.form.params.attachmentIds || this.form.params.attachmentIds.length === 0) {
						this.$message.error('请上传加油小票附件');
						return;
					}

					const data = { ...this.form };
					// 确保params存在
					if (!data.params) {
						data.params = {};
					}
					// 如果通过上传组件已设置了 attachmentIds，则保持；否则从 attachmentList 获取
					if (!data.params.attachmentIds && this.form.attachmentList) {
						data.params.attachmentIds = this.form.attachmentList.map(item => item.id);
					}

					if (this.form.id != null) {
						updateOilCardConsume(data).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addOilCardConsume(data).then(() => {
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
				.confirm('是否确认删除加油卡消费信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delOilCardConsume(ids);
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
				'system/OilCardConsume/export',
				{
					...this.queryParams
				},
				`油卡消费_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
