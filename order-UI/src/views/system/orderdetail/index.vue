<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="订单编号" prop="ordersNo">
        <el-input
          v-model="queryParams.ordersNo"
          placeholder="请输入订单编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="订单日期" prop="orderDate">
        <el-input
          v-model="queryParams.orderDate"
          placeholder="请输入订单日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="供应商" prop="supplier">
        <el-input
          v-model="queryParams.supplier"
          placeholder="请输入供应商"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="供应商ID" prop="supplierID">
        <el-input
          v-model="queryParams.supplierID"
          placeholder="请输入供应商ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="客户" prop="customer">
        <el-input
          v-model="queryParams.customer"
          placeholder="请输入客户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="客户ID" prop="customerID">
        <el-input
          v-model="queryParams.customerID"
          placeholder="请输入客户ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="级别编码" prop="levelID">
        <el-input
          v-model="queryParams.levelID"
          placeholder="请输入级别编码"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="级别名称" prop="levelName">
        <el-input
          v-model="queryParams.levelName"
          placeholder="请输入级别名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="计量单位" prop="countingUnit">
        <el-input
          v-model="queryParams.countingUnit"
          placeholder="请输入计量单位"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="厚度" prop="height">
        <el-input
          v-model="queryParams.height"
          placeholder="请输入厚度"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="长度" prop="length">
        <el-input
          v-model="queryParams.length"
          placeholder="请输入长度"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="宽度" prop="width">
        <el-input
          v-model="queryParams.width"
          placeholder="请输入宽度"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="出厂片数" prop="pieces">
        <el-input
          v-model="queryParams.pieces"
          placeholder="请输入出厂片数"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="每包片数" prop="piecesPerPack">
        <el-input
          v-model="queryParams.piecesPerPack"
          placeholder="请输入每包片数"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="包数" prop="packs">
        <el-input
          v-model="queryParams.packs"
          placeholder="请输入包数"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="出厂单价" prop="price">
        <el-input
          v-model="queryParams.price"
          placeholder="请输入出厂单价"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="出厂是否含税" prop="isIncludeTaxFactory">
        <el-input
          v-model="queryParams.isIncludeTaxFactory"
          placeholder="请输入出厂是否含税"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="杂费" prop="sundryCost">
        <el-input
          v-model="queryParams.sundryCost"
          placeholder="请输入杂费"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="出厂货款" prop="paymentFactory">
        <el-input
          v-model="queryParams.paymentFactory"
          placeholder="请输入出厂货款"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="卸货价" prop="paymentUnload">
        <el-input
          v-model="queryParams.paymentUnload"
          placeholder="请输入卸货价"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="销售是否含税" prop="isIncludeTaxSale">
        <el-input
          v-model="queryParams.isIncludeTaxSale"
          placeholder="请输入销售是否含税"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="总货款" prop="payments">
        <el-input
          v-model="queryParams.payments"
          placeholder="请输入总货款"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="误差" prop="erro">
        <el-input
          v-model="queryParams.erro"
          placeholder="请输入误差"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="吨位" prop="tonnage">
        <el-input
          v-model="queryParams.tonnage"
          placeholder="请输入吨位"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆运费单价" prop="landFreightPrice">
        <el-input
          v-model="queryParams.landFreightPrice"
          placeholder="请输入陆运费单价"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆运费" prop="landFreight">
        <el-input
          v-model="queryParams.landFreight"
          placeholder="请输入陆运费"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="海运费" prop="seaFreight">
        <el-input
          v-model="queryParams.seaFreight"
          placeholder="请输入海运费"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="总运费" prop="freight">
        <el-input
          v-model="queryParams.freight"
          placeholder="请输入总运费"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="其他费用" prop="otherCost">
        <el-input
          v-model="queryParams.otherCost"
          placeholder="请输入其他费用"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="利润" prop="profit">
        <el-input
          v-model="queryParams.profit"
          placeholder="请输入利润"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="不含税利润" prop="profitNoTax">
        <el-input
          v-model="queryParams.profitNoTax"
          placeholder="请输入不含税利润"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="实际片数" prop="actualPieces">
        <el-input
          v-model="queryParams.actualPieces"
          placeholder="请输入实际片数"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="总货款杂费" prop="paymentsWithSundry">
        <el-input
          v-model="queryParams.paymentsWithSundry"
          placeholder="请输入总货款杂费"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="加费" prop="additionalFees">
        <el-input
          v-model="queryParams.additionalFees"
          placeholder="请输入加费"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="仓库ID" prop="storeHouseID">
        <el-input
          v-model="queryParams.storeHouseID"
          placeholder="请输入仓库ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="仓库名称" prop="storeHouseName">
        <el-input
          v-model="queryParams.storeHouseName"
          placeholder="请输入仓库名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="仓库存储的货物ID" prop="storeID">
        <el-input
          v-model="queryParams.storeID"
          placeholder="请输入仓库存储的货物ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="物流利润" prop="logisticsProfit">
        <el-input
          v-model="queryParams.logisticsProfit"
          placeholder="请输入物流利润"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="客户佣金" prop="customerCommission">
        <el-input
          v-model="queryParams.customerCommission"
          placeholder="请输入客户佣金"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="是否被调整单" prop="isAdjusted">
        <el-input
          v-model="queryParams.isAdjusted"
          placeholder="请输入是否被调整单"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="调整日期" prop="adjustDate">
        <el-input
          v-model="queryParams.adjustDate"
          placeholder="请输入调整日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="作废标记" prop="cancelFlag">
        <el-input
          v-model="queryParams.cancelFlag"
          placeholder="请输入作废标记"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="备注" prop="comments">
        <el-input
          v-model="queryParams.comments"
          placeholder="请输入备注"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="添加时间" prop="addtime">
        <el-input
          v-model="queryParams.addtime"
          placeholder="请输入添加时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作人员ID" prop="userId">
        <el-input
          v-model="queryParams.userId"
          placeholder="请输入操作人员ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作人员姓名" prop="UserName">
        <el-input
          v-model="queryParams.UserName"
          placeholder="请输入操作人员姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:orderDetail:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:orderDetail:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:orderDetail:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:orderDetail:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="orderDetailList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="订单编号" align="center" prop="ordersNo" />
      <el-table-column label="订单日期" align="center" prop="orderDate" />
      <el-table-column label="供应商" align="center" prop="supplier" />
      <el-table-column label="供应商ID" align="center" prop="supplierID" />
      <el-table-column label="客户" align="center" prop="customer" />
      <el-table-column label="客户ID" align="center" prop="customerID" />
      <el-table-column label="级别编码" align="center" prop="levelID" />
      <el-table-column label="级别名称" align="center" prop="levelName" />
      <el-table-column label="计量单位" align="center" prop="countingUnit" />
      <el-table-column label="厚度" align="center" prop="height" />
      <el-table-column label="长度" align="center" prop="length" />
      <el-table-column label="宽度" align="center" prop="width" />
      <el-table-column label="出厂片数" align="center" prop="pieces" />
      <el-table-column label="每包片数" align="center" prop="piecesPerPack" />
      <el-table-column label="包数" align="center" prop="packs" />
      <el-table-column label="出厂单价" align="center" prop="price" />
      <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" />
      <el-table-column label="杂费" align="center" prop="sundryCost" />
      <el-table-column label="出厂货款" align="center" prop="paymentFactory" />
      <el-table-column label="卸货价" align="center" prop="paymentUnload" />
      <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" />
      <el-table-column label="总货款" align="center" prop="payments" />
      <el-table-column label="误差" align="center" prop="erro" />
      <el-table-column label="吨位" align="center" prop="tonnage" />
      <el-table-column label="陆运费单价" align="center" prop="landFreightPrice" />
      <el-table-column label="陆运费" align="center" prop="landFreight" />
      <el-table-column label="海运费" align="center" prop="seaFreight" />
      <el-table-column label="总运费" align="center" prop="freight" />
      <el-table-column label="其他费用" align="center" prop="otherCost" />
      <el-table-column label="利润" align="center" prop="profit" />
      <el-table-column label="不含税利润" align="center" prop="profitNoTax" />
      <el-table-column label="实际片数" align="center" prop="actualPieces" />
      <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" />
      <el-table-column label="加费" align="center" prop="additionalFees" />
      <el-table-column label="仓库ID" align="center" prop="storeHouseID" />
      <el-table-column label="仓库名称" align="center" prop="storeHouseName" />
      <el-table-column label="仓库存储的货物ID" align="center" prop="storeID" />
      <el-table-column label="物流利润" align="center" prop="logisticsProfit" />
      <el-table-column label="客户佣金" align="center" prop="customerCommission" />
      <el-table-column label="是否被调整单" align="center" prop="isAdjusted" />
      <el-table-column label="调整日期" align="center" prop="adjustDate" />
      <el-table-column label="作废标记" align="center" prop="cancelFlag" />
      <el-table-column label="备注" align="center" prop="comments" />
      <el-table-column label="添加时间" align="center" prop="addtime" />
      <el-table-column label="操作人员ID" align="center" prop="userId" />
      <el-table-column label="操作人员姓名" align="center" prop="UserName" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:orderDetail:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:orderDetail:remove']"
          >删除</el-button>
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

    <!-- 添加或修改订单详情对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="订单编号" prop="ordersNo">
          <el-input v-model="form.ordersNo" placeholder="请输入订单编号" />
        </el-form-item>
        <el-form-item label="订单日期" prop="orderDate">
          <el-input v-model="form.orderDate" placeholder="请输入订单日期" />
        </el-form-item>
        <el-form-item label="供应商" prop="supplier">
          <el-input v-model="form.supplier" placeholder="请输入供应商" />
        </el-form-item>
        <el-form-item label="供应商ID" prop="supplierID">
          <el-input v-model="form.supplierID" placeholder="请输入供应商ID" />
        </el-form-item>
        <el-form-item label="客户" prop="customer">
          <el-input v-model="form.customer" placeholder="请输入客户" />
        </el-form-item>
        <el-form-item label="客户ID" prop="customerID">
          <el-input v-model="form.customerID" placeholder="请输入客户ID" />
        </el-form-item>
        <el-form-item label="级别编码" prop="levelID">
          <el-input v-model="form.levelID" placeholder="请输入级别编码" />
        </el-form-item>
        <el-form-item label="级别名称" prop="levelName">
          <el-input v-model="form.levelName" placeholder="请输入级别名称" />
        </el-form-item>
        <el-form-item label="计量单位" prop="countingUnit">
          <el-input v-model="form.countingUnit" placeholder="请输入计量单位" />
        </el-form-item>
        <el-form-item label="厚度" prop="height">
          <el-input v-model="form.height" placeholder="请输入厚度" />
        </el-form-item>
        <el-form-item label="长度" prop="length">
          <el-input v-model="form.length" placeholder="请输入长度" />
        </el-form-item>
        <el-form-item label="宽度" prop="width">
          <el-input v-model="form.width" placeholder="请输入宽度" />
        </el-form-item>
        <el-form-item label="出厂片数" prop="pieces">
          <el-input v-model="form.pieces" placeholder="请输入出厂片数" />
        </el-form-item>
        <el-form-item label="每包片数" prop="piecesPerPack">
          <el-input v-model="form.piecesPerPack" placeholder="请输入每包片数" />
        </el-form-item>
        <el-form-item label="包数" prop="packs">
          <el-input v-model="form.packs" placeholder="请输入包数" />
        </el-form-item>
        <el-form-item label="出厂单价" prop="price">
          <el-input v-model="form.price" placeholder="请输入出厂单价" />
        </el-form-item>
        <el-form-item label="出厂是否含税" prop="isIncludeTaxFactory">
          <el-input v-model="form.isIncludeTaxFactory" placeholder="请输入出厂是否含税" />
        </el-form-item>
        <el-form-item label="杂费" prop="sundryCost">
          <el-input v-model="form.sundryCost" placeholder="请输入杂费" />
        </el-form-item>
        <el-form-item label="出厂货款" prop="paymentFactory">
          <el-input v-model="form.paymentFactory" placeholder="请输入出厂货款" />
        </el-form-item>
        <el-form-item label="卸货价" prop="paymentUnload">
          <el-input v-model="form.paymentUnload" placeholder="请输入卸货价" />
        </el-form-item>
        <el-form-item label="销售是否含税" prop="isIncludeTaxSale">
          <el-input v-model="form.isIncludeTaxSale" placeholder="请输入销售是否含税" />
        </el-form-item>
        <el-form-item label="总货款" prop="payments">
          <el-input v-model="form.payments" placeholder="请输入总货款" />
        </el-form-item>
        <el-form-item label="误差" prop="erro">
          <el-input v-model="form.erro" placeholder="请输入误差" />
        </el-form-item>
        <el-form-item label="吨位" prop="tonnage">
          <el-input v-model="form.tonnage" placeholder="请输入吨位" />
        </el-form-item>
        <el-form-item label="陆运费单价" prop="landFreightPrice">
          <el-input v-model="form.landFreightPrice" placeholder="请输入陆运费单价" />
        </el-form-item>
        <el-form-item label="陆运费" prop="landFreight">
          <el-input v-model="form.landFreight" placeholder="请输入陆运费" />
        </el-form-item>
        <el-form-item label="海运费" prop="seaFreight">
          <el-input v-model="form.seaFreight" placeholder="请输入海运费" />
        </el-form-item>
        <el-form-item label="总运费" prop="freight">
          <el-input v-model="form.freight" placeholder="请输入总运费" />
        </el-form-item>
        <el-form-item label="其他费用" prop="otherCost">
          <el-input v-model="form.otherCost" placeholder="请输入其他费用" />
        </el-form-item>
        <el-form-item label="利润" prop="profit">
          <el-input v-model="form.profit" placeholder="请输入利润" />
        </el-form-item>
        <el-form-item label="不含税利润" prop="profitNoTax">
          <el-input v-model="form.profitNoTax" placeholder="请输入不含税利润" />
        </el-form-item>
        <el-form-item label="实际片数" prop="actualPieces">
          <el-input v-model="form.actualPieces" placeholder="请输入实际片数" />
        </el-form-item>
        <el-form-item label="总货款杂费" prop="paymentsWithSundry">
          <el-input v-model="form.paymentsWithSundry" placeholder="请输入总货款杂费" />
        </el-form-item>
        <el-form-item label="加费" prop="additionalFees">
          <el-input v-model="form.additionalFees" placeholder="请输入加费" />
        </el-form-item>
        <el-form-item label="仓库ID" prop="storeHouseID">
          <el-input v-model="form.storeHouseID" placeholder="请输入仓库ID" />
        </el-form-item>
        <el-form-item label="仓库名称" prop="storeHouseName">
          <el-input v-model="form.storeHouseName" placeholder="请输入仓库名称" />
        </el-form-item>
        <el-form-item label="仓库存储的货物ID" prop="storeID">
          <el-input v-model="form.storeID" placeholder="请输入仓库存储的货物ID" />
        </el-form-item>
        <el-form-item label="物流利润" prop="logisticsProfit">
          <el-input v-model="form.logisticsProfit" placeholder="请输入物流利润" />
        </el-form-item>
        <el-form-item label="客户佣金" prop="customerCommission">
          <el-input v-model="form.customerCommission" placeholder="请输入客户佣金" />
        </el-form-item>
        <el-form-item label="是否被调整单" prop="isAdjusted">
          <el-input v-model="form.isAdjusted" placeholder="请输入是否被调整单" />
        </el-form-item>
        <el-form-item label="调整日期" prop="adjustDate">
          <el-input v-model="form.adjustDate" placeholder="请输入调整日期" />
        </el-form-item>
        <el-form-item label="作废标记" prop="cancelFlag">
          <el-input v-model="form.cancelFlag" placeholder="请输入作废标记" />
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item label="添加时间" prop="addtime">
          <el-input v-model="form.addtime" placeholder="请输入添加时间" />
        </el-form-item>
        <el-form-item label="操作人员ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入操作人员ID" />
        </el-form-item>
        <el-form-item label="操作人员姓名" prop="UserName">
          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listOrderDetail, getOrderDetail, delOrderDetail, addOrderDetail, updateOrderDetail } from "@/api/system/orderDetail";

