<script>
import { listSubject } from '../api/system/subject';

export default {
	name: 'SubjectOption',
	data() {
		return {
			paymentTypeOptions: [],
			paymentTypeTree: [],
			props: {
				label: 'title',
				value: 'title',
				children: 'children'
			},
			dialogVisible: false,
			type: ''
		};
	},
	methods: {
		getDataList() {
			listSubject({}, true).then(res => {
				this.paymentTypeOptions = res.data;
				this.$nextTick(() => {
					this.makeTree();
				});
			});
			this.dialogVisible = true;
		},
		makeTree() {
			// 找到根节点 通过筛选出parentId为0的元素
			this.paymentTypeTree = this.paymentTypeOptions
				.filter(item => item.parentId === 0)
				.sort((a, b) => {
					return a.orderNum - b.orderNum;
				});
			// 循环每一个根节点，找他们的子节点
			this.paymentTypeTree.forEach(root => {
				this.findChildren(root, '');
			});
		},
		findChildren(parent, fullSubjectString) {
			// 叶子节点存储路径 用于查找
			parent.fullSubjectString = fullSubjectString + parent.title + '-' || '';
			// 对传入根节点的子数组进行操作
			parent.children = this.paymentTypeOptions
				.filter(item => item.parentId === parent.id)
				.sort((a, b) => {
					return a.orderNum - b.orderNum;
				});
			parent.children.forEach(child => {
				this.findChildren(child, parent.fullSubjectString); // 递归处理子节点
			});
			// 如果子节点为空，则删除 children 属性
			if (parent.children.length === 0) {
				delete parent.children;
			}
			parent.fullSubjectString = parent.fullSubjectString?.slice(0, -1);
		},
		// 点击某个节点
		handleNodeClick(value) {
			// 使用 fullSubjectString 获取完整科目路径
			if (value.fullSubjectString) {
				this.type = value.fullSubjectString;
			} else {
				this.type = value.title;
			}
		},
		submitSubject() {
			this.$emit('update:type', this.type);
			this.dialogVisible = false;
		}
	}
};
</script>

<template>
	<div>
		<el-button type="primary" size="mini" icon="el-icon-search" @click="getDataList"></el-button>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="选择科目类型" :visible.sync="dialogVisible" width="300px" append-to-body>
			<el-tree :data="paymentTypeTree" :props="props" @node-click="handleNodeClick"></el-tree>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="submitSubject">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
::v-deep .el-dialog__body {
	max-height: 60vh;
	overflow-y: auto;
}
</style>
