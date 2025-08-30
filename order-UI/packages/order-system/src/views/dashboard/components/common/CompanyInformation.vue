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
					// 基础信息
					companyName: '选择公司以查看',
					companyType: '暂无',

					// 联系人信息
					relationName: '暂无',
					relationTel: '暂无',
					leader: '暂无',
					leaderTel: '暂无',
					salesman: '暂无',
					salesManager: '暂无',

					// 地址信息
					region: '暂无',
					province: '暂无',
					city: '暂无',
					county: '暂无',
					address: '暂无',

					// 银行信息
					bankName: '暂无',
					acountsName: '暂无',
					bankNo: '暂无',

					// 其他信息
					comments: '暂无',
					addtime: '暂无',
					userName: '暂无',

					supplierLoading: false
				};
			}
		}
	},
	data() {
		return {
			debounceTimer: null, // 存储防抖定时器
			timeOut: 500
		};
	},
	computed: {
		// 计算完整地址
		fullAddress() {
			const { province, city, county, address } = this.companyInfo;
			const parts = [province, city, county, address].filter(part => part && part !== '暂无');
			return parts.length > 0 ? parts.join('') : '暂无';
		},
		// 格式化公司类型
		formattedCompanyType() {
			const type = this.companyInfo.companyType;
			return type === '客户' ? 'success' : type === '供应商' ? 'warning' : 'info';
		}
	},
	methods: {
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div class="company-info-wrapper">
		<el-card class="company-info-card" v-loading="companyInfo.supplierLoading">
			<div slot="header" class="card-header">
				<div class="header-content">
					<div class="company-title">
						<i class="el-icon-office-building"></i>
						<span class="company-name">{{ companyInfo.companyName }}</span>
						<el-tag :type="formattedCompanyType" size="mini" class="company-type-tag">
							{{ companyInfo.companyType }}
						</el-tag>
					</div>
					<div class="header-meta">
						<span class="add-time">添加时间：{{ companyInfo.addtime }}</span>
						<span class="operator">操作员：{{ companyInfo.userName }}</span>
					</div>
				</div>
			</div>

			<div class="info-sections">
				<!-- 基础信息 -->
				<div class="info-section">
					<div class="section-title">
						<i class="el-icon-user"></i>
						<span>基础信息</span>
					</div>
					<el-descriptions class="section-descriptions" size="small" :column="2" border>
						<el-descriptions-item label="公司名称" :span="2">
							<EllipsisText :title="companyInfo.companyName" />
						</el-descriptions-item>
						<el-descriptions-item label="公司类型">
							<el-tag :type="formattedCompanyType" size="mini">
								{{ companyInfo.companyType }}
							</el-tag>
						</el-descriptions-item>
						<el-descriptions-item label="销售经理">
							<EllipsisText :title="companyInfo.salesManager" />
						</el-descriptions-item>
					</el-descriptions>
				</div>

				<!-- 联系人信息 -->
				<div class="info-section">
					<div class="section-title">
						<i class="el-icon-phone"></i>
						<span>联系人信息</span>
					</div>
					<el-descriptions class="section-descriptions" size="small" :column="2" border>
						<el-descriptions-item label="负责人">
							<EllipsisText :title="companyInfo.relationName" />
						</el-descriptions-item>
						<el-descriptions-item label="负责人电话">
							<span class="phone-number">{{ companyInfo.relationTel }}</span>
						</el-descriptions-item>
						<el-descriptions-item label="老板" v-if="companyInfo.leader !== '暂无'">
							<EllipsisText :title="companyInfo.leader" />
						</el-descriptions-item>
						<el-descriptions-item label="老板电话" v-if="companyInfo.leaderTel !== '暂无'">
							<span class="phone-number">{{ companyInfo.leaderTel }}</span>
						</el-descriptions-item>
						<el-descriptions-item label="业务员" v-if="companyInfo.salesman !== '暂无'">
							<EllipsisText :title="companyInfo.salesman" />
						</el-descriptions-item>
					</el-descriptions>
				</div>

				<!-- 地址信息 -->
				<div class="info-section">
					<div class="section-title">
						<i class="el-icon-location"></i>
						<span>地址信息</span>
					</div>
					<el-descriptions class="section-descriptions" size="small" :column="1" border>
						<el-descriptions-item label="区域">
							<EllipsisText :title="companyInfo.region" />
						</el-descriptions-item>
						<el-descriptions-item label="详细地址" v-if="fullAddress !== '暂无'">
							<EllipsisText :title="fullAddress" />
						</el-descriptions-item>
					</el-descriptions>
				</div>

				<!-- 银行信息 -->
				<div class="info-section" v-if="companyInfo.bankName !== '暂无' || companyInfo.acountsName !== '暂无' || companyInfo.bankNo !== '暂无'">
					<div class="section-title">
						<i class="el-icon-credit-card"></i>
						<span>银行信息</span>
					</div>
					<el-descriptions class="section-descriptions" size="small" :column="2" border>
						<el-descriptions-item label="开户银行" v-if="companyInfo.bankName !== '暂无'">
							<EllipsisText :title="companyInfo.bankName" />
						</el-descriptions-item>
						<el-descriptions-item label="账户名称" v-if="companyInfo.acountsName !== '暂无'">
							<EllipsisText :title="companyInfo.acountsName" />
						</el-descriptions-item>
						<el-descriptions-item label="银行账号" :span="2" v-if="companyInfo.bankNo !== '暂无'">
							<span class="bank-number">{{ companyInfo.bankNo }}</span>
						</el-descriptions-item>
					</el-descriptions>
				</div>

				<!-- 备注信息 -->
				<div class="info-section" v-if="companyInfo.comments !== '暂无'">
					<div class="section-title">
						<i class="el-icon-document"></i>
						<span>备注信息</span>
					</div>
					<el-descriptions class="section-descriptions" size="small" :column="1" border>
						<el-descriptions-item label="备注">
							<EllipsisText :title="companyInfo.comments" />
						</el-descriptions-item>
					</el-descriptions>
				</div>
			</div>
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
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.08);
	border: 1px solid #ebeef5;
	border-radius: 8px;

	&:hover {
		box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.12);
	}

	::v-deep .el-card__header {
		padding: 16px 20px;
		border-bottom: 1px solid #ebeef5;
		background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
	}

	::v-deep .el-card__body {
		padding: 20px;
		overflow-y: auto;
		max-height: calc(100vh - 200px);
	}
}

