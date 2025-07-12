<script>
import SearchOption from '@/components/SearchOption.vue';
import { listGoodsOrder } from '@/api/system/goodsOrder';
import { addCommission, updateCommission } from '@/api/commission';
import reLength from '@/views/dashboard/mixins/reLength';

export default {
	name: 'CommissionsForm',
	components: { SearchOption },
	mixins: [reLength],
	props: {
		// 这个只有在修改的时候有值
		id: {
			type: Number,
			default: 0
		},
		// 厂家返利还是客户返利
		type: {
			type: Number,
			default: 0
		},
		// 订单的id
		orderDetailId: {
			type: Number,
			default: 0
		},
		body: {
			type: Object,
			default: () => {}
		}
	},
	watch: {
		body: {
			handler(val) {
				this.$nextTick(() => {
					Object.assign(this.form, val);
				});
			},
			deep: true,
			immediate: true
		}
	},
	data() {
		return {
			form: {
				// id 只在修改的时候有值
				id: this.id ? this.id : null,
				type: this.type,
				commissionUnitPrice: '',
				otherPaymentAmount: '',
				orderDetailId: this.orderDetailId ? this.orderDetailId : ''
			},
			queryOrder: null,
			rules: {
				commissionUnitPrice: [
					{ required: true, message: '佣金单价不能为空', trigger: 'blur' },
					{ pattern: /^[0-9]+(.[0-9]{1,2})?$/, message: '请输入数字，且最多保留两位小数', trigger: 'blur' }
				],
				otherPaymentAmount: [
					{ required: true, message: '其他方式金额不能为空', trigger: 'blur' },
					{ pattern: /^[0-9]+(.[0-9]{1,2})?$/, message: '请输入数字，且最多保留两位小数', trigger: 'blur' }
				]
			}
		};
	},
	methods: {
		listGoodsOrder,
		handleProcess(that) {
			this.$refs.commissionForm.validate(valid => {
				if (valid) {
					if (this.id) {
						updateCommission(this.form).then(res => {
							this.$message.success('修改成功');
							that.dialogVisible = false;
							this.reset();
						});
						return;
					}

					addCommission(this.form).then(res => {
						this.$message.success('添加成功');
						that.dialogVisible = false;
						this.reset();
					});
				}
			});
		},
		handleReject(that) {
			for (let key in this.form) {
				this.form[key] = typeof this.form[key] === 'boolean' ? false : '';
			}
			that.dialogVisible = false;
			this.reset();
		},
		getSupplierNames(list) {
			console.log(list);

			if (list.length === 0) {
				return;
			}
			// 使用 Map 根据 supplierID 去重
			const supplierMap = new Map();
			list.forEach(item => {
				if (item.supplierID && !supplierMap.has(item.supplierID)) {
					supplierMap.set(item.supplierID, {
						supplier: item.supplier,
						supplierID: item.supplierID
					});
				}
			});
			// 返回去重后的数组
			return Array.from(supplierMap.values());
		},
		reset() {
			this.form = {
				id: this.id ? this.id : null,
				type: this.type,
				commissionUnitPrice: '',
				otherPaymentAmount: '',
				orderDetailId: this.orderDetailId ? this.orderDetailId : ''
			};
		}
	}
};
</script>

<template>
	<div>
		<el-form ref="commissionForm" :model="form" :rules="rules" label-width="140px">
			<!-- <el-form-item label="订单编号">
				<el-col :span="20">
					<el-input v-model="form.orderDetailId" placeholder="请输入内容" disabled />
				</el-col>
				<el-col :span="4">
					<SearchOption
						:limit-info="{}"
						:get-data="listGoodsOrder"
						icon="el-icon-search"
						query-label="订单编号"
						query-info="id"
						:query-name="queryOrder"
						@update:queryName="value => (queryOrder = value)"
						@commitBack="value => (form.orderDetailId = value.id)"
					>
						<template #table-columns>
							<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
							<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left" />
							<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" />
							<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left" width="200">
								<template #default="scope">
									<el-row v-if="scope.row.smailOrderDetails">
										<span v-for="(item, index) in getSupplierNames(scope.row.smailOrderDetails)" :key="index">
											<span class="invoice">
												{{ item.supplier }}
											</span>
										</span>
									</el-row>
									<template v-else>无</template>
								</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"></el-table-column>
							<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
							<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
							<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
							<el-table-column show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="100px">
								<template #default="scope">
									{{ scope.row.allPayments | changeNumber(changeLength) }}
								</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight" width="100px" />
							<el-table-column show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo">
								<template #default="scope">
									{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
								</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel" width="100px">
								<template #default="scope">
									{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
								</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
								<template #default="scope">
									{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
								</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight" width="100px" />
							<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
						</template>
					</SearchOption>
				</el-col>
			</el-form-item> -->
			<el-form-item label="佣金单价" prop="commissionUnitPrice">
				<el-input v-model="form.commissionUnitPrice" placeholder="请输入内容" />
			</el-form-item>
			<el-form-item label="其他方式金额" prop="otherPaymentAmount">
				<el-input v-model="form.otherPaymentAmount" placeholder="请输入内容" />
			</el-form-item>
		</el-form>
	</div>
</template>

<style scoped lang="scss"></style>
