export var mixin_payment_level = {
  data: function () {
    return {
      //付款分类信息
      subjectTree: [],
      //分类信息
      currentSort: {
        levelOne: '',
        levelTwo: ''
      },
      //一级分类列表
      OneLevelOption: [],
      //二级分类
      TwoLevelOption: [],
    }
  },
  computed: {
    fullLevel() {
      return this.currentSort.levelOne + '-' + this.currentSort.levelTwo;
    },
  },
  methods: {
    //点击一级分类后的回调
    handleSelectOneLevel(value) {
      this.currentSort.levelOne = value;
      for (var i = 0; i < this.OneLevelOption.length; i++) {
        //每个一级分类
        var oneSubject = this.OneLevelOption[i]
        //判断：所有一级分类id和点击一级分类id是否一样
        if (value === oneSubject.title) {  //===即比较值 还要比较类型
          //从一级分类中获取所有的二级分类
          this.TwoLevelOption = oneSubject.children
          //把二级分类Id值清空
          this.currentSort.levelTwo = ''
        }
      }
    },
    //点击二级
    handleSelectTwoLevel(value) {
      this.currentSort.levelTwo = value;
    },
  },
}
