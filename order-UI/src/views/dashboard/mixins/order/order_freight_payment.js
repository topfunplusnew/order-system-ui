// 运费一键申请
import {parseTime} from "../../../../utils/ruoyi";
import {TableName} from "../../../../api/tool/enums";
import {batchPayment} from "../../../../api/system/payment";

export var mixin_order_freight_payment = {
  data: function () {
    return {
      freightOnceVisible: false,
      // 己方银行卡信息
      freightSelfOnceInfo: {},
      bankQuery: '',
      selectedList: [],
      // 折叠面板的list
      activeNames: ['0'],
      batchPaymentList: [],
      total_freight: 0
    }
  },
  computed: {
    freightPaymentOnceDisabled() {
      return this.ids.length <= 0;
    }
  },
  methods: {
    // 勾选未支付 todo
    selectUnPayment(rows) {
      let flag = false;
      if (rows) {
        rows.forEach(row => {
          if (row.paymentState === '未支付') {
            this.$refs.multipleTable.toggleRowSelection(row);
            flag = true
          }
        })
        if (!flag) {
          this.$message.warning('当前没有未支付付款信息')
        }
      } else {
        this.$refs.multipleTable.clearSelection();
      }
    },
    // 一键申请运费
    handleFreightPaymentOnce(row) {
      this.selectedList.forEach(item => {
        item = this.convertOrderFreightToPayment(item)
        this.batchPaymentList.push(item)
      })
      // 计算总和
      for (let i = 0; i < this.batchPaymentList.length; i++) {
        this.total_freight += Number(this.batchPaymentList[i].moneyAmount)
      }
      this.resetFreightSelfOnceInfo();
      this.freightOnceVisible = true;
    },
    // 将orderFreight对象转换为Payment对象
    convertOrderFreightToPayment(orderFreight) {
      return {
        // 构建对方信息
        fundsDate: parseTime(new Date()),
        tableName: TableName.ORDER_FREIGHT,
        tID: orderFreight.id,
        moneyAmount: orderFreight.moneyAmount,
        otherAcountsName: orderFreight.otherAcountsName,
        otherBankNo: orderFreight.otherBankNo,
        otherBankName: orderFreight.otherBankName,
        companyName: '司机',
        companyId: orderFreight.driverId,
        companyType: "司机",
        comments: orderFreight.content,
        // 这两个是附件
        transactionHistory: "TH001",
        transactionHistoryAttachment: "attachment001.pdf",
      }
    },
    // 自动填充己方信息
    handleCallBack(val) {
      this.freightSelfOnceInfo.selfAcountsName = val.acountsName
      this.freightSelfOnceInfo.selfBankNo = val.bankNo
      this.freightSelfOnceInfo.selfBankName = val.bankName
    },
    // 一键付运费
    submitFreightOnce() {
      // 填充己方信息
      this.batchPaymentList.forEach(item => {
        Object.assign(item, {
          ...this.freightSelfOnceInfo,
          payType: this.freightSelfOnceInfo.payType.join('-')
        })
      })
      // 批量添加付款信息
      batchPayment(this.batchPaymentList).then(res => {
        this.$message.success('一键运费付款成功')
        this.resetFreightSelfOnceInfo();
        this.freightOnceVisible = false;
        this.getList()
      })
    },
    // 填充查询信息
    handleCommitBackBank(val) {
      this.bankQuery = val;
    },
    // 重置
    resetFreightSelfOnceInfo() {
      this.freightSelfOnceInfo = {
        selfAcountsName: '',
        selfBankNo: '',
        selfBankName: ''
      }
    }
  },
}
