import { listSubject } from "../../../../api/system/subject";

// 通用的构造树形节点的混入
export var mixin_receive_money_subject = {
  data: function () {
    return {
      paymentTypeOptions: [],
      paymentTypeTree: [],
      props: {
        label: "title",
        value: "title",
        children: "children",
      },
    };
  },
  created() {
    // 查询科目列表
    listSubject().then((res) => {
      this.paymentTypeOptions = res.data;
      this.makeTree();
    });
  },

  methods: {
    makeTree() {
      // 找到根节点 通过筛选出parentId为0的元素
      this.paymentTypeTree = this.paymentTypeOptions.filter(
        (item) => item.parentId === 0
      );
      // 循环每一个根节点，找他们的子节点
      this.paymentTypeTree.forEach((root) => {
        this.findChildren(root);
      });
    },
    findChildren(parent) {
      // 对传入根节点的子数组进行操作
      parent.children = this.paymentTypeOptions.filter(
        (item) => item.parentId === parent.id
      );
      parent.children.forEach((child) => {
        this.findChildren(child); // 递归处理子节点
      });

      // 如果子节点为空，则删除 children 属性
      if (parent.children.length === 0) {
        delete parent.children;
      }
    },
    // 选中某一个节点
    handleChange() {},
  },
};
