<!--订单页面-->
<template>
  <div class="app-container">
    <el-form :model="timesQuery" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
      <el-row>
        <el-col :span="4">
          <el-form-item label="开始时间" prop="beginTime">
            <el-date-picker
                v-model="queryParams.orderDateStart"
                type="date"
                placeholder="选择时间"
                value-format="yyyy-MM-dd"
                size="mini"
                style="width: 100px;">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item label="结束时间" prop="endTime">
            <el-date-picker
                v-model="queryParams.orderDateEnd"
                type="date"
                placeholder="选择时间"
                value-format="yyyy-MM-dd"
                size="mini"
                style="width: 100px;">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item label="客户名称" prop="customer">
            <el-input
                v-model="queryParams.customer"
                placeholder="请输入客户名称"
                clearable
                @keyup.enter.native="handleQuery"
                size="mini"
                style="width: 100px;">
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item label="审核状态" prop="checkState">
            <el-select
                v-model="queryParams.checkState"
                placeholder="请选择"
                size="mini"
                style="width: 100px;">
              <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item label="开票状态" prop="invoiceState">
            <el-select
                v-model="queryParams.invoiceState"
                placeholder="请选择"
                size="mini"
                style="width: 100px;">
              <el-option
                  v-for="item in optionsInvoice"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item>
            <el-button
                type="primary"
                icon="el-icon-search"
                size="mini"
                @click="handleQuery">
              搜索
            </el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <!--    表格上方操作栏-->
    <el-row :gutter="10" class="mb8">
      <!--      左侧操作栏-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="warning"
            plain
            icon="el-icon-download"
            size="mini"
            @click="handleExport"
            v-hasPermi="['system:goodsorder:export']"
        >导出订单数据
        </el-button>
      </el-col>
      <!--      右侧表格的工具栏-->
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
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
                plain
                icon="el-icon-folder-opened"
                size="mini"
                @click="handleExport"
                v-hasPermi="['system:goodsorder:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>
    <!--    表格列-->
    <el-table fit border v-loading="loading" :data="goodsOrderList" @selection-change="handleSelectionChange"
              id="printBox" v-horizontal-scroll="'always'"
              max-height="750" size="mini" :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column show-overflow-tooltip label="行操作" align="center" class-name="small-padding fixed-width"
                       width="100px" fixed="left">
        <template slot-scope="scope">
          <el-dropdown size="mini" split-button type="primary">
            操作
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item>
                <el-button
                    size="mini"
                    @click="checkOrderItemInfo(scope.row)"
                >查看
                </el-button>
              </el-dropdown-item>
              <!--              <el-dropdown-item>-->
              <!--                <el-button-->
              <!--                  size="mini"-->
              <!--                  type="primary"-->
              <!--                  @click="handleUpdate(scope.row)"-->
              <!--                  v-hasPermi="['system:goodsorder:edit']"-->
              <!--                >修改-->
              <!--                </el-button>-->
              <!--              </el-dropdown-item>-->
              <el-dropdown-item>
                <el-button
                    size="mini"
                    type="warning"
                    @click="handleCheckOrderDetailInfo(scope.row)"
                >详情
                </el-button>
              </el-dropdown-item>
              <el-dropdown-item>
                <el-button
                    size="mini"
                    type="danger"
                    @click="handleDelete(scope.row)"
                    v-hasPermi="['system:goodsorder:remove']"
                >删除
                </el-button>
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left"/>
      <el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left"/>
      <el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left"/>
      <el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left"/>
      <!--      <el-table-column label="订单编号" align="center" prop="ordersNo" v-if="columns[0].visible"/>-->
      <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo"
                       v-if="columns[1].visible"/>
      <el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel"
                       v-if="columns[2].visible" width="100px"/>
      <el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName"
                       v-if="columns[3].visible" width="100px"/>
      <el-table-column show-overflow-tooltip label="海运车牌" align="center" prop="seaCarNo" v-if="columns[4].visible">
        <template #default="scope">
          {{ scope.row.seaCarNo == null ? '无海运信息' : scope.row.seaCarNo }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel"
                       v-if="columns[5].visible" width="100px">
        <template #default="scope">
          {{ scope.row.seaDriverTel == null ? '无海运信息' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="海运司机姓名" align="center" prop="seaDriverName"
                       v-if="columns[6].visible" width="100px">
        <template #default="scope">
          {{ scope.row.seaDriverName == null ? '无海运信息' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager"
                       v-if="columns[7].visible"/>
      <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" v-if="columns[8].visible"/>
      <el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" v-if="columns[9].visible"
                       width="120">
        <template #default="scope">
          <el-row v-if="scope.row.checkState === '已审核'">
            <el-tag type="success">{{ scope.row.checkState }}</el-tag>
          </el-row>
          <el-row v-else>
            <el-row>
              <el-button type="warning" @click="handleCheck(scope.row)" size="mini"
                         v-hasPermi="['system:goodsorder:audit']">审核
              </el-button>
            </el-row>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState"
                       v-if="columns[10].visible" width="120px">
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
      <el-table-column show-overflow-tooltip label="附件" align="center" prop="path" v-if="columns[11].visible"
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
                       v-if="columns[12].visible" width="120px">
        <template slot-scope="scope">
          <el-row v-if="scope.row.paymentState === '未申请'">
            <el-button size="mini" type="primary" @click="applyForPayment(scope.row)">申请打款</el-button>
          </el-row>
          <el-row v-if="scope.row.paymentState === '审核中'">
            <el-tag type="warning">审核中</el-tag>
          </el-row>
          <el-row v-if="scope.row.paymentState === '未打款'">
            <el-tag type="warning">订单未打款</el-tag>
            <el-button>前往打款</el-button>
          </el-row>
          <el-row v-if="scope.row.paymentState === '已打款'">
            <el-tag type="success">订单已打款</el-tag>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="收到条附件路径" align="center" prop="receiveProof"
                       v-if="columns[13].visible"
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
      <!--      <el-table-column show-overflow-tooltip label="原订单编号" align="center" prop="adjustOrderid"-->
      <!--                       v-if="columns[17].visible" width="100px"/>-->
      <el-table-column show-overflow-tooltip label="是否可编辑" align="center" prop="isedit" v-if="columns[18].visible"
                       width="100px">
        <template slot-scope="scope">
          <el-tag
              :type="scope.row.isedit === 0 ? 'danger' :'success'">{{ scope.row.isedit === 0 ? "否" : "是" }}
          </el-tag>
        </template>
      </el-table-column>
      <!--      客户供应商是否开票-->
      <el-table-column show-overflow-tooltip label="客户是否开票" align="center" prop="customerIsInvoice"
                       v-if="columns[19].visible"
                       width="150px">
        <template #default="scope">
          <el-row v-if="scope.row.customerIsInvoice === 1">
            <el-tag type="success">客户已开票</el-tag>
          </el-row>
          <el-row v-else>
            <el-row>
              <el-button type="success" size="mini" @click="openCustomerInvoice(scope.row)">去开票</el-button>
            </el-row>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice"
                       v-if="columns[20].visible"
                       width="120px">
        <template #default="scope">
          <el-row v-if="scope.row.isSupplierInvoice === 1">
            <el-tag type="success"> 供应商已开票</el-tag>
          </el-row>
          <el-row v-else>
            <el-row>
              <el-button type="success" size="mini" @click="openSupplierInvoice(scope.row)">去开票</el-button>
            </el-row>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" v-if="columns[21].visible"/>
      <!--      右侧操作栏-->
      <el-table-column show-overflow-tooltip label="订单操作" align="center" class-name="small-padding fixed-width"
                       width="280px"
                       fixed="right">
        <template slot-scope="scope">
          <el-button
              size="mini"
              @click="handleOrder1(scope.row)"
              v-hasPermi="['system:goodsorder:edit']"
          >发货单
          </el-button>
          <el-button
              size="mini"
              type="primary"
              @click="checkPreviousOrder(scope.row)"
          >查看原订单
          </el-button>
          <el-button
              size="mini"
              type="primary"
              @click="handleUpload(scope.row)"
          >上传附件
          </el-button>
          <el-button
              size="mini"
              @click="handleCommit(scope.row)"
              v-hasPermi="['system:goodsorder:remove']"
          >上传收到条
          </el-button>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="运费申请" align="center" class-name="small-padding fixed-width"
                       width="100px"
                       fixed="right">
        <template slot-scope="scope">
          <el-dropdown size="mini" split-button type="primary">
            操作
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item>
                <el-row v-if="scope.row.landFreight>0 ||scope.row.seaFreight>0  ">
                  <el-button
                      size="mini"
                      v-if="scope.row.landFreight>0"
                      type="warning"
                      @click="handleApplyLandFree(scope.row)"
                      v-hasPermi="['system:goodsorder:remove']"
                  >陆运费申请
                  </el-button>
                  <el-button
                      size="mini"
                      v-if="scope.row.seaFreight>0"
                      type="primary"
                      @click="handleApplySeaFree(scope.row)"
                      v-hasPermi="['system:goodsorder:remove']"
                  >海运费申请
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
    <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
    />


    <!--        点击查看某个订单的弹窗   -->
    <el-dialog
        title="查看订单信息"
        :visible.sync="checkOrderVisible"
        width="60%">
      <el-descriptions title="订单信息" :column="4" border size="medium">
        <el-descriptions-item label="日期">{{ orderDetailInfo.orderDate }}</el-descriptions-item>
        <el-descriptions-item label="客户">{{ orderDetailInfo.customer }}</el-descriptions-item>
        <el-descriptions-item label="商家姓名">{{ orderDetailInfo.supplierNames }}</el-descriptions-item>
        <el-descriptions-item label="车队">{{ orderDetailInfo.fleet }}</el-descriptions-item>
        <el-descriptions-item label="审核状态">
          <TagsItem :check-info="orderDetailInfo.checkState" checkValue="未审核"/>
        </el-descriptions-item>
        <el-descriptions-item label="开票状态">
          <TagsItem :check-info="orderDetailInfo.invoiceState" checkValue="未开票"/>
        </el-descriptions-item>
        <el-descriptions-item label="附件">{{ orderDetailInfo.path }}</el-descriptions-item>
        <el-descriptions-item label="陆运车牌">{{ orderDetailInfo.landCarNo }}</el-descriptions-item>
        <el-descriptions-item label="陆运司机电话">{{ orderDetailInfo.landDriverTel }}</el-descriptions-item>
        <el-descriptions-item label="陆运司机姓名">{{ orderDetailInfo.landDriverName }}</el-descriptions-item>
        <el-descriptions-item label="海运车牌">{{ orderDetailInfo.seaCarNo }}</el-descriptions-item>
        <el-descriptions-item label="海运司机电话">{{ orderDetailInfo.seaDriverTel }}</el-descriptions-item>
        <el-descriptions-item label="海运司机姓名">{{ orderDetailInfo.seaDriverName }}</el-descriptions-item>
        <el-descriptions-item label="打款状态">{{ orderDetailInfo.PaymentState }}</el-descriptions-item>
        <el-descriptions-item label="陆运银行户名">{{ orderDetailInfo.landBankName }}</el-descriptions-item>
        <el-descriptions-item label="陆运银行账号">{{ orderDetailInfo.landBankNo }}</el-descriptions-item>
        <el-descriptions-item label="海运银行户名">{{ orderDetailInfo.seaBankName }}</el-descriptions-item>
        <el-descriptions-item label="海运银行账号">{{ orderDetailInfo.seaBankNo }}</el-descriptions-item>
        <el-descriptions-item label="收到条附件">{{ orderDetailInfo.receiveProof }}</el-descriptions-item>
        <el-descriptions-item label="是否被调整单">
          <TagsItem :check-info="orderDetailInfo.isAdjusted " check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="调整日期" v-if="orderDetailInfo.isAdjusted">{{
            orderDetailInfo.adjustDate
          }}
        </el-descriptions-item>
        <el-descriptions-item label="原订单编号">{{ orderDetailInfo.adjustOrderid }}</el-descriptions-item>
        <el-descriptions-item label="是否可编辑">
          <TagsItem :check-info="isOrNot(orderDetailInfo.isedit) " check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="客户是否开票">
          <TagsItem :check-info="isOrNot(orderDetailInfo.customerIsInvoice)" check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="供应商是否开票">
          <TagsItem :check-info="isOrNot(orderDetailInfo.customerIsInvoice)" check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="陆运费">{{ orderDetailInfo.landFreight }}</el-descriptions-item>
        <el-descriptions-item label="海运费">{{ orderDetailInfo.seaFreight }}</el-descriptions-item>
      </el-descriptions>
      <span slot="footer" class="dialog-footer">
        <el-button @click="checkOrderVisible = false">取 消</el-button>
        <el-button type="primary" @click="checkOrderVisible = false">确 定</el-button>
      </span>
    </el-dialog>


    <!--    点击发货单的弹窗-->
    <el-dialog
        title="发货单"
        :visible.sync="Order1Visible"
        width="75%">
      <!--      发货单主体-->
      <el-row>
        <ChatForm/>
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="Order1Visible = false">取 消</el-button>
    <el-button type="primary" @click="Order1Visible = false">确 定</el-button>
  </span>
    </el-dialog>

    <!--    上传附件的弹窗-->
    <el-dialog
        title="上传附件"
        :visible.sync="handleUploadVisible"
        width="30%">
      <!--      todo      <file-upload is-show-tip @input="handleBackUpload"/>-->
      <el-upload
          class="upload-demo"
          drag
          :action="uploadFileUrl"
          multiple :on-success="handleUploadPathSuccess"
          :limit="1"
          :headers="headers">
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb</div>
      </el-upload>
      <span slot="footer" class="dialog-footer">
    <el-button @click="handleUploadVisible = false">取 消</el-button>
    <el-button type="primary" @click="handleUploadVisible = false">确 定</el-button>
  </span>
    </el-dialog>

    <!--    上传收到条的弹窗 todo 可以上传多个文件-->
    <el-dialog
        title="提示"
        :visible.sync="handleCommitVisible"
        width="30%">
      <el-upload
          class="upload-demo"
          drag
          :action="uploadFileUrl"
          multiple :on-success="handleUploadReceiveProofSuccess"
          :headers="headers"
          :file-list="fileList"
          :on-change="handleChange">
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb</div>
      </el-upload>
      <span slot="footer" class="dialog-footer">
    <el-button @click="handleCommitVisible = false">取 消</el-button>
    <el-button type="primary" @click="handleCommitVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    添加订单的新弹窗 原有的新增不使用-->
    <el-dialog
        title="订单信息"
        :visible.sync="addOrderItemVisible"
        width="80%">
      <!--      添加订单 传递本组件的orderInfo信息 -->
      <OrderForm :orderInfo="orderInfo" @updateOrderInfo="handleChangeOrderInfo"/>
      <span slot="footer" class="dialog-footer">
    <el-button @click="cancelSubmit">取 消</el-button>
    <el-button type="primary" @click="submitOrder">添加订单</el-button>
  </span>
    </el-dialog>

    <!--    陆运费申请 指定destroy-on-close来销毁dialog的元素让其下次打开重新渲染 从而反复执行created-->
    <el-dialog
        title="陆运费申请"
        :visible.sync="landFreeDialogVisible"
        width="30%" destroy-on-close>
      <FreeApply :order-info="landFreightInfo"/>
    </el-dialog>

    <!--    海运费申请 :key="keyFlag"-->
    <el-dialog
        title="海运费申请"
        :visible.sync="seaFreeDialogVisible"
        width="30%" destroy-on-close>
      <FreeApply :order-info="seaFreightInfo"/>
    </el-dialog>


    <!--    订单详情-->
    <el-dialog
        title="订单货物详情"
        :visible.sync="checkOrderDetailInfoVisible"
        width="70%" destroy-on-close>
      <!--      传递订单详情列表-->
      <OrderDetailInfo :orderDetailInfoList="orderDetailInfoList"
                       @updateOrderDetailList="handleUpdateOrderDetailInfoList"/>
    </el-dialog>

    <!-- 添加或修改订单对话框 -->
    <el-dialog title="修改订单" :visible.sync="open" append-to-body width="70%">
      <OrderForm :orderInfo="orderInfo" @updateOrderInfo="handleChangeOrderInfo"/>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="订单打款申请" :visible.sync="paymentApplyVisible" width="48%">
      <keep-alive>
        <ApplyPayment :table-name="TableName.GOODS_ORDER" :t-i-d="tID" :need-money="needMoney"
                      :need-info="{}"
                      @changeOpen="handleCloseApply"/>
      </keep-alive>
    </el-dialog>

    <!-- 开发票-->
    <el-dialog
        :title="openTitle"
        :visible.sync="invoiceOpenVisible"
        width="50%">
      <el-row>
        <el-form :model="openTitleInfo" label-width="110px" :rules="CheckRules.openTitleRules">
          <el-form-item label="开票日期" prop="invoiceDate">
            <el-date-picker
                v-model="openTitleInfo.invoiceDate"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="我方开票实体" prop="invoiceObject">
            <el-input v-model="openTitleInfo.invoiceObject" placeholder="请输入我方开票实体"/>
          </el-form-item>
          <el-form-item label="开票金额" prop="invoiceAmount">
            <el-input v-model="openTitleInfo.invoiceAmount" placeholder="请输入开票金额"/>
          </el-form-item>
          <el-form-item label="公司名称" prop="companyName">
            <el-row>
              <el-col :span="10">
                <el-input v-model="openTitleInfo.companyName" placeholder="请输入对方公司名称"/>
              </el-col>
              <el-col :span="2">
                <SearchOption :limit-info="openTitleInfo.domain === 1? {companyType:'客户'}:{companyType:'供应商'}"
                              :get-data="listCompany" query-info="companyName"
                              query-label="公司名称" :query-name="queryCompanyName"
                              @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                  <template #table-columns>
                    <el-table-column :label="openTitleInfo.domain === 1? '客户':'供应商'" align="center"
                                     prop="relationName"/>
                    <el-table-column label="老板姓名" align="center" prop="leader"/>
                    <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                    <el-table-column label="区域" align="center" prop="region"/>
                    <el-table-column label="公司名称" align="center" prop="companyName"/>
                    <el-table-column label="销售经理" align="center" prop="salesManager"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="票据单位名称" prop="invoiceCompanyName">
            <el-input v-model="openTitleInfo.invoiceCompanyName" placeholder="请输入票据单位名称"/>
          </el-form-item>
          <el-form-item label="票点" prop="ticketPoint">
            <el-input v-model="openTitleInfo.ticketPoint" placeholder="请输入票点"/>
          </el-form-item>
          <el-form-item label="票点金额" prop="ticketPointAmount">
            <el-input v-model="openTitleInfo.ticketPointAmount" placeholder="请输入票点金额" disabled/>
          </el-form-item>
          <el-form-item label="备注" prop="comments">
            <el-input v-model="openTitleInfo.comments" placeholder="请输入备注"/>
          </el-form-item>
        </el-form>
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="invoiceOpenVisible = false">取 消</el-button>
    <el-button type="primary" @click="submitOpenTitle">确 定</el-button>
  </span>
    </el-dialog>

    <el-dialog
        title="原订单信息"
        :visible.sync="checkReviousOrderInfoVisible"
        width="70%">
      <el-row>
        <OrderInfos :order-info="previousOrderInfo"/>
      </el-row>
      <el-row>
        <OrderDetailInfo :orderDetailInfoList="previousOrderInfo.orderDetailList"/>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import {
  listGoodsOrder,
  getGoodsOrder,
  delGoodsOrder,
  addGoodsOrder,
  updateGoodsOrder,
  adjustGoodsOrder, auditGoodsOrder
} from "@/api/system/goodsOrder";
import TagsItem from "@/components/TagsItem/index.vue";
import OrderForm from "@/components/OrderForm.vue";
import {mapGetters} from "vuex";
import {getToken} from "@/utils/auth";
import {excludeParams} from "@/api/tool/exclude";
import SearchOption from "@/components/SearchOption.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import {addRebate} from "@/api/system/Rebate";
import {formatDate} from "@/utils";
import {addOrderFreight, listOrderFreight} from "@/api/system/orderFreight";
import SwitchBarItem from "@/components/SwitchBarItem.vue";
import SwitchBarForCheck from "@/components/SwitchBarForCheck.vue";
import ApplyPayment from "@/components/ApplyPayment.vue";
import ChatForm from "@/components/ChatForm.vue";
import {addInvoiceOut} from "@/api/system/invoiceOut";
import OrderDetail from "@/views/system/orderdetail/index.vue";
import OrderDetailInfo from "@/components/OrderDetailInfo.vue";
import {listPaymentApply} from "@/api/system/paymentApply";
import Vue from "vue";
import {TableName} from "@/api/tool/enums";
import FreeApply from "@/components/FreeApply.vue";
import {findFileExtension} from "@/utils/trash/utils";
import {parseTime} from "../../../utils/ruoyi";
import {downloadFile} from "@/api/download";
import {addInvoiceIn} from "@/api/system/invoiceIn";
import OrderInfos from "../../../components/OrderInfos.vue";

export default {
  name: "GoodsOrder",
  components: {
    OrderInfos,
    FreeApply,
    OrderDetailInfo,
    OrderDetail, ChatForm, ApplyPayment, SwitchBarForCheck, SwitchBarItem, SearchOption, OrderForm, TagsItem
  },
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
      // 订单表格数据
      goodsOrderList: [],
      // 弹出层标题
      title: "",
      //key强制重新渲染组件
      keyFlag: 0,
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        orderDate: null,
        customer: null,
        customerID: null,
        landCarID: null,
        landCarNo: null,
        landDriverTel: null,
        landDriverName: null,
        seaCarID: null,
        seaCarNo: null,
        seaDriverTel: null,
        seaDriverName: null,
        checkUserId: null,
        checkState: null,
        invoiceState: null,
        path: null,
        PaymentState: null,
        landBankName: null,
        landBankNo: null,
        seaBankName: null,
        seaBankNo: null,
        receiveProof: null,
        saleManager: null,
        fleet: null,
        isAdjusted: '是',
        adjustDate: null,
        isAdjust: '是',
        adjustOrderid: null,
        isedit: null,
        customerIsInvoice: null,
        isSupplierInvoice: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      timesQuery: {},
      paramQuery: {},
      options: [
        {
          value: '已审核',
          label: '已审核'
        }, {
          value: '未审核',
          label: '未审核'
        },
      ],
      optionsInvoice: [{
        value: '未开票',
        label: '未开票'
      }, {
        value: '部分开票',
        label: '部分开票'
      }, {
        value: '已开票',
        label: '已开票'
      },],
      //隐藏列
      columns: [
        {key: 0, label: `订单编号`, visible: true},
        {key: 1, label: `陆运车牌`, visible: true},
        {key: 2, label: `陆运司机电话`, visible: true},
        {key: 3, label: `陆运司机姓名`, visible: true},
        {key: 4, label: `海运车牌`, visible: true},
        {key: 5, label: `海运司机电话`, visible: true},
        {key: 6, label: `海运司机姓名`, visible: true},
        {key: 7, label: `销售经理`, visible: true},
        {key: 8, label: `车队`, visible: true},
        {key: 9, label: `审核状态`, visible: true},
        {key: 10, label: `开票状态`, visible: true},
        {key: 11, label: `附件路径`, visible: true},
        {key: 12, label: `打款状态`, visible: true},
        /* {key: 13, label: `陆运银行户名`, visible: true},
         {key: 14, label: `陆运银行账号`, visible: true},
         {key: 15, label: `海运银行户名`, visible: true},
         {key: 16, label: `海运银行账号`, visible: true},*/
        {key: 13, label: `收到条附件路径`, visible: true},
        {key: 14, label: `是否被调整单`, visible: true},
        {key: 15, label: `是否调整单`, visible: true},
        {key: 16, label: `调整日期`, visible: true},
        {key: 17, label: `原订单编号`, visible: true},
        {key: 18, label: `是否可编辑`, visible: true},
        {key: 19, label: `客户是否开票`, visible: true},
        {key: 20, label: `供应商是否开票`, visible: true},
        {key: 21, label: `备注`, visible: true},
      ],
      //顶部条件搜索
      queryOrderInfo: {},
      //点击查看的弹窗
      checkOrderVisible: false,
      //调整单的弹窗
      handleOrderVisible: false,
      //订单弹窗
      Order1Visible: false,
      //上传和收到条
      handleUploadVisible: false,
      handleCommitVisible: false,
      //添加新订单的弹窗
      addOrderItemVisible: false,
      //开票
      handleOpenTitleDialogVisible: false,
      //查看订单中的列表
      orderDetailInfo: {},

      //添加订单详情
      addOrderItem: {},
      //调整单的id
      tempId: '',
      //订单输入详情信息
      orderInfo: {},
      //上传附件临时保存当前点击订单信息
      tempOrderInfo: {
        receiveProof: ''
      },
      //运费的弹窗
      landFreeDialogVisible: false,
      seaFreeDialogVisible: false,
      //订单详情的
      checkOrderDetailInfoVisible: false,
      orderDetailInfoList: [],
      //运费
      landFreightFree: 0,
      seaFreightFree: 0,
      //订单中的司机相关信息 自动填充响应的收款方账号信息
      driverInfo: {},
      //开票信息
      openTitleInfo: {
        id: null,
        invoiceDate: null,
        invoiceObject: null,
        invoiceAmount: null,
        companyType: null,
        companyName: '',
        companyID: null,
        invoiceCompanyName: null,
        ticketPoint: null,
        ticketPointAmount: null,
        isOrderTax: 0,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
      },
      CheckRules: {
        openTitleRules: {
          invoiceDate: [
            {required: true, message: '请选择开票日期', trigger: 'blur'}
          ],
          invoiceObject: [
            {required: true, message: '请输入开票实体', trigger: 'blur'}
          ],
          invoiceCompanyName: [
            {required: true, message: '请输入票据单位名称', trigger: 'blur'}
          ],
          invoiceAmount: [
            {required: true, message: '请输入开票金额', trigger: 'blur'},
            {pattern: /^[0-9]*$/, message: '只能输入数字', trigger: 'blur'}],
          companyName: [
            {required: true, message: '请输入公司名称', trigger: 'blur'}],
          // 只能是数字
          ticketPoint: [
            {required: true, message: '请输入开票点', trigger: 'blur'},
            {pattern: /^[0-9]*$/, message: '只能输入数字', trigger: 'blur'}
          ],
          ticketPointAmount: [
            {required: true, message: '请输入开票点金额', trigger: 'blur'},
            {pattern: /^[0-9]*$/, message: '只能输入数字', trigger: 'blur'}],
        }
      },
      //当前订单id
      currentOrderId: null,
      queryCompanyName: '',
      //付款申请信息列表 用于判断海运费和陆运费按钮是否可用
      paymentApplyInfoList: [],
      isFreight: '',
      //陆运费信息
      landFreightInfo: {},
      seaFreightInfo: {},

      //上传路径
      uploadFileUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      headers: {
        Authorization: "Bearer " + getToken(),
      },

      //供应商 && 客户开发票
      invoiceOpenVisible: false,
      openTitle: '',
      // 订单申请打款
      tID: '',
      paymentApplyVisible: false,
      needMoney: 0,

      // 文件上传的列表
      fileList: [],

      // 查看原订单
      checkReviousOrderInfoVisible: false,
      previousOrderInfo: {},
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('goodsorder-columns') === 'null'
        || !localStorage.getItem('goodsorder-columns')) {
      //设置localStorage
      localStorage.setItem("goodsorder-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('goodsorder-columns'));
    }
    this.$store.dispatch('order/getOrderList')
  },
  computed: {
    TableName() {
      return TableName
    },
    //获取订单列表
    ...mapGetters(['orderItemList']),
    ...mapGetters(['orderList']),
    //拿到暂存里的订单信息
    ...mapGetters(['currentOrderInfo'])
  },
  //监听开票表单的变化 如果有 就赋值
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("goodsorder-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    // 监听整个开票表单 如果有变化 自动监听计算票点金额
    'openTitleInfo': {
      handler(val) {
        this.openTitleInfo.ticketPointAmount = Number(this.openTitleInfo.invoiceAmount * this.openTitleInfo.ticketPoint).toFixed(2)
      },
      deep: true
    }
  },
  methods: {
    parseTime,
    cancelSubmit() {
      this.orderInfo = {};
      this.addOrderItemVisible = false
      //清空订单详情填写信息
      this.$store.dispatch('order/clearOrderItemList');
      //清空订单列表基础信息
      this.orderInfo = {}
    },
    //时间查询
    handleTimesQuery() {
      //重新赋值
      this.goodsOrderList = this.orderList;
      if (Object.keys(JSON.parse(JSON.stringify(this.paramQuery))).length !== 0) {
        this.goodsOrderList = this.goodsOrderList.filter(obj => {
          let exclude = Object.entries(JSON.parse(JSON.stringify(this.paramQuery))) //填写的参数列表 判断item的某个属性
          return exclude.every((item) => {
            return obj.hasOwnProperty(item[0]) && obj[item[0]] === item[1];
          })
        })
        if (this.timesQuery.beginTime && this.timesQuery.endTime) {
          this.goodsOrderList =
              this.$dateRange(this, 'goodsOrderList', 'orderDate', this.timesQuery.beginTime, this.timesQuery.endTime);
        }
      } else {
        this.goodsOrderList =
            this.$dateRange(this, 'goodsOrderList', 'orderDate', this.timesQuery.beginTime, this.timesQuery.endTime);
      }
    },
    listCompany,
    listBankAccount,
    //子组件提醒父组件修改orderInfo信息
    handleChangeOrderInfo(val) {
      this.orderInfo = val;
    },

    //是或者否
    isOrNot(val) {
      return val === 1 ? "是" : "否";
    },

    //点击查看
    checkOrderItemInfo(row) {
      this.checkOrderVisible = true;
      const id = row.id;
      getGoodsOrder(id).then(res => {
        this.orderDetailInfo = res.data;
      })
    },
    //点击调整单的弹窗
    handleOrderItemInfo(row) {
      this.handleOrderVisible = true
      this.tempId = row.id;
    },
    //查看订单详情列表
    handleCheckOrderDetailInfo(row) {
      //赋值 以便于给子组件id
      sessionStorage.setItem('order_id', row.id)
      //查询该订单的订单详情，根据id查询  然后扔到暂存里
      getGoodsOrder(row.id).then(res => {
        this.orderDetailInfoList = res.data.orderDetailList;
      })
      this.checkOrderDetailInfoVisible = true;
    },
    // 当订单详情组件删除个体后，这里要进行刷新列表操作
    handleUpdateOrderDetailInfoList(order_id) {
      getGoodsOrder(order_id).then(res => {
        this.orderDetailInfoList = res.data.orderDetailList;
      })
    },

    //订单发货单
    handleOrder1(row) {
      this.Order1Visible = true
    },
    isPic(url) {
      return this.$imgs.includes(findFileExtension(url))
    },
    handleUpload(row) {
      this.handleUploadVisible = true
      //保存当前订单信息 现根据当前订单列表信息查询详细订单信息
      getGoodsOrder(row.id).then(res => {
        this.tempOrderInfo = res.data;
      })
    },
    handleCommit(row) {
      this.handleCommitVisible = true
      //点击收到条的时候查询当前订单详细信息
      getGoodsOrder(row.id).then(res => {
        this.tempOrderInfo = res.data;
      })
    },
    handleCloseApply() {
      this.paymentApplyVisible = false
      this.getList()
    },
    applyForPayment(row) {
      this.paymentApplyVisible = true;
      this.tID = row.id;
    },
    //查看原订单
    checkPreviousOrder(row) {
      getGoodsOrder(row.adjustOrderid).then(res => {
        this.previousOrderInfo = res.data;
        this.checkReviousOrderInfoVisible = true;
      })
    },

    //提交订单
    //订单列表的对象封装一个，订单详情有两个一样的对象 对应供应商发货和仓库发货
    submitOrder() {
      this.addOrderItemVisible = false
      this.orderInfo.orderDetailList = this.orderItemList; //从vuex拿到订单详细列表 加入到订单信息中
      //订单详情添加客户信息
      for (let i = 0; i < this.orderItemList.length; i++) {
        let item = this.orderItemList[i];
        item.customerID = this.orderInfo.customerID;
        item.customer = this.orderInfo.customer;
        //是否含税
        item.isIncludeTaxFactory = item.isIncludeTaxFactory === '是' ? '1' : '0';
        item.isIncludeTaxSale = item.isIncludeTaxSale === '是' ? '1' : '0';
      }
      addGoodsOrder({...this.orderInfo, PaymentState: ''}).then(res => {
        this.$message.success('订单提交成功')
      })
    },
    //查看附件信息
    checkAttachment(path) {
      window.open(path)
    },
    //删除收到条
    //todo 删除
    deleteReceiveProof(row) {
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        getGoodsOrder(row.id)
            .then(res => {
              let order = res.data;
              order.receiveProof = null;
              updateGoodsOrder(excludeParams(order, this.$exclude))
                  .then(res => {
                    this.$message.success('删除成功')
                    this.getList()
                  });
            })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    },
    //上传成功
    handleUploadReceiveProofSuccess(response, file, fileList) {
      if (response.code === 200) {
        //去除不必要字段
        this.tempOrderInfo = excludeParams(this.tempOrderInfo, this.$exclude)
        //修改订单信息
        updateGoodsOrder({...this.tempOrderInfo, receiveProof: response.url})
            .then(res => {
              this.$message.success('上传成功')
            })
      } else {
        this.$message.error('上传失败')
      }
      // fileList.pop();
    },
    // 上传文件的文件列表
    handleChange(file, fileList) {
      console.log('file', file);
      console.log('fileList', fileList)
    },
    //订单审核
    handleCheck(row) {
      console.log(row)
      //弹出确认和取消
      this.$confirm('是否审核该信息?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        //修改审核状态
        auditGoodsOrder({id: row.id, isaudit: true})
            .then(res => {
              this.$message({
                type: 'success',
                message: '操作成功~!'
              });
              this.getList()
            })
      })
    },
    handleUploadPathSuccess(response, file, fileList) {
      if (response.code === 200) {
        //去除不必要字段
        this.tempOrderInfo = excludeParams(this.tempOrderInfo, this.$exclude)
        //修改订单信息
        updateGoodsOrder({...this.tempOrderInfo, path: response.url})
            .then(res => {
              this.$message.success('上传成功')
            })
      } else {
        this.$message.error('上传失败')
      }
      fileList.pop();
    },
    //表格统计
    //自定义列统计总函数
    getSummaries(param) {
      const {columns, data} = param;
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '统计';
          return;
        }
        const values = data.map(item => {
          return Number(item[column.property])
        });
        if (!values.every(value => isNaN(value))) {
          //对指定列进行计算
          // if(index)
          //需要进行统计的索引列
          const out_list = [9, 10, 11]
          //index !== 9 && index !== 1 && index !== 16 && index !== 2
          if (out_list.includes(index)) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return prev + curr;
              } else {
                return prev;
              }
            }, 0);
            sums[index] += ' ';
          }
        } else {
          sums[index] = '';
        }
      });
      return sums;
    },

    //客户供应商开票功能
    //添加开票 是否订单开票要给订单id
    submitOpenTitle() {
      //排除不必要的字段
      this.openTitleInfo = excludeParams(this.openTitleInfo, this.$exclude)
      //这里要判断一下 如果是客户开票 就添加发票卖出信息 如果是供应商开票 则添加发票买入信息
      if (this.openTitleInfo.domain === 1) {
        //修改开票信息
        let info = {...this.openTitleInfo.orderInfo, customerIsInvoice: 1}
        updateGoodsOrder(excludeParams(info, this.$exclude))
            .then(res => {
              this.$message.success('开票状态设置成功~')
              //删除订单信息
              delete this.openTitleInfo.orderInfo
              //客户开票 添加发票卖出信息
              addInvoiceOut(this.openTitleInfo)
                  .then(res => {
                    this.$message.success('客户开票成功~')
                    this.openTitleInfo = {}
                    this.invoiceOpenVisible = false
                    this.getList()
                  })
            })
        //添加发票买入
      } else {
        let info = {...this.openTitleInfo.orderInfo, isSupplierInvoice: 1}
        updateGoodsOrder(excludeParams(info, this.$exclude))
            .then(res => {
              this.$message.success('开票状态设置成功~')
              //删除订单信息
              delete this.openTitleInfo.orderInfo
              //客户开票 添加发票卖出信息
              addInvoiceIn(this.openTitleInfo)
                  .then(res => {
                    this.$message.success('供应商开票成功~')
                    this.openTitleInfo = {}
                    this.invoiceOpenVisible = false
                    this.getList()
                  })
            })
      }
    },
    //开票信息弹窗
    handleUpdateCompanyName(val) {
      console.log(val)
      this.queryCompanyName = val;
    },
    handleCommitBackCompany(val) {
      console.log(val)
      this.openTitleInfo.companyName = val.companyName;
      this.openTitleInfo.companyID = val.id;
      this.openTitleInfo.companyType = val.companyType;
    },
    //客户开票 && 供应商开票
    openCustomerInvoice(row) {
      //客户开发票 即为发票卖出 添加发票卖出信息 1客户开票  2供应商开票
      this.openTitleInfo.domain = 1
      this.openTitleInfo.isOrderTax = row.id;
      //设置该订单信息 需要进行一次查询
      getGoodsOrder(row.id)
          .then(res => {
            this.openTitleInfo.orderInfo = res.data;
          })
      this.invoiceOpenVisible = true;
    },
    openSupplierInvoice(row) {
      this.openTitleInfo.domain = 2
      this.openTitleInfo.isOrderTax = row.id;
      getGoodsOrder(row.id)
          .then(res => {
            this.openTitleInfo.orderInfo = res.data;
          })
      this.invoiceOpenVisible = true;
    },
    //申请陆运费
    handleApplyLandFree(row) {
      //组装订单运费信息 己方银行卡信息弹窗自己选
      this.landFreightInfo = {
        ordersNo: row.ordersNo,
        freightType: '陆运',
        moneyAmount: row.landFreight,
        otherAcountsName: row.landDriverName,
        otherBankNo: row.landBankNo,
        otherBankName: row.landBankName,
        paymentState: '申请中',
        driverName: row.landDriverName,
        driverId: row.landCarID,
        carNo: row.landCarNo,
        fleet: row.fleet,
      }
      //首先去运费表查看是否有运费信息
      listOrderFreight({...this.landFreightInfo, paymentState: '未支付'}).then(res => {
        if (res.rows.length === 0) {
          // this.keyFlag += 1 //让dialog组件重新渲染
          this.landFreightFree = row.landFreight
          //组装司机信息
          this.driverInfo = {
            otherAcountsName: row.landDriverName,
            companyName: null,
            isExit: true,//用这个字段来表示有司机信息
          }
          this.landFreeDialogVisible = true;
        } else {
          this.$message.error('该订单已有陆运费信息!!!')
        }
      })
    },
    //申请海运费
    handleApplySeaFree(row) {
      //组装海运费信息
      this.seaFreightInfo = {
        ordersNo: row.ordersNo,
        freightType: '海运',
        moneyAmount: row.seaFreight,
        otherAcountsName: row.seaDriverName,
        otherBankNo: row.seaBankNo,
        otherBankName: row.seaBankName,
        paymentState: '申请中',
        driverName: row.seaDriverName,
        driverId: row.seaCarID,
        carNo: row.seaCarNo,
        fleet: '',
      }
      listOrderFreight({...this.seaFreightInfo, paymentState: '未支付'}).then(res => {
        if (res.rows.length === 0) {
          this.seaFreightFree = row.seaFreight
          this.driverInfo = {
            otherAcountsName: row.seaDriverName,
            companyName: null,
            isExit: true,
          }
          this.seaFreeDialogVisible = true;
        } else {
          this.$message.error('该订单已有运费信息!!!')
        }
      })

    },
    //打印
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询订单列表 */
    getList() {
      this.loading = true;
      listGoodsOrder(this.queryParams).then(response => {
        this.goodsOrderList = response.rows;
        this.total = response.total;
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
      this.orderInfo = {
        id: null,
        ordersNo: null,
        orderDate: null,
        customer: null,
        customerID: null,
        landCarID: null,
        landCarNo: null,
        landDriverTel: null,
        landDriverName: null,
        seaCarID: null,
        seaCarNo: null,
        seaDriverTel: null,
        seaDriverName: null,
        checkUserId: null,
        checkState: null,
        invoiceState: null,
        path: null,
        PaymentState: null,
        landBankName: null,
        landBankNo: null,
        seaBankName: null,
        seaBankNo: null,
        receiveProof: null,
        saleManager: null,
        fleet: null,
        isAdjusted: null,
        adjustDate: null,
        isAdjust: null,
        adjustOrderid: null,
        isedit: null,
        customerIsInvoice: null,
        isSupplierInvoice: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null
      };
      this.resetForm("form");
      //清除vuex的状态
      this.$store.commit('order/CLEAR_ORDER_ITEM_LIST')
      sessionStorage.removeItem('order_id')
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
      //打开新的新增框
      this.addOrderItemVisible = true
    },
    //修改订单的操作
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getGoodsOrder(id).then(response => {
        this.orderInfo = response.data;
        //将数据库拿到的订单列表装入vuex 因为订单添加的货物是从vuex获取的数据 对货物的操作也是操作vuex
        this.$store.commit("order/SET_ORDER_ITEM_LIST", response.data.orderDetailList)
        //填充供应商和客户id
        if (response.data.orderDetailList !== null && response.data.orderDetailList !== undefined) {
          for (let i = 0; i < this.orderInfo.orderDetailList.length; i++) {
            let item = this.orderInfo.orderDetailList[i];
            item.customerID = this.orderInfo.customerID;
            item.customer = this.orderInfo.customer;
            //是否含税
            item.isIncludeTaxFactory = item.isIncludeTaxFactory === '是' ? '1' : '0';
            item.isIncludeTaxSale = item.isIncludeTaxSale === '是' ? '1' : '0';
          }
        }
        this.open = true;
        this.title = "修改订单";
      });
    },
    /** 提交按钮 */
    submitForm() {
      if (this.orderInfo.id != null) {
        this.orderInfo = excludeParams(this.orderInfo, this.$exclude)
        updateGoodsOrder(this.orderInfo).then(response => {
          this.$modal.msgSuccess("修改成功");
          this.open = false;
          this.getList();
        });
      }
      //校验 后期再加
      /*this.$refs["form"].validate(valid => {
        if (valid) {

        }
      });*/
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除订单编号为"' + ids + '"的数据项？').then(function () {
        return delGoodsOrder(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      })
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/goodsOrder/export', {
        ...this.queryParams
      }, `goodsOrder_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>


