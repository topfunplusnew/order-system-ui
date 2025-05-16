<script>
import { getPayment } from '../../../../api/system/payment';
import { getMapperMethod } from './mapper';

/**
 * 付款信息页面 点击查看原单据信息 先查payment拿到表名 再拿tID加表名锁信息
 */
export default {
	name: 'CheckPrevious',
	props: {
		row: {
			type: Object,
			default: null
		}
	},
	data() {
		return {
			showInfo: {},
			// 弹窗
			dialogVisible: false
		};
	},
	mounted() {},
	methods: {
		// 查看原单据信息
		handleCheck(row) {
			getPayment(row.id).then(res => {
				const { tID, tableName } = res.data;
				// 当前有tID和tableName
				if (tID && tableName) {
					// 现在设计一个mapper 表名对应执行方法
					getMapperMethod(tableName)(tID)
						.then(res => {
							// 只有在存在数据的情况下才显示
							if (res?.data) {
								this.showInfo = res.data;
								console.log(this.showInfo);
								this.dialogVisible = true;
							} else {
								this.$message.warning('未找到对应数据');
							}
						})
						.catch(err => {
							this.$message.error('系统错误');
						});
				}
			});
		}
	}
};
</script>

<template>
	<div>
		<el-button size="mini" type="text" @click="handleCheck(row)">查看原单据</el-button>

		<el-dialog v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="数据展示" :visible.sync="dialogVisible" width="500px" append-to-body>
			<el-descriptions title="数据信息">
				<el-descriptions-item label="用户名">kooriookami</el-descriptions-item>
			</el-descriptions>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogVisible = false">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
