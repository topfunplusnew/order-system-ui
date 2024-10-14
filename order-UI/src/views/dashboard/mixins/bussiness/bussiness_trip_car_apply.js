// 出差的车辆申请模块
export var mixin_business_trip_car_apply = {
  data: function () {
    return {
      //是否使用车辆 默认为否
      useCar: '否',
      carApplyForm: {
        carNo: '',
        isMaintenance:
          '',
        isReimburse:
          '',
      },
      //车辆查询
      queryCars: '',
      carApplyVisible: false,
    }
  },
  computed: {},
  methods: {
    // 提交成功关闭
    closeAll() {
      this.active = 0;
      this.open = false
    },
  }
}
