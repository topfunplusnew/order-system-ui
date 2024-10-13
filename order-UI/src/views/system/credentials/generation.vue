<script>
import {
  mixin_credentials_generation_orderlist
} from "../../dashboard/mixins/credentials/credentials_generation_orderlist";
import InfoDialog from "../../../components/InfoDialog.vue";
import {DocumentNumber} from "../../../api/tool/enums";
import CrendentMake from "../../../components/CrendentMake.vue";
import OrderList from "../../../components/OrderList.vue";

export default {
  name: "generation",
  components: {OrderList, CrendentMake, InfoDialog},
  mixins: [mixin_credentials_generation_orderlist],
  data() {
    return {
      credentialInfo: {},
      credentialList: [],
      rules: {},
      // 单据类型
      type: '',
      options: [{
        value: DocumentNumber.GOODS_ORDER,
        label: DocumentNumber.GOODS_ORDER
      }],
    }
  },
  methods: {
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
    close() {
      this.dialogVisible = false;
    }
  }
}
</script>

<template>
  <div>
    <!--    借 主营业务成本-运费成本 - 68.25 运费 海运陆运之和-->
    <!--    贷 应付运费 - 陆运 应付运费 - 海运 分开写填运费-->
    <!--    凭证编号依据 模块 + 订单uuid-->
    <div style="margin: 19px 19px">
      <el-row>
        <el-select v-model="type" placeholder="单据类型" clearable>
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-row>
      <!--      凭证生成组件-->
      <CrendentMake/>
      <!--      选择单据类型后跳出的选择框-->
      <InfoDialog :title="'选择单据类型'" :visible.sync="dialogVisible" @update:visible="close">
        <template #info>
          <OrderList>
            <template #option>
              <el-row>
                <el-button type="danger" @click="makeCredentials">生成凭证</el-button>
              </el-row>
            </template>
          </OrderList>
        </template>
      </InfoDialog>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
