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
    // 拿到选中的订单列表
    handleEmitGoodsOrderList(values) {
      this.selectedNeedOrderList = values
      console.log(this.selectedNeedOrderList)
    },
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
      <CrendentMake :need-to-make-list="selectedNeedOrderList"/>
      <!--      选择单据类型后跳出的选择框-->
      <InfoDialog :title="'选择单据类型'" :visible.sync="dialogVisible" @update:visible="close">
        <template #info>
          <OrderList @update:selectedGoodsOrderList="handleEmitGoodsOrderList">
            <template #option>
              <el-row>
                <el-button type="danger" @click="makeCredentials">生成凭证</el-button>
              </el-row>
            </template>
          </OrderList>
        </template>
      </InfoDialog>

      <!--       确认选择订单页面-->
      <InfoDialog :title="'确认选择订单'" :visible.sync="CheckDialogVisible"
                  @update:visible="CheckDialogVisible = false">
        <template #info>
          <el-table fit border :data="selectedNeedOrderList" v-horizontal-scroll="'always'"
                    max-height="750" size="mini" :cell-style="()=>{return {padding:'2px'}}">
            <el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left"/>
            <el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left"/>
            <el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left"/>
            <el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left"
                             width="200">
              <template #default="scope">
                <el-row v-if="scope.row.supplierNames !== null">
                  <el-row>
                  <span v-for="(item, index) in getSupplierNames(scope.row.orderDetailList)" :key="index">
                        {{ item.supplier }}
                  </span>
                  </el-row>
                </el-row>
                <el-row><span v-if="scope.row.supplierNames === null">无</span></el-row>
              </template>
            </el-table-column>
            <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo"/>
            <el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel"
                             width="100px"/>
            <el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName"
                             width="100px"/>
            <el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight" width="100px"/>
            <el-table-column show-overflow-tooltip label="海运车牌" align="center" prop="seaCarNo">
              <template #default="scope">{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}</template>
            </el-table-column>
            <el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel"
                             width="100px">
              <template #default="scope">{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}</template>
            </el-table-column>
            <el-table-column show-overflow-tooltip label="海运司机姓名" align="center" prop="seaDriverName"
                             width="100px">
              <template #default="scope">{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverName }}</template>
            </el-table-column>
            <el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight" width="100px"/>
            <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager"/>
            <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet"/>
            <el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"/>
            <el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState" width="120px"/>
            <el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState" width="120px"/>
            <el-table-column show-overflow-tooltip label="是否可编辑" align="center" prop="isedit" width="100px">
              <template slot-scope="scope">
                <el-tag :type="scope.row.isedit === 0 ? 'danger' : 'success'">
                  {{ scope.row.isedit === 0 ? '否' : '是' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments"/>
          </el-table>
          <div style="text-align: center">
            <el-button type="primary" @click="submitMakeCredentials">确定生成</el-button>
          </div>
        </template>
      </InfoDialog>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
