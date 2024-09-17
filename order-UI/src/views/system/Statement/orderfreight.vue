<!-- todo 运费报表-->
<script>
import {listCompany} from "@/api/system/company";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getOrderFreight} from "@/api/system/statement";

export default {
  name: "orderfreight",
  mixins: [mixin_printHTML],
  data() {
    return {
      queryParams: {
        beginTime: '',
        endTime: ''
      },
      loading: '',
      // todo 测试数据
      companyList: [],
      columns: [
        {key: 0, label: `供应商`, visible: true},
        {key: 1, label: `地址`, visible: true},
        {key: 2, label: `联系人`, visible: true},
        {key: 3, label: `银行卡账号`, visible: true},
        {key: 4, label: `开户名`, visible: true},
        {key: 5, label: `开户行`, visible: true},
        {key: 6, label: `电话`, visible: true},
        {key: 7, label: `备注`, visible: true},
      ],
    }
  },
  methods: {
    // 时间查询
    handleQuery() {

    },
    refresh() {

    },
    getList() {
      this.loading = true;
      listCompany(this.queryParams).then(response => {
        this.companyList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    handleExport() {
      this.download('system/company/export', {
        ...this.queryParams
      }, `company_${new Date().getTime()}.xlsx`)
    }
  },
  created() {
    this.getList()
    getOrderFreight().then(res => {
      console.log(res)
    })
  },
}
</script>

<template>
  <div>
    <!--    刷新行-->
    <el-row style="background-color:#e6e6e6;">
      <el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
    </el-row>
    <hr color="#e6e6e6"/>
    <!--    时间范围搜索行-->
    <el-row>
      <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" label-width="100px">
        <el-form-item label="时间" prop="companyName">
          <el-date-picker
            v-model="queryParams.beginTime"
            type="date"
            size="mini"
            value-format="yyyy-MM-dd"
            placeholder="选择日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker
            v-model="queryParams.endTime"
            type="date"
            size="mini"
            value-format="yyyy-MM-dd"
            placeholder="选择日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        </el-form-item>
      </el-form>
    </el-row>
    <hr color="#e6e6e6"/>
    <el-row>
      <el-row style="font-weight: bold;font-size: 20px;margin: 0 30px">
        运费报表
      </el-row>
      <el-row>
        <right-toolbar @queryTable="getList" :columns="columns">
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
                v-hasPermi="['system:supplier:export']"
              >
              </el-button>
            </el-col>
          </template>
        </right-toolbar>
        <el-table border v-loading="loading" :data="companyList"
                  height="450px" v-horizontal-scroll="'always'" size="mini">
          <el-table-column label="id" align="center" prop="id"/>
          <el-table-column label="供应商" align="center" prop="companyName" v-if="columns[0].visible" width="200"/>
          <el-table-column label="地址" align="center" prop="address" v-if="columns[1].visible" width="200"/>
          <el-table-column label="联系人" align="center" prop="relationName" v-if="columns[2].visible" width="200"/>
          <el-table-column label="银行卡账号" align="center" prop="bankNo" v-if="columns[3].visible" width="200"/>
          <el-table-column label="老板电话" align="center" prop="leaderTel" v-if="columns[3].visible" width="200"/>
          <el-table-column label="开户名" align="center" prop="acountsName" v-if="columns[4].visible" width="200"/>
          <el-table-column label="开户行" align="center" prop="bankName" v-if="columns[5].visible" width="200"/>
          <el-table-column label="电话" align="center" prop="relationTel" v-if="columns[6].visible" width="200"/>
          <el-table-column label="备注" align="center" prop="comments" v-if="columns[7].visible" width="200"/>
        </el-table>
      </el-row>
    </el-row>
  </div>
</template>

<style scoped lang="scss">

</style>
