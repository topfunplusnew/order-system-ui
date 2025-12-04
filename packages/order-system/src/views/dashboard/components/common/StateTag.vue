<!--状态标签 传入的状态可能有多种组合 例如 开票与未开票 申请中 未付款 和已付款-->

<script>
export default {
	name: 'StateTag',
	props: {
		// 传入一个对象数组 每一个对象是这种状态对应的tag  例如 [{0：'未申请',1:'申请中',2:'未支付',3:'已支付'}]
		stateMapper: {
			type: Object,
			default: () => {
				return {};
			}
		},
		// 传入的状态
		stateTitle: {
			type: String,
			default: ''
		}
	},
	computed: {
		computedState() {
			const arr = Object.entries(this.stateMapper);

			const item = arr.find(([key, value]) => {
				return value === this.stateTitle;
			});

			const index = Number(item[0]) || 0;
			switch (index) {
				case 0:
					return 'danger';
				case 1:
					return 'warning';
				case 2:
					return 'success';
				case 3:
					return 'info';
				default:
					return 'info';
			}
		}
	}
};
</script>

<template>
	<div>
		<el-tag :type="computedState" size="mini">
			{{ stateTitle }}
		</el-tag>
	</div>
</template>

<style
	scoped
	lang=" scss
    "
></style>
