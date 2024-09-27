<script>
export default {
  name: "generation",
  data() {
    return {
      credentialInfo: {},
      credentialList: []
    }
  },
  methods: {
    rules: {},
    rowTripReimbursementIndex({row, rowIndex}) {
      row.index = rowIndex + 1;
    },
    // 添加
    handleAddCredentialList() {
      let obj = {};
      obj.item = "";
      obj.itemCost = "";
      obj.comments = "";
      obj.addtime = "";
      obj.userId = "";
      obj.UserName = "";
      obj.delFlag = "";
      this.credentialList.push(obj);
    },
  }
}
</script>

<template>
  <div>
    <div style="margin: 19px 19px">
      <el-form :model="credentialInfo" ref="credentialInfo" :rules="rules" label-width="80px" size="mini">
        <el-table border :data="credentialList" :row-class-name="rowTripReimbursementIndex"
                  ref="tripReimbursement" align="center" show-summary>
          <el-table-column>
            <template slot="header" slot-scope="scope">
              <el-form-item label="制单日期" prop="input97458">
                <el-date-picker
                    v-model="credentialInfo.insuranceDate"
                    type="date"
                    placeholder="选择制单日期"
                    value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
            </template>
            <el-table-column label="序号" align="center" prop="index" width="50"/>
            <el-table-column label="摘要" prop="item" width="150">
              <template slot-scope="scope">
                <el-input v-model="scope.row.item" placeholder="请输入摘要" :disabled="scope.row.isDisabled"/>
              </template>
            </el-table-column>
            <el-table-column label="科目名称" prop="itemCost">
              <template slot-scope="scope">
                <el-input v-model="scope.row.itemCost" placeholder="请输入科目名称" :disabled="scope.row.isDisabled"/>
              </template>
            </el-table-column>
          </el-table-column>
          <el-table-column>
            <template slot="header" slot-scope="scope">
              <el-form-item label="凭证编号" prop="input97458">
                <el-input
                    v-model="credentialInfo.menuName"
                    placeholder="请输入凭证编号"
                    clearable
                />
              </el-form-item>
            </template>
            <el-table-column label="辅助项" prop="itemCost">
              <template slot-scope="scope">
                <el-input v-model="scope.row.itemCost" placeholder="请输入辅助项" :disabled="scope.row.isDisabled"/>
              </template>
            </el-table-column>
            <el-table-column label="借方" prop="itemCost">
              <template slot-scope="scope">
                <el-input v-model="scope.row.itemCost" placeholder="请输入借方" :disabled="scope.row.isDisabled"/>
              </template>
            </el-table-column>
          </el-table-column>
          <el-table-column>
            <template slot="header" slot-scope="scope">
              <el-form-item label="制单人" prop="input97458">
                <el-input
                    v-model="credentialInfo.menuName"
                    placeholder="请输入制单人"
                    clearable
                />
              </el-form-item>
            </template>
            <el-table-column label="贷方" prop="itemCost">
              <template slot-scope="scope">
                <el-input v-model="scope.row.itemCost" placeholder="请输入贷方" :disabled="scope.row.isDisabled"/>
              </template>
            </el-table-column>
          </el-table-column>
          <template #append>
            <el-button type="text" @click="handleAddCredentialList">
              <i class="el-icon-plus el-icon--right"></i>添加
            </el-button>
          </template>
        </el-table>
        <el-button type="primary" style="float: right">
          保存
        </el-button>
      </el-form>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
