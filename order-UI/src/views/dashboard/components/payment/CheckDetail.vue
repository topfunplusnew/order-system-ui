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
				// 点击确认后跳转到订单运费界面 携带搜索参数
				this.$confirm(
					`是否查看司机名称为${res.data.driver}的运费详情?`,
					'提示',
					{
						confirmButtonText: '确定',
						cancelButtonText: '取消',
						type: 'warning'
					}
				).then(() => {
					this.$router.push({
						path: '/freight/applyfreight',
						query: {
							fundsDate: row.fundsDate,
							driverId: res.data.id
						}
					});
				});
			});
		}
	}
};
</script>

<template>
	<div>
		<div v-if="row.companyType === '司机'">
			<el-button size="mini" type="text" @click="handleCheck(row)"
				>查看运费详情
			</el-button>
		</div>
		<div v-else>无运费信息</div>
	</div>
</template>

<style scoped lang="scss"></style>
