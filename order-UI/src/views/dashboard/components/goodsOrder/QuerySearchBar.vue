<template>
  <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="70px">
    <el-row>
      <el-col :span="6">
        <el-form-item label="开始时间" prop="beginTime">
          <el-date-picker
            v-model="queryParams.orderDateStart"
            type="datetime"
            placeholder="选择时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            size="mini"
          >
          </el-date-picker>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker
            v-model="queryParams.orderDateEnd"
            type="datetime"
            placeholder="选择时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            size="mini"
          >
          </el-date-picker>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="客户名称" prop="customer">
          <el-input
            v-model="queryParams.customer"
            placeholder="请输入客户名称"
            clearable
            @keyup.enter.native="handleQuery"
            size="mini"
          >
          </el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="司机名称" prop="landDriverName">
          <el-input
            v-model="queryParams.landDriverName"
            placeholder="请输入司机名称"
            clearable
            @keyup.enter.native="handleQuery"
            size="mini"
          >
          </el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="海运公司" prop="seaDriverName">
          <el-input
            v-model="queryParams.seaDriverName"
            placeholder="请输入海运公司"
            clearable
            @keyup.enter.native="handleQuery"
            size="mini"
          >
          </el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="车队名称" prop="fleet">
          <el-input
            v-model="queryParams.fleet"
            placeholder="请输入车队名称"
            clearable
            @keyup.enter.native="handleQuery"
            size="mini"
          >
          </el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="审核状态" prop="checkState">
          <el-select
            v-model="queryParams.checkState"
            placeholder="请选择"
            size="mini"
            clearable
          >
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="开票状态" prop="invoiceState">
          <el-select
            v-model="queryParams.invoiceState"
            placeholder="请选择"
            size="mini"
          >
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
</template>
<script>
export default {
  name: 'QuerySearchBar',
  props: {
    handleQuery: {},
    options: {},
    optionsInvoice: {},
    queryParams: {},
    showSearch: {}
  }
}
</script>
