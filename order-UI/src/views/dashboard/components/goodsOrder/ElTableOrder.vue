<script>
import { mixin_printHTML } from "@/views/dashboard/mixins/print";
import { mixin_order_base } from "@/views/dashboard/mixins/order/order_base";
import reLength from "@/views/dashboard/mixins/reLength";
import CheckFiles from "@/components/CheckFiles.vue";
import { mixin_order_audit } from "@/views/dashboard/mixins/order/order_audit";
import { mixin_checkfile } from "@/views/dashboard/mixins/checkfiles/mixin_checkfile";
import { delGoodsOrder, getGoodsOrder, updateGoodsOrder } from "@/api/system/goodsOrder";
import { mixin_order_Invoice } from "@/views/dashboard/mixins/order/order_Invoice";
import { mixin_order_adjustOrder } from "@/views/dashboard/mixins/order/order_adjustOrder";
import { mixin_order_uploadFiles } from "@/views/dashboard/mixins/order/order_UploadFiles";
import { mixin_order_deliverGoods } from "@/views/dashboard/mixins/order/order_deliverGoods";
import { mixin_order_freeApply } from "@/views/dashboard/mixins/order/order_freeApply";
import DialogWrapper from "@/views/dashboard/components/common/DialogWrapper.vue";
import { mixin_order_checkOrder } from "@/views/dashboard/mixins/order/order_checkOrder";
import { mixin_order_add } from "@/views/dashboard/mixins/order/order_addOrder";
import { mixin_order_goodsItemInfo } from "@/views/dashboard/mixins/order/order_goodsItemInfo";
import FreeApply from "@/components/FreeApply.vue";
import { common_dialog } from "@/views/dashboard/mixins/common/common_dialog";