.card-header {
	.header-content {
		.company-title {
			display: flex;
			align-items: center;
			gap: 8px;
			margin-bottom: 8px;

			.el-icon-office-building {
				font-size: 18px;
				color: #409eff;
			}

			.company-name {
				font-weight: bold;
				font-size: 16px;
				color: #161617;
				flex: 1;
			}

			.company-type-tag {
				font-weight: 500;
			}
		}

		.header-meta {
			display: flex;
			justify-content: space-between;
			font-size: 12px;
			color: #909399;

			span {
				display: flex;
				align-items: center;
			}
		}
	}
}

.info-sections {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.info-section {
	.section-title {
		display: flex;
		align-items: center;
		gap: 6px;
		margin-bottom: 12px;
		font-weight: 600;
		font-size: 14px;
		color: #303133;

		i {
			font-size: 16px;
			color: #409eff;
		}
	}

	.section-descriptions {
		::v-deep .el-descriptions__label {
			font-weight: 500;
			color: #606266;
			background-color: #fafbfc;
			width: 100px;
			text-align: right;
		}

		::v-deep .el-descriptions__content {
			color: #303133;
			background-color: #ffffff;
		}

		::v-deep .el-descriptions-item__cell {
			padding: 10px 16px;
			border-color: #ebeef5;
		}

		::v-deep .el-descriptions__table {
			border-radius: 6px;
			overflow: hidden;
		}

		.phone-number {
			color: #409eff;
			font-weight: 500;

			&:hover {
				text-decoration: underline;
				cursor: pointer;
			}
		}

		.bank-number {
			font-family: 'Courier New', monospace;
			color: #e6a23c;
			font-weight: 500;
			letter-spacing: 1px;
		}
	}
}

/* 特殊样式 */
.el-tag {
	&.el-tag--success {
		background-color: #f0f9ff;
		color: #67c23a;
		border-color: #b3e19d;
	}

	&.el-tag--warning {
		background-color: #fdf6ec;
		color: #e6a23c;
		border-color: #f5dab1;
	}

	&.el-tag--info {
		background-color: #f4f4f5;
		color: #909399;
		border-color: #d3d4d6;
	}
}

/* 响应式适配 */
@media screen and (max-width: 768px) {
	.company-info-card {
		::v-deep .el-card__header {
			padding: 12px 16px;
		}

		::v-deep .el-card__body {
			padding: 16px;
		}
	}

	.header-content {
		.company-title {
			.company-name {
				font-size: 14px;
			}
		}

		.header-meta {
			flex-direction: column;
			gap: 4px;
			align-items: flex-start;
		}
	}

	.info-sections {
		gap: 16px;
	}

	.section-descriptions {
		::v-deep .el-descriptions__label {
			width: 80px;
			font-size: 12px;
		}

		::v-deep .el-descriptions__content {
			font-size: 13px;
		}

		::v-deep .el-descriptions-item__cell {
			padding: 8px 12px;
		}
	}
}

@media screen and (max-width: 480px) {
	.company-info-card {
		::v-deep .el-card__header {
			padding: 10px 12px;
		}

		::v-deep .el-card__body {
			padding: 12px;
		}
	}

	.header-content {
		.company-title {
			flex-direction: column;
			align-items: flex-start;
			gap: 6px;

			.company-name {
				font-size: 13px;
			}
		}
	}

	.section-title {
		font-size: 13px;

		i {
			font-size: 14px;
		}
	}

	.section-descriptions {
		::v-deep .el-descriptions__label {
			width: 70px;
			font-size: 11px;
		}

		::v-deep .el-descriptions__content {
			font-size: 12px;
		}

		::v-deep .el-descriptions-item__cell {
			padding: 6px 10px;
		}
	}
}
</style>
