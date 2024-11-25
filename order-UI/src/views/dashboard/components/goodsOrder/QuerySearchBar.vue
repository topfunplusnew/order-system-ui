<template>
  <div>
    <el-form ref="queryForm" :model="queryItems" size="mini" :inline="true" label-width="70px">
      <el-row>
        <el-col :span="6">
          <el-form-item label="开始时间" prop="beginTime">
            <el-date-picker
              v-model="queryItems.orderDateStart"
              type="datetime"
              placeholder="选择时间"
              value-format="yyyy-MM-dd HH:mm:ss"
              size="mini"
            ></el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="结束时间" prop="endTime">
            <el-date-picker
              v-model="queryItems.orderDateEnd"
              type="datetime"
              placeholder="选择时间"
              value-format="yyyy-MM-dd HH:mm:ss"
              size="mini"
            ></el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="客户名称" prop="customer">
            <el-input
              v-model="queryItems.customer"
              placeholder="请输入客户名称"
              clearable
              size="mini"
              @keyup.enter.native="handleQuery"
            ></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="司机名称" prop="landDriverName">
            <el-input
              v-model="queryItems.landDriverName"
              placeholder="请输入司机名称"
              clearable
              size="mini"
              @keyup.enter.native="handleQuery"
            ></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="海运公司" prop="seaDriverName">
            <el-input
              v-model="queryItems.seaDriverName"
              placeholder="请输入海运公司"
              clearable
              size="mini"
              @keyup.enter.native="handleQuery"
            ></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="车队名称" prop="fleet">
            <el-input
              v-model="queryItems.fleet"
              placeholder="请输入车队名称"
              clearable
              size="mini"
              @keyup.enter.native="handleQuery"
            ></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="审核状态" prop="checkState">
            <el-select v-model="queryItems.checkState" placeholder="请选择" size="mini" clearable>
              <el-option
                v-for="item in options"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              ></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="开票状态" prop="invoiceState">
            <el-select v-model="queryItems.invoiceState" placeholder="请选择" size="mini">
              <el-option
                v-for="item in optionInvent"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              ></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">
              搜索
            </el-button>
          </el-form-item>
        </el-col>
        <!-- <el-col :span="4">
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleProcess">
              点击增加{{ count }}
            </el-button>
          </el-form-item>
        </el-col> -->
      </el-row>
    </el-form>
  </div>
</template>
<script>
  import { computed, ref } from '@vue/composition-api'
  import { OptionInvent, Options } from '../../mixins/order/order_Invoice'

  export default {
    name: 'QuerySearchBar',
    props: {
      queryParams: {
        type: Object,
        default: () => ({})
      }
    },
    setup(props, { emit }) {
      // 数据状态
      const optionInvent = ref(OptionInvent)
      const options = ref(Options)
      const testValue = ref(0)

      // 计算属性
      const queryItems = computed({
        get: () => props.queryParams,
        set: (val) => emit('updateQuery', val)
      })

      const handleQuery = () => {
        emit('updateQuery', queryItems.value)
      }

      // // TODO 测试hooks
      // const { count, handleProcess } = useCounter()

      // 返回 setup 中定义的数据和方法
      return {
        optionInvent,
        options,
        queryItems,
        testValue,
        // count,
        // handleProcess,
        handleQuery
      }
    },
    mounted() {},
    methods: {}
  }
</script>
