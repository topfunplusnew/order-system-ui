<script>
export default {
	name: 'COMPANY_CAR',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	},
	computed: {
		// 提取 extraInfo 的附件列表
		attachments() {
			// todo 附件需要处理一下
			return this.needToSowInfo.extraInfo
				? Object.values(this.needToShowInfo.extraInfo)
				: [];
		}
	},
	methods: {
		handleProcess(that) {
			that.dialogVisible = false;
		},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<!-- 车辆信息 -->
		<el-descriptions title="车辆信息" border>
			<el-descriptions-item label="车辆型号">
				{{ needToShowInfo.model }}
			</el-descriptions-item>
			<el-descriptions-item label="车牌号">
				{{ needToShowInfo.licensePlate }}
			</el-descriptions-item>
			<el-descriptions-item label="购买时间">
				{{ needToShowInfo.purchaseDate }}
			</el-descriptions-item>
			<el-descriptions-item label="行驶里程">
				{{ needToShowInfo.mileage }}
			</el-descriptions-item>
			<el-descriptions-item label="保养金额">
				{{ needToShowInfo.maintenanceCost }}
			</el-descriptions-item>
			<el-descriptions-item label="保养日期">
				{{ needToShowInfo.maintenanceDate }}
			</el-descriptions-item>
			<el-descriptions-item label="保险金额">
				{{ needToShowInfo.insuranceCost }}
			</el-descriptions-item>
		</el-descriptions>

		<!-- 附件轮播图 -->
		<div v-if="attachments.length" class="carousel-container">
			<h3>附件信息</h3>
			<el-carousel
				indicator-position="outside"
				height="300px"
				autoplay
				class="carousel"
			>
				<el-carousel-item
					v-for="(attachment, index) in attachments"
					:key="index"
				>
					<img :src="attachment" alt="附件图片" class="carousel-image" />
				</el-carousel-item>
			</el-carousel>
		</div>
	</div>
</template>

<style scoped lang="scss">
.carousel-container {
	margin-top: 20px;
	background-color: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.carousel {
	width: 100%;
	overflow: hidden;
}

.carousel-image {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 确保图片按比例填充 */
	border-radius: 8px;
}
</style>
