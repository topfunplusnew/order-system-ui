import { getToken } from '../../../../utils/auth';
import { getBusinessTrip } from '../../../../api/system/BusinessTrip';
import { addOilCardConsume } from '../../../../api/system/OilCardConsume';
import { checkOilCard } from '../../../../api/system/oilCard';
import { mapGetters } from 'vuex';

export var mixin_businesstrip_car_apply = {
  data: function () {
    return {
      oilCardConsumeVisible: false,
      queryCars: '',
      queryCarNumber: '',
      oilCardConsumeInfo: {
        oilCardNo: '',
        carNo: '',
        // 附件路径
        attachmentOiladd: '',
        // 充值金额 默认为0
        rechargeMoney: '0'
      },
      queryOilCard: '',
      // 文件上传
      baseUrl: process.env.VUE_APP_BASE_API,
      uploadFileUrl: process.env.VUE_APP_BASE_API + '/common/upload', // 上传文件服务器地址
      headers: {
        Authorization: 'Bearer ' + getToken(),
      },
      isRecharge: '',
    }
  },
  computed: {
    ...mapGetters(['trueName'])
  },
  methods: {
    handleFileUploadCarApply(url) {
      this.form.path = url
    },
    // 打开油卡消费记录的弹窗
    openOilCardOpen(e) {
      this.resetOilCardConsumeInfo();
      this.oilCardConsumeVisible = true
    },
    updateQueryCars(val) {
      this.queryCars = val;
    },
    handleCommitBackCars(val) {
      this.form.carNo = val.dictLabel
    },
    handleCommitBackOilCard(val) {
      this.oilCardConsumeInfo.oilCardNo = val.oilCardNo;
    },
    handleCommitBackQueryOilCard(val) {
      this.queryOilCard = val
    },
    // 公司车辆
    handleCommitCarNumber(val) {
      this.oilCardConsumeInfo.carNo = val.dictLabel
    },
    handleCommitBackQueryCarNumber(val) {
      this.queryCarNumber = val;
    },
    // 文件上传
    handleFileSuccess(response, file, fileList) {
      if (response.code === 200) {
        this.oilCardConsumeInfo.attachmentOiladd = response.url
        console.log(this.oilCardConsumeInfo.attachmentOiladd)
        this.$message.success('上传成功')
      } else {
        this.$message.error('上传失败')
      }
      fileList.pop();
    },
    // 查看附件
    checkPath(path) {
      window.open(path)
    },
    // 添加油卡消费信息
    submitOilCard() {
      this.form.isUseOilCard = '1';
      // 要检查油卡的余额是否够用 如果够用就保存数据 如果不够用 那么就要提示是否充值  如果充值 就要弹出充值页面
      checkOilCard({
        oilCardNo: this.oilCardConsumeInfo.oilCardNo,
        consumeAmount: this.oilCardConsumeInfo.refuelingMoney
      }).then(res => {
        // 如果余额不足 要进行充值
        if (res.data.error === '油卡余额不足') {
          this.$confirm('油卡余额不足,是否充值?', '提示', {
            confirmButtonText: '是', cancelButtonText: '否', type: 'warning'
          }).then(() => {
            this.oilCardDialogVisible = true
            this.moneyInfo.rechargeName = this.trueName;
          })
          // 如果油卡信息不存在
        } else if (res.data.error === '油卡不存在') {
          this.$message.error('油卡不存在')
          // 如果存在并且余额充足
        } else {
          // 先从session拿出出差信息ID 判断是否存在
          const businessTripID = JSON.parse(sessionStorage.getItem('BusinessTrip-ID'))
          getBusinessTrip(businessTripID)
            .then(res => {
              if (res.data === undefined || res.data === {} || res.data === null) {
                this.$message.error('出差信息为空!请先添加出差信息')
              } else {
                // 纠正money
                this.oilCardConsumeInfo.rechargeMoney = this.isRecharge === '2' ? '0' : this.oilCardConsumeInfo.rechargeMoney
                // 添加油卡消费信息
                addOilCardConsume({ ...this.oilCardConsumeInfo, bTripId: businessTripID, }).then(res => {
                  this.$message.success('保存成功~')
                  setTimeout(() => {
                    // 回写充值账户信息到报销项中
                    if (this.form.isUseOilCard === '1') {
                      // 还要进一步判断 如果充值金额大于0 就要添加到报销项中
                      if (this.oilCardConsumeInfo.rechargeMoney > 0) {
                        this.tripReimbursementList.push({
                          index: this.tripReimbursementList.length + 1,
                          item: '加油卡现金充值金额',
                          itemCost: this.oilCardConsumeInfo.rechargeMoney,
                          isDisabled: true // 不可更改
                        })
                        this.$message.success('填写保存成功,相关费用已罗列')
                      } else {
                        this.$message.success('填写保存成功 充值金额为' + this.oilCardConsumeInfo.rechargeMoney + '元')
                      }
                    }
                  }, 100)
                  // 关闭油卡消费添加弹窗
                  this.oilCardConsumeVisible = false
                })
              }
            })
        }
      })
    },
    clearOilCard() {
      this.oilCardConsumeVisible = false;
      this.oilCardConsumeInfo = {}
      this.form.isUseOilCard = '0';
      this.$message.success('已清除')
    },
    resetOilCardConsumeInfo() {
      this.oilCardConsumeInfo = {
        oilCardNo: '', // 加油卡卡号
        useDate: '', // 使用加油卡时间
        carNo: '', // 车辆车牌号
        startCardSurplus: '', // 期初余额
        rechargeMoney: '', // 充值金额
        refuelingNumber: '', // 加油量
        unitPrice: '', // 单价
        refuelingMoney: '', // 加油金额
        attachmentOiladd: '', // 加油小票附件路径
        comments: '', // 备注
      };
    },
  },
}
