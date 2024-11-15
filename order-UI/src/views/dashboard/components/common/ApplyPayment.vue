<!--付款申请弹窗-->
<template>
  <div class="app-container">
    <el-form ref="form" :model="form" :rules="rules" label-width="120px">
      <el-form-item label="日期" prop="fundsDate">
        <el-date-picker
          v-model="form.fundsDate"
          type="date"
          value-format="yyyy-MM-dd"
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
      <el-form-item label="对方类型(请确认)">
        <el-select v-model="value" placeholder="请选择">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
        <span style="color: #1c84c6;font-size: 12px">请注意选择正确的对方公司类型!</span>
      </el-form-item>

      <!--      公司的填充 这里主要是为了companyId 如果选择的是己方公司 那么就不显示这个选择公司-->
      <el-form-item label="对方公司" prop="companyName" v-if="value !== '员工'">
        <el-row>
          <el-col :span="14">
            <el-input v-model="form.companyName" placeholder="请输入对方公司"/>
          </el-col>
          <el-col :span="4">
            <SearchOption :limit-info="{companyType:value}" :get-data="listCompany"
                          icon="el-icon-search" @update:queryName="handleUpdateQueryNameOther"
                          :query-label="value" query-info="companyName" :query-name="queryOther"
                          @commitBack="handleCommitBackOther">
              <template #table-columns>
                <el-table-column :label="`${value}名称`" align="center" prop="companyName" width="180"
                                 show-overflow-tooltip/>
                <el-table-column label="老板姓名" align="center" prop="leader" width="180"
                                 show-overflow-tooltip/>
                <el-table-column label="老板电话" align="center" prop="leaderTel" width="180"
                                 show-overflow-tooltip/>
                <el-table-column label="区域" align="center" prop="region" width="180"
                                 show-overflow-tooltip/>
                <el-table-column label="联系人" align="center" prop="relationName" width="180"
                                 show-overflow-tooltip/>
                <el-table-column label="销售经理" align="center" prop="salesManager" width="180"
                                 show-overflow-tooltip/>
                <el-table-column label="地址" align="center" prop="address" width="150"
                                 show-overflow-tooltip/>
                <el-table-column label="电话" align="center" prop="relationTel" width="180"
                                 show-overflow-tooltip/>
              </template>
            </SearchOption>
          </el-col>
        </el-row>
      </el-form-item>

      <!--      如果value选择的是客户-->
      <el-row v-if="value === '客户'">
        <el-form-item label="对方账号(客户)" prop="otherBankNo">
          <el-row>
            <el-col :span="14">
              <el-input v-model="form.otherBankNo" placeholder="请输入对方账号" :disabled="bankInputDisabled"/>
            </el-col>
            <el-col :span="3" v-if="bankInputDisabled === false">
              <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBack"
                            :limit-info="{acountsType:'客户'}" query-label="银行卡查找" query-info="bankNo"
                            :query-name="queryCompany"
                            @update:queryName="handleUpdateQueryName">
                <template #table-columns>
                  <el-table-column label="公司名称" align="center" prop="companyName">
                    <template #default="scope">
                      {{ isNull(scope.row.companyName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户行" align="center" prop="bankName">
                    <template #default="scope">
                      {{ isNull(scope.row.bankName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户名" align="center" prop="acountsName">
                    <template #default="scope">
                      {{ isNull(scope.row.acountsName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="账号" align="center" prop="bankNo">
                    <template #default="scope">
                      {{ isNull(scope.row.bankNo) }}
                    </template>
                  </el-table-column>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="对方开户行" prop="otherBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入对方开户行" :disabled="bankInputDisabled"/>
        </el-form-item>
      </el-row>
      <!--      如果是供应商-->
      <el-row v-if="value==='供应商'">
        <el-form-item label="对方账号(供应商)" prop="otherBankNo">
          <el-row>
            <el-col :span="14">
              <el-input v-model="form.otherBankNo" placeholder="请输入对方账号" :disabled="bankInputDisabled"/>
            </el-col>
            <el-col :span="3" v-if="bankInputDisabled === false">
              <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBack"
                            :limit-info="{acountsType:'供应商'}" query-label="银行卡查找" query-info="bankNo"
                            :query-name="queryCompany"
                            @update:queryName="handleUpdateQueryName">
                <template #table-columns>
                  <el-table-column label="公司名称" align="center" prop="companyName">
                    <template #default="scope">
                      {{ isNull(scope.row.companyName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户行" align="center" prop="bankName">
                    <template #default="scope">
                      {{ isNull(scope.row.bankName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户名" align="center" prop="acountsName">
                    <template #default="scope">
                      {{ isNull(scope.row.acountsName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="账号" align="center" prop="bankNo">
                    <template #default="scope">
                      {{ isNull(scope.row.bankNo) }}
                    </template>
                  </el-table-column>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>

        <el-form-item label="对方开户行" prop="otherBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入对方开户行" :disabled="bankInputDisabled"/>
        </el-form-item>
      </el-row>
      <!--    如果是司机-->
      <el-row v-if="value==='司机'">
        <el-form-item label="对方账号(司机)" prop="otherBankNo">
          <el-row>
            <el-col :span="14">
              <el-input v-model="form.otherBankNo" placeholder="请输入对方账号" :disabled="bankInputDisabled"/>
            </el-col>
            <el-col :span="3" v-if="bankInputDisabled === false">
              <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBack"
                            :limit-info="{acountsType:'司机'}" query-label="银行卡查找" query-info="bankNo"
                            :query-name="queryCompany"
                            @update:queryName="handleUpdateQueryName">
                <template #table-columns>
                  <el-table-column label="司机名称" align="center" prop="companyName">
                    <template #default="scope">
                      {{ isNull(scope.row.companyName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户行" align="center" prop="bankName">
                    <template #default="scope">
                      {{ isNull(scope.row.bankName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户名" align="center" prop="acountsName">
                    <template #default="scope">
                      {{ isNull(scope.row.acountsName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="账号" align="center" prop="bankNo">
                    <template #default="scope">
                      {{ isNull(scope.row.bankNo) }}
                    </template>
                  </el-table-column>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="对方开户行" prop="otherBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入对方开户行" :disabled="bankInputDisabled"/>
        </el-form-item>
      </el-row>

      <!--     如果选择的是 员工 -->
      <el-row v-if="value==='员工'">
        <el-form-item label="对方账号(员工)" prop="otherBankNo">
          <el-row>
            <el-col :span="14">
              <el-input v-model="form.otherBankNo" placeholder="请输入对方账号" :disabled="bankInputDisabled"/>
            </el-col>
            <el-col :span="3" v-if="bankInputDisabled === false">
              <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBack"
                            :limit-info="{acountsType:'员工'}" query-label="银行卡查找" query-info="bankNo"
                            :query-name="queryCompany"
                            @update:queryName="handleUpdateQueryName">
                <template #table-columns>
                  <el-table-column label="员工名称" align="center" prop="companyName">
                    <template #default="scope">
                      {{ isNull(scope.row.companyName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户行" align="center" prop="bankName">
                    <template #default="scope">
                      {{ isNull(scope.row.bankName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="开户名" align="center" prop="acountsName">
                    <template #default="scope">
                      {{ isNull(scope.row.acountsName) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="账号" align="center" prop="bankNo">
                    <template #default="scope">
                      {{ isNull(scope.row.bankNo) }}
                    </template>
                  </el-table-column>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="对方开户行" prop="otherBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入对方开户行" :disabled="bankInputDisabled"/>
        </el-form-item>
      </el-row>


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
</template>

<script>
import {
  listPaymentApply,
  addPaymentApply,
} from "@/api/system/paymentApply";
import {excludeParams} from "@/api/tool/exclude";
import SearchOption from "@/components/SearchOption.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {mixin_payment_apply} from "../../mixins/apply_payment/payment_apply";
import {mixin_payment_level} from "../../mixins/apply_payment/payment_level";
import {mixin_payment_watcher} from "../../mixins/apply_payment/payment_watcher";

import {listCompany} from "../../../../api/system/company";
import {mixin_payment_fill} from "../../mixins/apply_payment/payment_fill";
import {isNull} from "../../../../main";

export default {
  name: "ApplyPayment",
  components: {SearchOption},
  mixins: [mixin_payment_apply, mixin_payment_level, mixin_payment_watcher, mixin_payment_fill],
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
        reason: [
          {required: true, message: "付款事由不能为空", trigger: "blur"}],
      },
      //禁用输入框
      inputDisabled: false,
      //禁用银行卡输入 因为现金支付不需要银行卡信息
      bankInputDisabled: false,
    };
  },

  methods: {
    isNull,
    listCompany,
    listBankAccount,
    //上传的回调函数
    handleCommitUpload(val) {
      this.form.attachment = val;
    },
    getList() {
      this.loading = true;
      listPaymentApply(this.queryParams).then(response => {
        this.paymentApplyList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          excludeParams(this, this.$exclude)
          // 填充对应表名和主键
          this.form.tableName = this.tableName;
          this.form.tID = this.tID;
          this.form.payType = this.fullLevel;
          this.form.checkState = '' //审核状态赋空
          // 填充公司类型
          this.form.companyType = this.value;
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


  }
};
</script>
