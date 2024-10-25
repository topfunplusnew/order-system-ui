import {listBankAccount} from "../../../../api/system/bankAccount";

export var mixin_payment_watcher = {
  data: function () {
    return {}
  },
  props: {
    // 关联表名
    tableName: '',
    // 关联表的主键ID
    tID: '',
    //需要自动填充的钱
    needMoney: {
      type: Number
    },
    //需要自动填充的信息 包含 对方户名:acountsName 对方账号 bankNo 对方开户行 bankName 对方公司 companyName
    needInfo: {
      type: Object
    }
  },
  watch: {
    // 监听银行卡的变化 如果传入的银行卡信息有变化 就自动填充
    'needInfo.bankNo': {
      handler(val) {
        if (val === undefined) {
          console.log('val为undefined')
          return
        }
        listBankAccount({
          bankNo: this.needInfo.bankNo,
          bankName: this.needInfo.bankName,
          acountsName: this.needInfo.acountsName
        })
          .then(res => {
            if (res.rows.length === 0) {
              this.$message.error('未查询到该银行卡信息')
              this.form.otherAcountsName = ''
              this.form.otherBankNo = ''
              this.form.otherBankName = ''
            } else {
              this.form.otherAcountsName = res.rows[0].acountsName
              this.form.otherBankNo = res.rows[0].bankNo
              this.form.otherBankName = res.rows[0].bankName
            }
          })
      },
      deep: true
    },
    // 检测整个对象
    needInfo: {
      handler(val) {
        if (JSON.stringify(this.needInfo) !== '{}') {
          this.fillFreightInfo()
        }
      },
      deep: true
    },
    // 监听传入的金额
    needMoney: {
      handler(val) {
        // 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
        if (this.needMoney >= 0) {
          this.form.moneyAmount = this.needMoney;
          this.inputDisabled = true;
        }
      },
      deep: true,
      immediate: true
    },
    // 监听表的变化
    tableName: {
      handler(val) {
        if (val === 'oilrecharge') {
          this.form.companyType = '其他'
        }
        if (val === 'repayment') {
          this.form.companyType = '其他'
        }
        if (val === 'orderfreight') {
          this.form.companyType = '司机'
        }
      }
    }
  },
  methods: {},
}
