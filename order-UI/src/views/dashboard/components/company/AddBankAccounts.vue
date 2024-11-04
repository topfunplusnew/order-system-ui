<script>
import SearchOption from "../../../../components/SearchOption.vue";
import {listCompany} from "../../../../api/system/company";
import {excludeParams} from "../../../../api/tool/exclude";
import {addBankAccount,} from "../../../../api/system/bankAccount";
import {listCars} from "../../../../api/system/cars";

export default {
  name: "AddBankAccounts",
  components: {SearchOption},
  props: {
    companyType: {
      type: String,
      default: '客户'
    },
    // 需要companyName companyId
    companyInfo: {
      type: Object,
      required: true,
      default() {
        return {}
      }
    }
  },
  computed: {
    computedCompanyInfo() {
      return this.companyInfo
    }
  },
  // watch: {
  //   // 监听传入的公司信息 自动将账户类型和id赋值
  //   'companyInfo': {
  //     handler(val) {
  //       this.form.acountsType = val.companyType;
  //       this.form.companyID = val.id;
  //     },
  //     deep: true,
  //     immediate: true
  //   }
  // },
  data() {
    return {
      dialogVisible: false,
      // 搜索字段
      queryCompany: '',
      queryCompanyGive: '',
      queryCarsBank: '',
      title: '',
      options: [
        {
          value: '己方公司',
          label: '己方公司'
        }, {
          value: '客户',
          label: '客户'
        }, {
          value: '供应商',
          label: '供应商'
        }, {
          value: '司机',
          label: '司机'
        }, {
          value: '其它',
          label: '其它'
        }
      ],
      form: {},
      // 表单校验
      rules: {
        bankNo: [
          {required: true, message: "银行账号不能为空", trigger: "blur"}
        ],
        bankName: [
          {required: true, message: "开户行不能为空", trigger: "blur"}
        ],
        acountsName: [
          {required: true, message: "账户名称不能为空", trigger: "blur"}
        ],
        acountsType: [
          {required: true, message: "账户类型不能为空", trigger: "blur"}
        ],
        companyName: [
          {required: true, message: "公司名称不能为空", trigger: "blur"}
        ],
        companyType: [
          {required: true, message: "公司类型不能为空", trigger: "blur"}
        ],
      },
    }
  },
  methods: {
    listCars,
    listCompany,
    // 添加银行卡信息 这里需要选择客户或者供应商进行绑定
    handleAddBankAccount() {
      this.reset()
      // 填充公司信息 公司类型和id
      this.form.acountsType = this.computedCompanyInfo.companyType;
      this.form.companyId = this.computedCompanyInfo.id;
      this.form.companyName = this.computedCompanyInfo.companyName;
      // 打开弹窗
      this.dialogVisible = true
    },
    // //搜索供应商信息的回调 用于填充表单中关于供应商的某些信息
    // handleCommitBackCompanyGive(val) {
    //   this.form.companyName = val.companyName;
    //   this.form.companyId = val.id;
    // },
    // 搜索客户信息的回调 用于填充表单中关于客户的某些信息
    // handleCommitBackCompany(val) {
    //   this.form.companyName = val.companyName;
    //   this.form.companyId = val.id;
    // },
    // // 搜索字段的自动填充
    // handleQueryCompanyGive(value) {
    //   this.queryCompanyGive = value;
    // },
    // handleQueryCompany(value) {
    //   this.queryCompany = value;
    // },
    // // 搜索司机信息的回调 用于填充表单中关于司机的某些信息
    // handleCommitBackBankAccount(val) {
    //   this.form.acountsName = val.acountsName;
    //   this.form.companyId = val.id;
    // },
    // handleUpdateBankAccount(val) {
    //   this.queryBankAccount = val;
    // },
    // 取消按钮
    cancel() {
      this.dialogVisible = false;
      this.reset();
    },
    reset() {
      this.form = {
        id: null,
        companyName: null,
        companyId: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        acountsType: null,
        amount: null,
        comments: null,
        delFlag: null
      };
      this.resetForm("form");
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form = excludeParams(this.form, this.$exclude)
          addBankAccount(this.form).then(response => {
            this.$modal.msgSuccess("新增成功");
            this.dialogVisible = false;
            this.$emit('callGetList')
          });
        }
      });
    },
  }
}
</script>