export default {
  name: "OrderDetail",
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
      // 订单详情表格数据
      orderDetailList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        orderDate: null,
        supplier: null,
        supplierID: null,
        customer: null,
        customerID: null,
        levelID: null,
        levelName: null,
        countingUnit: null,
        height: null,
        length: null,
        width: null,
        pieces: null,
        piecesPerPack: null,
        packs: null,
        price: null,
        isIncludeTaxFactory: null,
        sundryCost: null,
        paymentFactory: null,
        paymentUnload: null,
        isIncludeTaxSale: null,
        payments: null,
        erro: null,
        tonnage: null,
        landFreightPrice: null,
        landFreight: null,
        seaFreight: null,
        freight: null,
        otherCost: null,
        profit: null,
        profitNoTax: null,
        actualPieces: null,
        paymentsWithSundry: null,
        additionalFees: null,
        storeHouseID: null,
        storeHouseName: null,
        storeID: null,
        logisticsProfit: null,
        customerCommission: null,
        isAdjusted: null,
        adjustDate: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询订单详情列表 */
    getList() {
      this.loading = true;
      listOrderDetail(this.queryParams).then(response => {
        this.orderDetailList = response.rows;
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
      this.form = {
        id: null,
        ordersNo: null,
        orderDate: null,
        supplier: null,
        supplierID: null,
        customer: null,
        customerID: null,
        levelID: null,
        levelName: null,
        countingUnit: null,
        height: null,
        length: null,
        width: null,
        pieces: null,
        piecesPerPack: null,
        packs: null,
        price: null,
        isIncludeTaxFactory: null,
        sundryCost: null,
        paymentFactory: null,
        paymentUnload: null,
        isIncludeTaxSale: null,
        payments: null,
        erro: null,
        tonnage: null,
        landFreightPrice: null,
        landFreight: null,
        seaFreight: null,
        freight: null,
        otherCost: null,
        profit: null,
        profitNoTax: null,
        actualPieces: null,
        paymentsWithSundry: null,
        additionalFees: null,
        storeHouseID: null,
        storeHouseName: null,
        storeID: null,
        logisticsProfit: null,
        customerCommission: null,
        isAdjusted: null,
        adjustDate: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null
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
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加订单详情";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getOrderDetail(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改订单详情";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateOrderDetail(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOrderDetail(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除订单详情编号为"' + ids + '"的数据项？').then(function() {
        return delOrderDetail(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/orderDetail/export', {
        ...this.queryParams
      }, `orderDetail_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
