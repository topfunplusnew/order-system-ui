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
			listSubject().then(res => {
				this.paymentTypeOptions = res.data;
				this.makeTree();
			});
			this.dialogVisible = true;
		},
		makeTree() {
			// 找到根节点 通过筛选出parentId为0的元素
			this.paymentTypeTree = this.paymentTypeOptions.filter(item => item.parentId === 0);
			// 循环每一个根节点，找他们的子节点
			this.paymentTypeTree.forEach(root => {
				this.findChildren(root);
			});
		},
		findChildren(parent) {
			// 对传入根节点的子数组进行操作
			parent.children = this.paymentTypeOptions.filter(item => item.parentId === parent.id);
			parent.children.forEach(child => {
				this.findChildren(child); // 递归处理子节点
			});

			// 如果子节点为空，则删除 children 属性
			if (parent.children.length === 0) {
				delete parent.children;
			}
		},
		// 点击某个节点
		handleNodeClick(value) {
			// 查找该节点的父节点
			const parent = this.paymentTypeOptions.find(item => item.id === value.parentId);
			if (parent !== undefined) {
				// 拼接类型
				if (value.type !== parent.title) {
					// 不是一级节点拼接三层
					this.type = value.type + parent.title + value.title;
				} else {
					this.type = value.type + value.title;
				}
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

<style scoped lang="scss"></style>
