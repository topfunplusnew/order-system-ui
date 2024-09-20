<!--付款申请弹窗-->
<template>
  <div class="app-container">
    <el-form ref="form" :model="form" :rules="rules" label-width="120px">
      <el-form-item label="日期" prop="fundsDate">
        <el-date-picker
          v-model="form.fundsDate"
          type="date"
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
      <el-form-item label="对方户名" prop="otherAcountsName">
        <el-row>
          <el-col :span="10">
            <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名" :disabled="bankInputDisabled"/>
          </el-col>
          <el-col :span="3" v-if="bankInputDisabled === false">
            <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBack"
                          :limit-info="{}" query-label="户名查找" query-info="acountsName"
                          :query-name="queryCompany"
                          @update:queryName="handleUpdateQueryName">
              <template #table-columns>
                <el-table-column label="公司名称" align="center" prop="companyName"/>
                <el-table-column label="公司类型" align="center" prop="companyType"/>
                <el-table-column label="开户行" align="center" prop="bankName"/>
                <el-table-column label="开户名" align="center" prop="acountsName"/>
                <el-table-column label="账号" align="center" prop="bankNo"/>
              </template>
            </SearchOption>
          </el-col>
        </el-row>
      </el-form-item>
      <el-form-item label="对方账号" prop="otherBankNo">
        <el-input v-model="form.otherBankNo" placeholder="请输入对方账号" :disabled="bankInputDisabled"/>
      </el-form-item>
      <el-form-item label="对方开户行" prop="otherBankName">
        <el-input v-model="form.otherBankName" placeholder="请输入对方开户行" :disabled="bankInputDisabled"/>
      </el-form-item>
      <el-form-item label="对方公司" prop="companyName">
        <el-input v-model="form.companyName" placeholder="请输入对方公司"/>
      </el-form-item>
      <el-form-item label="付款原因" prop="reason">
        <el-input v-model="form.reason" type="textarea" placeholder="请输入内容"/>
      </el-form-item>
      <!--        文件-->
      <el-form-item label="附件" prop="attachment">
        <file-upload @input="handleCommitUpload"/>
      </el-form-item>
      <el-form-item label="备注" prop="comments">
        <el-input v-model="form.comments" placeholder="请输入备注"/>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer" style="text-align: center">
      <el-button type="primary" @click="submitForm">确 定</el-button>
    </div>
  </div>
</template>

<script>
import {
  listPaymentApply,
  getPaymentApply,
  delPaymentApply,
  addPaymentApply,
  updatePaymentApply
} from "@/api/system/paymentApply";
import {excludeParams} from "@/api/tool/exclude";
import {listSubject} from "@/api/system/subject";
import {formatDate} from "@/utils";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";
import {mapGetters} from "vuex";
import {listBankAccount} from "@/api/system/bankAccount";

export default {
  name: "ApplyPayment",
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
    //需要自动填充的信息
    // 包含 对方户名:acountsName 对方账号 bankNo 对方开户行 bankName 对方公司 companyName
    needInfo: {
      type: Object
    }
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 总条数
      total: 0,
      // 付款信息表格数据
      paymentApplyList: [],
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
        companyName: [
          {required: true, message: "公司名称不能为空", trigger: "blur"}],
        reason: [
          {required: true, message: "付款事由不能为空", trigger: "blur"}],
      },
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
      // 对方户名
      queryCompany: '',
      //禁用输入框
      inputDisabled: false,
      //禁用银行卡输入 因为现金支付不需要银行卡信息
      bankInputDisabled: false,
    };
  },
  created() {
    // 查询科目信息
    listSubject().then(res => {
      this.subjectTree = this.handleTree(res.data, "id", "parentId");
      this.OneLevelOption = this.subjectTree;
    })

    //如果是油卡充值 要自动填写公司类型为其他
    if (this.tableName === 'oilrecharge') {
      this.form.companyType = '其他'
    }
    // 如果是运费申请公司类型为司机
    if (this.tableName === 'orderfreight') {
      this.form.companyType = '司机'
    }

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

    // 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
    if (this.needMoney > 0) {
      this.form.moneyAmount = this.needMoney;
      this.inputDisabled = true;
    }
    // 如果没有传入的数据
    if (JSON.stringify(this.needInfo) === '{}') {
      this.$message.success('无自动填充信息')
    } else {
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
    }
  },
  mounted() {

  },
  computed: {
    fullLevel() {
      return this.currentSort.levelOne + '-' + this.currentSort.levelTwo;
    },
  },
  watch: {
    // 监听银行卡的变化
    'needInfo.bankNo': {
      handler(val) {
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
      },
      deep: true
    },
    needInfo: {
      handler(val) {
        if (JSON.stringify(this.needInfo) === '{}') {
          this.$message.success('无自动填充信息')
        } else {
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
        }
      },
      deep: true // 因为父组件如果是解构赋值 那么就监听不到 需要深层监听
    },
    needMoney: {
      handler() {
        // 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
        if (this.needMoney > 0) {
          this.form.moneyAmount = this.needMoney;
          this.inputDisabled = true;
        }
      }
    }
  },
  methods: {
    listBankAccount,
    listCompany,
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

    //对方信息 - 点击确认后自动填充
    handleCommitBack(val) {
      this.form.otherBankNo = val.bankNo;
      this.form.otherBankName = val.bankName;
      this.form.companyName = val.companyName;
      this.form.companyId = val.id;
      this.form.otherAcountsName = val.acountsName;
      this.form.companyType = val.companyType
    },
    //上传的回调函数
    handleCommitUpload(val) {
      this.form.attachment = val;
    },

    //update
    handleUpdateQueryName(val) {
      this.queryCompany = val;
    },
    getList() {
      this.loading = true;
      listPaymentApply(this.queryParams).then(response => {
        this.paymentApplyList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.reset();
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
      this.resetForm("form");
    },

    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            //排除不必要字段
            excludeParams(this, this.$exclude)
            this.form.tableName = this.tableName;
            this.form.tID = this.tID;
            updatePaymentApply(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.getList();
            })
          } else {
            excludeParams(this, this.$exclude)
            this.form.tableName = this.tableName;
            this.form.tID = this.tID;
            this.form.payType = this.fullLevel;
            //审核状态赋空
            this.form.checkState = ''
            console.log('提交的付款表单', this.form)
            addPaymentApply(this.form).then(response => {
              this.$modal.msgSuccess("付款申请添加成功");
              this.$emit('changeOpen')
              this.getList();
            })
          }
        }
      });
    },
  }
};
</script>
