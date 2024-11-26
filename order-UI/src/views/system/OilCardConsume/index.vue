<template>
	<div class="app-container">
		<el-form
			v-show="showSearch"
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="120px"
		>
			<el-form-item label="加油卡卡号" prop="oilCardNo">
				<el-input
					v-model="queryParams.oilCardNo"
					placeholder="请输入加油卡卡号"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="使用加油卡开始时间" prop="useDateStart">
				<el-date-picker
					v-model="queryParams.useDateStart"
					type="datetime"
					placeholder="选择使用加油卡时间"
					value-format="yyyy-MM-dd HH:mm:ss"
				></el-date-picker>
			</el-form-item>
			<el-form-item label="使用加油卡结束时间" prop="useDateEnd">
				<el-date-picker
					v-model="queryParams.useDateEnd"
					type="datetime"
					placeholder="选择使用加油卡时间"
					value-format="yyyy-MM-dd HH:mm:ss"
				></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
				>
					搜索
				</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">
					刷新
				</el-button>
			</el-col>
			<right-toolbar
				:showSearch.sync="showSearch"
				:columns="columns"
				@queryTable="getList"
			>
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:oilcardconsume:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						></el-button>
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
					return { padding: '2px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column
				v-if="columns[0].visible"
				label="id"
				align="center"
				prop="id"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[1].visible"
				label="加油卡卡号"
				align="center"
				prop="oilCardNo"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[2].visible"
				label="使用加油卡时间"
				align="center"
				prop="useDate"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[3].visible"
				label="使用加油卡车辆车牌号"
				align="center"
				prop="carNo"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[4].visible"
				label="期初余额"
				align="center"
				prop="startCardSurplus"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[5].visible"
				label="加油量"
				align="center"
				prop="refuelingNumber"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[6].visible"
				label="单价"
				align="center"
				prop="unitPrice"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[7].visible"
				label="加油金额(元）"
				align="center"
				prop="refuelingMoney"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[8].visible"
				label="充值金额(元）"
				align="center"
				prop="rechargeMoney"
				width="110"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[9].visible"
				label="加油卡余额"
				align="center"
				prop="endCardSurplus"
				width="110"
				show-overflow-tooltip
			/>
			<!--      <el-table-column label="加油小票附件" align="center" prop="attachmentOiladd" v-if="columns[10].visible"-->
			<!--                       width="300px"/>-->
			<el-table-column
				v-if="columns[10].visible"
				label="加油小票附件"
				align="center"
				prop="attachmentOiladd"
			>
				<template #default="scope">
					<!--          <img v-if="isPic(scope.row.attachmentOiladd)" :src="scope.row.attachmentOiladd" alt=""-->
					<!--               style="width: 100%;height: 100%">-->
					<!--          <span v-else-if="scope.row.attachmentOiladd === '' || scope.row.attachmentOiladd === null">无附件</span>-->
					<!--          <span v-else>-->
					<!--            文件不支持预览，请手动下载:-->
					<!--          <a style="color: red"-->
					<!--             :href="scope.row.attachmentOiladd">{{ scope.row.attachmentOiladd }}</a>-->
					<!--          </span>-->
					<span v-if="!scope.row.attachmentOiladd">无</span>
					<span v-else>
						<a style="color: red" :href="scope.row.attachmentOiladd">
							<el-button size="mini" type="success">下载</el-button>
						</a>
					</span>
				</template>
			</el-table-column>
			<el-table-column
				v-if="columns[11].visible"
				label="备注"
				align="center"
				prop="comments"
			/>
			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
				fixed="right"
			>
				<template slot-scope="scope">
					<el-button
						v-hasPermi="['system:oilcardconsume:remove']"
						size="mini"
						type="danger"
						@click="handleDelete(scope.row)"
					>
						删除
					</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>

		<!-- 添加或修改加油卡消费信息对话框 -->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			:title="title"
			:visible.sync="open"
			width="500px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="加油卡卡号" prop="oilCardNo">
					<el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号" />
				</el-form-item>
				<el-form-item label="使用加油卡时间" prop="useDate">
					<el-input v-model="form.useDate" placeholder="请输入使用加油卡时间" />
				</el-form-item>
				<el-form-item label="使用加油卡车辆车牌号" prop="carNo">
					<el-input
						v-model="form.carNo"
						placeholder="请输入使用加油卡车辆车牌号"
					/>
				</el-form-item>
				<el-form-item label="期初余额" prop="startCardSurplus">
					<el-input
						v-model="form.startCardSurplus"
						placeholder="请输入期初余额"
					/>
				</el-form-item>
				<el-form-item label="加油量" prop="refuelingNumber">
					<el-input v-model="form.refuelingNumber" placeholder="请输入加油量" />
				</el-form-item>
				<el-form-item label="单价" prop="unitPrice">
					<el-input v-model="form.unitPrice" placeholder="请输入单价" />
				</el-form-item>
				<el-form-item label="加油金额(元）" prop="refuelingMoney">
					<el-input
						v-model="form.refuelingMoney"
						placeholder="请输入加油金额(元）"
					/>
				</el-form-item>
				<el-form-item label="充值金额(元）" prop="rechargeMoney">
					<el-input
						v-model="form.rechargeMoney"
						placeholder="请输入充值金额(元）"
					/>
				</el-form-item>
				<el-form-item label="加油卡余额" prop="endCardSurplus">
					<el-input
						v-model="form.endCardSurplus"
						placeholder="请输入加油卡余额"
					/>
				</el-form-item>
				<el-form-item label="加油小票附件" prop="attachmentOiladd">
					<el-input
						v-model="form.attachmentOiladd"
						placeholder="请输入加油小票附件"
					/>
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
import {
	listOilCardConsume,
	getOilCardConsume,
	delOilCardConsume,
	addOilCardConsume,
	updateOilCardConsume
} from '@/api/system/OilCardConsume';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { findFileExtension } from '@/utils/trash/utils';

export default {
	name: 'OilCardConsume',
	mixins: [mixin_printHTML],
	data() {
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
			rules: {},
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
			]
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
		if (
			localStorage.getItem('oilcardconsume-columns') === 'null' ||
			!localStorage.getItem('oilcardconsume-columns')
		) {
			// 设置localStorage
			localStorage.setItem(
				'oilcardconsume-columns',
				JSON.stringify(this.columns)
			);
		} else {
			this.columns = JSON.parse(localStorage.getItem('oilcardconsume-columns'));
		}
	},
	methods: {
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
		isPic(url) {
			console.log(url);
			return this.$imgs.includes(findFileExtension(url));
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
						updateOilCardConsume(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addOilCardConsume(this.form).then(response => {
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
