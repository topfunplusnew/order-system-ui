<!--为公司绑定银行卡 本质是银行卡修改 通用组件-->

<script>
import {listBankAccount, updateBankAccount} from "../../../../api/system/bankAccount";

export default {
  name: "AddBank",
  props: {
    // 需要companyName companyId
    companyInfo: {
      type: Object,
      default() {
        return {}
      }
    }
  },
  data() {
    return {
      // 银行卡信息
      bankAccount: {},
      // 选择银行卡的弹窗
      dialogFormVisible: false,
      // 银行卡列表
      tableData: []
    }
  },
  created() {
    listBankAccount({companyId: 0}).then(res => {
      console.log(res)
      this.tableData = res.rows
    })
  },
  computed: {
    customCompanyInfo() {
      return {
        companyId: this.companyInfo.id,
        companyName: this.companyInfo.companyName
      }
    }
  },
  methods: {
    handleAdd() {
      this.dialogFormVisible = true
    },
    // 选择某张银行卡
    chooseThisBankAccount(row) {
      this.$confirm('确定要绑定这张银行卡吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.updateBankAccount(row);
      })
    },
    // 为某个公司绑定银行卡 本质上是修改银行卡中的信息 修改companyId和companyName
    updateBankAccount(info) {
      const body = {
        ...info,
        ...this.customCompanyInfo
      }
      updateBankAccount(body).then(res => {
        this.$message.success('绑定成功')
        this.dialogFormVisible = false
        this.$emit("changeBankOpen")
      })
    },
  }
}
</script>

<template>
  <div>
    <div style="text-align: center">
      <!--  添加银行卡的操作 搜索未绑定的银行卡,修改银行卡 -->
      <el-button
        size="mini"
        type="primary"
        @click="handleAdd"
      >添加银行卡
      </el-button>
    </div>

    <el-dialog
      title="选择需要绑定的银行卡"
      :visible.sync="dialogFormVisible"
      append-to-body
      width="58%">
      <el-table
        :data="tableData"
        stripe
        style="width: 100%">
        <el-table-column label="账户类型" align="center" prop="acountsType"/>
        <el-table-column label="开户名称" align="center" prop="acountsName"/>
        <el-table-column label="银行账号" align="center" prop="bankNo"/>
        <el-table-column label="开户行" align="center" prop="bankName"/>
        <el-table-column label="余额" align="center" prop="amount"/>
        <el-table-column label="银行卡操作" align="center" class-name="small-padding fixed-width" fixed="right">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              @click="chooseThisBankAccount(scope.row)"
            >选择
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogFormVisible = false">取 消</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
