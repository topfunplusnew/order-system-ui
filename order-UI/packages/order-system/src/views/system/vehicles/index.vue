<template>
	<div class="app-container">
		<el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
			<el-form-item label="车辆型号" prop="model">
				<el-input v-model="queryParams.model" placeholder="请输入车辆型号" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'model')" />
			</el-form-item>
			<el-form-item label="车牌号" prop="licensePlate">
				<el-input v-model="queryParams.licensePlate" placeholder="请输入车牌号" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'licensePlate')" />
			</el-form-item>
			<el-form-item label="购买时间" prop="purchaseDate">
				<el-date-picker clearable v-model="queryParams.purchaseDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择购买时间"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['system:vehicles:add']">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['system:vehicles:edit']">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['system:vehicles:remove']">删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:vehicles:export']">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" size="mini" v-loading="loading" :data="vehiclesList" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column v-if="columns[0].visible" label="车辆型号" align="center" prop="model" />
			<el-table-column v-if="columns[1].visible" label="车牌号" align="center" prop="licensePlate" />
			<el-table-column v-if="columns[2].visible" label="购买时间" align="center" prop="purchaseDate" width="180">
				<template slot-scope="scope">
					<span>{{ parseTime(scope.row.purchaseDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="行驶里程" align="center" prop="mileage" />
			<el-table-column v-if="columns[4].visible" label="保养金额" align="center" prop="maintenanceCost" />
			<el-table-column v-if="columns[5].visible" label="保养日期" align="center" prop="maintenanceDate" width="180">
				<template slot-scope="scope">
					<span>{{ parseTime(scope.row.maintenanceDate, '{y}-{m}-{d}') }}</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[6].visible" label="保险金额" align="center" prop="insuranceCost" />
			<el-table-column v-if="columns[7].visible" label="备注" align="center" prop="notes" />
			<el-table-column label="附件" align="center">
				<template slot-scope="scope">
					<el-button size="mini" type="primary" icon="el-icon-upload" @click="handleUploadAttachments(scope.row)">附件上传</el-button>
				</template>
			</el-table-column>
			<!--			<el-table-column label="扩展性保留字段" align="center" prop="extraInfo" />-->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:vehicles:edit']">修改</el-button>
					<el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['system:vehicles:remove']">删除</el-button>
					<el-button size="mini" type="text" icon="el-icon-picture" @click="handleViewAttachments(scope.row)">查看附件</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改车辆信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px" @keyup.enter.native="submitForm" @submit.native.prevent="submitForm" size="mini">
				<el-form-item label="车辆型号" prop="model">
					<el-input v-model="form.model" placeholder="请输入车辆型号" @input="handleInputTrim($event, 'form', 'model')" />
				</el-form-item>
				<el-form-item label="车牌号" prop="licensePlate">
					<el-input v-model="form.licensePlate" placeholder="请输入车牌号" @input="handleInputTrim($event, 'form', 'licensePlate')" />
				</el-form-item>
				<el-form-item label="购买时间" prop="purchaseDate">
					<el-date-picker clearable v-model="form.purchaseDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择购买时间"></el-date-picker>
				</el-form-item>
				<el-form-item label="行驶里程" prop="mileage">
					<el-input v-model="form.mileage" placeholder="请输入行驶里程" @input="handleNumberInput($event, 'form', 'mileage')" />
				</el-form-item>
				<el-form-item label="保养金额" prop="maintenanceCost">
					<el-input v-model="form.maintenanceCost" placeholder="请输入保养金额" @input="handleNumberInput($event, 'form', 'maintenanceCost')" />
				</el-form-item>
				<el-form-item label="保养日期" prop="maintenanceDate">
					<el-date-picker clearable v-model="form.maintenanceDate" type="date" value-format="yyyy-MM-dd" placeholder="请选择保养日期"></el-date-picker>
				</el-form-item>
				<el-form-item label="保险金额" prop="insuranceCost">
					<el-input v-model="form.insuranceCost" placeholder="请输入保险金额" @input="handleNumberInput($event, 'form', 'insuranceCost')" />
				</el-form-item>
				<el-form-item label="备注" prop="notes">
					<el-input v-model="form.notes" type="textarea" placeholder="请输入内容" @input="handleInputTrim($event, 'form', 'notes')" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 查看附件对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="'查看附件'" :visible.sync="attachmentsDialogVisible" width="600px" append-to-body>
			<h3>图片附件</h3>
			<el-carousel v-if="imageAttachments.length" :interval="5000" type="card" height="400px">
				<el-carousel-item v-for="(item, index) in imageAttachments" :key="index">
					<img :src="item.url" :alt="item.name" style="width: 100%; height: 100%" />
				</el-carousel-item>
			</el-carousel>
			<div v-if="nonImageAttachments.length" class="non-image-attachments">
				<h3>非图片附件</h3>
				<div v-for="(item, index) in nonImageAttachments" :key="index" class="attachment-item">
					<i class="el-icon-document"></i>
					<a :href="item.url" target="_blank">{{ item.name }}</a>
				</div>
			</div>
		</el-dialog>

		<!-- 附件上传对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="'附件上传'" :visible.sync="uploadDialogVisible" width="600px" append-to-body>
			<el-upload
				class="upload-demo"
				:action="uploadFileUrl"
				:headers="{
					Authorization: 'Bearer ' + getToken()
				}"
				list-type="picture-card"
				:on-success="handleUploadSuccess"
				:multiple="true"
				:file-list="fileList"
				:auto-upload="true"
				:on-preview="handlePreview"
				:on-remove="handleRemove"
				:on-change="handleChange"
			>
				<i class="el-icon-plus"></i>
			</el-upload>
			<el-button type="primary" @click="submitUpload">上传</el-button>
		</el-dialog>
	</div>
</template>

<script>
import { listVehicles, getVehicles, delVehicles, addVehicles, updateVehicles } from '@/api/system/vehicles';
import { parseTime } from '../../../utils/ruoyi';
import { getToken } from '@/utils/auth';
import { mixin_printHTML } from '../../dashboard/mixins/print';
export default {
	name: 'Vehicles',
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
			// 车辆信息表格数据
			vehiclesList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				model: null,
				licensePlate: null,
				purchaseDate: null,
				mileage: null,
				maintenanceCost: null,
				maintenanceDate: null,
				insuranceCost: null,
				notes: null,
				extraInfo: null
			},
			// 表单参数
			form: {},
			columns: [
				{ key: 0, label: `车辆型号`, visible: true },
				{ key: 1, label: `车牌号`, visible: true },
				{ key: 2, label: `购买时间`, visible: true },
				{ key: 3, label: `行驶里程`, visible: true },
				{ key: 4, label: `保养金额`, visible: true },
				{ key: 5, label: `保养日期`, visible: true },
				{ key: 6, label: `保险金额`, visible: true },
				{ key: 7, label: `备注`, visible: true }
			],
			// 表单校验
			rules: {
				model: [
					{
						required: true,
						message: '车辆型号不能为空',
						trigger: 'blur'
					}
				],
				licensePlate: [
					{
						required: true,
						message: '车牌号不能为空',
						trigger: 'blur'
					}
				],
				purchaseDate: [
					{
						required: true,
						message: '购买时间不能为空',
						trigger: 'blur'
					}
				],
				mileage: [
					{
						required: true,
						message: '行驶里程不能为空',
						trigger: 'blur'
					},
					{
						pattern: /^[1-9]\d*(\.\d{1,2})?$/,
						message: '行驶里程必须是有效的正数，最多保留2位小数',
						trigger: 'blur'
					}
				],
				maintenanceCost: [
					{
						required: true,
						message: '保养金额不能为空',
						trigger: 'blur'
					},
					{
						pattern: /^(0|[1-9]\d*)(\.\d{1,2})?$/,
						message: '保养金额必须是有效的数字，最多保留2位小数',
						trigger: 'blur'
					}
				],
				maintenanceDate: [
					{
						required: true,
						message: '保养日期不能为空',
						trigger: 'blur'
					}
				],
				insuranceCost: [
					{
						required: true,
						message: '保险金额不能为空',
						trigger: 'blur'
					},
					{
						pattern: /^(0|[1-9]\d*)(\.\d{1,2})?$/,
						message: '保险金额必须是有效的数字，最多保留2位小数',
						trigger: 'blur'
					}
				]
			},
			attachmentsDialogVisible: false,
			attachments: [],
			imageAttachments: [],
			nonImageAttachments: [],
			uploadDialogVisible: false,
			fileList: [],
			currentRow: null,
			uploadList: [],
			number: 0,
			uploadFileUrl: process.env.VUE_APP_BASE_API + '/common/upload'
		};
	},
	created() {
		this.getList();
	},
	methods: {
		// 处理输入框禁止输入空格
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},
		// 处理数字输入框，只允许输入数字和小数点
		handleNumberInput(val, obj, prop) {
			// 移除所有非数字和小数点的字符
			let cleanValue = val.replace(/[^\d.]/g, '');

			// 确保只有一个小数点
			let parts = cleanValue.split('.');
			if (parts.length > 2) {
				cleanValue = parts[0] + '.' + parts.slice(1).join('');
			}

			// 限制小数点后最多两位
			if (parts.length === 2 && parts[1].length > 2) {
				cleanValue = parts[0] + '.' + parts[1].substring(0, 2);
			}

			// 防止以小数点开头
			if (cleanValue.startsWith('.')) {
				cleanValue = '0' + cleanValue;
			}

			// 防止以0开头但不是0.xx的情况
			if (cleanValue.length > 1 && cleanValue.startsWith('0') && !cleanValue.startsWith('0.')) {
				cleanValue = cleanValue.substring(1);
			}

			this[obj][prop] = cleanValue;
		},
		parseTime,
		getToken,
		// 上传成功回调
		handleUploadSuccess(res, file) {
			if (res.code === 200) {
				this.uploadList.push({ name: file.name, url: res.fileName });
				this.$message.success('上传成功');
			} else {
				this.$modal.msgError(res.msg);
				this.$refs.fileUpload.handleRemove(file);
			}
		},
		/** 查询车辆信息列表 */
		getList() {
			this.loading = true;
			listVehicles(this.queryParams).then(response => {
				this.vehiclesList = response.rows;
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
				model: null,
				licensePlate: null,
				purchaseDate: null,
				mileage: null,
				maintenanceCost: null,
				maintenanceDate: null,
				insuranceCost: null,
				notes: null,
				extraInfo: null
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
			this.title = '添加车辆信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getVehicles(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改车辆信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateVehicles(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addVehicles(this.form).then(() => {
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
				.confirm('是否确认删除车辆信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delVehicles(ids);
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
				'system/vehicles/export',
				{
					...this.queryParams
				},
				`vehicles_${new Date().getTime()}.xlsx`
			);
		},
		/** 查看附件按钮操作 */
		handleViewAttachments(row) {
			// 拿取附件数据
			if (!row.extraInfo) {
				this.$modal.msgError('该车辆没有附件');
				return;
			}
			if (!row.extraInfo.attachments) {
				this.$modal.msgError('该车辆没有附件');
				return;
			}
			this.attachments = row.extraInfo.attachments;
			this.imageAttachments = this.attachments
				.filter(item => item.name.match(/\.(jpeg|jpg|gif|png)$/i))
				.map(item => ({
					...item,
					url: item.url.replace(/^blob:/, '')
				}));
			this.nonImageAttachments = this.attachments.filter(item => !item.name.match(/\.(jpeg|jpg|gif|png)$/i));

			this.attachmentsDialogVisible = true;
		},
		/** 附件上传按钮操作 */
		handleUploadAttachments(row) {
			this.currentRow = row;
			this.fileList = this.uploadList = row.extraInfo?.attachments ? row.extraInfo.attachments : [];
			this.uploadDialogVisible = true;
		},
		handlePreview(file) {
			window.open(file.url);
		},
		handleRemove(file, fileList) {
			this.fileList = fileList;
			this.uploadList = fileList.map(item => ({
				name: item.name,
				url: item.url
			}));
		},
		handleChange(file, fileList) {
			this.fileList = fileList;
		},
		submitUpload() {
			// 将上传的文件信息保存到当前行的 extraInfo 字段中
			this.currentRow.extraInfo = {
				attachments: this.uploadList
			};
			// 更新当前行数据
			updateVehicles(this.currentRow).then(() => {
				this.getList();
				// 模拟上传成功
				this.$modal.msgSuccess('上传成功');
				this.uploadDialogVisible = false;
			});
		}
	}
};
</script>

<style scoped>
.non-image-attachments {
	margin-top: 20px;
}

.attachment-item {
	display: flex;
	align-items: center;
	margin-bottom: 10px;
	padding: 10px;
	border: 1px solid #ebeef5;
	border-radius: 4px;
	background-color: #f5f7fa;
}

.attachment-item i {
	margin-right: 10px;
	font-size: 20px;
	color: #409eff;
}

.attachment-item a {
	color: #409eff;
	text-decoration: none;
}

.attachment-item a:hover {
	text-decoration: underline;
}
</style>
