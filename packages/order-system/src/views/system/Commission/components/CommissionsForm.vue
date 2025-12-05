<script>
import { listGoodsOrder } from '@/api/system/goodsOrder';
import { addCommission, updateCommission } from '@/api/commission';
import reLength from '@/views/dashboard/mixins/reLength';

export default {
	name: 'CommissionsForm',
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
				id: this.id ? this.id : null,
				type: this.type,
				commissionUnitPrice: '',
				otherPaymentAmount: '',
				orderDetailId: this.orderDetailId ? this.orderDetailId : ''
			},
			queryOrder: null,
			rules: {
				commissionUnitPrice: [
					{ required: true, message: '请输入佣金单价', trigger: 'blur' },
					{ pattern: /^-?\d+(\.\d{1,4})?$/, message: '佣金单价格式不正确，最多保留4位小数', trigger: 'blur' }
				],
				otherPaymentAmount: [{ pattern: /^-?\d+(\.\d{1,2})?$/, message: '其他付款金额格式不正确，最多保留2位小数', trigger: 'blur' }]
			}
		};
	},
	methods: {
		listGoodsOrder,
		handleProcess(that) {
			return new Promise((resolve, reject) => {
				this.$refs.commissionForm.validate(valid => {
					if (valid) {
						if (this.id) {
							updateCommission(this.form).then(res => {
								that.dialogVisible = false;
								this.$message.success('修改成功');
								this.reset();
								resolve();
							});
						} else {
							addCommission(this.form).then(res => {
								that.dialogVisible = false;
								this.$message.success('添加成功');
								this.reset();
								resolve();
							});
						}
					}
				});
			});
		},
		handleReject(that) {
			return new Promise((resolve, reject) => {
				for (let key in this.form) {
					this.form[key] = typeof this.form[key] === 'boolean' ? false : '';
				}
				that.dialogVisible = false;
				this.reset();
				resolve();
			});
		},
		getSupplierNames(list) {
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
			<el-form-item label="佣金单价" prop="commissionUnitPrice">
				<el-input v-model="form.commissionUnitPrice" placeholder="请输入佣金单价" />
			</el-form-item>
			<el-form-item label="其他方式金额" prop="otherPaymentAmount">
				<el-input v-model="form.otherPaymentAmount" placeholder="请输入其他付款金额" />
			</el-form-item>
		</el-form>
	</div>
</template>

<style scoped lang="scss"></style>
