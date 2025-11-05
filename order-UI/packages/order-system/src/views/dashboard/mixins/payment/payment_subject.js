import { listSubject } from '../../../../api/system/subject';
import { getCompany } from '@/api/system/company';
import { getDicts } from '@/api/system/dict/data';
import { getConfigKey } from '../../../../api/system/config';
export var mixin_payment_subject = {
	data: function () {
		return {
			paymentTypeOptions: [],
			paymentTypeTree: [],
			props: {
				label: 'title',
				value: 'title',
				children: 'children'
			}
		};
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
		// 从查找表中查找某一个完整科目字符串对应的路径
		searchSubjectFromMap(subjectString) {
			if (!subjectString) return [];

			// 标准化输入的 subjectString，确保格式一致（去掉首尾空格，统一分隔符）
			const normalizedSubjectString = subjectString.trim();

			// 递归查找节点
			const findNodePath = (nodes, path = []) => {
				for (let node of nodes) {
					const currentPath = [...path, node.title];

					// 检查当前节点的 fullSubjectString 是否匹配
					if (node.fullSubjectString === normalizedSubjectString) {
						return currentPath;
					}

					// 如果有子节点，递归查找
					if (node.children && node.children.length > 0) {
						const result = findNodePath(node.children, currentPath);
						if (result) {
							return result;
						}
					}
				}
				return null;
			};

			// 从根节点开始查找
			const path = findNodePath(this.paymentTypeTree);
			return path || [];
		},
		searchSubjectNodeFromMap(subjectString) {
			if (!subjectString) return [];

			// 标准化输入的 subjectString，确保格式一致（去掉首尾空格，统一分隔符）
			const normalizedSubjectString = subjectString.trim();

			// 递归查找节点
			const findNodePath = (nodes, path = []) => {
				for (let node of nodes) {
					const currentPath = [...path, node.title];

					// 检查当前节点的 fullSubjectString 是否匹配
					if (node.fullSubjectString === normalizedSubjectString) {
						return node;
					}

					// 如果有子节点，递归查找
					if (node.children && node.children.length > 0) {
						const result = findNodePath(node.children, currentPath);
						if (result) {
							return result;
						}
					}
				}
				return null;
			};

			// 从根节点开始查找
			const node = findNodePath(this.paymentTypeTree);
			return node || null;
		},
		// 选中某一个节点
		async handleChange(value) {
			try {
				const subjectNode = this.searchSubjectNodeFromMap(value.join('-'));
				// 获取字典数据
				const dictResponse = await getDicts('order_payment_subject_company_mapping');
				if (dictResponse.data.length > 0) {
					for (const dict of dictResponse.data) {
						const [subjectNo, companyType, id] = dict.dictValue.split(':');
						if (subjectNo === subjectNode.subjectNo) {
							console.log(subjectNo);
							getCompany(id, companyType).then(res => {
								if (!res.data) return;
								this.$nextTick(() => {
									this.form.companyName = res.data.companyName;
								});
							});
						}
					}
				}
			} catch (error) {
				console.error('获取付款类型对应的公司信息失败:', error);
				// 静默处理错误，不显示提示
			}
		}
	}
};
