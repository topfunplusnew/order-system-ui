<template>
	<div>
		<!-- 用 v-show 避免 $refs 丢失 -->
		<el-form v-show="isConfigLoaded" id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150">
			<el-form-item v-if="shouldShowField('dateRange')" label="时间范围">
				<el-date-picker v-model="dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" size="mini" class="date-range-280" unlink-panels :clearable="true" @change="onDateRangeChange" />
			</el-form-item>
			<el-form-item v-if="shouldShowField('id')" label="ID" prop="id">
				<el-input v-model="queryParams.id" placeholder="请输入订单ID" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('customer')" label="客户名称" prop="customer">
				<el-input v-model="queryParams.customer" placeholder="请输入客户名称" clearable size="mini" class="input-standard" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('supplierNames')" label="供应商" prop="supplierNames">
				<el-input v-model="queryParams.params.supplierNames" placeholder="请输入供应商名称" clearable size="mini" class="input-standard" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('storeHouseName')" label="仓库名称" prop="params.storeHouseName">
				<el-input v-model="queryParams.params.storeHouseName" placeholder="请输入仓库名称" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('landDriverName')" label="司机名称" prop="landDriverName">
				<el-input v-model="queryParams.landDriverName" placeholder="请输入司机名称" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('landCarNo')" label="车牌" prop="landCarNo">
				<el-input v-model="queryParams.landCarNo" placeholder="请输入车牌" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('seaDriverName')" label="海运公司" prop="seaDriverName">
				<el-input v-model="queryParams.seaDriverName" placeholder="请输入海运公司" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('seaCarNo')" label="柜号" prop="seaCarNo">
				<el-input v-model="queryParams.seaCarNo" placeholder="请输入柜号" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('fleet')" label="车队名称" prop="fleet">
				<el-input v-model="queryParams.fleet" placeholder="请输入车队名称" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('userName')" label="录入员" prop="userName">
				<el-input v-model="queryParams.userName" placeholder="请输入录入员" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('saleManager')" label="销售经理" prop="saleManager">
				<el-input v-model="queryParams.saleManager" placeholder="请输入销售经理" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('checkState')" label="审核状态" prop="checkState">
				<el-select v-model="queryParams.checkState" placeholder="请选择" size="mini" clearable class="select-standard">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>

			<el-form-item v-if="shouldShowField('isIncludeTaxFactory')" label="供应商是否开票">
				<el-select v-model="queryParams.params.isIncludeTaxFactory" placeholder="请选择" size="mini" clearable class="input-short">
					<el-option v-for="item in getOptionInvent()" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>

			<el-form-item v-if="shouldShowField('isIncludeTaxSale')" label="客户是否开票">
				<el-select v-model="queryParams.params.isIncludeTaxSale" placeholder="请选择" size="mini" clearable class="input-short">
					<el-option v-for="item in getOptionInvent()" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>

			<el-form-item v-if="shouldShowField('levelName')" label="级别名称" prop="levelName">
				<el-input v-model="queryParams.params.levelName" placeholder="请输入级别名称" clearable size="mini" class="input-medium" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('length')" label="长度" prop="length">
				<el-input v-model="queryParams.params.length" placeholder="请输入长度" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('width')" label="宽度" prop="width">
				<el-input v-model="queryParams.params.width" placeholder="请输入宽度" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item v-if="shouldShowField('height')" label="厚度" prop="height">
				<el-input v-model="queryParams.params.height" placeholder="请输入厚度" clearable size="mini" class="input-short" @keyup.enter.native="handleQuery"></el-input>
			</el-form-item>

			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-setting" size="mini" @click="openFieldSetting">自定义</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-form-item>
		</el-form>

		<!-- 字段设置弹窗 -->
		<el-dialog title="自定义搜索字段" :visible.sync="fieldSettingVisible" width="500px" append-to-body>
			<el-checkbox-group v-model="selectedFields">
				<el-row :gutter="10">
					<el-col v-for="field in allFields" :key="field.value" :span="12" style="margin-bottom: 8px">
						<el-checkbox :label="field.value" style="width: 100%">
							<span style="font-size: 12px">{{ field.label }}</span>
						</el-checkbox>
					</el-col>
				</el-row>
			</el-checkbox-group>
			<span slot="footer" class="dialog-footer">
				<el-button size="mini" @click="resetToDefault">恢复默认</el-button>
				<el-button size="mini" @click="fieldSettingVisible = false">取消</el-button>
				<el-button size="mini" type="primary" @click="saveFieldSettings">确定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { OptionInvent, Options } from '@/views/dashboard/mixins/order/order_Invoice';
