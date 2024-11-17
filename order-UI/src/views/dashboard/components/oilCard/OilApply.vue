<script>
import SearchOption from "@/components/SearchOption.vue";
import {listSubject} from "@/api/system/subject";
import {listBankAccount} from "@/api/system/bankAccount";
import {addPaymentApply, listPaymentApply} from "@/api/system/paymentApply";
import {excludeParams} from "@/api/tool/exclude";
import {TableName} from "@/api/tool/enums";

export default {
  name: "OilApply",
  components: {SearchOption},
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
  data() {
    return {
      // 遮罩层
      loading: true,
      // 表单参数
      form: {
        tID: null,
        tableName: null,
        fundsDate: null,
        payType: null,
        moneyAmount: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        companyName: null,
        companyId: null,
        companyType: null,
        reason: null,
        attachment: null,
        applyPerson: null,
        applyPersonID: null,
        checkState: null,
        comments: null,
      },
      // 表单校验
      rules: {
        fundsDate: [
          {required: true, message: "付款日期不能为空", trigger: "blur"},
        ],
        moneyAmount: [
          {required: true, message: "付款金额不能为空", trigger: "blur"}],
        reason: [
          {required: true, message: "付款事由不能为空", trigger: "blur"}],
      },
      //禁用输入框
      inputDisabled: false,
      //禁用银行卡输入 因为现金支付不需要银行卡信息
      bankInputDisabled: false,
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
      paymentTypeOptions: [],
    }
  },
  computed: {
    fullLevel() {
      return this.currentSort.levelOne + '-' + this.currentSort.levelTwo;
    },
  },
  created() {
    // 查询科目信息
    listSubject().then(res => {
      this.subjectTree = this.handleTree(res.data, "id", "parentId");
      this.OneLevelOption = this.subjectTree;
    })
    // 填充金额
    this.fillMoney()

    // 填充表信息
    if (this.tableName === TableName.OIL_RECHARGE) {
      this.form.companyType = '其他'
    }
  },
  watch: {
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
    listBankAccount,
    //上传的回调函数
    handleCommitUpload(val) {
      this.form.attachment = val;
    },
    // 填充金额
    fillMoney() {
      // 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
      if (this.needMoney >= 0) {
        this.form.moneyAmount = this.needMoney;
        if (this.needMoney != 0) {
          this.inputDisabled = true;
        }
      }
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        tableName: null,
        tID: null,
        fundsDate: null,
        payType: null,
        moneyAmount: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        companyName: null,
        companyId: null,
        companyType: null,
        reason: null,
        attachment: null,
        applyPerson: null,
        applyPersonID: null,
        checkState: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null,
        submitflag: null
      };
      this.currentSort = {
        levelOne: '',
        levelTwo: ''
      }
      this.resetForm("form");
    },

    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          excludeParams(this, this.$exclude)
          this.form.tableName = this.tableName;
          this.form.tID = this.tID;
          this.form.payType = this.fullLevel;
          this.form.checkState = '' //审核状态赋空
          addPaymentApply(this.form).then(response => {
            this.$modal.msgSuccess("付款申请添加成功");
            this.reset()
            this.$emit('changeOpen')
          })
        }
      });
    },
    close() {
      this.$emit('changeOpen')
      this.reset()
    }
  }
}
</script>

<template>
  <div>
    <div class="app-container">
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="日期" prop="fundsDate">
          <el-date-picker
            v-model="form.fundsDate"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="选择日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="支付类型" prop="payType">
          <el-row :gutter="5">
            <!--            一级分类-->
            <el-col :span="8">
              <el-select v-model="currentSort.levelOne" placeholder="请选择一级分类" @change="handleSelectOneLevel">
                <el-option
                  v-for="item in OneLevelOption"
                  :key="item.id"
                  :label="item.title"
                  :value="item.title">
                </el-option>
              </el-select>
            </el-col>
            <!--            二级分类-->
            <el-col :span="8">
              <el-select v-model="currentSort.levelTwo" placeholder="请选择二级分类" @change="handleSelectTwoLevel">
                <el-option
                  v-for="item in TwoLevelOption"
                  :key="item.id"
                  :label="item.title"
                  :value="item.title">
                </el-option>
              </el-select>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额" :disabled="inputDisabled"/>
        </el-form-item>
        <el-form-item label="付款原因" prop="reason">
          <el-input v-model="form.reason" type="textarea" placeholder="请输入内容"/>
        </el-form-item>
        <el-form-item label="附件" prop="attachment">
          <file-upload @input="handleCommitUpload"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer" style="text-align: center">
        <el-button type="primary" @click="submitForm">提交申请</el-button>
        <el-button @click="close">关闭</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
