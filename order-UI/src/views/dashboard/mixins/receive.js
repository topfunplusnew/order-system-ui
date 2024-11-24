// 混入 收款的相关自动填充逻辑
import { addReceiveMoney } from '../../../api/system/receiveMoney';

export var mixin_reviveMoney = {
  data: function () {
    return {
      fundsDate: '',
      // 表的信息
      tID: '',
      receiveType: '',
      tableName: '',
      // 收款账款信息
      moneyAmount: '',
      // 己方银行信息 需要银行ID
      selfAcountsName: '',
      selfBankNo: '',
      selfBankName: '',
      selfBankID: '',
      // 对方银行信息
      otherAcountsName: '',
      otherBankNo: '',
      otherBankName: '',
      // 公司名称 公司id 公司类型
      companyName: '',
      companyId: '',
      companyType: '',
      comments: '',
    }
  },
  methods: {
    // 初始化表的信息
    initReviveMoneyTableInfo(tID, receiveType, tableName) {
      this.tID = tID;
      this.receiveType = receiveType;
      this.tableName = tableName;
    },
    // 初始化我方银行卡信息
    initReviveMoneySelfAccountInfo(selfAcountsName, selfBankNo, selfBankName, selfBankID) {
      this.selfAcountsName = selfAcountsName;
      this.selfBankNo = selfBankNo;
      this.selfBankName = selfBankName;
      this.selfBankID = selfBankID;
    },
    // 初始化对方账户信息
    initReviveMoneyOtherAccountInfo(otherAcountsName, otherBankNo, otherBankName) {
      this.otherAcountsName = otherAcountsName;
      this.otherBankNo = otherBankNo;
      this.otherBankName = otherBankName;
    },
    // 初始化时间
    initReceiveTime(time) {
      this.fundsDate = time;
    },
    // 初始化公司信息
    initReviveMoneyCompanyInfo(companyName, companyId, companyType) {
      this.companyName = companyName;
      this.companyId = companyId;
      this.companyType = companyType;
    },
    // 初始化备注信息
    initComment(comment) {
      this.comments = comment;
    },

    // 添加收款信息
    addReviveMoneyInfo() {
      // 组装实体对象
      const reviveMoneyInfo = {
        tID: this.tID,
        fundsDate: this.fundsDate,
        receiveType: this.receiveType,
        tableName: this.tableName,
        moneyAmount: this.moneyAmount,
        selfAcountsName: this.selfAcountsName,
        selfBankNo: this.selfBankNo,
        selfBankName: this.selfBankName,
        selfBankID: this.selfBankID,
        otherAcountsName: this.otherAcountsName,
        otherBankNo: this.otherBankNo,
        otherBankName: this.otherBankName,
        companyName: this.companyName,
        companyId: this.companyId,
        companyType: this.companyType,
        comments: this.comments,
      };
      console.log('收款信息：', reviveMoneyInfo)
      addReceiveMoney(reviveMoneyInfo).then(res => {
        this.$message.success('添加收款信息成功~')
      })
    },
    // 重置
    reset() {
      this.tID = ''
      this.receiveType = ''
      this.tableName = ''
      this.moneyAmount = ''
      this.selfAcountsName = ''
      this.selfBankNo = ''
      this.selfBankName = ''
      this.selfBankID = ''
      this.otherAcountsName = ''
      this.otherBankNo = ''
      this.otherBankName = ''
      this.companyName = ''
    }
  }

}
