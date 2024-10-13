import {listCarApply} from "../../../../api/system/carApply";

export var mixin_car_apply = {
  data: function () {
    return {
      indexCarApplyVisible: false,
      carApplyList: []
    }
  },
  methods: {
    // 索引车辆使用信息
    indexCarApplyInfo() {
      listCarApply().then(res => {
        this.carApplyList = res.rows;
        this.indexCarApplyVisible = true;
      })
    },
    // 引用该车辆使用信息
    indexThisCarApplyInfo(row) {
      console.log(row)
    }
  }
}
