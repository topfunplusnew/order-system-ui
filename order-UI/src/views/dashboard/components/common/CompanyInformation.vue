<script>
import EllipsisText from '@/views/dashboard/components/common/EllipsisText.vue';

export default {
	components: { EllipsisText },
	props: {
		supplierInfo: {
			type: Object,
			default: () => {
				return {
					supplierLoading: false
				};
			}
		}
	},
	watch: {
		point: {
			handler(val) {
				// 清除之前的定时器
				clearTimeout(this.debounceTimer);
				// 设置新的定时器
				this.debounceTimer = setTimeout(() => {
					this.$emit('update:point', val);
				}, this.timeOut); // 300ms 的防抖时间，可以根据需求调整
			},
			immediate: true
		}
	},
	data() {
		return {
			point: 0,
			debounceTimer: null, // 存储防抖定时器
			timeOut: 500
		};
	}
};
</script>

<template>
	<div>
		<div class="left-box-item">
			<el-card class="box-card" v-loading="supplierInfo.supplierLoading">
				<el-descriptions title="购买方信息" size="mini">
					<el-descriptions-item label="用户名">
						<EllipsisText title="张三是最帅的一个人" />
					</el-descriptions-item>
					<el-descriptions-item label="手机号">
						<EllipsisText title="张三是最帅的一个人" />
					</el-descriptions-item>
					<el-descriptions-item label="居住地">
						<EllipsisText title="张三是最帅的一个人" />
					</el-descriptions-item>
					<el-descriptions-item label="备注">
						<EllipsisText title="张三是最帅的一个人" />
					</el-descriptions-item>
					<el-descriptions-item label="联系地址">
						<EllipsisText title="张三是最帅的一个人" />
					</el-descriptions-item>
				</el-descriptions>
				<!--                  输入本批开票票点-->
				<div>
					<el-input v-model="point" placeholder="请输入本批开票票点"></el-input>
				</div>
			</el-card>
		</div>
	</div>
</template>

<style scoped lang="scss">
.left-box-item {
	margin-bottom: 20px;
}
</style>
