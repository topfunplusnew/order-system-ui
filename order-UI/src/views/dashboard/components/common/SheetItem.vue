<script>
import ExcelIcon from '@/views/dashboard/components/common/ExcelIcon.vue';

export default {
	name: 'SheetItem',
	components: { ExcelIcon },
	props: {
		title: {
			type: String,
			default: '无'
		}
	}
};
</script>

<template>
	<div>
		<div class="sheet-item">
			<div class="sheet-item-icon">
				<ExcelIcon />
			</div>
			<div class="sheet-item-desc">
				{{ title }}
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.sheet-item {
	width: 90px;
	height: 90px;
	background: #ffffff;
	margin: 15px;
	border-radius: 10px;
	padding: 5px;

	&:hover {
		background: #a7d7ad;
		cursor: pointer;
		transition: all 0.3s ease-in-out;
	}
}

.sheet-item-icon {
	text-align: center;
}

.sheet-item-desc {
	text-align: center;
	font-weight: bold;
}
</style>