import { getDateRangeDays } from '@/utils/index';
import _ from 'lodash';
import { getUserConfig, saveUserConfig } from '@/api/user-config';
import { UserConfigKey } from '@/api/tool/user-config.js'; // 导入枚举类

export default {
	name: 'QuerySearchBar',
	props: {
		isAdjust: {
			type: Boolean,
			default: false
		},
		currentPageNum: {
			type: Number,
			default: 1
		},
		currentPageSize: {
			type: Number,
			default: 50
		}
	},
	data() {
		return {
			fieldSettingVisible: false,
			isConfigLoaded: false,
			allFields: [
				{ value: 'id', label: 'ID' },
				{ value: 'dateRange', label: '时间范围' },
				{ value: 'customer', label: '客户名称' },
				{ value: 'supplierNames', label: '供应商' },
				{ value: 'storeHouseName', label: '仓库' },
				{ value: 'landDriverName', label: '司机名称' },
				{ value: 'landCarNo', label: '车牌' },
				{ value: 'seaDriverName', label: '海运公司' },
				{ value: 'seaCarNo', label: '柜号' },
				{ value: 'fleet', label: '车队名称' },
				{ value: 'userName', label: '录入员' },
				{ value: 'saleManager', label: '销售经理' },
				{ value: 'checkState', label: '审核状态' },
				{ value: 'isIncludeTaxFactory', label: '供应商是否开票' },
				{ value: 'isIncludeTaxSale', label: '客户是否开票' },
				{ value: 'levelName', label: '级别名称' },
				{ value: 'length', label: '长度' },
				{ value: 'width', label: '宽度' },
				{ value: 'height', label: '厚度' }
			],
			selectedFields: [],
			dateRange: [],
			options: Options,
			queryParams: {
				id: '',
				orderDateStart: null,
				orderDateEnd: null,
				pageNum: 1,
				pageSize: 50,

				customer: '',
				saleManager: '',
				landDriverName: '',
				landCarNo: '',
				seaDriverName: '',
				seaCarNo: '',
				fleet: '',
				userName: '',
				checkState: '',
				params: {
					storeHouseName: '',
					isIncludeTaxSale: '',
					isIncludeTaxFactory: '',
					supplierNames: '',
					levelName: '',
					length: '',
					width: '',
					height: ''
				}
			}
		};
	},
	computed: {
		shouldShowField() {
			return fieldName => this.isConfigLoaded && Array.isArray(this.selectedFields) && this.selectedFields.includes(fieldName);
		}
	},
	watch: {
		columns: {
			handler(newVal) {
				if (newVal.length > 0 && !this.configLoaded) {
					this.$nextTick(async () => {
						this.initializeColumnVisibility();
						await this.loadUserConfig();
					});
				}
			},
			immediate: true
		}
	},

	async created() {
		await this.loadFieldSettings();
		this.initializeDefaultQuery();
	},
	methods: {
		getOptionInvent() {
			return OptionInvent;
		},
		async loadFieldSettings() {
			try {
				const response = await getUserConfig(UserConfigKey.GOODS_SEARCH_COLUMNS);
				const configValue = response?.data?.value || response?.data || null;
				if (typeof configValue === 'string') {
					try {
						const parsed = JSON.parse(configValue);
						this.selectedFields = Object.keys(parsed.columns || {}).filter(key => parsed.columns[key]);
					} catch {
						this.selectedFields = this.allFields.map(f => f.value);
					}
				} else if (configValue?.columns) {
					this.selectedFields = Object.keys(configValue.columns).filter(key => configValue.columns[key]);
				} else {
					this.selectedFields = this.allFields.map(f => f.value);
				}
			} catch (err) {
				console.error('加载用户搜索字段配置失败:', err);
				this.selectedFields = this.allFields.map(f => f.value);
			} finally {
				this.isConfigLoaded = true;
			}
		},
		async saveFieldSettings() {
			try {
				const columnsConfig = {};
				this.allFields.forEach(f => {
					columnsConfig[f.value] = this.selectedFields.includes(f.value);
				});
				await saveUserConfig('goodsSearch-columns', { columns: columnsConfig });
				this.$message.success('字段设置已保存');
				this.fieldSettingVisible = false;
			} catch (err) {
				console.error('保存用户搜索字段配置失败:', err);
				this.$message.error('保存失败，请重试');
			}
		},
		resetToDefault() {
			this.selectedFields = this.allFields.map(f => f.value);
			this.saveFieldSettings();
			this.fieldSettingVisible = false;
		},
		openFieldSetting() {
			this.fieldSettingVisible = true;
		},
		async initializeDefaultQuery() {
			try {
				const range = (await getDateRangeDays()) || {};
				if (range.startTime && range.endTime) {
					const start = String(range.startTime).substring(0, 10);
					const end = String(range.endTime).substring(0, 10);
					this.dateRange = [start, end];
					this.queryParams.orderDateStart = start;
					this.queryParams.orderDateEnd = end;
					const query = _.cloneDeep(this.queryParams);
					this.formatOrderDateRange(query);
					this.$nextTick(() => this.$emit('updateQuery', query));
				}
			} catch (e) {
				console.error('获取默认时间范围失败:', e);
			}
		},
		onDateRangeChange(val) {
			if (Array.isArray(val) && val.length === 2) {
				this.dateRange = val;
				this.handleQuery();
			} else {
				this.dateRange = [];
			}
		},
		handleQuery() {
			// 保留当前分页参数，不重置
			this.queryParams.pageNum = this.currentPageNum;
			this.queryParams.pageSize = this.currentPageSize;
			if (Array.isArray(this.dateRange) && this.dateRange.length === 2) {
				this.queryParams.orderDateStart = this.dateRange[0];
				this.queryParams.orderDateEnd = this.dateRange[1];
			} else {
				this.queryParams.orderDateStart = null;
				this.queryParams.orderDateEnd = null;
			}
			const queryData = _.cloneDeep(this.queryParams);
			this.formatOrderDateRange(queryData);
			this.$emit('updateQuery', queryData);
		},
		resetQuery() {
			// 保存当前分页参数
			const currentPageNum = this.currentPageNum;
			const currentPageSize = this.currentPageSize;

			if (this.$refs.queryForm) this.$refs.queryForm.resetFields();
			Object.assign(this.queryParams, {
				id: '',
				orderDateStart: null,
				orderDateEnd: null,
				pageNum: currentPageNum,
				pageSize: currentPageSize,
				customer: '',
				saleManager: '',
				landDriverName: '',
				landCarNo: '',
				seaDriverName: '',
				seaCarNo: '',
				fleet: '',
				userName: '',
				checkState: ''
			});
			Object.assign(this.queryParams.params, {
				isIncludeTaxSale: '',
				isIncludeTaxFactory: '',
				supplierNames: '',
				levelName: '',
				length: '',
				width: '',
				height: ''
			});
			this.dateRange = [];
			this.handleQuery();
		},
		formatOrderDateRange(queryData) {
			if (!queryData?.orderDateStart || !queryData?.orderDateEnd) return;
			if (String(queryData.orderDateStart).length === 10) {
				queryData.orderDateStart += ' 00:00:00';
			}
			if (String(queryData.orderDateEnd).length === 10) {
				queryData.orderDateEnd += ' 23:59:59';
			}
		}
	}
};
</script>

<style lang="scss" scoped></style>
