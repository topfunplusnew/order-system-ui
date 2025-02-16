<script>
import EllipsisText from '@/views/dashboard/components/common/EllipsisText.vue';
// import { mapGetters } from 'vuex';

export default {
	components: { EllipsisText },
	props: {
		companyInfo: {
			type: Object,
			default: () => {
				return {
					companyName: '选择公司以查看',
					companyType: '暂无',
					leader: '暂无',
					region: '暂无',
					leaderTel: '暂无',
					comments: '暂无',
					supplierLoading: false
				};
			}
		}
	},

	// watch: {
	// 	point: {
	// 		handler(val) {
	// 			// 清除之前的定时器
	// 			clearTimeout(this.debounceTimer);
	// 			// 设置新的定时器
	// 			this.debounceTimer = setTimeout(() => {
	// 				this.$store.dispatch('excel/setTicketPoint', val);
	// 			}, this.timeOut); // 300ms 的防抖时间，可以根据需求调整
	// 		},
	// 		immediate: true
	// 	}
	// },
	// computed: {
	// 	point: {
	// 		get() {
	// 			return this.ticketPoint;
	// 		},
	// 		set(val) {
	// 			this.$store.dispatch('excel/setTicketPoint', val);
	// 		}
	// 	},
	// 	comments: {
	// 		get() {
	// 			return this.comment;
	// 		},
	// 		set(val) {
	// 			this.$store.dispatch('excel/setComment', val);
	// 		}
	// 	},
	// 	...mapGetters(['ticketPoint', 'comment'])
	// },
	data() {
		return {
			debounceTimer: null, // 存储防抖定时器
			timeOut: 500
		};
	}
};
</script>

<template>
	<div>
		<div class="left-box-item">
			<el-card class="box-card" v-loading="companyInfo.supplierLoading">
				<el-descriptions :title="companyInfo.companyType + '信息：'" size="mini">
					<el-descriptions-item label="公司名称">
						<EllipsisText :title="companyInfo.companyName" />
					</el-descriptions-item>
					<el-descriptions-item label="老板">
						<EllipsisText :title="companyInfo.leader" />
					</el-descriptions-item>
					<el-descriptions-item label="区域">
						<EllipsisText :title="companyInfo.region" />
					</el-descriptions-item>
					<el-descriptions-item label="联系电话">
						<EllipsisText :title="companyInfo.leaderTel" />
					</el-descriptions-item>
					<el-descriptions-item label="备注">
						<EllipsisText :title="companyInfo.comments" />
					</el-descriptions-item>
				</el-descriptions>
				<!--                  输入本批开票票点-->
			</el-card>

			<br />
			<!--			<el-card class="box-card">-->
			<!--				<div slot="header" class="clearfix">-->
			<!--					<span class="bold-text">票点</span>-->
			<!--				</div>-->
			<!--				<div>-->
			<!--					<el-form inline size="mini">-->
			<!--						<el-form-item label="本批开票票点">-->
			<!--							<el-input-->
			<!--								size="mini"-->
			<!--								v-model="point"-->
			<!--								clearable-->
			<!--								placeholder="请输入本批开票票点"-->
			<!--							></el-input>-->
			<!--						</el-form-item>-->
			<!--						<el-form-item label="本批操作备注">-->
			<!--							<el-input-->
			<!--								size="mini"-->
			<!--								v-model="comments"-->
			<!--								clearable-->
			<!--								placeholder="请输入本批操作备注"-->
			<!--							></el-input>-->
			<!--						</el-form-item>-->
			<!--					</el-form>-->
			<!--				</div>-->
			<!--			</el-card>-->
		</div>
	</div>
</template>

<style scoped lang="scss">
.left-box-item {
	margin-bottom: 20px;
}

.bold-text {
	font-weight: bold;
}
</style>
