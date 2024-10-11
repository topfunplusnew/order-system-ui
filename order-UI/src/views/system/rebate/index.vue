<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="返利开始日期" prop="rebateStartTime">
        <el-date-picker
          v-model="queryParams.rebateStartTime"
          type="date"
          placeholder="选择开始时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="返利结束日期" prop="rebateEndTime">
        <el-date-picker
          v-model="queryParams.rebateEndTime"
          type="date"
          placeholder="选择开始时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="供应商" prop="supplier">
        <el-input
          v-model="queryParams.supplier"
          placeholder="请输入供应商"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <!-- 刷新按钮-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:rebate:add']"
        >新增供应商返利信息
        </el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-printer"
              size="mini"
              @click="printHTML"
            >
            </el-button>
          </el-col>
        </template>
        <!--        导出-->
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:rebate:export']"
            >
            </el-button>
          </el-col>
        </template>
        <!--        导出2-->
        <template v-slot:export2>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport2"
              v-hasPermi="['system:rebate:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="RebateList" size="mini"
              @selection-change="handleSelectionChange" id="printBox" :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="日期" align="center" prop="rebateDate" v-if="columns[0].visible" show-overflow-tooltip/>
      <el-table-column label="金额" align="center" prop="rebate" v-if="columns[1].visible" show-overflow-tooltip/>
      <el-table-column label="类型" align="center" prop="rebateType" v-if="columns[2].visible" show-overflow-tooltip/>
      <el-table-column label="收款户名" align="center" prop="inAcountsName" v-if="columns[3].visible"
                       show-overflow-tooltip/>
      <el-table-column label="收款账号" align="center" prop="inBankNo" v-if="columns[4].visible" width="160"
                       show-overflow-tooltip/>
      <el-table-column label="供应商" align="center" prop="supplier" v-if="columns[5].visible"/>
      <el-table-column label="付款户名" align="center" prop="outAcountsName" v-if="columns[6].visible"
                       show-overflow-tooltip/>
      <el-table-column label="付款款账号" align="center" prop="outBankNo" v-if="columns[7].visible" width="160"/>
      <el-table-column label="返利原因" align="center" prop="rebateReason" v-if="columns[8].visible"
                       show-overflow-tooltip/>
      <el-table-column label="返利方式" align="center" prop="rebateMethod" v-if="columns[9].visible"
                       show-overflow-tooltip/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[10].visible" show-overflow-tooltip/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150px" fixed="right">
        <template slot-scope="scope">
          <!--          <el-button
                      size="mini"
                      type="warning"
                      @click="addPaymentApply(scope.row)"
                    >付款返利
                    </el-button>-->
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:rebate:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:rebate:remove']"
          >删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改返利回扣对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="50%"
               append-to-body>
      <el-row>
        <el-form ref="form" :model="form" :rules="rules" label-width="120px">
          <!--        多选 且树表 展示多个订单 每个订单里面有多个订单详情-->
          <el-row>
            <el-col :span="12">
              <el-form-item label="订单编号" prop="ordersNo">
                <el-button @click="orderDialogVisible = true">
                  {{ form.ordersNo === null || form.ordersNo === '' ? '选择订单' : '已选择:' + form.ordersNo }}
                </el-button>
              </el-form-item>
              <el-form-item label="日期" prop="rebateDate">
                <el-date-picker
                  v-model="form.rebateDate"
                  type="date"
                  placeholder="日期"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="类型" prop="rebateType">
                <el-select v-model="form.rebateType" placeholder="请选择">
                  <el-option
                    v-for="item in rebateTypes"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="金额" prop="rebate">
                <el-input v-model="form.rebate" placeholder="请输入金额"/>
              </el-form-item>
              <el-form-item label="收款户名" prop="inAcountsName">
                <el-row>
                  <el-col :span="15">
                    <el-input v-model="form.inAcountsName" placeholder="请输入收款户名"/>
                  </el-col>
                  <el-col :span="4">
                    <SearchOption :limit-info="{}" :get-data="listBankAccount" @commitBack="handleCommitBackBankAcount"
                                  @update:queryName="handleUpdateQueryBankAcount" :query-name="queryBankAcount"
                                  query-label="户名查找" query-info="acountsName">
                      <template #table-columns>
                        <el-table-column label="账户类型" align="center" prop="acountsType"/>
                        <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                        <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                        <el-table-column label="开户行" align="center" prop="bankName"/>
                        <el-table-column label="公司名称" align="center" prop="companyName"/>
                      </template>
                    </SearchOption>
                  </el-col>
                </el-row>
              </el-form-item>
              <el-form-item label="收款账号" prop="inBankNo">
                <el-input v-model="form.inBankNo" placeholder="请输入收款账号"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <!--        供应商直接选择 不要自己填-->
              <el-form-item label="请选择供应商" prop="supplier">
                <el-row>
                  <el-col :span="15">
                    <el-input disabled v-model="form.supplier" placeholder="请选择供应商"/>
                  </el-col>
                  <el-col :span="4">
                    <SearchOption :limit-info="{companyType:'供应商'}" :get-data="listCompany"
                                  @commitBack="handleCommitBackCompanyGive" @update:queryName="handleQueryCompanyGive"
                                  :query-name="queryCompanyGive" query-info="companyName" query-label="供应商查找">
                      <template #table-columns>
                        <el-table-column label="供应商" align="center" prop="companyName"/>
                        <el-table-column label="地址" align="center" prop="address"/>
                      </template>
                    </SearchOption>
                  </el-col>
                </el-row>
              </el-form-item>
              <!--        <el-form-item label="供应商ID" prop="supplierID">-->
              <!--          <el-input v-model="form.supplierID" placeholder="请输入供应商ID"/>-->
              <!--        </el-form-item>-->
              <el-form-item label="付款户名" prop="outAcountsName">
                <el-row>
                  <el-col :span="15">
                    <el-input v-model="form.outAcountsName" placeholder="请输入付款户名"/>
                  </el-col>
                  <el-col :span="4">
                    <SearchOption :limit-info="{acountsType:'己方公司'}" :get-data="listBankAccount"
                                  @commitBack="handleCommitBackBankAcountSelf"
                                  @update:queryName="handleUpdateQueryBankAcountSelf"
                                  :query-name="bankAcountSelf"
                                  query-label="户名查找" query-info="acountsName">
                      <template #table-columns>
                        <el-table-column label="账户类型" align="center" prop="acountsType"/>
                        <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                        <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                        <el-table-column label="开户行" align="center" prop="bankName"/>
                        <el-table-column label="公司名称" align="center" prop="companyName"/>
                      </template>
                    </SearchOption>
                  </el-col>
                </el-row>
              </el-form-item>
              <el-form-item label="付款款账号" prop="outBankNo">
                <el-input v-model="form.outBankNo" placeholder="请输入付款款账号"/>
              </el-form-item>
              <el-form-item label="返利原因" prop="rebateReason">
                <el-input v-model="form.rebateReason" placeholder="请输入返利原因"/>
              </el-form-item>
              <el-form-item label="备注" prop="comments">
                <el-input v-model="form.comments" placeholder="请输入备注"/>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    付款申请-->
    <!--    <el-dialog :close-on-click-modal="false" :show-close="false" title="返利付款申请" :visible.sync="paymentApplyVisible" width="500px">-->
    <!--      <keep-alive>-->
    <!--        <ApplyPayment :table-name="TableName.REBATE" :t-i-d="tid" :need-money="needMoney"-->
    <!--                      :need-info="{...needInfo,otherAcountsName:needInfo.acountsName}"-->
    <!--                      @changeOpen="paymentApplyVisible = false"/>-->
    <!--      </keep-alive>-->
    <!--    </el-dialog>-->


    <!--    选择订单详情-->
    <el-dialog :close-on-click-modal="false" :show-close="true"
               title="订单选择"
               :visible.sync="orderDialogVisible"
               width="65%">
      <el-row>
        <el-button type="primary" @click="selectOrderItem" size="mini">选择订单</el-button>
      </el-row>
      <hr/>
      <!--      展示-->
      <el-row>
        <el-row>
          <OrderInfos :orderInfo="orderInfo"/>
        </el-row>
        <el-row>
          <el-row>
            <span style="font-weight: bolder">货物详情列表</span>
          </el-row>
          <el-row>
            <el-table border :data="orderDetailList" max-height="700" size="mini"
                      :cell-style="()=>{return {padding:'.5px'}}">
              <el-table-column show-overflow-tooltip label="操作" align="center"
                               class-name="small-padding fixed-width"
                               width="100px" fixed="left">
                <template slot-scope="scope">
                  <el-button size="mini" type="success" @click="handleSelectOrderDetail(scope.row)">选择该货物
                  </el-button>
                </template>
              </el-table-column>
              <el-table-column label="订单日期" align="center" prop="orderDate" fixed="left"/>
              <el-table-column label="客户" align="center" prop="customer"/>
              <el-table-column label="供应商" align="center" prop="supplier"/>
              <el-table-column label="级别名称" align="center" prop="levelName"/>
              <el-table-column label="计量单位" align="center" prop="countingUnit"/>
              <el-table-column label="厚度" align="center" prop="height"/>
              <el-table-column label="长度" align="center" prop="length"/>
              <el-table-column label="宽度" align="center" prop="width"/>
              <el-table-column label="出厂片数" align="center" prop="pieces"/>
              <el-table-column label="每包片数" align="center" prop="piecesPerPack"/>
              <el-table-column label="包数" align="center" prop="packs"/>
              <el-table-column label="出厂单价" align="center" prop="price"/>
              <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory">
                <template slot-scope="scope">
                  <el-tag
                    disable-transitions>{{ scope.row.isIncludeTaxFactory === 0 ? "否" : "是" }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="杂费" align="center" prop="sundryCost"/>
              <el-table-column label="出厂货款" align="center" prop="paymentFactory"/>
              <el-table-column label="卸货价" align="center" prop="paymentUnload"/>
              <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale">
                <template slot-scope="scope">
                  <el-tag
                    disable-transitions>{{ scope.row.isIncludeTaxSale === 0 ? "否" : "是" }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="总货款" align="center" prop="payments"/>
              <el-table-column label="误差" align="center" prop="erro"/>
              <el-table-column label="吨位" align="center" prop="tonnage"/>
              <el-table-column label="陆运费单价" align="center" prop="landFreightPrice"/>
              <el-table-column label="陆运费" align="center" prop="landFreight"/>
              <el-table-column label="海运费" align="center" prop="seaFreight"/>
              <el-table-column label="总运费" align="center" prop="freight"/>
              <el-table-column label="其他费用" align="center" prop="otherCost"/>
              <el-table-column label="利润" align="center" prop="profit"/>
              <el-table-column label="不含税利润" align="center" prop="profitNoTax"/>
              <el-table-column label="实际片数" align="center" prop="actualPieces"/>
              <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry"/>
              <el-table-column label="加费" align="center" prop="additionalFees"/>
              <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
              <el-table-column label="物流利润" align="center" prop="logisticsProfit"/>
              <el-table-column label="客户佣金" align="center" prop="customerCommission"/>
            </el-table>
          </el-row>
        </el-row>
      </el-row>
    </el-dialog>

    <el-dialog :close-on-click-modal="false" :show-close="false" title="选择订单" :visible.sync="orderSelectVisible"
               width="70%">
      <el-table fit border v-loading="loading" :data="orderList"
                max-height="750" size="mini" :cell-style="()=>{return {padding:'2px'}}">
        <el-table-column show-overflow-tooltip label="行操作" align="center" class-name="small-padding fixed-width"
                         width="100px" fixed="left">
          <template slot-scope="scope">
            <el-button size="mini" type="success" @click="handleSelectOrderItem(scope.row)
            ">选择
            </el-button>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left"/>
        <el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left"/>
        <el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left"/>
        <el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left"/>
        <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo"
        />
        <el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel"
                         width="100px"/>
        <el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName"
                         width="100px"/>
        <el-table-column show-overflow-tooltip label="海运车牌" align="center" prop="seaCarNo"
        >
          <template #default="scope">
            {{ scope.row.seaCarNo == null ? '无海运信息' : scope.row.seaCarNo }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel"
        >
          <template #default="scope">
            {{ scope.row.seaDriverTel == null ? '无海运信息' : scope.row.seaDriverTel }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="海运司机姓名" align="center" prop="seaDriverName"
                         width="100px">
          <template #default="scope">
            {{ scope.row.seaDriverName == null ? '无海运信息' : scope.row.seaDriverTel }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager"
        />
        <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet"/>
        <el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState"

                         width="120">
        </el-table-column>
        <el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState"
                         width="120px">
          <template #default="scope">
            <el-row v-if="scope.row.customerIsInvoice === 1 && scope.row.isSupplierInvoice === 1">
              <el-tag type="success">已开票</el-tag>
            </el-row>
            <el-row v-else-if="scope.row.customerIsInvoice === 0 && scope.row.isSupplierInvoice === 0">
              <el-row>
                <el-tag type="danger">未开票</el-tag>
              </el-row>
            </el-row>
            <el-row v-else>
              <el-row>
                <el-tag type="warning">部分开票</el-tag>
              </el-row>
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="附件" align="center" prop="path"
                         width="150px">
          <template #default="scope">
            <el-row>
            </el-row>
            <el-row v-if="scope.row.path === '' || scope.row.path === null">
              无操作
            </el-row>
            <el-row v-else>
              <el-button size="mini" type="success" @click="checkAttachment(scope.row.path)">
                查看
              </el-button>
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState"
                         width="120px">
        </el-table-column>
        <el-table-column show-overflow-tooltip label="收到条附件路径" align="center" prop="receiveProof"

                         width="150px">
          <template #default="scope">
            <el-row v-if="scope.row.receiveProof === '' || scope.row.receiveProof === null">
              无操作
            </el-row>
            <el-row v-else>
              <el-button size="mini" type="success" @click="checkAttachment(scope.row.receiveProof)">
                查看
              </el-button>
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="原订单编号" align="center" prop="adjustOrderid"
                         width="100px"/>
        <el-table-column show-overflow-tooltip label="是否可编辑" align="center" prop="isedit"

                         width="100px">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.isedit === 0 ? 'danger' :'success'">{{ scope.row.isedit === 0 ? "否" : "是" }}
            </el-tag>
          </template>
        </el-table-column>
        <!--      客户供应商是否开票-->
        <el-table-column show-overflow-tooltip label="客户是否开票" align="center" prop="customerIsInvoice"

                         width="150px">
          <template #default="scope">
            <el-row v-if="scope.row.customerIsInvoice === 1">
              <el-tag type="success">客户已开票</el-tag>
            </el-row>
            <el-row v-else>
              <el-row>
                <el-tag type="danger">未开票</el-tag>
              </el-row>
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice"
                         width="120px">
          <template #default="scope">
            <el-row v-if="scope.row.isSupplierInvoice === 1">
              <el-tag type="success"> 供应商已开票</el-tag>
            </el-row>
            <el-row v-else>
              <el-row>
                <el-tag type="danger">未开票</el-tag>
              </el-row>
            </el-row>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments"/>
      </el-table>
      <pagination
        v-show="orderTotal>0"
        :total="orderTotal"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getOrderList"
      />
    </el-dialog>

  </div>
</template>

<script>
import {listRebate, getRebate, delRebate, addRebate, updateRebate} from "@/api/system/Rebate";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import {getGoodsOrder, listGoodsOrder} from "@/api/system/goodsOrder";
import OrderInfos from "@/components/OrderInfos.vue";
import OrderDetailInfo from "@/components/OrderDetailInfo.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import SearchOption from "@/components/SearchOption.vue";

export default {
  name: "Rebate",
  computed: {
    TableName() {
      return TableName
    }
  },
  components: {SearchOption, OrderDetailInfo, OrderInfos, ApplyPayment},
  mixins: [mixin_printHTML],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 弹出的订单列表页的总条数
      orderTotal: 0,
      // 返利回扣表格数据
      RebateList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        rebateEndTime: null,
        rebateStartTime: null,
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        rebateDate: null,
        rebate: null,
        rebateType: null,
        inAcountsName: null,
        inBankNo: null,
        supplier: null,
        supplierID: null,
        outAcountsName: null,
        outBankNo: null,
        rebateReason: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      rebateTypes: [{
        value: '返利',
        label: '返利'
      }, {
        value: '降价',
        label: '降价'
      }, {
        value: '售后质量赔偿',
        label: '售后质量赔偿'
      }],
      // 表单校验
      rules: {
        ordersNo: [
          {required: true, message: "订单号不能为空", trigger: "blur"}],
        rebateDate: [
          {required: true, message: "返利日期不能为空", trigger: "blur"}],
        rebate: [
          {required: true, message: "返利金额不能为空", trigger: "blur"}],
        rebateType: [
          {required: true, message: "返利类型不能为空", trigger: "change"}],
        inAcountsName: [
          {required: true, message: "收款户名不能为空", trigger: "blur"}],
        inBankNo: [
          {required: true, message: "收款账号不能为空", trigger: "blur"}],
        supplier: [
          {required: true, message: "供应商不能为空", trigger: "blur"}],
        outAcountsName: [
          {required: true, message: "付款户名不能为空", trigger: "blur"}],
        outBankNo: [
          {required: true, message: "付款账号不能为空", trigger: "blur"}],
        rebateReason: [
          {required: true, message: "请输入返利原因!", trigger: "blur"}
        ]
      },
      columns: [
        {key: 0, label: `日期`, visible: true},
        {key: 1, label: `金额`, visible: true},
        {key: 2, label: `类型`, visible: true},
        {key: 3, label: `收款户名`, visible: true},
        {key: 4, label: `收款账号`, visible: true},
        {key: 5, label: `供应商`, visible: true},
        {key: 6, label: `付款户名`, visible: true},
        {key: 7, label: `付款款账号`, visible: true},
        {key: 8, label: `返利原因`, visible: true},
        {key: 9, label: `返利方式`, visible: true},
        {key: 10, label: `备注`, visible: true},

      ],
      needInfo: '',
      paymentApplyVisible: false,
      tid: '',
      needMoney: 0,

      //订单列表 级联
      orderList: [],
      //订单详情列表 级联
      orderDetailList: [],
      orderDialogVisible: false,
      //订单个人信息和订单详情信息
      orderInfo: {},
      queryBankAcount: '',

      //搜索供应商
      queryCompanyGive: '',
      bankAcountSelf: '',

      // 选择订单的显示
      orderSelectVisible: false
    };
  },
  created() {
    this.getList();
    //获取订单列表 级联选择
    listGoodsOrder().then(res => {
      this.orderList = res.rows;
    })
    if (localStorage.getItem('rebate-columns') === 'null'
      || !localStorage.getItem('rebate-columns')) {
      //设置localStorage
      localStorage.setItem("rebate-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('rebate-columns'));
    }
  },
  watch: {},
  methods: {
    listCompany,
    listBankAccount,
    // 付款申请
    addPaymentApply(row) {
      this.tid = row.id;
      this.paymentApplyVisible = true;
      this.needMoney = row.rebate;
      this.needInfo = row;
    },
    // 自动填充的信息
    handleCommitBackBankAcount(val) {
      this.form.inAcountsName = val.acountsName
      this.form.inBankNo = val.bankNo
    },
    handleUpdateQueryBankAcount(val) {
      this.queryBankAcount = val;
    },
    handleCommitBackCompanyGive(val) {
      this.form.supplier = val.companyName
      this.form.supplierID = val.id;
    },
    handleQueryCompanyGive(val) {
      this.queryCompanyGive = val;
    },
    handleCommitBackBankAcountSelf(val) {
      this.form.outAcountsName = val.acountsName;
      this.form.outBankNo = val.bankNo;
    },
    handleUpdateQueryBankAcountSelf(val) {
      this.bankAcountSelf = val;
    },
    // 点击选择订单
    selectOrderItem() {
      this.orderSelectVisible = true;
    },
    // 点击选择订单弹出的订单列表页选择某个订单 需要自动填充信息
    handleSelectOrderItem(row) {
      getGoodsOrder(row.id).then(res => {
        this.orderInfo = res.data;
        this.orderDetailList = res.data.orderDetailList;
      })
      this.orderSelectVisible = false
    },
    // 选择某一个货物
    handleSelectOrderDetail(row) {
      this.form.ordersNo = row.ordersNo;
      this.form.orderDetailID = row.id;
      this.orderDialogVisible = false
    },
    //查看附件信息
    checkAttachment(path) {
      window.open(path)
    },
    /** 查询返利回扣列表 */
    getList() {
      this.loading = true;
      listRebate(this.queryParams).then(response => {
        this.RebateList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 弹出的列表页分页
    getOrderList() {
      listGoodsOrder(this.queryParams).then(response => {
        this.orderList = response.rows;
        this.orderTotal = response.orderTotal;
        this.loading = false;
      });
    },

    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        ordersNo: null,
        rebateDate: null,
        rebate: null,
        rebateType: null,
        inAcountsName: null,
        inBankNo: null,
        supplier: null,
        supplierID: null,
        outAcountsName: null,
        outBankNo: null,
        rebateReason: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加返利回扣";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getRebate(id).then(response => {
        this.form = response.data;
        this.form.ordersNo = response.data.orderDetails[0].ordersNo
        this.open = true;
        this.title = "修改返利回扣";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateRebate(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addRebate(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除返利回扣编号为"' + ids + '"的数据项？').then(function () {
        return delRebate(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/Rebate/export', {
        ...this.queryParams
      }, `Rebate_${new Date().getTime()}.xlsx`)
    },
    handleExport2() {
      this.download('system/Rebate/export2', {
        ...this.queryParams
      }, `厂家(返利+降价+售后质量赔偿)_${new Date().getTime()}.xlsx`)
    },

  }
};
</script>
