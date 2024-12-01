<template>
	<el-dialog
		:close-on-click-modal="false"
		:show-close="false"
		title="订单历史信息"
		:visible.sync="checkHistoryOrderVisible"
		width="1100px"
	>
		<el-row>
			<el-col :span="18" :offset="3">
				<el-timeline>
					<el-timeline-item timestamp="至今" placement="top">
						<el-button
							type="success"
							icon="el-icon-document"
							@click="checkcurrentOrderItemInfo"
						>
							查看原订单信息
						</el-button>
					</el-timeline-item>
					<!--            修改的时间线-->
					<el-timeline-item
						v-for="(item, index) in orderHistoryInfoList"
						:key="index"
						placement="top"
						:timestamp="item.diff.updateTime"
					>
						<el-collapse v-model="activeNames">
							<el-collapse-item
								:title="item.userName + ':' + item.remark"
								:name="index"
							>
								<el-card>
									<template #header>
										<span style="font-weight: bold"
											>修改人:{{ item.userName }}-{{ item.remark }}</span
										>
									</template>
									<div>
										<CodeDiff
											:old-string="item.diff.old"
											:new-string="item.diff.new"
											:context="10"
											output-format="line-by-line"
										/>
									</div>
								</el-card>
							</el-collapse-item>
						</el-collapse>
					</el-timeline-item>
				</el-timeline>
			</el-col>
		</el-row>
		<div slot="footer" class="dialog-footer">
			<el-button @click="close"> 关 闭</el-button>
		</div>
	</el-dialog>
</template>
<script>
import CodeDiff from 'vue-code-diff';

export default {
	name: 'OrderHistoryCheck',
	components: { CodeDiff },
	props: {
		activeNames: {
			type: Array,
			default() {
				return [];
			}
		},
		checkHistoryOrderVisible: {
			type: Boolean
		},
		checkcurrentOrderItemInfo: {
			type: Function,
			default() {
				return () => {};
			}
		},
		orderHistoryInfoList: {
			type: Array,
			default() {
				return [];
			}
		},
		parseTime: {
			type: String,
			default() {
				return '';
			}
		}
	},
	methods: {
		close() {
			this.$emit('close');
		}
	}
};
</script>

<style lang="scss" scoped>
.center {
	// 解决vue-code-diff对不齐和显示下拉标志问题
	max-height: 600px;
	overflow-y: auto;
	overflow-x: hidden;

	/* 样式穿透-起始行左右对齐，*/

	.d2h-code-side-line {
		height: 15px;
	}

	code.hljs {
		padding: 0;
	}

	// 删除行统计显示

	.d2h-code-side-linenumber {
		display: none;
	}

	.d2h-code-side-line {
		padding: unset;
	}

	.d2h-code-line-ctn {
		width: unset;
	}

	// 删除第一行的统计结果

	.d2h-info {
		display: none;
	}
}
</style>
