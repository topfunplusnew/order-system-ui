import {listSubject} from "../../../../api/system/subject";
import {listBankAccount} from "../../../../api/system/bankAccount";
import {TableName} from "../../../../api/tool/enums";

export var mixin_payment_apply = {
  data: function () {
    return {
      options: [{
        value: '客户',
        label: '客户'
      }, {
        value: '供应商',
        label: '供应商'
      }, {
        value: '司机',
        label: '司机'
      }],
      value: '客户'
    }
  },
  created() {
    // 查询科目信息
    listSubject().then(res => {
      this.subjectTree = this.handleTree(res.data, "id", "parentId");
      this.OneLevelOption = this.subjectTree;
    })
    // 检查
    this.checkPropsInfo()
  },
  methods: {
    // 检查传入的信息
    checkPropsInfo() {
      // 根据表名填充公司类型
      this.fillCompanyType()
      // 填充金额
      this.fillMoney()
      // 填充银行卡信息
      this.fillBankInfo()
    },
    // 根据表名填充公司类型
    fillCompanyType() {
      // 根据传入的表名来赋值公司类型
      if (this.tableName === TableName.OIL_RECHARGE) {
        this.form.companyType = '其他'
      }
      if (this.tableName === TableName.REPAYMENT) {
        this.form.companyType = '其他'
      }
      // 如果是运费申请公司类型为司机
      if (this.tableName === TableName.ORDER_FREIGHT) {
        this.form.companyType = '司机'
        this.value = '司机'
      }
    },
    // 填充运费信息
    fillFreightInfo() {
      //需要司机信息
      if (this.needInfo.isExit !== undefined) {
        if (this.needInfo.isExit === true) {
          //自动填充
          this.form.otherAcountsName = this.needInfo.otherAcountsName
          this.form.companyName = this.needInfo.companyName
          //查询司机的银行卡信息
          listBankAccount({acountsType: '司机', acountsName: this.needInfo.otherAcountsName})
            .then(res => {
              this.form.otherBankNo = res.rows[0].bankNo
              this.form.otherBankName = res.rows[0].bankName
            })
        }
      }
    },
    // 填充银行卡数据
    fillBankInfo() {
      // 如果传入的不是空数据
      if (JSON.stringify(this.needInfo) !== '{}') {
        this.fillFreightInfo()
        // 如果有银行卡信息自动填充
        listBankAccount({
          bankNo: this.needInfo.bankNo,
          bankName: this.needInfo.bankName,
          acountsName: this.needInfo.acountsName
        })
          .then(res => {
            if (res.rows.length === 0) {
              this.$message.error('未查询到该银行卡信息')
            } else {
              this.form.otherAcountsName = res.rows[0].acountsName
              this.form.otherBankNo = res.rows[0].bankNo
              this.form.otherBankName = res.rows[0].bankName
            }
          })
      }
    },
    // 填充金额
    fillMoney() {
      console.log('填充金额', this.needMoney)
      // 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
      if (this.needMoney >= 0) {
        this.form.moneyAmount = this.needMoney;
        if (this.needMoney != 0) {
          this.inputDisabled = true;
        }
      }
    },

  },
}
