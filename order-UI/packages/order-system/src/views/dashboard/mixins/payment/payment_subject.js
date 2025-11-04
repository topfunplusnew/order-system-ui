import { listSubject } from '../../../../api/system/subject';

export var mixin_payment_subject = {
	data: function () {
		return {
			paymentTypeOptions: [],
			paymentTypeTree: [],
			props: {
				label: 'title',
				value: 'title',
				children: 'children'
			},
			// 存储key和路径
			subjectMap: {}
		};
	},
	// 科目查找表
	computed: {
		subjectMap() {}
	},
	created() {
		// 查询科目列表
		listSubject({}, true).then(res => {
			this.paymentTypeOptions = res.data;
			this.$nextTick(() => {
				this.makeTree();
			});
		});
	},

	methods: {
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
			console.log(`this.paymentTypeTree`, this.paymentTypeTree);
			console.log(`this.subjectMap`, this.subjectMap);
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
			// this.subjectMap[parent.fullSubjectString] = [...parent.children.map(item => item.title), parent.title];
		},
		// 从查找表中查找某一个完整科目字符串对应的路径
		searchSubjectFromMap(subjectString) {
			if (!subjectString) return [];
		},
		// 选中某一个节点
		handleChange(value) {}
	}
};
