<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
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
			<el-table-column v-if="columns[8].visible" label="充值金额(元）" align="center" prop="rechargeMoney" width="110" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="加油卡余额" align="center" prop="endCardSurplus" width="110" show-overflow-tooltip />
			<!--      <el-table-column label="加油小票附件" align="center" prop="attachmentOiladd" v-if="columns[10].visible"-->
			<!--                       width="300px"/>-->
			<el-table-column v-if="columns[10].visible" label="加油小票附件" align="center" prop="attachmentOiladd">
				<template #default="scope">
					<div v-if="Array.isArray(scope.row.attachmentList)">
						<CheckFiles
							:attachmentList="scope.row.attachmentList"
							:flag="'attachmentOiladd'"
							@needToUpdate="value => handleUpdateFilePath(value, scope.row, getOilCardConsume, updateOilCardConsume)"
						/>
					</div>
					<div v-else>
						<el-tag type="danger">加载错误</el-tag>
					</div>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[11].visible" label="备注" align="center" prop="comments" />
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
								@commitBack="
									value => {
										form.oilCardNo = value.oilCardNo;
									}
								"
							>
								<template #table-columns>
									<el-table-column label="加油卡卡号1" align="center" prop="oilMainCardNo" />
									<el-table-column label="加油卡卡号2" align="center" prop="oilSecondCardNo" />
									<el-table-column label="消费类型" align="center" prop="rechargeMoney"></el-table-column>
									<el-table-column label="操作金额" align="center" prop="rechargeMoney" />
									<el-table-column label="操作时间" align="center" prop="rechargeDate" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="使用加油卡时间" prop="useDate">
					<el-date-picker v-model="form.useDate" type="datetime" placeholder="选择使用加油卡时间" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="使用加油卡车辆车牌号" prop="carNo">
					<el-row>
						<el-col :span="20">
							<el-input v-model="form.carNo" placeholder="请输入使用加油卡车辆车牌号" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:limit-info="{}"
								:get-data="listOilCard"
								query-info="licensePlate"
								query-label="车牌号"
								:query-name="carNo"
								@update:queryName="value => (carNo = value)"
								@commitBack="
									value => {
										form.carNo = value.licensePlate;
									}
								"
							>
								<template #table-columns>
									<el-table-column label="车辆型号" align="center" prop="model" />
									<el-table-column label="车牌号" align="center" prop="licensePlate" />
									<el-table-column label="购买时间" align="center" prop="purchaseDate" width="180">
										<template slot-scope="scope">
											<span>{{ parseTime(scope.row.purchaseDate, '{y}-{m}-{d}') }}</span>
										</template>
									</el-table-column>
									<el-table-column label="行驶里程" align="center" prop="mileage" />
									<el-table-column label="保养金额" align="center" prop="maintenanceCost" />
									<el-table-column label="保养日期" align="center" prop="maintenanceDate" width="180">
										<template slot-scope="scope">
											<span>{{ parseTime(scope.row.maintenanceDate, '{y}-{m}-{d}') }}</span>
										</template>
									</el-table-column>
									<el-table-column label="保险金额" align="center"></el-table-column>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item
					label=" 期初余额
                  "
					prop="startCardSurplus"
				>
					<el-input v-model="form.startCardSurplus" placeholder="请输入期初余额" />
				</el-form-item>
				<el-form-item label="加油量" prop="refuelingNumber">
					<el-input v-model="form.refuelingNumber" placeholder="请输入加油量" />
				</el-form-item>
				<el-form-item label="单价" prop="unitPrice">
					<el-input v-model="form.unitPrice" placeholder="请输入单价" />
				</el-form-item>
				<el-form-item label="加油金额(元）" prop="refuelingMoney">
					<el-input v-model="form.refuelingMoney" placeholder="请输入加油金额(元）" />
				</el-form-item>
				<el-form-item label="充值金额(元）" prop="rechargeMoney">
					<el-input v-model="form.rechargeMoney" placeholder="请输入充值金额(元）" />
				</el-form-item>
				<el-form-item label="加油卡余额" prop="endCardSurplus">
					<el-input v-model="form.endCardSurplus" placeholder="请输入加油卡余额" />
				</el-form-item>
				<el-form-item label="加油小票附件" prop="attachmentOiladd">
					<FileUpload v-model="form.attachmentOiladd" :limit="1" :fileSize="10" :fileType="['png', 'jpg', 'jpeg', 'pdf']" />
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
import FileUpload from '@/components/FileUpload/index.vue';
import SearchOption from '@/components/SearchOption.vue';
import { listOilCard } from '@/api/system/oilCard';
import { parseTime } from '../../../utils/ruoyi';

export default {
	name: 'OilCardConsume',
	components: {
		SearchOption,
		CheckFiles,
		FileUpload
	},
	mixins: [mixin_printHTML, mixin_checkfile],
	data() {
		// 校验数字且最多两位小数
		const validateNumber = (rule, value, callback) => {
			if (value === '' || value === null) {
				callback(new Error('该字段不能为空'));
			} else if (!/(^[1-9](\d+)?(\.\d{1,2})?$)|(^0$)|(^\d\.\d{1,2}$)/.test(value)) {
				callback(new Error('请输入数字，最多两位小数'));
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
				pageSize: 10,
				bTripId: null,
				oilCardNo: null,
				useDate: null,
				carNo: null,
				startCardSurplus: null,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				rechargeMoney: null,
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
				oilCardNo: [{ required: true, message: '加油卡卡号不能为空', trigger: 'blur' }],
				useDate: [{ required: true, message: '使用时间不能为空', trigger: 'blur' }],
				carNo: [{ required: true, message: '车牌号不能为空', trigger: 'blur' }],
				startCardSurplus: [{ required: true, trigger: 'blur', validator: validateNumber }],
				refuelingNumber: [{ required: true, trigger: 'blur', validator: validateNumber }],
				unitPrice: [{ required: true, trigger: 'blur', validator: validateNumber }],
				refuelingMoney: [{ required: true, trigger: 'blur', validator: validateNumber }],
				rechargeMoney: [{ required: true, trigger: 'blur', validator: validateNumber }],
				endCardSurplus: [{ required: true, trigger: 'blur', validator: validateNumber }]
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
				{ key: 8, label: `充值金额（元）`, visible: true },
				{ key: 9, label: `加油卡余额`, visible: true },
				{ key: 10, label: `加油小票附件`, visible: true },
				{ key: 11, label: `备注`, visible: true }
			],
			oilCardNoQuery: null,
			carNo: null
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
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				bTripId: null,
				oilCardNo: null,
				useDate: parseTime(new Date()),
				carNo: null,
				startCardSurplus: null,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				rechargeMoney: null,
				endCardSurplus: null,
				attachmentOiladd: null,
				comments: null,
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
				this.form = response.data;
				this.open = true;
				this.title = '修改加油卡消费信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateOilCardConsume(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addOilCardConsume(this.form).then(() => {
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
				`OilCardConsume_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