<template>
  <div>
    <!--      新增银行卡信息-->
    <div class="add-bank-account">
      <el-button
        type="text"
        size="mini"
        @click="handleAddBankAccount"
        v-hasPermi="['system:company:add']"
      >新增银行卡信息
      </el-button>
    </div>


    <el-dialog
      title="提示"
      :visible.sync="dialogVisible"
      width="30%" append-to-body>
      <div>
        <el-form ref="form" :model="form" :rules="rules" label-width="120px">
          <el-form-item label="账号类型" prop="acountsType">
            <el-select v-model="form.acountsType" placeholder="请选择账号类型">
              <el-option
                v-for="item in options"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="户名" prop="acountsName">
            <!--          如果是司机 那么就选择-->
            <el-row v-if="form.acountsType ==='司机'">
              <el-col :span="20">
                <el-input v-model="form.acountsName" placeholder="请输入户名"/>
              </el-col>
              <!--              <el-col :span="4">-->
              <!--                <el-tooltip content="选择已经添加过的账户" placement="top">-->
              <!--                  <SearchOption :limit-info="{}"-->
              <!--                                :get-data="listCars" query-info="carNo"-->
              <!--                                query-label="车牌查找" :query-name="queryCarsBank"-->
              <!--                                @update:queryName="handleUpdateBankAccount" @commitBack="handleCommitBackBankAccount">-->
              <!--                    <template #table-columns>-->
              <!--                      <el-table-column label="司机" align="center"-->
              <!--                                       prop="driver"/>-->
              <!--                      <el-table-column label="车牌号" align="center" prop="carNo"/>-->
              <!--                      <el-table-column label="司机电话" align="center" prop="tel"/>-->
              <!--                      <el-table-column label="开户名" align="center" prop="acountsName"/>-->
              <!--                      <el-table-column label="账号" align="center" prop="bankNo"/>-->
              <!--                      <el-table-column label="开户行" align="center" prop="bankName"/>-->
              <!--                      <el-table-column label="运输方式" align="center" prop="carType"/>-->
              <!--                    </template>-->
              <!--                  </SearchOption>-->
              <!--                </el-tooltip>-->
              <!--              </el-col>-->
            </el-row>
            <el-row v-else>
              <el-input v-model="form.acountsName" placeholder="请输入户名"/>
            </el-row>
          </el-form-item>
          <el-form-item label="公司名称" prop="companyName">
            <el-row>
              <el-col :span="10">
                <el-input v-model="form.companyName" placeholder="请输入公司名称"/>
              </el-col>
              <!--              &lt;!&ndash; 供应商信息搜索&ndash;&gt;-->
              <!--              <el-col :span="2" v-if="form.acountsType === '供应商'">-->
              <!--                <SearchOption :limit-info="{companyType:'供应商'}" :get-data="listCompany" query-label="名称查找"-->
              <!--                              :query-name="queryCompanyGive" query-info="companyName"-->
              <!--                              @commitBack="handleCommitBackCompanyGive" @update:queryName="handleQueryCompanyGive">-->
              <!--                  <template #table-columns>-->
              <!--                    <el-table-column label="供应商" align="center" prop="companyName"/>-->
              <!--                    <el-table-column label="地址" align="center" prop="address"/>-->
              <!--                  </template>-->
              <!--                </SearchOption>-->
              <!--              </el-col>-->
              <!--              &lt;!&ndash; 客户信息搜索&ndash;&gt;-->
              <!--              <el-col :span="2" v-if="form.acountsType === '客户'">-->
              <!--                <SearchOption :limit-info="{companyType:'客户'}" :get-data="listCompany"-->
              <!--                              :query-name="queryCompany" query-info="companyName" query-label="名称查找"-->
              <!--                              @commitBack="handleCommitBackCompany" @update:queryName="handleQueryCompany">-->
              <!--                  <template #table-columns>-->
              <!--                    <el-table-column label="客户" align="center" prop="relationName"/>-->
              <!--                    <el-table-column label="老板姓名" align="center" prop="leader"/>-->
              <!--                    <el-table-column label="老板电话" align="center" prop="leaderTel"/>-->
              <!--                    <el-table-column label="公司名称" align="center" prop="companyName"/>-->
              <!--                    <el-table-column label="销售经理" align="center" prop="salesManager"/>-->
              <!--                  </template>-->
              <!--                </SearchOption>-->
              <!--              </el-col>-->
            </el-row>
          </el-form-item>
          <el-form-item label="银行账号" prop="bankNo">
            <el-input v-model="form.bankNo" placeholder="请输入银行账号"/>
          </el-form-item>
          <el-form-item label="开户行" prop="bankName">
            <el-input v-model="form.bankName" placeholder="请输入开户行"/>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer" style="text-align: center">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.add-bank-account {
  text-align: center;
}
</style>
