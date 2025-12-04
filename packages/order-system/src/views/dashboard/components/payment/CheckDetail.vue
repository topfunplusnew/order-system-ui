<!--查看详情-->

<script>
import { getCars } from '../../../../api/system/cars';

export default {
	name: 'CheckDetail',
	props: {
		row: {
			type: Object
		}
	},
	data() {
		return {};
	},
	methods: {
		handleCheck(row) {
			if (!row.companyId) {
				this.$message.error('本行数据有误:司机ID为空！');
				return;
			}
			getCars(row.companyId).then(res => {
				this.$antdconfirm({
					title: '提示',
					content: `是否查看司机名称为${res.data.driver}的运费详情?`,
					okText: '确定',
					cancelText: '取消',
					type: 'warning',
					zIndex: 2600,
					onOk: () => {
						this.$router.push({
							path: '/freight/applyfreight',
							query: {
								fundsDate: row.fundsDate,
								driverId: res.data.id
							}
						});
					},
					onCancel: () => {
						this.$message.info('已取消查看运费详情');
					}
				});
			});
		}
	}
};
</script>

<template>
	<div>
		<div v-if="row.companyType === '司机'">
			<el-button size="mini" type="text" @click="handleCheck(row)">查看运费详情</el-button>
		</div>
		<div v-else>无运费信息</div>
	</div>
</template>

<style scoped lang="scss"></style>