export default {
  name: "ElTableOrder",
  components: { FreeApply, DialogWrapper, CheckFiles },
  // 引入打印的混入、拖动表头宽度引起的变化、订单的基本信息的混入
  mixins: [
    // 打印功能
    mixin_printHTML,
    // 通用的弹窗组件配套的混入
    common_dialog,
    // 表头拖动功能
    reLength,
    // 订单基本功能
    mixin_order_base,
    // 订单审核功能
    mixin_order_audit,
    // 文件查看功能
    mixin_checkfile,
    // 订单开票的功能
    mixin_order_Invoice,
    // 订单查看的功能
    mixin_order_checkOrder,
    // 查看订单的货物
    mixin_order_goodsItemInfo,
    // 订单的添加或者修改
    mixin_order_add,
    // 调整单功能
    mixin_order_adjustOrder,
    // 上传附件
    mixin_order_uploadFiles,
    // 发货单
    mixin_order_deliverGoods,
    // 运费申请
    mixin_order_freeApply,
  ],
  data () {
    return {
      // 订单表格中的数据
      goodsOrderList: [],
      // 加载中的效果
      loading: true,
      // 订单总数 用于分页
      total: 0,
    }
  },
  methods: {
    updateGoodsOrder,
    getGoodsOrder,
    // 处理下拉菜单  使用的是事件委托
    handleCommand (command, row) {
      // 根据不同操作委派不同的方法
      switch (command) {
        // 查看订单详情
        case "checkOrderItemInfo":
          this.checkOrderItemInfo(row);
          break;
        // 修改订单
        case "handleUpdate":
          this.handleUpdate(row);
          break;
        // 查看货物
        case "handleCheckOrderDetailInfo":
          this.handleCheckOrderDetailInfo(row);
          break;
        //删除订单
        case "handleDelete":
          this.handleDelete(row);
          break;
        default:
          break;
      }
    },
    // 删除某一个订单
    handleDelete (row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除订单ID为"' + ids + '"的订单？').then(function () {
        return delGoodsOrder(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      })
    },
    /** 搜索按钮操作 */
    handleQuery () {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery () {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 表格的导出
    handleExport () {
      this.download('system/goodsOrder/export', {
        ...this.queryParams
      }, `goodsOrder_${new Date().getTime()}.xlsx`)
    },
  },
  watch: {
    // 监听显示隐藏列的改变
    columns: {
      handler: (newVal) => {
        localStorage.setItem("goodsorder-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
  },
  created () {
    // 获取订单列表
    this.getList();
    // 设置显示隐藏列的本地存储
    if (localStorage.getItem('goodsorder-columns') === 'null'
      || !localStorage.getItem('goodsorder-columns')) {
      localStorage.setItem("goodsorder-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('goodsorder-columns'));
    }
  },
}
</script>

<template>
  <div>
    <div v-if="currentComponent">
      <!--    通用弹窗 配合common_dialogs 使用-->
      <DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" :dialog-props="dialogProps"
        :dialog-title="dialogTitle" :dialog-width="dialogWidth" @update:dialogVisible="args => dialogVisible = false"
        @close="handleCloseDialog" @confirm="handleDialogConfirm" />
    </div>

    <!--    顶部按钮操作-->
    <div>
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" size="mini" @click="handleAdd" v-hasPermi="['system:goodsorder:add']">添加订单信息
          </el-button>
        </el-col>
      </el-row>
    </div>
    <!--      右侧的工具栏-->
    <div>
      <right-toolbar @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button plain icon="el-icon-printer" size="mini" @click="printHTML">
            </el-button>
          </el-col>
        </template>
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport"
              v-hasPermi="['system:goodsorder:export']">
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </div>

    <!--    订单表格 数据量较大-->
    <div>
      <el-table fit border id="printBox" size="mini" virtual-scroll max-height="750"
        :cell-style="() => { return { padding: '.7px' } }" :data="goodsOrderList" v-loading="loading"
        v-horizontal-scroll="'always'" @header-dragend="changeColWidth">
        <el-table-column label="行操作" align="center" class-name="small-padding fixed-width" width="142" fixed="left">
          <template slot-scope="scope">
            <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)">
              <el-button size="mini" type="text">操作</el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="checkOrderItemInfo">
                  <el-button size="mini">查 看</el-button>
                </el-dropdown-item>
                <el-dropdown-item command="handleUpdate" v-hasPermi="['system:goodsorder:edit']">
                  <el-button size="mini" type="primary">修 改</el-button>
                </el-dropdown-item>
                <el-dropdown-item command="handleCheckOrderDetailInfo">
                  <el-button size="mini" type="warning">货 物</el-button>
                </el-dropdown-item>
                <el-dropdown-item command="handleDelete" v-hasPermi="['system:goodsorder:remove']">
                  <el-button size="mini" type="danger">删 除</el-button>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
            <!--          禁用-->
            <!--          <el-button-->
            <!--            style="margin-left: 5px"-->
            <!--            size="mini"-->
            <!--            type="text"-->
            <!--            @click="checkOrderHistory(scope.row)"-->
            <!--          >查看历史-->
            <!--          </el-button>-->
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
        <el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left"
          v-show="columns[0].visible" />
        <el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left"
          v-show="columns[1].visible" />
        <el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left"
          v-show="columns[2].visible" width="200">
          <template #default="scope">
            <el-row v-if="scope.row.smailOrderDetails">
              <span v-for="(item, index) in getSupplierNames(scope.row.smailOrderDetails)" :key="index">
                <el-badge is-dot class="item">
                  <span @click="updateOrderItemVisibleSupplierInvoice(scope.row, item.supplierID)">
                    {{ item.supplier }}
                  </span>
                </el-badge>
              </span>
            </el-row>
            <template v-else>
              无
            </template>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo"
          v-show="columns[3].visible" />
        <el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel"
          v-show="columns[4].visible" width="100px" />
        <el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName"
          v-show="columns[5].visible" width="100px" />
        <el-table-column show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="100px">
          <template #default="scope">
            {{ scope.row.allPayments | changeNumber(changeLength) }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight" v-show="columns[6].visible"
          width="100px" />
        <!--      原为海运车牌号-->
        <el-table-column show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo" v-show="columns[7].visible">
          <template #default="scope">
            {{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel"
          v-show="columns[8].visible" width="100px">
          <template #default="scope">
            {{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
          </template>
        </el-table-column>
        <!--      原为海运司机姓名-->
        <el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName"
          v-show="columns[9].visible" width="100px">
          <template #default="scope">
            {{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight" v-show="columns[10].visible"
          width="100px" />
        <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager"
          v-show="columns[11].visible" />
        <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" v-show="columns[12].visible" />
        <el-table-column show-overflow-tooltip label="业务员" align="center" prop="userName" width="120px" />
        <el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState"
          v-show="columns[13].visible" width="120">
          <template #default="scope">
            <el-row v-if="scope.row.checkState === '已审核'">
              {{ scope.row.checkState }}
            </el-row>
            <el-row v-else>
              <el-row>
                <el-button type="text" @click="handleCheck(scope.row)" size="mini"
                  v-hasPermi="['system:goodsorder:audit']">审核
                </el-button>
              </el-row>
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState"
          v-show="columns[14].visible" width="120px" />
        <el-table-column show-overflow-tooltip label="附件" align="center" prop="path" v-show="columns[15].visible"
          width="150px">
          <template slot-scope="scope">
            <CheckFiles :path="scope.row.path"
              @needToUpdate="(value) => handleUpdateFilePath(value, scope.row, 'path', getGoodsOrder, updateGoodsOrder)" />
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="收到条附件路径" align="center" prop="receiveProof"
          v-show="columns[17].visible" width="150px">
          <template #default="scope">
            <CheckFiles :path="scope.row.receiveProof"
              @needToUpdate="(value) => handleUpdateFilePath(value, scope.row, 'receiveProof', getGoodsOrder, updateGoodsOrder)" />
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="是否可编辑" align="center" prop="isedit" v-show="columns[19].visible"
          width="100px">
          <template slot-scope="scope">
            {{ scope.row.isedit === 0 ? "否" : "是" }}
          </template>
        </el-table-column>
        <!--      客户供应商是否开票-->
        <el-table-column show-overflow-tooltip label="客户是否开票" align="center" prop="customerIsInvoice"
          v-show="columns[20].visible" width="150px">
          <template #default="scope">
            <el-row v-if="hasOpen(scope.row, 1)">
              <el-row v-if="scope.row.customerIsInvoice > 0">
                <el-row>
                  <el-button type="text" size="mini" @click="updateOrderItemVisibleCustomerInvoice(scope.row)">继续开票
                  </el-button>
                </el-row>
              </el-row>
              <el-row v-else>
                <el-row>
                  <el-button type="text" size="mini" @click="updateOrderItemVisibleCustomerInvoice(scope.row)">前去开票
                  </el-button>
                </el-row>
              </el-row>
            </el-row>
            <el-row v-else>
              无开票
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice"
          v-show="columns[21].visible" width="120px">
          <template #default="scope">
            <el-row v-if="hasOpen(scope.row, 0)">
              <el-row v-if="scope.row.isSupplierInvoice > 0">
                <el-row>
                  <el-button type="text" size="mini" @click="updateOrderItemVisibleSupplierInvoice(scope.row)">继续开票
                  </el-button>
                </el-row>
              </el-row>
              <el-row v-else>
                <el-row>
                  <el-button type="text" size="mini" @click="updateOrderItemVisibleSupplierInvoice(scope.row)">前去开票
                  </el-button>
                </el-row>
              </el-row>
            </el-row>
            <el-row v-else>
              无开票
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" v-show="columns[22].visible" />
        <!--      右侧操作栏-->
        <el-table-column show-overflow-tooltip label="订单操作" align="center" class-name="small-padding fixed-width"
          width="160px" fixed="right">
          <template slot-scope="scope">
            <!--          调整单-->
            <el-button :disabled="scope.row.isAdjusted === '是'" size="mini" type="text"
              @click="handleOrderItemInfo(scope.row)">调整单
            </el-button>
            <!--          发货单-->
            <el-dropdown size="mini" type="text">
              <el-button type="text" size="mini">
                发货单<i class="el-icon-arrow-down el-icon--right"></i>
              </el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item>
                  <el-button size="mini" type="text" @click="handleOrder1(scope.row)">发货单1
                  </el-button>
                </el-dropdown-item>
                <el-dropdown-item>
                  <el-button size="mini" type="text" @click="handleOrder2(scope.row)">发货单2
                  </el-button>
                </el-dropdown-item>
                <el-dropdown-item>
                  <el-button size="mini" type="text" @click="handleOrder3(scope.row)">发货单3
                  </el-button>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="运费申请" align="center" class-name="small-padding fixed-width"
          width="100px" fixed="right">
          <template slot-scope="scope">
            <!--          如果有订单运费 那么就禁用按钮-->
            <el-dropdown size="mini" type="text" :disabled="(scope.row.params.isHaveOrderfreight === 'true')">
              <el-button type="text" :disabled="!(scope.row.landFreight > 0 || scope.row.seaFreight > 0)">操作
              </el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item>
                  <el-row v-if="scope.row.landFreight > 0 || scope.row.seaFreight > 0">
                    <el-button size="mini" v-if="scope.row.landFreight > 0" type="warning"
                      @click="handleApplyLandFree(scope.row)" v-hasPermi="['system:goodsorder:remove']">陆运费申请
                    </el-button>
                    <el-button size="mini" v-if="scope.row.seaFreight > 0" type="primary"
                      @click="handleApplySeaFree(scope.row)" v-hasPermi="['system:goodsorder:remove']">海运费申请
                    </el-button>
                  </el-row>
                  <el-row v-else>
                    无运费信息
                  </el-row>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </template>
        </el-table-column>
      </el-table>
      <!--    分页组件-->
      <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
        @pagination="getList" />
    </div>
  </div>
</template>

<style scoped lang="scss"></style>
