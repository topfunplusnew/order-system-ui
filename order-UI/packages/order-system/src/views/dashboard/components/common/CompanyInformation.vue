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
	<div class="company-info-wrapper">
		<el-card class="company-info-card" v-loading="companyInfo.supplierLoading">
			<div slot="header" class="card-header">
				<span class="bold-text">{{ companyInfo.companyType }}信息</span>
			</div>
			<el-descriptions class="company-descriptions" size="mini" :column="1" border>
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
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.company-info-wrapper {
	height: 100%;
	display: flex;
	flex-direction: column;
}

.company-info-card {
	height: 100%;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
	border: 1px solid #ebeef5;
	border-radius: 6px;

	&:hover {
		box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.12);
	}

	::v-deep .el-card__header {
		padding: 12px 16px;
		border-bottom: 1px solid #ebeef5;
		
		.card-header {
			margin: 0;
		}
	}

	::v-deep .el-card__body {
		padding: 16px;
		overflow-y: auto;
	}
}

.bold-text {
	font-weight: bold;
	color: #161617;
	font-size: 14px;
}

.company-descriptions {
	::v-deep .el-descriptions__label {
		font-weight: 500;
		color: #606266;
		background-color: #f5f7fa;
		width: 80px;
	}

	::v-deep .el-descriptions__content {
		color: #303133;
		background-color: #ffffff;
	}

	::v-deep .el-descriptions-item__cell {
		padding: 8px 12px;
	}

	::v-deep .el-descriptions__table {
		border-radius: 4px;
		overflow: hidden;
	}
}

/* 响应式适配 */
@media screen and (max-width: 768px) {
	.company-info-card {
		::v-deep .el-card__body {
			padding: 12px;
		}
	}

	.company-descriptions {
		::v-deep .el-descriptions__label {
			width: 70px;
		}

		::v-deep .el-descriptions-item__cell {
			padding: 6px 10px;
		}
	}
}

@media screen and (max-width: 480px) {
	.company-descriptions {
		::v-deep .el-descriptions__label {
			width: 60px;
			font-size: 12px;
		}

		::v-deep .el-descriptions__content {
			font-size: 12px;
		}

		::v-deep .el-descriptions-item__cell {
			padding: 4px 8px;
		}
	}
}
</style>
