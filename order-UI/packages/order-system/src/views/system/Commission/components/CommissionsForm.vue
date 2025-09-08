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
					{ required: true, message: '佣金单价不能为空', trigger: 'blur' },
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
							that.dialogVisible = false;
							this.$message.success('修改成功');
							this.reset();
							return Promise.resolve();
						});
					} else {
						addCommission(this.form).then(res => {
							that.dialogVisible = false;
							this.$message.success('添加成功');
							this.reset();
							return Promise.resolve();
						});
					}
				}
			});
		},
		handleReject(that) {
			for (let key in this.form) {
				this.form[key] = typeof this.form[key] === 'boolean' ? false : '';
			}
			that.dialogVisible = false;
			this.reset();
			return Promise.resolve();
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
				<el-input v-model="form.commissionUnitPrice" placeholder="请输入内容" />
			</el-form-item>
			<el-form-item label="其他方式金额" prop="otherPaymentAmount">
				<el-input v-model="form.otherPaymentAmount" placeholder="请输入内容" />
			</el-form-item>
		</el-form>
	</div>
</template>

<style scoped lang="scss"></style>
